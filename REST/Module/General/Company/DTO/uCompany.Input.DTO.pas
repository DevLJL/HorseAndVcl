unit uCompany.Input.DTO;

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
  TCompanyInputDTO = class(TBaseDTO)
  private
    Faddress_number: String;
    Fname: String;
    Fsend_email_email_accountant: String;
    Fdistrict: String;
    Fsend_email_app_default: SmallInt;
    Fcompany_email: String;
    Finternet_page: String;
    Fsend_email_identification: String;
    Fsend_email_email: String;
    Flegal_entity_number: String;
    Falias_name: String;
    Facl_user_id: Int64;
    Fsend_email_header_message: String;
    Fstate_registration: String;
    Ficms_taxpayer: SmallInt;
    Ffinancial_email: String;
    Freference_point: String;
    Fzipcode: String;
    Fnote: String;
    Fcomplement: String;
    Fsend_email_footer_message: String;
    Fsend_email_port: String;
    Fsend_email_smtp: String;
    Fsend_email_ssl: SmallInt;
    Faddress: String;
    Fsend_email_password: String;
    Fbank_note: String;
    Fphone_2: String;
    Fphone_3: String;
    Fcommercial_note: String;
    Fcity_id: Int64;
    Fsend_email_tls: SmallInt;
    Fphone_1: String;
    Fsend_email_user: String;
    Fmunicipal_registration: String;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TCompanyInputDTO;
    {$ENDIF}

    [SwagString(255)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;

    [SwagString(255)]
    [SwagProp('alias_name', 'Fantasia/Apelido', true)]
    property alias_name: String read Falias_name write Falias_name;

    [SwagString(20)]
    [SwagProp('legal_entity_number', 'CPF/CNPJ', true)]
    property legal_entity_number: String read Flegal_entity_number write Flegal_entity_number;

    [SwagNumber(0,2)]
    [SwagProp('icms_taxpayer', '[0..2] 0-Não contribuinte de icms, 1-Contribuinte de icms, 2-Isento de icms', false)]
    property icms_taxpayer: SmallInt read Ficms_taxpayer write Ficms_taxpayer;

    [SwagString(20)]
    [SwagProp('state_registration', 'Inscrição Estadual', false)]
    property state_registration: String read Fstate_registration write Fstate_registration;

    [SwagString(20)]
    [SwagProp('municipal_registration', 'Inscrição Municipal', false)]
    property municipal_registration: String read Fmunicipal_registration write Fmunicipal_registration;

    [SwagString(10)]
    [SwagProp('zipcode', 'CEP', false)]
    property zipcode: String read Fzipcode write Fzipcode;

    [SwagString(255)]
    [SwagProp('address', 'Endereço', true)]
    property address: String read Faddress write Faddress;

    [SwagString(15)]
    [SwagProp('address_number', 'Número da Casa/Ap', false)]
    property address_number: String read Faddress_number write Faddress_number;

    [SwagString(255)]
    [SwagProp('address_number', 'Número da Casa/Ap', false)]
    property complement: String read Fcomplement write Fcomplement;

    [SwagString(255)]
    [SwagProp('district', 'Bairro', true)]
    property district: String read Fdistrict write Fdistrict;

    [SwagNumber]
    [SwagProp('city_id', 'Cidade (ID)', true)]
    property city_id: Int64 read Fcity_id write Fcity_id;

    [SwagString(255)]
    [SwagProp('reference_point', 'Ponto de Referência', false)]
    property reference_point: String read Freference_point write Freference_point;

    [SwagString(18)]
    [SwagProp('phone_1', 'Telefone 1', true)]
    property phone_1: String read Fphone_1 write Fphone_1;

    [SwagString(18)]
    [SwagProp('phone_2', 'Telefone 2', false)]
    property phone_2: String read Fphone_2 write Fphone_2;

    [SwagString(18)]
    [SwagProp('phone_3', 'Telefone 3', false)]
    property phone_3: String read Fphone_3 write Fphone_3;

    [SwagString(255)]
    [SwagProp('company_email', 'E-mail da Empresa', false)]
    property company_email: String read Fcompany_email write Fcompany_email;

    [SwagString(255)]
    [SwagProp('financial_email', 'E-mail do Financeiro', false)]
    property financial_email: String read Ffinancial_email write Ffinancial_email;

    [SwagString(255)]
    [SwagProp('internet_page', 'Página de internet', false)]
    property internet_page: String read Finternet_page write Finternet_page;

    [SwagString]
    [SwagProp('note', 'Observação', false)]
    property note: String read Fnote write Fnote;

    [SwagString]
    [SwagProp('bank_note', 'Observação Bancária', false)]
    property bank_note: String read Fbank_note write Fbank_note;

    [SwagString]
    [SwagProp('commercial_note', 'Observação Comercial', false)]
    property commercial_note: String read Fcommercial_note write Fcommercial_note;

    [SwagNumber(0,1)]
    [SwagProp('send_email_app_default', '[0..1] Disparo de E-mail - Configuração Padrão', false)]
    property send_email_app_default: SmallInt read Fsend_email_app_default write Fsend_email_app_default;

    [SwagString(255)]
    [SwagProp('send_email_email', 'Disparo de E-mail - E-mail', false)]
    property send_email_email: String read Fsend_email_email write Fsend_email_email;

    [SwagString(255)]
    [SwagProp('send_email_identification', 'Disparo de E-mail - Identificação', false)]
    property send_email_identification: String read Fsend_email_identification write Fsend_email_identification;

    [SwagString(255)]
    [SwagProp('send_email_user', 'Disparo de E-mail - Usuário', false)]
    property send_email_user: String read Fsend_email_user write Fsend_email_user;

    [SwagString(100)]
    [SwagProp('send_email_password', 'Disparo de E-mail - Senha', false)]
    property send_email_password: String read Fsend_email_password write Fsend_email_password;

    [SwagString(100)]
    [SwagProp('send_email_smtp', 'Disparo de E-mail - SMTP', false)]
    property send_email_smtp: String read Fsend_email_smtp write Fsend_email_smtp;

    [SwagString(10)]
    [SwagProp('send_email_port', 'Disparo de E-mail - Porta', false)]
    property send_email_port: String read Fsend_email_port write Fsend_email_port;

    [SwagNumber(0,1)]
    [SwagProp('send_email_ssl', '[0..1] Disparo de E-mail - SSL', false)]
    property send_email_ssl: SmallInt read Fsend_email_ssl write Fsend_email_ssl;

    [SwagNumber(0,1)]
    [SwagProp('send_email_tls', '[0..1] Disparo de E-mail - TLS', false)]
    property send_email_tls: SmallInt read Fsend_email_tls write Fsend_email_tls;

    [SwagString(255)]
    [SwagProp('send_email_email_accountant', 'Disparo de E-mail - E-mail do Contador', false)]
    property send_email_email_accountant: String read Fsend_email_email_accountant write Fsend_email_email_accountant;

    [SwagString]
    [SwagProp('send_email_footer_message', 'Disparo de E-mail - Mensagem do Rodapé', false)]
    property send_email_footer_message: String read Fsend_email_footer_message write Fsend_email_footer_message;

    [SwagString]
    [SwagProp('send_email_header_message', 'Disparo de E-mail - Mensagem do Cabeçalho', false)]
    property send_email_header_message: String read Fsend_email_header_message write Fsend_email_header_message;

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

{ TCompanyInputDTO }

{$IFDEF APPREST}
class function TCompanyInputDTO.FromReq(AReq: THorseRequest): TCompanyInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TCompanyInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := StrInt(AReq.Session<TMyClaims>.Id);
end;
{$ENDIF}

end.

