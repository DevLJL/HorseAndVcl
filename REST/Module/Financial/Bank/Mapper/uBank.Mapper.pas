unit uBank.Mapper;

interface

uses
  uMapper.Interfaces,
  uBank,
  uBank.Input.DTO,
  uBank.Show.DTO,
  uBank.Filter.DTO,
  uFilter;

type
  TBankMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TBankInputDTO): TBank;
    class function EntityToShow(AEntity: TBank): TBankShowDTO;
    class function FilterToEntity(AInput: TBankFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uBank.Filter;

{ TBankMapper }

class function TBankMapper.EntityToShow(AEntity: TBank): TBankShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TBankShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
end;

class function TBankMapper.FilterToEntity(AInput: TBankFilterDTO): IFilter;
begin
  Result := TBankFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'bank.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'bank.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'bank.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TBankMapper.InputToEntity(AInput: TBankInputDTO): TBank;
begin
  Result := TBank.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
