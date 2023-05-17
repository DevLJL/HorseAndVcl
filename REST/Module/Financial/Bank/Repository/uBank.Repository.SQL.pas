unit uBank.Repository.SQL;

interface

uses
  uBase.Repository,
  uBank.Repository.Interfaces,
  uBank.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uBank,
  uIndexResult;

type
  TBankRepositorySQL = class(TBaseRepository, IBankRepository)
  private
    FBankSQLBuilder: IBankSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IBankSQLBuilder);
    function DataSetToEntity(ADtsBank: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
    function FieldExists(AColumName, AColumnValue: String; AId: Int64): Boolean;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IBankSQLBuilder): IBankRepository;
    function Show(AId: Int64): TBank;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils, uTrans, uApplication.Exception;

{ TBankRepositorySQL }

class function TBankRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IBankSQLBuilder): IBankRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TBankRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IBankSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FBankSQLBuilder   := ASQLBuilder;
  FManageTransaction := False;
end;

function TBankRepositorySQL.DataSetToEntity(ADtsBank: TDataSet): TBaseEntity;
var
  LBank: TBank;
begin
  LBank := TBank.FromJSON(ADtsBank.ToJSONObjectString);

  // Tratar especificidades
  LBank.created_by_acl_user.id   := ADtsBank.FieldByName('created_by_acl_user_id').AsLargeInt;
  LBank.created_by_acl_user.name := ADtsBank.FieldByName('created_by_acl_user_name').AsString;
  LBank.updated_by_acl_user.id   := ADtsBank.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LBank.updated_by_acl_user.name := ADtsBank.FieldByName('updated_by_acl_user_name').AsString;

  Result := LBank;
end;

function TBankRepositorySQL.FieldExists(AColumName, AColumnValue: String; AId: Int64): Boolean;
begin
  Result := not FConn.MakeQry.Open(
    FBankSQLBuilder.RegisteredFields(AColumName, AColumnValue, AId)
  ).DataSet.IsEmpty;
end;

function TBankRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FBankSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TBankRepositorySQL.Show(AId: Int64): TBank;
begin
  Result := ShowById(AId) as TBank;
end;

procedure TBankRepositorySQL.Validate(AEntity: TBaseEntity);
begin
  var LErrors := EmptyStr;
  const LBank = AEntity as TBank;

  // Verificar se code já existe
  if not LBank.code.Trim.IsEmpty then
  begin
    if FieldExists('bank.code', LBank.code, LBank.id) then
      LErrors := LErrors + Trans.FieldWithValueIsInUse('Código do banco', LBank.code) + #13;
  end;

  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);
end;

end.


