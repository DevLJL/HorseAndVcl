unit uAclUser.Repository.SQL;

interface

uses
  uBase.Repository,
  uAclUser.Repository.Interfaces,
  uAclUser.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uAclUser;

type
  TAclUserRepositorySQL = class(TBaseRepository, IAclUserRepository)
  private
    FAclUserSQLBuilder: IAclUserSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IAclUserSQLBuilder);
    function DataSetToEntity(ADtsAclUser: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IAclUserSQLBuilder): IAclUserRepository;
    function Show(AId: Int64): TAclUser;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils,
  uHlp,
  uAppRest.Types,
  uZLQry.Interfaces;

{ TAclUserRepositorySQL }

class function TAclUserRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IAclUserSQLBuilder): IAclUserRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TAclUserRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IAclUserSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FAclUserSQLBuilder := ASQLBuilder;
end;

function TAclUserRepositorySQL.DataSetToEntity(ADtsAclUser: TDataSet): TBaseEntity;
var
  LAclUser: TAclUser;
begin
  LAclUser := TAclUser.FromJSON(ADtsAclUser.ToJSONObjectString);

  // Tratar especificidades
  LAclUser.login_password := Decrypt(ENCRYPTATION_KEY, ADtsAclUser.FieldByName('login_password').AsString);
  LAclUser.acl_role.id    := ADtsAclUser.FieldByName('acl_role_id').AsLargeInt;
  LAclUser.acl_role.name  := ADtsAclUser.FieldByName('acl_role_name').AsString;

  Result := LAclUser;
end;

function TAclUserRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FAclUserSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TAclUserRepositorySQL.Show(AId: Int64): TAclUser;
begin
  Result := ShowById(AId) as TAclUser;
end;

procedure TAclUserRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


