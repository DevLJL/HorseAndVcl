unit uSalePayment.Input.View;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
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
  JvExComCtrls,
  JvComCtrls,
  JvExMask,
  JvToolEdit,
  JvDBControls,
  uAppVcl.Types,
  uZLMemTable.Interfaces,
  uSale.ViewModel.Interfaces;

type
  TSalePaymentInputView = class(TBaseInputView)
    dtsSalePayment: TDataSource;
    Label10: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label12: TLabel;
    Label22: TLabel;
    Label1: TLabel;
    Label7: TLabel;
    edtpayment_name: TDBEdit;
    Panel4: TPanel;
    Panel5: TPanel;
    imgLocaPayment: TImage;
    edtpayment_id: TDBEdit;
    edtbank_account_name: TDBEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    imgLocaBankAccount: TImage;
    edtbank_account_id: TDBEdit;
    edtdue_date: TJvDBDateEdit;
    edtamount: TDBEdit;
    memnote: TDBMemo;
    Panel3: TPanel;
    Panel6: TPanel;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
    procedure edttotalKeyPress(Sender: TObject; var Key: Char);
    procedure imgLocaPaymentClick(Sender: TObject);
    procedure imgLocaBankAccountClick(Sender: TObject);
  private
    FState: TEntityState;
    FViewModel: ISaleViewModel;
    FViewModelBackup: IZLMemTable;
    FViewModelBackupRecNumber: Integer;
    procedure BeforeShow;
    function ValidateCurrentSalePayment: String;
  public
    class function Handle(AState: TEntityState; AViewModel: ISaleViewModel): Integer;
  end;

const
  TITLE_NAME = 'Venda > Pagamento';

implementation

uses
  Vcl.Dialogs,
  uHandle.Exception,
  uAlert.View,
  uMemTable.Factory,
  uHlp,
  uTrans,
  uSmartPointer,
  uBankAccount.Index.View,
  uPayment.Index.View;

{$R *.dfm}

{ TSalePaymentInputView }

procedure TSalePaymentInputView.BeforeShow;
begin
  // Efetua uma cópia para restaurar se necessário
  dtsSalePayment.DataSet := FViewModel.SalePayments.DataSet;
  FViewModelBackup.FromDataSet(dtsSalePayment.DataSet);
  FViewModelBackupRecNumber := dtsSalePayment.DataSet.RecNo;

  // Iniciar Loading
  Try
    LoadingForm              := True;
    pnlBackground.Enabled    := False;
    pgc.Visible              := False;
    dtsSalePayment.DataSet := nil;

    case FState of
      TEntityState.Store: Begin
        lblTitle.Caption := TITLE_NAME + ' (Incluindo...)';
        FViewModel.SalePayments.DataSet.Append;
      end;
      TEntityState.Update,
      TEntityState.View: Begin
        lblTitle.Caption := TITLE_NAME + ' (Editando...)';
        FViewModel.SalePayments.DataSet.Edit;
      end;
    end;
  finally
    // Encerrar Loading
    LoadingForm              := false;
    pnlBackground.Enabled    := True;
    pgc.Visible              := True;
    dtsSalePayment.DataSet := FViewModel.SalePayments.DataSet;
    if edtamount.CanFocus then
      edtamount.SetFocus;
  end;
end;

procedure TSalePaymentInputView.btnCancelClick(Sender: TObject);
begin
  inherited;

  // Cancelar Operação
  case FState of
    TEntityState.Store: Begin
      case dtsSalePayment.DataSet.State of
        dsInsert: dtsSalePayment.DataSet.Cancel;
        dsBrowse: dtsSalePayment.DataSet.Delete;
        dsEdit: Begin
          dtsSalePayment.DataSet.Cancel;
          dtsSalePayment.DataSet.Delete;
        end;
      end;
    end;
    TEntityState.Update: Begin
      // Restaurar dados anteriores (Evita erros)
      FViewModelBackup.DataSet.First;
      for var lI := 2 to FViewModelBackupRecNumber do
        FViewModelBackup.DataSet.Next;
      dtsSalePayment.DataSet.Edit;
      for var lI := 0 to Pred(dtsSalePayment.DataSet.Fields.Count) do
        dtsSalePayment.DataSet.Fields[lI].Value := FViewModelBackup.DataSet.FieldByName(dtsSalePayment.DataSet.Fields[lI].FieldName).Value;
      dtsSalePayment.DataSet.Post;
    end;
  end;

  ModalResult := MrCancel;
end;

procedure TSalePaymentInputView.btnSaveClick(Sender: TObject);
begin
  btnFocus.SetFocus;
  Try
    // Ativar Loading
    LoadingSave := True;

    // Sempre salvar dataset para evitar erros
    if FViewModel.SalePayments.DataSet.State in [dsInsert, dsEdit] then
      FViewModel.SalePayments.DataSet.Post;

    // Validar dados
    const LErrors = ValidateCurrentSalePayment;
    if not LErrors.Trim.IsEmpty then
    begin
      TAlertView.Handle(LErrors);
      FViewModel.SalePayments.DataSet.Edit;
      Abort;
    end;

    ModalResult := mrOk;
  Finally
    LoadingSave := False;
  End;
end;

procedure TSalePaymentInputView.edttotalKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if (key = #13) then
    btnSaveClick(btnSave);
end;

procedure TSalePaymentInputView.FormCreate(Sender: TObject);
begin
  inherited;
  FViewModelBackup := TMemTableFactory.Make;
  tmrAllowSave.Enabled := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TSalePaymentInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  // Esc - Sair
  if (Key = VK_ESCAPE) then
  begin
    btnCancelClick(btnCancel);
    Exit;
  end;

  // F6 - Salvar
  if (Key = VK_F6) then
  begin
    btnSaveClick(btnSave);
    Exit;
  end;

  // F1 - Localizar Pagamento
  if (Key = VK_F1) and (edtpayment_id.Focused or edtpayment_name.Focused) then
  begin
    imgLocaPaymentClick(imgLocaPayment);
    Exit;
  end;

  // F1 - Localizar Conta Bancária
  if (Key = VK_F1) and (edtbank_account_id.Focused or edtbank_account_name.Focused) then
  begin
    imgLocaBankAccountClick(imgLocaBankAccount);
    Exit;
  end;
end;

procedure TSalePaymentInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TSalePaymentInputView.Handle(AState: TEntityState; AViewModel: ISaleViewModel): Integer;
begin
  const LView: SH<TSalePaymentInputView> = TSalePaymentInputView.Create(nil);
  LView.Value.FState     := AState;
  LView.Value.FViewModel := AViewModel;
  Result                 := LView.Value.ShowModal;
end;

procedure TSalePaymentInputView.imgLocaBankAccountClick(Sender: TObject);
begin
  const LPk = TBankAccountIndexView.HandleLocate;
  if (LPk > 0) then
    dtsSalePayment.DataSet.FieldByName('bank_account_id').Text := LPk.ToString;
end;

procedure TSalePaymentInputView.imgLocaPaymentClick(Sender: TObject);
begin
  const LPk = TPaymentIndexView.HandleLocate;
  if (LPk > 0) then
    dtsSalePayment.DataSet.FieldByName('payment_id').Text := LPk.ToString;
end;

procedure TSalePaymentInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (StrInt(edtpayment_id.Text) > 0) and (StrInt(edtbank_account_id.Text) > 0) and
                 (edtdue_date.Date > 0) and (StrFloat(edtamount.Text) > 0);
  inherited;
end;

function TSalePaymentInputView.ValidateCurrentSalePayment: String;
begin
  var LErrors := EmptyStr;
  With dtsSalePayment.DataSet do
  begin
    if (FieldByName('payment_id').AsLargeInt <= 0) then
      LErrors := 'O campo [Pagamento] é obrigatório.' + #13;
    if (FieldByName('bank_account_id').AsLargeInt <= 0) then
      LErrors := 'O campo [Conta Bancária] é obrigatório.' + #13;
    if (FieldByName('due_date').AsDateTime <= 0) then
      LErrors := 'O campo [Vencimento] é obrigatório.' + #13;
    if (FieldByName('amount').AsFloat <= 0) then
      LErrors := 'O campo [Valor] é obrigatório.' + #13;
  end;

  Result := LErrors;
end;



end.
