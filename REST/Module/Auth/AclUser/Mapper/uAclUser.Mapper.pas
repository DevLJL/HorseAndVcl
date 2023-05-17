unit uAclUser.Mapper;

interface

uses
  uMapper.Interfaces,
  uAclUser,
  uAclUser.Input.DTO,
  uAclUser.Show.DTO,
  uAclUser.Filter.DTO,
  uFilter;

type
  TAclUserMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TAclUserInputDTO): TAclUser;
    class function EntityToShow(AEntity: TAclUser): TAclUserShowDTO;
    class function FilterToEntity(AInput: TAclUserFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uAclUser.Filter,
  uRepository.Factory,
  uAclRole.Persistence.UseCase;

{ TAclUserMapper }

class function TAclUserMapper.EntityToShow(AEntity: TAclUser): TAclUserShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result := TAclUserShowDTO.FromJSON(AEntity.AsJSON);
  Result.acl_role_name := AEntity.acl_role.name;

  // Anexar informações do Perfil
  const AclRoleRepository = TRepositoryFactory.Make.AclRole;
  const AclRolePersistence = TAclRolePersistenceUseCase.Make(AclRoleRepository);
  if Assigned(Result.acl_role) then
    Result.acl_role.free;
  Result.acl_role := AclRolePersistence.Show(Result.acl_role_id);
end;

class function TAclUserMapper.FilterToEntity(AInput: TAclUserFilterDTO): IFilter;
begin
  Result := TAclUserFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'acl_user.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'acl_user.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'acl_user.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TAclUserMapper.InputToEntity(AInput: TAclUserInputDTO): TAclUser;
begin
  Result := TAclUser.FromJson(AInput.AsJson);
end;

end.
