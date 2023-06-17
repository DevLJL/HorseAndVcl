unit uGlobalConfig.Mapper;

interface

uses
  uMapper.Interfaces,
  uGlobalConfig,
  uGlobalConfig.Input.DTO,
  uGlobalConfig.Show.DTO,
  uGlobalConfig.Filter.DTO,
  uFilter;

type
  TGlobalConfigMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TGlobalConfigInputDTO): TGlobalConfig;
    class function EntityToShow(AEntity: TGlobalConfig): TGlobalConfigShowDTO;
    class function FilterToEntity(AInput: TGlobalConfigFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uGlobalConfig.Filter;

{ TGlobalConfigMapper }

class function TGlobalConfigMapper.EntityToShow(AEntity: TGlobalConfig): TGlobalConfigShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TGlobalConfigShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
end;

class function TGlobalConfigMapper.FilterToEntity(AInput: TGlobalConfigFilterDTO): IFilter;
begin
  Result := TGlobalConfigFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in)
    .AclUserId    (AInput.acl_user_id);

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'global_config.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TGlobalConfigMapper.InputToEntity(AInput: TGlobalConfigInputDTO): TGlobalConfig;
begin
  Result := TGlobalConfig.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
