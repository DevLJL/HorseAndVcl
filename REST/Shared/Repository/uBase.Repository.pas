unit uBase.Repository;

interface

uses
  uBase.Repository.Interfaces,
  uZLConnection.Interfaces,
  
  uIndexResult,
  uBase.Entity,
  uBase.SQLBuilder.Interfaces,
  Data.DB,
  uSelectWithFilter,
  uFilter;

type
  TBaseRepository = class abstract (TInterfacedObject, IBaseRepository)
  protected
    FConn: IZLConnection;
    FSQLBuilder: IBaseSQLBuilder;
    FManageTransaction: Boolean;
    function DataSetToEntity(ADtsBrand: TDataSet): TBaseEntity; virtual; abstract;
    procedure Validate(AEntity: TBaseEntity); virtual; abstract;
  public
    function Conn: IZLConnection;
    function SetManageTransaction(AValue: Boolean): IBaseRepository;
    function Delete(AId: Int64): Boolean; virtual;
    function DeleteByIdRange(AId: String): Boolean; virtual;
    function ShowById(AId: Int64): TBaseEntity; virtual;
    function Store(AEntity: TBaseEntity): Int64; virtual;
    function Update(AId: Int64; AEntity: TBaseEntity): Int64; virtual;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter; virtual; abstract;
    function Index(AFilter: IFilter): IIndexResult; virtual;
  end;

implementation

uses
  uZLQry.Interfaces,
  System.SysUtils,
  System.Math,
  uHlp;

{ TBaseRepository }

function TBaseRepository.Conn: IZLConnection;
begin
  Result := FConn;
end;

function TBaseRepository.Delete(AId: Int64): Boolean;
begin
  FConn.MakeQry.ExecSQL(FSQLBuilder.DeleteById(AId));
  Result := True;
end;

function TBaseRepository.DeleteByIdRange(AId: String): Boolean;
begin
  FConn.MakeQry.ExecSQL(FSQLBuilder.DeleteByIdRange(AId));
  Result := True;
end;

function TBaseRepository.Index(AFilter: IFilter): IIndexResult;
var
  lOutPut: TOutPutSelectAlLFilter;
  lSQLPaginate, lSQLWithoutPaginate: String;
  lAllPagesRecordCount, lCurrentPageRecordCount, lLastPageNumber: Integer;
  LQry: IZLQry;
begin
  Result := TIndexResult.Make;
  LQry   := FConn.MakeQry;

  // SQL com pagina��o e sem pagina��o
  lOutPut             := SelectAllWithFilter(AFilter);
  lSQLPaginate        := lOutPut.SQL;
  lSQLWithoutPaginate := lOutPut.SQLWithoutPaginate;

  // Executar sql com pagina��o
  LQry.Open(lSQLPaginate);
  Result.Data.FromDataSet(LQry.DataSet);
  lCurrentPageRecordCount := Result.Data.DataSet.RecordCount;

  if Assigned(AFilter) then
  begin
    lSQLWithoutPaginate := 'select count(*) ' + copy(lSQLWithoutPaginate, Pos('from', lSQLWithoutPaginate));
    lSQLWithoutPaginate := StringReplace(lSQLWithoutPaginate, copy(lSQLWithoutPaginate, Pos('order by', lSQLWithoutPaginate)), '', [rfReplaceAll]);
    LQry.Open(lSQLWithoutPaginate);
    lAllPagesRecordCount := LQry.DataSet.Fields[0].AsLargeInt;
    lLastPageNumber := 1;
    if (AFilter.LimitPerPage > 0) then
      lLastPageNumber := ceil(lAllPagesRecordCount/AFilter.LimitPerPage);

    // Metadados
    Result.CurrentPage        (AFilter.CurrentPage)
      .CurrentPageRecordCount (lCurrentPageRecordCount)
      .LastPageNumber         (lLastPageNumber)
      .AllPagesRecordCount    (lAllPagesRecordCount)
      .LimitPerPage           (AFilter.LimitPerPage)
      .NavFirst               (AFilter.CurrentPage > 1)
      .NavPrior               (AFilter.CurrentPage > 1)
      .NavNext                (not (AFilter.CurrentPage = lLastPageNumber))
      .NavLast                (not (AFilter.CurrentPage = lLastPageNumber));
  end;
end;

function TBaseRepository.SetManageTransaction(AValue: Boolean): IBaseRepository;
begin
  Result := Self;
  FManageTransaction := AValue;
end;

function TBaseRepository.ShowById(AId: Int64): TBaseEntity;
begin
  Result := nil;
  With FConn.MakeQry.Open(FSQLBuilder.SelectById(AId)) do
  begin
    if DataSet.IsEmpty then Exit;
    Result := DataSetToEntity(DataSet);
  end;
end;

function TBaseRepository.Store(AEntity: TBaseEntity): Int64;
begin
  Validate(AEntity);
  Result := FConn.MakeQry
    .ExecSQL (FSQLBuilder.Insert(AEntity))
    .Open    (FSQLBuilder.LastInsertId)
    .DataSet.Fields[0].AsLargeInt;
end;

function TBaseRepository.Update(AId: Int64; AEntity: TBaseEntity): Int64;
begin
  Validate(AEntity);
  FConn.MakeQry.ExecSQL(FSQLBuilder.Update(AId, AEntity));
  Result := AId;
end;

end.
