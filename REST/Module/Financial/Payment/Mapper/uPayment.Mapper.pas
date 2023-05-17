unit uPayment.Mapper;

interface

uses
  uMapper.Interfaces,
  uPayment,
  uPayment.Input.DTO,
  uPayment.Show.DTO,
  uPayment.Filter.DTO,
  uFilter;

type
  TPaymentMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TPaymentInputDTO): TPayment;
    class function EntityToShow(AEntity: TPayment): TPaymentShowDTO;
    class function FilterToEntity(AInput: TPaymentFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uPayment.Filter;

{ TPaymentMapper }

class function TPaymentMapper.EntityToShow(AEntity: TPayment): TPaymentShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                           := TPaymentShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name  := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name  := AEntity.updated_by_acl_user.name;
  Result.bank_account_default_name := AEntity.bank_account_default.name;
end;

class function TPaymentMapper.FilterToEntity(AInput: TPaymentFilterDTO): IFilter;
begin
  Result := TPaymentFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'payment.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'payment.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'payment.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TPaymentMapper.InputToEntity(AInput: TPaymentInputDTO): TPayment;
begin
  Result := TPayment.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
