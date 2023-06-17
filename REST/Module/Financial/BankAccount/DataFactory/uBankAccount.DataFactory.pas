unit uBankAccount.DataFactory;

interface

uses
  uBase.DataFactory,
  uBankAccount.Show.DTO,
  uBankAccount.Input.DTO,
  uBankAccount.Persistence.UseCase.Interfaces,
  uBankAccount.Persistence.UseCase;

type
  IBankAccountDataFactory = Interface
    ['{EE8F6C7E-587A-4F71-BE34-A9BCDE6CB45A}']
    function GenerateInsert: TBankAccountShowDTO;
    function GenerateInput: TBankAccountInputDTO;
  End;

  TBankAccountDataFactory = class(TBaseDataFactory, IBankAccountDataFactory)
  private
    FPersistence: IBankAccountPersistenceUseCase;
    constructor Create(APersistenceUseCase: IBankAccountPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IBankAccountPersistenceUseCase = nil): IBankAccountDataFactory;
    function GenerateInsert: TBankAccountShowDTO;
    function GenerateInput: TBankAccountInputDTO;
  end;

implementation

{ TBankAccountDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uBank.Show.DTO,
  uBank.DataFactory,
  uTestConnection;

constructor TBankAccountDataFactory.Create(APersistenceUseCase: IBankAccountPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TBankAccountPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).BankAccount);
end;

function TBankAccountDataFactory.GenerateInput: TBankAccountInputDTO;
begin
  const BankShowDTO: SH<TBankShowDTO> = TBankDataFactory.Make.GenerateInsert;
  Result := TBankAccountInputDTO.Create;
  With Result do
  begin
    name        := TFaker.Text(60);
    bank_id     := BankShowDTO.Value.id;
    note        := TFaker.LoremIpsum;
    acl_user_id := 1;
  end;
end;

function TBankAccountDataFactory.GenerateInsert: TBankAccountShowDTO;
begin
  const LInput: SH<TBankAccountInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TBankAccountDataFactory.Make(APersistenceUseCase: IBankAccountPersistenceUseCase): IBankAccountDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
