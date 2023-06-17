unit uIndexResult;

interface

uses
  uZLMemTable.Interfaces,
  uReq;

type
  IIndexResult = interface
    ['{3E1EA3EC-540C-40E6-9498-9D59A4EFB297}']

    function Data: IZLMemTable; overload;
    function Data(AValue: IZLMemTable): IIndexResult; overload;

    function CurrentPage: Integer; overload;
    function CurrentPage(AValue: Integer): IIndexResult; overload;

    function CurrentPageRecordCount: Integer; overload;
    function CurrentPageRecordCount(AValue: Integer): IIndexResult; overload;

    function LastPageNumber: Integer; overload;
    function LastPageNumber(AValue: Integer): IIndexResult; overload;

    function AllPagesRecordCount: Integer; overload;
    function AllPagesRecordCount(AValue: Integer): IIndexResult; overload;

    function LimitPerPage: Integer; overload;
    function LimitPerPage(AValue: Integer): IIndexResult; overload;

    function NavPrior: Boolean; overload;
    function NavPrior(AValue: Boolean): IIndexResult; overload;

    function NavNext: Boolean; overload;
    function NavNext(AValue: Boolean): IIndexResult; overload;

    function NavFirst: Boolean; overload;
    function NavFirst(AValue: Boolean): IIndexResult; overload;

    function NavLast: Boolean; overload;
    function NavLast(AValue: Boolean): IIndexResult; overload;

    function ETag: String; overload;
    function ETag(AValue: String): IIndexResult; overload;
  end;

  TIndexResult = class(TInterfacedObject, IIndexResult)
  private
    FData: IZLMemTable;

    FCurrentPage: Integer;
    FCurrentPageRecordCount: Integer;
    FLastPageNumber: Integer;
    FAllPagesRecordCount: Integer;
    FLimitPerPage: Integer;

    FNavPrior: Boolean;
    FNavNext: Boolean;
    FNavFirst: Boolean;
    FNavLast: Boolean;
    FETag: String;
  public
    class function Make: IIndexResult;
    class function FromResponse(AResponseContent: String; ADataStructure: IZLMemTable; AETag: String = ''): IIndexResult;
    constructor Create;
    destructor Destroy; override;

    function Data: IZLMemTable; overload;
    function Data(AValue: IZLMemTable): IIndexResult; overload;

    function CurrentPage: Integer; overload;
    function CurrentPage(AValue: Integer): IIndexResult; overload;

    function CurrentPageRecordCount: Integer; overload;
    function CurrentPageRecordCount(AValue: Integer): IIndexResult; overload;

    function LastPageNumber: Integer; overload;
    function LastPageNumber(AValue: Integer): IIndexResult; overload;

    function AllPagesRecordCount: Integer; overload;
    function AllPagesRecordCount(AValue: Integer): IIndexResult; overload;

    function LimitPerPage: Integer; overload;
    function LimitPerPage(AValue: Integer): IIndexResult; overload;

    function NavPrior: Boolean; overload;
    function NavPrior(AValue: Boolean): IIndexResult; overload;

    function NavNext: Boolean; overload;
    function NavNext(AValue: Boolean): IIndexResult; overload;

    function NavFirst: Boolean; overload;
    function NavFirst(AValue: Boolean): IIndexResult; overload;

    function NavLast: Boolean; overload;
    function NavLast(AValue: Boolean): IIndexResult; overload;

    function ETag: String; overload;
    function ETag(AValue: String): IIndexResult; overload;
  end;

implementation

uses
  System.SysUtils,
  uMemTable.Factory,
  XSuperObject;

{ TIndexResult }

function TIndexResult.AllPagesRecordCount(AValue: Integer): IIndexResult;
begin
  Result := Self;
  FAllPagesRecordCount := AValue;
end;

function TIndexResult.AllPagesRecordCount: Integer;
begin
  Result := FAllPagesRecordCount;
end;

constructor TIndexResult.Create;
begin
  FData := TMemTableFactory.Make;
end;

function TIndexResult.CurrentPage: Integer;
begin
  Result := FCurrentPage;
end;

function TIndexResult.CurrentPage(AValue: Integer): IIndexResult;
begin
  Result := Self;
  FCurrentPage := AValue;
end;

function TIndexResult.CurrentPageRecordCount: Integer;
begin
  Result := FCurrentPageRecordCount;
end;

function TIndexResult.CurrentPageRecordCount(AValue: Integer): IIndexResult;
begin
  Result := Self;
  FCurrentPageRecordCount := AValue;
end;

function TIndexResult.Data(AValue: IZLMemTable): IIndexResult;
begin
  Result := Self;
  FData := AValue;
end;

destructor TIndexResult.Destroy;
begin
  inherited;
end;

function TIndexResult.ETag(AValue: String): IIndexResult;
begin
  Result := Self;
  FETag := AValue;
end;

function TIndexResult.ETag: String;
begin
  Result := FEtag;
end;

class function TIndexResult.FromResponse(AResponseContent: String; ADataStructure: IZLMemTable; AETag: String = ''): IIndexResult;
begin
  Result := Self.Make;
  Result.ETag(AETag);

  // Retorno dos dados
  const LSO = SO(AResponseContent);
  Result
    .Data                   (ADataStructure.FromJson(LSO.O['data'].A['result'].AsJSON))
    .CurrentPage            (LSO.O['data'].O['meta'].I['current_page'])
    .CurrentPageRecordCount (LSO.O['data'].O['meta'].I['current_page_record_count'])
    .LastPageNumber         (LSO.O['data'].O['meta'].I['last_page_number'])
    .AllPagesRecordCount    (LSO.O['data'].O['meta'].I['all_pages_record_count'])
    .LimitPerPage           (LSO.O['data'].O['meta'].I['limit_per_page'])
    .NavPrior               (LSO.O['data'].O['meta'].B['nav_prior'])
    .NavNext                (LSO.O['data'].O['meta'].B['nav_next'])
    .NavFirst               (LSO.O['data'].O['meta'].B['nav_first'])
    .NavLast                (LSO.O['data'].O['meta'].B['nav_last']);
end;

function TIndexResult.Data: IZLMemTable;
begin
  Result := FData;
end;

function TIndexResult.LastPageNumber(AValue: Integer): IIndexResult;
begin
  Result := Self;
  FLastPageNumber := AValue;
end;

function TIndexResult.LimitPerPage(AValue: Integer): IIndexResult;
begin
  Result := Self;
  FLimitPerPage := AValue;
end;

function TIndexResult.LimitPerPage: Integer;
begin
  Result := FLimitPerPage;
end;

function TIndexResult.LastPageNumber: Integer;
begin
  Result := FLastPageNumber;
end;

class function TIndexResult.Make: IIndexResult;
begin
  Result := Self.Create;
end;

function TIndexResult.NavFirst(AValue: Boolean): IIndexResult;
begin
  Result := Self;
  FNavFirst := AValue;
end;

function TIndexResult.NavFirst: Boolean;
begin
  Result := FNavFirst;
end;

function TIndexResult.NavLast(AValue: Boolean): IIndexResult;
begin
  Result := Self;
  FNavLast := AValue;
end;

function TIndexResult.NavLast: Boolean;
begin
  Result := FNavLast;
end;

function TIndexResult.NavNext(AValue: Boolean): IIndexResult;
begin
  Result := Self;
  FNavNext := AValue;
end;

function TIndexResult.NavNext: Boolean;
begin
  Result := FNavNext;
end;

function TIndexResult.NavPrior(AValue: Boolean): IIndexResult;
begin
  Result := Self;
  FNavPrior := AValue;
end;

function TIndexResult.NavPrior: Boolean;
begin
  Result := FNavPrior;
end;

end.

