unit uBank.DataFactory;

interface

uses
  uBase.DataFactory,
  uBank.Show.DTO,
  uBank.Input.DTO,
  uBank.Persistence.UseCase.Interfaces,
  uBank.Persistence.UseCase;

type
  IBankDataFactory = Interface
    ['{550882D4-99E3-4F34-9B7C-577E84955341}']
    function GenerateInsert: TBankShowDTO;
    function GenerateInput: TBankInputDTO;
  End;

  TBankDataFactory = class(TBaseDataFactory, IBankDataFactory)
  private
    FPersistence: IBankPersistenceUseCase;
    constructor Create(APersistenceUseCase: IBankPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IBankPersistenceUseCase = nil): IBankDataFactory;
    function GenerateInsert: TBankShowDTO;
    function GenerateInput: TBankInputDTO;
  end;

implementation

{ TBankDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection,
  uBank.Filter,
  uHlp;

constructor TBankDataFactory.Create(APersistenceUseCase: IBankPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TBankPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Bank);
end;

function TBankDataFactory.GenerateInput: TBankInputDTO;
var
  LNextCode: Int64;
begin
  const LIndexResult = FPersistence.Index(TBankFilter.Make.OrderBy('bank.id desc'));
  case (LIndexResult.Data.FieldByName('id').AsInteger < 253) of
    True:  LNextCode := 760;
    False: LNextCode := StrInt(LIndexResult.Data.FieldByName('code').AsString) + 1;
  end;

  Result := TBankInputDTO.Create;
  With Result do
  begin
    name        := TFaker.Text(60);
    code        := StrZero(LNextCode.ToString,3);
    acl_user_id := 1;
  end;
end;

function TBankDataFactory.GenerateInsert: TBankShowDTO;
begin
  const LInput: SH<TBankInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TBankDataFactory.Make(APersistenceUseCase: IBankPersistenceUseCase): IBankDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
