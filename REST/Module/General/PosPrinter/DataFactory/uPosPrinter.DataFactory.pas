unit uPosPrinter.DataFactory;

interface

uses
  uBase.DataFactory,
  uPosPrinter.Show.DTO,
  uPosPrinter.Input.DTO,
  uPosPrinter.Persistence.UseCase.Interfaces,
  uPosPrinter.Persistence.UseCase;

type
  IPosPrinterDataFactory = Interface
    ['{4C7C6F7D-80DD-42C7-A3FB-ED2594C13101}']
    function GenerateInsert: TPosPrinterShowDTO;
    function GenerateInput: TPosPrinterInputDTO;
  End;

  TPosPrinterDataFactory = class(TBaseDataFactory, IPosPrinterDataFactory)
  private
    FPersistence: IPosPrinterPersistenceUseCase;
    constructor Create(APersistenceUseCase: IPosPrinterPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IPosPrinterPersistenceUseCase = nil): IPosPrinterDataFactory;
    function GenerateInsert: TPosPrinterShowDTO;
    function GenerateInput: TPosPrinterInputDTO;
  end;

implementation

{ TPosPrinterDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection,
  uPosPrinter.Types;

constructor TPosPrinterDataFactory.Create(APersistenceUseCase: IPosPrinterPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TPosPrinterPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).PosPrinter);
end;

function TPosPrinterDataFactory.GenerateInput: TPosPrinterInputDTO;
begin
  Result := TPosPrinterInputDTO.Create;
  With Result do
  begin
    name                         := TFaker.Text(30);
    model                        := TPosPrinterModel(Round(14));
    port                         := 'PDF Printer';
    columns                      := 48;
    space_between_lines          := 40;
    buffer                       := 0;
    font_size                    := 0;
    blank_lines_to_end           := 4;
    flg_port_control             := 1;
    flg_translate_tags           := 1;
    flg_ignore_tags              := 0;
    flg_paper_cut                := 1;
    flg_partial_paper_cut        := 1;
    flg_send_cut_written_command := 1;
    page_code                    := TPosPrinterPageCode(Round(6));
    acl_user_id                  := 1;
  end;
end;

function TPosPrinterDataFactory.GenerateInsert: TPosPrinterShowDTO;
begin
  const LInput: SH<TPosPrinterInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TPosPrinterDataFactory.Make(APersistenceUseCase: IPosPrinterPersistenceUseCase): IPosPrinterDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
