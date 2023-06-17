unit uCache;

interface

uses
  System.SysUtils,
  Quick.MemoryCache,
  Quick.Console,
  Quick.Format,
  Quick.Commons,
  System.Generics.Collections,
  XSuperObject,
  uAclUser.Show.DTO,
  System.Classes,
  System.SyncObjs,
  uPosPrinterContent;

type
  TCache = class
  private
    FCache: IMemoryCache;
    FPosPrinterContentList: TObjectList<TPosPrinterContent>;
    FLock: TCriticalSection;
    procedure OnEndPurgerJob(ARemovedEntries : Integer);
    procedure OnPurgeJobError(const AErrorMsg : string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetValue(const AKey, AValue: string; AExpirationMilliseconds: Integer = 0); overload;
    procedure SetValue(const AKey, AValue: string; AExpirationDate: TDateTime); overload;
    function  GetValue(const AKey: string; out AValue : string): Boolean;
    procedure RemoveValue(const AKey: string);
    function  PushPosPrinterContent(APosPrinterID: Int64; AValue: TStringList; ACopies: SmallInt = 1): TCache;
    function  PosPrinterContentList: TObjectList<TPosPrinterContent>;
  end;

var
  Cache: TCache;

const
  AUTH_KEY_CACHE = 'auth';

implementation

{ TCache }

uses
  uSmartPointer,
  uRepository.Factory,
  uAclUser,
  uAclUser.Mapper,
  uHlp;

constructor TCache.Create;
begin
  inherited Create;
  FCache                 := TMemoryCache.Create;
  FCache.Compression     := True;
  //Descomentar quando quiser acompanhar volume de cache
  //FCache.OnEndPurgerJob  := OnEndPurgerJob;
  FCache.OnPurgeJobError := OnPurgeJobError;
  FPosPrinterContentList := TObjectList<TPosPrinterContent>.Create;
  FLock                  := TCriticalSection.Create;
end;

procedure TCache.SetValue(const AKey, AValue: string; AExpirationMilliseconds: Integer);
begin
  Self.RemoveValue(AKey);
  FCache.SetValue(AKey, AValue, AExpirationMilliseconds);
end;

procedure TCache.SetValue(const AKey, AValue: string; AExpirationDate: TDateTime);
begin
  Self.RemoveValue(AKey);
  FCache.SetValue(AKey, AValue, AExpirationDate);
end;

destructor TCache.Destroy;
begin
  if Assigned(FPosPrinterContentList) then FPosPrinterContentList.Free;
  if Assigned(FLock)                  then FLock.Free;
  inherited;
end;

function TCache.GetValue(const AKey: string; out AValue: string): Boolean;
begin
  Result := FCache.TryGetValue(AKey, AValue);
end;

procedure TCache.OnEndPurgerJob(ARemovedEntries: Integer);
begin
  const LMessage = 'Purger job finished (Removed: %s /CachedObjects: %s / CacheSize: %s)';
  cout(Format(LMessage, [NumberToStr(ARemovedEntries),NumberToStr(FCache.CachedObjects),FormatBytes(FCache.CacheSize)]), ccMagenta);
end;

procedure TCache.OnPurgeJobError(const AErrorMsg: string);
begin
  const LMessage = 'Error flushing cache expireds (%s)';
  coutFmt(LMessage, [AErrorMsg], etError);
end;

procedure TCache.RemoveValue(const AKey: string);
begin
  FCache.RemoveValue(AKey);
end;

function TCache.PosPrinterContentList: TObjectList<TPosPrinterContent>;
begin
  Result := FPosPrinterContentList;
end;

function TCache.PushPosPrinterContent(APosPrinterID: Int64; AValue: TStringList; ACopies: SmallInt): TCache;
begin
  Result := Self;

  try
    FLock.Enter;

    const LPosPrinterContent = TPosPrinterContent.Create(APosPrinterID, AValue, ACopies);
    FPosPrinterContentList.Add(LPosPrinterContent);
  finally
    FLock.Leave;
  end;
end;

initialization
  Cache := TCache.Create;

finalization
  Cache.Free;

end.
