unit uBrand.Repository.SQL;

interface

uses
  uBase.Repository,
  uBrand.Repository.Interfaces,
  uBrand.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uBrand,
  uIndexResult;

type
  TBrandRepositorySQL = class(TBaseRepository, IBrandRepository)
  private
    FBrandSQLBuilder: IBrandSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IBrandSQLBuilder);
    function DataSetToEntity(ADtsBrand: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IBrandSQLBuilder): IBrandRepository;
    function Show(AId: Int64): TBrand;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TBrandRepositorySQL }

class function TBrandRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IBrandSQLBuilder): IBrandRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TBrandRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IBrandSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FBrandSQLBuilder   := ASQLBuilder;
  FManageTransaction := False;
end;

function TBrandRepositorySQL.DataSetToEntity(ADtsBrand: TDataSet): TBaseEntity;
begin
  const LBrand = TBrand.FromJSON(ADtsBrand.ToJSONObjectString);

  // Tratar especificidades
  LBrand.created_by_acl_user.id   := ADtsBrand.FieldByName('created_by_acl_user_id').AsLargeInt;
  LBrand.created_by_acl_user.name := ADtsBrand.FieldByName('created_by_acl_user_name').AsString;
  LBrand.updated_by_acl_user.id   := ADtsBrand.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LBrand.updated_by_acl_user.name := ADtsBrand.FieldByName('updated_by_acl_user_name').AsString;

  Result := LBrand;
end;

function TBrandRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FBrandSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TBrandRepositorySQL.Show(AId: Int64): TBrand;
begin
  Result := ShowById(AId) as TBrand;
end;

procedure TBrandRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


