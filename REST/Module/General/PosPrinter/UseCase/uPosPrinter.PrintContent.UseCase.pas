unit uPosPrinter.PrintContent.UseCase;

interface

uses
  uPosPrinter.Repository.Interfaces,
  System.Classes,
  uPosPrinter.Lib.Interfaces,
  uPosPrinterContent,
  System.Generics.Collections,
  uZLMemTable.Interfaces;

type
  IPosPrinterPrintContentUseCase = Interface
    ['{4B839CA3-3840-4CD0-8CB6-71A1916A4E2B}']
    function Execute(APosPrinterContentList: TObjectList<TPosPrinterContent>): IPosPrinterPrintContentUseCase;
  End;

  TPosPrinterPrintContentUseCase = class(TInterfacedObject, IPosPrinterPrintContentUseCase)
  private
    FRepository: IPosPrinterRepository;
    FPosPrinters: IZLMemTable;
    FWorkList: TObjectList<TPosPrinterContent>;
    FSourceList: TObjectList<TPosPrinterContent>;
    FPosLib: IPosPrinterLib;
    FWork: TPosPrinterContent;
    procedure ListPosPrinters;
    procedure CreateWorkList;
    procedure ReadWorkList;
    function  SetPosConfiguration: Boolean;
    procedure PrintWorkContent;
    function  RemoveFromSourceList(AUUID: String): Boolean;
    procedure TryPrintingNextTime(AWork: TPosPrinterContent; AExceptionError: String);
    function  FindInSourceList(AUUID: String; AReturnIndex: Boolean): Integer; overload;
    function  FindInSourceList(AUUID: String): TPosPrinterContent; overload;
    constructor Create(ARepository: IPosPrinterRepository);
    destructor  Destroy; override;
  public
    class function Make(ARepository: IPosPrinterRepository): IPosPrinterPrintContentUseCase;
    function Execute(APosPrinterContentList: TObjectList<TPosPrinterContent>): IPosPrinterPrintContentUseCase;
  end;

implementation

{ TPosPrinterPrintContentUseCase }

uses
  uSmartPointer,
  uTrans,
  System.SysUtils,
  uPosPrinter,
  uPosPrinter.Lib.Factory,
  uPosPrinter.Lib.Types;

const
  MAX_RETRIES_TO_PRINT = 3;

class function TPosPrinterPrintContentUseCase.Make(ARepository: IPosPrinterRepository): IPosPrinterPrintContentUseCase;
begin
  Result := Self.Create(ARepository);
end;

constructor TPosPrinterPrintContentUseCase.Create(ARepository: IPosPrinterRepository);
begin
  inherited Create;
  FRepository := ARepository;
  FWorkList   := TObjectList<TPosPrinterContent>.Create;
end;

function TPosPrinterPrintContentUseCase.Execute(APosPrinterContentList: TObjectList<TPosPrinterContent>): IPosPrinterPrintContentUseCase;
begin
  Result      := Self;
  FSourceList := APosPrinterContentList;

  ListPosPrinters; {Listar Impressoras POS}
  CreateWorkList;  {Clonar Lista p/ evitar problemas de concorrência}
  ReadWorkList;    {Ler Lista clonada}
end;

procedure TPosPrinterPrintContentUseCase.ListPosPrinters;
begin
  FPosPrinters := FRepository.Index(nil).Data;
  if FPosPrinters.IsEmpty then
    raise Exception.Create('Nenhuma impressora POS cadastrada.');
end;

procedure TPosPrinterPrintContentUseCase.CreateWorkList;
begin
  FWorkList.Clear;
  for var LCurrent in FSourceList do
    FWorkList.Add(LCurrent.Clone);
end;

procedure TPosPrinterPrintContentUseCase.ReadWorkList;
begin
  for var LI := Pred(FWorkList.Count) downto 0 do
  begin
    FWork := FWorkList.Items[LI];
    if not SetPosConfiguration then
      Continue;

    PrintWorkContent;
  end;
end;

function TPosPrinterPrintContentUseCase.SetPosConfiguration: Boolean;
begin
  // Localizar Impressora POS para configuração
  FPosPrinters.First;
  if not FPosPrinters.Locate('id', FWork.PosPrinterId) then
    Exit;

  // Verificar existência da impressora em Painel de Controle
  FPosLib := TPosPrinterLibFactory.Make;
  const LSystemPrinters: SH<TStringList> = TStringList.Create;
  FPosLib.LoadPorts(LSystemPrinters);
  var LFound := False;
  for var LI := 0 to Pred(LSystemPrinters.Value.Count) do
  begin
    if (Pos(FPosPrinters.FieldByName('port').AsString.Trim.ToLower, LSystemPrinters.Value[LI].Trim.ToLower) > 0) then
    begin
      LFound := True;
      Break;
    end;
  end;
  if not LFound then
    Exit;

  // Configurar Componente de Impressão
  With FPosLib.Param do
  begin
    model                        := TPosPrinterLibParamModel(Ord(FPosPrinters.FieldByName('model').AsInteger));
    port                         := FPosPrinters.FieldByName('port').AsString;
    columns                      := FPosPrinters.FieldByName('columns').AsInteger;
    space_between_lines          := FPosPrinters.FieldByName('space_between_lines').AsInteger;
    buffer                       := FPosPrinters.FieldByName('buffer').AsInteger;
    font_size                    := FPosPrinters.FieldByName('font_size').AsInteger;
    blank_lines_to_end           := FPosPrinters.FieldByName('blank_lines_to_end').AsInteger;
    flg_port_control             := FPosPrinters.FieldByName('flg_port_control').AsInteger = 1;
    flg_translate_tags           := FPosPrinters.FieldByName('flg_translate_tags').AsInteger = 1;
    flg_ignore_tags              := FPosPrinters.FieldByName('flg_ignore_tags').AsInteger = 1;
    flg_paper_cut                := FPosPrinters.FieldByName('flg_paper_cut').AsInteger = 1;
    flg_partial_paper_cut        := FPosPrinters.FieldByName('flg_partial_paper_cut').AsInteger = 1;
    flg_send_cut_written_command := FPosPrinters.FieldByName('flg_send_cut_written_command').AsInteger = 1;
    is_open_cash_drawer          := False;
    page_code                    := TPosPrinterLibParamPageCode(Ord(FPosPrinters.FieldByName('page_code').AsInteger));
  end;

  Result := True;
end;

procedure TPosPrinterPrintContentUseCase.PrintWorkContent;
begin
  try
    FPosLib.PrintContent(FWork.Content, FWork.Copies); {Imprimir Conteúdo}
    RemoveFromSourceList(FWork.UUID);                  {Remover da Lista}
  except on E: Exception do
    TryPrintingNextTime(FWork, E.Message); {Tenta Imprimir "X" vezes}
  end;
end;

function TPosPrinterPrintContentUseCase.RemoveFromSourceList(AUUID: String): Boolean;
begin
  for var LJ := Pred(FSourceList.Count) downto 0 do
  begin
    if (AUUID = FSourceList.Items[LJ].UUID) then
    begin
      FSourceList.Delete(LJ);
      Result := True;
      Break;
    end;
  end;
end;

procedure TPosPrinterPrintContentUseCase.TryPrintingNextTime(AWork: TPosPrinterContent; AExceptionError: String);
begin
  // Localizar Conteúdo em Lista Principal
  const LFound = FindInSourceList(AWork.UUID);
  if not Assigned(LFound) then
    Exit;

  // "X" Tentativas
  LFound.Retries := LFound.Retries + 1;
  if (LFound.Retries < MAX_RETRIES_TO_PRINT) then
    Exit;

  // Ultrapassou "X" limite de tentativas
  RemoveFromSourceList(LFound.UUID);
  const LError = Format('Falhou na 3º tenantiva de impressão. Mensagem Tecnica: %s; PosPrinterID: %s; Nome: %s; Modelo: %s; Porta: %s', [
    AExceptionError,
    FPosPrinters.FieldByName('id').AsString,
    FPosPrinters.FieldByName('name').AsString,
    FPosPrinters.FieldByName('model').AsString,
    FPosPrinters.FieldByName('port').AsString
  ]);
  raise Exception.Create(LError);
end;

function TPosPrinterPrintContentUseCase.FindInSourceList(AUUID: String): TPosPrinterContent;
begin
  Result := Nil;
  const LFoundIndex = FindInSourceList(AUUID, True);
  if (LFoundIndex < 0) then
    Exit;

  Result := FSourceList.Items[LFoundIndex];
end;

function TPosPrinterPrintContentUseCase.FindInSourceList(AUUID: String; AReturnIndex: Boolean): Integer;
begin
  Result := -1;

  for var LI := Pred(FSourceList.Count) downto 0 do
  begin
    if AUUID = FSourceList.Items[LI].UUID then
    begin
      Result := LI;
      Break;
    end;
  end;
end;

destructor TPosPrinterPrintContentUseCase.Destroy;
begin
  if Assigned(FWorkList) then FWorkList.Free;
  inherited;
end;

end.
