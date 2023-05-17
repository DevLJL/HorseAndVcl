unit uQueueEmail.SQLBuilder.Interfaces;

interface

uses
  uBase.SQLBuilder.Interfaces,
  uSelectWithFilter,
  uFilter,
  uQueueEmailAttachment,
  uQueueEmailContact;

type
  IQueueEmailSQLBuilder = interface(IBaseSQLBuilder)
    ['{01AC99C9-A17E-4164-9B49-4703C8B69915}']

    // QueueEmail
    function ScriptSeedTable: String;
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;

    // QueueEmailAttachment
    function ScriptCreateQueueEmailAttachmentTable: String;
    function SelectQueueEmailAttachmentsByQueueEmailId(AQueueEmailId: Int64): String;
    function DeleteQueueEmailAttachmentsByQueueEmailId(AQueueEmailId: Int64): String;
    function InsertQueueEmailAttachment(AQueueEmailAttachment: TQueueEmailAttachment): String;

    // QueueEmailContact
    function ScriptCreateQueueEmailContactTable: String;
    function SelectQueueEmailContactsByQueueEmailId(AQueueEmailId: Int64): String;
    function DeleteQueueEmailContactsByQueueEmailId(AQueueEmailId: Int64): String;
    function InsertQueueEmailContact(AQueueEmailContact: TQueueEmailContact): String;
  end;

implementation

end.

