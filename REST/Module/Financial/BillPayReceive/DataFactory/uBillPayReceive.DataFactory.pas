unit uBillPayReceive.DataFactory;

interface

uses
  uBase.DataFactory,
  uBillPayReceive.Show.DTO,
  uBillPayReceive.Input.DTO,
  uBillPayReceive.Persistence.UseCase.Interfaces,
  uBillPayReceive.Persistence.UseCase;

type
  IBillPayReceiveDataFactory = Interface
    ['{134EBA93-56D8-44F3-9B86-67E923614318}']
    function GenerateInsert: TBillPayReceiveShowDTO;
    function GenerateInput: TBillPayReceiveInputDTO;
  End;

  TBillPayReceiveDataFactory = class(TBaseDataFactory, IBillPayReceiveDataFactory)
  private
    FPersistence: IBillPayReceivePersistenceUseCase;
    constructor Create(APersistenceUseCase: IBillPayReceivePersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IBillPayReceivePersistenceUseCase = nil): IBillPayReceiveDataFactory;
    function GenerateInsert: TBillPayReceiveShowDTO;
    function GenerateInput: TBillPayReceiveInputDTO;
  end;

implementation

{ TBillPayReceiveDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uPerson.Show.DTO,
  uPerson.DataFactory,
  uChartOfAccount.Show.DTO,
  uChartOfAccount.DataFactory,
  uCostCenter.Show.DTO,
  uCostCenter.DataFactory,
  uBankAccount.Show.DTO,
  uBankAccount.DataFactory,
  uPayment.Show.DTO,
  uPayment.DataFactory,
  uBillPayReceive.Types,
  uTestConnection;

constructor TBillPayReceiveDataFactory.Create(APersistenceUseCase: IBillPayReceivePersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TBillPayReceivePersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).BillPayReceive);
end;

function TBillPayReceiveDataFactory.GenerateInput: TBillPayReceiveInputDTO;
begin
  const PersonShowDTO: SH<TPersonShowDTO> = TPersonDataFactory.Make.GenerateInsert;
  const ChartOfAccountShowDTO: SH<TChartOfAccountShowDTO> = TChartOfAccountDataFactory.Make.GenerateInsert;
  const CostCenterShowDTO: SH<TCostCenterShowDTO> = TCostCenterDataFactory.Make.GenerateInsert;
  const BankAccountShowDTO: SH<TBankAccountShowDTO> = TBankAccountDataFactory.Make.GenerateInsert;
  const PaymentShowDTO: SH<TPaymentShowDTO> = TPaymentDataFactory.Make.GenerateInsert;

  Result := TBillPayReceiveInputDTO.Create;
  With Result do
  begin
    batch                 := TFaker.GenerateUUID;
    &type                 := TBillPayReceiveType(Random(1));
    short_description     := TFaker.LoremIpsum(60);
    person_id             := PersonShowDTO.Value.id;
    chart_of_account_id   := ChartOfAccountShowDTO.Value.id;
    cost_center_id        := CostCenterShowDTO.Value.id;
    bank_account_id       := BankAccountShowDTO.Value.id;
    payment_id            := PaymentShowDTO.Value.id;
    due_date              := now;
    installment_quantity  := Random(10)+1;
    installment_number    := Random(10)+1;
    amount                := TFaker.NumberFloat;
    discount              := 0;
    interest_and_fine     := 0;
    net_amount            := amount;
    status                := TBillPayReceiveStatus(Random(2));
    payment_date          := now;
    note                  := TFaker.LoremIpsum(60);
    sale_id               := 0;
    acl_user_id           := 1;
  end;
end;

function TBillPayReceiveDataFactory.GenerateInsert: TBillPayReceiveShowDTO;
begin
  const LInput: SH<TBillPayReceiveInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TBillPayReceiveDataFactory.Make(APersistenceUseCase: IBillPayReceivePersistenceUseCase): IBillPayReceiveDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
