unit uSale.SQLBuilder.MySQL;

interface

uses
  uFilter,
  uSelectWithFilter,
  uSale,
  criteria.query.language,
  uSale.SQLBuilder.Interfaces,
  uBase.Entity,
  uSaleItem,
  uSalepayment;

type
  TSaleSQLBuilderMySQL = class(TInterfacedObject, ISaleSQLBuilder)
  public
    class function Make: ISaleSQLBuilder;

    // Sale
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
    function SQLForReport(ASaleId: Int64): TSQLForReportOutput;

    // SaleItem
    function ScriptCreateSaleItemTable: String;
    function SelectSaleItemsBySaleId(ASaleId: Int64): String;
    function DeleteSaleItemsBySaleId(ASaleId: Int64): String;
    function InsertSaleItem(ASaleItem: TSaleItem): String;

    // SalePayment
    function ScriptCreateSalePaymentTable: String;
    function SelectSalePaymentsBySaleId(ASaleId: Int64): String;
    function DeleteSalePaymentsBySaleId(ASaleId: Int64): String;
    function InsertSalePayment(ASalePayment: TSalePayment): String;
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
  PERSON_NAME_COLUMN = 'IF(person.name is null or person.name = '''', ''Não informado'', person.name)';
  DECIMAL_PLACES = 4;

{ TSaleSQLBuilderMySQL }

function TSaleSQLBuilderMySQL.SQLForReport(ASaleId: Int64): TSQLForReportOutput;
const
  // Cabeçalho
  L_SALE_SQL = ' SELECT '+
              '   sale.*, '+
              PERSON_NAME_COLUMN + ' as person_name, '+
              '   person.alias_name as person_alias_name, '+
              '   person.legal_entity_number as person_legal_entity_number, '+
              '   person.state_registration as person_state_registration, '+
              '   person.municipal_registration as person_municipal_registration, '+
              '   person.address as person_address, '+
              '   person.address_number as person_address_number, '+
              '   person.district as person_district, '+
              '   person.complement as person_complement, '+
              '   city.name as person_city_name, '+
              '   city.state as person_city_state, '+
              '   person.zipcode as person_zipcode, '+
              '   person.phone_1 as person_phone_1, '+
              '   person.phone_2 as person_phone_2, '+
              '   person.phone_3 as person_phone_3, '+
              '   person.company_email as person_company_email, '+
              '   person.financial_email as person_financial_email, '+
              '   seller.name as seller_name '+
              ' FROM '+
              '   sale '+
              ' LEFT JOIN person '+
              '        ON person.id = sale.person_id '+
              ' LEFT JOIN city '+
              '        ON city.id = person.city_id '+
              ' INNER JOIN person seller '+
              '         ON seller.id = sale.seller_id '+
              ' WHERE '+
              '   sale.id = %s';

  // Itens
  L_SALE_ITEMS_SQL = ' SELECT '+
                    '   sale_item.*, '+
                    '   product.sku_code as product_sku_code, '+
                    '   product.name as product_name, '+
                    '   unit.name as product_unit_name '+
                    ' FROM '+
                    '   sale_item '+
                    ' INNER JOIN product '+
                    '         ON product.id = sale_item.product_id '+
                    ' INNER JOIN unit '+
                    '         ON unit.id = product.unit_id '+
                    ' WHERE '+
                    '   sale_item.sale_id = %s '+
                    ' ORDER BY '+
                    '   sale_item.id';

  // Pagamentos
  L_SALE_PAYMENTS_SQL = ' SELECT '+
                        '   sale_payment.*, '+
                        '   payment.name as payment_name, '+
                        '   payment.flg_post_as_received as payment_flg_post_as_received, '+
                        '   bank_account.name as bank_account_name '+
                        ' FROM '+
                        '   sale_payment '+
                        ' INNER JOIN payment '+
                        '         ON payment.id = sale_payment.payment_id '+
                        ' INNER JOIN bank_account '+
                        '         ON bank_account.id = sale_payment.bank_account_id '+
                        ' WHERE '+
                        '   sale_payment.sale_id = %s '+
                        ' ORDER BY '+
                        '   sale_payment.id';
begin
  With Result do
  begin
    Sale         := Format(L_SALE_SQL,          [Q(ASaleId)]);
    SaleItems    := Format(L_SALE_ITEMS_SQL,    [Q(ASaleId)]);
    SalePayments := Format(L_SALE_PAYMENTS_SQL, [Q(ASaleId)]);
  end;
end;

function TSaleSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM sale WHERE id = %s';
  Result := Format(LSQL, [Q(AId)]);
end;

function TSaleSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM sale WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TSaleSQLBuilderMySQL.DeleteSaleItemsBySaleId(ASaleId: Int64): String;
begin
  const LSQL = 'DELETE FROM sale_item WHERE sale_id = %s';
  Result := Format(LSQL, [Q(ASaleId)]);
end;

function TSaleSQLBuilderMySQL.DeleteSalePaymentsBySaleId(ASaleId: Int64): String;
begin
  const LSQL = 'DELETE FROM sale_payment WHERE sale_id = %s';
  Result := Format(LSQL, [Q(ASaleId)]);
end;

function TSaleSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO sale '+
               '   (person_id, seller_id, carrier_id, note, internal_note, status, delivery_status, type, '+
               '    flg_payment_requested, sum_sale_item_total, discount, increase, freight, total, money_received, '+
               '    money_change, amount_of_people, informed_legal_entity_number, consumption_number, created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)';
  const LSale = AEntity as TSale;

  Result := Format(LSQL, [
    QN(LSale.person_id),
    QN(LSale.seller_id),
    QN(LSale.carrier_id),
    Q(LSale.note),
    Q(LSale.internal_note),
    Q(Ord(LSale.status)),
    Q(Ord(LSale.delivery_status)),
    Q(Ord(LSale.&type)),
    Q(LSale.flg_payment_requested),
    Q(LSale.sum_sale_item_total, DECIMAL_PLACES),
    Q(LSale.discount, DECIMAL_PLACES),
    Q(LSale.increase, DECIMAL_PLACES),
    Q(LSale.freight, DECIMAL_PLACES),
    Q(LSale.total, DECIMAL_PLACES),
    Q(LSale.money_received, DECIMAL_PLACES),
    Q(LSale.money_change, DECIMAL_PLACES),
    Q(LSale.amount_of_people),
    Q(LSale.informed_legal_entity_number),
    Q(LSale.consumption_number),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LSale.created_by_acl_user_id)
  ]);
end;

function TSaleSQLBuilderMySQL.InsertSaleItem(ASaleItem: TSaleItem): String;
begin
  const LSQL = ' INSERT INTO sale_item '+
               '   (sale_id, product_id, quantity, price, unit_discount, total, seller_id, note) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s, %s)';
  Result := Format(LSQL, [
    Q(ASaleItem.sale_id),
    Q(ASaleItem.product_id),
    Q(ASaleItem.quantity, DECIMAL_PLACES),
    Q(ASaleItem.price, DECIMAL_PLACES),
    Q(ASaleItem.unit_discount, DECIMAL_PLACES),
    Q(ASaleItem.total, DECIMAL_PLACES),
    QN(ASaleItem.seller_id),
    Q(ASaleItem.note)
  ]);
end;

function TSaleSQLBuilderMySQL.InsertSalePayment(ASalePayment: TSalePayment): String;
begin
  const LSQL = ' INSERT INTO sale_payment '+
               '   (sale_id, collection_uuid, payment_id, bank_account_id, amount, due_date, note) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s)';
  Result := Format(LSQL, [
    Q(ASalePayment.sale_id),
    Q(ASalePayment.collection_uuid),
    QN(ASalePayment.payment_id),
    QN(ASalePayment.bank_account_id),
    Q(ASalePayment.amount, DECIMAL_PLACES),
    Q(ASalePayment.due_date, TDBDriver.dbMYSQL),
    Q(ASalePayment.note)
  ]);
end;

function TSaleSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TSaleSQLBuilderMySQL.Make: ISaleSQLBuilder;
begin
  Result := Self.Create;
end;

function TSaleSQLBuilderMySQL.ScriptCreateTable: String;
begin
  Result := ' CREATE TABLE `sale` ( '+
            ' `id` bigint NOT NULL AUTO_INCREMENT, '+
            ' `person_id` bigint DEFAULT NULL, '+
            ' `seller_id` bigint NOT NULL, '+
            ' `carrier_id` bigint DEFAULT NULL, '+
            ' `note` text, '+
            ' `internal_note` text, '+
            ' `status` tinyint DEFAULT NULL COMMENT ''[0-Pendente, 1-Concluido, 2-Cancelado]'', '+
            ' `delivery_status` tinyint DEFAULT NULL COMMENT ''[0-Novo, 1-Recusado, 2-Agendado, 3-Preparando, 4-Em Transito, 5-Entregue, 6-Cancelado]'', '+
            ' `type` tinyint DEFAULT NULL COMMENT ''[0-Normal, 1-Consumo, 2-Entrega]'', '+
            ' `flg_payment_requested` tinyint DEFAULT NULL, '+
            ' `sum_sale_item_total` decimal(15,8) DEFAULT NULL, '+
            ' `discount` decimal(15,8) DEFAULT NULL, '+
            ' `increase` decimal(15,8) DEFAULT NULL, '+
            ' `freight` decimal(15,8) DEFAULT NULL, '+
            ' `total` decimal(15,8) DEFAULT NULL, '+
            ' `money_received` decimal(15,8) DEFAULT NULL, '+
            ' `money_change` decimal(15,8) DEFAULT NULL, '+
            ' `amount_of_people` tinyint DEFAULT NULL, '+
            ' `informed_legal_entity_number` varchar(20) DEFAULT NULL, '+
            ' `consumption_number` bigint DEFAULT NULL, '+
            ' `created_at` datetime DEFAULT NULL, '+
            ' `updated_at` datetime DEFAULT NULL, '+
            ' `created_by_acl_user_id` bigint DEFAULT NULL, '+
            ' `updated_by_acl_user_id` bigint DEFAULT NULL, '+
            ' PRIMARY KEY (`id`), '+
            ' KEY `sale_fk_created_by_acl_user_id` (`created_by_acl_user_id`), '+
            ' KEY `sale_fk_updated_by_sale_id` (`updated_by_acl_user_id`), '+
            ' KEY `sale_fk_person_id` (`person_id`), '+
            ' KEY `sale_fk_seller_id` (`seller_id`), '+
            ' KEY `sale_fk_carrier_id` (`carrier_id`), '+
            ' KEY `sale_idx_status` (`status`) /*!80000 INVISIBLE */, '+
            ' KEY `sale_idx_delivery_status` (`delivery_status`) /*!80000 INVISIBLE */, '+
            ' KEY `sale_idx_type` (`type`) /*!80000 INVISIBLE */, '+
            ' KEY `sale_idx_flg_payment_requested` (`flg_payment_requested`), '+
            ' KEY `sale_idx_consumption_number` (`consumption_number`), '+
            ' KEY `sale_idx_created_at` (`created_at`), '+
            ' CONSTRAINT `sale_fk_created_by_acl_user_id` FOREIGN KEY (`created_by_acl_user_id`) REFERENCES `acl_user` (`id`), '+
            ' CONSTRAINT `sale_fk_updated_by_sale_id` FOREIGN KEY (`updated_by_acl_user_id`) REFERENCES `acl_user` (`id`),    '+
            ' CONSTRAINT `sale_fk_carrier_id` FOREIGN KEY (`carrier_id`) REFERENCES `person` (`id`), '+
            ' CONSTRAINT `sale_fk_person_id` FOREIGN KEY (`person_id`) REFERENCES `person` (`id`), '+
            ' CONSTRAINT `sale_fk_seller_id` FOREIGN KEY (`seller_id`) REFERENCES `person` (`id`) '+
            ' ) ';
end;

function TSaleSQLBuilderMySQL.ScriptCreateSaleItemTable: String;
begin
  Result := ' CREATE TABLE `sale_item` ( '+
            '   `id` bigint NOT NULL AUTO_INCREMENT, '+
            '   `sale_id` bigint NOT NULL, '+
            '   `product_id` bigint NOT NULL, '+
            '   `quantity` decimal(18,4) DEFAULT NULL, '+
            '   `price` decimal(18,4) DEFAULT NULL, '+
            '   `unit_discount` decimal(18,4) DEFAULT NULL, '+
            '   `total` decimal(18,4) DEFAULT NULL, '+
            '   `seller_id` bigint NOT NULL, '+
            '   `note` text, '+
            '   PRIMARY KEY (`id`), '+
            '   KEY `sale_item_fk_sale_id` (`sale_id`), '+
            '   KEY `sale_item_fk_product_id` (`product_id`), ' +
            '   CONSTRAINT `sale_item_fk_product_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`), ' +
            '   CONSTRAINT `sale_item_fk_sale_id` FOREIGN KEY (`sale_id`) REFERENCES `sale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE '+
            ' )  ';
end;

function TSaleSQLBuilderMySQL.ScriptCreateSalePaymentTable: String;
begin
  Result := ' CREATE TABLE `sale_payment` ( '+
            '   `id` bigint NOT NULL AUTO_INCREMENT, '+
            '   `sale_id` bigint NOT NULL, '+
            '   `collection_uuid` char(36) NOT NULL, '+
            '   `payment_id` bigint NOT NULL, '+
            '   `bank_account_id` bigint NOT NULL, '+
            '   `amount` decimal(18,4) NOT NULL, '+
            '   `note` text, '+
            '   `due_date` DATE NOT NULL, '+
            '   PRIMARY KEY (`id`), '+
            '   KEY `sale_payment_fk_sale_id` (`sale_id`), '+
            '   KEY `sale_payment_fk_payment_id` (`payment_id`), ' +
            '   KEY `sale_payment_fk_bank_account_id` (`bank_account_id`), ' +
            '   CONSTRAINT `sale_payment_fk_bank_account_id` FOREIGN KEY (`bank_account_id`) REFERENCES `bank_account` (`id`), ' +
            '   CONSTRAINT `sale_payment_fk_sale_id` FOREIGN KEY (`sale_id`) REFERENCES `sale` (`id`) ON DELETE CASCADE ON UPDATE CASCADE '+
            ' )  ';
end;

function TSaleSQLBuilderMySQL.ScriptSeedTable: String;
begin
  Result := '';
end;

function TSaleSQLBuilderMySQL.SelectAll: String;
begin
  Result := ' SELECT '+
            '   sale.*, '+
            PERSON_NAME_COLUMN + ' as person_name, '+
            '   seller.name as seller_name, '+
            '   carrier.name as carrier_name, '+
            '   created_by_acl_user.name as created_by_acl_user_name, '+
            '   updated_by_acl_user.name as updated_by_acl_user_name '+
            ' FROM '+
            '   sale '+
            ' LEFT JOIN person '+
            '        ON person.id = sale.person_id '+
            ' INNER JOIN person seller '+
            '         ON seller.id = sale.seller_id '+
            ' LEFT JOIN person carrier '+
            '        ON carrier.id = sale.carrier_id '+
            ' LEFT JOIN acl_user created_by_acl_user '+
            '        ON created_by_acl_user.id = sale.created_by_acl_user_id '+
            ' LEFT JOIN acl_user updated_by_acl_user '+
            '        ON updated_by_acl_user.id = sale.updated_by_acl_user_id ';
end;

function TSaleSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'sale.id', ddMySql);
end;

function TSaleSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE sale.id = ' + AId.ToString;
end;

function TSaleSQLBuilderMySQL.SelectSaleItemsBySaleId(ASaleId: Int64): String;
begin
  const LSQL = ' SELECT '+
               '   sale_item.*, '+
               '   product.name as product_name, '+
               '   unit.id as product_unit_id, '+
               '   unit.name as product_unit_name '+
               ' FROM '+
               '   sale_item '+
               ' INNER JOIN product '+
               '       ON product.id = sale_item.product_id '+
               ' INNER JOIN unit '+
               '       ON unit.id = product.unit_id '+
               ' WHERE '+
               '   sale_item.sale_id = %s '+
               ' ORDER BY '+
               '   sale_item.id';
  Result := Format(LSQL, [Q(ASaleId)]);
end;

function TSaleSQLBuilderMySQL.SelectSalePaymentsBySaleId(ASaleId: Int64): String;
begin
  const LSQL = ' SELECT '+
               '   sale_payment.*, '+
               '   payment.name as payment_name, '+
               '   payment.flg_post_as_received as payment_flg_post_as_received, '+
               '   bank_account.name as bank_account_name '+
               ' FROM '+
               '   sale_payment '+
               ' INNER JOIN payment '+
               '         ON payment.id = sale_payment.payment_id '+
               ' INNER JOIN bank_account '+
               '         ON bank_account.id = sale_payment.bank_account_id '+
               ' WHERE '+
               '   sale_payment.sale_id = %s '+
               ' ORDER BY '+
               '   sale_payment.id ';
  Result := Format(LSQL, [Q(ASaleId)]);
end;

function TSaleSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE sale SET '+
               '   person_id = %s, '+
               '   seller_id = %s, '+
               '   carrier_id = %s, '+
               '   note = %s, '+
               '   internal_note = %s, '+
               '   status = %s, '+
               '   delivery_status = %s, '+
               '   type = %s, '+
               '   flg_payment_requested = %s, '+
               '   sum_sale_item_total = %s, '+
               '   discount = %s, '+
               '   increase = %s, '+
               '   freight = %s, '+
               '   total = %s, '+
               '   money_received = %s, '+
               '   money_change = %s, '+
               '   amount_of_people = %s, '+
               '   informed_legal_entity_number = %s, '+
               '   consumption_number = %s, '+
               '   updated_at = %s, '+
               '   updated_by_acl_user_id = %s '+
               ' WHERE '+
               '   id = %s ';
  const LSale = AEntity as TSale;
  Result := Format(LSQL, [
    QN(LSale.person_id),
    QN(LSale.seller_id),
    QN(LSale.carrier_id),
    Q(LSale.note),
    Q(LSale.internal_note),
    Q(Ord(LSale.status)),
    Q(Ord(LSale.delivery_status)),
    Q(Ord(LSale.&type)),
    Q(LSale.flg_payment_requested),
    Q(LSale.sum_sale_item_total, DECIMAL_PLACES),
    Q(LSale.discount, DECIMAL_PLACES),
    Q(LSale.increase, DECIMAL_PLACES),
    Q(LSale.freight, DECIMAL_PLACES),
    Q(LSale.total, DECIMAL_PLACES),
    Q(LSale.money_received, DECIMAL_PLACES),
    Q(LSale.money_change, DECIMAL_PLACES),
    Q(LSale.amount_of_people),
    Q(LSale.informed_legal_entity_number),
    Q(LSale.consumption_number),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LSale.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.

