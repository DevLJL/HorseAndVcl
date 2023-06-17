unit uBankAccount.Input.DTO;

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
  TBankAccountInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Facl_user_id: Int64;
    Fcode: String;
    Fnote: String;
    Fbank_id: Int64;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TBankAccountInputDTO;
    {$ENDIF}

    [SwagString(255)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;

    [SwagNumber]
    [SwagProp('bank_id', 'Banco (ID)', true)]
    property bank_id: Int64 read Fbank_id write Fbank_id;

    [SwagString]
    [SwagProp('note', 'Observação', false)]
    property note: String read Fnote write Fnote;

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

{ TBankAccountInputDTO }

{$IFDEF APPREST}
class function TBankAccountInputDTO.FromReq(AReq: THorseRequest): TBankAccountInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TBankAccountInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := AReq.Session<TMyClaims>.IdToInt64;
end;
{$ENDIF}

end.

