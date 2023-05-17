unit uConsumption.Mapper;

interface

uses
  uMapper.Interfaces,
  uConsumption,
  uConsumption.Input.DTO,
  uConsumption.Show.DTO,
  uConsumption.Filter.DTO,
  uFilter;

type
  TConsumptionMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TConsumptionInputDTO): TConsumption;
    class function EntityToShow(AEntity: TConsumption): TConsumptionShowDTO;
    class function FilterToEntity(AInput: TConsumptionFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uConsumption.Filter;

{ TConsumptionMapper }

class function TConsumptionMapper.EntityToShow(AEntity: TConsumption): TConsumptionShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TConsumptionShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
end;

class function TConsumptionMapper.FilterToEntity(AInput: TConsumptionFilterDTO): IFilter;
begin
  Result := TConsumptionFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'consumption.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'consumption.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'consumption.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TConsumptionMapper.InputToEntity(AInput: TConsumptionInputDTO): TConsumption;
begin
  Result := TConsumption.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
