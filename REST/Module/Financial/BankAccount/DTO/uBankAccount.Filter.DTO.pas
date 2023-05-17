unit uBankAccount.Filter.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  uBase.Filter.DTO,
  XSuperObject,
  uSmartPointer;

type
  TBankAccountFilterDTO = class(TBaseFilterDTO)
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TBankAccountFilterDTO;
    {$ENDIF}
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TBankAccountFilterDTO }

{$IFDEF APPREST}
class function TBankAccountFilterDTO.FromReq(AReq: THorseRequest): TBankAccountFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TBankAccountFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

