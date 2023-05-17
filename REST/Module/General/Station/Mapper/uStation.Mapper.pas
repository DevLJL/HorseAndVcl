unit uStation.Mapper;

interface

uses
  uMapper.Interfaces,
  uStation,
  uStation.Input.DTO,
  uStation.Show.DTO,
  uStation.Filter.DTO,
  uFilter;

type
  TStationMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TStationInputDTO): TStation;
    class function EntityToShow(AEntity: TStation): TStationShowDTO;
    class function FilterToEntity(AInput: TStationFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uStation.Filter;

{ TStationMapper }

class function TStationMapper.EntityToShow(AEntity: TStation): TStationShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result := TStationShowDTO.FromJSON(AEntity.AsJSON);
end;

class function TStationMapper.FilterToEntity(AInput: TStationFilterDTO): IFilter;
begin
  Result := TStationFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'station.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'station.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'station.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TStationMapper.InputToEntity(AInput: TStationInputDTO): TStation;
begin
  Result := TStation.FromJson(AInput.AsJson);
end;

end.
