unit uNcm.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uNcm;

type
  INcmRepository = interface(IBaseRepository)
    ['{4DA90248-02B8-4389-818E-C47D93B1B956}']
    function Show(AId: Int64): TNcm;
  end;

implementation

end.


