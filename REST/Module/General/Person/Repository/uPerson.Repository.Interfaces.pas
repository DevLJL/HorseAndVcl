unit uPerson.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uPerson;

type
  IPersonRepository = interface(IBaseRepository)
    ['{2973D75F-34B3-440F-A6B2-1242A24211B7}']
    function Show(AId: Int64): TPerson;
  end;

implementation

end.


