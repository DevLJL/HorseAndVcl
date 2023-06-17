unit uBase.Filter.DTO;

interface

uses
  uBase.DTO,
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  XSuperObject,
  uSmartPointer;

type
  TBaseFilterDTO = class(TBaseDTO)
  private
    Flimit_per_page: Integer;
    Fcolumns: String;
    Fcurrent_page: Integer;
    Fwhere_pk_in: String;
    Forder_by: String;
    Fcustom_search_content: String;
    Fid_search_content: Int64;
    Fetag: String;
    Facl_user_id: Int64;
    procedure Setcurrent_page(const Value: Integer);
    procedure Setlimit_per_page(const Value: Integer);
  public
    constructor Create;

    [SwagNumber]
    [SwagProp('current_page', 'Página setada', true)]
    property current_page: Integer read Fcurrent_page write Setcurrent_page;

    [SwagNumber]
    [SwagProp('limit_per_page', 'Limite por página', true)]
    property limit_per_page: Integer read Flimit_per_page write Setlimit_per_page;

    [SwagString]
    [SwagProp('columns', 'Limite por página', false)]
    property columns: String read Fcolumns write Fcolumns;

    [SwagString]
    [SwagProp('order_by', 'Ordenar por. Ex: tabela.coluna desc', false)]
    property order_by: String read Forder_by write Forder_by;

    [SwagString]
    [SwagProp('where_pk_in', 'Filtro por chaves primárias. Ex: 1,7,18', false)]
    property where_pk_in: String read Fwhere_pk_in write Fwhere_pk_in;

    [SwagString]
    [SwagProp('custom_search_content', 'Contéudo para pesquisa customizada', false)]
    property custom_search_content: String read Fcustom_search_content write Fcustom_search_content;

    [SwagNumber]
    [SwagProp('id_search_content', 'Contéudo para pesquisar por ID', false)]
    property id_search_content: Int64 read Fid_search_content write Fid_search_content;

    [SwagString]
    [SwagProp('ETag', 'If-None-Match', false)]
    property etag: String read Fetag write Fetag;

    [SwagIgnore]
    [DISABLE]
    property acl_user_id: Int64 read Facl_user_id write Facl_user_id;
  end;

implementation

const
  CURRENT_PAGE_DEFAULT = 1;
  LIMIT_PER_PAGE_DEFAULT = 50;

{ TBaseFilterDTO }

constructor TBaseFilterDTO.Create;
begin
  inherited Create;
  Fcurrent_page   := CURRENT_PAGE_DEFAULT;
  Flimit_per_page := LIMIT_PER_PAGE_DEFAULT;
end;

procedure TBaseFilterDTO.Setcurrent_page(const Value: Integer);
begin
  Fcurrent_page := Value;
  if (Fcurrent_page <= 0) then
    Fcurrent_page := CURRENT_PAGE_DEFAULT;
end;

procedure TBaseFilterDTO.Setlimit_per_page(const Value: Integer);
begin
  Flimit_per_page := Value;
  if (Flimit_per_page <= 0) then
    Flimit_per_page := LIMIT_PER_PAGE_DEFAULT;
end;

end.
