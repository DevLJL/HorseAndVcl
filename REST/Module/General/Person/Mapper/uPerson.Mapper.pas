unit uPerson.Mapper;

interface

uses
  uMapper.Interfaces,
  uPerson,
  uPerson.Input.DTO,
  uPerson.Show.DTO,
  uPerson.Filter.DTO,
  uFilter;

type
  TPersonMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TPersonInputDTO): TPerson;
    class function EntityToShow(AEntity: TPerson): TPersonShowDTO;
    class function FilterToEntity(AInput: TPersonFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uPerson.Filter, uHlp;

{ TPersonMapper }

class function TPersonMapper.EntityToShow(AEntity: TPerson): TPersonShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TPersonShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
  Result.city_name                := AEntity.city.name;
  Result.city_state               := AEntity.city.state;
  Result.city_country             := AEntity.city.country;
  Result.city_ibge_code           := AEntity.city.ibge_code;
  Result.city_country_ibge_code   := AEntity.city.country_ibge_code;
end;

class function TPersonMapper.FilterToEntity(AInput: TPersonFilterDTO): IFilter;
begin
  Result := TPersonFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'person.name',       TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.None,  'person.alias_name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'person.id',         TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'person.id', TCondition.Equal, AInput.id_search_content.ToString);

  // name
  if not AInput.name.Trim.IsEmpty then
    Result.Where(TParentheses.OpenAndClose, 'person.name', TCondition.LikeInitial, AInput.name.Trim);

  // alias_name
  if not AInput.alias_name.Trim.IsEmpty then
    Result.Where(TParentheses.OpenAndClose, 'person.alias_name', TCondition.LikeInitial, AInput.alias_name.Trim);

  // legal_entity_number
  if not AInput.legal_entity_number.Trim.IsEmpty then
    Result.Where(TParentheses.OpenAndClose, 'person.legal_entity_number', TCondition.LikeInitial, AInput.legal_entity_number.Trim);

  // legal_entity_number
  if not AInput.zipcode.Trim.IsEmpty then
    Result.Where(TParentheses.OpenAndClose, 'person.zipcode', TCondition.LikeInitial, AInput.zipcode.Trim);

  // address
  if not AInput.address.Trim.IsEmpty then
    Result.Where(TParentheses.OpenAndClose, 'person.address', TCondition.LikeInitial, AInput.address.Trim);

  // address_number
  if not AInput.address_number.Trim.IsEmpty then
    Result.Where(TParentheses.OpenAndClose, 'person.address_number', TCondition.LikeInitial, AInput.address_number.Trim);

  // district
  if not AInput.district.Trim.IsEmpty then
    Result.Where(TParentheses.OpenAndClose, 'person.district', TCondition.LikeInitial, AInput.district.Trim);

  // city_name
  if not AInput.city_name.Trim.IsEmpty then
    Result.Where(TParentheses.OpenAndClose, 'city.name', TCondition.LikeInitial, AInput.city_name.Trim);

  // reference_point
  if not AInput.reference_point.Trim.IsEmpty then
    Result.Where(TParentheses.OpenAndClose, 'person.reference_point', TCondition.LikeInitial, AInput.reference_point.Trim);

  // phone_1
  if not AInput.phone_1.Trim.IsEmpty then
    Result.Where(TParentheses.OpenAndClose, 'person.phone_1', TCondition.LikeInitial, AInput.phone_1.Trim);

  // company_email
  if not AInput.company_email.Trim.IsEmpty then
    Result.Where(TParentheses.OpenAndClose, 'person.company_email', TCondition.LikeInitial, AInput.company_email.Trim);

  // financial_email
  if not AInput.financial_email.Trim.IsEmpty then
    Result.Where(TParentheses.OpenAndClose, 'person.financial_email', TCondition.LikeInitial, AInput.financial_email.Trim);
end;

class function TPersonMapper.InputToEntity(AInput: TPersonInputDTO): TPerson;
begin
  Result := TPerson.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
