unit uPosPrinter.SQLBuilder.MySQL;

interface

uses
  uPosPrinter.SQLBuilder.Interfaces,
  uFilter,
  uSelectWithFilter,
  uPosPrinter.Filter,
  uBase.Entity;

type
  TPosPrinterSQLBuilderMySQL = class(TInterfacedObject, IPosPrinterSQLBuilder)
  public
    class function Make: IPosPrinterSQLBuilder;

    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
    function SelectAll: String;
    function SelectById(AId: Int64): String;
    function Insert(AEntity: TBaseEntity): String;
    function LastInsertId: String;
    function DeleteById(AId: Int64): String;
    function DeleteByIdRange(AId: String): String;
    function Update(AId: Int64; AEntity: TBaseEntity): String;
  end;

implementation

uses
  uZLConnection.Types,
  System.SysUtils,
  uPosPrinter,
  uAppRest.Types,
  uQuotedStr,
  uHlp,
  uAclUser.Show.DTO,
  XSuperObject;

{ TPosPrinterSQLBuilderMySQL }

function TPosPrinterSQLBuilderMySQL.DeleteById(AId: Int64): String;
begin
  const LSQL = 'DELETE FROM pos_printer WHERE pos_printer.id = %s';
  Result := Format(LSQL, [
    Q(AId.ToString)
  ]);
end;

function TPosPrinterSQLBuilderMySQL.DeleteByIdRange(AId: String): String;
begin
  const LSQL = 'DELETE FROM pos_printer WHERE id in (%s)';
  Result := Format(LSQL, [AId]);
end;

function TPosPrinterSQLBuilderMySQL.Insert(AEntity: TBaseEntity): String;
begin
  const LSQL = ' INSERT INTO pos_printer '+
               '   (name, model, port, columns, space_between_lines, buffer, font_size, blank_lines_to_end, '+
               '    flg_port_control, flg_translate_tags, flg_ignore_tags, flg_paper_cut, flg_partial_paper_cut, '+
               '    flg_send_cut_written_command, page_code, created_at, created_by_acl_user_id) '+
               ' VALUES '+
               '   (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)';
  const LPosPrinter = AEntity as TPosPrinter;
  Result := Format(LSQL, [
    Q(LPosPrinter.name),
    Q(Ord(LPosPrinter.model)),
    Q(LPosPrinter.port),
    Q(LPosPrinter.columns),
    Q(LPosPrinter.space_between_lines),
    Q(LPosPrinter.buffer),
    Q(LPosPrinter.font_size),
    Q(LPosPrinter.blank_lines_to_end),
    Q(LPosPrinter.flg_port_control),
    Q(LPosPrinter.flg_translate_tags),
    Q(LPosPrinter.flg_ignore_tags),
    Q(LPosPrinter.flg_paper_cut),
    Q(LPosPrinter.flg_partial_paper_cut),
    Q(LPosPrinter.flg_send_cut_written_command),
    Q(Ord(LPosPrinter.page_code)),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LPosPrinter.created_by_acl_user_id)
  ]);
end;

function TPosPrinterSQLBuilderMySQL.LastInsertId: String;
begin
  Result := SELECT_LAST_INSERT_ID_MYSQL;
end;

class function TPosPrinterSQLBuilderMySQL.Make: IPosPrinterSQLBuilder;
begin
  Result := Self.Create;
end;

function TPosPrinterSQLBuilderMySQL.SelectAll: String;
begin
  Result :=  ' SELECT '+
             '   pos_printer.*, '+
             '   created_by_acl_user.name as created_by_acl_user_name, '+
             '   updated_by_acl_user.name as updated_by_acl_user_name  '+
             ' FROM '+
             '   pos_printer '+
             ' LEFT JOIN acl_user created_by_acl_user '+
             '        ON created_by_acl_user.id = pos_printer.created_by_acl_user_id '+
             ' LEFT JOIN acl_user updated_by_acl_user '+
             '        ON updated_by_acl_user.id = pos_printer.updated_by_acl_user_id ';
end;

function TPosPrinterSQLBuilderMySQL.SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
begin
  Result := TSelectWithFilter.SelectAllWithFilter(AFilter, SelectAll, 'pos_printer.id', ddMySql);
end;

function TPosPrinterSQLBuilderMySQL.SelectById(AId: Int64): String;
begin
  Result := SelectAll + ' WHERE pos_printer.id = ' + AId.ToString;
end;

function TPosPrinterSQLBuilderMySQL.Update(AId: Int64; AEntity: TBaseEntity): String;
begin
  const LSQL = ' UPDATE pos_printer SET '+
               '   name = %s, '+
               '   model = %s, '+
               '   port = %s, '+
               '   columns = %s, '+
               '   space_between_lines = %s, '+
               '   buffer = %s, '+
               '   font_size = %s, '+
               '   blank_lines_to_end = %s, '+
               '   flg_port_control = %s, '+
               '   flg_translate_tags = %s, '+
               '   flg_ignore_tags = %s, '+
               '   flg_paper_cut = %s, '+
               '   flg_partial_paper_cut = %s, '+
               '   flg_send_cut_written_command = %s, '+
               '   page_code = %s, '+
               '   updated_at = %s, '+
               '   updated_by_acl_user_id = %s '+
               ' WHERE '+
               '   id = %s ';
  const LPosPrinter = AEntity as TPosPrinter;
  Result := Format(LSQL, [
    Q(LPosPrinter.name),
    Q(Ord(LPosPrinter.model)),
    Q(LPosPrinter.port),
    Q(LPosPrinter.columns),
    Q(LPosPrinter.space_between_lines),
    Q(LPosPrinter.buffer),
    Q(LPosPrinter.font_size),
    Q(LPosPrinter.blank_lines_to_end),
    Q(LPosPrinter.flg_port_control),
    Q(LPosPrinter.flg_translate_tags),
    Q(LPosPrinter.flg_ignore_tags),
    Q(LPosPrinter.flg_paper_cut),
    Q(LPosPrinter.flg_partial_paper_cut),
    Q(LPosPrinter.flg_send_cut_written_command),
    Q(Ord(LPosPrinter.page_code)),
    Q(Now(), TDBDriver.dbMYSQL),
    Q(LPosPrinter.updated_by_acl_user_id),
    Q(AId)
  ]);
end;

end.
