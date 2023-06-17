unit uPosPrinter;

interface

uses
  uAclUser,
  uBase.Entity,
  Data.DB,
  uPosPrinter.Types;

type
  TPosPrinter = class(TBaseEntity)
  private
    Fid: Int64;
    Fname: string;
    Fflg_translate_tags: SmallInt;
    Fbuffer: SmallInt;
    Fflg_partial_paper_cut: SmallInt;
    Fblank_lines_to_end: SmallInt;
    Fflg_paper_cut: SmallInt;
    Fflg_ignore_tags: SmallInt;
    Fmodel: TPosPrinterModel;
    Fcolumns: SmallInt;
    Fport: String;
    Fflg_send_cut_written_command: SmallInt;
    Fspace_between_lines: SmallInt;
    Fpage_code: TPosPrinterPageCode;
    Ffont_size: SmallInt;
    Fflg_port_control: SmallInt;
    Fcreated_at: TDateTime;
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;

    // OneToOne
    Fupdated_by_acl_user: TAclUser;
    Fcreated_by_acl_user: TAclUser;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property name: string read Fname write Fname;
    property model: TPosPrinterModel read Fmodel write Fmodel;
    property port: String read Fport write Fport;
    property columns: SmallInt read Fcolumns write Fcolumns;
    property space_between_lines: SmallInt read Fspace_between_lines write Fspace_between_lines;
    property buffer: SmallInt read Fbuffer write Fbuffer;
    property font_size: SmallInt read Ffont_size write Ffont_size;
    property blank_lines_to_end: SmallInt read Fblank_lines_to_end write Fblank_lines_to_end;
    property flg_port_control: SmallInt read Fflg_port_control write Fflg_port_control;
    property flg_translate_tags: SmallInt read Fflg_translate_tags write Fflg_translate_tags;
    property flg_ignore_tags: SmallInt read Fflg_ignore_tags write Fflg_ignore_tags;
    property flg_paper_cut: SmallInt read Fflg_paper_cut write Fflg_paper_cut;
    property flg_partial_paper_cut: SmallInt read Fflg_partial_paper_cut write Fflg_partial_paper_cut;
    property flg_send_cut_written_command: SmallInt read Fflg_send_cut_written_command write Fflg_send_cut_written_command;
    property page_code: TPosPrinterPageCode read Fpage_code write Fpage_code;
    property created_at: TDateTime read Fcreated_at write Fcreated_at;
    property updated_at: TDateTime read Fupdated_at write Fupdated_at;
    property created_by_acl_user_id: Int64 read Fcreated_by_acl_user_id write Fcreated_by_acl_user_id;
    property updated_by_acl_user_id: Int64 read Fupdated_by_acl_user_id write Fupdated_by_acl_user_id;

    // OneToOne
    property created_by_acl_user: TAclUser read Fcreated_by_acl_user write Fcreated_by_acl_user;
    property updated_by_acl_user: TAclUser read Fupdated_by_acl_user write Fupdated_by_acl_user;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uApplication.Exception, uTrans;

{ TPosPrinter }

constructor TPosPrinter.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TPosPrinter.Destroy;
begin
  if Assigned(Fcreated_by_acl_user) then Fcreated_by_acl_user.Free;
  if Assigned(Fupdated_by_acl_user) then Fupdated_by_acl_user.Free;
  inherited;
end;

procedure TPosPrinter.Initialize;
begin
  Fcreated_at          := now;
  Fcreated_by_acl_user := TAclUser.Create;
  Fupdated_by_acl_user := TAclUser.Create;
end;

function TPosPrinter.Validate: String;
var
  lIsInserting: Boolean;
begin
  Result := EmptyStr;
  lIsInserting := Fid = 0;

  if Fname.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;

  if Fport.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Porta') + #13;
end;

end.

