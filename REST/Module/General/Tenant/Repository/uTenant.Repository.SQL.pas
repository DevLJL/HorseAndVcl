unit uTenant.Repository.SQL;

interface

uses
  uBase.Repository,
  uTenant.Repository.Interfaces,
  uTenant.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uTenant,
  uIndexResult;

type
  TTenantRepositorySQL = class(TBaseRepository, ITenantRepository)
  private
    FTenantSQLBuilder: ITenantSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: ITenantSQLBuilder);
    function DataSetToEntity(ADtsTenant: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: ITenantSQLBuilder): ITenantRepository;
    function Show(AId: Int64): TTenant;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TTenantRepositorySQL }

class function TTenantRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: ITenantSQLBuilder): ITenantRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TTenantRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: ITenantSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FTenantSQLBuilder   := ASQLBuilder;
  FManageTransaction := False;
end;

function TTenantRepositorySQL.DataSetToEntity(ADtsTenant: TDataSet): TBaseEntity;
var
  LTenant: TTenant;
begin
  LTenant := TTenant.FromJSON(ADtsTenant.ToJSONObjectString);

  // Tratar especificidades
  LTenant.city.id        := ADtsTenant.FieldByName('city_id').AsLargeInt;
  LTenant.city.name      := ADtsTenant.FieldByName('city_name').AsString;
  LTenant.city.state     := ADtsTenant.FieldByName('city_state').AsString;
  LTenant.city.ibge_code := ADtsTenant.FieldByName('city_ibge_code').AsString;

  Result := LTenant;
end;

function TTenantRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FTenantSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TTenantRepositorySQL.Show(AId: Int64): TTenant;
begin
  Result := ShowById(AId) as TTenant;
end;

procedure TTenantRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


