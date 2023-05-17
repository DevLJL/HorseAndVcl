unit uCity.Filter.DTO;

interface

uses
  uBase.Filter.DTO,
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  XSuperObject,
  uSmartPointer;

type
  TCityFilterDTO = class(TBaseFilterDTO)
  private
    Fibge_code: String;
  public
    [SwagNumber]
    [SwagProp('ibge_code', 'Cód IBGE da Cidade', false)]
    property ibge_code: String read Fibge_code write Fibge_code;

    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TCityFilterDTO;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TCityFilterDTO }

{$IFDEF APPREST}
class function TCityFilterDTO.FromReq(AReq: THorseRequest): TCityFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TCityFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

