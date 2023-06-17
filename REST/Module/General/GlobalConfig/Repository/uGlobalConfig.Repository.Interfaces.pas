unit uGlobalConfig.Repository.Interfaces;

interface

uses
  uBase.Repository.Interfaces,
  uGlobalConfig;

type
  IGlobalConfigRepository = interface(IBaseRepository)
    ['{510E515B-592C-46C2-ACDD-0AF0A1FB26EC}']
    function Show(AId: Int64): TGlobalConfig;
  end;

implementation

end.


