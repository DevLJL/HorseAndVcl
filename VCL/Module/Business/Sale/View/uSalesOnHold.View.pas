unit uSalesOnHold.View;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Skia,
  Vcl.DBCGrids,
  Data.DB,
  Vcl.StdCtrls,
  Vcl.NumberBox,
  Skia.Vcl,
  Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  uIndexResult, Vcl.WinXCtrls;

type
  TSalesOnHoldView = class(TForm)
    pnlBackground: TPanel;
    pnlBackground2: TPanel;
    Panel8: TPanel;
    pnlTitle: TPanel;
    lblTitle: TLabel;
    imgCloseTitle: TImage;
    imgTitle: TImage;
    dtsIndex: TDataSource;
    pnlGrid: TPanel;
    pnlGrid2: TPanel;
    pnlDbgrid: TPanel;
    lblNoSearch: TLabel;
    imgNoSearch2: TImage;
    imgNoSearch: TSkAnimatedImage;
    DBGrid1: TDBGrid;
    pnlSearch: TPanel;
    pnlSearch4: TPanel;
    pnlSearch2: TPanel;
    lblSearch: TLabel;
    pnlSearch3: TPanel;
    Panel4: TPanel;
    imgSearchClear: TImage;
    pnlSearch5: TPanel;
    lblSearchTitle: TLabel;
    edtSearchValue: TEdit;
    pnlImgDoSearch: TPanel;
    imgDoSearch: TImage;
    tmrDoSearch: TTimer;
    procedure imgCloseTitleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure edtSearchValueKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure tmrDoSearchTimer(Sender: TObject);
    procedure edtSearchValueChange(Sender: TObject);
    procedure imgDoSearchClick(Sender: TObject);
    procedure imgSearchClearClick(Sender: TObject);
  private
    FResultSaleId: Int64;
    FLoadingSearch: Boolean;
    FIndexResult: IIndexResult;
    procedure SetLoadingSearch(const Value: Boolean);
    property LoadingSearch: Boolean read FLoadingSearch write SetLoadingSearch;
  public
    class function HandleLocate: Int64;
    procedure DoSearch(ATryLocateSaleCheckName: String = '');
  end;

implementation

{$R *.dfm}

uses
  uSmartPointer,
  uHlp,
  uEither,
  Quick.Threads,
  uSale.Service,
  uApplicationError.View,
  uSale.Filter.DTO, uSale.Types;

procedure TSalesOnHoldView.btnSelectClick(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsIndex.DataSet) and dtsIndex.DataSet.Active and (dtsIndex.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  FResultSaleId := dtsIndex.DataSet.FieldByName('id').AsLargeInt;
  ModalResult := MrOK;
end;

procedure TSalesOnHoldView.DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Bloquear Ctrl + Del
  if (ssCtrl in Shift) and (Key = VK_DELETE) then
    Key := 0;

  // Focus em pesquisa
  If (Shift = [ssShift]) and (key = VK_TAB) then
  Begin
    if edtSearchValue.CanFocus then
      edtSearchValue.SetFocus;
    Key := 0;
  End;

  // Quando Enter Pressionado Editar
  if (Key = VK_RETURN) Then
  Begin
    btnSelectClick(Sender);
    Key := 0;
  End;
end;

procedure TSalesOnHoldView.DoSearch(ATryLocateSaleCheckName: String);
var
  LIndexResult: Either<String, IIndexResult>;
  LFilter: SH<TSaleFilterDTO>;
begin
  // Evitar erro
  if LoadingSearch then
    Exit;

  // Iniciar Loading
  LoadingSearch      := True;
  pnlGrid.Enabled    := False;
  DBGrid1.DataSource := nil;

  // Filtro
  LFilter := TSaleFilterDTO.Create;
  With LFilter.Value do
  begin
    limit_per_page                 := 1000;
    order_by                       := 'sale.sale_check_id'; {Nº da Comanda}
    custom_search_for_sale_on_hold := '%'+edtSearchValue.Text+'%';
    &type                          := Ord(TSaleType.Normal).ToString;
    status                         := Ord(TSaleStatus.Pending).ToString;
  end;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      LIndexResult := TSaleService.Make.Index(LFilter);
    end)
  .OnException_Sync(
    procedure(ATask : ITask; AException : Exception)
    begin
      TApplicationErrorView.Handle(AException);
    end)
  .OnTerminated_Sync(
    procedure(ATask: ITask)
    begin
      Try
        // Verificar retorno da Task
        if ATask.Failed then Exit;
        case LIndexResult.Match of
          True:  FIndexResult := LIndexResult.Right;
          False: Begin
            TApplicationErrorView.Handle(LIndexResult.Left);
            Exit;
          End;
        end;

        DBGrid1.DataSource  := dtsIndex;
        dtsIndex.DataSet    := FIndexResult.Data.DataSet;
        if not ATryLocateSaleCheckName.Trim.IsEmpty then
          dtsIndex.DataSet.Locate('sale_check_name', VarArrayOf([ATryLocateSaleCheckName]), []);
      finally
        // Encerrar Loading
        pnlGrid.Enabled := True;
        LoadingSearch   := False;
        if edtSearchValue.CanFocus then
          edtSearchValue.SetFocus;
      end;
    end)
  .Run;
end;

procedure TSalesOnHoldView.edtSearchValueChange(Sender: TObject);
begin
  if tmrDoSearch.Enabled then
    tmrDoSearch.Enabled := False;
  tmrDoSearch.Enabled := True;
end;

procedure TSalesOnHoldView.edtSearchValueKeyPress(Sender: TObject;
  var Key: Char);
begin
  If (Key = #13) Then
  Begin
    if (tmrDoSearch.Enabled and (LoadingSearch = False)) then
    begin
      tmrDoSearch.Enabled := False;
      DoSearch;
    end;
if DBGrid1.CanFocus then DBGrid1.SetFocus;
    DBGrid1.SelectedIndex := 0;
    Exit;
  End;
end;

procedure TSalesOnHoldView.FormCreate(Sender: TObject);
begin
  CreateDarkBackground(Self);
  edtSearchValue.Text := EmptyStr;
  FitFormToScreen(Self);
  DoSearch;
end;

procedure TSalesOnHoldView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Esc - Fechar Modal
  if (Key = VK_ESCAPE) then
  begin
    imgCloseTitleClick(imgCloseTitle);
    Exit;
  end;
end;

procedure TSalesOnHoldView.FormShow(Sender: TObject);
begin
  if edtSearchValue.CanFocus then
    edtSearchValue.SetFocus;
end;

class function TSalesOnHoldView.HandleLocate: Int64;
begin
  const LView: SH<TSalesOnHoldView> = TSalesOnHoldView.Create(Nil);
  if not (LView.Value.ShowModal = MrOK) then
  Begin
    Result := 0;
    Exit;
  End;

  Result := LView.Value.FResultSaleId;
end;

procedure TSalesOnHoldView.imgCloseTitleClick(Sender: TObject);
begin
  ModalResult := MrCancel;
end;

procedure TSalesOnHoldView.imgDoSearchClick(Sender: TObject);
begin
  DoSearch;
end;

procedure TSalesOnHoldView.imgSearchClearClick(Sender: TObject);
begin
  edtSearchValue.Clear;
  DoSearch;
end;

procedure TSalesOnHoldView.SetLoadingSearch(const Value: Boolean);
begin
  FLoadingSearch := Value;

//  case FLoadingSearch of
//    True: Begin
//      imgNoSearch.Enabled := True;
//      Screen.Cursor       := crHourGlass;
//      DBGrid1.Visible := False;
//    end;
//    False: Begin
//      imgNoSearch.Enabled := False;
//      Screen.Cursor       := crDefault;
//      DBGrid1.Visible := True;
//    End;
//  end;
end;

procedure TSalesOnHoldView.tmrDoSearchTimer(Sender: TObject);
begin
  tmrDoSearch.Enabled := False;
  DoSearch;
end;

end.
