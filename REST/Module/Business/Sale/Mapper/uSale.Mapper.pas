unit uSale.Mapper;

interface

uses
  uMapper.Interfaces,
  uSale,
  uSale.Input.DTO,
  uSale.Show.DTO,
  uSale.Filter.DTO,
  uFilter;

type
  TSaleMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TSaleInputDTO): TSale;
    class function EntityToShow(AEntity: TSale): TSaleShowDTO;
    class function FilterToEntity(AInput: TSaleFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uSale.Filter,
  uHlp, uSale.Types;

{ TSaleMapper }

class function TSaleMapper.EntityToShow(AEntity: TSale): TSaleShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                           := TSaleShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name  := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name  := AEntity.updated_by_acl_user.name;
  Result.total                     := AEntity.total;
  Result.person_name               := AEntity.person.name;
  Result.seller_name               := AEntity.seller.name;
  Result.carrier_name              := AEntity.carrier.name;
  Result.perc_discount             := AEntity.perc_discount;
  Result.perc_increase             := AEntity.perc_increase;
  Result.sum_sale_item_total       := AEntity.sum_sale_item_total;
  Result.sum_sale_item_quantity    := AEntity.sum_sale_item_quantity;

  // SaleItems - Tratar especificidades
  for var lI := 0 to Pred(AEntity.sale_items.Count) do
  begin
    Result.sale_items.Items[lI].product_name      := AEntity.sale_items.Items[lI].product.name;
    Result.sale_items.Items[lI].product_unit_id   := AEntity.sale_items.Items[lI].product.unit_id;
    Result.sale_items.Items[lI].product_unit_name := AEntity.sale_items.Items[lI].product.&unit.name;
    Result.sale_items.Items[lI].subtotal          := AEntity.sale_items.Items[lI].subtotal;
    Result.sale_items.Items[lI].total             := AEntity.sale_items.Items[lI].total;
  end;

  // SalePayments - Tratar especificidades
  for var lI := 0 to Pred(AEntity.sale_payments.Count) do
  begin
    Result.sale_payments.Items[lI].payment_name      := AEntity.sale_payments.Items[lI].payment.name;
    Result.sale_payments.Items[lI].bank_account_name := AEntity.sale_payments.Items[lI].bank_account.name;
  end;
end;

class function TSaleMapper.FilterToEntity(AInput: TSaleFilterDTO): IFilter;
begin
  Result := TSaleFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'sale.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'sale.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'sale.id', TCondition.Equal, AInput.id_search_content.ToString);

  // Pesquisa Customizada para Vendas em Espera
  if not AInput.custom_search_for_sale_on_hold.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'sale.sale_check_id',   TCondition.LikeInitial, AInput.custom_search_for_sale_on_hold.Trim)
      .&Or   (TParentheses.Close, 'sale.sale_check_name', TCondition.LikeInitial, AInput.custom_search_for_sale_on_hold.Trim);
  end;

  // Status da Venda
  if not AInput.status.Trim.IsEmpty then
  begin
    const LSaleStatus = TSaleStatus(StrInt(AInput.status.Trim));
    Result.Where(TParentheses.OpenAndClose, 'sale.status', TCondition.Equal, Ord(LSaleStatus).ToString);
  end;

  // Tipo de Venda
  if not AInput.&type.Trim.IsEmpty then
  begin
    const LSaleType = TSaleType(StrInt(AInput.&type.Trim));
    Result.Where(TParentheses.OpenAndClose, 'sale.type', TCondition.Equal, Ord(LSaleType).ToString);
  end;
end;

class function TSaleMapper.InputToEntity(AInput: TSaleInputDTO): TSale;
begin
  Result := TSale.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
