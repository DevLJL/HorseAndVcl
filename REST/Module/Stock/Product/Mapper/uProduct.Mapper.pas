unit uProduct.Mapper;

interface

uses
  uMapper.Interfaces,
  uProduct,
  uProduct.Input.DTO,
  uProduct.Show.DTO,
  uProduct.Filter.DTO,
  uFilter;

type
  TProductMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TProductInputDTO): TProduct;
    class function EntityToShow(AEntity: TProduct): TProductShowDTO;
    class function FilterToEntity(AInput: TProductFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uProduct.Filter;

{ TProductMapper }

class function TProductMapper.EntityToShow(AEntity: TProduct): TProductShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TProductShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
  Result.unit_name                := AEntity.&unit.name;
  Result.ncm_code                 := AEntity.ncm.code;
  Result.ncm_name                 := AEntity.ncm.name;
  Result.category_name            := AEntity.category.name;
  Result.brand_name               := AEntity.brand.name;
  Result.size_name                := AEntity.size.name;
  Result.storage_location_name    := AEntity.storage_location.name;
end;

class function TProductMapper.FilterToEntity(AInput: TProductFilterDTO): IFilter;
begin
  Result := TProductFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'product.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'product.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'product.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TProductMapper.InputToEntity(AInput: TProductInputDTO): TProduct;
begin
  Result := TProduct.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
