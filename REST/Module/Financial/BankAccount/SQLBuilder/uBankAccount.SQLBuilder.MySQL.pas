unit uBankAccount.SQLBuilder.MySQL;

interface

uses
  uBankAccount.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uBankAccount.Filter,
  uBase.Entity;

type
  TBankAccountSQLBuilderMySQL = class(TInterfacedObject, IBankAccountSQLBuilder)
  public
    class function Make: IBankAccountSQLBuilder;

    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;
  end;

implementation

uses
  uZLConnection.Types,
  System.SysUtils,
  uBankAccount,
  uAppRest.Types,
  uQuotedStr,
  uHlp;

{ TBankAccountSQLBuilderMySQL }

function TBankAccountSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM bank_account WHERE bank_account.id = %s';
  Result := Format(LSQL, [AId.ToString]);
end;

function TBankAccountSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM bank_account WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TBankAccountSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO bank_account '+
               '   (name, note, bank_id, created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s)';
  const LBankAccount = AEntity as TBankAccount;

  Result := Format(LSQL, [
    Q(LBankAccount.name),
    Q(LBankAccount.note),
    QN(LBankAccount.bank_id),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LBankAccount.created_by_acl_user_id)
  ]);
end;

function TBankAccountSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TBankAccountSQLBuilderMySQL.Make: IBankAccountSQLBuilder;
begin
  Result := Self.Create;
end;

function TBankAccountSQLBuilderMySQL.SelectAll: String;
begin
  Result := ' SELECT '+
            '   bank_account.*, '+
            '   bank.name as bank_name, '+
            '   created_by_acl_user.name as created_by_acl_user_name, '+
            '   updated_by_acl_user.name as updated_by_acl_user_name  '+
            ' FROM '+
            '   bank_account '+
            ' INNER JOIN bank '+
            '         ON bank.id = bank_account.bank_id '+
            ' LEFT JOIN acl_user created_by_acl_user '+
            '        ON created_by_acl_user.id = bank_account.created_by_acl_user_id '+
            ' LEFT JOIN acl_user updated_by_acl_user '+
            '        ON updated_by_acl_user.id = bank_account.updated_by_acl_user_id ';
end;

function TBankAccountSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'bank_account.id', ddMySql);
end;

function TBankAccountSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE bank_account.id = ' + AId.ToString;
end;

function TBankAccountSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE bank_account SET '+
               '   name = %s, '+
               '   note = %s, '+
               '   bank_id = %s, '+
               '   updated_at = %s, '+
               '   updated_by_acl_user_id = %s '+
               ' WHERE '+
               '   id = %s ';
  const LBankAccount = AEntity as TBankAccount;

  Result := Format(LSQL, [
    Q(LBankAccount.name),
    Q(LBankAccount.note),
    Q(LBankAccount.bank_id),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LBankAccount.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.

