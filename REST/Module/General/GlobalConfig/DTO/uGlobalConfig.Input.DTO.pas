unit uGlobalConfig.Input.DTO;

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
  TGlobalConfigInputDTO = class(TBaseDTO)
  private
    Fpdv_edit_item_before_register: SmallInt;
    Facl_user_id: Int64;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TGlobalConfigInputDTO;
    {$ENDIF}

    [SwagNumber]
    [SwagProp('pdv_edit_item_before_register', 'PDV > Editar item antes de registrar', false)]
    property pdv_edit_item_before_register: SmallInt read Fpdv_edit_item_before_register write Fpdv_edit_item_before_register;

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

{ TGlobalConfigInputDTO }

{$IFDEF APPREST}
class function TGlobalConfigInputDTO.FromReq(AReq: THorseRequest): TGlobalConfigInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TGlobalConfigInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := AReq.Session<TMyClaims>.IdToInt64;
end;
{$ENDIF}

end.

