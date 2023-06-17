unit uPosPrinter.Input.DTO;

interface

uses
  uBase.DTO,
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  XSuperObject,
  uSmartPointer,
  uPosPrinter.Types;

type
  TPosPrinterInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Facl_user_id: Int64;
    Fbuffer: SmallInt;
    Fflg_port_control: SmallInt;
    Fflg_translate_tags: SmallInt;
    Fflg_partial_paper_cut: SmallInt;
    Fblank_lines_to_end: SmallInt;
    Fflg_paper_cut: SmallInt;
    Fflg_ignore_tags: SmallInt;
    Fmodel: TPosPrinterModel;
    Fcolumns: SmallInt;
    Fport: String;
    Fspace_between_lines: SmallInt;
    Fflg_send_cut_written_command: SmallInt;
    Fpage_code: TPosPrinterPageCode;
    Ffont_size: SmallInt;
  public
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TPosPrinterInputDTO;
    {$ENDIF}

    [SwagString(100)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;

    [SwagNumber(0,15)]
    [SwagProp('model', 'Modelo', true)]
    property model: TPosPrinterModel read Fmodel write Fmodel;

    [SwagString(100)]
    [SwagProp('port', 'Porta', true)]
    property port: String read Fport write Fport;

    [SwagNumber(20,48)]
    [SwagProp('columns', 'Colunas', true)]
    property columns: SmallInt read Fcolumns write Fcolumns;

    [SwagNumber]
    [SwagProp('space_between_lines', 'Espaço entre linhas', false)]
    property space_between_lines: SmallInt read Fspace_between_lines write Fspace_between_lines;

    [SwagNumber]
    [SwagProp('buffer', 'Buffer', false)]
    property buffer: SmallInt read Fbuffer write Fbuffer;

    [SwagNumber]
    [SwagProp('font_size', 'Tamanho da Fonte', false)]
    property font_size: SmallInt read Ffont_size write Ffont_size;

    [SwagNumber]
    [SwagProp('blank_lines_to_end', 'Linhas em branco no final', false)]
    property blank_lines_to_end: SmallInt read Fblank_lines_to_end write Fblank_lines_to_end;

    [SwagNumber(0,1)]
    [SwagProp('flg_port_control', 'Controle de Porta', false)]
    property flg_port_control: SmallInt read Fflg_port_control write Fflg_port_control;

    [SwagNumber(0,1)]
    [SwagProp('flg_translate_tags', 'Traduzir Tags', false)]
    property flg_translate_tags: SmallInt read Fflg_translate_tags write Fflg_translate_tags;

    [SwagNumber(0,1)]
    [SwagProp('flg_ignore_tags', 'Ignorar Tags', false)]
    property flg_ignore_tags: SmallInt read Fflg_ignore_tags write Fflg_ignore_tags;

    [SwagNumber(0,1)]
    [SwagProp('flg_paper_cut', 'Cortar Papel', false)]
    property flg_paper_cut: SmallInt read Fflg_paper_cut write Fflg_paper_cut;

    [SwagNumber(0,1)]
    [SwagProp('flg_partial_paper_cut', 'Cortar Papel Parcial', false)]
    property flg_partial_paper_cut: SmallInt read Fflg_partial_paper_cut write Fflg_partial_paper_cut;

    [SwagNumber(0,1)]
    [SwagProp('flg_send_cut_written_command', 'Cortar papel por envio de comando', false)]
    property flg_send_cut_written_command: SmallInt read Fflg_send_cut_written_command write Fflg_send_cut_written_command;

    [SwagNumber(0,6)]
    [SwagProp('page_code', 'Código de Página', false)]
    property page_code: TPosPrinterPageCode read Fpage_code write Fpage_code;

    [SwagIgnore]
    [DISABLE]
    property acl_user_id: Int64 read Facl_user_id write Facl_user_id;
  end;

implementation

uses
  System.SysUtils,
  {$IFDEF APPREST}
  uMyClaims,
  {$ENDIF}
  uHlp;

{ TPosPrinterInputDTO }

{$IFDEF APPREST}
class function TPosPrinterInputDTO.FromReq(AReq: THorseRequest): TPosPrinterInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TPosPrinterInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := AReq.Session<TMyClaims>.IdToInt64;
end;
{$ENDIF}

end.

