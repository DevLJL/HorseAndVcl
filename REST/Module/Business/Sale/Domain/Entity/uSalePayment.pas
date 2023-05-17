unit uSalePayment;

interface

uses
  uBase.Entity,
  uPayment,
  uBankAccount;

type
  TSalePayment = class(TBaseEntity)
  private
    Fid: Int64;
    Fsale_id: Int64;
    Fbank_account_id: Int64;
    Fpayment_id: Int64;
    Fdue_date: TDate;
    Fcollection_uuid: String;
    Fnote: string;
    Famount: Double;

    // OneToOne
    Fpayment: TPayment;
    Fbank_account: TBankAccount;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property sale_id: Int64 read Fsale_id write Fsale_id;
    property collection_uuid: String read Fcollection_uuid write Fcollection_uuid;
    property payment_id: Int64 read Fpayment_id write Fpayment_id;
    property bank_account_id: Int64 read Fbank_account_id write Fbank_account_id;
    property amount: Double read Famount write Famount;
    property due_date: TDate read Fdue_date write Fdue_date;
    property note: string read Fnote write Fnote;

    // OneToOne
    property payment: TPayment read Fpayment write Fpayment;
    property bank_account: TBankAccount read Fbank_account write Fbank_account;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uHlp,
  uAppRest.Types,
  uApplication.Exception,
  uTrans;

{ TSalePayment }

constructor TSalePayment.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TSalePayment.Destroy;
begin
  if Assigned(Fpayment)      then Fpayment.Free;
  if Assigned(Fbank_account) then Fbank_account.Free;
  inherited;
end;

procedure TSalePayment.Initialize;
begin
  Fpayment      := TPayment.Create;
  Fbank_account := TBankAccount.Create;
end;

function TSalePayment.Validate: String;
begin
  Result := EmptyStr;
  const LIsInserting = (Fid = 0);

  if Fcollection_uuid.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('CollectionUUID') + #13;

  if (Fpayment_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Pagamento') + #13;

  if (Fbank_account_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Conta Bancária') + #13;

  if (Famount <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Valor do Pagamento') + #13;

  if (Fdue_date <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Vencimento') + #13;
end;

end.

