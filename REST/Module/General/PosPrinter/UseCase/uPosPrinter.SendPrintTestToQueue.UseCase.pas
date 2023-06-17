unit uPosPrinter.SendPrintTestToQueue.UseCase;

interface

uses
  uPosPrinter.Repository.Interfaces;

type
  IPosPrinterSendPrintTestToQueueUseCase = Interface
    ['{63F30B4C-04F5-45B8-BF64-0C24488E7123}']
    function Execute(AId: Int64; LContent: String = ''): IPosPrinterSendPrintTestToQueueUseCase;
  End;

  TPosPrinterSendPrintTestToQueueUseCase = class(TInterfacedObject, IPosPrinterSendPrintTestToQueueUseCase)
  private
    FRepository: IPosPrinterRepository;
    constructor Create(ARepository: IPosPrinterRepository);
  public
    class function Make(ARepository: IPosPrinterRepository): IPosPrinterSendPrintTestToQueueUseCase;
    function Execute(AId: Int64; LContent: String = ''): IPosPrinterSendPrintTestToQueueUseCase;
  end;

implementation

{ TPosPrinterSendPrintTestToQueueUseCase }

uses
  uPosPrinter,
  uSmartPointer,
  uTrans,
  System.SysUtils,
  System.Classes,
  uCache;

constructor TPosPrinterSendPrintTestToQueueUseCase.Create(ARepository: IPosPrinterRepository);
begin
  inherited Create;
  FRepository := ARepository;
end;

function TPosPrinterSendPrintTestToQueueUseCase.Execute(AId: Int64; LContent: String): IPosPrinterSendPrintTestToQueueUseCase;
begin
  Result := Self;

  // Localizar Impressora POS para obter a quantidade de colunas
  const LPosPrinter: SH<TPosPrinter> = FRepository.Show(AId);
  if not Assigned(LPosPrinter.Value) then
    raise Exception.Create(Trans.RecordNotFoundWithId(AId.ToString));
  const LColumns = LPosPrinter.Value.columns;

  // Conte˙do para Impress„o POS
  const LStrListContent = TStringList.Create;
  With LStrListContent do
  begin
    Add('INICIO');
    Add('123 testando... ' + LColumns.ToString);
    Add('Testando caracteres especiais... ' + LColumns.ToString);
    Add('·‡„‚‰Á ' + LColumns.ToString);
    Add('Testando pulo de linha... ' + LColumns.ToString);
    Add(' ');
    Add(' ###BODY ' + LColumns.ToString);
    Add(LContent);
    Add(' BODY### ' + LColumns.ToString);
    Add(' ');
    Add('FIM');
  end;

  // Adicionar em Fila (Cache) para impress„o
  Cache.PushPosPrinterContent(AId, LStrListContent);
end;

class function TPosPrinterSendPrintTestToQueueUseCase.Make(ARepository: IPosPrinterRepository): IPosPrinterSendPrintTestToQueueUseCase;
begin
  Result := Self.Create(ARepository);
end;

end.
