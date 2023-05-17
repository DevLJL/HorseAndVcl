unit uCostCenter.Mapper;

interface

uses
  uMapper.Interfaces,
  uCostCenter,
  uCostCenter.Input.DTO,
  uCostCenter.Show.DTO,
  uCostCenter.Filter.DTO,
  uFilter;

type
  TCostCenterMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TCostCenterInputDTO): TCostCenter;
    class function EntityToShow(AEntity: TCostCenter): TCostCenterShowDTO;
    class function FilterToEntity(AInput: TCostCenterFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uCostCenter.Filter;

{ TCostCenterMapper }

class function TCostCenterMapper.EntityToShow(AEntity: TCostCenter): TCostCenterShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TCostCenterShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
end;

class function TCostCenterMapper.FilterToEntity(AInput: TCostCenterFilterDTO): IFilter;
begin
  Result := TCostCenterFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'cost_center.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'cost_center.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'cost_center.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TCostCenterMapper.InputToEntity(AInput: TCostCenterInputDTO): TCostCenter;
begin
  Result := TCostCenter.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
