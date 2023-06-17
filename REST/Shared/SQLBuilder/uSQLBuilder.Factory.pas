unit uSQLBuilder.Factory;

interface

uses
  uAdditional.SQLBuilder.Interfaces,
  uPriceList.SQLBuilder.Interfaces,
  uGlobalConfig.SQLBuilder.Interfaces,
  uQueueEmail.SQLBuilder.Interfaces,
  uCashFlow.SQLBuilder.Interfaces,
  uConsumption.SQLBuilder.Interfaces,
  uPosPrinter.SQLBuilder.Interfaces,
  uBillPayReceive.SQLBuilder.Interfaces,
  uTenant.SQLBuilder.Interfaces,
  uSale.SQLBuilder.Interfaces,
  uPayment.SQLBuilder.Interfaces,
  uChartOfAccount.SQLBuilder.Interfaces,
  uBankAccount.SQLBuilder.Interfaces,
  uCostCenter.SQLBuilder.Interfaces,
  uBank.SQLBuilder.Interfaces,
  uProduct.SQLBuilder.Interfaces,
  uStorageLocation.SQLBuilder.Interfaces,
  uSize.SQLBuilder.Interfaces,
  uCategory.SQLBuilder.Interfaces,
  uNcm.SQLBuilder.Interfaces,
  uUnit.SQLBuilder.Interfaces,
  uPerson.SQLBuilder.Interfaces,
  uCity.SQLBuilder.Interfaces,
  uBrand.SQLBuilder.Interfaces,
  uAclUser.SQLBuilder.Interfaces,
  uStation.SQLBuilder.Interfaces,
  uAclRole.SQLBuilder.Interfaces,
  uZLConnection.Types;

type
  ISQLBuilderFactory = interface
    ['{70331F0A-8240-4E68-9344-84329210019F}']
    function Additional: IAdditionalSQLBuilder;
    function PriceList: IPriceListSQLBuilder;
    function GlobalConfig: IGlobalConfigSQLBuilder;
    function QueueEmail: IQueueEmailSQLBuilder;
    function CashFlow: ICashFlowSQLBuilder;
    function Consumption: IConsumptionSQLBuilder;
    function PosPrinter: IPosPrinterSQLBuilder;
    function BillPayReceive: IBillPayReceiveSQLBuilder;
    function Tenant: ITenantSQLBuilder;
    function Sale: ISaleSQLBuilder;
    function Station: IStationSQLBuilder;
    function Payment: IPaymentSQLBuilder;
    function ChartOfAccount: IChartOfAccountSQLBuilder;
    function BankAccount: IBankAccountSQLBuilder;
    function CostCenter: ICostCenterSQLBuilder;
    function Bank: IBankSQLBuilder;
    function Product: IProductSQLBuilder;
    function StorageLocation: IStorageLocationSQLBuilder;
    function Size: ISizeSQLBuilder;
    function Category: ICategorySQLBuilder;
    function Ncm: INcmSQLBuilder;
    function &Unit: IUnitSQLBuilder;
    function Person: IPersonSQLBuilder;
    function City: ICitySQLBuilder;
    function Brand: IBrandSQLBuilder;
    function AclUser: IAclUserSQLBuilder;
    function AclRole: IAclRoleSQLBuilder;
  end;

  TSQLBuilderFactory = class(TInterfacedObject, ISQLBuilderFactory)
  private
    FDriverDB: TZLDriverDB;
    constructor Create(ADriverDB: TZLDriverDB);
  public
    class function Make(ADriverDB: TZLDriverDB = ddDefault): ISQLBuilderFactory;

    function Additional: IAdditionalSQLBuilder;
    function PriceList: IPriceListSQLBuilder;
    function GlobalConfig: IGlobalConfigSQLBuilder;
    function QueueEmail: IQueueEmailSQLBuilder;
    function CashFlow: ICashFlowSQLBuilder;
    function Consumption: IConsumptionSQLBuilder;
    function PosPrinter: IPosPrinterSQLBuilder;
    function BillPayReceive: IBillPayReceiveSQLBuilder;
    function Tenant: ITenantSQLBuilder;
    function Sale: ISaleSQLBuilder;
    function Station: IStationSQLBuilder;
    function Payment: IPaymentSQLBuilder;
    function ChartOfAccount: IChartOfAccountSQLBuilder;
    function BankAccount: IBankAccountSQLBuilder;
    function CostCenter: ICostCenterSQLBuilder;
    function Bank: IBankSQLBuilder;
    function Product: IProductSQLBuilder;
    function StorageLocation: IStorageLocationSQLBuilder;
    function Size: ISizeSQLBuilder;
    function Category: ICategorySQLBuilder;
    function Ncm: INcmSQLBuilder;
    function &Unit: IUnitSQLBuilder;
    function Person: IPersonSQLBuilder;
    function City: ICitySQLBuilder;
    function Brand: IBrandSQLBuilder;
    function AclUser: IAclUserSQLBuilder;
    function AclRole: IAclRoleSQLBuilder;
  end;

implementation

uses
  uAdditional.SQLBuilder.MySQL,
  uPriceList.SQLBuilder.MySQL,
  uGlobalConfig.SQLBuilder.MySQL,
  uQueueEmail.SQLBuilder.MySQL,
  uCashFlow.SQLBuilder.MySQL,
  uConsumption.SQLBuilder.MySQL,
  uPosPrinter.SQLBuilder.MySQL,
  uBillPayReceive.SQLBuilder.MySQL,
  uTenant.SQLBuilder.MySQL,
  uSale.SQLBuilder.MySQL,
  uStation.SQLBuilder.MySQL,
  uPayment.SQLBuilder.MySQL,
  uChartOfAccount.SQLBuilder.MySQL,
  uBankAccount.SQLBuilder.MySQL,
  uCostCenter.SQLBuilder.MySQL,
  uBank.SQLBuilder.MySQL,
  uProduct.SQLBuilder.MySQL,
  uStorageLocation.SQLBuilder.MySQL,
  uSize.SQLBuilder.MySQL,
  uCategory.SQLBuilder.MySQL,
  uNcm.SQLBuilder.MySQL,
  uUnit.SQLBuilder.MySQL,
  uPerson.SQLBuilder.MySQL,
  uCity.SQLBuilder.MySQL,
//  uAppParam.SQLBuilder.MySQL,
  uBrand.SQLBuilder.MySQL,
  uAclUser.SQLBuilder.MySQL,
  uAclRole.SQLBuilder.MySQL,
  uEnv.Rest;

{ TSQLBuilderFactory }

function TSQLBuilderFactory.&Unit: IUnitSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TUnitSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.AclRole: IAclRoleSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TAclRoleSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.AclUser: IAclUserSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TAclUserSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.Additional: IAdditionalSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TAdditionalSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.Bank: IBankSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TBankSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.BankAccount: IBankAccountSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TBankAccountSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.BillPayReceive: IBillPayReceiveSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TBillPayReceiveSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.Brand: IBrandSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TBrandSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.CashFlow: ICashFlowSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TCashFlowSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.Category: ICategorySQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TCategorySQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.ChartOfAccount: IChartOfAccountSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TChartOfAccountSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.City: ICitySQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TCitySQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.Tenant: ITenantSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TTenantSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.Consumption: IConsumptionSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TConsumptionSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.CostCenter: ICostCenterSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TCostCenterSQLBuilderMySQL.Make;
  end;
end;

constructor TSQLBuilderFactory.Create(ADriverDB: TZLDriverDB);
begin
  inherited Create;

  FDriverDB := ADriverDB;
  if (FDriverDB = ddDefault) then
    FDriverDB := ENV_REST.DriverDB;
end;

function TSQLBuilderFactory.GlobalConfig: IGlobalConfigSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TGlobalConfigSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.Payment: IPaymentSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TPaymentSQLBuilderMySQL.Make;
  end;
end;

class function TSQLBuilderFactory.Make(ADriverDB: TZLDriverDB): ISQLBuilderFactory;
begin
  Result := Self.Create(ADriverDB);
end;

function TSQLBuilderFactory.Ncm: INcmSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TNcmSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.Sale: ISaleSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TSaleSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.QueueEmail: IQueueEmailSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TQueueEmailSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.Person: IPersonSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TPersonSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.PosPrinter: IPosPrinterSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TPosPrinterSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.PriceList: IPriceListSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TPriceListSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.Product: IProductSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TProductSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.Size: ISizeSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TSizeSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.Station: IStationSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TStationSQLBuilderMySQL.Make;
  end;
end;

function TSQLBuilderFactory.StorageLocation: IStorageLocationSQLBuilder;
begin
  case FDriverDB of
    ddMySql: Result := TStorageLocationSQLBuilderMySQL.Make;
  end;
end;

end.
