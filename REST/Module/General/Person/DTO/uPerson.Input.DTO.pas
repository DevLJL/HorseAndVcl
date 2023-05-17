unit uPerson.Input.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  uBase.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections,
  uPersonContact.Input.DTO,
  uPerson.Types;

type
  TPersonInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Facl_user_id: Int64;
    Fflg_technician: SmallInt;
    Faddress_number: String;
    Fdistrict: String;
    Fcompany_email: String;
    Fflg_supplier: SmallInt;
    Fflg_seller: SmallInt;
    Finternet_page: String;
    Flegal_entity_number: String;
    Falias_name: String;
    Fflg_final_customer: SmallInt;
    Fstate_registration: String;
    Ficms_taxpayer: TPersonIcmsTaxPayer;
    Ffinancial_email: String;
    Freference_point: String;
    Fzipcode: String;
    Fnote: String;
    Fcomplement: String;
    Fflg_employee: SmallInt;
    Fflg_other: SmallInt;
    Fflg_carrier: SmallInt;
    Faddress: String;
    Fflg_customer: SmallInt;
    Fbank_note: String;
    Fphone_2: String;
    Fphone_3: String;
    Fcommercial_note: String;
    Fcity_id: Int64;
    Fphone_1: String;
    Fmunicipal_registration: String;

    // OneToMany
    Fperson_contacts: TObjectList<TPersonContactInputDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TPersonInputDTO;
    {$ENDIF}

    [SwagString(255)]
    [SwagProp('name', 'Razão/Nome', true)]
    property name: String read Fname write Fname;

    [SwagString(255)]
    [SwagProp('alias_name', 'Fantasia/Apelido', false)]
    property alias_name: String read Falias_name write Falias_name;

    [SwagString(20)]
    [SwagProp('legal_entity_number', 'CPF/CNPJ', false)]
    property legal_entity_number: String read Flegal_entity_number write Flegal_entity_number;

    [SwagNumber(0,2)]
    [SwagProp('icms_taxpayer', '[0..2] 0-Não contribuinte de icms, 1-Contribuinte de icms, 2-Isento de icms', false)]
    property icms_taxpayer: TPersonIcmsTaxPayer read Ficms_taxpayer write Ficms_taxpayer;

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
    [SwagProp('flg_customer', '[0..1] Cliente', false)]
    property flg_customer: SmallInt read Fflg_customer write Fflg_customer;

    [SwagNumber(0,1)]
    [SwagProp('flg_seller', '[0..1] Vendedor', false)]
    property flg_seller: SmallInt read Fflg_seller write Fflg_seller;

    [SwagNumber(0,1)]
    [SwagProp('flg_supplier', '[0..1] Fornecedor', false)]
    property flg_supplier: SmallInt read Fflg_supplier write Fflg_supplier;

    [SwagNumber(0,1)]
    [SwagProp('flg_carrier', '[0..1] Transportador', false)]
    property flg_carrier: SmallInt read Fflg_carrier write Fflg_carrier;

    [SwagNumber(0,1)]
    [SwagProp('flg_technician', '[0..1] Técnico', false)]
    property flg_technician: SmallInt read Fflg_technician write Fflg_technician;

    [SwagNumber(0,1)]
    [SwagProp('flg_employee', '[0..1] ´Colaborador', false)]
    property flg_employee: SmallInt read Fflg_employee write Fflg_employee;

    [SwagNumber(0,1)]
    [SwagProp('flg_other', '[0..1] Outros', false)]
    property flg_other: SmallInt read Fflg_other write Fflg_other;

    [SwagNumber(0,1)]
    [SwagProp('flg_final_customer', '[0..1] Consumidor Final', false)]
    property flg_final_customer: SmallInt read Fflg_final_customer write Fflg_final_customer;

    [SwagIgnore]
    [DISABLE]
    property acl_user_id: Int64 read Facl_user_id write Facl_user_id;

    // OneToMany
    property person_contacts: TObjectList<TPersonContactInputDTO> read Fperson_contacts write Fperson_contacts;
  end;

implementation

uses
  System.SysUtils,
  {$IFDEF APPREST}
  uMyClaims,
  {$ENDIF}
  uHlp;

{ TPersonInputDTO }

constructor TPersonInputDTO.Create;
begin
  inherited Create;
  Fperson_contacts := TObjectList<TPersonContactInputDTO>.Create;
end;

destructor TPersonInputDTO.Destroy;
begin
  if Assigned(Fperson_contacts) then
    FreeAndNil(Fperson_contacts);
  inherited;
end;

{$IFDEF APPREST}
class function TPersonInputDTO.FromReq(AReq: THorseRequest): TPersonInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TPersonInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := StrInt(AReq.Session<TMyClaims>.Id);
end;
{$ENDIF}

end.

