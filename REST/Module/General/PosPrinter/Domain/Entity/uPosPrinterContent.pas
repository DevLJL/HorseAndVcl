unit uPosPrinterContent;

interface

uses
  System.Classes;

type
  TPosPrinterContent = class
  private
    FPosPrinterId: Int64;
    FContent: TStringList;
    FCopies: SmallInt;
    FUUID: String;
    FRetries: Integer;
  public
    constructor Create(APosPrinterId: Int64; AContent: TStringList; ACopies: SmallInt = 1);
    destructor Destroy; override;
    property PosPrinterId: Int64 read FPosPrinterId write FPosPrinterId;
    property Content: TStringList read FContent write FContent;
    property Copies: SmallInt read FCopies write FCopies;
    property UUID: String read FUUID write FUUID;
    property Retries: Integer read FRetries write FRetries;
    function Clone: TPosPrinterContent;
  end;

implementation

uses
  uHlp;

{ TPosPrinterContent }

function TPosPrinterContent.Clone: TPosPrinterContent;
begin
  const LContent = TStringList.Create;
  LContent.BeginUpdate;
  LContent.Text := FContent.Text;
  LContent.EndUpdate;

  Result         := TPosPrinterContent.Create(FPosPrinterId, LContent, FCopies);
  Result.UUID    := FUUID;
  Result.Retries := FRetries;
end;

constructor TPosPrinterContent.Create(APosPrinterId: Int64; AContent: TStringList; ACopies: SmallInt);
begin
  inherited Create;
  FPosPrinterId := APosPrinterId;
  FContent      := AContent;
  FCopies       := ACopies;
  FUUID         := NextUUID;
  FRetries      := 0;
end;

destructor TPosPrinterContent.Destroy;
begin
  if Assigned(FContent) then FContent.Free;
  inherited;
end;

end.
