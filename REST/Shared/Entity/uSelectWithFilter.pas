unit uSelectWithFilter;

interface

uses

  uZLConnection.Types,
  uFilter;

type
  TOutPutSelectAlLFilter = record
    SQL: String;
    SQLWithoutPaginate: String;
  end;

  TSelectWithFilter = class
    class function SelectAllWithFilter(
      AFilter: IFilter;
      ASelectAll: String;
      APKName: String;
      ADriverDB: TZLDriverDB = ddMySql;
      AAdditionalExpression: String = ''
    ): TOutPutSelectAlLFilter;
  end;

implementation

uses
  System.SysUtils,
  uHlp;

{ TSelectWithFilter }

class function TSelectWithFilter.SelectAllWithFilter(
  AFilter: IFilter;
  ASelectAll, APKName: String;
  ADriverDB: TZLDriverDB;
  AAdditionalExpression: String
): TOutPutSelectAlLFilter;
const
  L_SQL_KEYS: TArray<String> = [' FROM ',' ORDER BY ',' WHERE ',' AND ', ' OR '];
var
  lSQL: String;
  lColumns, lLimitPerPage, lSkipRecords: String;
  lCurrentPage: Integer;
  lSQLWithoutPaginate: String;
  lSQLKey: String;
begin
  lSQL := ASelectAll;
  for lSQLKey in L_SQL_KEYS do
    lSQL := StringReplace(lSQL, lSQLKey, lSQLKey.ToLower, [rfReplaceAll]);

  if not Assigned(AFilter) then
  begin
    Result.SQL := lSQL;
    Result.SQLWithoutPaginate := lSQL;
    Exit;
  end;

  lColumns      := AFilter.Columns.Trim.ToLower;
  lLimitPerPage := AFilter.LimitPerPage.ToString;
  lCurrentPage  := iif((AFilter.CurrentPage <= 0), 1, AFilter.CurrentPage);
  lSkipRecords  := ((lCurrentPage - 1) * AFilter.LimitPerPage).ToString;

  // Evitar erros
  if (lLimitPerPage = '0') then lLimitPerPage := '50';
  if (lCurrentPage = 0)    then lCurrentPage  := 1;

  // Colunas a serem exibidas
  if not lColumns.Trim.IsEmpty then
    lSQL := 'select ' + lColumns + ' ' + copy(lSQL, Pos('from', lSQL));

  // Adicionar expressão
  lSQL := lSQL + ' WHERE ' + APKName + ' is not null ';
  lSQL := lSQL + ' ' + AFilter.GetExpression;
  if not AAdditionalExpression.Trim.IsEmpty then
    lSQL := lSQL + ' ' + AAdditionalExpression;

  // Adicionar WherePkIn
  if not AFilter.WherePkIn.Trim.IsEmpty then
    lSQL := lSQL + ' AND ' + APKName + ' in (' + AFilter.WherePkIn + ')';

  // Adicionar Ordenação
  lSQL := lSQL + ' order by ' + iif(
    AFilter.orderBy.Trim.IsEmpty,
    APKName,
    AFilter.orderBy.Trim
  );

  // Limit e Skip
  lSQLWithoutPaginate       := lSQL;
  Result.SQL                := lSQL + ' limit '+lLimitPerPage+' offset '+lSkipRecords+' ';
  Result.SQLWithoutPaginate := lSQLWithoutPaginate;
end;

end.
