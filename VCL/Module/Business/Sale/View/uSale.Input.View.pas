unit uSale.Input.View;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Forms,
  Data.DB,
  Vcl.StdCtrls,
  Vcl.Mask,
  Vcl.DBCtrls,
  Vcl.ComCtrls,
  Vcl.WinXCtrls,
  Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,
  Vcl.Controls,
  Vcl.Buttons,
  uBase.Input.View,
  Skia,
  Skia.Vcl,
  Vcl.Grids,
  Vcl.DBGrids,
  JvExDBGrids,
  JvExComCtrls,
  JvComCtrls,
  Vcl.NumberBox,
  uAppVcl.Types,
  uSale.ViewModel.Interfaces,
  uSmartPointer,
  uSale.Show.DTO,
  uProduct.Show.DTO,
  uZLMemTable.Interfaces,
  uProduct.Index.View;  

type
  TSaleInputView = class(TBaseInputView)
    dtsSale: TDataSource;
    dtsSaleItems: TDataSource;
    dtsSalePayments: TDataSource;
    TabSheet3: TTabSheet;
    Panel3: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Panel7: TPanel;
    edtsum_sale_item_total2: TDBEdit;
    edtdiscount: TDBEdit;
    edtincrease: TDBEdit;
    edtperc_discount: TDBEdit;
    edtperc_increase: TDBEdit;
    Panel8: TPanel;
    Panel16: TPanel;
    Panel14: TPanel;
    Panel17: TPanel;
    Panel20: TPanel;
    dbgSalePayments: TDBGrid;
    Panel21: TPanel;
    Label29: TLabel;
    imgsale_payment_append: TImage;
    Label21: TLabel;
    edtpayment_term_amount: TNumberBox;
    cbxPayment: TComboBox;
    Panel24: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    lblChange: TLabel;
    edtchange: TDBEdit;
    Panel22: TPanel;
    Panel23: TPanel;
    Label20: TLabel;
    edtsum_sale_payment_amount: TDBEdit;
    Panel27: TPanel;
    Panel28: TPanel;
    btnDeleteAllSalePayments: TSpeedButton;
    Panel31: TPanel;
    Image2: TImage;
    Panel32: TPanel;
    Label22: TLabel;
    Label37: TLabel;
    Label10: TLabel;
    Label4: TLabel;
    Panel5: TPanel;
    edtId: TDBEdit;
    edtperson_name: TDBEdit;
    Panel41: TPanel;
    Panel42: TPanel;
    imgLocaPerson: TImage;
    edtperson_id: TDBEdit;
    edtseller_name: TDBEdit;
    Panel4: TPanel;
    Panel1: TPanel;
    imgLocaSeller: TImage;
    edtseller_id: TDBEdit;
    pgcNote: TPageControl;
    TabSheet1: TTabSheet;
    Panel12: TPanel;
    DBMemo1: TDBMemo;
    TabSheet2: TTabSheet;
    Panel13: TPanel;
    DBMemo2: TDBMemo;
    Panel33: TPanel;
    Label2: TLabel;
    Panel9: TPanel;
    Label13: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Label18: TLabel;
    Label19: TLabel;
    DBEdit3: TDBEdit;
    edttotal: TDBEdit;
    Panel11: TPanel;
    Panel38: TPanel;
    Label1: TLabel;
    edtsale_item_quantity: TNumberBox;
    Panel39: TPanel;
    Panel40: TPanel;
    Label8: TLabel;
    Panel43: TPanel;
    imgsale_item_append: TImage;
    edtsale_item_id: TEdit;
    Panel6: TPanel;
    imgsale_item_loca_product: TImage;
    Panel10: TPanel;
    Panel36: TPanel;
    Label15: TLabel;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel15: TPanel;
    edtsum_sale_item_quantity: TDBEdit;
    Panel29: TPanel;
    edtsum_sale_item_total: TDBEdit;
    Label6: TLabel;
    Panel30: TPanel;
    Label17: TLabel;
    Image3: TImage;
    imgFinalValueInfo: TImage;
    Panel2: TPanel;
    dbgSaleItems: TDBGrid;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
    procedure btnSaleItemsEditClick(Sender: TObject);
    procedure btnSaleItemsDeleteClick(Sender: TObject);
    procedure imgLocaSellerClick(Sender: TObject);
    procedure imgLocaPersonClick(Sender: TObject);
    procedure imgsale_item_loca_productClick(Sender: TObject);
    procedure EdtFieldExit(Sender: TObject); override;
    procedure edtsale_item_totalKeyPress(Sender: TObject; var Key: Char);
    procedure imgsale_item_appendClick(Sender: TObject);
    procedure dbgSaleItemsCellClick(Column: TColumn);
    procedure dbgSaleItemsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure EdtFieldEnter(Sender: TObject); override;
    procedure edtpayment_term_amountKeyPress(Sender: TObject; var Key: Char);
    procedure imgsale_payment_appendClick(Sender: TObject);
    procedure btnDeleteAllSalePaymentsClick(Sender: TObject);
    procedure edtchangeChange(Sender: TObject);
    procedure dbgSalePaymentsCellClick(Column: TColumn);
    procedure btnSalePaymentsEditClick(Sender: TObject);
    procedure btnSalePaymentsDeleteClick(Sender: TObject);
    procedure dbgSalePaymentsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgSaleItemsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TabSheet3Show(Sender: TObject);
    procedure tabMainShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtsale_item_idKeyPress(Sender: TObject; var Key: Char);
    procedure Image3Click(Sender: TObject);
    procedure imgFinalValueInfoClick(Sender: TObject);
  private
    FViewModel: ISaleViewModel;
    FHandleResult: TSaleShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    FProductShowDTOSelected: SH<TProductShowDTO>;
    FPayments: IZLMemTable;
    FProductIndexView: TProductIndexView;
    FProductInitialSearchContent: String;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
    procedure LoadPayments;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0): TSaleShowDTO;
  end;

const
  TITLE_NAME = 'Venda';
  MARGIN_OF_ERROR = 0.01;

implementation

{$R *.dfm}

uses
  uToast.View,
  Quick.Threads,
  Vcl.Dialogs,
  uHandle.Exception,
  uAlert.View,
  uDTM,
  uYesOrNo.View,
  uEither,
  uApplicationError.View,
  uTrans,
  uSale.Input.DTO,
  uSale.ViewModel,
  uSale.Service,
  uHlp,
  uSaleItem.Input.View,
  uIndexResult,
  uBankAccount.Index.View,
  uPerson.Index.View,
  System.Math,
  uSale.Types,
  uProduct.Service,
  uPayment.Show.DTO,
  uPayment.Service,
  uPaymentTerm.Locate.View,
  System.DateUtils,
  uSalePayment.Input.View,
  uPayment.Filter.DTO, uProduct.Types, uInfo.View;

{ TSaleInputView }
procedure TSaleInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm             := True;
  dtsSale.DataSet         := nil;
  dtsSaleItems.DataSet    := nil;
  dtsSalePayments.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TSaleViewModel.Make;
      case FState of
        TEntityState.Store: FViewModel.Sale.Append;
        TEntityState.Update,
        TEntityState.View: Begin
          const LSaleShowDTO: SH<TSaleShowDTO> = TSaleService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LSaleShowDTO);
          FViewModel.Sale.Edit;
        end;
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
      if (FState = TEntityState.Store) then
      begin
        if edtseller_id.CanFocus then
          edtseller_id.SetFocus;
      end else
      begin
        if edtsale_item_id.CanFocus then
          edtsale_item_id.SetFocus;
      end;

      // Encerrar Loading
      LoadingForm             := False;
      dtsSale.DataSet         := FViewModel.Sale.DataSet;
      dtsSaleItems.DataSet    := FViewModel.SaleItems.DataSet;
      dtsSalePayments.DataSet := FViewModel.SalePayments.DataSet;
      if edtseller_id.CanFocus then
        edtseller_id.SetFocus;
    end)
  .Run;
end;

procedure TSaleInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TSaleInputView.btnDeleteAllSalePaymentsClick(Sender: TObject);
begin
  inherited;
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
    UnLockControl(pnlBackground);
  End;
end;

procedure TSaleInputView.btnSaleItemsDeleteClick(Sender: TObject);
begin
  // Mensagem de Sim/Não
  if not (TYesOrNoView.Handle(Trans.DoYouWantToDeleteSelectedRecord, Trans.Exclusion) = mrOK) then
    Exit;

  Try
    LockControl(pnlBackground);

    dtsSaleItems.DataSet.Delete;
    ToastView.Execute(Trans.RecordDeleted, tneError);
  Finally
    UnLockControl(pnlBackground);
  End;
end;

procedure TSaleInputView.btnSaleItemsEditClick(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsSaleItems.DataSet) and dtsSaleItems.DataSet.Active and (dtsSaleItems.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  Try
    LockControl(pnlBackground);

    // Incluir Novo Contato
    TSaleItemInputView.Handle(TEntityState.Update, FViewModel);
  Finally
    UnLockControl(pnlBackground);
  End;
end;

procedure TSaleInputView.btnSalePaymentsDeleteClick(Sender: TObject);
begin
  // Mensagem de Sim/Não
  if not (TYesOrNoView.Handle(Trans.DoYouWantToDeleteSelectedRecord, Trans.Exclusion) = mrOK) then
    Exit;

  Try
    LockControl(pnlBackground);

    dtsSalePayments.DataSet.Delete;
    ToastView.Execute(Trans.RecordDeleted, tneError);
  Finally
    UnLockControl(pnlBackground);
  End;
end;

procedure TSaleInputView.btnSalePaymentsEditClick(Sender: TObject);
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

procedure TSaleInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TSaleShowDTO>;
begin
  inherited;
  if not pnlSave.Visible then
    Exit;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Lançar pagamento posicionado se não tiver nenhum informado
  if (dtsSalePayments.DataSet.RecordCount <= 0) and (dtsSale.DataSet.FieldByName('total').AsFloat > 0) then
  begin
    edtpayment_term_amount.ValueFloat := dtsSale.DataSet.FieldByName('total').AsFloat;
    imgsale_payment_appendClick(imgsale_payment_append);
  end;

  // Sempre salvar dataset para evitar erros
  if FViewModel.Sale.State in [dsInsert, dsEdit] then
  begin
    FViewModel.Sale.FieldByName('money_received').AsFloat := FViewModel.Sale.FieldByName('sum_sale_payment_amount').AsFloat;
    FViewModel.Sale.FieldByName('money_change').AsFloat   := FViewModel.Sale.FieldByName('remaining_change').AsFloat;
    FViewModel.Sale.Post;
  end;

  // Se estiver com status pendente ao atualizar, perguntar se deseja faturar ao termino da atualização da venda
  var LGenerateBillingAtTheEnd := False;
  if (FState = TEntityState.Update) and (TSaleStatus(dtsSale.DataSet.FieldByName('status').AsInteger) = TSaleStatus.Pending) then
    LGenerateBillingAtTheEnd := (TYesOrNoView.Handle('Deseja faturar pedido após atualização?', 'Faturar') = mrOK);

  // Iniciar Loading
  LoadingSave             := True;
  LoadingForm             := True;
  dtsSale.DataSet         := nil;
  dtsSaleItems.DataSet    := nil;
  dtsSalePayments.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LSaleInputDTO: SH<TSaleInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TSaleService.Make.StoreAndGenerateBilling(LSaleInputDTO);
        TEntityState.Update: Begin
          LSaved := TSaleService.Make.UpdateAndShow(FEditPK, LSaleInputDTO, False);
          if LSaved.Match and LGenerateBillingAtTheEnd then
            LSaved := TSaleService.Make.GenerateBilling(FEditPK, TSaleGenerateBillingOperation.Approve);
        End;
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

          FViewModel.Sale.Edit;
          ToastView.Execute(Trans.RecordValidationFailed, tneError);
          Exit;
        end;

        // Retornar registro inserido/atualizado
        ToastView.Execute(Trans.RecordSaved, tneSuccess);
        FHandleResult := LSaved.Right;
        ModalResult   := MrOK;
      finally
        // Encerrar Loading
        LoadingSave             := False;
        LoadingForm             := False;
        dtsSale.DataSet         := FViewModel.Sale.DataSet;
        dtsSaleItems.DataSet    := FViewModel.SaleItems.DataSet;
        dtsSalePayments.DataSet := FViewModel.SalePayments.DataSet;
      end;
    end)
  .Run;
end;

procedure TSaleInputView.dbgSaleItemsCellClick(Column: TColumn);
begin
  inherited;
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

procedure TSaleInputView.dbgSaleItemsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
Var
  lI: Integer;
  lKeepGoing: Boolean;
begin
  inherited;
  lKeepGoing := Assigned(dtsSaleItems.DataSet) and (dtsSaleItems.DataSet.Active) and (dtsSaleItems.DataSet.RecordCount > 0);
  if not lKeepGoing then
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

procedure TSaleInputView.dbgSaleItemsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  // Focus em ID do Produto
  If (Shift = [ssShift]) and (Key = VK_TAB) then
  Begin
    if edtsale_item_id.CanFocus then
      edtsale_item_id.SetFocus;
    Key := 0;
  End;
end;

procedure TSaleInputView.dbgSalePaymentsCellClick(Column: TColumn);
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

procedure TSaleInputView.dbgSalePaymentsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
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

procedure TSaleInputView.edtchangeChange(Sender: TObject);
begin
  inherited;
  const LKeepGoing = Assigned(dtsSale.DataSet) and (dtsSale.DataSet.State in [dsInsert, dsEdit]);
  if not LKeepGoing then
    Exit;

  case (dtsSale.DataSet.FieldByName('remaining_change').AsFloat < 0) of
    True:  lblChange.Caption := 'Faltante:';
    False: lblChange.Caption := 'Troco:';
  end;
end;

procedure TSaleInputView.EdtFieldEnter(Sender: TObject);
begin
  inherited;
  if (Sender = edtpayment_term_amount) then
  begin
    case (dtsSale.DataSet.FieldByName('remaining_change').AsCurrency < 0) of
      True:  edtpayment_term_amount.ValueFloat := Abs(dtsSale.DataSet.FieldByName('remaining_change').AsCurrency);
      False: edtpayment_term_amount.ValueFloat := 0;
    end;
    edtpayment_term_amount.SelectAll;
  end;
end;

procedure TSaleInputView.EdtFieldExit(Sender: TObject);
begin
  if ((Sender = edtsale_item_id) or (Sender = edtsale_item_quantity)) then
  begin
    if (Sender is TEdit)      then TEdit(Sender).Color := $00FCFBF8;  
    if (Sender is TNumberbox) then TNumberbox(Sender).Color := $00FCFBF8;  
  end else
    inherited;
end;

procedure TSaleInputView.edtpayment_term_amountKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key = #13) then
  begin
    case (edtpayment_term_amount.ValueFloat > 0) of
      True:  imgsale_payment_appendClick(imgsale_payment_append);
      False: btnSaveClick(btnSave);
    end;
  end;
end;

procedure TSaleInputView.edtsale_item_idKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    imgsale_item_appendClick(imgsale_item_append);
end;

procedure TSaleInputView.edtsale_item_totalKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key = #13) then
    imgsale_item_appendClick(imgsale_item_append);
end;

procedure TSaleInputView.FormCreate(Sender: TObject);
begin
  inherited;
  FitFormToScreen(Self);
  pgc.ActivePageIndex  := 0;
  tmrAllowSave.Enabled := True;
  tmrAllowSaveTimer(tmrAllowSave);
  LoadPayments;

  // Instanciar uma única vez pesquisa de itens
  FProductIndexView := TProductIndexView.Create(nil);
  FProductIndexView.SetLayoutLocate(False);  
end;

procedure TSaleInputView.FormDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FProductIndexView) then
    FProductIndexView.Free;
end;

procedure TSaleInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  // Esc - Sair
  if (Key = VK_ESCAPE) then
  begin
    btnCancelClick(btnCancel);
    Exit;
  end;

  // F1 - Alterar Quantidade
  if (Key = VK_F1) and (pgc.ActivePageIndex = 0) and edtsale_item_quantity.CanFocus then
  begin
    edtsale_item_quantity.SetFocus;
    edtsale_item_quantity.SelectAll;
    Exit;
  end;  

  // F2 - Localizar Item
  if ((Key = VK_F2) and (pgc.ActivePageIndex = 0)) then
  begin
    imgsale_item_loca_productClick(imgsale_item_loca_product);
    Exit;
  end;

  // F6 - Pagamento
  if ((Key = VK_F6) and (pgc.ActivePageIndex = 0)) then
  begin
    pgc.ActivePageIndex := 1;
    Exit;
  end;

  // F6 - Salvar
  if ((Key = VK_F6) and pnlSave.Visible and FormIsValid) then
  begin
    btnSaveClick(btnSave);
    Exit;
  end;

  // F4 - Localizar Vendedor
  if (Key = VK_F4) and (pgc.ActivePageIndex = 0) then
  begin
    imgLocaSellerClick(imgLocaSeller);
    Exit;
  end;

  // F5 - Localizar Cliente
  if (Key = VK_F5) and (pgc.ActivePageIndex = 0) then
  begin
    imgLocaPersonClick(imgLocaPerson);
    Exit;
  end;
end;

procedure TSaleInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TSaleInputView.Handle(AState: TEntityState; AEditPK: Int64): TSaleShowDTO;
begin
  Result := nil;
  const LView: SH<TSaleInputView> = TSaleInputView.Create(nil);
  LView.Value.EditPK := AEditPK;
  LView.Value.State  := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TSaleInputView.Image3Click(Sender: TObject);
begin
  TInfoView.Handle(
    'Você pode verificar os valores do item antes da inserção, independentemente da configuração realizada anteriormente.'+#13+
    'Para realizar esse processo: Pressione [SHIFT] + [ENTER] com o código do item já informado.'
  ); 
end;

procedure TSaleInputView.imgFinalValueInfoClick(Sender: TObject);
begin
  inherited;
  TInfoView.Handle(
    'O campo "TOTAL DOS ITENS" não contempla valores como acréscimos, descontos, fretes e outros. '+
    'Na aba de Pagamento, esses valores serão destacados individualmente, permitindo uma compreensão clara e facilitando a análise de cada campo calculado.'
  );
end;

procedure TSaleInputView.imgLocaPersonClick(Sender: TObject);
var
  LFilter: TPersonFormFilter;
begin
  if edtperson_name.CanFocus then edtperson_name.SetFocus;
  LFilter.flg_customer := TPersonFormFilterValue.Yes;
  const LPk = TPersonIndexView.HandleLocate(LFilter);
  if (LPk > 0) then
    dtsSale.DataSet.FieldByName('person_id').Text := LPk.ToString;
end;

procedure TSaleInputView.imgLocaSellerClick(Sender: TObject);
var
  LFilter: TPersonFormFilter;
begin
  if edtseller_name.CanFocus then edtseller_name.SetFocus;
  LFilter.flg_seller := TPersonFormFilterValue.Yes;
  const LPk = TPersonIndexView.HandleLocate(LFilter);
  if (LPk > 0) then
    dtsSale.DataSet.FieldByName('seller_id').Text := LPk.ToString
end;

procedure TSaleInputView.imgsale_item_appendClick(Sender: TObject);
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

procedure TSaleInputView.imgsale_item_loca_productClick(Sender: TObject);
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

procedure TSaleInputView.imgsale_payment_appendClick(Sender: TObject);
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

procedure TSaleInputView.LoadPayments;
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

procedure TSaleInputView.SetState(const Value: TEntityState);
begin
  FState := Value;

  case FState of
    TEntityState.Store:  lblTitle.Caption := TITLE_NAME + ' (Incluindo...)';
    TEntityState.Update: lblTitle.Caption := TITLE_NAME + ' (Editando...)';
    TEntityState.View: Begin
      lblTitle.Caption        := TITLE_NAME + ' (Visualizando...)';
      pnlTitle.Color          := clGray;
      pnlSave.Visible         := False;
      pnlCancel.Margins.Right := 0;
    end;
  end;
end;

procedure TSaleInputView.tabMainShow(Sender: TObject);
begin
  inherited;
  pnlBottomButtons.Visible := False;
end;

procedure TSaleInputView.TabSheet3Show(Sender: TObject);
begin
  inherited;
  pnlBottomButtons.Visible := True;
  EdtFieldEnter(edtpayment_term_amount);

  if cbxPayment.CanFocus then cbxPayment.SetFocus;
  if (dtsSalePayments.DataSet.RecordCount <= 0) then
  begin
    cbxPayment.ItemIndex   := 0;
    cbxPayment.DroppedDown := true;
  end;
end;

procedure TSaleInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  // Verificar se pagamento � igual ou superior ao total da venda
  const LPaymentTotal: Extended  = StrFloat(edtsum_sale_payment_amount.Text);
  const LSaleTotal: Extended     = StrFloat(edttotal.Text);
  const LPaymentIsGreaterOrEqual = RoundTo((LPaymentTotal+MARGIN_OF_ERROR) - LSaleTotal, -4) >= 0;

  FormIsValid := (StrInt(edtseller_id.Text) > 0) and
                 Assigned(dtsSaleItems.DataSet) and (dtsSaleItems.DataSet.Active) and (dtsSaleItems.DataSet.RecordCount > 0) and
                 Assigned(dtsSalePayments.DataSet) and (dtsSalePayments.DataSet.Active) and (dtsSalePayments.DataSet.RecordCount > 0) and
                 LPaymentIsGreaterOrEqual;
  inherited;
end;


end.
