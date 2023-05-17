unit uQueueEmail;

interface

uses
  uAppRest.Types,
  uQueueEmail.Types,
  uAclUser,
  uBase.Entity,
  Data.DB,
  uQueueEmailAttachment,
  uQueueEmailContact,
  System.Generics.Collections;

type
  TQueueEmail = class(TBaseEntity)
  private
    Fid: Int64;
    Fuuid: string;
    Fcreated_at: TDateTime;
    Fupdated_at: TDateTime;
    Fmessage: String;
    Fsubject: String;
    Fcurrent_retries: SmallInt;
    Freply_to: String;
    Fsent: TQueueEmailSent;
    Fsent_error: String;
    Fpriority: TQueueEmailPriority;

    // OneToMany
    Fqueue_email_attachments: TObjectList<TQueueEmailAttachment>;
    Fqueue_email_contacts: TObjectList<TQueueEmailContact>;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property uuid: string read Fuuid write Fuuid;
    property reply_to: String read Freply_to write Freply_to;
    property priority: TQueueEmailPriority read Fpriority write Fpriority;
    property subject: String read Fsubject write Fsubject;
    property &message: String read Fmessage write Fmessage;
    property sent: TQueueEmailSent read Fsent write Fsent;
    property sent_error: String read Fsent_error write Fsent_error;
    property current_retries: SmallInt read Fcurrent_retries write Fcurrent_retries;
    property created_at: TDateTime read Fcreated_at write Fcreated_at;
    property updated_at: TDateTime read Fupdated_at write Fupdated_at;

    // OneToMany
    property queue_email_attachments: TObjectList<TQueueEmailAttachment> read Fqueue_email_attachments write Fqueue_email_attachments;
    property queue_email_contacts: TObjectList<TQueueEmailContact> read Fqueue_email_contacts write Fqueue_email_contacts;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uApplication.Exception,
  uTrans,
  uHlp;

{ TQueueEmail }

constructor TQueueEmail.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TQueueEmail.Destroy;
begin
  if Assigned(Fqueue_email_attachments) then Fqueue_email_attachments.Free;
  if Assigned(Fqueue_email_contacts)    then Fqueue_email_contacts.Free;
  inherited;
end;

procedure TQueueEmail.Initialize;
begin
  Fqueue_email_attachments := TObjectList<TQueueEmailAttachment>.Create;
  Fqueue_email_contacts    := TObjectList<TQueueEmailContact>.Create;
end;

function TQueueEmail.Validate: String;
var
  LHasRecipient: Boolean;
begin
  Result := EmptyStr;
  const LIsInserting = (Fid = 0);

  if (Fuuid.Trim.Length <> 36) then
    Result := Result + Trans.FieldWasNotInformed('UUID (Identificação)') + #13;

  if Fsubject.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Assunto') + #13;

  // QueueEmailAttachment
  for var lI := 0 to Pred(Fqueue_email_attachments.Count) do
  begin
    const LCurrentError = Fqueue_email_attachments.Items[lI].Validate;
    if not LCurrentError.Trim.IsEmpty then
      Result := Result + '   Anexos > Item ' + StrZero((lI+1).ToString,3) + ': ' + LCurrentError;
  end;

  // QueueEmailContact
  if (Fqueue_email_contacts.Count <= 0) then Result := Result + 'Nenhum Contato de E-mail informado.';
  for var lI := 0 to Pred(Fqueue_email_contacts.Count) do
  begin
    if not LHasRecipient then
      LHasRecipient := (Fqueue_email_contacts.Items[lI].&type = TQueueEmailContactType.Recipient);

    const LCurrentError = Fqueue_email_contacts.Items[lI].Validate;
    if not LCurrentError.Trim.IsEmpty then
      Result := Result + '   Contatos > Item ' + StrZero((lI+1).ToString,3) + ': ' + LCurrentError;
  end;

  // Existe um destinatário informado
  if not LHasRecipient then
    Result := Result + 'Nenhum destinatário informado em Contatos';
end;

end.
