unit uPerson.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uPerson;

type
  IPersonRepository = interface(IBaseRepository)
    ['{45FD0EE2-C9DB-4FB4-9CE0-C204A3973286}']
    function Show(AId: Int64): TPerson;
  end;

implementation

end.


