unit uCashFlow;

interface

uses
  uAppRest.Types,
  uAclUser,
  uBase.Entity,
  Data.DB,
  uStation,
  uCashFlowTransaction,
  System.Generics.Collections;

type
  TCashFlow = class(TBaseEntity)
  private
    Fid: Int64;
    Fclosing_note: String;
    Fstation_id: Int64;
    Fopening_date: TDateTime;
    Fclosing_date: TDateTime;
    Ffinal_balance_amount: double;
    Fopening_balance_amount: double;
    Fcreated_at: TDateTime;
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;

    // OneToOne
    Fstation: TStation;
    Fupdated_by_acl_user: TAclUser;
    Fcreated_by_acl_user: TAclUser;

    // OneToMany
    Fcash_flow_transactions: TObjectList<TCashFlowTransaction>;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property station_id: Int64 read Fstation_id write Fstation_id;
    property opening_balance_amount: double read Fopening_balance_amount write Fopening_balance_amount;
    property final_balance_amount: double read Ffinal_balance_amount write Ffinal_balance_amount;
    property opening_date: TDateTime read Fopening_date write Fopening_date;
    property closing_date: TDateTime read Fclosing_date write Fclosing_date;
    property closing_note: String read Fclosing_note write Fclosing_note;
    property created_at: TDateTime read Fcreated_at write Fcreated_at;
    property updated_at: TDateTime read Fupdated_at write Fupdated_at;
    property created_by_acl_user_id: Int64 read Fcreated_by_acl_user_id write Fcreated_by_acl_user_id;
    property updated_by_acl_user_id: Int64 read Fupdated_by_acl_user_id write Fupdated_by_acl_user_id;

    // OneToOne
    property station: TStation read Fstation write Fstation;
    property created_by_acl_user: TAclUser read Fcreated_by_acl_user write Fcreated_by_acl_user;
    property updated_by_acl_user: TAclUser read Fupdated_by_acl_user write Fupdated_by_acl_user;

    // OneToMany
    property cash_flow_transactions: TObjectList<TCashFlowTransaction> read Fcash_flow_transactions write Fcash_flow_transactions;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uApplication.Exception,
  uHlp,
uTrans;

{ TCashFlow }

constructor TCashFlow.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TCashFlow.Destroy;
begin
  if Assigned(Fstation)                    then Fstation.Free;
  if Assigned(Fcreated_by_acl_user)        then Fcreated_by_acl_user.Free;
  if Assigned(Fupdated_by_acl_user)        then Fupdated_by_acl_user.Free;
  if Assigned(Fcash_flow_transactions) then Fcash_flow_transactions.Free;
  inherited;
end;

procedure TCashFlow.Initialize;
begin
  Fcreated_at             := now;
  Fstation                := TStation.Create;
  Fcreated_by_acl_user    := TAclUser.Create;
  Fupdated_by_acl_user    := TAclUser.Create;
  Fcash_flow_transactions := TObjectList<TCashFlowTransaction>.Create;
end;

function TCashFlow.Validate: String;
begin
  Result := EmptyStr;
  const LIsInserting = (Fid = 0);

  if (Fstation_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Esta��o') + #13;

  if (Fopening_date <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Data de Abertura') + #13;

  // CashFlowTransaction
  for var lI := 0 to Pred(Fcash_flow_transactions.Count) do
  begin
    const LCurrentError = Fcash_flow_transactions.Items[lI].Validate;
    if not LCurrentError.Trim.IsEmpty then
      Result := Result + '   Transa��o > Item ' + StrZero((lI+1).ToString,3) + ': ' + LCurrentError;
  end;
end;

end.

