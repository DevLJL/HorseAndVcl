unit uPayment.SQLBuilder.MySQL;

interface

uses
  uFilter,
  uSelectWithFilter,
  uPayment,
  criteria.query.language,
  uPayment.SQLBuilder.Interfaces,
  uBase.Entity,
  uPaymentTerm;

type
  TPaymentSQLBuilderMySQL = class(TInterfacedObject, IPaymentSQLBuilder)
  public
    class function Make: IPaymentSQLBuilder;
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

    // PaymentTerm
    function ScriptCreatePaymentTermTable: String;
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

function TPaymentSQLBuilderMySQL.ScriptCreatePaymentTermTable: String;
begin
  Result := ' CREATE TABLE `payment_term` ( '+
            ' `id` bigint NOT NULL AUTO_INCREMENT, '+
            ' `payment_id` bigint NOT NULL, '+
            ' `description` varchar(255) DEFAULT NULL, '+
            ' `number_of_installments` smallint DEFAULT NULL, '+
            ' `interval_between_installments` smallint DEFAULT NULL, '+
            ' `first_in` smallint DEFAULT NULL, '+
            ' PRIMARY KEY (`id`), '+
            ' KEY `payment_term_fk_payment_id` (`payment_id`), '+
            ' CONSTRAINT `payment_term_fk_payment_id` FOREIGN KEY (`payment_id`) REFERENCES `payment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE '+
            ' ) ';
end;

function TPaymentSQLBuilderMySQL.ScriptCreateTable: String;
begin
  Result := ' CREATE TABLE `payment` ( '+
            '   `id` bigint NOT NULL AUTO_INCREMENT, '+
            '   `name` varchar(100) NOT NULL, '+
            '   `flg_post_as_received` tinyint(4) DEFAULT NULL, '+
            '   `flg_active` tinyint(4) DEFAULT NULL, '+
            '   `flg_active_at_pos` tinyint(4) DEFAULT NULL, '+
            '   `bank_account_default_id` bigint NOT NULL, '+
            '   `created_at` datetime DEFAULT NULL, '+
            '   `updated_at` datetime DEFAULT NULL, '+
            '   `created_by_acl_user_id` bigint DEFAULT NULL, '+
            '   `updated_by_acl_user_id` bigint DEFAULT NULL, '+
            '   PRIMARY KEY (`id`), '+
            '   KEY `payment_idx_created_at` (`created_at`), '+
            '   KEY `payment_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
            '   KEY `payment_fk_updated_by_acl_role_id` (`updated_by_acl_user_id`), '+
            '   KEY `payment_fk_bank_account_default_id` (`bank_account_default_id`), '+
            '   CONSTRAINT `payment_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
            '   CONSTRAINT `payment_fk_updated_by_acl_role_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
            '   CONSTRAINT `payment_fk_bank_account_default_id` FOREIGN KEY (`bank_account_default_id`) REFERENCES `bank_account` (`id`) '+
            ' ) ';
end;

function TPaymentSQLBuilderMySQL.ScriptSeedTable: String;
begin
  // Payment
  Result := ' INSERT INTO `payment` (`id`,`name`,`flg_post_as_received`,`flg_active`,`flg_active_at_pos`,`bank_account_default_id`) VALUES (1,''Dinheiro'',1,1,0,1); '+
            ' INSERT INTO `payment` (`id`,`name`,`flg_post_as_received`,`flg_active`,`flg_active_at_pos`,`bank_account_default_id`) VALUES (2,''Cartão de Débito'',1,1,0,1); '+
            ' INSERT INTO `payment` (`id`,`name`,`flg_post_as_received`,`flg_active`,`flg_active_at_pos`,`bank_account_default_id`) VALUES (3,''Cartão de Crédito'',1,1,0,1); '+
            ' INSERT INTO `payment` (`id`,`name`,`flg_post_as_received`,`flg_active`,`flg_active_at_pos`,`bank_account_default_id`) VALUES (4,''Cheque'',1,1,0,1); '+
            ' INSERT INTO `payment` (`id`,`name`,`flg_post_as_received`,`flg_active`,`flg_active_at_pos`,`bank_account_default_id`) VALUES (5,''Prazo'',0,1,0,1); '+
            ' INSERT INTO `payment` (`id`,`name`,`flg_post_as_received`,`flg_active`,`flg_active_at_pos`,`bank_account_default_id`) VALUES (6,''Boleto'',0,1,0,1); '+
            ' INSERT INTO `payment` (`id`,`name`,`flg_post_as_received`,`flg_active`,`flg_active_at_pos`,`bank_account_default_id`) VALUES (7,''Ticket Troca'',1,1,0,1); ';

  // PaymentTerm
  Result := Result +
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''A VISTA'',1,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''02X'',2,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''03X'',3,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''04X'',4,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''05X'',5,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''06X'',6,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''07X'',7,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''08X'',8,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''09X'',9,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''10X'',10,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''11X'',11,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (3,''12X'',12,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (2,''A VISTA'',1,0,0); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (1,''A VISTA'',1,0,0); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (4,''A VISTA'',1,0,0); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (4,''30 DIAS'',1,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''30 DIAS'',1,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''02X'',2,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''03X'',3,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''04X'',4,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''05X'',5,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''06X'',6,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''07X'',7,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''08X'',8,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''09X'',9,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''10X'',10,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''11X'',11,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (5,''12X'',12,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (6,''05 DIAS'',1,5,5); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (6,''10 DIAS'',1,10,10); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (6,''15 DIAS'',1,15,15); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (6,''20 DIAS'',1,20,20); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (6,''25 DIAS'',1,25,25); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (6,''30 DIAS'',1,30,30); '+
            ' INSERT INTO `payment_term` (`payment_id`,`description`,`number_of_installments`,`interval_between_installments`,`first_in`) VALUES (7,''A VISTA'',1,0,0); ';
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

