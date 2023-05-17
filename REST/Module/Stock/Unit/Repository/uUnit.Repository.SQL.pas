unit uUnit.Repository.SQL;

interface

uses
  uBase.Repository,
  uUnit.Repository.Interfaces,
  uUnit.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uUnit,
  uIndexResult;

type
  TUnitRepositorySQL = class(TBaseRepository, IUnitRepository)
  private
    FUnitSQLBuilder: IUnitSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IUnitSQLBuilder);
    function DataSetToEntity(ADtsUnit: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IUnitSQLBuilder): IUnitRepository;
    function Show(AId: Int64): TUnit;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TUnitRepositorySQL }

class function TUnitRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IUnitSQLBuilder): IUnitRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TUnitRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IUnitSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FUnitSQLBuilder   := ASQLBuilder;
  FManageTransaction := False;
end;

function TUnitRepositorySQL.DataSetToEntity(ADtsUnit: TDataSet): TBaseEntity;
var
  LUnit: TUnit;
begin
  LUnit := TUnit.FromJSON(ADtsUnit.ToJSONObjectString);

  // Tratar especificidades
  LUnit.created_by_acl_user.id   := ADtsUnit.FieldByName('created_by_acl_user_id').AsLargeInt;
  LUnit.created_by_acl_user.name := ADtsUnit.FieldByName('created_by_acl_user_name').AsString;
  LUnit.updated_by_acl_user.id   := ADtsUnit.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LUnit.updated_by_acl_user.name := ADtsUnit.FieldByName('updated_by_acl_user_name').AsString;

  Result := LUnit;
end;

function TUnitRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FUnitSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TUnitRepositorySQL.Show(AId: Int64): TUnit;
begin
  Result := ShowById(AId) as TUnit;
end;

procedure TUnitRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


