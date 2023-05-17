unit uStorageLocation.Mapper;

interface

uses
  uMapper.Interfaces,
  uStorageLocation,
  uStorageLocation.Input.DTO,
  uStorageLocation.Show.DTO,
  uStorageLocation.Filter.DTO,
  uFilter;

type
  TStorageLocationMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TStorageLocationInputDTO): TStorageLocation;
    class function EntityToShow(AEntity: TStorageLocation): TStorageLocationShowDTO;
    class function FilterToEntity(AInput: TStorageLocationFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uStorageLocation.Filter;

{ TStorageLocationMapper }

class function TStorageLocationMapper.EntityToShow(AEntity: TStorageLocation): TStorageLocationShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TStorageLocationShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
end;

class function TStorageLocationMapper.FilterToEntity(AInput: TStorageLocationFilterDTO): IFilter;
begin
  Result := TStorageLocationFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'storage_location.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'storage_location.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'storage_location.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TStorageLocationMapper.InputToEntity(AInput: TStorageLocationInputDTO): TStorageLocation;
begin
  Result := TStorageLocation.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
