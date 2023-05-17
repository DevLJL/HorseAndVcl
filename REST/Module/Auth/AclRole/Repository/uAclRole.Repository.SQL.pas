unit uAclRole.Repository.SQL;

interface

uses
  uBase.Repository,
  uAclRole.Repository.Interfaces,
  uAclRole.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uAclRole;

type
  TAclRoleRepositorySQL = class(TBaseRepository, IAclRoleRepository)
  private
    FAclRoleSQLBuilder: IAclRoleSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IAclRoleSQLBuilder);
    function DataSetToEntity(ADtsAclRole: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IAclRoleSQLBuilder): IAclRoleRepository;
    function Show(AId: Int64): TAclRole;
    function Update(AId: Int64; AEntity: TBaseEntity): Int64; override;
    function Store(AEntity: TBaseEntity): Int64; override;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils,
  uZLQry.Interfaces,
  Vcl.Forms;

{ TAclRoleRepositorySQL }

class function TAclRoleRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IAclRoleSQLBuilder): IAclRoleRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TAclRoleRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IAclRoleSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FAclRoleSQLBuilder := ASQLBuilder;
  FManageTransaction := True;
end;

function TAclRoleRepositorySQL.DataSetToEntity(ADtsAclRole: TDataSet): TBaseEntity;
var
  LAclRole: TAclRole;
begin
  LAclRole := TAclRole.FromJSON(ADtsAclRole.ToJSONObjectString);
  Result := LAclRole;
end;

function TAclRoleRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FAclRoleSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TAclRoleRepositorySQL.Show(AId: Int64): TAclRole;
var
  LQry: IZLQry;
  LAclRole: TAclRole;
begin
  Result := nil;
  // Instanciar Qry
  LQry := FConn.MakeQry;

  // AclRole
  LAclRole := inherited ShowById(AId) as TAclRole;
  if not assigned(LAclRole) then
    Exit;

  Result := LAclRole;
end;

function TAclRoleRepositorySQL.Store(AEntity: TBaseEntity): Int64;
var
  LStoredId: Int64;
  LAclRole: TAclRole;
  LQry: IZLQry;
begin
  if FManageTransaction then
    FConn.StartTransaction;

  Try
    // Instanciar Qry
    LQry := FConn.MakeQry;
    LAclRole := AEntity as TAclRole;

    // AclRole
    LStoredId := inherited Store(AEntity);
    LAclRole  := AEntity as TAclRole;

    if FManageTransaction then
      FConn.CommitTransaction;
  except on E: Exception do
    Begin
      if FManageTransaction then
        FConn.RollBackTransaction;
      raise;
    End;
  end;

  Result := LStoredId;
end;

function TAclRoleRepositorySQL.Update(AId: Int64; AEntity: TBaseEntity): Int64;
var
  LAclRole: TAclRole;
  LQry: IZLQry;
begin
  if FManageTransaction then
    FConn.StartTransaction;

  Try
    // Instanciar Qry
    LQry := FConn.MakeQry;

    // AclRole
    inherited Update(AId, AEntity);
    LAclRole := AEntity as TAclRole;

    if FManageTransaction then
      FConn.CommitTransaction;
  except on E: Exception do
    Begin
      if FManageTransaction then
        FConn.RollBackTransaction;
      raise;
    End;
  end;

  Result := AId;
end;

procedure TAclRoleRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


