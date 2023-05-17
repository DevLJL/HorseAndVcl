unit uAclUser.SQLBuilder.MySQL;

interface

uses
  uAclUser.SQLBuilder.Interfaces,
  uBase.Entity,
  uFilter,
  uSelectWithFilter;

type
  TAclUserSQLBuilderMySQL = class(TInterfacedObject, IAclUserSQLBuilder)
  public
    class function Make: IAclUserSQLBuilder;
    function ScriptCreateTable: String;
    function ScriptSeedTable: String;
    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function ShowByLoginAndPassword(ALogin, APassword: String): String;
  end;

implementation

uses
  uHlp,
  uAppRest.Types,
  System.SysUtils,
  uAclUser,
  uQuotedStr,
  uZLConnection.Types;

{ TAclUserSQLBuilderMySQL }

function TAclUserSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM acl_user WHERE acl_user = %s';
  Result := Format(LSQL, [
    AId.ToString
  ]);
end;

function TAclUserSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM acl_user WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TAclUserSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO acl_user '+
               '   (name, login, login_password, acl_role_id, seller_id, flg_superuser, last_token, last_expiration) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s, %s)';
  const LAclUser = AEntity as TAclUser;

  Result := Format(LSQL, [
    Q(LAclUser.name),
    Q(LAclUser.login),
    Q(Encrypt(ENCRYPTATION_KEY, LAclUser.login_password)),
    Q(LAclUser.acl_role_id),
    QN(LAclUser.seller_id),
    Q(LAclUser.flg_superuser),
    Q(LAclUser.last_token),
    Q(LAclUser.last_expiration, TDBDriver.dbMYSQL)
  ]);
end;

function TAclUserSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TAclUserSQLBuilderMySQL.Make: IAclUserSQLBuilder;
begin
  Result := Self.Create;
end;

function TAclUserSQLBuilderMySQL.ScriptCreateTable: String;
begin
  Result := ' CREATE TABLE `acl_user` (                                                                       '+
            '   `id` bigint NOT NULL AUTO_INCREMENT,                                                          '+
            '   `name` varchar(100) NOT NULL,                                                                 '+
            '   `login` varchar(100) NOT NULL,                                                                '+
            '   `login_password` varchar(100) NOT NULL,                                                       '+
            '   `acl_role_id` bigint NOT NULL,                                                                '+
            '   `flg_superuser` tinyint(4) DEFAULT NULL,                                                      '+
            '   `seller_id` bigint DEFAULT NULL,                                                              '+
            '   `last_token` text,                                                                            '+
            '   `last_expiration` datetime DEFAULT NULL,                                                      '+
            '   PRIMARY KEY (`id`),                                                                           '+
            '   UNIQUE KEY `login_UNIQUE` (`login`),                                                          '+
            '   KEY `acl_user_fk_acl_role_id` (`acl_role_id`),                                                '+
            '   CONSTRAINT `acl_user_fk_acl_role_id` FOREIGN KEY (`acl_role_id`) REFERENCES `acl_role` (`id`) '+
            ' )                                                                                               ';
end;

function TAclUserSQLBuilderMySQL.ScriptSeedTable: String;
begin
  const LSQL = ' INSERT INTO acl_user '+
               '   (name, login, login_password, acl_role_id, flg_superuser) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s)';

  Result := Format(LSQL, [
    Q('lead'),
    Q('lead'),
    Q(Encrypt(ENCRYPTATION_KEY, 'lead321')),
    Q(1),
    Q(1)
  ]);
end;

function TAclUserSQLBuilderMySQL.SelectAll: String;
begin
  Result := ' SELECT '+
            '   acl_user.*, '+
            '   acl_role.name AS acl_role_name, '+
            '   person.name AS seller_name '+
            ' FROM '+
            '   acl_user '+
            ' INNER JOIN acl_role '+
            '         ON acl_role.id = acl_user.acl_role_id '+
            '  LEFT JOIN person '+
            '         ON person.id = acl_user.seller_id ';
end;

function TAclUserSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'acl_role.id', ddMySql);
end;

function TAclUserSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE acl_user.id = ' + AId.ToString;
end;

function TAclUserSQLBuilderMySQL.ShowByLoginAndPassword(ALogin, APassword: String): String;
begin
  Result := SelectAll + ' WHERE acl_user.login = ' + QuotedStr(ALogin) + ' and acl_user.login_password = ' + QuotedStr(APassword);
end;

function TAclUserSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE acl_user SET '+
               '   name = %s, '+
               '   login = %s, '+
               '   login_password = %s, '+
               '   acl_role_id = %s, '+
               '   seller_id = %s, '+
               '   flg_superuser = %s, '+
               '   last_token = %s, '+
               '   last_expiration = %s '+
               ' WHERE '+
               '   id = %s ';
  const LAclUser = AEntity as TAclUser;

  Result   := Format(LSQL, [
    Q(LAclUser.name),
    Q(LAclUser.login),
    Q(Encrypt(ENCRYPTATION_KEY, LAclUser.login_password)),
    Q(LAclUser.acl_role_id),
    iif(LAclUser.seller_id <= 0, 'Null', Q(LAclUser.seller_id)),
    Q(LAclUser.flg_superuser),
    Q(LAclUser.last_token),
    Q(LAclUser.last_expiration, TDBDriver.dbMYSQL),
    Q(AId.ToString)
  ]);
end;

end.
