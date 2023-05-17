unit uQueueEmail.Types;

interface

{$SCOPEDENUMS ON}
type
  TQueueEmailPriority    = (Highest, High, Normal, Low, Lowest);
  TQueueEmailSent        = (No, Yes, Error);
  TQueueEmailContactType = (Recipient, ReceiptRecipient, CarbonCopy, BlindCarbonCopy);

implementation

end.

