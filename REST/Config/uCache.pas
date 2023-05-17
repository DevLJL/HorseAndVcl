unit uCache;

interface

uses
  System.SysUtils,
  Quick.MemoryCache,
  Quick.Console,
  Quick.Format,
  Quick.Commons,
  System.Generics.Collections,
  uProduct.Show.DTO,
  XSuperObject;

type
  TCache = class
  private
    FCache: IMemoryCache;
    FProductShowDTOList: TObjectList<TProductShowDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetValue(const AKey, AValue: string; AExpirationMilliseconds: Integer = 0);
    function  GetValue(const AKey: string; out AValue : string): Boolean;
    procedure RemoveValue(const AKey: string);

    function  PushProduct(AValue: TProductShowDTO): TCache;
    function  GetProduct(AId: Int64): TProductShowDTO;
    procedure ClearProductList;
  end;

var
  Cache: TCache;

implementation

{ TCache }

constructor TCache.Create;
begin
  inherited Create;
  FCache := TMemoryCache.Create;
  FCache.Compression := True;
  FCache.OnEndPurgerJob := procedure(aRemovedEntries : Integer)
                           begin
                             cout(Format('[CACHE] Purger job finished (Removed: %s /CachedObjects: %s / CacheSize: %s)',[NumberToStr(aRemovedEntries),NumberToStr(FCache.CachedObjects),FormatBytes(FCache.CacheSize)]),ccMagenta);
                           end;

  FCache.OnPurgeJobError := procedure(const aErrorMsg : string)
                            begin
                              coutFmt('[CACHE] Error flushing cache expireds (%s)',[aErrorMsg],etError);
                            end;
  FProductShowDTOList := TObjectList<TProductShowDTO>.Create;
end;

procedure TCache.SetValue(const AKey, AValue: string; AExpirationMilliseconds: Integer);
begin
  Self.RemoveValue(AKey);
  FCache.SetValue(AKey, AValue, AExpirationMilliseconds);
end;

destructor TCache.Destroy;
begin
  if Assigned(FProductShowDTOList) then FProductShowDTOList.Free;
  inherited;
end;

function TCache.GetValue(const AKey: string; out AValue: string): Boolean;
begin
  Result := FCache.TryGetValue(AKey, AValue);
end;

procedure TCache.RemoveValue(const AKey: string);
begin
  FCache.RemoveValue(AKey);
  if AKey.Contains('TProductController') then
    ClearProductList;
end;

function TCache.GetProduct(AId: Int64): TProductShowDTO;
begin
  Result := Nil;
  for var LProduct in FProductShowDTOList do
  begin
    if (LProduct.id = AId) then
    Begin
      Result := TProductShowDTO.FromJSON(LProduct.AsJSON);
      Break;
    End;
  end;
end;

procedure TCache.ClearProductList;
begin
  if not Assigned(FProductShowDTOList) then
    Exit;

  FreeAndNil(FProductShowDTOList);
  FProductShowDTOList := TObjectList<TProductShowDTO>.Create;
end;

function TCache.PushProduct(AValue: TProductShowDTO): TCache;
begin
  Result := Self;
  if not Assigned(AValue) then
    Exit;

  FProductShowDTOList.Add(TProductShowDTO.FromJSON(AValue.AsJSON));
  if (FProductShowDTOList.Count >= 100) then
    FProductShowDTOList.Delete(0);
end;

initialization
  Cache := TCache.Create;

finalization
  Cache.Free;

end.
