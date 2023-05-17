unit uCategory.Mapper;

interface

uses
  uMapper.Interfaces,
  uCategory,
  uCategory.Input.DTO,
  uCategory.Show.DTO,
  uCategory.Filter.DTO,
  uFilter;

type
  TCategoryMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TCategoryInputDTO): TCategory;
    class function EntityToShow(AEntity: TCategory): TCategoryShowDTO;
    class function FilterToEntity(AInput: TCategoryFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uCategory.Filter;

{ TCategoryMapper }

class function TCategoryMapper.EntityToShow(AEntity: TCategory): TCategoryShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TCategoryShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
end;

class function TCategoryMapper.FilterToEntity(AInput: TCategoryFilterDTO): IFilter;
begin
  Result := TCategoryFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'category.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'category.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'category.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TCategoryMapper.InputToEntity(AInput: TCategoryInputDTO): TCategory;
begin
  Result := TCategory.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
