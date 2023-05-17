unit uBankAccount.Mapper;

interface

uses
  uMapper.Interfaces,
  uBankAccount,
  uBankAccount.Input.DTO,
  uBankAccount.Show.DTO,
  uBankAccount.Filter.DTO,
  uFilter;

type
  TBankAccountMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TBankAccountInputDTO): TBankAccount;
    class function EntityToShow(AEntity: TBankAccount): TBankAccountShowDTO;
    class function FilterToEntity(AInput: TBankAccountFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uBankAccount.Filter;

{ TBankAccountMapper }

class function TBankAccountMapper.EntityToShow(AEntity: TBankAccount): TBankAccountShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TBankAccountShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
  Result.bank_name                := AEntity.bank.name
end;

class function TBankAccountMapper.FilterToEntity(AInput: TBankAccountFilterDTO): IFilter;
begin
  Result := TBankAccountFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'bank_account.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'bank_account.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'bank_account.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TBankAccountMapper.InputToEntity(AInput: TBankAccountInputDTO): TBankAccount;
begin
  Result := TBankAccount.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
