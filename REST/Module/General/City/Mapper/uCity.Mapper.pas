unit uCity.Mapper;

interface

uses
  uMapper.Interfaces,
  uCity,
  uCity.Input.DTO,
  uCity.Show.DTO,
  uCity.Filter.DTO,
  uFilter;

type
  TCityMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TCityInputDTO): TCity;
    class function EntityToShow(AEntity: TCity): TCityShowDTO;
    class function FilterToEntity(AInput: TCityFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uCity.Filter;

{ TCityMapper }

class function TCityMapper.EntityToShow(AEntity: TCity): TCityShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TCityShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
end;

class function TCityMapper.FilterToEntity(AInput: TCityFilterDTO): IFilter;
begin
  Result := TCityFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'city.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'city.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por id
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'city.id', TCondition.Equal, AInput.id_search_content.ToString);

  // Pesquisa por ibge_code
  if not AInput.ibge_code.Trim.IsEmpty then
    Result.Where(TParentheses.OpenAndClose, 'city.ibge_code', TCondition.Equal, AInput.ibge_code.Trim);
end;

class function TCityMapper.InputToEntity(AInput: TCityInputDTO): TCity;
begin
  Result := TCity.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
