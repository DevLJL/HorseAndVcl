unit uConsumptionMap.View;

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
  Vcl.Imaging.pngimage,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  JvExStdCtrls,
  JvEdit,
  JvValidateEdit,
  Data.DB,
  Vcl.Grids,
  Vcl.DBGrids,
  JvExDBGrids,
  Skia,
  Skia.Vcl,
  Vcl.Menus,
  JvMenus,
  Vcl.DBCtrls,
  Vcl.DBCGrids,
  Vcl.NumberBox,
  uIndexResult,
  uZLMemTable.Interfaces;

type
  {$SCOPEDENUMS ON}
  TConsumptionSaleAction = (None, New, Edit, Closure);
  TCurrentConsumptionSale = Record
    number: SmallInt;
    sale_id: Int64;
    action: TConsumptionSaleAction;
  end;

  TConsumptionMapView = class(TForm)
    pnlBackground: TPanel;
    pnlBackground2: TPanel;
    pnlTitle: TPanel;
    lblTitle: TLabel;
    imgCloseTitle: TImage;
    imgTitle: TImage;
    Panel8: TPanel;
    Panel1: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    imgLocateConsumptionNumber: TImage;
    Panel5: TPanel;
    imgsale_item_loca_product: TImage;
    Panel7: TPanel;
    edtConsumptionNumber: TNumberBox;
    Panel2: TPanel;
    Panel3: TPanel;
    dtsIndex: TDataSource;
    pnlDbgrid: TPanel;
    lblNoSearch: TLabel;
    imgNoSearch2: TImage;
    imgNoSearch: TSkAnimatedImage;
    pnlConsumptionAll: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    pnlConsumptionSaleAll: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    pnlConsumptionSaleFree: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    pnlConsumptionSaleBusy: TPanel;
    Panel20: TPanel;
    Panel21: TPanel;
    Panel22: TPanel;
    pnlConsumptionSalePreAccount: TPanel;
    ppmOptions: TPopupMenu;
    mniRegistros1: TMenuItem;
    EmitirPrConta1: TMenuItem;
    mniCloseConsumption: TMenuItem;
    DBCtrlGrid1: TDBCtrlGrid;
    pnlCard: TPanel;
    pnlCardTitle: TPanel;
    pnlCardContent: TPanel;
    lblCardTitle: TDBText;
    imgSaleAmountOfPeople: TImage;
    lblSaleAmountOfPeople: TDBText;
    lblSaleTotal: TDBText;
    imgCardOption: TImage;
    Panel11: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure imgCloseTitleClick(Sender: TObject);
    procedure pnlCardClick(Sender: TObject);
    procedure edtConsumptionNumberKeyPress(Sender: TObject; var Key: Char);
    procedure imgLocateConsumptionNumberClick(Sender: TObject);
    procedure DBCtrlGrid1PaintPanel(DBCtrlGrid: TDBCtrlGrid; Index: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure edtConsumptionNumberChange(Sender: TObject);
    procedure imgCardOptionClick(Sender: TObject);
    procedure mniCloseConsumptionClick(Sender: TObject);
  private
    FResultNumber: SmallInt;
    FResultSaleId: Int64;
    FResultAction: TConsumptionSaleAction;
    FLoadingSearch: Boolean;
    FIndexResult: IZLMemTable;
    procedure DoSearch(ATryLocateConsumptionNumber: Int64 = 0);
    procedure SetLoadingSearch(const Value: Boolean);
    property LoadingSearch: Boolean read FLoadingSearch write SetLoadingSearch;
  public
    class function HandleLocate: TCurrentConsumptionSale;
  end;

var
  ConsumptionMapView: TConsumptionMapView;

implementation

{$R *.dfm}

uses
  uSmartPointer,
  uHlp,
  Quick.Threads,
  uApplicationError.View,
  uConsumption.Service,
  uEither, uConsumptionSale.Filter.DTO, uAlert.View;

{ TConsumptionMapView }

procedure TConsumptionMapView.DBCtrlGrid1PaintPanel(DBCtrlGrid: TDBCtrlGrid; Index: Integer);
begin
  const LKeepGoing = Assigned(dtsIndex.DataSet) and (dtsIndex.DataSet.Active) and (dtsIndex.DataSet.RecordCount > 0) and (LoadingSearch = False);
  if not LKeepGoing then
  begin
    if pnlCard.Visible then
      pnlCard.Visible := False;
    Exit;
  end;

  // Configurar layout do card
  if not pnlCard.Visible then
    pnlCard.Visible := True;
  imgSaleAmountOfPeople.Visible := dtsIndex.DataSet.FieldByName('sale_amount_of_people').AsLargeInt > 0;
  lblSaleAmountOfPeople.Visible := dtsIndex.DataSet.FieldByName('sale_amount_of_people').AsLargeInt > 0;
  lblSaleTotal.Visible          := dtsIndex.DataSet.FieldByName('sale_total').AsFloat > 0;
  imgCardOption.Visible         := dtsIndex.DataSet.FieldByName('sale_id').AsLargeInt > 0;

  // Livre
  if (dtsIndex.DataSet.FieldByName('sale_id').AsLargeInt <= 0) then
  begin
    pnlCard.Color              := $00D8F2C8;
    pnlCardTitle.Color         := $00D8F2C8;
    lblCardTitle.Font.Color    := $004F8A26;
    pnlCardContent.Color       := $00EDF9E6;
  end;

  // Ocupada
  if (dtsIndex.DataSet.FieldByName('sale_id').AsLargeInt > 0) and
     (dtsIndex.DataSet.FieldByName('sale_flg_payment_requested').AsInteger <= 0) then
  begin
    pnlCard.Color             := $00E6E1D5;
    pnlCardTitle.Color        := $00E6E1D5;
    lblCardTitle.Font.Color   := $00857950;
    pnlCardContent.Color      := $00F3F1EB;
  end;

  // Pré-Conta
  if (dtsIndex.DataSet.FieldByName('sale_id').AsLargeInt > 0) and
     (dtsIndex.DataSet.FieldByName('sale_flg_payment_requested').AsInteger = 1) then
  begin
    pnlCard.Color             := $00BBF4FF;
    pnlCardTitle.Color        := $00BBF4FF;
    lblCardTitle.Font.Color   := $0000ACCA;
    pnlCardContent.Color      := $00DFFBFF;
  end;
end;

procedure TConsumptionMapView.DoSearch(ATryLocateConsumptionNumber: Int64);
var
  LIndexResult: Either<String, IZLMemTable>;
begin
  // Evitar erro
  if LoadingSearch then
    Exit;

  // Iniciar Loading
  LoadingSearch          := True;
  pnlBackground.Enabled  := False;
  DBCtrlGrid1.DataSource := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      LIndexResult := TConsumptionService.Make.IndexWithSale(Nil);
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

        DBCtrlGrid1.DataSource  := dtsIndex;
        dtsIndex.DataSet        := FIndexResult.DataSet;
        if (ATryLocateConsumptionNumber > 0) then
          dtsIndex.DataSet.Locate('number', VarArrayOf([ATryLocateConsumptionNumber]), []);
      finally
        // Encerrar Loading
        pnlBackground.Enabled := True;
        LoadingSearch         := False;
        if edtConsumptionNumber.CanFocus then
          edtConsumptionNumber.SetFocus;
      end;
    end)
  .Run;
end;

procedure TConsumptionMapView.edtConsumptionNumberChange(Sender: TObject);
begin
  if edtConsumptionNumber.Value = 0 then
    edtConsumptionNumber.Text := EmptyStr;
end;

procedure TConsumptionMapView.edtConsumptionNumberKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (key = #13) then
    imgLocateConsumptionNumberClick(imgLocateConsumptionNumber);
end;

procedure TConsumptionMapView.FormCreate(Sender: TObject);
begin
  CreateDarkBackground(Self);
  edtConsumptionNumber.Alignment := taCenter;
  edtConsumptionNumber.Text      := EmptyStr;
  FitFormToScreen(Self);
  DoSearch;
end;

procedure TConsumptionMapView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Esc - Sair
  if (Key = VK_ESCAPE) then
  begin
    imgCloseTitleClick(imgCloseTitle);
    Exit;
  end;
end;

procedure TConsumptionMapView.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if not DBCtrlGrid1.ClientRect.Contains(DBCtrlGrid1.ScreenToClient(MousePos)) then Exit;
  if not Assigned(DBCtrlGrid1.DataSource)   then Exit;
  if (DBCtrlGrid1.DataSource.DataSet = nil) then Exit;

  Try
    DBCtrlGrid1.DataSource.DataSet.DisableControls;

    case (WheelDelta > 0) of
      True: Begin
        for var LI := 0 to (DBCtrlGrid1.ColCount*DBCtrlGrid1.RowCount) do
          DBCtrlGrid1.DataSource.DataSet.Prior;
      End;
      False: Begin
        for var LI := 0 to (DBCtrlGrid1.ColCount*DBCtrlGrid1.RowCount) do
          DBCtrlGrid1.DataSource.DataSet.Next;
      End;
    end;
  Finally
    DBCtrlGrid1.DataSource.DataSet.EnableControls;
  End;

  Handled := True;
end;

class function TConsumptionMapView.HandleLocate: TCurrentConsumptionSale;
begin
  const LView: SH<TConsumptionMapView> = TConsumptionMapView.Create(nil);
  if not (LView.Value.ShowModal = mrOK) then
  begin
    Result.number  := -1;
    Result.sale_id := -1;
    Result.action  := TConsumptionSaleAction.None;
    Exit;
  end;

  Result.number  := LView.Value.FResultNumber;
  Result.sale_id := LView.Value.FResultSaleId;
  Result.action  := LView.Value.FResultAction;
end;


procedure TConsumptionMapView.imgCardOptionClick(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsIndex.DataSet) and dtsIndex.DataSet.Active and (dtsIndex.DataSet.RecordCount > 0) and (LoadingSearch = False);
  if not LKeepGoing then
    Exit;

  ppmOptions.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

procedure TConsumptionMapView.imgCloseTitleClick(Sender: TObject);
begin
  ModalResult := MrCancel;
end;

procedure TConsumptionMapView.imgLocateConsumptionNumberClick(Sender: TObject);
var
  LMemTable: IZLMemTable;
begin
  const LKeepGoing = (edtConsumptionNumber.ValueInt > 0) and Assigned(dtsIndex.DataSet) and
                (dtsIndex.DataSet.Active);
  if not LKeepGoing then
    Exit;

  try
    LockControl(pnlBackground);

    // Localizar Ficha de Consumo
    const LFilter: SH<TConsumptionSaleFilterDTO> = TConsumptionSaleFilterDTO.Create;
    LFilter.Value.number := edtConsumptionNumber.ValueInt;
    const LEitherResult = TConsumptionService.Make.IndexWithSale(LFilter);
    case LEitherResult.Match of
      False: raise Exception.Create(LEitherResult.Left);
      True:  LMemTable := LEitherResult.Right;
    end;
    if LMemTable.IsEmpty then
    begin
      TAlertView.Handle(Format('Ficha de consumo: "%s" não encontrada.',[edtConsumptionNumber.Text]));
      Exit;
    end;

    // Carregar campos e retornar
    FResultNumber := LMemTable.FieldByName('number').AsLargeInt;
    FResultSaleId := LMemTable.FieldByName('sale_id').AsLargeInt;
    case (FResultSaleId <= 0) of
      True:  FResultAction := TConsumptionSaleAction.New;
      False: FResultAction := TConsumptionSaleAction.Edit;
    end;

    ModalResult := mrOK;
  finally
    UnLockControl(pnlBackground);
  end;
end;

procedure TConsumptionMapView.mniCloseConsumptionClick(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsIndex.DataSet) and (dtsIndex.DataSet.Active);
  if not LKeepGoing then
    Exit;

  // Carregar campos e retornar
  FResultNumber := dtsIndex.DataSet.FieldByName('number').AsLargeInt;
  FResultSaleId := dtsIndex.DataSet.FieldByName('sale_id').AsLargeInt;
  FResultAction := TConsumptionSaleAction.Closure;

  ModalResult := mrOK;
end;

procedure TConsumptionMapView.pnlCardClick(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsIndex.DataSet) and dtsIndex.DataSet.Active and (dtsIndex.DataSet.RecordCount > 0) and (LoadingSearch = False);
  if not LKeepGoing then
    Exit;

  var LKey: Char := #13;
  edtConsumptionNumber.Text := dtsIndex.DataSet.FieldByName('number').AsString;
  edtConsumptionNumberKeyPress(Sender, LKEY);
end;

procedure TConsumptionMapView.SetLoadingSearch(const Value: Boolean);
begin
  FLoadingSearch := Value;

  case FLoadingSearch of
    True: Begin
      imgNoSearch.Enabled := True;
      Screen.Cursor       := crHourGlass;
      DBCtrlGrid1.Visible := False;
    end;
    False: Begin
      imgNoSearch.Enabled := False;
      Screen.Cursor       := crDefault;
      DBCtrlGrid1.Visible := True;
    End;
  end;
end;

end.
