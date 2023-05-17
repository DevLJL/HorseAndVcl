unit uSize.Mapper;

interface

uses
  uMapper.Interfaces,
  uSize,
  uSize.Input.DTO,
  uSize.Show.DTO,
  uSize.Filter.DTO,
  uFilter;

type
  TSizeMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TSizeInputDTO): TSize;
    class function EntityToShow(AEntity: TSize): TSizeShowDTO;
    class function FilterToEntity(AInput: TSizeFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uSize.Filter;

{ TSizeMapper }

class function TSizeMapper.EntityToShow(AEntity: TSize): TSizeShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TSizeShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
end;

class function TSizeMapper.FilterToEntity(AInput: TSizeFilterDTO): IFilter;
begin
  Result := TSizeFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'size.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'size.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'size.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TSizeMapper.InputToEntity(AInput: TSizeInputDTO): TSize;
begin
  Result := TSize.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
