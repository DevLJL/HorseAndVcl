unit uAclRole.Show.DTO;

interface

uses
  uAclRole.Input.DTO,
  Horse.Request,
  GBSwagger.Model.Attributes,
  XSuperObject,
  uSmartPointer,
  uAppRest.Types,
  uResponse.DTO,
  System.Generics.Collections;

type
  TAclRoleShowDTO = class(TAclRoleInputDTO)
  private
    Fid: Int64;
  public
    [SwagNumber]
    [SwagProp('id', 'ID', true)]
    property id: Int64 read Fid write Fid;
  end;

  // ---------------------------------------------------------------------------
  // SwaggerDoc
  // ---------------------------------------------------------------------------
  TAclRoleShowResponseDTO = class(TResponseDTO)
  private
    Fdata: TAclRoleShowDTO;
  public
    property data: TAclRoleShowDTO read Fdata write Fdata;
  end;

  TAclRoleIndexDataResponseDTO = class
  private
    Fmeta: TResponseMetaDTO;
    Fresult: TObjectList<TAclRoleShowDTO>;
  public
    property result: TObjectList<TAclRoleShowDTO> read Fresult write Fresult;
    property meta: TResponseMetaDTO read Fmeta write Fmeta;
  end;

  TAclRoleIndexResponseDTO = class(TResponseDTO)
  private
    Fdata: TAclRoleIndexDataResponseDTO;
  public
    property data: TAclRoleIndexDataResponseDTO read Fdata write Fdata;
  end;
  // ---------------------------------------------------------------------------

implementation

end.

