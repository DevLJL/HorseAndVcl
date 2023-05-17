unit uStation.Input.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  uBase.DTO,
  XSuperObject,
  uSmartPointer;

type
  TStationInputDTO = class(TBaseDTO)
  private
    Fname: String;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TStationInputDTO;
    {$ENDIF}

    [SwagString(100)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;
  end;

implementation

uses
  System.SysUtils,
  {$IFDEF APPREST}
  uMyClaims,
  {$ENDIF}
  uHlp;

{ TStationInputDTO }

{$IFDEF APPREST}
class function TStationInputDTO.FromReq(AReq: THorseRequest): TStationInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result := TStationInputDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

