unit uAclRole.Mapper;

interface

uses
  uMapper.Interfaces,
  uAclRole,
  uAclRole.Input.DTO,
  uAclRole.Show.DTO,
  uAclRole.Filter.DTO,
  uFilter;

type
  TAclRoleMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TAclRoleInputDTO): TAclRole;
    class function EntityToShow(AEntity: TAclRole): TAclRoleShowDTO;
    class function FilterToEntity(AInput: TAclRoleFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uAclRole.Filter;

{ TAclRoleMapper }

class function TAclRoleMapper.EntityToShow(AEntity: TAclRole): TAclRoleShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result := TAclRoleShowDTO.FromJSON(AEntity.AsJSON);
end;

class function TAclRoleMapper.FilterToEntity(AInput: TAclRoleFilterDTO): IFilter;
begin
  Result := TAclRoleFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'acl_role.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'acl_role.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'acl_role.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TAclRoleMapper.InputToEntity(AInput: TAclRoleInputDTO): TAclRole;
begin
  Result := TAclRole.FromJson(AInput.AsJson);
end;

end.
