unit uSale.Filter.DTO;

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
  TSaleFilterDTO = class(TBaseFilterDTO)
  private
    Fcustom_search_for_sale_on_hold: String;
    Fstatus: String;
    Ftype: String;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TSaleFilterDTO;
    {$ENDIF}

    [SwagString]
    [SwagProp('custom_search_for_sale_on_hold', 'Pesquisa customizada para Venda em Espera', false)]
    property custom_search_for_sale_on_hold: String read Fcustom_search_for_sale_on_hold write Fcustom_search_for_sale_on_hold;

    [SwagString]
    [SwagProp('status', 'Status [0..2] 0-Pendente, 1-Concluido, 2-Cancelado', false)]
    property status: String read Fstatus write Fstatus;

    [SwagString]
    [SwagProp('type', 'Tipo [0..2] 0-Normal, 1-Consumo, 2-Entrega', false)]
    property &type: String read Ftype write Ftype;
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TSaleFilterDTO }

{$IFDEF APPREST}
class function TSaleFilterDTO.FromReq(AReq: THorseRequest): TSaleFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TSaleFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

