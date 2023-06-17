unit uGlobalConfig.Repository.SQL;

interface

uses
  uBase.Repository,
  uGlobalConfig.Repository.Interfaces,
  uGlobalConfig.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uGlobalConfig,
  uIndexResult;

type
  TGlobalConfigRepositorySQL = class(TBaseRepository, IGlobalConfigRepository)
  private
    FGlobalConfigSQLBuilder: IGlobalConfigSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IGlobalConfigSQLBuilder);
    function DataSetToEntity(ADtsGlobalConfig: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IGlobalConfigSQLBuilder): IGlobalConfigRepository;
    function Show(AId: Int64): TGlobalConfig;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TGlobalConfigRepositorySQL }

class function TGlobalConfigRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IGlobalConfigSQLBuilder): IGlobalConfigRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TGlobalConfigRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IGlobalConfigSQLBuilder);
begin
  inherited Create;
  FConn                   := AConn;
  FSQLBuilder             := ASQLBuilder;
  FGlobalConfigSQLBuilder := ASQLBuilder;
  FManageTransaction      := False;
end;

function TGlobalConfigRepositorySQL.DataSetToEntity(ADtsGlobalConfig: TDataSet): TBaseEntity;
begin
  const LGlobalConfig = TGlobalConfig.FromJSON(ADtsGlobalConfig.ToJSONObjectString);

  // Tratar especificidades
  LGlobalConfig.created_by_acl_user.id   := ADtsGlobalConfig.FieldByName('created_by_acl_user_id').AsLargeInt;
  LGlobalConfig.created_by_acl_user.name := ADtsGlobalConfig.FieldByName('created_by_acl_user_name').AsString;
  LGlobalConfig.updated_by_acl_user.id   := ADtsGlobalConfig.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LGlobalConfig.updated_by_acl_user.name := ADtsGlobalConfig.FieldByName('updated_by_acl_user_name').AsString;

  Result := LGlobalConfig;
end;

function TGlobalConfigRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FGlobalConfigSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TGlobalConfigRepositorySQL.Show(AId: Int64): TGlobalConfig;
begin
  Result := ShowById(AId) as TGlobalConfig;
end;

procedure TGlobalConfigRepositorySQL.Validate(AEntity: TBaseEntity);
begin
end;

end.


