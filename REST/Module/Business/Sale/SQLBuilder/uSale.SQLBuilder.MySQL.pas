unit uSale.SQLBuilder.MySQL;

interface

uses
  uFilter,
  uSelectWithFilter,
  uSale,
  uSale.SQLBuilder.Interfaces,
  uBase.Entity,
  uSaleItem,
  uSalepayment;

type
  TSaleSQLBuilderMySQL = class(TInterfacedObject, ISaleSQLBuilder)
  public
    class function Make: ISaleSQLBuilder;

    // SaleCheck
    function NextSaleCheckId: String;

    // Sale
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
    function SelectSaleItemsBySaleId(ASaleId: Int64): String;
    function DeleteSaleItemsBySaleId(ASaleId: Int64): String;
    function InsertSaleItem(ASaleItem: TSaleItem): String;

    // SalePayment
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
               '    flg_payment_requested, sum_sale_item_total, discount, increase, freight, service_charge, cover_charge, '+
               '    total, money_received, money_change, amount_of_people, informed_legal_entity_number, '+
               '    consumption_number, sale_check_id, sale_check_name, created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)';
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
    Q(LSale.service_charge, DECIMAL_PLACES),
    Q(LSale.cover_charge, DECIMAL_PLACES),
    Q(LSale.total, DECIMAL_PLACES),
    Q(LSale.money_received, DECIMAL_PLACES),
    Q(LSale.money_change, DECIMAL_PLACES),
    Q(LSale.amount_of_people),
    Q(LSale.informed_legal_entity_number),
    Q(LSale.consumption_number),
    Q(LSale.sale_check_id),
    Q(LSale.sale_check_name),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LSale.created_by_acl_user_id)
  ]);
end;

function TSaleSQLBuilderMySQL.NextSaleCheckId: String;
begin
  const LSQL = ' INSERT INTO sale_check '+
               '   (`created_at`) '+
               ' VALUES '+
               '   (%s) ';
  Result := Format(LSQL, [Q(Now(), TDBDriver.dbMYSQL)]);
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
               '   service_charge = %s, '+
               '   cover_charge = %s, '+
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
    Q(LSale.service_charge, DECIMAL_PLACES),
    Q(LSale.cover_charge, DECIMAL_PLACES),
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

