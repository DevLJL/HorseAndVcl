unit uBankAccount.Repository.SQL;

interface

uses
  uBase.Repository,
  uBankAccount.Repository.Interfaces,
  uBankAccount.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uBankAccount,
  uIndexResult;

type
  TBankAccountRepositorySQL = class(TBaseRepository, IBankAccountRepository)
  private
    FBankAccountSQLBuilder: IBankAccountSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IBankAccountSQLBuilder);
    function DataSetToEntity(ADtsBankAccount: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IBankAccountSQLBuilder): IBankAccountRepository;
    function Show(AId: Int64): TBankAccount;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TBankAccountRepositorySQL }

class function TBankAccountRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IBankAccountSQLBuilder): IBankAccountRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TBankAccountRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IBankAccountSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FBankAccountSQLBuilder   := ASQLBuilder;
  FManageTransaction := False;
end;

function TBankAccountRepositorySQL.DataSetToEntity(ADtsBankAccount: TDataSet): TBaseEntity;
var
  LBankAccount: TBankAccount;
begin
  LBankAccount := TBankAccount.FromJSON(ADtsBankAccount.ToJSONObjectString);

  // Tratar especificidades
  LBankAccount.created_by_acl_user.id   := ADtsBankAccount.FieldByName('created_by_acl_user_id').AsLargeInt;
  LBankAccount.created_by_acl_user.name := ADtsBankAccount.FieldByName('created_by_acl_user_name').AsString;
  LBankAccount.updated_by_acl_user.id   := ADtsBankAccount.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LBankAccount.updated_by_acl_user.name := ADtsBankAccount.FieldByName('updated_by_acl_user_name').AsString;
  LBankAccount.bank.id                  := ADtsBankAccount.FieldByName('bank_id').AsLargeInt;
  LBankAccount.bank.name                := ADtsBankAccount.FieldByName('bank_name').AsString;

  Result := LBankAccount;
end;

function TBankAccountRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FBankAccountSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TBankAccountRepositorySQL.Show(AId: Int64): TBankAccount;
begin
  Result := ShowById(AId) as TBankAccount;
end;

procedure TBankAccountRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


