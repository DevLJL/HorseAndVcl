unit uProduct.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  uResponse.DTO,
  {$ENDIF}
  uProduct.Input.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections;

type
  TProductShowDTO = class(TProductInputDTO)
  private
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_name: String;
    Fcreated_at: TDateTime;
    Fcreated_by_acl_user_name: String;
    Fid: Int64;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;
    Fncm_name: String;
    Fmarketup: Double;
    Fcategory_name: String;
    Fsize_name: String;
    Fncm_code: String;
    Fbrand_name: String;
    Funit_name: String;
    Fstorage_location_name: String;
  public
    [SwagNumber]
    [SwagProp('id', 'ID', true)]
    property id: Int64 read Fid write Fid;

    [SwagNumber]
    [SwagProp('marketup', 'Lucro', true)]
    property marketup: Double read Fmarketup write Fmarketup;

    [SwagDate(DATETIME_DISPLAY_FORMAT)]
    [SwagProp('created_at', CREATED_AT_DISPLAY, true)]
    property created_at: TDateTime read Fcreated_at write Fcreated_at;

    [SwagDate(DATETIME_DISPLAY_FORMAT)]
    [SwagProp('updated_at', UPDATED_AT_DISPLAY)]
    property updated_at: TDateTime read Fupdated_at write Fupdated_at;

    [SwagNumber]
    [SwagProp('created_by_acl_user_id', CREATED_BY_ACL_USER_ID, true)]
    property created_by_acl_user_id: Int64 read Fcreated_by_acl_user_id write Fcreated_by_acl_user_id;

    [SwagNumber]
    [SwagProp('updated_by_acl_user_id', UPDATED_BY_ACL_USER_ID)]
    property updated_by_acl_user_id: Int64 read Fupdated_by_acl_user_id write Fupdated_by_acl_user_id;

    [SwagString]
    [SwagProp('created_by_acl_user_name', CREATED_BY_ACL_USER_NAME, true)]
    property created_by_acl_user_name: String read Fcreated_by_acl_user_name write Fcreated_by_acl_user_name;

    [SwagString]
    [SwagProp('updated_by_acl_user_name', UPDATED_BY_ACL_USER_NAME)]
    property updated_by_acl_user_name: String read Fupdated_by_acl_user_name write Fupdated_by_acl_user_name;

    [SwagString]
    [SwagProp('unit_name', 'Unidade de Medida (ID)', true)]
    property unit_name: String read Funit_name write Funit_name;

    [SwagString]
    [SwagProp('ncm_code', 'NCM (Código)', true)]
    property ncm_code: String read Fncm_code write Fncm_code;

    [SwagString]
    [SwagProp('ncm_name', 'NCM (Código)', true)]
    property ncm_name: String read Fncm_name write Fncm_name;

    [SwagString]
    [SwagProp('category_name', 'Categoria (Nome)', true)]
    property category_name: String read Fcategory_name write Fcategory_name;

    [SwagString]
    [SwagProp('brand_name', 'Marca (Nome)', true)]
    property brand_name: String read Fbrand_name write Fbrand_name;

    [SwagString]
    [SwagProp('size_name', 'Tamanho (Nome)', true)]
    property size_name: String read Fsize_name write Fsize_name;

    [SwagString]
    [SwagProp('storage_location_name', 'Local de Armazenamento (Nome)', true)]
    property storage_location_name: String read Fstorage_location_name write Fstorage_location_name;
  end;

  {$IFDEF APPREST}
  // ---------------------------------------------------------------------------
  // SwaggerDoc
  // ---------------------------------------------------------------------------
  TProductShowResponseDTO = class(TResponseDTO)
  private
    Fdata: TProductShowDTO;
  public
    property data: TProductShowDTO read Fdata write Fdata;
  end;

  TProductIndexDataResponseDTO = class
  private
    Fmeta: TResponseMetaDTO;
    Fresult: TObjectList<TProductShowDTO>;
  public
    property result: TObjectList<TProductShowDTO> read Fresult write Fresult;
    property meta: TResponseMetaDTO read Fmeta write Fmeta;
  end;

  TProductIndexResponseDTO = class(TResponseDTO)
  private
    Fdata: TProductIndexDataResponseDTO;
  public
    property data: TProductIndexDataResponseDTO read Fdata write Fdata;
  end;
  // ---------------------------------------------------------------------------
  {$ENDIF}

implementation

end.

