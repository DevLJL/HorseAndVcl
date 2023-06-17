unit uPriceList.Mapper;

interface

uses
  uMapper.Interfaces,
  uPriceList,
  uPriceList.Input.DTO,
  uPriceList.Show.DTO,
  uPriceList.Filter.DTO,
  uFilter;

type
  TPriceListMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TPriceListInputDTO): TPriceList;
    class function EntityToShow(AEntity: TPriceList): TPriceListShowDTO;
    class function FilterToEntity(AInput: TPriceListFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uPriceList.Filter;

{ TPriceListMapper }

class function TPriceListMapper.EntityToShow(AEntity: TPriceList): TPriceListShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TPriceListShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
end;

class function TPriceListMapper.FilterToEntity(AInput: TPriceListFilterDTO): IFilter;
begin
  Result := TPriceListFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in)
    .AclUserId    (AInput.acl_user_id);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'price_list.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'price_list.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'price_list.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TPriceListMapper.InputToEntity(AInput: TPriceListInputDTO): TPriceList;
begin
  Result := TPriceList.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
