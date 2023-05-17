unit uCompany.Repository.SQL;

interface

uses
  uBase.Repository,
  uCompany.Repository.Interfaces,
  uCompany.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uCompany,
  uIndexResult;

type
  TCompanyRepositorySQL = class(TBaseRepository, ICompanyRepository)
  private
    FCompanySQLBuilder: ICompanySQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: ICompanySQLBuilder);
    function DataSetToEntity(ADtsCompany: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: ICompanySQLBuilder): ICompanyRepository;
    function Show(AId: Int64): TCompany;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TCompanyRepositorySQL }

class function TCompanyRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: ICompanySQLBuilder): ICompanyRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TCompanyRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: ICompanySQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FCompanySQLBuilder   := ASQLBuilder;
  FManageTransaction := False;
end;

function TCompanyRepositorySQL.DataSetToEntity(ADtsCompany: TDataSet): TBaseEntity;
var
  LCompany: TCompany;
begin
  LCompany := TCompany.FromJSON(ADtsCompany.ToJSONObjectString);

  // Tratar especificidades
  LCompany.city.id        := ADtsCompany.FieldByName('city_id').AsLargeInt;
  LCompany.city.name      := ADtsCompany.FieldByName('city_name').AsString;
  LCompany.city.state     := ADtsCompany.FieldByName('city_state').AsString;
  LCompany.city.ibge_code := ADtsCompany.FieldByName('city_ibge_code').AsString;

  Result := LCompany;
end;

function TCompanyRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FCompanySQLBuilder.SelectAllWithFilter(AFilter);
end;

function TCompanyRepositorySQL.Show(AId: Int64): TCompany;
begin
  Result := ShowById(AId) as TCompany;
end;

procedure TCompanyRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


