unit uStation.Repository.SQL;

interface

uses
  uBase.Repository,
  uStation.Repository.Interfaces,
  uStation.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uStation,
  uIndexResult;

type
  TStationRepositorySQL = class(TBaseRepository, IStationRepository)
  private
    FStationSQLBuilder: IStationSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IStationSQLBuilder);
    function DataSetToEntity(ADtsStation: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IStationSQLBuilder): IStationRepository;
    function Show(AId: Int64): TStation;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TStationRepositorySQL }

class function TStationRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IStationSQLBuilder): IStationRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TStationRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IStationSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FStationSQLBuilder   := ASQLBuilder;
  FManageTransaction := False;
end;

function TStationRepositorySQL.DataSetToEntity(ADtsStation: TDataSet): TBaseEntity;
begin
  Result := TStation.FromJSON(ADtsStation.ToJSONObjectString);
end;

function TStationRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FStationSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TStationRepositorySQL.Show(AId: Int64): TStation;
begin
  Result := ShowById(AId) as TStation;
end;

procedure TStationRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


