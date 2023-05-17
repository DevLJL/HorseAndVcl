unit uCompany.Mapper;

interface

uses
  uMapper.Interfaces,
  uCompany,
  uCompany.Input.DTO,
  uCompany.Show.DTO,
  uCompany.Filter.DTO,
  uFilter;

type
  TCompanyMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TCompanyInputDTO): TCompany;
    class function EntityToShow(AEntity: TCompany): TCompanyShowDTO;
    class function FilterToEntity(AInput: TCompanyFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uCompany.Filter;

{ TCompanyMapper }

class function TCompanyMapper.EntityToShow(AEntity: TCompany): TCompanyShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                := TCompanyShowDTO.FromJSON(AEntity.AsJSON);
  Result.city_name      := AEntity.city.name;
  Result.city_state     := AEntity.city.state;
  Result.city_ibge_code := AEntity.city.ibge_code;
end;

class function TCompanyMapper.FilterToEntity(AInput: TCompanyFilterDTO): IFilter;
begin
  Result := TCompanyFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'company.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'company.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'company.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TCompanyMapper.InputToEntity(AInput: TCompanyInputDTO): TCompany;
begin
  Result := TCompany.FromJson(AInput.AsJson);
end;

end.
