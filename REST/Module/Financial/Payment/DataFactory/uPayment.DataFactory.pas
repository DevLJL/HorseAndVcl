unit uPayment.DataFactory;

interface

uses
  uBase.DataFactory,
  uPayment.Show.DTO,
  uPayment.Input.DTO,
  uPayment.Persistence.UseCase.Interfaces,
  uPayment.Persistence.UseCase;

type
  IPaymentDataFactory = Interface
    ['{87DBB5D0-3343-4430-9992-71F61F71A331}']
    function GenerateInsert: TPaymentShowDTO;
    function GenerateInput: TPaymentInputDTO;
  End;

  TPaymentDataFactory = class(TBaseDataFactory, IPaymentDataFactory)
  private
    FPersistence: IPaymentPersistenceUseCase;
    constructor Create(APersistenceUseCase: IPaymentPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IPaymentPersistenceUseCase = nil): IPaymentDataFactory;
    function GenerateInsert: TPaymentShowDTO;
    function GenerateInput: TPaymentInputDTO;
  end;

implementation

{ TPaymentDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uHlp,
  uBankAccount.Show.DTO,
  uBankAccount.DataFactory,
  uPaymentTerm.Input.DTO,
  uTestConnection;

constructor TPaymentDataFactory.Create(APersistenceUseCase: IPaymentPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TPaymentPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Payment);
end;

function TPaymentDataFactory.GenerateInput: TPaymentInputDTO;
begin
  const BankAccountShowDTO: SH<TBankAccountShowDTO> = TBankAccountDataFactory.Make.GenerateInsert;

  // Payment
  Result := TPaymentInputDTO.Create;
  With Result do
  begin
    name                    := TFaker.Payment;
    flg_post_as_received    := Random(1);
    flg_active              := Random(1);
    flg_active_at_pos       := Random(1);
    bank_account_default_id := BankAccountShowDTO.Value.id;
    acl_user_id := 1;
  end;

  // PaymentTerm
  for var lI := 0 to 2 do
  begin
    Result.payment_terms.Add(TPaymentTermInputDTO.Create);
    With Result.payment_terms.Last do
    begin
      description                   := TFaker.Text(60);
      number_of_installments        := Random(12)+1;
      interval_between_installments := 30;
      first_in                      := Random(30);
    end;
  end;
end;

function TPaymentDataFactory.GenerateInsert: TPaymentShowDTO;
begin
  const LInput: SH<TPaymentInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TPaymentDataFactory.Make(APersistenceUseCase: IPaymentPersistenceUseCase): IPaymentDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
