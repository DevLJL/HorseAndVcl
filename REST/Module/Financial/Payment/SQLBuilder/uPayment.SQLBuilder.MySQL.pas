unit uPayment.SQLBuilder.MySQL;

interface

uses
  uFilter,
  uSelectWithFilter,
  uPayment,
  uPayment.SQLBuilder.Interfaces,
  uBase.Entity,
  uPaymentTerm;

type
  TPaymentSQLBuilderMySQL = class(TInterfacedObject, IPaymentSQLBuilder)
  public
    class function Make: IPaymentSQLBuilder;
    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;

    // PaymentTerm
    function SelectPaymentsTermByPaymentId(APaymentId: Int64): String;
    function DeletePaymentsTermByPaymentId(APaymentId: Int64): String;
    function InsertPaymentTerm(APaymentTerm: TPaymentTerm): String;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  uZLConnection.Types,
  uAppRest.Types,
  uHlp,
  uQuotedStr;

{ TPaymentSQLBuilderMySQL }

function TPaymentSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM payment WHERE payment.id = %s';
  Result := Format(LSQL, [AId.ToString]);
end;

function TPaymentSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM payment WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TPaymentSQLBuilderMySQL.DeletePaymentsTermByPaymentId(APaymentId: Int64): String;
begin
  const LSQL = 'DELETE FROM payment_term WHERE payment_term.payment_id = %s';
  Result := Format(LSQL, [APaymentId.ToString]);
end;

function TPaymentSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO payment '+
               '   (name, flg_post_as_received, flg_active, flg_active_at_pos, bank_account_default_id, '+
               '    created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s)';
  const LPayment = AEntity as TPayment;

  Result := Format(LSQL, [
    Q(LPayment.name),
    Q(LPayment.flg_post_as_received),
    Q(LPayment.flg_active),
    Q(LPayment.flg_active_at_pos),
    QN(LPayment.bank_account_default_id),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LPayment.created_by_acl_user_id)
  ]);
end;

function TPaymentSQLBuilderMySQL.InsertPaymentTerm(APaymentTerm: TPaymentTerm): String;
begin
  const LSQL = ' INSERT INTO payment_term '+
               '   (payment_id, description, number_of_installments, interval_between_installments, first_in) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s) ';
  Result := Format(LSQL, [
    Q(APaymentTerm.payment_id),
    Q(APaymentTerm.description),
    Q(APaymentTerm.number_of_installments),
    Q(APaymentTerm.interval_between_installments),
    Q(APaymentTerm.first_in)
  ]);
end;

function TPaymentSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TPaymentSQLBuilderMySQL.Make: IPaymentSQLBuilder;
begin
  Result := Self.Create;
end;

function TPaymentSQLBuilderMySQL.SelectAll: String;
begin
  Result := ' SELECT '+
            '   payment.*, '+
            '   bank_account.name as bank_account_default_name, '+
            '   created_by_acl_user.name as created_by_acl_user_name, ' +
            '   updated_by_acl_user.name as updated_by_acl_user_name ' +
            ' FROM '+
            '   payment '+
            ' INNER JOIN bank_account '+
            '         ON bank_account.id = payment.bank_account_default_id ' +
            '  LEFT JOIN acl_user created_by_acl_user'+
            '         ON created_by_acl_user.id = payment.created_by_acl_user_id ' +
            '  LEFT JOIN acl_user updated_by_acl_user'+
            '         ON updated_by_acl_user.id = payment.updated_by_acl_user_id ';
end;

function TPaymentSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'payment.id', ddMySql);
end;

function TPaymentSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE payment.id = ' + AId.ToString;
end;

function TPaymentSQLBuilderMySQL.SelectPaymentsTermByPaymentId(APaymentId: Int64): String;
begin
  const LSQL = ' SELECT '+
               '   payment_term.* '+
               ' FROM '+
               '   payment_term '+
               ' WHERE '+
               '   payment_term.payment_id = %s '+
               ' ORDER BY '+
               '   payment_term.id';
  Result := Format(lSQL, [APaymentId.ToString]);
end;

function TPaymentSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE payment SET '+
               '   name = %s, '+
               '   flg_post_as_received = %s, '+
               '   flg_active = %s, '+
               '   flg_active_at_pos = %s, '+
               '   bank_account_default_id = %s, '+
               '   updated_at = %s, '+
               '   updated_by_acl_user_id = %s '+
               ' WHERE '+
               '   id = %s ';
  const LPayment = AEntity as TPayment;

  Result := Format(LSQL, [
    Q(LPayment.name),
    Q(LPayment.flg_post_as_received),
    Q(LPayment.flg_active),
    Q(LPayment.flg_active_at_pos),
    QN(LPayment.bank_account_default_id),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LPayment.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.

