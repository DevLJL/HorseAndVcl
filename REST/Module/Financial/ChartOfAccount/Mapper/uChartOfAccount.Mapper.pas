unit uChartOfAccount.Mapper;

interface

uses
  uMapper.Interfaces,
  uChartOfAccount,
  uChartOfAccount.Input.DTO,
  uChartOfAccount.Show.DTO,
  uChartOfAccount.Filter.DTO,
  uFilter;

type
  TChartOfAccountMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TChartOfAccountInputDTO): TChartOfAccount;
    class function EntityToShow(AEntity: TChartOfAccount): TChartOfAccountShowDTO;
    class function FilterToEntity(AInput: TChartOfAccountFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uChartOfAccount.Filter;

{ TChartOfAccountMapper }

class function TChartOfAccountMapper.EntityToShow(AEntity: TChartOfAccount): TChartOfAccountShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TChartOfAccountShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
end;

class function TChartOfAccountMapper.FilterToEntity(AInput: TChartOfAccountFilterDTO): IFilter;
begin
  Result := TChartOfAccountFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'chart_of_account.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'chart_of_account.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'chart_of_account.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TChartOfAccountMapper.InputToEntity(AInput: TChartOfAccountInputDTO): TChartOfAccount;
begin
  Result := TChartOfAccount.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
