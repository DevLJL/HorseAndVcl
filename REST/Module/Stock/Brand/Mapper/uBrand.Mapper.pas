unit uBrand.Mapper;

interface

uses
  uMapper.Interfaces,
  uBrand,
  uBrand.Input.DTO,
  uBrand.Show.DTO,
  uBrand.Filter.DTO,
  uFilter;

type
  TBrandMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TBrandInputDTO): TBrand;
    class function EntityToShow(AEntity: TBrand): TBrandShowDTO;
    class function FilterToEntity(AInput: TBrandFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uBrand.Filter;

{ TBrandMapper }

class function TBrandMapper.EntityToShow(AEntity: TBrand): TBrandShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TBrandShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
end;

class function TBrandMapper.FilterToEntity(AInput: TBrandFilterDTO): IFilter;
begin
  Result := TBrandFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'brand.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'brand.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'brand.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TBrandMapper.InputToEntity(AInput: TBrandInputDTO): TBrand;
begin
  Result := TBrand.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
