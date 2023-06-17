unit uCashFlow.Mapper;

interface

uses
  uMapper.Interfaces,
  uCashFlow,
  uCashFlow.Input.DTO,
  uCashFlow.Show.DTO,
  uCashFlow.Filter.DTO,
  uFilter;

type
  TCashFlowMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TCashFlowInputDTO): TCashFlow;
    class function EntityToShow(AEntity: TCashFlow): TCashFlowShowDTO;
    class function FilterToEntity(AInput: TCashFlowFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uCashFlow.Filter,
  uHlp;

{ TCashFlowMapper }

class function TCashFlowMapper.EntityToShow(AEntity: TCashFlow): TCashFlowShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                           := TCashFlowShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name  := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name  := AEntity.updated_by_acl_user.name;
  Result.station_name              := AEntity.station.name;

  // CashFlowTransactions - Tratar especificidades
  for var lI := 0 to Pred(AEntity.cash_flow_transactions.Count) do
  begin
    Result.cash_flow_transactions.Items[lI].payment_name  := AEntity.cash_flow_transactions.Items[lI].payment.name;
    Result.cash_flow_transactions.Items[lI].person_name   := AEntity.cash_flow_transactions.Items[lI].person.name;
  end;
end;

class function TCashFlowMapper.FilterToEntity(AInput: TCashFlowFilterDTO): IFilter;
begin
  Result := TCashFlowFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'cash_flow.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'cash_flow.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'cash_flow.id', TCondition.Equal, AInput.id_search_content.ToString);

  // StationId
  if not AInput.station_id.Trim.IsEmpty then
    Result.Where(TParentheses.OpenAndClose, 'cash_flow.station_id', TCondition.Equal, StrInt(AInput.station_id).ToString);

  // Opened
  if not AInput.opened.Trim.IsEmpty then
  begin
    case StrInt(AInput.opened.Trim) of
      0: Result.Where(TParentheses.OpenAndClose, 'cash_flow.closing_date', TCondition.IsNotNull);
      1: Result.Where(TParentheses.OpenAndClose, 'cash_flow.closing_date', TCondition.IsNull);
    end;
  end;
end;

class function TCashFlowMapper.InputToEntity(AInput: TCashFlowInputDTO): TCashFlow;
begin
  Result := TCashFlow.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
