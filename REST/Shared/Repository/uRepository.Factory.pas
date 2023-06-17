unit uRepository.Factory;

interface

uses
  uAdditional.Repository.Interfaces,
  uPriceList.Repository.Interfaces,
  uGlobalConfig.Repository.Interfaces,
  uQueueEmail.Repository.Interfaces,
  uCashFlow.Repository.Interfaces,
  uConsumption.Repository.Interfaces,
  uPosPrinter.Repository.Interfaces,
  uBillPayReceive.Repository.Interfaces,
  uTenant.Repository.Interfaces,
  uSale.Repository.Interfaces,
  uStation.Repository.Interfaces,
  uPayment.Repository.Interfaces,
  uChartOfAccount.Repository.Interfaces,
  uBankAccount.Repository.Interfaces,
  uCostCenter.Repository.Interfaces,
  uBank.Repository.Interfaces,
  uProduct.Repository.Interfaces,
  uStorageLocation.Repository.Interfaces,
  uSize.Repository.Interfaces,
  uCategory.Repository.Interfaces,
  uNcm.Repository.Interfaces,
  uUnit.Repository.Interfaces,
  uPerson.Repository.Interfaces,
  uCity.Repository.Interfaces,
  uAclUser.Repository.Interfaces,
  uAclRole.Repository.Interfaces,
  uBrand.Repository.Interfaces,
  uZLConnection.Interfaces,
  uZLConnection.Types;

type
  IRepositoryFactory = Interface
    ['{30B8DCC2-78FB-4995-A3B7-E125761D6BC9}']
    function Additional: IAdditionalRepository;
    function PriceList: IPriceListRepository;
    function GlobalConfig: IGlobalConfigRepository;
    function QueueEmail: IQueueEmailRepository;
    function CashFlow: ICashFlowRepository;
    function Consumption: IConsumptionRepository;
    function PosPrinter: IPosPrinterRepository;
    function BillPayReceive: IBillPayReceiveRepository;
    function Tenant: ITenantRepository;
    function Sale: ISaleRepository;
    function Station: IStationRepository;
    function Payment: IPaymentRepository;
    function ChartOfAccount: IChartOfAccountRepository;
    function BankAccount: IBankAccountRepository;
    function CostCenter: ICostCenterRepository;
    function Bank: IBankRepository;
    function Product: IProductRepository;
    function StorageLocation: IStorageLocationRepository;
    function Size: ISizeRepository;
    function Category: ICategoryRepository;
    function Ncm: INcmRepository;
    function &Unit: IUnitRepository;
    function Person: IPersonRepository;
    function City: ICityRepository;
    function AclUser: IAclUserRepository;
    function AclRole: IAclRoleRepository;
    function Brand: IBrandRepository;
    function Conn: IZLConnection;
  end;

  TRepositoryFactory = class(TInterfacedObject, IRepositoryFactory)
  private
    FConn: IZLConnection;
    FRepoType: TZLRepositoryType;
    FDriverDB: TZLDriverDB;
    constructor Create(AConn: IZLConnection; ARepoType: TZLRepositoryType; ADriverDB: TZLDriverDB);
  public
    class function Make(AConn: IZLConnection = nil; ARepoType: TZLRepositoryType = rtDefault; ADriverDB: TZLDriverDB = ddDefault): IRepositoryFactory;
    function Conn: IZLConnection;

    function Additional: IAdditionalRepository;
    function PriceList: IPriceListRepository;
    function GlobalConfig: IGlobalConfigRepository;
    function QueueEmail: IQueueEmailRepository;
    function CashFlow: ICashFlowRepository;
    function Consumption: IConsumptionRepository;
    function PosPrinter: IPosPrinterRepository;
    function BillPayReceive: IBillPayReceiveRepository;
    function Tenant: ITenantRepository;
    function Sale: ISaleRepository;
    function Station: IStationRepository;
    function Payment: IPaymentRepository;
    function ChartOfAccount: IChartOfAccountRepository;
    function BankAccount: IBankAccountRepository;
    function CostCenter: ICostCenterRepository;
    function Bank: IBankRepository;
    function Product: IProductRepository;
    function StorageLocation: IStorageLocationRepository;
    function Size: ISizeRepository;
    function Category: ICategoryRepository;
    function Ncm: INcmRepository;
    function &Unit: IUnitRepository;
    function Person: IPersonRepository;
    function City: ICityRepository;
    function AclUser: IAclUserRepository;
    function AclRole: IAclRoleRepository;
    function Brand: IBrandRepository;
  end;

implementation

uses
  uAdditional.Repository.SQL,
  uPriceList.Repository.SQL,
  uGlobalConfig.Repository.SQL,
  uQueueEmail.Repository.SQL,
  uCashFlow.Repository.SQL,
  uConsumption.Repository.SQL,
  uPosPrinter.Repository.SQL,
  uBillPayReceive.Repository.SQL,
  uTenant.Repository.SQL,
  uSale.Repository.SQL,
  uStation.Repository.SQL,
  uPayment.Repository.SQL,
  uChartOfAccount.Repository.SQL,
  uBankAccount.Repository.SQL,
  uCostCenter.Repository.SQL,
  uBank.Repository.SQL,
  uProduct.Repository.SQL,
  uStorageLocation.Repository.SQL,
  uSize.Repository.SQL,
  uCategory.Repository.SQL,
  uNcm.Repository.SQL,
  uUnit.Repository.SQL,
  uPerson.Repository.SQL,
  uCity.Repository.SQL,
  uAclUser.Repository.SQL,
  uAclRole.Repository.SQL,
  uBrand.Repository.SQL,
  uSQLBuilder.Factory,
  uEnv.Rest,
  uConnection.Factory;

{ TRepositoryFactory }

function TRepositoryFactory.&Unit: IUnitRepository;
begin
  case FRepoType of
    rtSQL: Result := TUnitRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).&Unit);
  end;
end;

function TRepositoryFactory.AclRole: IAclRoleRepository;
begin
  case FRepoType of
    rtSQL: Result := TAclRoleRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).AclRole);
  end;
end;

function TRepositoryFactory.AclUser: IAclUserRepository;
begin
  case FRepoType of
    rtSQL: Result := TAclUserRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).AclUser);
  end;
end;

function TRepositoryFactory.Additional: IAdditionalRepository;
begin
  case FRepoType of
    rtSQL: Result := TAdditionalRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).Additional);
  end;
end;

function TRepositoryFactory.Bank: IBankRepository;
begin
  case FRepoType of
    rtSQL: Result := TBankRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).Bank);
  end;
end;

function TRepositoryFactory.BankAccount: IBankAccountRepository;
begin
  case FRepoType of
    rtSQL: Result := TBankAccountRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).BankAccount);
  end;
end;

function TRepositoryFactory.BillPayReceive: IBillPayReceiveRepository;
begin
  case FRepoType of
    rtSQL: Result := TBillPayReceiveRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).BillPayReceive);
  end;
end;

function TRepositoryFactory.Brand: IBrandRepository;
begin
  case FRepoType of
    rtSQL: Result := TBrandRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).Brand);
  end;
end;

function TRepositoryFactory.CashFlow: ICashFlowRepository;
begin
  case FRepoType of
    rtSQL: Result := TCashFlowRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).CashFlow);
  end;
end;

function TRepositoryFactory.Category: ICategoryRepository;
begin
  case FRepoType of
    rtSQL: Result := TCategoryRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).Category);
  end;
end;

function TRepositoryFactory.ChartOfAccount: IChartOfAccountRepository;
begin
  case FRepoType of
    rtSQL: Result := TChartOfAccountRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).ChartOfAccount);
  end;
end;

function TRepositoryFactory.City: ICityRepository;
begin
  case FRepoType of
    rtSQL: Result := TCityRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).City);
  end;
end;

function TRepositoryFactory.Tenant: ITenantRepository;
begin
  case FRepoType of
    rtSQL: Result := TTenantRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).Tenant);
  end;
end;

function TRepositoryFactory.Conn: IZLConnection;
begin
  Result := FConn;
end;

function TRepositoryFactory.Consumption: IConsumptionRepository;
begin
  case FRepoType of
    rtSQL: Result := TConsumptionRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).Consumption);
  end;
end;

function TRepositoryFactory.CostCenter: ICostCenterRepository;
begin
  case FRepoType of
    rtSQL: Result := TCostCenterRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).CostCenter);
  end;
end;

constructor TRepositoryFactory.Create(AConn: IZLConnection; ARepoType: TZLRepositoryType; ADriverDB: TZLDriverDB);
begin
  inherited Create;

  // Driver do Banco de Dados
  FDriverDB := ADriverDB;
  if (FDriverDB = ddDefault) then
    FDriverDB := ENV_REST.DriverDB;

  // Tipo de Repositório
  FRepoType := ARepoType;
  if (FRepoType = rtDefault) then
    FRepoType := ENV_REST.DefaultRepoType;

  // Conexão
  case Assigned(AConn) of
    True:  FConn := AConn;
    False: FConn := TConnectionFactory.Make;
  end;
end;

function TRepositoryFactory.GlobalConfig: IGlobalConfigRepository;
begin
  case FRepoType of
    rtSQL: Result := TGlobalConfigRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).GlobalConfig);
  end;
end;

function TRepositoryFactory.Payment: IPaymentRepository;
begin
  case FRepoType of
    rtSQL: Result := TPaymentRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).Payment);
  end;
end;

class function TRepositoryFactory.Make(AConn: IZLConnection; ARepoType: TZLRepositoryType; ADriverDB: TZLDriverDB): IRepositoryFactory;
begin
  Result := Self.Create(AConn, ARepoType, ADriverDB);
end;

function TRepositoryFactory.Ncm: INcmRepository;
begin
  case FRepoType of
    rtSQL: Result := TNcmRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).Ncm);
  end;
end;

function TRepositoryFactory.Sale: ISaleRepository;
begin
  case FRepoType of
    rtSQL: Result := TSaleRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).Sale);
  end;
end;

function TRepositoryFactory.QueueEmail: IQueueEmailRepository;
begin
  case FRepoType of
    rtSQL: Result := TQueueEmailRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).QueueEmail);
  end;
end;

function TRepositoryFactory.Person: IPersonRepository;
begin
  case FRepoType of
    rtSQL: Result := TPersonRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).Person);
  end;
end;

function TRepositoryFactory.PosPrinter: IPosPrinterRepository;
begin
  case FRepoType of
    rtSQL: Result := TPosPrinterRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).PosPrinter);
  end;
end;

function TRepositoryFactory.PriceList: IPriceListRepository;
begin
  case FRepoType of
    rtSQL: Result := TPriceListRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).PriceList);
  end;
end;

function TRepositoryFactory.Product: IProductRepository;
begin
  case FRepoType of
    rtSQL: Result := TProductRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).Product);
  end;
end;

function TRepositoryFactory.Size: ISizeRepository;
begin
  case FRepoType of
    rtSQL: Result := TSizeRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).Size);
  end;
end;

function TRepositoryFactory.Station: IStationRepository;
begin
  case FRepoType of
    rtSQL: Result := TStationRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).Station);
  end;
end;

function TRepositoryFactory.StorageLocation: IStorageLocationRepository;
begin
  case FRepoType of
    rtSQL: Result := TStorageLocationRepositorySQL.Make(FConn, TSQLBuilderFactory.Make(FDriverDB).StorageLocation);
  end;
end;

end.
