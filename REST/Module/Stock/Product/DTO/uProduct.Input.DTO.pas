unit uProduct.Input.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  uBase.DTO,
  XSuperObject,
  uSmartPointer,
  uProduct.Types;

type
  TProductInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Facl_user_id: Int64;
    Fflg_discontinued: SmallInt;
    Fgross_weight: Double;
    Fcost: Double;
    Fgenre: TProductGenre;
    Funit_id: Int64;
    Fpacking_weight: Double;
    Fprice: Double;
    Fcurrent_quantity: Double;
    Fstorage_location_id: Int64;
    Fmanufacturing_code: String;
    Fflg_to_move_the_stock: SmallInt;
    Fsku_code: String;
    Fncm_id: Int64;
    Fmaximum_quantity: Double;
    Fean_code: String;
    Ftype: TProductType;
    Fflg_product_for_scales: SmallInt;
    Fcomplement_note: String;
    Fnet_weight: Double;
    Fcategory_id: Int64;
    Fsize_id: Int64;
    Fbrand_id: Int64;
    Fsimplified_name: String;
    Fminimum_quantity: Double;
    Finternal_note: String;
    Fidentification_code: String;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TProductInputDTO;
    {$ENDIF}

    [SwagString(100)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;

    [SwagString(30)]
    [SwagProp('simplified_name', 'Nome Simplificado', false)]
    property simplified_name: String read Fsimplified_name write Fsimplified_name;

    [SwagNumber(0,1)]
    [SwagProp('type', 'Tipo [0..1] 0-product, 1-service]', false)]
    property &type: TProductType read Ftype write Ftype;

    [SwagString(45)]
    [SwagProp('sku_code', 'Código de Referência', false)]
    property sku_code: String read Fsku_code write Fsku_code;

    [SwagString(45)]
    [SwagProp('ean_code', 'Código de Barras', false)]
    property ean_code: String read Fean_code write Fean_code;

    [SwagString(45)]
    [SwagProp('manufacturing_code', 'Código de Fábrica', false)]
    property manufacturing_code: String read Fmanufacturing_code write Fmanufacturing_code;

    [SwagString(45)]
    [SwagProp('identification_code', 'Identificação', false)]
    property identification_code: String read Fidentification_code write Fidentification_code;

    [SwagNumber]
    [SwagProp('cost', 'Preço de Custo', false)]
    property cost: Double read Fcost write Fcost;

    [SwagNumber]
    [SwagProp('price', 'Preço de Venda', false)]
    property price: Double read Fprice write Fprice;

    [SwagNumber]
    [SwagProp('current_quantity', 'Quantidade Atual (Em Estoque)', false)]
    property current_quantity: Double read Fcurrent_quantity write Fcurrent_quantity;

    [SwagNumber]
    [SwagProp('minimum_quantity', 'Quantidade Mínima', false)]
    property minimum_quantity: Double read Fminimum_quantity write Fminimum_quantity;

    [SwagNumber]
    [SwagProp('maximum_quantity', 'Quantidade Máxima', false)]
    property maximum_quantity: Double read Fmaximum_quantity write Fmaximum_quantity;

    [SwagNumber]
    [SwagProp('gross_weight', 'Peso Bruto', false)]
    property gross_weight: Double read Fgross_weight write Fgross_weight;

    [SwagNumber]
    [SwagProp('net_weight', 'Peso Líquido', false)]
    property net_weight: Double read Fnet_weight write Fnet_weight;

    [SwagNumber]
    [SwagProp('packing_weight', 'Peso Embalado', false)]
    property packing_weight: Double read Fpacking_weight write Fpacking_weight;

    [SwagNumber(0,1)]
    [SwagProp('flg_to_move_the_stock', '[0..1] Movimentar Estoque', false)]
    property flg_to_move_the_stock: SmallInt read Fflg_to_move_the_stock write Fflg_to_move_the_stock;

    [SwagNumber(0,1)]
    [SwagProp('flg_product_for_scales', '[0..1] Item de balança', false)]
    property flg_product_for_scales: SmallInt read Fflg_product_for_scales write Fflg_product_for_scales;

    [SwagString]
    [SwagProp('internal_note', 'Observação Interna', false)]
    property internal_note: String read Finternal_note write Finternal_note;

    [SwagString]
    [SwagProp('complement_note', 'Complemento', false)]
    property complement_note: String read Fcomplement_note write Fcomplement_note;

    [SwagNumber(0,1)]
    [SwagProp('flg_discontinued', '[0..1] Descontinuado', false)]
    property flg_discontinued: SmallInt read Fflg_discontinued write Fflg_discontinued;

    [SwagNumber]
    [SwagProp('unit_id', 'Unidade de Medida (ID)', true)]
    property unit_id: Int64 read Funit_id write Funit_id;

    [SwagNumber]
    [SwagProp('ncm_id', 'NCM (ID)', true)]
    property ncm_id: Int64 read Fncm_id write Fncm_id;

    [SwagNumber]
    [SwagProp('category_id', 'Categoria (ID)', false)]
    property category_id: Int64 read Fcategory_id write Fcategory_id;

    [SwagNumber]
    [SwagProp('brand_id', 'Marca (ID)', false)]
    property brand_id: Int64 read Fbrand_id write Fbrand_id;

    [SwagNumber]
    [SwagProp('size_id', 'Tamanho (ID)', false)]
    property size_id: Int64 read Fsize_id write Fsize_id;

    [SwagNumber]
    [SwagProp('storage_location_id', 'Local de Armazenamento (ID)', false)]
    property storage_location_id: Int64 read Fstorage_location_id write Fstorage_location_id;

    [SwagNumber]
    [SwagProp('genre', 'Gênero [0..3] 0-Nenhum, 1-Masculino, 2-Geminino, 3-Unisex', false)]
    property genre: TProductGenre read Fgenre write Fgenre;

    [SwagIgnore]
    [DISABLE]
    property acl_user_id: Int64 read Facl_user_id write Facl_user_id;
  end;

implementation

uses
  System.SysUtils,
  {$IFDEF APPREST}
  uMyClaims,
  {$ENDIF}
  uHlp;

{ TProductInputDTO }

{$IFDEF APPREST}
class function TProductInputDTO.FromReq(AReq: THorseRequest): TProductInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TProductInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := StrInt(AReq.Session<TMyClaims>.Id);
end;
{$ENDIF}

end.

