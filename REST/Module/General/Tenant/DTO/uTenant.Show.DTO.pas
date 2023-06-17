unit uTenant.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  uResponse.DTO,
  {$ENDIF}
  uTenant.Input.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections;

type
  TTenantShowDTO = class(TTenantInputDTO)
  private
    Fcity_ibge_code: String;
    Fcity_name: String;
    Fid: Int64;
    Fcity_state: String;
  public
    [SwagNumber]
    [SwagProp('id', 'ID', true)]
    property id: Int64 read Fid write Fid;

    [SwagString]
    [SwagProp('city_name', 'Cidade (Nome)', true)]
    property city_name: String read Fcity_name write Fcity_name;

    [SwagString]
    [SwagProp('city_state', 'Cidade (Estado)', true)]
    property city_state: String read Fcity_state write Fcity_state;

    [SwagString]
    [SwagProp('city_ibge_code', 'Cidade (Cód IBGE da Cidade)', true)]
    property city_ibge_code: String read Fcity_ibge_code write Fcity_ibge_code;
  end;

  {$IFDEF APPREST}
  // ---------------------------------------------------------------------------
  // SwaggerDoc
  // ---------------------------------------------------------------------------
  TTenantShowResponseDTO = class(TResponseDTO)
  private
    Fdata: TTenantShowDTO;
  public
    property data: TTenantShowDTO read Fdata write Fdata;
  end;

  TTenantIndexDataResponseDTO = class
  private
    Fmeta: TResponseMetaDTO;
    Fresult: TObjectList<TTenantShowDTO>;
  public
    property result: TObjectList<TTenantShowDTO> read Fresult write Fresult;
    property meta: TResponseMetaDTO read Fmeta write Fmeta;
  end;

  TTenantIndexResponseDTO = class(TResponseDTO)
  private
    Fdata: TTenantIndexDataResponseDTO;
  public
    property data: TTenantIndexDataResponseDTO read Fdata write Fdata;
  end;
  // ---------------------------------------------------------------------------
  {$ENDIF}

implementation

end.

