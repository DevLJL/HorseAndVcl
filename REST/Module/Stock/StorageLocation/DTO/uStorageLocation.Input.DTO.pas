unit uStorageLocation.Input.DTO;

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
  TStorageLocationInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Facl_user_id: Int64;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TStorageLocationInputDTO;
    {$ENDIF}

    [SwagString(100)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;

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

{ TStorageLocationInputDTO }

{$IFDEF APPREST}
class function TStorageLocationInputDTO.FromReq(AReq: THorseRequest): TStorageLocationInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TStorageLocationInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := StrInt(AReq.Session<TMyClaims>.Id);
end;
{$ENDIF}

end.

