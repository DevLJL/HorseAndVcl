unit uBillPayReceive;

interface

uses
  uAppRest.Types,
  uAclUser,
  uBase.Entity,
  Data.DB,
  uBillPayReceive.Types,
  uPerson,
  uChartOfAccount,
  uCostCenter,
  uBankAccount,
  uPayment;

type
  TBillPayReceive = class(TBaseEntity)
  private
    Fid: Int64;
    Fbatch: string;
    Fperson_id: Int64;
    Fbank_account_id: Int64;
    Finstallment_number: Int64;
    Finstallment_quantity: Int64;
    Finterest_and_fine: double;
    Fpayment_id: Int64;
    Fdue_date: TDate;
    Fdiscount: double;
    Fnote: String;
    Fstatus: TBillPayReceiveStatus;
    Famount: double;
    Fcost_center_id: Int64;
    Ftype: TBillPayReceiveType;
    Fsale_id: Int64;
    Fshort_description: string;
    Fchart_of_account_id: Int64;
    Fpayment_date: TDate;
    Fcreated_at: TDateTime;
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;

    // OneToOne
    Fperson: TPerson;
    Fchart_of_account: TChartOfAccount;
    Fcost_center: TCostCenter;
    Fbank_account: TBankAccount;
    Fpayment: TPayment;
    Fupdated_by_acl_user: TAclUser;
    Fcreated_by_acl_user: TAclUser;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property batch: string read Fbatch write Fbatch;
    property &type: TBillPayReceiveType read Ftype write Ftype;
    property short_description: string read Fshort_description write Fshort_description;
    property person_id: Int64 read Fperson_id write Fperson_id;
    property chart_of_account_id: Int64 read Fchart_of_account_id write Fchart_of_account_id;
    property cost_center_id: Int64 read Fcost_center_id write Fcost_center_id;
    property bank_account_id: Int64 read Fbank_account_id write Fbank_account_id;
    property payment_id: Int64 read Fpayment_id write Fpayment_id;
    property due_date: TDate read Fdue_date write Fdue_date;
    property installment_quantity: Int64 read Finstallment_quantity write Finstallment_quantity;
    property installment_number: Int64 read Finstallment_number write Finstallment_number;
    property amount: double read Famount write Famount;
    property discount: double read Fdiscount write Fdiscount;
    property interest_and_fine: double read Finterest_and_fine write Finterest_and_fine;
    function net_amount: double;
    property status: TBillPayReceiveStatus read Fstatus write Fstatus;
    property payment_date: TDate read Fpayment_date write Fpayment_date;
    property note: String read Fnote write Fnote;
    property sale_id: Int64 read Fsale_id write Fsale_id;

    property created_at: TDateTime read Fcreated_at write Fcreated_at;
    property updated_at: TDateTime read Fupdated_at write Fupdated_at;
    property created_by_acl_user_id: Int64 read Fcreated_by_acl_user_id write Fcreated_by_acl_user_id;
    property updated_by_acl_user_id: Int64 read Fupdated_by_acl_user_id write Fupdated_by_acl_user_id;

    // OneToOne
    property person: TPerson read Fperson write Fperson;
    property chart_of_account: TChartOfAccount read Fchart_of_account write Fchart_of_account;
    property cost_center: TCostCenter read Fcost_center write Fcost_center;
    property bank_account: TBankAccount read Fbank_account write Fbank_account;
    property payment: TPayment read Fpayment write Fpayment;
    property created_by_acl_user: TAclUser read Fcreated_by_acl_user write Fcreated_by_acl_user;
    property updated_by_acl_user: TAclUser read Fupdated_by_acl_user write Fupdated_by_acl_user;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uApplication.Exception, uTrans;

{ TBillPayReceive }

constructor TBillPayReceive.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TBillPayReceive.Destroy;
begin
  if Assigned(Fperson)              then Fperson.Free;
  if Assigned(Fchart_of_account)    then Fchart_of_account.Free;
  if Assigned(Fcost_center)         then Fcost_center.Free;
  if Assigned(Fbank_account)        then Fbank_account.Free;
  if Assigned(Fpayment)             then Fpayment.Free;
  if Assigned(Fcreated_by_acl_user) then Fcreated_by_acl_user.Free;
  if Assigned(Fupdated_by_acl_user) then Fupdated_by_acl_user.Free;
  inherited;
end;

procedure TBillPayReceive.Initialize;
begin
  Fcreated_at          := now;
  Fperson              := TPerson.Create;
  Fchart_of_account    := TChartOfAccount.Create;
  Fcost_center         := TCostCenter.Create;
  Fbank_account        := TBankAccount.Create;
  Fpayment             := TPayment.Create;
  Fcreated_by_acl_user := TAclUser.Create;
  Fupdated_by_acl_user := TAclUser.Create;
end;

function TBillPayReceive.net_amount: double;
begin
  Result := (Famount - Fdiscount) + Finterest_and_fine;
end;

function TBillPayReceive.Validate: String;
var
  LIsInserting: Boolean;
begin
  Result := EmptyStr;
  LIsInserting := Fid = 0;

  if Fbatch.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Lote') + #13;

  if Fshort_description.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Descrição') + #13;

  if (Fbank_account_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Conta Bancária') + #13;

  if (Fpayment_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Pagamento') + #13;

  if (Fdue_date <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Vencimento') + #13;

  if (Finstallment_quantity <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Quantidade de Parcelas') + #13;

  if (Finstallment_number <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Número da Parcela') + #13;

  if (Famount <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Valor') + #13;

  if (net_amount <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Valor Líquido') + #13;
end;

end.

