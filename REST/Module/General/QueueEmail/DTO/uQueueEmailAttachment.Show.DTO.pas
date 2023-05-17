unit uQueueEmailAttachment.Show.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections,
  uQueueEmailAttachment.Input.DTO;

type
  TQueueEmailAttachmentShowDTO = class(TQueueEmailAttachmentInputDTO)
  private
    Fqueue_email_id: Int64;
    Fid: Int64;
  public
    [SwagNumber]
    [SwagProp('id', 'ID', true)]
    property id: Int64 read Fid write Fid;

    [SwagNumber]
    [SwagProp('queue_email_id', 'QueueEmail (ID)', true)]
    property queue_email_id: Int64 read Fqueue_email_id write Fqueue_email_id;
  end;

implementation

end.


