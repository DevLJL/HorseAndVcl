unit uAclRole.Filter.DTO;

interface

uses
  uBase.Filter.DTO,
  Horse.Request,
  GBSwagger.Model.Attributes,
  XSuperObject,
  uSmartPointer,
  uAppRest.Types;

type
  TAclRoleFilterDTO = class(TBaseFilterDTO)
  public
    class function FromReq(AReq: THorseRequest): TAclRoleFilterDTO;
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TAclRoleFilterDTO }

class function TAclRoleFilterDTO.FromReq(AReq: THorseRequest): TAclRoleFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TAclRoleFilterDTO.FromJSON(AReq.Body);
end;

end.

