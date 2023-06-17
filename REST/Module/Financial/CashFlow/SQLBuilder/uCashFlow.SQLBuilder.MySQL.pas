unit uCashFlow.SQLBuilder.MySQL;

interface

uses
  uSelectWithFilter,
  uCashFlow,
  uCashFlow.SQLBuilder.Interfaces,
  uBase.Entity,
  uCashFlowTransaction,
  uFilter;

type
  TCashFlowSQLBuilderMySQL = class(TInterfacedObject, ICashFlowSQLBuilder)
  public
    class function Make: ICashFlowSQLBuilder;
    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function StationInUse(AStationId: Int64; ADiffCashFlowId: Int64 = 0): String;

    // CashFlowTransaction
    function ScriptCashFlowTransactionTable: String;
    function SelectCashFlowTransactionsByCashFlowId(ACashFlowId: Int64): String;
    function DeleteCashFlowTransactionsByCashFlowId(ACashFlowId: Int64): String;
    function InsertCashFlowTransaction(ACashFlowTransaction: TCashFlowTransaction): String;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  uZLConnection.Types,
  uAppRest.Types,
  uHlp,
  DateUtils,
  uQuotedStr;

const
  DECIMAL_PLACES = 4;

{ TCashFlowSQLBuilderMySQL }

function TCashFlowSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM cash_flow WHERE id = %s';
  Result := Format(LSQL, [Q(AId)]);
end;

function TCashFlowSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM cash_flow WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TCashFlowSQLBuilderMySQL.DeleteCashFlowTransactionsByCashFlowId(ACashFlowId: Int64): String;
begin
  const LSQL = 'DELETE FROM cash_flow_transaction WHERE cash_flow_id = %s';
  Result := Format(LSQL, [Q(ACashFlowId)]);
end;

function TCashFlowSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO cash_flow '+
               '   (station_id, opening_balance_amount, final_balance_amount, opening_date, closing_note, created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s)';
  const LCashFlow = AEntity as TCashFlow;
  Result := Format(LSQL, [
    Q(LCashFlow.station_id),
    Q(LCashFlow.opening_balance_amount, DECIMAL_PLACES),
    Q(LCashFlow.final_balance_amount, DECIMAL_PLACES),
    Q(LCashFlow.opening_date, TDBDriver.dbMYSQL),
    Q(LCashFlow.closing_note),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LCashFlow.created_by_acl_user_id)
  ]);
end;

function TCashFlowSQLBuilderMySQL.InsertCashFlowTransaction(ACashFlowTransaction: TCashFlowTransaction): String;
begin
  const LSQL = ' INSERT INTO cash_flow_transaction '+
               '   (cash_flow_id, flg_manual_transaction, transaction_date, history, type, amount, payment_id, note, sale_id, person_id) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)';
  Result := Format(LSQL, [
    Q(ACashFlowTransaction.cash_flow_id),
    Q(ACashFlowTransaction.flg_manual_transaction),
    Q(ACashFlowTransaction.transaction_date, TDBDriver.dbMYSQL),
    Q(ACashFlowTransaction.history),
    Q(Ord(ACashFlowTransaction.&type)),
    Q(ACashFlowTransaction.amount, DECIMAL_PLACES),
    QN(ACashFlowTransaction.payment_id),
    Q(ACashFlowTransaction.note),
    QN(ACashFlowTransaction.sale_id),
    QN(ACashFlowTransaction.person_id)
  ]);
end;

function TCashFlowSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TCashFlowSQLBuilderMySQL.Make: ICashFlowSQLBuilder;
begin
  Result := Self.Create;
end;

function TCashFlowSQLBuilderMySQL.ScriptCashFlowTransactionTable: String;
begin
  Result := '';
end;

function TCashFlowSQLBuilderMySQL.SelectAll: String;
begin
  Result :=  ' SELECT '+
             '   cash_flow.*, '+
             '   station.name as station_name, '+
             '   created_by_acl_user.name as created_by_acl_user_name, '+
             '   updated_by_acl_user.name as updated_by_acl_user_name '+
             ' FROM '+
             '   cash_flow '+
             ' INNER JOIN station '+
             '         ON station.id = cash_flow.station_id '+
             '  LEFT JOIN acl_user created_by_acl_user '+
             '         ON created_by_acl_user.id = cash_flow.created_by_acl_user_id '+
             '  LEFT JOIN acl_user updated_by_acl_user '+
             '         ON updated_by_acl_user.id = cash_flow.updated_by_acl_user_id ';
end;

function TCashFlowSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'cash_flow.id', ddMySql);
end;

function TCashFlowSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE cash_flow.id = ' + AId.ToString;
end;

function TCashFlowSQLBuilderMySQL.SelectCashFlowTransactionsByCashFlowId(ACashFlowId: Int64): String;
begin
  const LSQL = ' SELECT '+
               '   cash_flow_transaction.*, '+
               '   payment.name as payment_name, '+
               '   person.name as person_name '+
               ' FROM '+
               '   cash_flow_transaction '+
               ' INNER JOIN payment '+
               '         ON payment.id = cash_flow_transaction.payment_id '+
               '  LEFT JOIN person '+
               '         ON person.id = cash_flow_transaction.person_id '+
               ' WHERE '+
               '   cash_flow_transaction.cash_flow_id = %s '+
               ' ORDER BY '+
               '   cash_flow_transaction.id';
  Result := Format(LSQL, [Q(ACashFlowId)]);
end;

function TCashFlowSQLBuilderMySQL.StationInUse(AStationId, ADiffCashFlowId: Int64): String;
begin
  const LSQL = ' SELECT '+
               '   cash_flow.id '+
               ' FROM '+
               '   cash_flow '+
               ' WHERE '+
               '   cash_flow.closing_date is null '+
               ' AND '+
               '   cash_flow.station_id = %s '+
               ' AND '+
               '   cash_flow.id <> %s';
  Result := Format(LSQL, [
    Q(AStationId),
    Q(ADiffCashFlowId)
  ]);
end;

function TCashFlowSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE cash_flow SET '+
               '   station_id = %s, '+
               '   opening_balance_amount = %s, '+
               '   final_balance_amount = %s, '+
               '   opening_date = %s, '+
               '   closing_note = %s, '+
               '   updated_at = %s, '+
               '   updated_by_acl_user_id = %s '+
               ' WHERE '+
               '   id = %s';
  const LCashFlow = AEntity as TCashFlow;
  Result := Format(LSQL, [
    Q(LCashFlow.station_id),
    Q(LCashFlow.opening_balance_amount, DECIMAL_PLACES),
    Q(LCashFlow.final_balance_amount, DECIMAL_PLACES),
    Q(LCashFlow.opening_date, TDBDriver.dbMYSQL),
    Q(LCashFlow.closing_note),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LCashFlow.created_by_acl_user_id),
    Q(AId)
  ]);
end;

end.

