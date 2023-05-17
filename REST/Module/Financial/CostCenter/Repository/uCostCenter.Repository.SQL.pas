unit uCostCenter.Repository.SQL;

interface

uses
  uBase.Repository,
  uCostCenter.Repository.Interfaces,
  uCostCenter.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uCostCenter,
  uIndexResult;

type
  TCostCenterRepositorySQL = class(TBaseRepository, ICostCenterRepository)
  private
    FCostCenterSQLBuilder: ICostCenterSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: ICostCenterSQLBuilder);
    function DataSetToEntity(ADtsCostCenter: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: ICostCenterSQLBuilder): ICostCenterRepository;
    function Show(AId: Int64): TCostCenter;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TCostCenterRepositorySQL }

class function TCostCenterRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: ICostCenterSQLBuilder): ICostCenterRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TCostCenterRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: ICostCenterSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FCostCenterSQLBuilder   := ASQLBuilder;
  FManageTransaction := False;
end;

function TCostCenterRepositorySQL.DataSetToEntity(ADtsCostCenter: TDataSet): TBaseEntity;
var
  LCostCenter: TCostCenter;
begin
  LCostCenter := TCostCenter.FromJSON(ADtsCostCenter.ToJSONObjectString);

  // Tratar especificidades
  LCostCenter.created_by_acl_user.id   := ADtsCostCenter.FieldByName('created_by_acl_user_id').AsLargeInt;
  LCostCenter.created_by_acl_user.name := ADtsCostCenter.FieldByName('created_by_acl_user_name').AsString;
  LCostCenter.updated_by_acl_user.id   := ADtsCostCenter.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LCostCenter.updated_by_acl_user.name := ADtsCostCenter.FieldByName('updated_by_acl_user_name').AsString;

  Result := LCostCenter;
end;

function TCostCenterRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FCostCenterSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TCostCenterRepositorySQL.Show(AId: Int64): TCostCenter;
begin
  Result := ShowById(AId) as TCostCenter;
end;

procedure TCostCenterRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


