unit uPriceList.Input.DTO;

interface

uses
  uBase.DTO,
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  XSuperObject,
  uSmartPointer;

type
  TPriceListInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Facl_user_id: Int64;
    Fshort_description: String;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TPriceListInputDTO;
    {$ENDIF}

    [SwagString(100)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;

    [SwagString(100)]
    [SwagProp('short_description', 'Descrição curta', false)]
    property short_description: String read Fshort_description write Fshort_description;

    [SwagIgnore]
    [DISABLE]
    property acl_user_id: Int64 read Facl_user_id write Facl_user_id;
  end;

implementation

uses
  System.SysUtils,
  {$IFDEF APPREST}
  uMyClaims,
  {$ENDIF}
  uHlp;

{ TPriceListInputDTO }

{$IFDEF APPREST}
class function TPriceListInputDTO.FromReq(AReq: THorseRequest): TPriceListInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TPriceListInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := AReq.Session<TMyClaims>.IdToInt64;
end;
{$ENDIF}

end.

