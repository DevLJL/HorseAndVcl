unit uSaleGenerateBillingRepositories;

interface

uses
  uZLConnection.Interfaces,
  uSale.Repository.Interfaces,
  uProduct.Repository.Interfaces,
  uBillPayReceive.Repository.Interfaces,
  uCashFlow.Repository.Interfaces;

type
  ISaleGenerateBillingRepositories = Interface
    ['{2428E09B-6E4C-4952-B5D9-96FE0CC1B1E8}']

    function Shared: IZLConnection;
    function Sale: ISaleRepository;
    function Product: IProductRepository;
    function BillPayReceive: IBillPayReceiveRepository;
    function CashFlow: ICashFlowRepository;
  End;

  TSaleGenerateBillingRepositories = class(TInterfacedObject, ISaleGenerateBillingRepositories)
  private
    FConn: IZLConnection;
    FSaleRepository: ISaleRepository;
    FProductRepository: IProductRepository;
    FBillPayReceiveRepository: IBillPayReceiveRepository;
    FCashFlowRepository: ICashFlowRepository;
    constructor Create(AConn: IZLConnection);
  public
    class function Make(AConn: IZLConnection = nil): ISaleGenerateBillingRepositories;

    function Shared: IZLConnection;
    function Sale: ISaleRepository;
    function Product: IProductRepository;
    function BillPayReceive: IBillPayReceiveRepository;
    function CashFlow: ICashFlowRepository;
  end;

implementation

{ TSaleGenerateBillingRepositories }

uses
  uRepository.Factory,
  uConnection.Factory;

function TSaleGenerateBillingRepositories.BillPayReceive: IBillPayReceiveRepository;
begin
  Result := FBillPayReceiveRepository;
end;

function TSaleGenerateBillingRepositories.CashFlow: ICashFlowRepository;
begin
  Result := FCashFlowRepository;
end;

constructor TSaleGenerateBillingRepositories.Create(AConn: IZLConnection);
begin
  inherited Create;
  case Assigned(AConn) of
    True:  FConn := AConn;
    False: FConn := TConnectionFactory.Make;
  end;

  // Instanciar repositórios
  FSaleRepository           := TRepositoryFactory.Make(FConn).Sale;
  FProductRepository        := TRepositoryFactory.Make(FConn).Product;
  FBillPayReceiveRepository := TRepositoryFactory.Make(FConn).BillPayReceive;
  FCashFlowRepository       := TRepositoryFactory.Make(FConn).CashFlow;

  // Desligar Controle de Transações de dentro do Repositório
  // Transação será gerenciada externamente
  FSaleRepository.SetManageTransaction(False);
  FProductRepository.SetManageTransaction(False);
  FBillPayReceiveRepository.SetManageTransaction(False);
  FCashFlowRepository.SetManageTransaction(False);
end;

class function TSaleGenerateBillingRepositories.Make(AConn: IZLConnection): ISaleGenerateBillingRepositories;
begin
  Result := Self.Create(AConn);
end;

function TSaleGenerateBillingRepositories.Product: IProductRepository;
begin
  Result := FProductRepository;
end;

function TSaleGenerateBillingRepositories.Sale: ISaleRepository;
begin
  Result := FSaleRepository;
end;

function TSaleGenerateBillingRepositories.Shared: IZLConnection;
begin
  Result := FConn;
end;

end.
