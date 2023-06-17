unit uCity.SQLBuilder.MySQL;

interface

uses
  uCity.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uCity.Filter,
  uBase.Entity;

type
  TCitySQLBuilderMySQL = class(TInterfacedObject, ICitySQLBuilder)
  public
    class function Make: ICitySQLBuilder;

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
  uCity,
  uAppRest.Types,
  uQuotedStr,
  uHlp,
  uSmartPointer,
  System.Classes;

{ TCitySQLBuilderMySQL }

function TCitySQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM city WHERE city.id = %s';
  Result := Format(LSQL, [AId.ToString]);
end;

function TCitySQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM city WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TCitySQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO city '+
               '   (name, state, country, ibge_code, country_ibge_code, identification, created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s, %s)';
  const LCity = AEntity as TCity;

  Result := Format(LSQL, [
    Q(LCity.name),
    Q(LCity.state),
    Q(LCity.country),
    Q(LCity.ibge_code),
    Q(LCity.country_ibge_code),
    Q(LCity.identification),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LCity.created_by_acl_user_id)
  ]);
end;

function TCitySQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TCitySQLBuilderMySQL.Make: ICitySQLBuilder;
begin
  Result := Self.Create;
end;



function TCitySQLBuilderMySQL.SelectAll: String;
begin
  Result :=  ' SELECT '+
             '   city.*, '+
             '   created_by_acl_user.name as created_by_acl_user_name, '+
             '   updated_by_acl_user.name as updated_by_acl_user_name  '+
             ' FROM '+
             '   city '+
             ' LEFT JOIN acl_user created_by_acl_user '+
             '        ON created_by_acl_user.id = city.created_by_acl_user_id '+
             ' LEFT JOIN acl_user updated_by_acl_user '+
             '        ON updated_by_acl_user.id = city.updated_by_acl_user_id ';
end;

function TCitySQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'city.id', ddMySql);
end;

function TCitySQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE city.id = ' + AId.ToString;
end;

function TCitySQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE city SET '+
               '   name = %s, '+
               '   state = %s, '+
               '   country = %s, '+
               '   ibge_code = %s, '+
               '   country_ibge_code = %s, '+
               '   identification = %s, '+
               '   updated_at = %s, '+
               '   updated_by_acl_user_id = %s '+
               ' WHERE '+
               '   id = %s ';
  const LCity = AEntity as TCity;

  Result := Format(LSQL, [
    Q(LCity.name),
    Q(LCity.state),
    Q(LCity.country),
    Q(LCity.ibge_code),
    Q(LCity.country_ibge_code),
    Q(LCity.identification),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LCity.created_by_acl_user_id),
    Q(AId)
  ]);
end;

end.

