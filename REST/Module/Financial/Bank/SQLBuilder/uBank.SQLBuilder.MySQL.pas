unit uBank.SQLBuilder.MySQL;

interface

uses
  uBank.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uBank.Filter,
  uBase.Entity;

type
  TBankSQLBuilderMySQL = class(TInterfacedObject, IBankSQLBuilder)
  public
    class function Make: IBankSQLBuilder;

    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;
    function RegisteredFields(AColumName, AColumnValue: String; AId: Int64): String;
  end;

implementation

uses
  uZLConnection.Types,
  System.SysUtils,
  uBank,
  uAppRest.Types,
  uQuotedStr,
  uHlp,
  uSmartPointer,
  System.Classes;

{ TBankSQLBuilderMySQL }

function TBankSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM bank WHERE bank.id = %s';
  Result := Format(LSQL, [AId.ToString]);
end;

function TBankSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM bank WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TBankSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO bank '+
               '   (name, code, created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s, %s)';
  const LBank = AEntity as TBank;

  Result := Format(LSQL, [
    Q(LBank.name),
    Q(LBank.code),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LBank.created_by_acl_user_id)
  ]);
end;

function TBankSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TBankSQLBuilderMySQL.Make: IBankSQLBuilder;
begin
  Result := Self.Create;
end;

function TBankSQLBuilderMySQL.RegisteredFields(AColumName, AColumnValue: String; AId: Int64): String;
begin
  const LSQL = 'SELECT %s FROM bank WHERE %s = %s AND bank.id <> %s';
  Result := Format(LSQL, [
    AColumName,
    AColumName,
    Q(AColumnValue),
    AId.ToString
  ]);
end;

function TBankSQLBuilderMySQL.SelectAll: String;
begin
  Result := ' SELECT '+
            '   bank.*, '+
            '   created_by_acl_user.name as created_by_acl_user_name, '+
            '   updated_by_acl_user.name as updated_by_acl_user_name  '+
            ' FROM '+
            '   bank '+
            ' LEFT JOIN acl_user created_by_acl_user '+
            '        ON created_by_acl_user.id = bank.created_by_acl_user_id '+
            ' LEFT JOIN acl_user updated_by_acl_user '+
            '        ON updated_by_acl_user.id = bank.updated_by_acl_user_id ';
end;

function TBankSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'bank.id', ddMySql);
end;

function TBankSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE bank.id = ' + AId.ToString;
end;

function TBankSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE bank SET '+
               '   name = %s, '+
               '   code = %s, '+
               '   updated_at = %s, '+
               '   updated_by_acl_user_id = %s '+
               ' WHERE '+
               '   id = %s ';
  const LBank = AEntity as TBank;

  Result := Format(LSQL, [
    Q(LBank.name),
    Q(LBank.code),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LBank.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.
