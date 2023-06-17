unit uAdditional.Mapper;

interface

uses
  uMapper.Interfaces,
  uAdditional,
  uAdditional.Input.DTO,
  uAdditional.Show.DTO,
  uAdditional.Filter.DTO,
  uFilter;

type
  TAdditionalMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TAdditionalInputDTO): TAdditional;
    class function EntityToShow(AEntity: TAdditional): TAdditionalShowDTO;
    class function FilterToEntity(AInput: TAdditionalFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uAdditional.Filter;

{ TAdditionalMapper }

class function TAdditionalMapper.EntityToShow(AEntity: TAdditional): TAdditionalShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TAdditionalShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;

  // AdditionalProducts - Tratar especificidades
  for var lI := 0 to Pred(AEntity.additional_products.Count) do
  begin
    Result.additional_products.Items[lI].product_name := AEntity.additional_products.Items[lI].product.name;
  end;
end;

class function TAdditionalMapper.FilterToEntity(AInput: TAdditionalFilterDTO): IFilter;
begin
  Result := TAdditionalFilter.Make
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
      .Where (TParentheses.Open,  'additional.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'additional.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'additional.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TAdditionalMapper.InputToEntity(AInput: TAdditionalInputDTO): TAdditional;
begin
  Result := TAdditional.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
