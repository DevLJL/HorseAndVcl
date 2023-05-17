unit uQueueEmail.Mapper;

interface

uses
  uMapper.Interfaces,
  uQueueEmail,
  uQueueEmail.Input.DTO,
  uQueueEmail.Show.DTO,
  uQueueEmail.Filter.DTO,
  uFilter;

type
  TQueueEmailMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TQueueEmailInputDTO): TQueueEmail;
    class function EntityToShow(AEntity: TQueueEmail): TQueueEmailShowDTO;
    class function FilterToEntity(AInput: TQueueEmailFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uQueueEmail.Filter;

{ TQueueEmailMapper }

class function TQueueEmailMapper.EntityToShow(AEntity: TQueueEmail): TQueueEmailShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result := TQueueEmailShowDTO.FromJSON(AEntity.AsJSON);
end;

class function TQueueEmailMapper.FilterToEntity(AInput: TQueueEmailFilterDTO): IFilter;
begin
  Result := TQueueEmailFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'queue_email.recipients', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'queue_email.id',         TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'queue_email.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TQueueEmailMapper.InputToEntity(AInput: TQueueEmailInputDTO): TQueueEmail;
begin
  Result := TQueueEmail.FromJson(AInput.AsJson);
end;

end.
