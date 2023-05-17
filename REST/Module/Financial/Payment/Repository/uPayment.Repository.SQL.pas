unit uPayment.Repository.SQL;

interface

uses
  uBase.Repository,
  uPayment.Repository.Interfaces,
  uPayment.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uPayment,
  uPaymentTerm,
  uZLMemTable.Interfaces;

type
  TPaymentRepositorySQL = class(TBaseRepository, IPaymentRepository)
  private
    FPaymentSQLBuilder: IPaymentSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IPaymentSQLBuilder);
    function DataSetToEntity(ADtsPayment: TDataSet): TBaseEntity; override;
    function DataSetToPaymentTerm(ADtsPaymentTerm: TDataSet): TPaymentTerm;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IPaymentSQLBuilder): IPaymentRepository;
    function Show(AId: Int64): TPayment;
    function Update(AId: Int64; AEntity: TBaseEntity): Int64; override;
    function Store(AEntity: TBaseEntity): Int64; override;
    function ListPaymentTerms(APaymentId: Int64): IZLMemTable;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils,
  uZLQry.Interfaces,
  Vcl.Forms;

{ TPaymentRepositorySQL }

class function TPaymentRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IPaymentSQLBuilder): IPaymentRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TPaymentRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IPaymentSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FPaymentSQLBuilder := ASQLBuilder;
  FManageTransaction := True;
end;

function TPaymentRepositorySQL.DataSetToEntity(ADtsPayment: TDataSet): TBaseEntity;
begin
  const LPayment = TPayment.FromJSON(ADtsPayment.ToJSONObjectString);

  // Tratar especificidades
  LPayment.bank_account_default.id   := ADtsPayment.FieldByName('bank_account_default_id').AsLargeInt;
  LPayment.bank_account_default.name := ADtsPayment.FieldByName('bank_account_default_name').AsString;
  LPayment.created_by_acl_user.id    := ADtsPayment.FieldByName('created_by_acl_user_id').AsLargeInt;
  LPayment.created_by_acl_user.name  := ADtsPayment.FieldByName('created_by_acl_user_name').AsString;
  LPayment.updated_by_acl_user.id    := ADtsPayment.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LPayment.updated_by_acl_user.name  := ADtsPayment.FieldByName('updated_by_acl_user_name').AsString;

  Result := LPayment;
end;

function TPaymentRepositorySQL.DataSetToPaymentTerm(ADtsPaymentTerm: TDataSet): TPaymentTerm;
begin
  Result := TPaymentTerm.FromJSON(ADtsPaymentTerm.ToJSONObjectString);
end;

function TPaymentRepositorySQL.ListPaymentTerms(APaymentId: Int64): IZLMemTable;
begin
  Result := FConn.MakeMemTable.FromDataSet(
    FConn.MakeQry.Open(
      FPaymentSQLBuilder.SelectPaymentsTermByPaymentId(APaymentId)
    ).DataSet
  );
end;

function TPaymentRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FPaymentSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TPaymentRepositorySQL.Show(AId: Int64): TPayment;
begin
  Result := Nil;
  const LQry = FConn.MakeQry;

  // Payment
  const LPayment = inherited ShowById(AId) as TPayment;
  if not assigned(LPayment) then
    Exit;

  // PaymentTerm
  LQry.Open(FPaymentSQLBuilder.SelectPaymentsTermByPaymentId(AId));
  LQry.First;
  while not LQry.Eof do
  begin
    LPayment.payment_terms.Add(DataSetToPaymentTerm(LQry.DataSet));
    LQry.Next;
  end;

  Result := LPayment;
end;

function TPaymentRepositorySQL.Store(AEntity: TBaseEntity): Int64;
var
  LStoredId: Int64;
begin
  Try
    if FManageTransaction then
      FConn.StartTransaction;

    // Instanciar Qry
    const LQry = FConn.MakeQry;

    // Payment
    LStoredId := inherited Store(AEntity);
    const LPayment = AEntity as TPayment;

    // PaymentTerms
    for var LPaymentTerm in LPayment.payment_terms do
    begin
      LPaymentTerm.payment_id := LStoredId;
      LQry.ExecSQL(FPaymentSQLBuilder.InsertPaymentTerm(LPaymentTerm))
    end;

    if FManageTransaction then
      FConn.CommitTransaction;
  except on E: Exception do
    Begin
      if FManageTransaction then
        FConn.RollBackTransaction;
      raise;
    End;
  end;

  Result := LStoredId;
end;

function TPaymentRepositorySQL.Update(AId: Int64; AEntity: TBaseEntity): Int64;
begin
  Try
    if FManageTransaction then
      FConn.StartTransaction;

    // Instanciar Qry
    const LQry = FConn.MakeQry;

    // Payment
    inherited Update(AId, AEntity);
    const LPayment = AEntity as TPayment;

    // PaymentTerms
    LQry.ExecSQL(FPaymentSQLBuilder.DeletePaymentsTermByPaymentId(AId));
    for var LPaymentTerm in LPayment.payment_terms do
    begin
      LPaymentTerm.payment_id := AId;
      LQry.ExecSQL(FPaymentSQLBuilder.InsertPaymentTerm(LPaymentTerm))
    end;

    if FManageTransaction then
      FConn.CommitTransaction;
  except on E: Exception do
    Begin
      if FManageTransaction then
        FConn.RollBackTransaction;
      raise;
    End;
  end;

  Result := AId;
end;

procedure TPaymentRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.



