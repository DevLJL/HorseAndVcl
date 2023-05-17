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

    function ScriptCreateTable: String;
    function ScriptSeedTable: String;
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

function TBankAccountSQLBuilderMySQL.ScriptCreateTable: String;
begin
  Result := ' CREATE TABLE `bank_account` ( '+
            '   `id` bigint NOT NULL AUTO_INCREMENT, '+
            '   `name` varchar(255) NOT NULL, '+
            '   `bank_id` bigint NOT NULL, '+
            '   `note` text, '+
            '   `created_at` datetime DEFAULT NULL, '+
            '   `updated_at` datetime DEFAULT NULL, '+
            '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
            '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
            '   PRIMARY KEY (`id`), '+
            '   KEY `bank_account_idx_created_at` (`created_at`), '+
            '   KEY `bank_account_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
            '   KEY `bank_account_fk_updated_by_acl_role_id` (`updated_by_acl_user_id`), '+
            '   KEY `bank_account_fk_bank_id` (`bank_id`), '+
            '   CONSTRAINT `bank_account_fk_bank_id` FOREIGN KEY (`bank_id`) REFERENCES `bank` (`id`), '+
            '   CONSTRAINT `bank_account_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
            '   CONSTRAINT `bank_account_fk_updated_by_acl_role_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`)  '+
            ' ) ';
end;

function TBankAccountSQLBuilderMySQL.ScriptSeedTable: String;
begin
  Result := 'INSERT INTO `bank_account` (`name`,`bank_id`) VALUES (''CAIXA FUNDO FIXO'',''1'');';
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

