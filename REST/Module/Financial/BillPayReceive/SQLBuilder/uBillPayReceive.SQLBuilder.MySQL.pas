unit uBillPayReceive.SQLBuilder.MySQL;

interface

uses
  uFilter,
  uSelectWithFilter,
  uBillPayReceive,
  criteria.query.language,
  uBillPayReceive.SQLBuilder.Interfaces,
  uBase.Entity;


type
  TBillPayReceiveSQLBuilderMySQL = class(TInterfacedObject, IBillPayReceiveSQLBuilder)
  public
    class function Make: IBillPayReceiveSQLBuilder;
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
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  uZLConnection.Types,
  uAppRest.Types,
  uHlp,
  uQuotedStr;

const
  DECIMAL_PLACES = 4;

{ TBillPayReceiveSQLBuilderMySQL }

function TBillPayReceiveSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM bill_pay_receive WHERE id = %s';
  Result := Format(LSQL, [Q(AId)]);
end;

function TBillPayReceiveSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM bill_pay_receive WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TBillPayReceiveSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO bill_pay_receive '+
               '   (batch, type, short_description, person_id, chart_of_account_id, cost_center_id, bank_account_id, '+
               '    payment_id, due_date, installment_quantity, installment_number, amount, discount, interest_and_fine, '+
               '    net_amount, status, payment_date, note, sale_id, created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)';
  const LBillPayReceive = AEntity as TBillPayReceive;

  Result := Format(LSQL, [
    Q(LBillPayReceive.batch),
    Q(Ord(LBillPayReceive.&type)),
    Q(LBillPayReceive.short_description),
    QN(LBillPayReceive.person_id),
    QN(LBillPayReceive.chart_of_account_id),
    QN(LBillPayReceive.cost_center_id),
    QN(LBillPayReceive.bank_account_id),
    QN(LBillPayReceive.payment_id),
    Q(LBillPayReceive.due_date, TDBDriver.dbMYSQL),
    Q(LBillPayReceive.installment_quantity),
    Q(LBillPayReceive.installment_number),
    Q(LBillPayReceive.amount, DECIMAL_PLACES),
    Q(LBillPayReceive.discount, DECIMAL_PLACES),
    Q(LBillPayReceive.interest_and_fine, DECIMAL_PLACES),
    Q(LBillPayReceive.net_amount, DECIMAL_PLACES),
    Q(Ord(LBillPayReceive.status)),
    Q(LBillPayReceive.payment_date, TDBDriver.dbMYSQL),
    Q(LBillPayReceive.note),
    QN(LBillPayReceive.sale_id),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LBillPayReceive.created_by_acl_user_id)
  ]);
end;

function TBillPayReceiveSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TBillPayReceiveSQLBuilderMySQL.Make: IBillPayReceiveSQLBuilder;
begin
  Result := Self.Create;
end;

function TBillPayReceiveSQLBuilderMySQL.ScriptCreateTable: String;
begin
  Result := ' CREATE TABLE `bill_pay_receive` ( '+
            '   `id` bigint NOT NULL AUTO_INCREMENT, '+
            '   `batch` varchar(36) NOT NULL, '+
            '   `type` tinyint(4) DEFAULT NULL COMMENT ''[0..1] 0-Débito, 1-Crédito'', '+
            '   `short_description` varchar(100) NOT NULL, '+
            '   `person_id` bigint DEFAULT NULL, '+
            '   `chart_of_account_id` bigint DEFAULT NULL, '+
            '   `cost_center_id` bigint DEFAULT NULL, '+
            '   `bank_account_id` bigint NOT NULL, '+
            '   `payment_id` bigint NOT NULL, '+
            '   `due_date` date NOT NULL, '+
            '   `installment_quantity` tinyint(4) NOT NULL, '+
            '   `installment_number` tinyint(4) NOT NULL, '+
            '   `amount` decimal(18,4) NOT NULL, '+
            '   `discount` decimal(18,4) DEFAULT NULL, '+
            '   `interest_and_fine` decimal(18,4) DEFAULT NULL, '+
            '   `net_amount` decimal(18,4) NOT NULL, '+
            '   `status` tinyint(4) NOT NULL COMMENT ''[0..2] 0-Pendente, 1-Aprovada, 2-Cancelada'', '+
            '   `payment_date` date DEFAULT NULL, '+
            '   `note` text, '+
            '   `sale_id` bigint DEFAULT NULL, '+
            '   `created_at` datetime DEFAULT NULL, '+
            '   `updated_at` datetime DEFAULT NULL, '+
            '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
            '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
            '   PRIMARY KEY (`id`), '+
            '   KEY `bill_pay_receive_idx_created_at` (`created_at`), '+
            '   KEY `bill_pay_receive_idx_batch` (`batch`), '+
            '   KEY `bill_pay_receive_idx_type` (`type`), '+
            '   KEY `bill_pay_receive_idx_due_date` (`due_date`), '+
            '   KEY `bill_pay_receive_idx_status` (`status`), '+
            '   KEY `bill_pay_receive_idx_payment_date` (`payment_date`), '+
            '   KEY `bill_pay_receive_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
            '   KEY `bill_pay_receive_fk_updated_by_acl_role_id` (`updated_by_acl_user_id`), '+
            '   KEY `bill_pay_receive_fk_person_id` (`person_id`), '+
            '   KEY `bill_pay_receive_fk_chart_of_account_id` (`chart_of_account_id`), '+
            '   KEY `bill_pay_receive_fk_cost_center_id` (`cost_center_id`), '+
            '   KEY `bill_pay_receive_fk_bank_account_id` (`bank_account_id`), '+
            '   KEY `bill_pay_receive_fk_payment_id` (`payment_id`), '+
            '   KEY `bill_pay_receive_fk_sale_id` (`sale_id`), '+
            '   CONSTRAINT `bill_pay_receive_fk_bank_account_id` FOREIGN KEY (`bank_account_id`) REFERENCES `bank_account` (`id`) , '+
            '   CONSTRAINT `bill_pay_receive_fk_chart_of_account_id` FOREIGN KEY (`chart_of_account_id`) REFERENCES `chart_of_account` (`id`) , '+
            '   CONSTRAINT `bill_pay_receive_fk_cost_center_id` FOREIGN KEY (`cost_center_id`) REFERENCES `cost_center` (`id`) , '+
            '   CONSTRAINT `bill_pay_receive_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`) , '+
            '   CONSTRAINT `bill_pay_receive_fk_payment_id` FOREIGN KEY (`payment_id`) REFERENCES `payment` (`id`) , '+
            '   CONSTRAINT `bill_pay_receive_fk_person_id` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`) , '+
            '   CONSTRAINT `bill_pay_receive_fk_sale_id` FOREIGN KEY (`sale_id`) REFERENCES `sale` (`id`) , '+
            '   CONSTRAINT `bill_pay_receive_fk_updated_by_acl_role_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`)  '+
            ' ) ';
end;

function TBillPayReceiveSQLBuilderMySQL.ScriptSeedTable: String;
begin
  Result := '';
end;

function TBillPayReceiveSQLBuilderMySQL.SelectAll: String;
begin
  Result := ' SELECT '+
            '   bill_pay_receive.*, '+
            '   person.name as person_name, '+
            '   chart_of_account.name as chart_of_account_name, '+
            '   cost_center.name as cost_center_name, '+
            '   bank_account.name as bank_account_name, '+
            '   payment.name as payment_name, '+
            '   created_by_acl_user.name as created_by_acl_user_name, '+
            '   updated_by_acl_user.name as updated_by_acl_user_name '+
            ' FROM '+
            '   bill_pay_receive '+
            ' LEFT JOIN person '+
            '        ON person.id = bill_pay_receive.person_id '+
            ' LEFT JOIN chart_of_account '+
            '        ON chart_of_account.id = bill_pay_receive.chart_of_account_id '+
            ' LEFT JOIN cost_center '+
            '        ON cost_center.id = bill_pay_receive.cost_center_id '+
            ' INNER JOIN bank_account '+
            '         ON bank_account.id = bill_pay_receive.bank_account_id '+
            ' INNER JOIN payment '+
            '         ON payment.id = bill_pay_receive.payment_id '+
            '  LEFT JOIN acl_user created_by_acl_user '+
            '         ON created_by_acl_user.id = bill_pay_receive.created_by_acl_user_id '+
            '  LEFT JOIN acl_user updated_by_acl_user '+
            '         ON updated_by_acl_user.id = bill_pay_receive.updated_by_acl_user_id ';
end;

function TBillPayReceiveSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'bill_pay_receive.id', ddMySql);
end;

function TBillPayReceiveSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE bill_pay_receive.id = ' + AId.ToString;
end;

function TBillPayReceiveSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE bill_pay_receive SET '+
               '   batch = %s, '+
               '   type = %s, '+
               '   short_description = %s, '+
               '   person_id = %s, '+
               '   chart_of_account_id = %s, '+
               '   cost_center_id = %s, '+
               '   bank_account_id = %s, '+
               '   payment_id = %s, '+
               '   due_date = %s, '+
               '   installment_quantity = %s, '+
               '   installment_number = %s, '+
               '   amount = %s, '+
               '   discount = %s, '+
               '   interest_and_fine = %s, '+
               '   net_amount = %s, '+
               '   status = %s, '+
               '   payment_date = %s, '+
               '   note = %s, '+
               '   sale_id = %s, '+
               '   updated_at = %s, '+
               '   updated_by_acl_user_id = %s '+
               ' WHERE '+
               '   id = %s ';
  const LBillPayReceive = AEntity as TBillPayReceive;

  Result := Format(LSQL, [
    Q(LBillPayReceive.batch),
    Q(Ord(LBillPayReceive.&type)),
    Q(LBillPayReceive.short_description),
    QN(LBillPayReceive.person_id),
    QN(LBillPayReceive.chart_of_account_id),
    QN(LBillPayReceive.cost_center_id),
    QN(LBillPayReceive.bank_account_id),
    QN(LBillPayReceive.payment_id),
    Q(LBillPayReceive.due_date, TDBDriver.dbMYSQL),
    Q(LBillPayReceive.installment_quantity),
    Q(LBillPayReceive.installment_number),
    Q(LBillPayReceive.amount, DECIMAL_PLACES),
    Q(LBillPayReceive.discount, DECIMAL_PLACES),
    Q(LBillPayReceive.interest_and_fine, DECIMAL_PLACES),
    Q(LBillPayReceive.net_amount, DECIMAL_PLACES),
    Q(Ord(LBillPayReceive.status)),
    Q(LBillPayReceive.payment_date, TDBDriver.dbMYSQL),
    Q(LBillPayReceive.note),
    QN(LBillPayReceive.sale_id),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LBillPayReceive.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.

