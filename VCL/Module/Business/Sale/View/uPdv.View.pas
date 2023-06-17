unit uPdv.View;

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
  Vcl.ComCtrls,
  JvExComCtrls,
  JvComCtrls,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  JvExControls,
  JvGradient,
  JvButton,
  JvTransparentButton,
  Data.DB,
  Vcl.Mask,
  Vcl.DBCtrls,
  Vcl.Imaging.pngimage,
  Vcl.Grids,
  Vcl.DBGrids,
  JvExDBGrids,
  JvExStdCtrls,
  JvEdit,
  JvValidateEdit,
  JvCombobox,
  Vcl.Buttons,
  Skia,
  Skia.Vcl,
  Vcl.DBCGrids,
  Vcl.NumberBox,
  uSale.ViewModel.Interfaces,
  uZLMemTable.Interfaces,
  uAppVcl.Types,
  uEnv.Vcl,
  uProduct.Index.View;

{$SCOPEDENUMS ON}
type
  TMainPage  = (Closed, Opened, Input, Loading);
  TInputPage = (Items, Payment);
  TMoveType  = (Normal, WithoutPayment);
  TPdvIndexView = class(TForm)
    pnlBackground: TPanel;
    nbkMain: TNotebook;
    pnlMainPage00Closed: TPanel;
    pnlMainPage01Opened: TPanel;
    pnlMainPage02Input: TPanel;
    Panel10: TPanel;
    JvGradient2: TJvGradient;
    Panel12: TPanel;
    Panel13: TPanel;
    btnOpenCashier: TJvTransparentButton;
    btnCloseModal: TJvTransparentButton;
    pnlAvailableContent: TPanel;
    JvGradient8: TJvGradient;
    pnlCaixaStatus: TPanel;
    lblTime: TLabel;
    lblDate: TLabel;
    lblDayOfWeek: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label7: TLabel;
    Label19: TLabel;
    Label25: TLabel;
    Label29: TLabel;
    pnlAvailableButtons: TPanel;
    btnAppend: TJvTransparentButton;
    btnCloseForm: TJvTransparentButton;
    btnDelivery: TJvTransparentButton;
    btnConsumptionNumber: TJvTransparentButton;
    pnlLoading: TPanel;
    JvGradient1: TJvGradient;
    imgNoSearch: TSkAnimatedImage;
    Panel40: TPanel;
    JvTransparentButton2: TPanel;
    nbkInput: TNotebook;
    pnlInputPage00Data: TPanel;
    Panel58: TPanel;
    Panel59: TPanel;
    Panel60: TPanel;
    Panel61: TPanel;
    Label15: TLabel;
    Panel62: TPanel;
    Label3: TLabel;
    edtsum_sale_item_total: TDBEdit;
    Panel6: TPanel;
    dbgSaleItems: TDBGrid;
    Panel69: TPanel;
    pnlsale_item_append: TPanel;
    imgsale_item_append: TImage;
    Panel71: TPanel;
    Panel7: TPanel;
    imgsale_item_loca_product: TImage;
    Panel8: TPanel;
    Label21: TLabel;
    edtsale_item_id: TEdit;
    Panel65: TPanel;
    btnReleaseSalePayment: TJvTransparentButton;
    btnCancel: TJvTransparentButton;
    btnBackOrder: TJvTransparentButton;
    Panel64: TPanel;
    pnlWelcome: TPanel;
    Panel4: TPanel;
    Label27: TLabel;
    Panel3: TPanel;
    Label11: TLabel;
    btnRemoverCodCliente: TJvTransparentButton;
    Label26: TLabel;
    btnRemoverCodVend: TJvTransparentButton;
    Label28: TLabel;
    imgReduzirQde: TImage;
    imgAumentarQde: TImage;
    edtperson_name: TDBEdit;
    edtseller_name: TDBEdit;
    DBEdit1: TDBEdit;
    edtseller_id: TDBEdit;
    edtperson_id: TDBEdit;
    Panel9: TPanel;
    Panel11: TPanel;
    imgLogoPdv: TImage;
    pnlInfoSaleItemPriceLabel: TPanel;
    pnlInfoSaleItemLabel: TPanel;
    pnlInputPage01Payment: TPanel;
    pnlInfoSalePayment: TPanel;
    Panel2: TPanel;
    Panel19: TPanel;
    Panel39: TPanel;
    btnSave: TJvTransparentButton;
    btnBackToItems: TJvTransparentButton;
    tmrLivre: TTimer;
    dtsSale: TDataSource;
    dtsSaleItems: TDataSource;
    dtsSalePayments: TDataSource;
    btnFocus: TButton;
    btnAppendButton: TButton;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label12: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Panel14: TPanel;
    DBEdit2: TDBEdit;
    edtdiscount: TDBEdit;
    edtincrease: TDBEdit;
    edtperc_discount: TDBEdit;
    edtperc_increase: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    Label14: TLabel;
    Label16: TLabel;
    Panel1: TPanel;
    Panel20: TPanel;
    dbgSalePayments: TDBGrid;
    Panel21: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    edtpayment_term_amount: TNumberBox;
    cbxPayment: TComboBox;
    Panel24: TPanel;
    Panel18: TPanel;
    Panel22: TPanel;
    lblChange: TPanel;
    edtchange: TDBEdit;
    Panel23: TPanel;
    Panel25: TPanel;
    lblPago: TPanel;
    edtsum_sale_payment_amount: TDBEdit;
    Panel27: TPanel;
    Panel28: TPanel;
    btnDeleteAllSalePayments: TSpeedButton;
    Panel31: TPanel;
    Image2: TImage;
    imgsale_payment_append: TImage;
    Panel15: TPanel;
    Panel16: TPanel;
    Label22: TLabel;
    Panel17: TPanel;
    Label6: TLabel;
    edttotal: TDBEdit;
    btnOnHoldSales: TJvTransparentButton;
    Label13: TLabel;
    DBEdit3: TDBEdit;
    Label17: TLabel;
    DBEdit4: TDBEdit;
    Label18: TLabel;
    DBEdit5: TDBEdit;
    Panel26: TPanel;
    Panel29: TPanel;
    DBEdit6: TDBEdit;
    DBEdit15: TDBEdit;
    Label23: TLabel;
    DBEdit16: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit20: TDBEdit;
    tmrUpdateLayout: TTimer;
    Label20: TLabel;
    Label24: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Panel5: TPanel;
    Panel32: TPanel;
    Label37: TLabel;
    edtsale_item_quantity: TNumberBox;
    lblFinalValue: TLabel;
    imgFinalValueInfo: TImage;
    Image3: TImage;
    procedure FormCreate(Sender: TObject);
    procedure tmrLivreTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCloseModalClick(Sender: TObject);
    procedure btnOpenCashierClick(Sender: TObject);
    procedure btnAppendClick(Sender: TObject);
    procedure btnReleaseSalePaymentClick(Sender: TObject);
    procedure btnSaveWithoutPaymentClick(Sender: TObject);
    procedure edtFieldClick(Sender: TObject);
    procedure edtsale_item_idKeyPress(Sender: TObject; var Key: Char);
    procedure imgsale_item_appendClick(Sender: TObject);
    procedure imgsale_item_loca_productClick(Sender: TObject);
    procedure dbgSaleItemsCellClick(Column: TColumn);
    procedure btnSaleItemsEditClick(Sender: TObject);
    procedure btnSaleItemsDeleteClick(Sender: TObject);
    procedure dbgSaleItemsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dtsSaleItemsDataChange(Sender: TObject; Field: TField);
    procedure btnSalePaymentsEditClick(Sender: TObject);
    procedure btnSalePaymentsDeleteClick(Sender: TObject);
    procedure edtFieldKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtFieldEnter(Sender: TObject);
    procedure edtFieldExit(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnBackOrderClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure imgLocaSellerClick(Sender: TObject);
    procedure imgLocaPersonClick(Sender: TObject);
    procedure btnBackToItemsClick(Sender: TObject);
    procedure btnDeleteAllSalePaymentsClick(Sender: TObject);
    procedure edtchangeChange(Sender: TObject);
    procedure edtpayment_term_amountKeyPress(Sender: TObject; var Key: Char);
    procedure imgsale_payment_appendClick(Sender: TObject);
    procedure dbgSalePaymentsCellClick(Column: TColumn);
    procedure dbgSalePaymentsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnSaveClick(Sender: TObject);
    procedure nbkMainPageChanged(Sender: TObject);
    procedure btnConsumptionNumberClick(Sender: TObject);
    procedure btnOnHoldSalesClick(Sender: TObject);
    procedure imgReduzirQdeClick(Sender: TObject);
    procedure btnDeliveryClick(Sender: TObject);
    procedure tmrUpdateLayoutTimer(Sender: TObject);
    procedure edtsale_item_quantityKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure edttotalChange(Sender: TObject);
    procedure imgFinalValueInfoClick(Sender: TObject);
    procedure Image3Click(Sender: TObject);
  private
    FViewModel: ISaleViewModel;
    FPayments: IZLMemTable;
    FMoveType: TMoveType;
    FState: TEntityState;
    FProductIndexView: TProductIndexView;
    FProductInitialSearchContent: String;

    // Parâmetros
    // -------------------------------------------------------------------------
    FPdvTicketOption: TPdvTicketOption;
    FPdvTicketCopies: SmallInt;
    // -------------------------------------------------------------------------

    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    procedure LoadPayments;
    procedure BeforeShow;
    procedure ChangePage(APage: TMainPage); overload;
    procedure ChangePage(APage: TInputPage); overload;
    function  CurrentMainPage: TMainPage;
    function  CurrentInputPage: TInputPage;
  public
  end;

var
  PdvIndexView: TPdvIndexView;
const
  COLOR_ON_ENTER: TColor = $00F3ECE4;
  COLOR_ON_EXIT: TColor  = clWindow;

implementation

{$R *.dfm}

uses
  uSale.ViewModel,
  uIndexResult,
  Quick.Threads,
  uEither,
  uPayment.Service,
  uApplicationError.View,
  uCashFlow.Service,
  uSmartPointer,
  uCashFlow.Show.DTO,
  uCashFlow.Filter.DTO,
  uHlp,
  uYesOrNo.View,
  uOpenCashier.View,
  uProduct.Show.DTO,
  uProduct.Service,
  uSaleItem.Input.View,
  uTrans,
  uToast.View,
  uDTM,
  uSale.Index.View,
  uBillPayReceive.Index.View,
  uPerson.Index.View,
  uPayment.Show.DTO,
  uAlert.View,
  uPaymentTerm.Locate.View,
  System.DateUtils,
  uSalePayment.Input.View,
  uSale.Input.DTO,
  uSale.Service,
  uSale.Show.DTO,
  uSale.Types,
  uUserLogged,
  uConsumptionMap.View,
  uSaleCheckName.View,
  uSalesOnHold.View,
  uCustomerForDelivery.Index.View,
  uProduct.Types, uInfo.View;

procedure TPdvIndexView.BeforeShow;
var LIsOpened: Boolean;
begin
  // Tela de Loading
  ChangePage(TMainPage.Loading);

  // Executar Task
  TRunTask.Execute(
   procedure(ATask: ITask)
   begin
      LIsOpened := TCashFlowService.Make.IsOpenedByStationId(ENV_VCL.StationId)
    end)
  .OnException_Sync(
    procedure(ATask : ITask; AException : Exception)
    begin
      TApplicationErrorView.Handle(AException);
    end)
  .OnTerminated_Sync(
    procedure(ATask: ITask)
    begin
      // Verificar retorno da Task
      if ATask.Failed then Exit;
      if not Assigned(nbkMain) then
        Exit;

      // Mudar página conforme resultado do caixa (Fechado/Aberto)
      ChangePage(TMainPage(BoolInt(LIsOpened)));
    end)
  .Run;
end;

procedure TPdvIndexView.btnAppendClick(Sender: TObject);
begin
  Try
    LockControl(pnlBackground);

    FViewModel.EmptyDataSets.Sale.Append;
    FMoveType := TMoveType.Normal;
    State     := TEntityState.Store;

    ChangePage(TMainPage.Input);
    ChangePage(TInputPage.Items);
  Finally
    UnLockControl(pnlBackground);
    edtsale_item_id.Clear;
    if edtsale_item_id.CanFocus then
      edtsale_item_id.SetFocus;
  End;
end;

procedure TPdvIndexView.btnBackOrderClick(Sender: TObject);
begin
  if (dtsSale.DataSet.FieldByName('total').AsCurrency <= 0) then
    raise Exception.Create('Não é possível colocar venda em espera se "TOTAL GERAL" É R$ 0,00');

  try
    LockControl(pnlBackground);
    const LSaleCheckName = TSaleCheckNameView.Handle;
    if LSaleCheckName.Trim.IsEmpty then
      Exit;

    dtsSale.DataSet.FieldByName('sale_check_name').AsString := LSaleCheckName;
    btnSaveWithoutPaymentClick(Sender);
  finally
    UnLockControl(pnlBackground);
  end;
end;

procedure TPdvIndexView.btnBackToItemsClick(Sender: TObject);
begin
  ChangePage(TInputPage.Items);
end;

procedure TPdvIndexView.btnCancelClick(Sender: TObject);
begin
  // Mensagem de Sim/Não
  if not (TYesOrNoView.Handle('Deseja cancelar operação?', Trans.AbortOperation) = mrOK) then
    Abort;

  if (FViewModel.Sale.State in [dsInsert, dsEdit]) then
    FViewModel.Sale.Cancel;

  ChangePage(TMainPage.Opened);
end;

procedure TPdvIndexView.btnCloseModalClick(Sender: TObject);
begin
  if (TYesOrNoView.Handle('Deseja sair do PDV?', 'Fechar') = mrOK) then
    ModalResult := MrCancel;
end;

procedure TPdvIndexView.btnConsumptionNumberClick(Sender: TObject);
var
  LSaleShowDTO: SH<TSaleShowDTO>;
begin
  try
    LockControl(pnlBackground);

    const LResult = TConsumptionMapView.HandleLocate;
    if (LResult.action = TConsumptionSaleAction.None) then
      Exit;

    case LResult.action of
      TConsumptionSaleAction.New: Begin
        FViewModel.EmptyDataSets.Sale.Append;
        FMoveType := TMoveType.WithoutPayment;
        State     := TEntityState.Store;
      End;
      TConsumptionSaleAction.Edit: Begin
        LSaleShowDTO := TSaleService.Make.Show(LResult.sale_id);
        FViewModel.FromShowDTO(LSaleShowDTO).Sale.Edit;
        FMoveType := TMoveType.WithoutPayment;
        State     := TEntityState.Update;
      End;
      TConsumptionSaleAction.Closure: Begin
        LSaleShowDTO := TSaleService.Make.Show(LResult.sale_id);
        FViewModel.FromShowDTO(LSaleShowDTO).Sale.Edit;
        FMoveType := TMoveType.Normal;
        State     := TEntityState.Update;
      End;
    end;

    FViewModel.Sale.FieldByName('type').AsInteger               := Ord(TSaleType.Consumption);
    FViewModel.Sale.FieldByName('consumption_number').AsInteger := LResult.number;
    ChangePage(TMainPage.Input);
    ChangePage(TInputPage.Items);
  finally
    UnLockControl(pnlBackground);
    edtsale_item_id.Clear;
    if edtsale_item_id.CanFocus then
      edtsale_item_id.SetFocus;
  end;
end;

procedure TPdvIndexView.btnDeleteAllSalePaymentsClick(Sender: TObject);
begin
  if (dtsSalePayments.DataSet.RecordCount = 0) then
    Exit;

  // Mensagem de Sim/Não
  if not (TYesOrNoView.Handle('Deseja limpar pagamentos?', Trans.Exclusion) = mrOK) then
    Exit;

  Try
    LockControl(pnlBackground);

    dtsSalePayments.DataSet.First;
    while not dtsSalePayments.DataSet.Eof do
      dtsSalePayments.DataSet.Delete;

    ToastView.Execute(Trans.RecordDeleted, tneError);
  Finally
    UnlockControl(pnlBackground);
    if cbxPayment.CanFocus then cbxPayment.SetFocus;
  End;
end;

procedure TPdvIndexView.btnOnHoldSalesClick(Sender: TObject);
var
  LSaleShowDTO: SH<TSaleShowDTO>;
begin
  try
    LockControl(pnlBackground);

    // Localizar Venda em Espera
    const LResult = TSalesOnHoldView.HandleLocate;
    if (LResult <= 0) then
      Exit;

    // Editar
    LSaleShowDTO := TSaleService.Make.Show(LResult);
    FViewModel.FromShowDTO(LSaleShowDTO).Sale.Edit;
    FMoveType := TMoveType.Normal;
    State     := TEntityState.Update;

    // Mudar Página
    FViewModel.Sale.FieldByName('type').AsInteger := Ord(TSaleType.Normal);
    ChangePage(TMainPage.Input);
    ChangePage(TInputPage.Items);
  finally
    UnLockControl(pnlBackground);
    edtsale_item_id.Clear;
    if edtsale_item_id.CanFocus then
      edtsale_item_id.SetFocus;
  end;
end;

procedure TPdvIndexView.btnOpenCashierClick(Sender: TObject);
begin
  if not (TOpenCashierView.Handle = mrOK) then
    Exit;

  ChangePage(TMainPage.Opened);
end;

procedure TPdvIndexView.btnReleaseSalePaymentClick(Sender: TObject);
begin
  if (dtsSale.DataSet.FieldByName('total').AsCurrency <= 0) then
    raise Exception.Create('Não é possível prosseguir para o pagamento se "TOTAL GERAL" É R$ 0,00');

  ChangePage(TInputPage.Payment);
  edtFieldEnter(edtpayment_term_amount);
  if (dtsSalePayments.DataSet.RecordCount <= 0) then
  begin
    if cbxPayment.CanFocus then
      cbxPayment.SetFocus;
    cbxPayment.ItemIndex   := 0;
    cbxPayment.DroppedDown := true;
  end;
end;

procedure TPdvIndexView.btnSaleItemsDeleteClick(Sender: TObject);
begin
  // Mensagem de Sim/Não
  if not (TYesOrNoView.Handle(Trans.DoYouWantToDeleteSelectedRecord, Trans.Exclusion) = mrOK) then
    Exit;

  Try
    LockControl(pnlBackground);

    const LProductName = dtsSaleItems.DataSet.FieldByName('product_name').AsString.ToUpper;
    dtsSaleItems.DataSet.Delete;

    ToastView.Execute(Trans.RecordDeleted, TTypeToastEnum.tneError);
    pnlInfoSaleItemLabel.Caption      := 'ITEM CANCELADO!';
    pnlInfoSaleItemPriceLabel.Caption := LProductName;
  Finally
    UnlockControl(pnlBackground);
    if edtsale_item_id.CanFocus then
      edtsale_item_id.SetFocus;
  End;
end;

procedure TPdvIndexView.btnSaleItemsEditClick(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsSaleItems.DataSet) and dtsSaleItems.DataSet.Active and (dtsSaleItems.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  Try
    LockControl(pnlBackground);

    // Incluir Novo Registro
    TSaleItemInputView.Handle(TEntityState.Update, FViewModel);
  Finally
    UnLockControl(pnlBackground);
    if edtsale_item_id.CanFocus then
      edtsale_item_id.SetFocus;
  End;
end;

procedure TPdvIndexView.btnSalePaymentsDeleteClick(Sender: TObject);
begin
  // Mensagem de Sim/Não
  if not (TYesOrNoView.Handle(Trans.DoYouWantToDeleteSelectedRecord, Trans.Exclusion) = mrOK) then
    Exit;

  Try
    LockControl(pnlBackground);

    dtsSalePayments.DataSet.Delete;
    ToastView.Execute(Trans.RecordDeleted, tneError);
  Finally
    UnlockControl(pnlBackground);
  End;
end;

procedure TPdvIndexView.btnSalePaymentsEditClick(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsSalePayments.DataSet) and dtsSalePayments.DataSet.Active and (dtsSalePayments.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  Try
    LockControl(pnlBackground);

    // Incluir Novo Registro
    TSalePaymentInputView.Handle(TEntityState.Update, FViewModel);
  Finally
    UnLockControl(pnlBackground);
  End;
end;

procedure TPdvIndexView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TSaleShowDTO>;
  LPdvPrintTicket: Boolean;
  LPdvPrintTicketCopies: SmallInt;
begin
  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if (CurrentMainPage = TMainPage.Loading) then
    Exit;

  // Lançar pagamento posicionado se não tiver nenhum informado
  if (dtsSalePayments.DataSet.RecordCount <= 0) and (dtsSale.DataSet.FieldByName('total').AsFloat > 0) then
  begin
    edtpayment_term_amount.ValueFloat := dtsSale.DataSet.FieldByName('total').AsFloat;
    imgsale_payment_appendClick(imgsale_payment_append);
  end;

  // Imprimir Comprovante Não Fiscal. Perguntar!
  LPdvPrintTicket       := False;
  LPdvPrintTicketCopies := FPdvTicketCopies;
  case FPdvTicketOption of
    TPdvTicketOption.Print:    LPdvPrintTicket := True;
    TPdvTicketOption.Optional: LPdvPrintTicket := (TYesOrNoView.Handle('Deseja imprimir ticket não fiscal?', Trans.Printing) = mrOK);
  end;

  // Sempre salvar dataset para evitar erros
  if FViewModel.Sale.State in [dsInsert, dsEdit] then
  begin
    FViewModel.Sale.FieldByName('money_received').AsFloat := FViewModel.Sale.FieldByName('sum_sale_payment_amount').AsFloat;
    FViewModel.Sale.FieldByName('money_change').AsFloat   := FViewModel.Sale.FieldByName('remaining_change').AsFloat;
    FViewModel.Sale.Post;
  end;

  // Iniciar Loading
  dtsSale.DataSet         := nil;
  dtsSaleItems.DataSet    := nil;
  dtsSalePayments.DataSet := nil;
  ChangePage(TMainPage.Loading);

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      // Incluir/Alterar Venda
      const LSaleService = TSaleService.Make;
      const LSaleInputDTO: SH<TSaleInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store: LSaved := LSaleService.StoreAndGenerateBilling(LSaleInputDTO);
        TEntityState.Update: Begin
          LSaved := LSaleService.UpdateAndShow(FViewModel.Sale.Fields[0].AsLargeInt, LSaleInputDTO, False);
          if LSaved.Match then
            LSaved := LSaleService.GenerateBilling(FViewModel.Sale.Fields[0].AsLargeInt, TSaleGenerateBillingOperation.Approve);
        End;
      end;
      if not LSaved.Match then
        Exit;

      // Imprimir Comprovante Não Fiscal
      if LPdvPrintTicket then
        LSaleService.PosTicket(LSaved.Right.id, LPdvPrintTicketCopies);
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
        // Abortar se falhar na validação
        if not LSaved.Match then
        begin
          // Não exibir alerta quando a tarefa falhar, pois já exibe uma mensagem por default
          if not ATask.Failed then
            TAlertView.Handle(LSaved.Left);

          FViewModel.Sale.Edit;
          ToastView.Execute(Trans.RecordValidationFailed, tneError);
          ChangePage(TMainPage.Input);
          Exit;
        end;

        // Retornar tela para incluir/alterar outra venda
        LSaved.Right.Free;
        ToastView.Execute(Trans.RecordSaved, tneSuccess);
        ChangePage(TMainPage.Opened);
      finally
        dtsSale.DataSet         := FViewModel.Sale.DataSet;
        dtsSaleItems.DataSet    := FViewModel.SaleItems.DataSet;
        dtsSalePayments.DataSet := FViewModel.SalePayments.DataSet;
      end;
    end)
  .Run;
end;

procedure TPdvIndexView.btnSaveWithoutPaymentClick(Sender: TObject);
var LSaved: Either<String, TSaleShowDTO>;
begin
  inherited;

  // Sempre salvar dataset para evitar erros
  if FViewModel.Sale.State in [dsInsert, dsEdit] then
    FViewModel.Sale.Post;

  // Iniciar Loading
  LockControl(pnlBackground);
  dtsSale.DataSet         := nil;
  dtsSaleItems.DataSet    := nil;
  dtsSalePayments.DataSet := nil;
  ChangePage(TMainPage.Loading);

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LSaleInputDTO: SH<TSaleInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TSaleService.Make.StoreAndShow(LSaleInputDTO);
        TEntityState.Update: LSaved := TSaleService.Make.UpdateAndShow(FViewModel.Sale.Fields[0].AsLargeInt, LSaleInputDTO);
      end;
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
        // Abortar se falhar na validação
        if not LSaved.Match then
        begin
          // Não exibir alerta quando a tarefa falhar, pois já exibe uma mensagem por default
          if not ATask.Failed then
            TAlertView.Handle(LSaved.Left);

          ChangePage(TMainPage.Input);
          FViewModel.Sale.Edit;
          ToastView.Execute(Trans.RecordValidationFailed, tneError);
          Exit;
        end;

        // Retornar registro inserido/atualizado
        LSaved.Right.Free;
        ChangePage(TMainPage.Opened);
        ChangePage(TInputPage.Items);
        State := TEntityState.None;
      finally
        // Encerrar Loading
        UnLockControl(pnlBackground);
        dtsSale.DataSet         := FViewModel.Sale.DataSet;
        dtsSaleItems.DataSet    := FViewModel.SaleItems.DataSet;
        dtsSalePayments.DataSet := FViewModel.SalePayments.DataSet;
      end;
    end)
  .Run;
end;

procedure TPdvIndexView.dbgSaleItemsCellClick(Column: TColumn);
begin
  inherited;
  if edtsale_item_id.CanFocus then edtsale_item_id.SetFocus;
  const LKeepGoing = Assigned(dtsSaleItems.DataSet) and dtsSaleItems.DataSet.Active and (dtsSaleItems.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  // Editar
  if (AnsiLowerCase(Column.FieldName) = 'action_edit') then
    btnSaleItemsEditClick(dbgSaleItems);

  // Deletar
  if (AnsiLowerCase(Column.FieldName) = 'action_delete') then
    btnSaleItemsDeleteClick(dbgSaleItems);
end;

procedure TPdvIndexView.dbgSaleItemsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  const LKeepGoing = Assigned(dtsSaleItems.DataSet) and (dtsSaleItems.DataSet.Active) and (dtsSaleItems.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  // Exibir imagem de Editar
  if (AnsiLowerCase(Column.FieldName) = 'action_edit') then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
    DTM.imgListGrid.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 0);
  end;

  // Exibir imagem de Deletar
  if (AnsiLowerCase(Column.FieldName) = 'action_delete') then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
    DTM.imgListGrid.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 1);
  end;
end;

procedure TPdvIndexView.dbgSalePaymentsCellClick(Column: TColumn);
begin
  const LKeepGoing = Assigned(dtsSalePayments.DataSet) and dtsSalePayments.DataSet.Active and (dtsSalePayments.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  // Editar
  if (AnsiLowerCase(Column.FieldName) = 'action_edit') then
    btnSalePaymentsEditClick(dbgSalePayments);

  // Deletar
  if (AnsiLowerCase(Column.FieldName) = 'action_delete') then
    btnSalePaymentsDeleteClick(dbgSalePayments);
end;

procedure TPdvIndexView.dbgSalePaymentsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  const LKeepGoing = Assigned(dtsSalePayments.DataSet) and (dtsSalePayments.DataSet.Active) and (dtsSalePayments.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  // Exibir imagem de Editar
  if (AnsiLowerCase(Column.FieldName) = 'action_edit') then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
    DTM.imgListGrid.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 0);
  end;

  // Exibir imagem de Deletar
  if (AnsiLowerCase(Column.FieldName) = 'action_delete') then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
    DTM.imgListGrid.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 1);
  end;
end;

procedure TPdvIndexView.dtsSaleItemsDataChange(Sender: TObject; Field: TField);
begin
  pnlInfoSaleItemLabel.Caption      := EmptyStr;
  pnlInfoSaleItemPriceLabel.Caption := EmptyStr;
  const LKeepGoing = Assigned(dtsSale.DataSet) and (dtsSale.DataSet.State in [dsInsert, dsEdit]) and
                     Assigned(dtsSaleItems.DataSet) and dtsSaleItems.DataSet.Active and (dtsSaleItems.DataSet.RecordCount > 0) and
                     (dtsSaleItems.DataSet.FieldByName('product_name').AsString.Trim > '');
  if not lKeepGoing then
    Exit;

  // Carregar informações do ITEM
  With dtsSaleItems.DataSet do
  begin
    pnlInfoSaleItemLabel.Caption := Copy(AnsiUpperCase(FieldByName('product_name').AsString),1,30);
    pnlInfoSaleItemPriceLabel.Caption  :=
      FormatCurr('#,##0.00', FieldByName('quantity').AsCurrency) + ' ' +
      FieldByName('product_unit_name').AsString + '   x   ' +
      FormatCurr('R$ #,##0.00', FieldByName('total').AsCurrency/FieldByName('quantity').AsCurrency) + '   =   ' +
      FormatCurr('R$ #,##0.00', FieldByName('total').AsCurrency);
  end;
end;

procedure TPdvIndexView.edtchangeChange(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsSale.DataSet) and (dtsSale.DataSet.State in [dsInsert, dsEdit]);
  if not LKeepGoing then
    Exit;

  case (dtsSale.DataSet.FieldByName('remaining_change').AsFloat < 0) of
    True:  lblChange.Caption := 'Faltante:';
    False: lblChange.Caption := 'Troco:';
  end;
end;

procedure TPdvIndexView.edtFieldClick(Sender: TObject);
begin
  if (Sender is TEdit) then
    TEdit(Sender).SelectAll;

  if (Sender is TDBEdit) then
    TDBEdit(Sender).SelectAll;

  if (Sender is TNumberBox) then
    TNumberBox(Sender).SelectAll;
end;

procedure TPdvIndexView.edtFieldEnter(Sender: TObject);
begin
 if (Sender is TEdit) then
    TEdit(Sender).Color := COLOR_ON_ENTER;

 if (Sender is TDBEdit) then
    TDBEdit(Sender).Color := COLOR_ON_ENTER;

  if (Sender is TComboBox) then
    TComboBox(Sender).Color := COLOR_ON_ENTER;

  if (Sender is TDBComboBox) then
    TDBComboBox(Sender).Color := COLOR_ON_ENTER;

  if (Sender is TMemo) then
    TMemo(Sender).Color := COLOR_ON_ENTER;

  if (Sender is TDBMemo) then
    TDBMemo(Sender).Color := COLOR_ON_ENTER;

  if (Sender is TNumberBox) then
    TNumberBox(Sender).Color := COLOR_ON_ENTER;

  if (Sender = edtpayment_term_amount) then
  begin
    case (dtsSale.DataSet.FieldByName('remaining_change').AsCurrency < 0) of
      True:  edtpayment_term_amount.ValueFloat := Abs(dtsSale.DataSet.FieldByName('remaining_change').AsCurrency);
      False: edtpayment_term_amount.ValueFloat := 0;
    end;
    edtpayment_term_amount.SelectAll;
  end;
end;

procedure TPdvIndexView.edtFieldExit(Sender: TObject);
begin
  if (Sender is TEdit) then
    TEdit(Sender).Color := COLOR_ON_EXIT;

  if (Sender is TDBEdit) then
    TDBEdit(Sender).Color := COLOR_ON_EXIT;

  if (Sender is TComboBox) then
    TComboBox(Sender).Color := COLOR_ON_EXIT;

  if (Sender is TDBComboBox) then
    TDBComboBox(Sender).Color := COLOR_ON_EXIT;

  if (Sender is TMemo) then
    TMemo(Sender).Color := COLOR_ON_EXIT;

  if (Sender is TDBMemo) then
    TDBMemo(Sender).Color := COLOR_ON_EXIT;

  if (Sender is TNumberBox) then
    TNumberBox(Sender).Color := COLOR_ON_EXIT;
end;

procedure TPdvIndexView.edtFieldKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Focus no proximo campo
  if (Key = VK_RETURN) then
    Perform(WM_NEXTDLGCTL,0,0);
end;

procedure TPdvIndexView.edtpayment_term_amountKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    case (edtpayment_term_amount.ValueFloat > 0) of
      True:  imgsale_payment_appendClick(imgsale_payment_append);
      False: btnSaveClick(btnSave);
    end;
  end;
end;

procedure TPdvIndexView.edtsale_item_idKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    imgsale_item_appendClick(imgsale_item_append);
end;

procedure TPdvIndexView.edtsale_item_quantityKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and edtsale_item_id.CanFocus then
  begin
    edtsale_item_id.SetFocus;
    edtsale_item_id.SelectAll;
  end;
end;

procedure TPdvIndexView.edttotalChange(Sender: TObject);
begin
  lblFinalValue.Caption := Format('R$ %.2n', [StrFloat(edtTotal.Text)]);
end;

procedure TPdvIndexView.FormCreate(Sender: TObject);
begin
  ChangePage(TMainPage.Loading);
  ChangePage(TInputPage.Items);
  tmrLivre.Enabled := True;
  tmrLivreTimer(tmrLivre);
  LoadPayments;
  FViewModel := TSaleViewModel.Make;

  // Instanciar uma única vez pesquisa de itens
  FProductIndexView := TProductIndexView.Create(nil);
  FProductIndexView.SetLayoutLocate(False);

  // Parâmetros
  FPdvTicketOption := ENV_VCL.PdvTicketOption;
  FPdvTicketCopies := ENV_VCL.PdvTicketCopies;
end;

procedure TPdvIndexView.FormDestroy(Sender: TObject);
begin
  if Assigned(FProductIndexView) then
    FProductIndexView.Free;
end;

procedure TPdvIndexView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Caixa Fechado
  if (CurrentMainPage = TMainPage.Closed) then
  begin
    // Esc - Sair
    if (Key = VK_ESCAPE) then
    begin
      btnCloseModalClick(btnCloseModal);
      Exit;
    end;

    // Enter - Abrir Caixa
    if (Key = VK_RETURN) then
    begin
      btnOpenCashierClick(btnOpenCashier);
      Exit;
    end;
  end;

  // Livre
  if (CurrentMainPage = TMainPage.Opened) then
  begin
    // F12 - Alterar resolução para 1024x768 (Teste)
    if TheKeyIsBeingPressed(VK_SHIFT) and (Key = VK_F12) Then
    begin
      if (Self.Height <= 768) then
      begin
        Self.Height := Screen.Height;
        Self.Width  := Screen.Width;
        Self.Top    := 0;
        Self.Left   := 0;
      end else
      Begin
        Self.Height := 768;
        Self.Width  := 1024;
        Self.Top    := Trunc((Screen.Height-Self.Height)/2);
        Self.Left   := Trunc((Screen.Width-Self.Width)/2);
      End;
      Exit;
    end;

    // Esc - Sair
    if (Key = VK_ESCAPE) then
    begin
      btnCloseModalClick(btnCloseForm);
      Exit;
    end;

    // F2 - Consultar itens
    if (Key = VK_F2) then
    begin
      TProductIndexView.HandleLocate;
      Exit;
    end;

    // F3 - Fichas de Consumo
    if (Key = VK_F3) then
    begin
      btnConsumptionNumberClick(btnConsumptionNumber);
      Exit;
    end;

    // F4 - Entrega
    if (Key = VK_F4) then
    begin
      btnDeliveryClick(btnDelivery);
      Exit;
    end;

    // F5 - Abrir venda em espera
    if (Key = VK_F5) then
    begin
      btnOnHoldSalesClick(btnOnHoldSales);
      Exit;
    end;

    // F9 - Consultar EAN
    if (Key = VK_F9) then
    begin
      //ConsultEAN;
      Exit;
    end;

    // F10 - Histórico de Vendas
    if (Key = VK_F10) then
    begin
      TSaleIndexView.HandleLocate;
      Exit;
    end;

    // F11 - Meu Caixa
    if (Key = VK_F11) then
    begin
      //TCashFlowConsultView.Handle;
      Exit;
    end;

    // F12 - Contas a Pagar/Receber
    if (Key = VK_F12) then
    begin
      TBillPayReceiveIndexView.HandleLocate;
      Exit;
    end;

    // Enter - Iniciar Venda
    if (Key = VK_RETURN) then
    begin
      btnAppendClick(btnAppend);
      Exit;
    end;
  end;

  // Inserindo/Atualizando > Itens
  if (CurrentMainPage = TMainPage.Input) and (CurrentInputPage = TInputPage.Items) then
  begin
    // F1 - Alterar Quantidade
    if (Key = VK_F1) then
    begin
      edtsale_item_quantity.SetFocus;
      edtsale_item_quantity.SelectAll;
      Exit;
    end;

    // F2 - Localizar Item
    if (Key = VK_F2) then
    begin
      imgsale_item_loca_productClick(imgsale_item_loca_product);
      Exit;
    end;

    // F4 - Localizar Vendedor
    if (Key = VK_F4) then
    begin
      imgLocaSellerClick(Sender);
      Exit;
    end;

    // F5 - Localizar Cliente
    if (Key = VK_F5) then
    begin
      imgLocaPersonClick(Sender);
      Exit;
    end;

    // F6 - Lançar Pagamento
    if (Key = VK_F6) and (FMoveType = TMoveType.Normal) then
    begin
      btnReleaseSalePaymentClick(btnReleaseSalePayment);
      Exit;
    end;

    // F6 - Salvar
    if (Key = VK_F6) and (FMoveType = TMoveType.WithoutPayment) then
    begin
      btnSaveWithoutPaymentClick(sender);
      Exit;
    end;

    // F7 - Aguardar (Colocar venda em modo de espera)
    if (Key = VK_F7) then
    begin
      btnBackOrderClick(sender);
      Exit;
    end;

    // ESC - Cancelar Venda
    if (Key = VK_ESCAPE) then
    begin
      btnCancelClick(btnCancel);
      Exit;
    end;
  end;

  // Inserindo/Atualizando > Pagamento
  if (CurrentMainPage = TMainPage.Input) and (CurrentInputPage = TInputPage.Payment) then
  begin
    // F1 - Desconto $
    if (Key = VK_F1) then
    begin
      edtdiscount.SetFocus;
      edtdiscount.SelectAll;
      Exit;
    end;

    // F2 - Desconto %
    if (Key = VK_F2) then
    begin
      edtperc_discount.SetFocus;
      edtperc_discount.SelectAll;
      Exit;
    end;

    // F3 - Acréscimo $
    if (Key = VK_F2) then
    begin
      edtincrease.SetFocus;
      edtincrease.SelectAll;
      Exit;
    end;

    // F5 - Acréscimo %
    if (Key = VK_F2) then
    begin
      edtperc_increase.SetFocus;
      edtperc_increase.SelectAll;
      Exit;
    end;

    // F6 - Pagamento
    if (Key = VK_F6) then
    begin
      cbxPayment.SetFocus;
      cbxPayment.DroppedDown := true;
      Exit;
    end;

    // F7 - Valor de Pagamento
    if (Key = VK_F7) then
    begin
      edtpayment_term_amount.SetFocus;
      edtpayment_term_amount.SelectAll;
      Exit;
    end;

    // F9 - Limpar Pagamentos
    if (Key = VK_F9) then
    begin
      btnDeleteAllSalePaymentsClick(btnDeleteAllSalePayments);
      Exit;
    end;

    // ESC - Voltar para Produtos
    if (Key = VK_ESCAPE) then
    begin
      btnBackToItemsClick(btnBackToItems);
      Exit;
    end;

    // END - Salvar
    if (Key = VK_END) then
    begin
      btnSaveClick(btnSave);
      Exit;
    end;
  end;
end;

procedure TPdvIndexView.FormShow(Sender: TObject);
begin
  BeforeShow;
end;

procedure TPdvIndexView.Image3Click(Sender: TObject);
begin
  TInfoView.Handle(
    'Você pode verificar os valores do item antes da inserção, independentemente da configuração realizada anteriormente.'+#13+
    'Para realizar esse processo: Pressione [SHIFT] + [ENTER] com o código do item já informado.'
  );
end;

function TPdvIndexView.CurrentMainPage: TMainPage;
begin
  Result := TMainPage(nbkMain.PageIndex);
end;

procedure TPdvIndexView.imgFinalValueInfoClick(Sender: TObject);
begin
  TInfoView.Handle(
    'O campo "TOTAL GERAL" é uma composição de diferentes tipos de valores, tais como acréscimos, descontos, fretes e outros. '+
    'Esses elementos são levados em consideração no cálculo do "TOTAL GERAL", proporcionando uma representação completa e precisa do valor total a ser pago ou recebido.'+#13+
    #13+
    'Na aba de Pagamento, esses valores serão destacados individualmente, permitindo uma compreensão clara e facilitando a análise de cada campo calculado.'
  );
end;

procedure TPdvIndexView.imgLocaPersonClick(Sender: TObject);
var
  LFilter: TPersonFormFilter;
begin
  if edtsale_item_id.CanFocus then edtsale_item_id.SetFocus;
  LFilter.flg_customer := TPersonFormFilterValue.Yes;
  const LPk = TPersonIndexView.HandleLocate(LFilter);
  if (LPk > 0) then
    dtsSale.DataSet.FieldByName('person_id').Text := LPk.ToString
end;

procedure TPdvIndexView.imgLocaSellerClick(Sender: TObject);
var
  LFilter: TPersonFormFilter;
begin
  if edtsale_item_id.CanFocus then edtsale_item_id.SetFocus;
  LFilter.flg_seller := TPersonFormFilterValue.Yes;
  const LPk = TPersonIndexView.HandleLocate(LFilter);
  if (LPk > 0) then
    dtsSale.DataSet.FieldByName('seller_id').Text := LPk.ToString
end;

procedure TPdvIndexView.imgReduzirQdeClick(Sender: TObject);
begin
  if (Sender = imgReduzirQde) then
  Begin
    With dtsSale.DataSet do
    begin
      FieldByName('amount_of_people').AsInteger := FieldByName('amount_of_people').AsInteger - 1;
      if (FieldByName('amount_of_people').AsInteger <= 0) then
        FieldByName('amount_of_people').AsInteger := 1;
    end;
  End;

  if (Sender = imgAumentarQde) then
  Begin
    With dtsSale.DataSet do
      FieldByName('amount_of_people').AsInteger := FieldByName('amount_of_people').AsInteger + 1;
  End;
end;

procedure TPdvIndexView.imgsale_item_appendClick(Sender: TObject);
begin
  const LShiftIsPressed = GetKeyState(VK_SHIFT) < 0;
  const LKeepGoing = Assigned(dtsSale.DataSet) and dtsSale.DataSet.Active and Assigned(dtsSaleItems.DataSet) and
                     dtsSaleItems.DataSet.Active and (String(edtsale_item_id.Text).Trim > '');
  if not lKeepGoing then
    Exit;

  try
    LockControl(pnlBackground);

    if (edtsale_item_quantity.ValueFloat <= 0) then
      edtsale_item_quantity.ValueFloat := 1;

    var LQuantity: Double := edtsale_item_quantity.ValueFloat;
    var LEanOrSkuCode := edtsale_item_id.Text;
    var LAsteriskPos  := Pos('*', LEanOrSkuCode);
    if (LAsteriskPos > 0) then
    begin
      LQuantity     := StrFloat(Copy(LEanOrSkuCode, 1, Pred(LAsteriskPos)));
      LEanOrSkuCode := Trim(Copy(LEanOrSkuCode, LAsteriskPos+1));
    end;

    // Tentar localizar item por EAN ou SkuCode
    if Trim(LEanOrSkuCode).IsEmpty then Exit;
    const LProductShowDTOSelected: SH<TProductShowDTO> = TProductService.Make.ShowByEanOrSkuCode(LEanOrSkuCode);
    if not Assigned(LProductShowDTOSelected.Value) then
    begin
      // Se não encontrar o item e os 3 primeiros caracteres forem letras, deve abrir a pesquisa por descrição
      const LContent = String(edtsale_item_id.Text).Trim;
      const LOpenSearchByDescription = (LContent.Length >= 3) and (OnlyDifNumbers(LContent).Length = LContent.Length);
      if LOpenSearchByDescription then
      begin
        FProductInitialSearchContent := edtsale_item_id.Text;
        edtsale_item_id.Clear;
        imgsale_item_loca_productClick(imgsale_item_loca_product);
        Exit;
      end;

      TAlertView.Handle(Format('Item com o código informado "%s" não foi encontrado.',[LEanOrSkuCode]));
      edtsale_item_id.Text := EmptyStr;
      Exit;
    end;

    With dtsSaleItems.DataSet do
    begin
      Append;
      FieldByName('product_id').AsLargeInt      := LProductShowDTOSelected.Value.id;
      FieldByName('quantity').AsFloat           := LQuantity;
      FieldByName('price').AsFloat              := LProductShowDTOSelected.Value.price;
      FieldByName('unit_discount').AsFloat      := 0;
      FieldByName('seller_id').AsLargeInt       := FViewModel.Sale.FieldByName('seller_id').AsLargeInt;
      FieldByName('note').AsString              := EmptyStr;
      FieldByName('product_name').AsString      := LProductShowDTOSelected.Value.name;      {virtual}
      FieldByName('product_unit_name').AsString := LProductShowDTOSelected.Value.unit_name; {virtual}
      Post;
    end;

    // Editar produto que acabou de lançar
    if (LProductShowDTOSelected.Value.check_value_before_insert = TProductCheckValueBeforeInsert.Yes) or LShiftIsPressed then
      if not (TSaleItemInputView.Handle(TEntityState.Update, FViewModel) = mrOK) then
        dtsSaleItems.DataSet.Delete;
  finally
    edtsale_item_id.Text             := EmptyStr;
    edtsale_item_quantity.ValueFloat := 1;
    UnlockControl(pnlBackground);
    if edtsale_item_id.CanFocus then
    begin
      edtsale_item_id.SetFocus;
      edtsale_item_id.SelectAll;
    end;
  end;
end;

procedure TPdvIndexView.imgsale_item_loca_productClick(Sender: TObject);
begin
  try
    // Criar fundo transparente
    const LDarkBackground: SH<TForm> = TForm.Create(nil);
    CreateDarkBackground(LDarkBackground.Value);

    // Instanciar uma única vez
    if not (FProductIndexView.AShowModal(FProductInitialSearchContent) = mrOK) then Exit;
    if not (FProductIndexView.LocateResult > 0) then Exit;

    // Localizar Item
    const LProductShowDTO: SH<TProductShowDTO> = TProductService.Make.Show(FProductIndexView.LocateResult);
    edtsale_item_id.Text := edtsale_item_id.Text + lProductShowDTO.Value.sku_code;
    imgsale_item_appendClick(imgsale_item_append);
  finally
    // Evitar Erros
    FProductInitialSearchContent := EmptyStr;
  end;
end;

procedure TPdvIndexView.imgsale_payment_appendClick(Sender: TObject);
var
  LPaymentShowDTO: SH<TPaymentShowDTO>;
begin
  inherited;
  const LKeepGoing = Assigned(dtsSale.DataSet) and dtsSale.DataSet.Active and Assigned(dtsSalePayments.DataSet) and dtsSalePayments.DataSet.Active;
  if not LKeepGoing then
    Exit;

  try
    LockControl(pnlBackground);

    var LErrors := EmptyStr;
    FPayments.First;
    case FPayments.Locate('name', VarArrayOf([cbxPayment.Text])) of
      True:  LPaymentShowDTO := TPaymentService.Make.Show(FPayments.FieldByName('id').AsLargeInt);
      False: LErrors         := LErrors + 'Campo [Pagamento] � obrigat�rio.' + #13;
    end;
    if String(cbxPayment.Text).Trim.IsEmpty then
      LErrors := LErrors + 'Campo [Pagamento] � obrigat�rio.' + #13;
    if (edtpayment_term_amount.ValueFloat <= 0) then
      LErrors := LErrors + 'Campo [Valor] � obrigat�rio.' + #13;
    if not LErrors.Trim.IsEmpty then
    begin
      TAlertView.Handle(LErrors);
      Exit;
    end;

    // Termo de Pagamento
    var LPaymentTermShowDTO := LPaymentShowDTO.Value.payment_terms.Items[0];
    if (LPaymentShowDTO.Value.payment_terms.Count > 1) then
    begin
      LPaymentTermShowDTO := TPaymentTermLocateView.Handle(FPayments.FieldByName('id').AsLargeInt);
      if not Assigned(LPaymentTermShowDTO) then Exit;
    end;

    // Lan�ar Pagamento (Parcelas)
    const LUUID = NextUUID;
    const LAmount: Double = edtpayment_term_amount.ValueFloat/LPaymentTermShowDTO.number_of_installments;
    var LDueDate := IncDay(Now, LPaymentTermShowDTO.first_in);
    for var lI := 1 to LPaymentTermShowDTO.number_of_installments do
    begin
      dtsSalePayments.DataSet.Append;
      dtsSalePayments.DataSet.FieldByName('collection_uuid').AsString     := LUUID;
      dtsSalePayments.DataSet.FieldByName('payment_id').AsLargeInt        := LPaymentShowDTO.Value.id;
      dtsSalePayments.DataSet.FieldByName('bank_account_id').AsLargeInt   := LPaymentShowDTO.Value.bank_account_default_id;
      dtsSalePayments.DataSet.FieldByName('amount').AsFloat               := LAmount;
      dtsSalePayments.DataSet.FieldByName('note').AsString                := EmptyStr;
      dtsSalePayments.DataSet.FieldByName('due_date').AsDateTime          := LDueDate;
      dtsSalePayments.DataSet.FieldByName('payment_name').AsString        := LPaymentShowDTO.Value.name; {virtual}
      dtsSalePayments.DataSet.FieldByName('bank_account_name').AsString   := LPaymentShowDTO.Value.bank_account_default_name; {virtual}
      dtsSalePayments.DataSet.Post;

      // Incrementar intervalo entre parcelas
      case (LPaymentTermShowDTO.interval_between_installments = 30) of
        True:  LDueDate := IncMonth(LDueDate);
        False: LDueDate := IncDay(LDueDate, LPaymentTermShowDTO.interval_between_installments);
      end;
      Application.ProcessMessages;
    end;
  finally
    UnLockControl(pnlBackground);
    edtpayment_term_amount.ValueFloat := 0;
    if cbxPayment.CanFocus then
      cbxPayment.SetFocus;
  end;
end;

procedure TPdvIndexView.btnDeliveryClick(Sender: TObject);
begin
  const LPersonId = TCustomerForDeliveryIndexView.HandleLocate;
  if LPersonId <= 0 then
    Exit;

  ShowMessage(LPersonId.ToString);
end;

procedure TPdvIndexView.ChangePage(APage: TInputPage);
begin
  if not (nbkInput.PageIndex = Ord(APage)) then
    nbkInput.PageIndex := Ord(APage);
end;

procedure TPdvIndexView.ChangePage(APage: TMainPage);
begin
  if not (nbkMain.PageIndex = Ord(APage)) then
    nbkMain.PageIndex := Ord(APage);
end;

function TPdvIndexView.CurrentInputPage: TInputPage;
begin
  Result := TInputPage(nbkInput.PageIndex);
end;

procedure TPdvIndexView.LoadPayments;
var
  LIndexResultTask: Either<String, IIndexResult>;
  LIndexResult: IIndexResult;
begin
  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
   begin
      LIndexResultTask := TPaymentService.Make.Index();
    end)
  .OnException_Sync(
    procedure(ATask : ITask; AException : Exception)
    begin
      TApplicationErrorView.Handle(AException);
    end)
  .OnTerminated_Sync(
    procedure(ATask: ITask)
    begin
      // Verificar retorno da Task
      if ATask.Failed then Exit;
      case LIndexResultTask.Match of
        True:  LIndexResult := LIndexResultTask.Right;
        False: Begin
          TApplicationErrorView.Handle(LIndexResultTask.Left);
          Exit;
        End;
      end;

      FPayments := LIndexResult.Data;

      // Evita erro se o Form for abortado antes de terminar o carregamento
      if not Assigned(cbxPayment) then
        Exit;

      var LCount := 0;
      var LSetItemIndex := 0;
      cbxPayment.Items.BeginUpdate;
      cbxPayment.Clear;
      FPayments.First;
      while not FPayments.Eof do
      begin
        Inc(LCount);
        if (FPayments.FieldByName('id').AsLargeInt = 1) then
          LSetItemIndex := LCount-1;

        cbxPayment.Items.Add(FPayments.FieldByName('name').AsString.ToUpper);
        Application.ProcessMessages;
        FPayments.Next;
      end;
      cbxPayment.Items.EndUpdate;
      cbxPayment.ItemIndex := LSetItemIndex;
    end)
  .Run;
end;

procedure TPdvIndexView.nbkMainPageChanged(Sender: TObject);
begin
  // Evitar erro com atalho "Enter" para abrir a venda
  if ((CurrentMainPage = TMainPage.Opened) and btnAppendButton.CanFocus) then
    btnAppendButton.SetFocus;
end;

procedure TPdvIndexView.SetState(const Value: TEntityState);
begin
  FState := Value;

  dtsSale.DataSet            := FViewModel.Sale.DataSet;
  dtsSaleItems.DataSet       := FViewModel.SaleItems.DataSet;
  dbgSaleItems.DataSource    := dtsSaleItems;
  dtsSalePayments.DataSet    := FViewModel.SalePayments.DataSet;
  dbgSalePayments.DataSource := dtsSalePayments;

  case FMoveType of
    TMoveType.Normal: Begin
      btnReleaseSalePayment.Caption := 'Pagamento (F6)';
      btnReleaseSalePayment.OnClick := btnReleaseSalePaymentClick;
      btnBackOrder.Visible          := Assigned(dtsSale.DataSet) and dtsSale.DataSet.Active and (TSaleType(dtsSale.DataSet.FieldByName('type').AsInteger) = TSaleType.Normal);
    End;
    TMoveType.WithoutPayment: Begin
      btnReleaseSalePayment.Caption := 'Salvar (F6)';
      btnReleaseSalePayment.OnClick := btnSaveWithoutPaymentClick;
      btnBackOrder.Visible          := False;
    End;
  end;
end;

procedure TPdvIndexView.tmrLivreTimer(Sender: TObject);
begin
  lblTime.Caption := Copy(TimeToStr(GetTime()),1,5);
  lblDate.Caption := DateToStr(now);

  case DayOfWeek(Date) of
    1: lblDayOfWeek.Caption := 'Domingo';
    2: lblDayOfWeek.Caption := 'Segunda-feira';
    3: lblDayOfWeek.Caption := 'Terça-feira';
    4: lblDayOfWeek.Caption := 'Quarta-feira';
    5: lblDayOfWeek.Caption := 'Quinta-feira';
    6: lblDayOfWeek.Caption := 'Sexta-feira';
    7: lblDayOfWeek.Caption := 'Sábado';
  end;
end;

procedure TPdvIndexView.tmrUpdateLayoutTimer(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsSale.DataSet) and dtsSale.DataSet.Active;
  if not LKeepGoing then
    Exit;

  // Aguardando lançamento de itens...
  if Assigned(dtsSaleItems.DataSet) and dtsSaleItems.DataSet.Active and (dtsSaleItems.DataSet.RecordCount <= 0) then
  begin
    const LMsg = 'AGUARDANDO ITENS...';
    if not (pnlInfoSaleItemLabel.Caption = LMsg) then
    Begin
      pnlInfoSaleItemLabel.Caption      := LMsg;
      pnlInfoSaleItemPriceLabel.Caption := EmptyStr;
    End;
  end;

  // Alterar Layout dos dados do Cliente
  const LHasCustomerFilled = (dtsSale.DataSet.FieldByName('person_id').AsInteger > 0) and (dtsSale.DataSet.FieldByName('person_name').AsString.Trim > EmptyStr);
  case LHasCustomerFilled of
    True: Begin
      if pnlWelcome.Height <> 318 then
        pnlWelcome.Height := 318;
    End;
    False: Begin
      if pnlWelcome.Height <> 195 then
        pnlWelcome.Height := 195;
    End;
  end;
end;

end.
