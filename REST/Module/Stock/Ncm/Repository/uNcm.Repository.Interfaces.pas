unit uNcm.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uNcm;

type
  INcmRepository = interface(IBaseRepository)
    ['{820D3BE1-20AD-4852-8506-79D0E6704314}']
    function Show(AId: Int64): TNcm;
  end;

implementation

end.


