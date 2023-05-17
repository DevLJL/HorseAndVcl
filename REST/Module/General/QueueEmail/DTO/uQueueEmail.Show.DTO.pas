unit uQueueEmail.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  uResponse.DTO,
  {$ENDIF}
  uQueueEmail.Input.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections,
  uQueueEmailAttachment.Show.DTO,
  uQueueEmailContact.Show.DTO;

type
  TQueueEmailShowDTO = class(TQueueEmailInputDTO)
  private
    Fupdated_at: TDateTime;
    Fcreated_at: TDateTime;
    Fid: Int64;

    // OneToMany
    Fqueue_email_contacts: TObjectList<TQueueEmailContactShowDTO>;
    Fqueue_email_attachments: TObjectList<TQueueEmailAttachmentShowDTO>;
  public
    constructor Create;
    destructor Destroy; override;

    [SwagNumber]
    [SwagProp('id', 'ID', true)]
    property id: Int64 read Fid write Fid;

    [SwagDate(DATETIME_DISPLAY_FORMAT)]
    [SwagProp('created_at', CREATED_AT_DISPLAY, true)]
    property created_at: TDateTime read Fcreated_at write Fcreated_at;

    [SwagDate(DATETIME_DISPLAY_FORMAT)]
    [SwagProp('updated_at', UPDATED_AT_DISPLAY)]
    property updated_at: TDateTime read Fupdated_at write Fupdated_at;

    // OneToMany
    property queue_email_contacts: TObjectList<TQueueEmailContactShowDTO> read Fqueue_email_contacts write Fqueue_email_contacts;
    property queue_email_attachments: TObjectList<TQueueEmailAttachmentShowDTO> read Fqueue_email_attachments write Fqueue_email_attachments;
  end;

  {$IFDEF APPREST}
  // ---------------------------------------------------------------------------
  // SwaggerDoc
  // ---------------------------------------------------------------------------
  TQueueEmailShowResponseDTO = class(TResponseDTO)
  private
    Fdata: TQueueEmailShowDTO;
  public
    property data: TQueueEmailShowDTO read Fdata write Fdata;
  end;

  TQueueEmailIndexDataResponseDTO = class
  private
    Fmeta: TResponseMetaDTO;
    Fresult: TObjectList<TQueueEmailShowDTO>;
  public
    property result: TObjectList<TQueueEmailShowDTO> read Fresult write Fresult;
    property meta: TResponseMetaDTO read Fmeta write Fmeta;
  end;

  TQueueEmailIndexResponseDTO = class(TResponseDTO)
  private
    Fdata: TQueueEmailIndexDataResponseDTO;
  public
    property data: TQueueEmailIndexDataResponseDTO read Fdata write Fdata;
  end;
  // ---------------------------------------------------------------------------
  {$ENDIF}

implementation

uses
  System.SysUtils;

{ TQueueEmailShowDTO }

constructor TQueueEmailShowDTO.Create;
begin
  inherited Create;
  Fqueue_email_attachments := TObjectList<TQueueEmailAttachmentShowDTO>.Create;
  Fqueue_email_contacts    := TObjectList<TQueueEmailContactShowDTO>.Create;
end;

destructor TQueueEmailShowDTO.Destroy;
begin
  if Assigned(Fqueue_email_attachments) then FreeAndNil(Fqueue_email_attachments);
  if Assigned(Fqueue_email_contacts)    then FreeAndNil(Fqueue_email_contacts);

  inherited;
end;

end.

