unit uCity.Repository.SQL;

interface

uses
  uBase.Repository,
  uCity.Repository.Interfaces,
  uCity.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uCity,
  uIndexResult;

type
  TCityRepositorySQL = class(TBaseRepository, ICityRepository)
  private
    FCitySQLBuilder: ICitySQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: ICitySQLBuilder);
    function DataSetToEntity(ADtsCity: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: ICitySQLBuilder): ICityRepository;
    function Show(AId: Int64): TCity;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TCityRepositorySQL }

class function TCityRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: ICitySQLBuilder): ICityRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TCityRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: ICitySQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FCitySQLBuilder   := ASQLBuilder;
  FManageTransaction := False;
end;

function TCityRepositorySQL.DataSetToEntity(ADtsCity: TDataSet): TBaseEntity;
var
  LCity: TCity;
begin
  LCity := TCity.FromJSON(ADtsCity.ToJSONObjectString);

  // Tratar especificidades
  LCity.created_by_acl_user.id   := ADtsCity.FieldByName('created_by_acl_user_id').AsLargeInt;
  LCity.created_by_acl_user.name := ADtsCity.FieldByName('created_by_acl_user_name').AsString;
  LCity.updated_by_acl_user.id   := ADtsCity.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LCity.updated_by_acl_user.name := ADtsCity.FieldByName('updated_by_acl_user_name').AsString;

  Result := LCity;
end;

function TCityRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FCitySQLBuilder.SelectAllWithFilter(AFilter);
end;

function TCityRepositorySQL.Show(AId: Int64): TCity;
begin
  Result := ShowById(AId) as TCity;
end;

procedure TCityRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


