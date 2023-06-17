unit uAdditional.Repository.SQL;

interface

uses
  uBase.Repository,
  uAdditional.Repository.Interfaces,
  uAdditional.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uAdditional,
  uIndexResult,
  uAdditionalProduct;

type
  TAdditionalRepositorySQL = class(TBaseRepository, IAdditionalRepository)
  private
    FAdditionalSQLBuilder: IAdditionalSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IAdditionalSQLBuilder);
    function DataSetToEntity(ADtsAdditional: TDataSet): TBaseEntity; override;
    function DataSetToAdditionalProduct(ADtsAdditionalProduct: TDataSet): TAdditionalProduct;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IAdditionalSQLBuilder): IAdditionalRepository;
    function Show(AId: Int64): TAdditional;
    function Update(AId: Int64; AEntity: TBaseEntity): Int64; override;
    function Store(AEntity: TBaseEntity): Int64; override;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TAdditionalRepositorySQL }

class function TAdditionalRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IAdditionalSQLBuilder): IAdditionalRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TAdditionalRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IAdditionalSQLBuilder);
begin
  inherited Create;
  FConn                 := AConn;
  FSQLBuilder           := ASQLBuilder;
  FAdditionalSQLBuilder := ASQLBuilder;
  FManageTransaction    := True;
end;

function TAdditionalRepositorySQL.DataSetToEntity(ADtsAdditional: TDataSet): TBaseEntity;
begin
  const LAdditional = TAdditional.FromJSON(ADtsAdditional.ToJSONObjectString);

  // Tratar especificidades
  LAdditional.created_by_acl_user.id   := ADtsAdditional.FieldByName('created_by_acl_user_id').AsLargeInt;
  LAdditional.created_by_acl_user.name := ADtsAdditional.FieldByName('created_by_acl_user_name').AsString;
  LAdditional.updated_by_acl_user.id   := ADtsAdditional.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LAdditional.updated_by_acl_user.name := ADtsAdditional.FieldByName('updated_by_acl_user_name').AsString;

  Result := LAdditional;
end;

function TAdditionalRepositorySQL.DataSetToAdditionalProduct(ADtsAdditionalProduct: TDataSet): TAdditionalProduct;
begin
  Result := TAdditionalProduct.FromJSON(ADtsAdditionalProduct.ToJSONObjectString);

  // Tratar especificidades
  Result.product.id   := ADtsAdditionalProduct.FieldByName('product_id').AsLargeInt;
  Result.product.name := ADtsAdditionalProduct.FieldByName('product_name').AsString;
end;

function TAdditionalRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FAdditionalSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TAdditionalRepositorySQL.Show(AId: Int64): TAdditional;
begin
  Result := nil;
  const LQry = FConn.MakeQry;

  // Additional
  const LAdditional = inherited ShowById(AId) as TAdditional;
  if not Assigned(LAdditional) then
    Exit;

  // AdditionalProduct
  LQry.Open(FAdditionalSQLBuilder.SelectAdditionalProductsByAdditionalId(AId));
  LQry.First;
  while not LQry.Eof do
  begin
    LAdditional.additional_products.Add(DataSetToAdditionalProduct(LQry.DataSet));
    LQry.Next;
  end;

  Result := LAdditional;
end;

function TAdditionalRepositorySQL.Store(AEntity: TBaseEntity): Int64;
var
  LStoredId: Int64;
begin
  Try
    if FManageTransaction then
      FConn.StartTransaction;

    // Instanciar Qry
    const LQry = FConn.MakeQry;

    // Additional
    LStoredId := inherited Store(AEntity);
    const LAdditional = AEntity as TAdditional;

    // AdditionalProducts
    for var LAdditionalProduct in LAdditional.additional_products do
    begin
      LAdditionalProduct.additional_id := LStoredId;
      LQry.ExecSQL(FAdditionalSQLBuilder.InsertAdditionalProduct(LAdditionalProduct))
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

function TAdditionalRepositorySQL.Update(AId: Int64; AEntity: TBaseEntity): Int64;
begin
  Try
    if FManageTransaction then
      FConn.StartTransaction;

    // Instanciar Qry
    const LQry = FConn.MakeQry;

    // Additional
    inherited Update(AId, AEntity);
    const LAdditional = AEntity as TAdditional;

    // AdditionalProducts
    LQry.ExecSQL(FAdditionalSQLBuilder.DeleteAdditionalProductsByAdditionalId(AId));
    for var LAdditionalProduct in LAdditional.additional_products do
    begin
      LAdditionalProduct.additional_id := AId;
      LQry.ExecSQL(FAdditionalSQLBuilder.InsertAdditionalProduct(LAdditionalProduct))
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

procedure TAdditionalRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


