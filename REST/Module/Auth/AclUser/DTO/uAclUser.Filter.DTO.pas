unit uAclUser.Filter.DTO;

interface

uses
  uBase.Filter.DTO,
  Horse.Request,
  GBSwagger.Model.Attributes,
  XSuperObject,
  uSmartPointer,
  uAppRest.Types;

type
  TAclUserFilterDTO = class(TBaseFilterDTO)
  public
    class function FromReq(AReq: THorseRequest): TAclUserFilterDTO;
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TAclUserFilterDTO }

class function TAclUserFilterDTO.FromReq(AReq: THorseRequest): TAclUserFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TAclUserFilterDTO.FromJSON(AReq.Body);
end;

end.

