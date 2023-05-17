unit uQueueEmail.Input.DTO;

interface

uses
  uBase.DTO,
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  XSuperObject,
  uSmartPointer,
  uQueueEmail.Types,
  System.Generics.Collections,
  uQueueEmailAttachment.Input.DTO,
  uQueueEmailContact.Input.DTO;

type
  TQueueEmailInputDTO = class(TBaseDTO)
  private
    Fsent: TQueueEmailSent;
    Fmessage: String;
    Fuuid: string;
    Fsubject: String;
    Fcurrent_retries: SmallInt;
    Freply_to: String;
    Fpriority: TQueueEmailPriority;

    // OneToMany
    Fqueue_email_contacts: TObjectList<TQueueEmailContactInputDTO>;
    Fqueue_email_attachments: TObjectList<TQueueEmailAttachmentInputDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TQueueEmailInputDTO;
    {$ENDIF}

    [SwagString(36)]
    [SwagProp('uuid', 'UUID', true)]
    property uuid: string read Fuuid write Fuuid;

    [SwagString]
    [SwagProp('reply_to', 'Responder para. Exemplo de preenchimento: contato1@email.com nome1; contato2@email.com nome2; contato3@email.com nome3;', false)]
    property reply_to: String read Freply_to write Freply_to;

    [SwagNumber(0,4)]
    [SwagProp('priority', 'Prioridade [0..4] 0-Muito Alta, 1-Alta, 2-Normal, 3-Baixa, 4-Muito Baixa', false)]
    property priority: TQueueEmailPriority read Fpriority write Fpriority;

    [SwagString(255)]
    [SwagProp('subject', 'Assunto', true)]
    property subject: String read Fsubject write Fsubject;

    [SwagString]
    [SwagProp('message', 'Mensagem', false)]
    property &message: String read Fmessage write Fmessage;

    [SwagNumber(0,2)]
    [SwagProp('sent', '[0..2] 0-Não enviado, 1-Enviado, 2-Erro', false)]
    property sent: TQueueEmailSent read Fsent write Fsent;

    [SwagNumber]
    [SwagProp('current_retries', 'Tentativas de envio', false)]
    property current_retries: SmallInt read Fcurrent_retries write Fcurrent_retries;

    // OneToMany
    property queue_email_contacts: TObjectList<TQueueEmailContactInputDTO> read Fqueue_email_contacts write Fqueue_email_contacts;
    property queue_email_attachments: TObjectList<TQueueEmailAttachmentInputDTO> read Fqueue_email_attachments write Fqueue_email_attachments;
  end;

implementation

uses
  System.SysUtils,
  {$IFDEF APPREST}
  uMyClaims,
  {$ENDIF}
  uHlp;

{ TQueueEmailInputDTO }

{$IFDEF APPREST}
constructor TQueueEmailInputDTO.Create;
begin
  inherited Create;
  Fqueue_email_attachments := TObjectList<TQueueEmailAttachmentInputDTO>.Create;
  Fqueue_email_contacts    := TObjectList<TQueueEmailContactInputDTO>.Create;
end;

destructor TQueueEmailInputDTO.Destroy;
begin
  if Assigned(Fqueue_email_attachments) then FreeAndNil(Fqueue_email_attachments);
  if Assigned(Fqueue_email_contacts)    then FreeAndNil(Fqueue_email_contacts);

  inherited;
end;

class function TQueueEmailInputDTO.FromReq(AReq: THorseRequest): TQueueEmailInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result := TQueueEmailInputDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

