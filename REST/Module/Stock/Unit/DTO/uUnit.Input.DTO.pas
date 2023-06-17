unit uUnit.Input.DTO;

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
  TUnitInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Facl_user_id: Int64;
    Fdescription: String;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TUnitInputDTO;
    {$ENDIF}

    [SwagString(10)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;

    [SwagString(100)]
    [SwagProp('description', 'Descrição', true)]
    property description: String read Fdescription write Fdescription;

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

{ TUnitInputDTO }

{$IFDEF APPREST}
class function TUnitInputDTO.FromReq(AReq: THorseRequest): TUnitInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TUnitInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := AReq.Session<TMyClaims>.IdToInt64;
end;
{$ENDIF}

end.

