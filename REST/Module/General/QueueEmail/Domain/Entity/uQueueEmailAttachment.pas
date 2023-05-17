unit uQueueEmailAttachment;

interface

uses
  uBase.Entity,
  System.Classes;

type
  TQueueEmailAttachment = class(TBaseEntity)
  private
    Fbase64: String;
    Fqueue_email_id: Int64;
    Fid: Int64;
    Ffile_name: string;
    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property queue_email_id: Int64 read Fqueue_email_id write Fqueue_email_id;
    property file_name: string read Ffile_name write Ffile_name;
    property base64: String read Fbase64 write Fbase64;

    function base64ToMemoryStream: TMemoryStream;
    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uHlp,
  uAppRest.Types,
  uApplication.Exception,
  uTrans,
  System.NetEncoding;

{ TQueueEmailAttachment }

function TQueueEmailAttachment.base64ToMemoryStream: TMemoryStream;
begin
  if Fbase64.Trim.IsEmpty then
    Result := Nil;

  // Converter Base64 p/ MemoryStream
  const LBytes = TBase64Encoding.Base64.DecodeStringToBytes(Fbase64);
  Result := TMemoryStream.Create;
  Result.WriteBuffer(LBytes[0], Length(LBytes));
end;

constructor TQueueEmailAttachment.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TQueueEmailAttachment.Destroy;
begin
  inherited;
end;

procedure TQueueEmailAttachment.Initialize;
begin
//
end;

function TQueueEmailAttachment.Validate: String;
var
  LIsInserting: Boolean;
begin
  Result := EmptyStr;
  LIsInserting := Fid = 0;

  if file_name.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome do Arquivo') + #13;

  if base64.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Arquivo em Base64') + #13;
end;

end.

