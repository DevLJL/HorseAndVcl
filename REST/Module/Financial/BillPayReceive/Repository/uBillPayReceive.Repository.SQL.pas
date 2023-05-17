unit uBillPayReceive.Repository.SQL;

interface

uses
  uBase.Repository,
  uBillPayReceive.Repository.Interfaces,
  uBillPayReceive.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uBillPayReceive;

type
  TBillPayReceiveRepositorySQL = class(TBaseRepository, IBillPayReceiveRepository)
  private
    FBillPayReceiveSQLBuilder: IBillPayReceiveSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IBillPayReceiveSQLBuilder);
    function DataSetToEntity(ADtsBillPayReceive: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IBillPayReceiveSQLBuilder): IBillPayReceiveRepository;
    function Show(AId: Int64): TBillPayReceive;
    function DeleteBySaleId(ASaleId: Int64): Boolean;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TBillPayReceiveRepositorySQL }

class function TBillPayReceiveRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IBillPayReceiveSQLBuilder): IBillPayReceiveRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TBillPayReceiveRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IBillPayReceiveSQLBuilder);
begin
  inherited Create;
  FConn            := AConn;
  FSQLBuilder      := ASQLBuilder;
  FBillPayReceiveSQLBuilder := ASQLBuilder;
end;

function TBillPayReceiveRepositorySQL.DataSetToEntity(ADtsBillPayReceive: TDataSet): TBaseEntity;
var
  LBillPayReceive: TBillPayReceive;
begin
  LBillPayReceive := TBillPayReceive.FromJSON(ADtsBillPayReceive.ToJSONObjectString);

  // Tratar especificidades
  LBillPayReceive.person.id                := ADtsBillPayReceive.FieldByName('person_id').AsLargeInt;
  LBillPayReceive.person.name              := ADtsBillPayReceive.FieldByName('person_name').AsString;
  LBillPayReceive.chart_of_account.id      := ADtsBillPayReceive.FieldByName('chart_of_account_id').AsLargeInt;
  LBillPayReceive.chart_of_account.name    := ADtsBillPayReceive.FieldByName('chart_of_account_name').AsString;
  LBillPayReceive.cost_center.id           := ADtsBillPayReceive.FieldByName('cost_center_id').AsLargeInt;
  LBillPayReceive.cost_center.name         := ADtsBillPayReceive.FieldByName('cost_center_name').AsString;
  LBillPayReceive.bank_account.id          := ADtsBillPayReceive.FieldByName('bank_account_id').AsLargeInt;
  LBillPayReceive.bank_account.name        := ADtsBillPayReceive.FieldByName('bank_account_name').AsString;
  LBillPayReceive.payment.id               := ADtsBillPayReceive.FieldByName('payment_id').AsLargeInt;
  LBillPayReceive.payment.name             := ADtsBillPayReceive.FieldByName('payment_name').AsString;
  LBillPayReceive.created_by_acl_user.id   := ADtsBillPayReceive.FieldByName('created_by_acl_user_id').AsLargeInt;
  LBillPayReceive.created_by_acl_user.name := ADtsBillPayReceive.FieldByName('created_by_acl_user_name').AsString;
  LBillPayReceive.updated_by_acl_user.id   := ADtsBillPayReceive.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LBillPayReceive.updated_by_acl_user.name := ADtsBillPayReceive.FieldByName('updated_by_acl_user_name').AsString;

  Result := LBillPayReceive;
end;

function TBillPayReceiveRepositorySQL.DeleteBySaleId(ASaleId: Int64): Boolean;
begin
  FConn.MakeQry.ExecSQL('DELETE FROM bill_pay_receive WHERE bill_pay_receive.sale_id = ' + ASaleId.ToString);
  Result := True;
end;

function TBillPayReceiveRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FBillPayReceiveSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TBillPayReceiveRepositorySQL.Show(AId: Int64): TBillPayReceive;
begin
  Result := ShowById(AId) as TBillPayReceive;
end;

procedure TBillPayReceiveRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.



