unit uConnection.Factory;

interface

uses
  uZLConnection.Interfaces,
  uZLConnection.Types;

type
  TConnectionFactory = class
  public
    class function Make(AConnType: TZLConnLibType = ctDefault): IZLConnection;
  end;

implementation

{ TConnectionFactory }

uses
  uZLConnection.FireDAC,
  uEnv.Rest;

class function TConnectionFactory.Make(AConnType: TZLConnLibType): IZLConnection;
var
  lConnType: TZLConnLibType;
begin
  lConnType := AConnType;
  if (lConnType = ctDefault) then
    lConnType := ENV_REST.DefaultConnLibType;

  case lConnType of
    ctFireDAC: Result := TZLConnectionFireDAC.Make(
      ENV_REST.Database,
      ENV_REST.Server,
      ENV_REST.UserName,
      ENV_REST.Password,
      ENV_REST.Driver,
      ENV_REST.VendorLib
    );
    ctADO: ;
    ctZEOS: ;
  end;
end;

end.
