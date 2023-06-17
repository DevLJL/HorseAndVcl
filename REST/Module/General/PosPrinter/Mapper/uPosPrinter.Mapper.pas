unit uPosPrinter.Mapper;

interface

uses
  uMapper.Interfaces,
  uPosPrinter,
  uPosPrinter.Input.DTO,
  uPosPrinter.Show.DTO,
  uPosPrinter.Filter.DTO,
  uFilter;

type
  TPosPrinterMapper = class(TInterfacedObject, IMapper)
  public
    class function InputToEntity(AInput: TPosPrinterInputDTO): TPosPrinter;
    class function EntityToShow(AEntity: TPosPrinter): TPosPrinterShowDTO;
    class function FilterToEntity(AInput: TPosPrinterFilterDTO): IFilter;
  end;

implementation

uses
  System.SysUtils,
  uAppRest.Types,
  XSuperObject,
  uTrans,
  uFilter.Types,
  uPosPrinter.Filter;

{ TPosPrinterMapper }

class function TPosPrinterMapper.EntityToShow(AEntity: TPosPrinter): TPosPrinterShowDTO;
begin
  if not Assigned(AEntity) then
    raise Exception.Create(Trans.RecordNotFound);

  Result                          := TPosPrinterShowDTO.FromJSON(AEntity.AsJSON);
  Result.created_by_acl_user_name := AEntity.created_by_acl_user.name;
  Result.updated_by_acl_user_name := AEntity.updated_by_acl_user.name;
end;

class function TPosPrinterMapper.FilterToEntity(AInput: TPosPrinterFilterDTO): IFilter;
begin
  Result := TPosPrinterFilter.Make
    .CurrentPage  (AInput.current_page)
    .LimitPerPage (AInput.limit_per_page)
    .Columns      (AInput.columns)
    .OrderBy      (AInput.order_by)
    .WherePkIn    (AInput.where_pk_in)
    .AclUserId    (AInput.acl_user_id);

  // Pesquisa Customizada
  if not AInput.custom_search_content.Trim.IsEmpty then
  begin
    Result
      .Where (TParentheses.Open,  'pos_printer.name', TCondition.LikeInitial, AInput.custom_search_content.Trim)
      .&Or   (TParentheses.Close, 'pos_printer.id',   TCondition.LikeInitial, AInput.custom_search_content.Trim);
  end;

  // Pesquisa por ID
  if (AInput.id_search_content > 0) then
    Result.Where(TParentheses.OpenAndClose, 'pos_printer.id', TCondition.Equal, AInput.id_search_content.ToString);
end;

class function TPosPrinterMapper.InputToEntity(AInput: TPosPrinterInputDTO): TPosPrinter;
begin
  Result := TPosPrinter.FromJson(AInput.AsJson);
  Result.created_by_acl_user_id := AInput.acl_user_id;
  Result.updated_by_acl_user_id := AInput.acl_user_id;
end;

end.
