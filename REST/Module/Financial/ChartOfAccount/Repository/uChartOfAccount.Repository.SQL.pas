unit uChartOfAccount.Repository.SQL;

interface

uses
  uBase.Repository,
  uChartOfAccount.Repository.Interfaces,
  uChartOfAccount.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uChartOfAccount,
  uIndexResult;

type
  TChartOfAccountRepositorySQL = class(TBaseRepository, IChartOfAccountRepository)
  private
    FChartOfAccountSQLBuilder: IChartOfAccountSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IChartOfAccountSQLBuilder);
    function DataSetToEntity(ADtsChartOfAccount: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IChartOfAccountSQLBuilder): IChartOfAccountRepository;
    function Show(AId: Int64): TChartOfAccount;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TChartOfAccountRepositorySQL }

class function TChartOfAccountRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IChartOfAccountSQLBuilder): IChartOfAccountRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TChartOfAccountRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IChartOfAccountSQLBuilder);
begin
  inherited Create;
  FConn              := AConn;
  FSQLBuilder        := ASQLBuilder;
  FChartOfAccountSQLBuilder   := ASQLBuilder;
  FManageTransaction := False;
end;

function TChartOfAccountRepositorySQL.DataSetToEntity(ADtsChartOfAccount: TDataSet): TBaseEntity;
var
  LChartOfAccount: TChartOfAccount;
begin
  LChartOfAccount := TChartOfAccount.FromJSON(ADtsChartOfAccount.ToJSONObjectString);

  // Tratar especificidades
  LChartOfAccount.created_by_acl_user.id   := ADtsChartOfAccount.FieldByName('created_by_acl_user_id').AsLargeInt;
  LChartOfAccount.created_by_acl_user.name := ADtsChartOfAccount.FieldByName('created_by_acl_user_name').AsString;
  LChartOfAccount.updated_by_acl_user.id   := ADtsChartOfAccount.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LChartOfAccount.updated_by_acl_user.name := ADtsChartOfAccount.FieldByName('updated_by_acl_user_name').AsString;

  Result := LChartOfAccount;
end;

function TChartOfAccountRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FChartOfAccountSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TChartOfAccountRepositorySQL.Show(AId: Int64): TChartOfAccount;
begin
  Result := ShowById(AId) as TChartOfAccount;
end;

procedure TChartOfAccountRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


