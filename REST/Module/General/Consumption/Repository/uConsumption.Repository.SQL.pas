unit uConsumption.Repository.SQL;

interface

uses
  uBase.Repository,
  uConsumption.Repository.Interfaces,
  uConsumption.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uConsumption,
  uIndexResult,
  uZLMemTable.Interfaces,
  uConsumptionSale.Filter;

type
  TConsumptionRepositorySQL = class(TBaseRepository, IConsumptionRepository)
  private
    FConsumptionSQLBuilder: IConsumptionSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IConsumptionSQLBuilder);
    function DataSetToEntity(ADtsConsumption: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IConsumptionSQLBuilder): IConsumptionRepository;
    function Show(AId: Int64): TConsumption;
    function DeleteByNumbers(AInitial, AFinal: SmallInt): IConsumptionRepository;
    function IndexWithSale(AFilter: IConsumptionSaleFilter): IZLMemTable;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils,
  uZLQry.Interfaces,
  uMemTable.Factory,
  uConsumption.Types;

{ TConsumptionRepositorySQL }

class function TConsumptionRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IConsumptionSQLBuilder): IConsumptionRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TConsumptionRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IConsumptionSQLBuilder);
begin
  inherited Create;
  FConn            := AConn;
  FSQLBuilder      := ASQLBuilder;
  FConsumptionSQLBuilder := ASQLBuilder;
end;

function TConsumptionRepositorySQL.DataSetToEntity(ADtsConsumption: TDataSet): TBaseEntity;
var
  LConsumption: TConsumption;
begin
  LConsumption := TConsumption.FromJSON(ADtsConsumption.ToJSONObjectString);

  // Tratar especificidades
  LConsumption.created_by_acl_user.id   := ADtsConsumption.FieldByName('created_by_acl_user_id').AsLargeInt;
  LConsumption.created_by_acl_user.name := ADtsConsumption.FieldByName('created_by_acl_user_name').AsString;
  LConsumption.updated_by_acl_user.id   := ADtsConsumption.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LConsumption.updated_by_acl_user.name := ADtsConsumption.FieldByName('updated_by_acl_user_name').AsString;

  Result := LConsumption;
end;

function TConsumptionRepositorySQL.DeleteByNumbers(AInitial, AFinal: SmallInt): IConsumptionRepository;
begin
  Result := Self;
  FConn.MakeQry.ExecSQL(FConsumptionSQLBuilder.DeleteByNumbers(AInitial, AFinal));
end;

function TConsumptionRepositorySQL.IndexWithSale(AFilter: IConsumptionSaleFilter): IZLMemTable;
var
  lDtsFilter: String;
  lSqLFilter: String;
  LQry: IZLQry;
begin
  lSqLFilter := EmptyStr;

  // Filtro do DataSet
  case AFilter.Status of
    TConsumptionSaleStatus.All:        lDtsFilter := EmptyStr;
    TConsumptionSaleStatus.Free:       lDtsFilter := ' sale_id <= 0';
    TConsumptionSaleStatus.Busy:       lDtsFilter := ' sale_id > 0 and sale_flg_payment_requested <= 0';
    TConsumptionSaleStatus.PreAccount: lDtsFilter := ' sale_id > 0 and sale_flg_payment_requested = 1';
  end;

  // Filtro do SQL
  if (AFilter.Number > 0) then
    lSqLFilter := lSqLFilter + ' and consumption.number = ' + AFilter.Number.ToString;

  {TODO -oOwner -cGeneral : Refatorar! Levar esse sql para SQLBuilder}
  LQry := FConn.MakeQry.Open(
    ' select '+
    '   consumption.number, '+
    '   consumption.flg_active, '+
    '   sale.id as sale_id, '+
    '   sale.amount_of_people as sale_amount_of_people, '+
    '   sale.total as sale_total, '+
    '   sale.created_at as sale_created_at, '+
    '   sale.status as sale_status, '+
    '   sale.type as sale_type, '+
    '   sale.flg_payment_requested as sale_flg_payment_requested, '+
    '   sale.updated_at as sale_updated_at, '+
    '   CONCAT(TIMESTAMPDIFF(MINUTE, sale.created_at, NOW()), '' min'') AS sale_dwell_time_in_minutes, '+
    '   CONCAT(TIMESTAMPDIFF(MINUTE, sale.updated_at, NOW()), '' min'') AS sale_last_update_in_minutes '+
    ' from '+
    '   consumption '+
    ' left join sale '+
    '        on sale.consumption_number = consumption.number '+
    '       and sale.type = 1 '+
    '       and (sale.status = 0 or sale.status is null) '+
    ' where '+
    '   consumption.number is not null '+ lSqLFilter +
    ' order by '+
    '   consumption.number '
  )
  .Filter(lDtsFilter)
  .Filtered(true);

  Result := FConn.MakeMemTable.FromDataSet(LQry.DataSet);
end;

function TConsumptionRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FConsumptionSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TConsumptionRepositorySQL.Show(AId: Int64): TConsumption;
begin
  Result := ShowById(AId) as TConsumption;
end;

procedure TConsumptionRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.



