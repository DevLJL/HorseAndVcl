unit uStation.SQLBuilder.MySQL;

interface

uses
  uStation.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uStation.Filter,
  uBase.Entity;

type
  TStationSQLBuilderMySQL = class(TInterfacedObject, IStationSQLBuilder)
  public
    class function Make: IStationSQLBuilder;

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
  uStation,
  uAppRest.Types,
  uQuotedStr,
  uHlp;

{ TStationSQLBuilderMySQL }

function TStationSQLBuilderMySQL.DeleteById(AId: Int64): String;
const
  LSQL = 'DELETE FROM station WHERE station.id = %s';
begin
  Result := Format(LSQL, [AId.ToString]);
end;

function TStationSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
const
  LSQL = 'DELETE FROM station WHERE id in (%s)';
begin
  Result := Format(LSQL, [AId]);
end;

function TStationSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
const
  LSQL = ' INSERT INTO station '+
         '   (name) '+
         ' VALUES '+
         '   (%s)';
var
  LStation: TStation;
begin
  LStation := AEntity as TStation;

  Result := Format(LSQL, [
    Q(LStation.name)
  ]);
end;

function TStationSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TStationSQLBuilderMySQL.Make: IStationSQLBuilder;
begin
  Result := Self.Create;
end;

function TStationSQLBuilderMySQL.SelectAll: String;
const
  LSQL = ' SELECT '+
         '   station.* '+
         ' FROM '+
         '   station ';
begin
  Result := LSQL;
end;

function TStationSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'station.id', ddMySql);
end;

function TStationSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE station.id = ' + AId.ToString;
end;

function TStationSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
const
  LSQL = ' UPDATE station SET '+
         '   name = %s '+
         ' WHERE '+
         '   id = %s ';
var
  LStation: TStation;
begin
  LStation := AEntity as TStation;

  Result := Format(LSQL, [
    Q(LStation.name),
    Q(AId)
  ]);
end;

end.
