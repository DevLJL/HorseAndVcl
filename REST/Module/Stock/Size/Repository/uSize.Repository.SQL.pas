unit uSize.Repository.SQL;

interface

uses
  uBase.Repository,
  uSize.Repository.Interfaces,
  uSize.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uSize,
  uIndexResult;

type
  TSizeRepositorySQL = class(TBaseRepository, ISizeRepository)
  private
    FSizeSQLBuilder: ISizeSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: ISizeSQLBuilder);
    function DataSetToEntity(ADtsSize: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: ISizeSQLBuilder): ISizeRepository;
    function Show(AId: Int64): TSize;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TSizeRepositorySQL }

class function TSizeRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: ISizeSQLBuilder): ISizeRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TSizeRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: ISizeSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FSizeSQLBuilder   := ASQLBuilder;
  FManageTransaction := False;
end;

function TSizeRepositorySQL.DataSetToEntity(ADtsSize: TDataSet): TBaseEntity;
var
  LSize: TSize;
begin
  LSize := TSize.FromJSON(ADtsSize.ToJSONObjectString);

  // Tratar especificidades
  LSize.created_by_acl_user.id   := ADtsSize.FieldByName('created_by_acl_user_id').AsLargeInt;
  LSize.created_by_acl_user.name := ADtsSize.FieldByName('created_by_acl_user_name').AsString;
  LSize.updated_by_acl_user.id   := ADtsSize.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LSize.updated_by_acl_user.name := ADtsSize.FieldByName('updated_by_acl_user_name').AsString;

  Result := LSize;
end;

function TSizeRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FSizeSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TSizeRepositorySQL.Show(AId: Int64): TSize;
begin
  Result := ShowById(AId) as TSize;
end;

procedure TSizeRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


