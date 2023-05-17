unit uBillPayReceive.Mapper;

interface

uses
  uMapper.Interfaces,
  uBillPayReceive,
  uBillPayReceive.Input.DTO,
  uBillPayReceive.Show.DTO,
  uBillPayReceive.Filter.DTO,
  uFilter;

type
  TBillPayReceiveMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TBillPayReceiveInputDTO): TBillPayReceive;
    class function EntityToShow(AEntity: TBillPayReceive): TBillPayReceiveShowDTO;
    class function FilterToEntity(AInput: TBillPayReceiveFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uBillPayReceive.Filter;

{ TBillPayReceiveMapper }

class function TBillPayReceiveMapper.EntityToShow(AEntity: TBillPayReceive): TBillPayReceiveShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TBillPayReceiveShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
  Result.net_amount               := AEntity.net_amount;
  Result.person_name              := AEntity.person.name;
  Result.chart_of_account_name    := AEntity.chart_of_account.name;
  Result.cost_center_name         := AEntity.cost_center.name;
  Result.bank_account_name        := AEntity.bank_account.name;
  Result.payment_name             := AEntity.payment.name;
end;

class function TBillPayReceiveMapper.FilterToEntity(AInput: TBillPayReceiveFilterDTO): IFilter;
begin
  Result := TBillPayReceiveFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'bill_pay_receive.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'bill_pay_receive.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'bill_pay_receive.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TBillPayReceiveMapper.InputToEntity(AInput: TBillPayReceiveInputDTO): TBillPayReceive;
begin
  Result := TBillPayReceive.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
