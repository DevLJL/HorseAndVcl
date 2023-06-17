unit uQueueEmail.SendPending.UseCase;

interface

uses
  uRepository.Factory,
  uTenant.Repository.Interfaces,
  uQueueEmail.Repository.Interfaces,
  uZLMemTable.Interfaces,
  uTenant,
  SendEmail,
  System.Classes,
  System.Generics.Collections,
  uQueueEmail;

type
  IQueueEmailSendPendingUseCase = Interface
    ['{B1DD177F-1452-4456-9F01-7760472C752F}']
    /// <returns>
    ///   Quantidade de E-mail(s) Enviado(s) c/ Sucesso
    /// </returns>
    function Execute: Integer;
  End;

  TQueueEmailSendPendingUseCase = class(TInterfacedObject, IQueueEmailSendPendingUseCase)
  private
    FTenantRepository: ITenantRepository;
    FQueueEmailRepository: IQueueEmailRepository;
    FQueueEmails: IZLMemTable;
    FCurrentQueueEmail: TQueueEmail;
    FTenant: TTenant;
    FSendEmailLib: TSendEmail;
    FSuccessfulSendCount: Integer;
    FMemoryStreams: TObjectList<TMemoryStream>;
    destructor Destroy; override;
    constructor Create(ARepositoryFactory: IRepositoryFactory);
    function ListEmailsPendingDelivery: IQueueEmailSendPendingUseCase;
    function QueueEmailsPendingDelivery: IQueueEmailSendPendingUseCase;
    function SetUpEmailDelivery: IQueueEmailSendPendingUseCase;
    function LoadRecipients: IQueueEmailSendPendingUseCase;
    function LoadReceiptRecipients: IQueueEmailSendPendingUseCase;
    function LoadReplyTo: IQueueEmailSendPendingUseCase;
    function LoadCarbonCopies: IQueueEmailSendPendingUseCase;
    function LoadBlindCarbonCopies: IQueueEmailSendPendingUseCase;
    function LoadAttachments: IQueueEmailSendPendingUseCase;
    function DeliverEmail: IQueueEmailSendPendingUseCase;
  public
    class function Make(ARepositoryFactory: IRepositoryFactory): IQueueEmailSendPendingUseCase;
    function Execute: Integer;
  end;

implementation

{ TQueueEmailSendPendingUseCase }

uses
  System.SysUtils,
  uQueueEmail.Filter,
  uFilter.Types,
  uQueueEmail.Types,
  uSmartPointer,
  uHlp,
  uQuotedStr,
  System.NetEncoding;

const
  MAX_RETRY = 3;

class function TQueueEmailSendPendingUseCase.Make(ARepositoryFactory: IRepositoryFactory): IQueueEmailSendPendingUseCase;
begin
  Result := Self.Create(ARepositoryFactory);
end;

constructor TQueueEmailSendPendingUseCase.Create(ARepositoryFactory: IRepositoryFactory);
begin
  inherited Create;
  FTenantRepository    := ARepositoryFactory.Tenant;
  FQueueEmailRepository := ARepositoryFactory.QueueEmail;
  FSuccessfulSendCount  := 0;
  FMemoryStreams        := TObjectList<TMemoryStream>.Create;
end;

function TQueueEmailSendPendingUseCase.Execute: Integer;
begin
  FTenant := FTenantRepository.Show(1); {Configuração de envio do e-mail}
  ListEmailsPendingDelivery;            {Listar E-mails Pendentes}
  QueueEmailsPendingDelivery;           {Enviar E-mails Pendentes}

  Result := FSuccessfulSendCount;
end;

function TQueueEmailSendPendingUseCase.ListEmailsPendingDelivery: IQueueEmailSendPendingUseCase;
begin
  Result := Self;

  // Filtrar E-mails Pendentes de Envio
  FQueueEmails := FQueueEmailRepository.Index(
    TQueueEmailFilter.Make
      .Where(TParentheses.OpenAndClose, 'queue_email.sent',            TCondition.Equal, Ord(TQueueEmailSent.No).ToString)
      .&Or(TParentheses.Open,           'queue_email.sent',            TCondition.Equal, Ord(TQueueEmailSent.Error).ToString)
      .&And(TParentheses.Close,         'queue_email.current_retries', TCondition.Less,  MAX_RETRY.ToString)
  ).Data;
end;

function TQueueEmailSendPendingUseCase.QueueEmailsPendingDelivery: IQueueEmailSendPendingUseCase;
begin
  Result := Self;
  if FQueueEmails.IsEmpty then
    Exit;

  // Loop em E-mails p/ Envio
  FQueueEmails.First;
  while not FQueueEmails.Eof do
  begin
    FCurrentQueueEmail := FQueueEmailRepository.Show(FQueueEmails.FieldByName('id').AsLargeInt);

    SetUpEmailDelivery;
    LoadRecipients;        {Destinatários}
    LoadReceiptRecipients; {Confirmação de resposta dos destinatários}
    LoadReplyTo;           {Responder para ...}
    LoadCarbonCopies;      {Cópias}
    LoadBlindCarbonCopies; {Cópias ocultas}
    LoadAttachments;       {Anexos}
    DeliverEmail;          {Enviar E-mail}

    // Próximo E-mail
    FQueueEmails.Next;
  end;
end;

function TQueueEmailSendPendingUseCase.SetUpEmailDelivery: IQueueEmailSendPendingUseCase;
begin
  // Configurar E-mail
  FSendEmailLib := TSendEmail.New
    .Clear
    .ClearRecipient
    .From(FTenant.send_email_email, FTenant.send_email_identification)
    .Host(FTenant.send_email_smtp)
    .Port(StrInt(FTenant.send_email_port))
    .Auth(True)
    .UserName(FTenant.send_email_user)
    .Password(FTenant.send_email_password)
    .SSL(IntBool(FTenant.send_email_ssl))
    .TLS(IntBool(FTenant.send_email_tls));
end;

function TQueueEmailSendPendingUseCase.LoadRecipients: IQueueEmailSendPendingUseCase;
begin
  Result := Self;

  for var LContact in FCurrentQueueEmail.queue_email_contacts do
  begin
    if (LContact.&type = TQueueEmailContactType.Recipient) then
      FSendEmailLib.AddTo(LContact.email, LContact.name);
  end;
end;

function TQueueEmailSendPendingUseCase.LoadReceiptRecipients: IQueueEmailSendPendingUseCase;
begin
  Result := Self;

  for var LContact in FCurrentQueueEmail.queue_email_contacts do
  begin
    if (LContact.&type = TQueueEmailContactType.ReceiptRecipient) then
      FSendEmailLib.AddReceiptRecipient(LContact.email, LContact.name);
  end;
end;

function TQueueEmailSendPendingUseCase.LoadReplyTo: IQueueEmailSendPendingUseCase;
begin
  Result := Self;
  if not FCurrentQueueEmail.reply_to.Trim.IsEmpty then
    FSendEmailLib.AddReplyTo(FCurrentQueueEmail.reply_to);
end;

function TQueueEmailSendPendingUseCase.LoadCarbonCopies: IQueueEmailSendPendingUseCase;
begin
  Result := Self;

  for var LContact in FCurrentQueueEmail.queue_email_contacts do
  begin
    if (LContact.&type = TQueueEmailContactType.CarbonCopy) then
      FSendEmailLib.AddCC(LContact.email, LContact.name);
  end;
end;

function TQueueEmailSendPendingUseCase.LoadBlindCarbonCopies: IQueueEmailSendPendingUseCase;
begin
  Result := Self;

  for var LContact in FCurrentQueueEmail.queue_email_contacts do
  begin
    if (LContact.&type = TQueueEmailContactType.BlindCarbonCopy) then
      FSendEmailLib.AddBCC(LContact.email, LContact.name);
  end;
end;

function TQueueEmailSendPendingUseCase.LoadAttachments: IQueueEmailSendPendingUseCase;
begin
  Result := Self;

  for var LAttachment in FCurrentQueueEmail.queue_email_attachments do
  begin
    FMemoryStreams.Add(LAttachment.base64ToMemoryStream);
    FSendEmailLib.AddAttachment(FMemoryStreams.Last, LAttachment.file_name);
  end;
end;

function TQueueEmailSendPendingUseCase.DeliverEmail: IQueueEmailSendPendingUseCase;
const
  LSQL = ' UPDATE queue_email SET '+
         '   sent = %s, '+
         '   sent_error = %s, '+
         '   current_retries = current_retries+1, '+
         '   updated_at = %s '+
         ' WHERE '+
         '   id = %s ';
begin
  Try
    FSendEmailLib
      .Priority(TPriority(FQueueEmails.FieldByName('priority').AsInteger))
      .Subject(FQueueEmails.FieldByName('subject').AsString)
      .Message(FQueueEmails.FieldByName('message').AsString, True)
      .Send;
  except on E: Exception do
    Begin
      // Atualizar status do e-mail
      {TODO -oOwner -cGeneral : Precisa refatorar}
      FQueueEmailRepository.Conn.MakeQry.ExecSQL(Format(LSQL, [
        Q(Ord(TQueueEmailSent.Error)),
        Q(E.Message),
        Q(Now(), TDBDriver.dbMYSQL),
        Q(FQueueEmails.FieldByName('id').AsInteger)
      ]));
      Exit;
    End;
  end;

  // Atualizar status do e-mail
  {TODO -oOwner -cGeneral : Precisa refatorar}
  FQueueEmailRepository.Conn.MakeQry.ExecSQL(Format(LSQL, [
    Q(Ord(TQueueEmailSent.Yes)),
    Q(''),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(FQueueEmails.FieldByName('id').AsInteger)
  ]));
  Inc(FSuccessfulSendCount);
end;

destructor TQueueEmailSendPendingUseCase.Destroy;
begin
  if Assigned(FTenant)           then FreeAndNil(FTenant);
  if Assigned(FMemoryStreams)     then FreeAndNil(FMemoryStreams);
  if Assigned(FCurrentQueueEmail) then FreeAndNil(FCurrentQueueEmail);

  inherited;
end;

end.
