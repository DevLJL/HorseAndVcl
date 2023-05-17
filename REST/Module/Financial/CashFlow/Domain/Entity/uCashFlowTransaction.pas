unit uCashFlowTransaction;

interface

uses
  uBase.Entity,
  uPayment,
  uPerson,
  uCashFlowTransaction.Types;

type
  TCashFlowTransaction = class(TBaseEntity)
  private
    Fperson_id: Int64;
    Fhistory: String;
    Fflg_manual_transaction: SmallInt;
    Ftransaction_date: TDateTime;
    Fpayment_id: Int64;
    Fid: Int64;
    Fnote: String;
    Famount: Double;
    Fcash_flow_id: Int64;
    Fsale_id: Int64;
    Ftype: TCashFlowTransactionType;

    // OneToOne
    Fpayment: TPayment;
    Fperson: TPerson;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property cash_flow_id: Int64 read Fcash_flow_id write Fcash_flow_id;
    property flg_manual_transaction: SmallInt read Fflg_manual_transaction write Fflg_manual_transaction;
    property transaction_date: TDateTime read Ftransaction_date write Ftransaction_date;
    property history: String read Fhistory write Fhistory;
    property &type: TCashFlowTransactionType read Ftype write Ftype;
    property amount: Double read Famount write Famount;
    property payment_id: Int64 read Fpayment_id write Fpayment_id;
    property note: String read Fnote write Fnote;
    property sale_id: Int64 read Fsale_id write Fsale_id;
    property person_id: Int64 read Fperson_id write Fperson_id;

    // OneToOne
    property payment: TPayment read Fpayment write Fpayment;
    property person: TPerson read Fperson write Fperson;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uHlp,
  uAppRest.Types,
  uApplication.Exception, uTrans;

{ TCashFlowTransaction }

constructor TCashFlowTransaction.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TCashFlowTransaction.Destroy;
begin
  if Assigned(Fpayment) then Fpayment.Free;
  if Assigned(Fperson)  then Fperson.Free;
  inherited;
end;

procedure TCashFlowTransaction.Initialize;
begin
  Fpayment := TPayment.Create;
  Fperson  := TPerson.Create;
end;

function TCashFlowTransaction.Validate: String;
begin
  Result := EmptyStr;
  const LIsInserting = (Fid = 0);

  if (Ftransaction_date <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Data de Transação') + #13;

  if Fhistory.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Histórico') + #13;

  if (Fpayment_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Pagamento') + #13;
end;

end.

