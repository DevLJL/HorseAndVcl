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
  uZLMemTable.Interfaces;

type
  TSaleInputView = class(TBaseInputView)
    dtsSale: TDataSource;
    dtsSaleItems: TDataSource;
    Label22: TLabel;
    Label37: TLabel;
    Label10: TLabel;
    Label4: TLabel;
    Label2: TLabel;
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
    Panel2: TPanel;
    Panel6: TPanel;
    dbgSaleItems: TDBGrid;
    Panel9: TPanel;
    Label8: TLabel;
    Label15: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    imgsale_item_append: TImage;
    Label1: TLabel;
    Panel10: TPanel;
    Panel11: TPanel;
    imgsale_item_loca_product: TImage;
    edtsale_item_id: TEdit;
    edtsale_item_name: TEdit;
    edtsale_item_price: TNumberBox;
    edtsale_item_quantity: TNumberBox;
    edtsale_item_total: TNumberBox;
    Panel15: TPanel;
    Image1: TImage;
    Panel25: TPanel;
    Panel26: TPanel;
    Label17: TLabel;
    edtsum_sale_item_quantity: TDBEdit;
    Panel29: TPanel;
    Panel30: TPanel;
    Label6: TLabel;
    edtsum_sale_item_total: TDBEdit;
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
    edttotal: TDBEdit;
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
  private
    FViewModel: ISaleViewModel;
    FHandleResult: TSaleShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    FProductShowDTOSelected: SH<TProductShowDTO>;
    FPayments: IZLMemTable;
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
  uNotificationView,
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
  uProduct.Index.View,
  uPayment.Show.DTO,
  uPayment.Service,
  uPaymentTerm.Locate.View,
  System.DateUtils, uSalePayment.Input.View, uPayment.Filter.DTO;

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

    NotificationView.Execute(Trans.RecordDeleted, tneError);
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
    NotificationView.Execute(Trans.RecordDeleted, tneError);
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
    NotificationView.Execute(Trans.RecordDeleted, tneError);
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
          LSaved := TSaleService.Make.UpdateAndShow(FEditPK, LSaleInputDTO);
          if LSaved.Match and LGenerateBillingAtTheEnd then
          begin
            LSaved.Right.Free; // Evitar MemoryLeak
            LSaved := TSaleService.Make.GenerateBilling(FEditPK, TSaleGenerateBillingOperation.Approve);
          end;
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
          NotificationView.Execute(Trans.RecordValidationFailed, tneError);
          Exit;
        end;

        // Retornar registro inserido/atualizado
        NotificationView.Execute(Trans.RecordSaved, tneSuccess);
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
  inherited;

  // Produto
  if (Sender = edtsale_item_id) then
  begin
    FProductShowDTOSelected := TProductService.Make.Show(StrInt(edtsale_item_id.Text));
    if not Assigned(FProductShowDTOSelected.Value) then
    begin
      edtsale_item_id.Text          := EmptyStr;
      edtsale_item_name.Text        := EmptyStr;
      edtsale_item_quantity.ValueFloat := 0;
      edtsale_item_price.ValueFloat    := 0;
      edtsale_item_total.ValueFloat    := 0;
      Exit;
    end;

    // Carregar com dados encontrados
    With FProductShowDTOSelected.Value do
    begin
      edtsale_item_id.Text          := id.ToString;
      edtsale_item_name.Text        := name;
      edtsale_item_quantity.ValueFloat := 1;
      edtsale_item_price.ValueFloat    := price;
      edtsale_item_total.ValueFloat    := price;
    end;
    Exit;
  end;

  // Calcular valor do produto
  if (Sender = edtsale_item_quantity) or (Sender = edtsale_item_price) then
  begin
    edtsale_item_total.ValueFloat := edtsale_item_quantity.ValueFloat * edtsale_item_price.ValueFloat;
  end;
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
  pgc.ActivePageIndex           := 0;
  tmrAllowSave.Enabled          := True;
  tmrAllowSaveTimer(tmrAllowSave);
  LoadPayments;
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

  // F6 - Salvar
  if ((Key = VK_F6) and pnlSave.Visible) then
  begin
    btnSaveClick(btnSave);
    Exit;
  end;

  // F1 - Localizar Vendedor
  if (Key = VK_F1) and (edtseller_id.Focused or edtseller_name.Focused) then
  begin
    imgLocaSellerClick(imgLocaSeller);
    Exit;
  end;

  // F1 - Localizar Cliente
  if (Key = VK_F1) and (edtperson_id.Focused or edtperson_name.Focused) then
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

procedure TSaleInputView.imgLocaPersonClick(Sender: TObject);
begin
  if edtperson_name.CanFocus then edtperson_name.SetFocus;
  const LPk = TPersonIndexView.HandleLocate({TPersonFormFilter.fpCustomer});
  if (LPk > 0) then
    dtsSale.DataSet.FieldByName('person_id').Text := LPk.ToString;
end;

procedure TSaleInputView.imgLocaSellerClick(Sender: TObject);
begin
  if edtseller_name.CanFocus then edtseller_name.SetFocus;
  const LPk = TPersonIndexView.HandleLocate({TPersonFormFilter.fpSelle^});
  if (LPk > 0) then
    dtsSale.DataSet.FieldByName('seller_id').Text := LPk.ToString
end;

procedure TSaleInputView.imgsale_item_appendClick(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsSale.DataSet) and dtsSale.DataSet.Active and Assigned(dtsSaleItems.DataSet) and dtsSaleItems.DataSet.Active;
  if not LKeepGoing then
    Exit;

  try
    LockControl(pnlBackground);

    var LErrors := EmptyStr;
    if not Assigned(FProductShowDTOSelected.Value) then
      LErrors := LErrors + 'Produto/Servi�o n�o foi selecionado.' + #13;
    if String(edtsale_item_id.Text).Trim.IsEmpty then
      LErrors := LErrors + 'Campo [ID] � obrigat�rio.' + #13;
    if (edtsale_item_quantity.ValueFloat <= 0) then
      LErrors := LErrors + 'Campo [Quantidade] � obrigat�rio.' + #13;
    if not LErrors.Trim.IsEmpty then
    begin
      TAlertView.Handle(LErrors);
      Exit;
    end;

    With dtsSaleItems.DataSet do
    begin
      Append;
      FieldByName('product_id').AsLargeInt      := StrInt64(edtsale_item_id.Text);
      FieldByName('quantity').AsFloat           := edtsale_item_quantity.ValueFloat;
      FieldByName('price').AsFloat              := edtsale_item_price.ValueFloat;
      FieldByName('unit_discount').AsFloat      := 0;
      FieldByName('seller_id').AsLargeInt       := StrInt64(edtseller_id.Text);
      FieldByName('note').AsString              := EmptyStr;
      FieldByName('product_name').AsString      := FProductShowDTOSelected.Value.name; {virtual}
      FieldByName('product_unit_name').AsString := FProductShowDTOSelected.Value.unit_name; {virtual}
      Post;
    end;
  finally
    edtsale_item_id.Text             := EmptyStr;
    edtsale_item_name.Text           := EmptyStr;
    edtsale_item_quantity.ValueFloat := 1;
    edtsale_item_price.ValueFloat    := 0;
    edtsale_item_total.ValueFloat    := 0;
    UnLockControl(pnlBackground);
    if edtsale_item_id.CanFocus then
      edtsale_item_id.SetFocus;
  end;
end;

procedure TSaleInputView.imgsale_item_loca_productClick(Sender: TObject);
begin
  if edtsale_item_name.CanFocus then edtsale_item_name.SetFocus;
  const LPk = TProductIndexView.HandleLocate;
  if (LPk > 0) then
  Begin
    edtsale_item_id.Text := LPk.ToString;
    EdtFieldExit(edtsale_item_id);
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
