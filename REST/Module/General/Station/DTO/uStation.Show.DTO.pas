unit uStation.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  uResponse.DTO,
  {$ENDIF}
  uStation.Input.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections;

type
  TStationShowDTO = class(TStationInputDTO)
  private
    Fid: Int64;
  public
    [SwagNumber]
    [SwagProp('id', 'ID', true)]
    property id: Int64 read Fid write Fid;
  end;

  {$IFDEF APPREST}
  // ---------------------------------------------------------------------------
  // SwaggerDoc
  // ---------------------------------------------------------------------------
  TStationShowResponseDTO = class(TResponseDTO)
  private
    Fdata: TStationShowDTO;
  public
    property data: TStationShowDTO read Fdata write Fdata;
  end;

  TStationIndexDataResponseDTO = class
  private
    Fmeta: TResponseMetaDTO;
    Fresult: TObjectList<TStationShowDTO>;
  public
    property result: TObjectList<TStationShowDTO> read Fresult write Fresult;
    property meta: TResponseMetaDTO read Fmeta write Fmeta;
  end;

  TStationIndexResponseDTO = class(TResponseDTO)
  private
    Fdata: TStationIndexDataResponseDTO;
  public
    property data: TStationIndexDataResponseDTO read Fdata write Fdata;
  end;
  // ---------------------------------------------------------------------------
  {$ENDIF}

implementation

end.

