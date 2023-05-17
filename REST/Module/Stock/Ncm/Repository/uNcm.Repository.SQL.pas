unit uNcm.Repository.SQL;

interface

uses
  uBase.Repository,
  uNcm.Repository.Interfaces,
  uNcm.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uNcm,
  uIndexResult;

type
  TNcmRepositorySQL = class(TBaseRepository, INcmRepository)
  private
    FNcmSQLBuilder: INcmSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: INcmSQLBuilder);
    function  DataSetToEntity(ADtsNcm: TDataSet): TBaseEntity; override;
    function  SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
    function  FieldExists(AColumName, AColumnValue: String; AId: Int64): Boolean;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: INcmSQLBuilder): INcmRepository;
    function Show(AId: Int64): TNcm;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils,
  uApplication.Exception, uTrans;

{ TNcmRepositorySQL }

class function TNcmRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: INcmSQLBuilder): INcmRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TNcmRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: INcmSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FNcmSQLBuilder   := ASQLBuilder;
  FManageTransaction := False;
end;

function TNcmRepositorySQL.DataSetToEntity(ADtsNcm: TDataSet): TBaseEntity;
var
  LNcm: TNcm;
begin
  LNcm := TNcm.FromJSON(ADtsNcm.ToJSONObjectString);

  // Tratar especificidades
  LNcm.created_by_acl_user.id   := ADtsNcm.FieldByName('created_by_acl_user_id').AsLargeInt;
  LNcm.created_by_acl_user.name := ADtsNcm.FieldByName('created_by_acl_user_name').AsString;
  LNcm.updated_by_acl_user.id   := ADtsNcm.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LNcm.updated_by_acl_user.name := ADtsNcm.FieldByName('updated_by_acl_user_name').AsString;

  Result := LNcm;
end;

function TNcmRepositorySQL.FieldExists(AColumName, AColumnValue: String; AId: Int64): Boolean;
begin
  Result := not FConn.MakeQry.Open(
    FNcmSQLBuilder.RegisteredFields(AColumName, AColumnValue, AId)
  ).DataSet.IsEmpty;
end;

function TNcmRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FNcmSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TNcmRepositorySQL.Show(AId: Int64): TNcm;
begin
  Result := ShowById(AId) as TNcm;
end;

procedure TNcmRepositorySQL.Validate(AEntity: TBaseEntity);
begin
  var LErrors := EmptyStr;
  const LNcm = (AEntity as TNcm);

  // CPF/CNPJ deve ser um campo único
  if not LNcm.code.Trim.IsEmpty then
  begin
    if FieldExists('ncm.code', LNcm.code, LNcm.id) then
      lErrors := lErrors + Trans.FieldWithValueIsInUse('NCM (Código)', LNcm.code) + #13;
  end;

  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);
end;

end.


