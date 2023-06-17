unit uTenant.Mapper;

interface

uses
  uMapper.Interfaces,
  uTenant,
  uTenant.Input.DTO,
  uTenant.Show.DTO,
  uTenant.Filter.DTO,
  uFilter;

type
  TTenantMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TTenantInputDTO): TTenant;
    class function EntityToShow(AEntity: TTenant): TTenantShowDTO;
    class function FilterToEntity(AInput: TTenantFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uTenant.Filter;

{ TTenantMapper }

class function TTenantMapper.EntityToShow(AEntity: TTenant): TTenantShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                := TTenantShowDTO.FromJSON(AEntity.AsJSON);
  Result.city_name      := AEntity.city.name;
  Result.city_state     := AEntity.city.state;
  Result.city_ibge_code := AEntity.city.ibge_code;
end;

class function TTenantMapper.FilterToEntity(AInput: TTenantFilterDTO): IFilter;
begin
  Result := TTenantFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'tenant.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'tenant.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'tenant.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TTenantMapper.InputToEntity(AInput: TTenantInputDTO): TTenant;
begin
  Result := TTenant.FromJson(AInput.AsJson);
end;

end.
