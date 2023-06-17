unit uQueueEmail.SQLBuilder.MySQL;

interface

uses
  uQueueEmail.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uQueueEmail.Filter,
  uBase.Entity,
  uQueueEmailAttachment,
  uQueueEmailContact;

type
  TQueueEmailSQLBuilderMySQL = class(TInterfacedObject, IQueueEmailSQLBuilder)
  public
    class function Make: IQueueEmailSQLBuilder;

    // QueueEmail
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;

    // QueueEmailAttachment
    function SelectQueueEmailAttachmentsByQueueEmailId(AQueueEmailId: Int64): String;
    function DeleteQueueEmailAttachmentsByQueueEmailId(AQueueEmailId: Int64): String;
    function InsertQueueEmailAttachment(AQueueEmailAttachment: TQueueEmailAttachment): String;

    // QueueEmailContact
    function SelectQueueEmailContactsByQueueEmailId(AQueueEmailId: Int64): String;
    function DeleteQueueEmailContactsByQueueEmailId(AQueueEmailId: Int64): String;
    function InsertQueueEmailContact(AQueueEmailContact: TQueueEmailContact): String;
  end;

implementation

uses
  uZLConnection.Types,
  System.SysUtils,
  uQueueEmail,
  uAppRest.Types,
  uQuotedStr,
  uHlp;

{ TQueueEmailSQLBuilderMySQL }

function TQueueEmailSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM queue_email WHERE queue_email.id = %s';
  Result := Format(LSQL, [AId.ToString]);
end;

function TQueueEmailSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM queue_email WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TQueueEmailSQLBuilderMySQL.DeleteQueueEmailAttachmentsByQueueEmailId(AQueueEmailId: Int64): String;
begin
  const LSQL = 'DELETE FROM queue_email_attachment WHERE queue_email_attachment.queue_email_id = %s';
  Result := Format(LSQL, [AQueueEmailId.ToString]);
end;

function TQueueEmailSQLBuilderMySQL.DeleteQueueEmailContactsByQueueEmailId(AQueueEmailId: Int64): String;
begin
  const LSQL = 'DELETE FROM queue_email_contact WHERE queue_email_contact.queue_email_id = %s';
  Result := Format(LSQL, [AQueueEmailId.ToString]);
end;

function TQueueEmailSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO queue_email '+
               '   (uuid, reply_to, priority, subject, message, sent, sent_error, current_retries, created_at) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s, %s, %s) ';
  const LQueueEmail = AEntity as TQueueEmail;
  Result := Format(LSQL, [
    Q(LQueueEmail.uuid),
    Q(LQueueEmail.reply_to),
    Q(Ord(LQueueEmail.priority)),
    Q(LQueueEmail.subject),
    Q(LQueueEmail.message),
    Q(Ord(LQueueEmail.sent)),
    Q(LQueueEmail.sent_error),
    Q(LQueueEmail.current_retries),
    Q(Now(), TDBDriver.dbMYSQL)
  ]);
end;

function TQueueEmailSQLBuilderMySQL.InsertQueueEmailAttachment(AQueueEmailAttachment: TQueueEmailAttachment): String;
begin
  const LSQL = ' INSERT INTO queue_email_attachment '+
               '   (queue_email_id, file_name, base64) '+
               ' VALUES '+
               '   (%s, %s, %s) ';
  Result := Format(LSQL, [
    Q(AQueueEmailAttachment.queue_email_id),
    Q(AQueueEmailAttachment.file_name),
    Q(AQueueEmailAttachment.base64)
  ]);
end;

function TQueueEmailSQLBuilderMySQL.InsertQueueEmailContact(AQueueEmailContact: TQueueEmailContact): String;
begin
  const LSQL = ' INSERT INTO queue_email_contact '+
               '   (queue_email_id, email, name, type) '+
               ' VALUES '+
               '   (%s, %s, %s, %s) ';
  Result := Format(LSQL, [
    Q(AQueueEmailContact.queue_email_id),
    Q(AQueueEmailContact.email),
    Q(AQueueEmailContact.name),
    Q(Ord(AQueueEmailContact.&type))
  ]);
end;

function TQueueEmailSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TQueueEmailSQLBuilderMySQL.Make: IQueueEmailSQLBuilder;
begin
  Result := Self.Create;
end;

function TQueueEmailSQLBuilderMySQL.SelectAll: String;
begin
  Result :=  ' SELECT '+
             '   queue_email.* '+
             ' FROM '+
             '   queue_email ';
end;

function TQueueEmailSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'queue_email.id', ddMySql);
end;

function TQueueEmailSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE queue_email.id = ' + AId.ToString;
end;

function TQueueEmailSQLBuilderMySQL.SelectQueueEmailAttachmentsByQueueEmailId(AQueueEmailId: Int64): String;
begin
  const LSQL = ' SELECT '+
               '   queue_email_attachment.* '+
               ' FROM '+
               '   queue_email_attachment '+
               ' WHERE '+
               '   queue_email_attachment.queue_email_id = %s '+
               ' ORDER BY '+
               '   queue_email_attachment.id';
  Result := Format(lSQL, [AQueueEmailId.ToString]);
end;

function TQueueEmailSQLBuilderMySQL.SelectQueueEmailContactsByQueueEmailId(AQueueEmailId: Int64): String;
begin
  const LSQL = ' SELECT '+
               '   queue_email_contact.* '+
               ' FROM '+
               '   queue_email_contact '+
               ' WHERE '+
               '   queue_email_contact.queue_email_id = %s '+
               ' ORDER BY '+
               '   queue_email_contact.id';
  Result := Format(lSQL, [AQueueEmailId.ToString]);
end;

function TQueueEmailSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE queue_email SET '+
                '   uuid = %s, '+
                '   reply_to = %s, '+
                '   priority = %s, '+
                '   subject = %s, '+
                '   message = %s, '+
                '   sent = %s, '+
                '   sent_error = %s, '+
                '   current_retries = %s, '+
                '   updated_at = %s '+
               ' WHERE '+
               '   id = %s ';
  const LQueueEmail = AEntity as TQueueEmail;
  Result := Format(LSQL, [
    Q(LQueueEmail.uuid),
    Q(LQueueEmail.reply_to),
    Q(Ord(LQueueEmail.priority)),
    Q(LQueueEmail.subject),
    Q(LQueueEmail.message),
    Q(Ord(LQueueEmail.sent)),
    Q(LQueueEmail.sent_error),
    Q(LQueueEmail.current_retries),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LQueueEmail.id)
  ]);
end;

end.
