unit uPayment;

interface

uses
  uAppRest.Types,
  uAclUser,
  uBase.Entity,
  Data.DB,
  uPaymentTerm,
  System.Generics.Collections,
  uBankAccount;

type
  TPayment = class(TBaseEntity)
  private
    Fid: Int64;
    Fname: string;
    Fflg_post_as_received: SmallInt;
    Fflg_active: SmallInt;
    Fflg_active_at_pos: SmallInt;
    Fbank_account_default_id: Int64;
    Fcreated_at: TDateTime;
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;

    // OneToOne
    Fbank_account_default: TBankAccount;
    Fupdated_by_acl_user: TAclUser;
    Fcreated_by_acl_user: TAclUser;

    // OneToMany
    Fpayment_terms: TObjectList<TPaymentTerm>;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property name: string read Fname write Fname;
    property flg_post_as_received: SmallInt read Fflg_post_as_received write Fflg_post_as_received;
    property flg_active: SmallInt read Fflg_active write Fflg_active;
    property flg_active_at_pos: SmallInt read Fflg_active_at_pos write Fflg_active_at_pos;
    property bank_account_default_id: Int64 read Fbank_account_default_id write Fbank_account_default_id;
    property created_at: TDateTime read Fcreated_at write Fcreated_at;
    property updated_at: TDateTime read Fupdated_at write Fupdated_at;
    property created_by_acl_user_id: Int64 read Fcreated_by_acl_user_id write Fcreated_by_acl_user_id;
    property updated_by_acl_user_id: Int64 read Fupdated_by_acl_user_id write Fupdated_by_acl_user_id;

    // OneToOne
    property bank_account_default: TBankAccount read Fbank_account_default write Fbank_account_default;
    property created_by_acl_user: TAclUser read Fcreated_by_acl_user write Fcreated_by_acl_user;
    property updated_by_acl_user: TAclUser read Fupdated_by_acl_user write Fupdated_by_acl_user;

    // OneToMany
    property payment_terms: TObjectList<TPaymentTerm> read Fpayment_terms write Fpayment_terms;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uApplication.Exception, uHlp, uTrans;

{ TPayment }

constructor TPayment.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TPayment.Destroy;
begin
  if Assigned(Fbank_account_default) then Fbank_account_default.Free;
  if Assigned(Fcreated_by_acl_user)  then Fcreated_by_acl_user.Free;
  if Assigned(Fupdated_by_acl_user)  then Fupdated_by_acl_user.Free;
  if Assigned(Fpayment_terms)    then Fpayment_terms.Free;
  inherited;
end;

procedure TPayment.Initialize;
begin
  Fcreated_at           := now;
  Fbank_account_default := TBankAccount.Create;
  Fcreated_by_acl_user  := TAclUser.Create;
  Fupdated_by_acl_user  := TAclUser.Create;
  Fpayment_terms        := TObjectList<TPaymentTerm>.Create;
end;

function TPayment.Validate: String;
begin
  Result := EmptyStr;
  const LIsInserting = (Fid = 0);

  if Fname.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;
  if (Fbank_account_default_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Conta Bancária Padrão') + #13;

  if (Fpayment_terms.Count <= 0) then
    Result := Result + 'Nenhuma condição de pagamento informada.' + #13;

  // PaymentTerm
  for var lI := 0 to Pred(Fpayment_terms.Count) do
  begin
    const LCurrentError = Fpayment_terms.Items[lI].Validate;
    if not LCurrentError.Trim.IsEmpty then
      Result := Result + '   Condição de Pagamento > Item ' + StrZero((lI+1).ToString,3) + ': ' + LCurrentError;
  end;
end;

end.

