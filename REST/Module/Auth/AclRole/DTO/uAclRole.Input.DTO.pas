unit uAclRole.Input.DTO;

interface

uses
  uBase.DTO,
  Horse.Request,
  GBSwagger.Model.Attributes,
  XSuperObject,
  uSmartPointer,
  uAppRest.Types,
  System.Generics.Collections,
  uAclRole.Types;

type
  TAclRoleInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Fgeneral_search_method: TAclRoleGeneralSearchMethod;
  public
    class function FromReq(AReq: THorseRequest): TAclRoleInputDTO;

    [SwagString(100)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;

    [SwagNumber]
    [SwagProp('general_research_method', 'Geral-Método de Pesquisa', False)]
    property general_search_method: TAclRoleGeneralSearchMethod read Fgeneral_search_method write Fgeneral_search_method;


  end;

implementation

uses
  System.SysUtils;

{ TAclRoleInputDTO }

class function TAclRoleInputDTO.FromReq(AReq: THorseRequest): TAclRoleInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result := TAclRoleInputDTO.FromJSON(AReq.Body);
end;

end.

