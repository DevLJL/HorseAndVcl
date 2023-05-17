unit uMain.Vcl.View;

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
  Vcl.ExtCtrls,
  Vcl.Menus,
  System.Actions,
  Vcl.ActnList,
  Vcl.Imaging.jpeg,
  Vcl.ComCtrls,
  JvExControls,
  JvXPCore,
  JvXPBar,
  Vcl.Buttons,
  Vcl.WinXCtrls,
  Vcl.StdCtrls,
  Vcl.Imaging.pngimage,
  uSmartPointer;

type
  TMainVclView = class(TForm)
    btnFocus: TButton;
    pnlBackground: TPanel;
    pnlTopBar: TPanel;
    imgShowOrHideSideBar: TImage;
    Image1: TImage;
    Image4: TImage;
    lblDate: TLabel;
    lblNameOfTheWeek: TLabel;
    lblCompanyAliasName: TLabel;
    imgDadosEmpLogo: TImage;
    lblCompanyEin: TLabel;
    imgNetConnected: TImage;
    imgNetDisconnected: TImage;
    SplitView1: TSplitView;
    Panel7: TPanel;
    Image8: TImage;
    lblUserLoggedLogin: TLabel;
    Image9: TImage;
    lblStationNumber: TLabel;
    Image10: TImage;
    lblPcName: TLabel;
    btnPerfil: TSpeedButton;
    btnAclUser: TSpeedButton;
    btnLogoff: TSpeedButton;
    ScrollBox1: TScrollBox;
    XPBarStock: TJvXPBar;
    imgCatalago: TImage;
    menuFinanceiro: TJvXPBar;
    imgFinanceiro: TImage;
    menuFavoritos: TJvXPBar;
    imgFavoritos: TImage;
    imgFavoritosAjustar: TImage;
    menuCompras: TJvXPBar;
    imgCompras: TImage;
    menuVendas: TJvXPBar;
    imgVendas: TImage;
    menuRelatorios: TJvXPBar;
    imgRelatorios: TImage;
    menuFiscal: TJvXPBar;
    Image3: TImage;
    XPBarConfiguration: TJvXPBar;
    imgConfiguracoes: TImage;
    Panel1: TPanel;
    pnlBody: TPanel;
    pgcActiveForms: TPageControl;
    TabSheet1: TTabSheet;
    pnlDashboard: TPanel;
    imgPrinc: TImage;
    btnCloseTabSheet: TButton;
    ActionList1: TActionList;
    actClose: TAction;
    actPerson: TAction;
    actCity: TAction;
    actBrand: TAction;
    actCategory: TAction;
    actSize: TAction;
    actStorageLocation: TAction;
    actUnid: TAction;
    actProduct: TAction;
    actBank: TAction;
    actCostCenter: TAction;
    actBankAccount: TAction;
    actChartOfAccount: TAction;
    actPayment: TAction;
    actBillPayReceive: TAction;
    actNCM: TAction;
    actBusinessProposal: TAction;
    actSale: TAction;
    actMyCompany: TAction;
    actPosPrinter: TAction;
    actAppParamConfig: TAction;
    actAppParamConfigSat: TAction;
    actOperationType: TAction;
    actCFOP: TAction;
    actTaxRule: TAction;
    actPdv: TAction;
    actConsumption: TAction;
    actCashFlow: TAction;
    PopupMenu1: TPopupMenu;
    Abas1: TMenuItem;
    mniCloseCurrentTab: TMenuItem;
    mniCloseOthersTab: TMenuItem;
    mniCloseAllTabs: TMenuItem;
    tmrCheckInternet: TTimer;
    actStation: TAction;
    procedure FormShow(Sender: TObject);
    procedure tmrCheckInternetTimer(Sender: TObject);
    procedure actBrandExecute(Sender: TObject);
    procedure XPBarClick(Sender: TObject);
    procedure pgcActiveFormsMouseEnter(Sender: TObject);
    procedure pgcActiveFormsMouseLeave(Sender: TObject);
    procedure pgcActiveFormsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnCloseTabSheetClick(Sender: TObject);
    procedure mniCloseCurrentTabClick(Sender: TObject);
    procedure mniCloseOthersTabClick(Sender: TObject);
    procedure mniCloseAllTabsClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure imgDadosEmpLogoClick(Sender: TObject);
    procedure actCityExecute(Sender: TObject);
    procedure actPersonExecute(Sender: TObject);
    procedure actCategoryExecute(Sender: TObject);
    procedure actNCMExecute(Sender: TObject);
    procedure actSizeExecute(Sender: TObject);
    procedure actStorageLocationExecute(Sender: TObject);
    procedure actUnidExecute(Sender: TObject);
    procedure actProductExecute(Sender: TObject);
    procedure actMyCompanyExecute(Sender: TObject);
    procedure actConsumptionExecute(Sender: TObject);
    procedure actStationExecute(Sender: TObject);
    procedure actBankExecute(Sender: TObject);
    procedure actBankAccountExecute(Sender: TObject);
    procedure actChartOfAccountExecute(Sender: TObject);
    procedure actCostCenterExecute(Sender: TObject);
    procedure actPaymentExecute(Sender: TObject);
    procedure actCashFlowExecute(Sender: TObject);
    procedure actBillPayReceiveExecute(Sender: TObject);
    procedure actSaleExecute(Sender: TObject);
  private
    FTabSheetTag: Integer;
    FNetConnectedLog: ISH<TStringList>;
    FIsNetConnected: Boolean;
    procedure LoadUserLoggedOnMainScreen;
    procedure SetIsNetConnected(const Value: Boolean);
    function  ShowForm(const AFrmClass: TComponentClass; ACaption: String): TForm;
    procedure ShowTabCloseButtonOnHotTab;
  public
    property IsNetConnected: Boolean read FIsNetConnected write SetIsNetConnected;
  end;

var
  MainVclView: TMainVclView;

implementation

{$R *.dfm}

uses
  uLogin.View,
  uHlp,
  System.Threading,
  uNotificationView,
  uBrand.Index.View,
  uCity.Index.View,
  uPerson.Index.View,
  uCategory.Index.View,
  uNcm.Index.View,
  uSize.Index.View,
  uStorageLocation.Index.View,
  uUnit.Index.View,
  uProduct.Index.View,
  uCompany.Show.DTO,
  uCompany.Input.View,
  uAppVcl.Types,
  uConsumption.Index.View,
  uStation.Index.View,
  uBank.Index.View,
  uBankAccount.Index.View,
  uChartOfAccount.Index.View,
  uCostCenter.Index.View,
  uPayment.Index.View,
  uCashFlow.Index.View,
  uBillPayReceive.Index.View,
  uSale.Index.View;

procedure TMainVclView.actBankAccountExecute(Sender: TObject);
begin
  ShowForm(TBankAccountIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actBankExecute(Sender: TObject);
begin
  ShowForm(TBankIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actBillPayReceiveExecute(Sender: TObject);
begin
  ShowForm(TBillPayReceiveIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actBrandExecute(Sender: TObject);
begin
  ShowForm(TBrandIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actCashFlowExecute(Sender: TObject);
begin
  ShowForm(TCashFlowIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actCategoryExecute(Sender: TObject);
begin
  ShowForm(TCategoryIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actChartOfAccountExecute(Sender: TObject);
begin
  ShowForm(TChartOfAccountIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actCityExecute(Sender: TObject);
begin
  ShowForm(TCityIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actConsumptionExecute(Sender: TObject);
begin
  ShowForm(TConsumptionIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actCostCenterExecute(Sender: TObject);
begin
  ShowForm(TCostCenterIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actMyCompanyExecute(Sender: TObject);
begin
  // Minha Empresa
  const LUpdated: SH<TCompanyShowDTO> = TCompanyInputView.Handle(TEntityState.Update, 1);
  if not Assigned(LUpdated.Value) then
    Exit;
end;

procedure TMainVclView.actNCMExecute(Sender: TObject);
begin
  ShowForm(TNcmIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actPaymentExecute(Sender: TObject);
begin
  ShowForm(TPaymentIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actPersonExecute(Sender: TObject);
begin
  ShowForm(TPersonIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actProductExecute(Sender: TObject);
begin
  ShowForm(TProductIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actSaleExecute(Sender: TObject);
begin
  ShowForm(TSaleIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actSizeExecute(Sender: TObject);
begin
  ShowForm(TSizeIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actStationExecute(Sender: TObject);
begin
  ShowForm(TStationIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actStorageLocationExecute(Sender: TObject);
begin
  ShowForm(TStorageLocationIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.actUnidExecute(Sender: TObject);
begin
  ShowForm(TUnitIndexView, TAction(Sender).Caption);
end;

procedure TMainVclView.btnCloseTabSheetClick(Sender: TObject);
begin
  // Não permitir operação com Home
  if String(pgcActiveForms.Pages[btnCloseTabSheet.Tag].Caption).Trim.ToLower = 'home' then Exit;

  pgcActiveForms.Pages[btnCloseTabSheet.Tag].Free;
  pgcActiveForms.ActivePageIndex := Pred(btnCloseTabSheet.Tag);
  ShowTabCloseButtonOnHotTab;
end;

procedure TMainVclView.FormShow(Sender: TObject);
begin
  // Efetuar Login
  const LLoginView: SH<TLoginView> = TLoginView.Create(nil);
  if not (LLoginView.Value.ShowModal = mrOK) then
  begin
    Application.Terminate;
    Exit;
  end;

  // Carregar dados do usuário logado
  LoadUserLoggedOnMainScreen;

  // Preparar Tela
  WindowState              := TWindowState.wsMaximized;
  pgcActiveForms.Align     := alClient;
  imgNetConnected.Width    := 0;
  imgNetDisconnected.Width := 0;
  FNetConnectedLog         := SH<TStringList>.Make;
  tmrCheckInternet.Enabled := True;
  tmrCheckInternetTimer(tmrCheckInternet);
end;

procedure TMainVclView.imgDadosEmpLogoClick(Sender: TObject);
begin
  {$IFDEF APPVCL}
    ShowMessage('APPVCL');
  {$ENDIF}
end;

function TMainVclView.ShowForm(const AFrmClass: TComponentClass; ACaption: String): TForm;
var
  lTabSheetShow: TTabSheet;
  lFormShow: TComponent;
  lI: Integer;
  lSourceStr, lTargetStr: String;
  lWindowWidth, lWindowHeight: Integer;
  lCloseMenu: Boolean;
  lJ: Integer;
begin
  Result := nil;

  lWindowWidth  := GetSystemMetrics(SM_CXSCREEN) - (GetSystemMetrics(SM_CXSCREEN) - GetSystemMetrics(SM_CXFULLSCREEN));
  lWindowHeight := GetSystemMetrics(SM_CYSCREEN) - (GetSystemMetrics(SM_CYSCREEN) - GetSystemMetrics(SM_CYFULLSCREEN)) + GetSystemMetrics(SM_CYCAPTION);
  lCloseMenu    := (lWindowWidth <= 1200) or (lWindowHeight <= 750);
  if lCloseMenu then
    SplitView1.Opened := False;

  // Se formulário já existir, apenas abre
  for lI := 0 to Pred(pgcActiveForms.PageCount) do
  Begin
    lSourceStr := String(pgcActiveForms.Pages[lI].Caption).Trim.ToLower;
    lTargetStr := ACaption.Trim.ToLower;

    if (lSourceStr = lTargetStr) then
    begin
      for lJ := 0 to Pred(pgcActiveForms.Pages[lI].ControlCount) do
      begin
        if (pgcActiveForms.Pages[lI].Controls[lJ] is TForm) then
        begin
          Result := TForm(pgcActiveForms.Pages[lI].Controls[lJ]);
          Break;
        end;
      end;
      pgcActiveForms.ActivePageIndex := lI;
      Exit;
    end;
  End;

  // Limite de abas abertas (10)
  if (pgcActiveForms.PageCount > 10) then
  begin
    NotificationView.Execute('Limite(10) de páginas foi atingido. Encerre alguma página e tente novamente.', tneError);
    Abort;
  end;

  // Se formulário não existir, cria aba para abrir
  lTabSheetShow             := TTabSheet.Create(pgcActiveForms);
  lTabSheetShow.Parent      := pgcActiveForms;
  lTabSheetShow.PageControl := pgcActiveForms;
  lTabSheetShow.Caption     := '     ' + ACaption + '     ';

  // Se formulário não existir, cria formulário e coloca na aba criada
  lFormShow := AFrmClass.Create(lTabSheetShow);
  TForm(lFormShow).Parent      := lTabSheetShow;
  TForm(lFormShow).Align       := alClient;
  TForm(lFormShow).BorderStyle := bsNone;
  TForm(lFormShow).Show;
  TForm(lFormShow).BringToFront;
  Result := TForm(lFormShow);
  pgcActiveForms.ActivePageIndex := Pred(pgcActiveForms.PageCount);
end;

procedure TMainVclView.LoadUserLoggedOnMainScreen;
begin
  lblCompanyAliasName.Caption := 'Nenhuma';
  lblCompanyEin.Caption       := '000.000.000-00';
  lblDate.Caption             := FormatDateTime('DD/MM', now);
  lblNameOfTheWeek.Caption    := DayOfWeekStr(now);
  //lblUserLoggedLogin.Caption  := Copy(LoggedInUser.Current.login,1,12);
  lblStationNumber.Caption    := '000';
  lblPcName.Caption           := Copy(getPcName,1,12);
end;

procedure TMainVclView.mniCloseAllTabsClick(Sender: TObject);
var
  lI: Integer;
begin
  Try
    // Evita bug de layoyt
    pgcActiveForms.Align  := alNone;
    pgcActiveForms.Height := 0;

    pgcActiveForms.Align  := alNone;
    for lI := Pred(pgcActiveForms.PageCount) downto 0 do
    begin
      // Não permitir operação com Home
      if String(pgcActiveForms.Pages[lI].Caption).Trim.ToLower <> 'home' then
        pgcActiveForms.Pages[lI].Free;
    end;
  Finally
    pgcActiveForms.Align  := alClient;
  End;
end;

procedure TMainVclView.mniCloseCurrentTabClick(Sender: TObject);
begin
  Try
    // Evita bug de layoyt
    pgcActiveForms.Align  := alNone;
    pgcActiveForms.Height := 0;

    // Não permitir operação com Home
    if String(pgcActiveForms.Pages[FTabSheetTag].Caption).Trim.ToLower = 'home' then Exit;

    pgcActiveForms.Pages[FTabSheetTag].Free;
    pgcActiveForms.ActivePageIndex := Pred(FTabSheetTag);
  Finally
    pgcActiveForms.Align  := alClient;
  End;
end;

procedure TMainVclView.mniCloseOthersTabClick(Sender: TObject);
var
  lI: Integer;
begin
  Try
    // Evita bug de layoyt
    pgcActiveForms.Align  := alNone;
    pgcActiveForms.Height := 0;

    for lI := Pred(pgcActiveForms.PageCount) downto 0 do
    begin
      if (FTabSheetTag <> lI) then
      Begin
        // Não permitir operação com Home
        if String(pgcActiveForms.Pages[lI].Caption).Trim.ToLower <> 'home' then
          pgcActiveForms.Pages[lI].Free;
      End;
    end;

    if (pgcActiveForms.PageCount > 0)        then pgcActiveForms.ActivePageIndex := 1;
    if (pgcActiveForms.ActivePageIndex = -1) then pgcActiveForms.ActivePageIndex := 0;
  Finally
    pgcActiveForms.Align  := alClient;
  End;
end;

procedure TMainVclView.pgcActiveFormsMouseEnter(Sender: TObject);
begin
  ShowTabCloseButtonOnHotTab;
end;

procedure TMainVclView.pgcActiveFormsMouseLeave(Sender: TObject);
begin
  if btnCloseTabSheet <> FindVCLWindow(Mouse.CursorPos) then
  begin
    btnCloseTabSheet.Hide;
    btnCloseTabSheet.Tag := -1;
  end;
end;

procedure TMainVclView.pgcActiveFormsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
{$WRITEABLECONST ON}
const oldPos : integer = -2;
{$WRITEABLECONST OFF}
var
  iot : integer;
  ctrl : TWinControl;
begin
  inherited;

  iot := TPageControl(Sender).IndexOfTabAt(x,y);

  if (iot > -1) then
  begin
    if iot <> oldPos then
      ShowTabCloseButtonOnHotTab;
  end;

  oldPos := iot;
end;

procedure TMainVclView.PopupMenu1Popup(Sender: TObject);
begin
  if (btnCloseTabSheet.Tag < 0) then Abort;
  FTabSheetTag := btnCloseTabSheet.Tag;
end;

procedure TMainVclView.SetIsNetConnected(const Value: Boolean);
begin
  FIsNetConnected := Value;

  case FIsNetConnected of
    True: Begin
      imgNetConnected.Width    := 40;
      imgNetDisconnected.Width :=  0;
    end;
    False: begin
      imgNetConnected.Width    :=  0;
      imgNetDisconnected.Width := 40;

      FNetConnectedLog.Add(DateTimeToStr(now()) + ' - Internet desconectada.');
    end;
  end;
end;

procedure TMainVclView.ShowTabCloseButtonOnHotTab;
var
  iot : integer;
  cp : TPoint;
  rectOver: TRect;
begin
  cp  := pgcActiveForms.ScreenToClient(Mouse.CursorPos);
  iot := pgcActiveForms.IndexOfTabAt(cp.X, cp.Y);

  if iot > -1 then
  begin
    rectOver := pgcActiveForms.TabRect(iot);

    btnCloseTabSheet.Left := rectOver.Right - btnCloseTabSheet.Width;
    btnCloseTabSheet.Top  := rectOver.Top + ((rectOver.Height div 2) - (btnCloseTabSheet.Height div 2));

    btnCloseTabSheet.Tag := iot;
    btnCloseTabSheet.Show;
  end
  else
  begin
    btnCloseTabSheet.Tag := -1;
    btnCloseTabSheet.Hide;
  end;
end;

procedure TMainVclView.tmrCheckInternetTimer(Sender: TObject);
var
  lIsConnected: Boolean;
begin
  TTask.Run(procedure
  begin
    lIsConnected := InternetIsConnected;

    TThread.Synchronize(TThread.CurrentThread, procedure
    begin
      IsNetConnected := lIsConnected;
    end)
  end);
end;

procedure TMainVclView.XPBarClick(Sender: TObject);
var
  lI: Integer;
begin
  // Fechar Todos
  if not Assigned(Sender) then
  begin
    for lI := 0 to Pred(ComponentCount) do
    if (Components[lI] is TJvXPBar) then
      TJvXPBar(Components[lI]).Collapsed := True;
    Exit;
  end;

  // Abrir selecionado e fechar os outros
  if TJvXPBar(Sender).Collapsed then
  Begin
    TJvXPBar(Sender).Collapsed  := False;
    for lI := 0 to Pred(ComponentCount) do
    if (Components[lI] is TJvXPBar) then
    if TJvXPBar(Components[lI]).Name <> TJvXPBar(Sender).Name then
      TJvXPBar(Components[lI]).Collapsed := True;
  End else
    TJvXPBar(Sender).Collapsed := True;
end;

end.
