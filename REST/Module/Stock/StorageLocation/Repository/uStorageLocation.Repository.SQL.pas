unit uStorageLocation.Repository.SQL;

interface

uses
  uBase.Repository,
  uStorageLocation.Repository.Interfaces,
  uStorageLocation.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uStorageLocation,
  uIndexResult;

type
  TStorageLocationRepositorySQL = class(TBaseRepository, IStorageLocationRepository)
  private
    FStorageLocationSQLBuilder: IStorageLocationSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IStorageLocationSQLBuilder);
    function DataSetToEntity(ADtsStorageLocation: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IStorageLocationSQLBuilder): IStorageLocationRepository;
    function Show(AId: Int64): TStorageLocation;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TStorageLocationRepositorySQL }

class function TStorageLocationRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IStorageLocationSQLBuilder): IStorageLocationRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TStorageLocationRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IStorageLocationSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FStorageLocationSQLBuilder   := ASQLBuilder;
  FManageTransaction := False;
end;

function TStorageLocationRepositorySQL.DataSetToEntity(ADtsStorageLocation: TDataSet): TBaseEntity;
var
  LStorageLocation: TStorageLocation;
begin
  LStorageLocation := TStorageLocation.FromJSON(ADtsStorageLocation.ToJSONObjectString);

  // Tratar especificidades
  LStorageLocation.created_by_acl_user.id   := ADtsStorageLocation.FieldByName('created_by_acl_user_id').AsLargeInt;
  LStorageLocation.created_by_acl_user.name := ADtsStorageLocation.FieldByName('created_by_acl_user_name').AsString;
  LStorageLocation.updated_by_acl_user.id   := ADtsStorageLocation.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LStorageLocation.updated_by_acl_user.name := ADtsStorageLocation.FieldByName('updated_by_acl_user_name').AsString;

  Result := LStorageLocation;
end;

function TStorageLocationRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FStorageLocationSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TStorageLocationRepositorySQL.Show(AId: Int64): TStorageLocation;
begin
  Result := ShowById(AId) as TStorageLocation;
end;

procedure TStorageLocationRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


