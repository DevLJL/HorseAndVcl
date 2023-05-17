unit uNcm.Mapper;

interface

uses
  uMapper.Interfaces,
  uNcm,
  uNcm.Input.DTO,
  uNcm.Show.DTO,
  uNcm.Filter.DTO,
  uFilter;

type
  TNcmMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TNcmInputDTO): TNcm;
    class function EntityToShow(AEntity: TNcm): TNcmShowDTO;
    class function FilterToEntity(AInput: TNcmFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uNcm.Filter;

{ TNcmMapper }

class function TNcmMapper.EntityToShow(AEntity: TNcm): TNcmShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TNcmShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
end;

class function TNcmMapper.FilterToEntity(AInput: TNcmFilterDTO): IFilter;
begin
  Result := TNcmFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'ncm.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.None,  'ncm.code', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'ncm.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'ncm.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TNcmMapper.InputToEntity(AInput: TNcmInputDTO): TNcm;
begin
  Result := TNcm.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
