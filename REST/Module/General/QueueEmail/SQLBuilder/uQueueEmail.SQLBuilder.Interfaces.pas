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
    ['{A4559ADA-8FE2-409B-B38A-F7DBA20E7122}']

    // QueueEmail
    function SelectAll: String;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;

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

end.

