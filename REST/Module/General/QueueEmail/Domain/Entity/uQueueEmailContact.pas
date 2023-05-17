unit uQueueEmailContact;

interface

uses
  uBase.Entity,
  uQueueEmail.Types;

type
  TQueueEmailContact = class(TBaseEntity)
  private
    Fname: String;
    Fqueue_email_id: Int64;
    Fid: Int64;
    Femail: string;
    Ftype: TQueueEmailContactType;
    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property queue_email_id: Int64 read Fqueue_email_id write Fqueue_email_id;
    property email: string read Femail write Femail;
    property name: String read Fname write Fname;
    property &type: TQueueEmailContactType read Ftype write Ftype;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uHlp,
  uAppRest.Types,
  uApplication.Exception,
  uTrans;

{ TQueueEmailContact }

constructor TQueueEmailContact.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TQueueEmailContact.Destroy;
begin
  inherited;
end;

procedure TQueueEmailContact.Initialize;
begin
//
end;

function TQueueEmailContact.Validate: String;
var
  LIsInserting: Boolean;
begin
  Result := EmptyStr;
  LIsInserting := Fid = 0;

  if Femail.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('E-mail') + #13;

  if Fname.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;
end;

end.

