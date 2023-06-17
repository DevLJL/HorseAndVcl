unit uPosPrinter.Repository.SQL;

interface

uses
  uBase.Repository,
  uPosPrinter.Repository.Interfaces,
  uPosPrinter.SQLBuilder.Interfaces,
  uZLConnection.Interfaces,
  Data.DB,
  uBase.Entity,
  uFilter,
  uSelectWithFilter,
  uPosPrinter,
  uIndexResult;

type
  TPosPrinterRepositorySQL = class(TBaseRepository, IPosPrinterRepository)
  private
    FPosPrinterSQLBuilder: IPosPrinterSQLBuilder;
    constructor Create(AConn: IZLConnection; ASQLBuilder: IPosPrinterSQLBuilder);
    function DataSetToEntity(ADtsPosPrinter: TDataSet): TBaseEntity; override;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; override;
    procedure Validate(AEntity: TBaseEntity); override;
  public
    class function Make(AConn: IZLConnection; ASQLBuilder: IPosPrinterSQLBuilder): IPosPrinterRepository;
    function Show(AId: Int64): TPosPrinter;
 end;

implementation

uses
  XSuperObject,
  DataSet.Serialize,
  System.SysUtils;

{ TPosPrinterRepositorySQL }

class function TPosPrinterRepositorySQL.Make(AConn: IZLConnection; ASQLBuilder: IPosPrinterSQLBuilder): IPosPrinterRepository;
begin
  Result := Self.Create(AConn, ASQLBuilder);
end;

constructor TPosPrinterRepositorySQL.Create(AConn: IZLConnection; ASQLBuilder: IPosPrinterSQLBuilder);
begin
  inherited Create;
  FConn                   := AConn;
  FSQLBuilder             := ASQLBuilder;
  FPosPrinterSQLBuilder   := ASQLBuilder;
  FManageTransaction      := False;
end;

function TPosPrinterRepositorySQL.DataSetToEntity(ADtsPosPrinter: TDataSet): TBaseEntity;
begin
  const LPosPrinter = TPosPrinter.FromJSON(ADtsPosPrinter.ToJSONObjectString);

  // Tratar especificidades
  LPosPrinter.created_by_acl_user.id   := ADtsPosPrinter.FieldByName('created_by_acl_user_id').AsLargeInt;
  LPosPrinter.created_by_acl_user.name := ADtsPosPrinter.FieldByName('created_by_acl_user_name').AsString;
  LPosPrinter.updated_by_acl_user.id   := ADtsPosPrinter.FieldByName('updated_by_acl_user_id').AsLargeInt;
  LPosPrinter.updated_by_acl_user.name := ADtsPosPrinter.FieldByName('updated_by_acl_user_name').AsString;

  Result := LPosPrinter;
end;

function TPosPrinterRepositorySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := FPosPrinterSQLBuilder.SelectAllWithFilter(AFilter);
end;

function TPosPrinterRepositorySQL.Show(AId: Int64): TPosPrinter;
begin
  Result := ShowById(AId) as TPosPrinter;
end;

procedure TPosPrinterRepositorySQL.Validate(AEntity: TBaseEntity);
begin
//
end;

end.


