unit uPerson;

interface

uses
  uAppRest.Types,
  uAclUser,
  uBase.Entity,
  Data.DB,
  uCity,
  System.Generics.Collections,
  uPersonContact,
  uPerson.Types;

type
  TPerson = class(TBaseEntity)
  private
    Fid: Int64;
    Fname: string;
    Faddress_number: String;
    Fflg_supplier: SmallInt;
    Fdistrict: String;
    Fflg_seller: SmallInt;
    Fcompany_email: String;
    Finternet_page: String;
    Falias_name: String;
    Fflg_final_customer: SmallInt;
    Fstate_registration: String;
    Ficms_taxpayer: TPersonIcmsTaxPayer;
    Ffinancial_email: String;
    Freference_point: String;
    Fzipcode: String;
    Fflg_employee: SmallInt;
    Fnote: String;
    Fcomplement: String;
    Flegal_entity_number: String;
    Fflg_other: SmallInt;
    Fflg_carrier: SmallInt;
    Fflg_customer: SmallInt;
    Faddress: String;
    Fbank_note: String;
    Fphone_2: String;
    Fphone_3: String;
    Fcommercial_note: String;
    Fcity_id: Int64;
    Fphone_1: String;
    Fflg_technician: SmallInt;
    Fmunicipal_registration: String;
    Fcreated_at: TDateTime;
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;

    // OneToOne
    Fcity: TCity;
    Fupdated_by_acl_user: TAclUser;
    Fcreated_by_acl_user: TAclUser;

    // OneToMany
    Fperson_contacts: TObjectList<TPersonContact>;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property name: string read Fname write Fname;
    property alias_name: String read Falias_name write Falias_name;
    property legal_entity_number: String read Flegal_entity_number write Flegal_entity_number;
    property icms_taxpayer: TPersonIcmsTaxPayer read Ficms_taxpayer write Ficms_taxpayer;
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
    property flg_customer: SmallInt read Fflg_customer write Fflg_customer;
    property flg_seller: SmallInt read Fflg_seller write Fflg_seller;
    property flg_supplier: SmallInt read Fflg_supplier write Fflg_supplier;
    property flg_carrier: SmallInt read Fflg_carrier write Fflg_carrier;
    property flg_technician: SmallInt read Fflg_technician write Fflg_technician;
    property flg_employee: SmallInt read Fflg_employee write Fflg_employee;
    property flg_other: SmallInt read Fflg_other write Fflg_other;
    property flg_final_customer: SmallInt read Fflg_final_customer write Fflg_final_customer;
    property created_at: TDateTime read Fcreated_at write Fcreated_at;
    property updated_at: TDateTime read Fupdated_at write Fupdated_at;
    property created_by_acl_user_id: Int64 read Fcreated_by_acl_user_id write Fcreated_by_acl_user_id;
    property updated_by_acl_user_id: Int64 read Fupdated_by_acl_user_id write Fupdated_by_acl_user_id;

    // OneToOne
    property city: TCity read Fcity write Fcity;
    property created_by_acl_user: TAclUser read Fcreated_by_acl_user write Fcreated_by_acl_user;
    property updated_by_acl_user: TAclUser read Fupdated_by_acl_user write Fupdated_by_acl_user;

    // OneToMany
    property person_contacts: TObjectList<TPersonContact> read Fperson_contacts write Fperson_contacts;

    function Validate: String; override;
    procedure BeforeSave(AState: TEntityState);
    function BeforeSaveAndValidate(AState: TEntityState): String;
  end;

implementation

uses
  System.SysUtils,
  uHlp,
  uApplication.Exception,
  uPerson.BeforeSave,
  uTrans;

{ TPerson }

procedure TPerson.BeforeSave(AState: TEntityState);
begin
  TPersonBeforeSave.Make(Self, AState).Execute;
end;

constructor TPerson.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TPerson.Destroy;
begin
  if Assigned(Fcity)                then Fcity.Free;
  if Assigned(Fperson_contacts)     then Fperson_contacts.Free;
  if Assigned(Fcreated_by_acl_user) then Fcreated_by_acl_user.Free;
  if Assigned(Fupdated_by_acl_user) then Fupdated_by_acl_user.Free;

  inherited;
end;

procedure TPerson.Initialize;
begin
  Fcreated_by_acl_user := TAclUser.Create;
  Fupdated_by_acl_user := TAclUser.Create;
  Fcity                := TCity.Create;
  Fperson_contacts     := TObjectList<TPersonContact>.Create;
end;

function TPerson.Validate: String;
begin
  Result := EmptyStr;
  const LIsInserting = (Fid = 0);

  if Fname.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;

  // Tipo de Pessoa
  const LHasAtLeastOneFilled = (Fflg_customer > 0)   or (Fflg_seller > 0)   or
                               (Fflg_supplier > 0)   or (Fflg_carrier > 0)  or
                               (Fflg_technician > 0) or (Fflg_employee > 0) or
                               (Fflg_other > 0);

  if not LHasAtLeastOneFilled then
    Result := Result + Trans.FieldWasNotInformed('Tipo de Pessoa') + #13;

  // Validar CPF/CNPJ
  if not Flegal_entity_number.Trim.IsEmpty then
  begin
    if ValidateCpfCnpj(Flegal_entity_number).IsEmpty then
      Result := Result + Trans.FieldIsInvalid('CPF/CNPJ') + #13;
  end;

  // PersonContact
  for var lI := 0 to Pred(Fperson_contacts.Count) do
  begin
    const LCurrentError = Fperson_contacts.Items[lI].Validate;
    if not LCurrentError.Trim.IsEmpty then
      Result := Result + '   Contato > Item ' + StrZero((lI+1).ToString,3) + ': ' + LCurrentError;
  end;
end;

function TPerson.BeforeSaveAndValidate(AState: TEntityState): String;
begin
  BeforeSave(AState);
  Result := Validate;
end;

end.

