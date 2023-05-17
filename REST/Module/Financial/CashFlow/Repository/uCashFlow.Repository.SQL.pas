unit uCashFlow.Repository.SQL;

interface

uses
  uBase.Repository,
  uCashFlow.Repository.Interfaces,
  uCashFlow.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uCashFlow,
  uCashFlowTransaction;

type
  TCashFlowRepositorySQL = class(TBaseRepository, ICashFlowRepository)
  private
    FCashFlowSQLBuilder: ICashFlowSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: ICashFlowSQLBuilder);
    function DataSetToEntity(ADtsCashFlow: TDataSet): TBaseEntity; override;
    function DataSetToCashFlowTransaction(ADtsCashFlowTransaction: TDataSet): TCashFlowTransaction;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: ICashFlowSQLBuilder): ICashFlowRepository;
    function Show(AId: Int64): TCashFlow;
    function Update(AId: Int64; AEntity: TBaseEntity): Int64; override;
    function Store(AEntity: TBaseEntity): Int64; override;
    function GetIdByStationInUse(AStationId: Int64; ADiffCashFlowId: Int64 = 0): Int64;
    function StoreTransaction(ACashFlowTransaction: TCashFlowTransaction): ICashFlowRepository;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils, uZLQry.Interfaces, Vcl.Forms;

{ TCashFlowRepositorySQL }

class function TCashFlowRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: ICashFlowSQLBuilder): ICashFlowRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TCashFlowRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: ICashFlowSQLBuilder);
begin
  inherited Create;
  FConn               := AConn;
  FSQLBuilder         := ASQLBuilder;
  FCashFlowSQLBuilder := ASQLBuilder;
  FManageTransaction  := True;
end;

function TCashFlowRepositorySQL.DataSetToCashFlowTransaction(ADtsCashFlowTransaction: TDataSet): TCashFlowTransaction;
begin
  const LCashFlowTransaction = TCashFlowTransaction.FromJSON(ADtsCashFlowTransaction.ToJSONObjectString);

  // Tratar especificidades
  LCashFlowTransaction.payment.id   := ADtsCashFlowTransaction.FieldByName('payment_id').AsLargeInt;
  LCashFlowTransaction.payment.name := ADtsCashFlowTransaction.FieldByName('payment_name').AsString;
  LCashFlowTransaction.person.id    := ADtsCashFlowTransaction.FieldByName('person_id').AsLargeInt;
  LCashFlowTransaction.person.name  := ADtsCashFlowTransaction.FieldByName('person_name').AsString;

  Result := LCashFlowTransaction;
end;

function TCashFlowRepositorySQL.DataSetToEntity(ADtsCashFlow: TDataSet): TBaseEntity;
begin
  const LCashFlow = TCashFlow.FromJSON(ADtsCashFlow.ToJSONObjectString);

  // Tratar especificidades
  LCashFlow.station.id               := ADtsCashFlow.FieldByName('station_id').AsLargeInt;
  LCashFlow.station.name             := ADtsCashFlow.FieldByName('station_name').AsString;
  LCashFlow.created_by_acl_user.id   := ADtsCashFlow.FieldByName('created_by_acl_user_id').AsLargeInt;
  LCashFlow.created_by_acl_user.name := ADtsCashFlow.FieldByName('created_by_acl_user_name').AsString;
  LCashFlow.updated_by_acl_user.id   := ADtsCashFlow.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LCashFlow.updated_by_acl_user.name := ADtsCashFlow.FieldByName('updated_by_acl_user_name').AsString;

  Result := LCashFlow;
end;

function TCashFlowRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FCashFlowSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TCashFlowRepositorySQL.Show(AId: Int64): TCashFlow;
begin
  Result := nil;
  const LQry = FConn.MakeQry;

  // CashFlow
  const LCashFlow = inherited ShowById(AId) as TCashFlow;
  if not assigned(LCashFlow) then
    Exit;

  // CashFlowTransaction
  LQry.Open(FCashFlowSQLBuilder.SelectCashFlowTransactionsByCashFlowId(AId));
  LQry.First;
  while not LQry.Eof do
  begin
    LCashFlow.cash_flow_transactions.Add(DataSetToCashFlowTransaction(LQry.DataSet));
    LQry.Next;
  end;

  Result := LCashFlow;
end;

function TCashFlowRepositorySQL.GetIdByStationInUse(AStationId, ADiffCashFlowId: Int64): Int64;
begin
  Result := FConn.MakeQry.Open(
    FCashFlowSQLBuilder.StationInUse(AStationId, ADiffCashFlowId)
  ).DataSet.FieldByName('id').AsLargeInt;
end;

function TCashFlowRepositorySQL.Store(AEntity: TBaseEntity): Int64;
var
  LStoredId: Int64;
begin
  Try
    if FManageTransaction then
      FConn.StartTransaction;

    // Instanciar Qry
    const LQry = FConn.MakeQry;

    // CashFlow
    LStoredId := inherited Store(AEntity);
    const LCashFlow = AEntity as TCashFlow;

    // CashFlowTransactions
    for var LCashFlowTransaction in LCashFlow.cash_flow_transactions do
    begin
      LCashFlowTransaction.cash_flow_id := LStoredId;
      LQry.ExecSQL(FCashFlowSQLBuilder.InsertCashFlowTransaction(LCashFlowTransaction))
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

function TCashFlowRepositorySQL.StoreTransaction(ACashFlowTransaction: TCashFlowTransaction): ICashFlowRepository;
begin
  Result := Self;
  FConn.MakeQry.ExecSQL(FCashFlowSQLBuilder.InsertCashFlowTransaction(ACashFlowTransaction));
end;

function TCashFlowRepositorySQL.Update(AId: Int64; AEntity: TBaseEntity): Int64;
begin
  Try
    if FManageTransaction then
      FConn.StartTransaction;

    // Instanciar Qry
    const LQry = FConn.MakeQry;

    // CashFlow
    inherited Update(AId, AEntity);
    const LCashFlow = AEntity as TCashFlow;

    // CashFlowTransactions
    LQry.ExecSQL(FCashFlowSQLBuilder.DeleteCashFlowTransactionsByCashFlowId(AId));
    for var LCashFlowTransaction in LCashFlow.cash_flow_transactions do
    begin
      LCashFlowTransaction.cash_flow_id := AId;
      LQry.ExecSQL(FCashFlowSQLBuilder.InsertCashFlowTransaction(LCashFlowTransaction))
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

procedure TCashFlowRepositorySQL.Validate(AEntity: TBaseEntity);
begin
  const LCashFlow = AEntity as TCashFlow;
  const LIsInserting = (LCashFlow.id = 0);

  // Se já existir uma estação em uso, bloquear operação
  if (GetIdByStationInUse(LCashFlow.station_id, LCashFlow.id) > 0) then
  begin
    raise Exception.Create(
      'Não é possível manter mais de uma estação em aberto.' + #13 +
      '"'+LCashFlow.station_id.ToString + ' - ' + LCashFlow.station.name + '" já está em uso!'
    );
  end;
end;

end.



