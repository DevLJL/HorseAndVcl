unit uQueueEmail.Repository.SQL;

interface

uses
  uBase.Repository,
  uQueueEmail.Repository.Interfaces,
  uQueueEmail.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uQueueEmail,
  uIndexResult,
  uQueueEmailAttachment,
  uQueueEmailContact;

type
  TQueueEmailRepositorySQL = class(TBaseRepository, IQueueEmailRepository)
  private
    FQueueEmailSQLBuilder: IQueueEmailSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IQueueEmailSQLBuilder);
    function  DataSetToEntity(ADtsQueueEmail: TDataSet): TBaseEntity; override;
    function  DataSetToQueueEmailAttachment(ADtsQueueEmailAttachment: TDataSet): TQueueEmailAttachment;
    function  DataSetToQueueEmailContact(ADtsQueueEmailContact: TDataSet): TQueueEmailContact;
    function  SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IQueueEmailSQLBuilder): IQueueEmailRepository;
    function Show(AId: Int64): TQueueEmail;
    function Update(AId: Int64; AEntity: TBaseEntity): Int64; override;
    function Store(AEntity: TBaseEntity): Int64; override;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TQueueEmailRepositorySQL }

class function TQueueEmailRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IQueueEmailSQLBuilder): IQueueEmailRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TQueueEmailRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IQueueEmailSQLBuilder);
begin
  inherited Create;
  FConn                := AConn;
  FSQLBuilder          := ASQLBuilder;
  FQueueEmailSQLBuilder := ASQLBuilder;
  FManageTransaction   := True;
end;

function TQueueEmailRepositorySQL.DataSetToEntity(ADtsQueueEmail: TDataSet): TBaseEntity;
begin
  Result := TQueueEmail.FromJSON(ADtsQueueEmail.ToJSONObjectString);
end;

function TQueueEmailRepositorySQL.DataSetToQueueEmailAttachment(ADtsQueueEmailAttachment: TDataSet): TQueueEmailAttachment;
begin
  Result := TQueueEmailAttachment.FromJSON(ADtsQueueEmailAttachment.ToJSONObjectString);
end;

function TQueueEmailRepositorySQL.DataSetToQueueEmailContact(ADtsQueueEmailContact: TDataSet): TQueueEmailContact;
begin
  Result := TQueueEmailContact.FromJSON(ADtsQueueEmailContact.ToJSONObjectString);
end;

function TQueueEmailRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FQueueEmailSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TQueueEmailRepositorySQL.Show(AId: Int64): TQueueEmail;
begin
  Result := Nil;
  const LQry = FConn.MakeQry;

  // QueueEmail
  const LQueueEmail = inherited ShowById(AId) as TQueueEmail;
  if not assigned(LQueueEmail) then
    Exit;

  // QueueEmailAttachment
  LQry.Open(FQueueEmailSQLBuilder.SelectQueueEmailAttachmentsByQueueEmailId(AId));
  LQry.First;
  while not LQry.Eof do
  begin
    LQueueEmail.queue_email_attachments.Add(DataSetToQueueEmailAttachment(LQry.DataSet));
    LQry.Next;
  end;

  // QueueEmailContact
  LQry.Open(FQueueEmailSQLBuilder.SelectQueueEmailContactsByQueueEmailId(AId));
  LQry.First;
  while not LQry.Eof do
  begin
    LQueueEmail.queue_email_contacts.Add(DataSetToQueueEmailContact(LQry.DataSet));
    LQry.Next;
  end;

  Result := LQueueEmail;
end;

function TQueueEmailRepositorySQL.Store(AEntity: TBaseEntity): Int64;
var
  LStoredId: Int64;
begin
  Try
    if FManageTransaction then
      FConn.StartTransaction;

    // Instanciar Qry
    const LQry = FConn.MakeQry;

    // QueueEmail
    LStoredId := inherited Store(AEntity);
    const LQueueEmail = AEntity as TQueueEmail;

    // QueueEmailAttachments
    for var LQueueEmailAttachment in LQueueEmail.queue_email_attachments do
    begin
      LQueueEmailAttachment.queue_email_id := LStoredId;
      LQry.ExecSQL(FQueueEmailSQLBuilder.InsertQueueEmailAttachment(LQueueEmailAttachment))
    end;

    // QueueEmailContacts
    for var LQueueEmailContact in LQueueEmail.queue_email_contacts do
    begin
      LQueueEmailContact.queue_email_id := LStoredId;
      LQry.ExecSQL(FQueueEmailSQLBuilder.InsertQueueEmailContact(LQueueEmailContact))
    end;

    if FManageTransaction then
      FConn.CommitTransaction;
  except on E: Exception do
    Begin
      if FManageTransaction then
        FConn.RollBackTransaction;
      raise;
    End;
  end;

  Result := LStoredId;
end;

function TQueueEmailRepositorySQL.Update(AId: Int64; AEntity: TBaseEntity): Int64;
begin
  Try
    if FManageTransaction then
      FConn.StartTransaction;

    // Instanciar Qry
    const LQry = FConn.MakeQry;

    // QueueEmail
    inherited Update(AId, AEntity);
    const LQueueEmail = AEntity as TQueueEmail;

    // QueueEmailAttachments
    LQry.ExecSQL(FQueueEmailSQLBuilder.DeleteQueueEmailAttachmentsByQueueEmailId(AId));
    for var LQueueEmailAttachment in LQueueEmail.queue_email_attachments do
    begin
      LQueueEmailAttachment.queue_email_id := AId;
      LQry.ExecSQL(FQueueEmailSQLBuilder.InsertQueueEmailAttachment(LQueueEmailAttachment))
    end;

    // QueueEmailContacts
    LQry.ExecSQL(FQueueEmailSQLBuilder.DeleteQueueEmailContactsByQueueEmailId(AId));
    for var LQueueEmailContact in LQueueEmail.queue_email_contacts do
    begin
      LQueueEmailContact.queue_email_id := AId;
      LQry.ExecSQL(FQueueEmailSQLBuilder.InsertQueueEmailContact(LQueueEmailContact))
    end;

    if FManageTransaction then
      FConn.CommitTransaction;
  except on E: Exception do
    Begin
      if FManageTransaction then
        FConn.RollBackTransaction;
      raise;
    End;
  end;

  Result := AId;
end;

procedure TQueueEmailRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


