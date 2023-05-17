unit uQueueEmail.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uQueueEmail;

type
  IQueueEmailRepository = interface(IBaseRepository)
    ['{D988894A-6C51-4AC9-90E1-797F31D22D90}']
    function Show(AId: Int64): TQueueEmail;
  end;

implementation

end.


