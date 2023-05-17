unit uOutPutFileStream;

interface

uses
  System.Classes;

type
  IOutPutFileStream = Interface
    ['{6089C5F9-6EEA-426B-9E81-4B446D774472}']
    function Value: TFileStream;
    function FilePath: String;
    function ContentType: String;
    function ToBase64: String;
  end;

  TOutPutFileStream = class(TInterfacedObject, IOutPutFileStream)
  private
    FStream: TFileStream;
    FFilePath: String;
    FCopyFilePath: String;
    constructor Create(AFilePath: String);
  public
    destructor Destroy; override;
    class function Make(AFilePath: String): IOutPutFileStream;

    function Value: TFileStream;
    function FilePath: String;
    function ContentType: String;
    function ToBase64: String;
  end;

implementation

uses
  System.SysUtils,
  Windows,
  System.NetEncoding;

{ TOutPutFileStream }

function TOutPutFileStream.ContentType: String;
var
  lExt: String;
begin
  lExt := ExtractFileExt(FFilePath);
  if (lExt = '.pdf') then Result := 'application/pdf';
end;

constructor TOutPutFileStream.Create(AFilePath: String);
begin
  inherited Create;
  FFilePath     := AFilePath;
  FCopyFilePath := Copy(FFilePath, 1, Pos('.', FFilePath)-1) + '_copy'+ Copy(FFilePath, Pos('.', FFilePath));
  CopyFile(PChar(FFilePath), PChar(FCopyFilePath), False);

  // Abrir Stream com cópia do arquivo para evitar erros
  FStream := TFileStream.Create(FCopyFilePath, fmOpenRead);
end;

destructor TOutPutFileStream.Destroy;
begin
  if Assigned(FStream) then FStream.Free;
  inherited;
end;

function TOutPutFileStream.FilePath: String;
begin
  Result := FFilePath;
end;

class function TOutPutFileStream.Make(AFilePath: String): IOutPutFileStream;
begin
  Result := Self.Create(AFilePath);
end;

function TOutPutFileStream.ToBase64: String;
const
  L_CHARS_TO_REMOVE: TArray<String> = ['[',']','{','}'];
var
  LInStream: TStream;
  LOutStream: TStream;
  LFile: String;
  LStrList: TStringList;
  lI: Integer;
  LNextUUID: String;
begin
  LNextUUID := TGUID.NewGuid.ToString;
  for lI := 0 to High(L_CHARS_TO_REMOVE) do
    LNextUUID := StringReplace(LNextUUID, L_CHARS_TO_REMOVE[lI], '', [rfReplaceAll]);

  LInStream := TFileStream.Create(FFilePath, fmOpenRead);
  LStrList  := TStringList.Create;
  try
    LFile := 'Temp\'+LNextUUID;
    LOutStream := TFileStream.Create(LFile, fmCreate);
    try
      TNetEncoding.Base64.Encode(LInStream, LOutStream);
    finally
      LOutStream.Free;
    end;

    LStrList.LoadFromFile(LFile);
    Result := LStrList.Text;
  finally
    if FileExists(LFile)   then DeleteFile(Pchar(LFile));
    if Assigned(LInStream) then LInStream.Free;
    if Assigned(LStrList)  then LStrList.Free;
  end;
end;

function TOutPutFileStream.Value: TFileStream;
begin
  Result := FStream;
end;

end.

