unit uCashFlow.DataFactory;

interface

uses
  uBase.DataFactory,
  uCashFlow.Show.DTO,
  uCashFlow.Input.DTO,
  uCashFlow.Persistence.UseCase.Interfaces,
  uCashFlow.Persistence.UseCase;

type
  ICashFlowDataFactory = Interface
    ['{CA893AB0-22E9-460A-90B9-6B9263EB474F}']
    function GenerateInsert: TCashFlowShowDTO;
    function GenerateInput: TCashFlowInputDTO;
  End;

  TCashFlowDataFactory = class(TBaseDataFactory, ICashFlowDataFactory)
  private
    FPersistence: ICashFlowPersistenceUseCase;
    constructor Create(APersistenceUseCase: ICashFlowPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: ICashFlowPersistenceUseCase = nil): ICashFlowDataFactory;
    function GenerateInsert: TCashFlowShowDTO;
    function GenerateInput: TCashFlowInputDTO;
  end;

implementation

{ TCashFlowDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uHlp,
  uStation.Show.DTO,
  uStation.DataFactory,
  uPayment.Show.DTO,
  uPayment.DataFactory,
  uPerson.Show.DTO,
  uPerson.DataFactory,
  uCashFlowTransaction.Input.DTO,
  uEither,
  uTestConnection,
  uCashFlowTransaction.Types;

constructor TCashFlowDataFactory.Create(APersistenceUseCase: ICashFlowPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TCashFlowPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).CashFlow);
end;

function TCashFlowDataFactory.GenerateInput: TCashFlowInputDTO;
begin
  const StationShowDTO: SH<TStationShowDTO> = TStationDataFactory.Make.GenerateInsert;
  const PaymentShowDTO: SH<TPaymentShowDTO> = TPaymentDataFactory.Make.GenerateInsert;
  const PersonShowDTO: SH<TPersonShowDTO> = TPersonDataFactory.Make.GenerateInsert;

  // CashFlow
  Result := TCashFlowInputDTO.Create;
  With Result do
  begin
    station_id             := StationShowDTO.Value.id;
    opening_balance_amount := TFaker.NumberFloat;
    final_balance_amount   := TFaker.NumberFloat;
    opening_date           := now;
    acl_user_id            := 1;
  end;

  // CashFlowTransaction
  for var lI := 0 to 2 do
  begin
    Result.cash_flow_transactions.Add(TCashFlowTransactionInputDTO.Create);
    With Result.cash_flow_transactions.Last do
    begin
      flg_manual_transaction := 1;
      transaction_date       := now;
      history                := TFaker.LoremIpsum(60);
      &type                  := TCashFlowTransactionType(Random(1));
      amount                 := TFaker.NumberFloat;
      payment_id             := PaymentShowDTO.Value.id;
      note                   := TFaker.LoremIpsum(60);
      sale_id                := 0;
      person_id              := PersonShowDTO.Value.id;
    end;
  end;
end;

function TCashFlowDataFactory.GenerateInsert: TCashFlowShowDTO;
begin
  const LInput: SH<TCashFlowInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TCashFlowDataFactory.Make(APersistenceUseCase: ICashFlowPersistenceUseCase): ICashFlowDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
