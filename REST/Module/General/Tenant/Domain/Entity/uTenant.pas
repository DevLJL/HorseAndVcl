unit uTenant;

interface

uses
  uAppRest.Types,
  uAclUser,
  uBase.Entity,
  Data.DB,
  uCity,
  System.Generics.Collections;

type
  TTenant = class(TBaseEntity)
  private
    Fid: Int64;
    Fname: string;
    Faddress_number: String;
    Fdistrict: String;
    Fcompany_email: String;
    Finternet_page: String;
    Falias_name: String;
    Fstate_registration: String;
    Ficms_taxpayer: SmallInt;
    Ffinancial_email: String;
    Freference_point: String;
    Fzipcode: String;
    Fnote: String;
    Fcomplement: String;
    Flegal_entity_number: String;
    Faddress: String;
    Fbank_note: String;
    Fphone_2: String;
    Fphone_3: String;
    Fcommercial_note: String;
    Fcity_id: Int64;
    Fphone_1: String;
    Fmunicipal_registration: String;
    Fsend_email_email_accountant: String;
    Fsend_email_app_default: SmallInt;
    Fsend_email_identification: String;
    Fsend_email_email: String;
    Fsend_email_header_message: String;
    Fsend_email_footer_message: String;
    Fsend_email_port: String;
    Fsend_email_smtp: String;
    Fsend_email_ssl: SmallInt;
    Fsend_email_password: String;
    Fsend_email_tls: SmallInt;
    Fsend_email_user: String;

    // OneToOne
    Fcity: TCity;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property name: string read Fname write Fname;
    property alias_name: String read Falias_name write Falias_name;
    property legal_entity_number: String read Flegal_entity_number write Flegal_entity_number;
    property icms_taxpayer: SmallInt read Ficms_taxpayer write Ficms_taxpayer;
    property state_registration: String read Fstate_registration write Fstate_registration;
    property municipal_registration: String read Fmunicipal_registration write Fmunicipal_registration;
    property zipcode: String read Fzipcode write Fzipcode;
    property address: String read Faddress write Faddress;
    property address_number: String read Faddress_number write Faddress_number;
    property complement: String read Fcomplement write Fcomplement;
    property district: String read Fdistrict write Fdistrict;
    property city_id: Int64 read Fcity_id write Fcity_id;
    property reference_point: String read Freference_point write Freference_point;
    property phone_1: String read Fphone_1 write Fphone_1;
    property phone_2: String read Fphone_2 write Fphone_2;
    property phone_3: String read Fphone_3 write Fphone_3;
    property company_email: String read Fcompany_email write Fcompany_email;
    property financial_email: String read Ffinancial_email write Ffinancial_email;
    property internet_page: String read Finternet_page write Finternet_page;
    property note: String read Fnote write Fnote;
    property bank_note: String read Fbank_note write Fbank_note;
    property commercial_note: String read Fcommercial_note write Fcommercial_note;
    property send_email_app_default: SmallInt read Fsend_email_app_default write Fsend_email_app_default;
    property send_email_email: String read Fsend_email_email write Fsend_email_email;
    property send_email_identification: String read Fsend_email_identification write Fsend_email_identification;
    property send_email_user: String read Fsend_email_user write Fsend_email_user;
    property send_email_password: String read Fsend_email_password write Fsend_email_password;
    property send_email_smtp: String read Fsend_email_smtp write Fsend_email_smtp;
    property send_email_port: String read Fsend_email_port write Fsend_email_port;
    property send_email_ssl: SmallInt read Fsend_email_ssl write Fsend_email_ssl;
    property send_email_tls: SmallInt read Fsend_email_tls write Fsend_email_tls;
    property send_email_email_accountant: String read Fsend_email_email_accountant write Fsend_email_email_accountant;
    property send_email_footer_message: String read Fsend_email_footer_message write Fsend_email_footer_message;
    property send_email_header_message: String read Fsend_email_header_message write Fsend_email_header_message;


    // OneToOne
    property city: TCity read Fcity write Fcity;

    function Validate: String; override;
    procedure BeforeSave(AState: TEntityState);
    function BeforeSaveAndValidate(AState: TEntityState): String;
  end;

implementation

uses
  System.SysUtils,
  uHlp,
  uApplication.Exception,
  uTenant.BeforeSave,
  uTrans;

{ TTenant }

procedure TTenant.BeforeSave(AState: TEntityState);
begin
  TTenantBeforeSave.Make(Self, AState).Execute;
end;

constructor TTenant.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TTenant.Destroy;
begin
  if Assigned(Fcity) then Fcity.Free;

  inherited;
end;

procedure TTenant.Initialize;
begin
  Fcity := TCity.Create;
end;

function TTenant.Validate: String;
var
  LIsInserting: Boolean;
  lI: Integer;
  LCurrentError: String;
begin
  Result := EmptyStr;
  LIsInserting := Fid = 0;

  if Fname.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;
end;

function TTenant.BeforeSaveAndValidate(AState: TEntityState): String;
begin
  BeforeSave(AState);
  Result := Validate;
end;

end.

