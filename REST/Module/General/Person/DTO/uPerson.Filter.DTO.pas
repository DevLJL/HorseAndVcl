unit uPerson.Filter.DTO;

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
  TPersonFilterDTO = class(TBaseFilterDTO)
  private
    Faddress_number: String;
    Fdistrict: String;
    Fcompany_email: String;
    Flegal_entity_number: String;
    Falias_name: String;
    Fcity_name: String;
    Ffinancial_email: String;
    Freference_point: String;
    Fzipcode: String;
    Faddress: String;
    Fphone_1: String;
    Fname: String;
    Fflg_customer: String;
    Fflg_supplier: String;
    Fflg_seller: String;
    Fflg_carrier: String;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TPersonFilterDTO;
    {$ENDIF}

    [SwagString]
    [SwagProp('name', 'Razão/Nome', false)]
    property name: String read Fname write Fname;

    [SwagString]
    [SwagProp('alias_name', 'Fantasia/Apelido', false)]
    property alias_name: String read Falias_name write Falias_name;

    [SwagString]
    [SwagProp('legal_entity_number', 'CPF/CNPJ', false)]
    property legal_entity_number: String read Flegal_entity_number write Flegal_entity_number;

    [SwagString]
    [SwagProp('zipcode', 'CEP', false)]
    property zipcode: String read Fzipcode write Fzipcode;

    [SwagString]
    [SwagProp('address', 'Endereço', false)]
    property address: String read Faddress write Faddress;

    [SwagString]
    [SwagProp('address_number', 'Número do Endereço', false)]
    property address_number: String read Faddress_number write Faddress_number;

    [SwagString]
    [SwagProp('district', 'Bairro', false)]
    property district: String read Fdistrict write Fdistrict;

    [SwagString]
    [SwagProp('city_name', 'Cidade (Nome)', false)]
    property city_name: String read Fcity_name write Fcity_name;

    [SwagString]
    [SwagProp('reference_point', 'Ponto de Referência', false)]
    property reference_point: String read Freference_point write Freference_point;

    [SwagString]
    [SwagProp('phone_1', 'Telefone 1', false)]
    property phone_1: String read Fphone_1 write Fphone_1;

    [SwagString]
    [SwagProp('company_email', 'E-mail da Companhia', false)]
    property company_email: String read Fcompany_email write Fcompany_email;

    [SwagString]
    [SwagProp('financial_email', 'E-mail Financeiro', false)]
    property financial_email: String read Ffinancial_email write Ffinancial_email;

    [SwagString]
    [SwagProp('flg_customer', 'Cliente [Empty-Nenhum, 0-Não, 1-Sim]', false)]
    property flg_customer: String read Fflg_customer write Fflg_customer;

    [SwagString]
    [SwagProp('flg_seller', 'Vendedor [Empty-Nenhum, 0-Não, 1-Sim]', false)]
    property flg_seller: String read Fflg_seller write Fflg_seller;

    [SwagString]
    [SwagProp('flg_supplier', 'Fornecedor [Empty-Nenhum, 0-Não, 1-Sim]', false)]
    property flg_supplier: String read Fflg_supplier write Fflg_supplier;

    [SwagString]
    [SwagProp('flg_carrier', 'Transportador [Empty-Nenhum, 0-Não, 1-Sim]', false)]
    property flg_carrier: String read Fflg_carrier write Fflg_carrier;
  end;

implementation

uses
  System.SysUtils,
  uTrans;

{ TPersonFilterDTO }

{$IFDEF APPREST}
class function TPersonFilterDTO.FromReq(AReq: THorseRequest): TPersonFilterDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create(Trans.NoJsonFilterReported);

  Result := TPersonFilterDTO.FromJSON(AReq.Body);
end;
{$ENDIF}

end.

