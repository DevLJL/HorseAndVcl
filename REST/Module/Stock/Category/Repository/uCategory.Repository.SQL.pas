unit uCategory.Repository.SQL;

interface

uses
  uBase.Repository,
  uCategory.Repository.Interfaces,
  uCategory.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uCategory,
  uIndexResult;

type
  TCategoryRepositorySQL = class(TBaseRepository, ICategoryRepository)
  private
    FCategorySQLBuilder: ICategorySQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: ICategorySQLBuilder);
    function DataSetToEntity(ADtsCategory: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: ICategorySQLBuilder): ICategoryRepository;
    function Show(AId: Int64): TCategory;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TCategoryRepositorySQL }

class function TCategoryRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: ICategorySQLBuilder): ICategoryRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TCategoryRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: ICategorySQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FCategorySQLBuilder   := ASQLBuilder;
  FManageTransaction := False;
end;

function TCategoryRepositorySQL.DataSetToEntity(ADtsCategory: TDataSet): TBaseEntity;
var
  LCategory: TCategory;
begin
  LCategory := TCategory.FromJSON(ADtsCategory.ToJSONObjectString);

  // Tratar especificidades
  LCategory.created_by_acl_user.id   := ADtsCategory.FieldByName('created_by_acl_user_id').AsLargeInt;
  LCategory.created_by_acl_user.name := ADtsCategory.FieldByName('created_by_acl_user_name').AsString;
  LCategory.updated_by_acl_user.id   := ADtsCategory.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LCategory.updated_by_acl_user.name := ADtsCategory.FieldByName('updated_by_acl_user_name').AsString;

  Result := LCategory;
end;

function TCategoryRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FCategorySQLBuilder.SelectAllWithFilter(AFilter);
end;

function TCategoryRepositorySQL.Show(AId: Int64): TCategory;
begin
  Result := ShowById(AId) as TCategory;
end;

procedure TCategoryRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


