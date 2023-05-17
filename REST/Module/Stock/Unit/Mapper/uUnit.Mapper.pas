unit uUnit.Mapper;

interface

uses
  uMapper.Interfaces,
  uUnit,
  uUnit.Input.DTO,
  uUnit.Show.DTO,
  uUnit.Filter.DTO,
  uFilter;

type
  TUnitMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TUnitInputDTO): TUnit;
    class function EntityToShow(AEntity: TUnit): TUnitShowDTO;
    class function FilterToEntity(AInput: TUnitFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uUnit.Filter;

{ TUnitMapper }

class function TUnitMapper.EntityToShow(AEntity: TUnit): TUnitShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TUnitShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
end;

class function TUnitMapper.FilterToEntity(AInput: TUnitFilterDTO): IFilter;
begin
  Result := TUnitFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'unit.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'unit.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'unit.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TUnitMapper.InputToEntity(AInput: TUnitInputDTO): TUnit;
begin
  Result := TUnit.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
