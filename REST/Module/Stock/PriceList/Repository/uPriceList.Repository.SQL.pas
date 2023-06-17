unit uPriceList.Repository.SQL;

interface

uses
  uBase.Repository,
  uPriceList.Repository.Interfaces,
  uPriceList.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uPriceList,
  uIndexResult;

type
  TPriceListRepositorySQL = class(TBaseRepository, IPriceListRepository)
  private
    FPriceListSQLBuilder: IPriceListSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IPriceListSQLBuilder);
    function DataSetToEntity(ADtsPriceList: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IPriceListSQLBuilder): IPriceListRepository;
    function Show(AId: Int64): TPriceList;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TPriceListRepositorySQL }

class function TPriceListRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IPriceListSQLBuilder): IPriceListRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TPriceListRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IPriceListSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FPriceListSQLBuilder   := ASQLBuilder;
  FManageTransaction := False;
end;

function TPriceListRepositorySQL.DataSetToEntity(ADtsPriceList: TDataSet): TBaseEntity;
begin
  const LPriceList = TPriceList.FromJSON(ADtsPriceList.ToJSONObjectString);

  // Tratar especificidades
  LPriceList.created_by_acl_user.id   := ADtsPriceList.FieldByName('created_by_acl_user_id').AsLargeInt;
  LPriceList.created_by_acl_user.name := ADtsPriceList.FieldByName('created_by_acl_user_name').AsString;
  LPriceList.updated_by_acl_user.id   := ADtsPriceList.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LPriceList.updated_by_acl_user.name := ADtsPriceList.FieldByName('updated_by_acl_user_name').AsString;

  Result := LPriceList;
end;

function TPriceListRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FPriceListSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TPriceListRepositorySQL.Show(AId: Int64): TPriceList;
begin
  Result := ShowById(AId) as TPriceList;
end;

procedure TPriceListRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


