unit uCashFlowTransaction.Input.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons, uBase.Input.View,
  Skia, Skia.Vcl, JvExComCtrls, JvComCtrls,

  uAppVcl.Types,
  uZLMemTable.Interfaces,
  uCashFlow.ViewModel.Interfaces, JvExStdCtrls, JvCombobox, JvDBCombobox,
  JvExMask, JvToolEdit, JvDBControls;

type
  TCashFlowTransactionInputView = class(TBaseInputView)
    dtsCashFlowTransaction: TDataSource;
    Label22: TLabel;
    Label2: TLabel;
    Label10: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    Label6: TLabel;
    Label11: TLabel;
    Label26: TLabel;
    Panel5: TPanel;
    edthistory: TDBEdit;
    Panel1: TPanel;
    chkflg_manual_transaction: TDBCheckBox;
    edttransaction_date: TJvDBDateEdit;
    DBEdit1: TDBEdit;
    edtpayment_name: TDBEdit;
    Panel4: TPanel;
    Panel2: TPanel;
    imgLocaPayment: TImage;
    edtpayment_id: TDBEdit;
    edtperson_name: TDBEdit;
    Panel3: TPanel;
    Panel6: TPanel;
    imgLocaPerson: TImage;
    edtperson_id: TDBEdit;
    DBEdit4: TDBEdit;
    cbxType: TJvDBComboBox;
    memNote: TDBMemo;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
    procedure imgLocaPaymentClick(Sender: TObject);
    procedure imgLocaPersonClick(Sender: TObject);
  private
    FState: TEntityState;
    FViewModel: ICashFlowViewModel;
    FViewModelBackup: IZLMemTable;
    FViewModelBackupRecNumber: Integer;
    procedure BeforeShow;
    function ValidateCurrentCashFlowTransaction: String;
  public
    class function Handle(AState: TEntityState; AViewModel: ICashFlowViewModel): Integer;
  end;

const
  TITLE_NAME = 'Fluxo de Caixa > Contato';

implementation

uses
  Vcl.Dialogs,
  uHandle.Exception,
  uAlert.View,
  uMemTable.Factory,
  uHlp,
  uTrans,
  uSmartPointer, uPayment.Index.View, uPerson.Index.View;

{$R *.dfm}

{ TCashFlowTransactionInputView }

procedure TCashFlowTransactionInputView.BeforeShow;
begin
  // Efetua uma cópia para restaurar se necessário
  dtsCashFlowTransaction.DataSet := FViewModel.CashFlowTransactions.DataSet;
  FViewModelBackup.FromDataSet(dtsCashFlowTransaction.DataSet);
  FViewModelBackupRecNumber := dtsCashFlowTransaction.DataSet.RecNo;

  // Iniciar Loading
  Try
    LoadingForm              := True;
    pnlBackground.Enabled    := False;
    pgc.Visible              := False;
    dtsCashFlowTransaction.DataSet := nil;

    case FState of
      TEntityState.Store: Begin
        lblTitle.Caption := TITLE_NAME + ' (Incluindo...)';
        FViewModel.CashFlowTransactions.DataSet.Append;
      end;
      TEntityState.Update,
      TEntityState.View: Begin
        lblTitle.Caption := TITLE_NAME + ' (Editando...)';
        FViewModel.CashFlowTransactions.DataSet.Edit;
      end;
    end;
  finally
    // Encerrar Loading
    LoadingForm              := false;
    pnlBackground.Enabled    := True;
    pgc.Visible              := True;
    dtsCashFlowTransaction.DataSet := FViewModel.CashFlowTransactions.DataSet;
    if edttransaction_date.CanFocus then
      edttransaction_date.SetFocus;
  end;
end;

procedure TCashFlowTransactionInputView.btnCancelClick(Sender: TObject);
begin
  inherited;

  // Cancelar Operação
  case FState of
    TEntityState.Store: Begin
      case dtsCashFlowTransaction.DataSet.State of
        dsInsert: dtsCashFlowTransaction.DataSet.Cancel;
        dsBrowse: dtsCashFlowTransaction.DataSet.Delete;
        dsEdit: Begin
          dtsCashFlowTransaction.DataSet.Cancel;
          dtsCashFlowTransaction.DataSet.Delete;
        end;
      end;
    end;
    TEntityState.Update: Begin
      // Restaurar dados anteriores (Evita erros)
      FViewModelBackup.DataSet.First;
      for var lI := 2 to FViewModelBackupRecNumber do
        FViewModelBackup.DataSet.Next;
      dtsCashFlowTransaction.DataSet.Edit;
      for var lI := 0 to Pred(dtsCashFlowTransaction.DataSet.Fields.Count) do
        dtsCashFlowTransaction.DataSet.Fields[lI].Value := FViewModelBackup.DataSet.FieldByName(dtsCashFlowTransaction.DataSet.Fields[lI].FieldName).Value;
      dtsCashFlowTransaction.DataSet.Post;
    end;
  end;

  ModalResult := MrCancel;
end;

procedure TCashFlowTransactionInputView.btnSaveClick(Sender: TObject);
begin
  btnFocus.SetFocus;
  Try
    // Ativar Loading
    LoadingSave := True;

    // Sempre salvar dataset para evitar erros
    if FViewModel.CashFlowTransactions.DataSet.State in [dsInsert, dsEdit] then
      FViewModel.CashFlowTransactions.DataSet.Post;

    // Validar dados
    const LErrors = ValidateCurrentCashFlowTransaction;
    if not LErrors.Trim.IsEmpty then
    begin
      TAlertView.Handle(LErrors);
      FViewModel.CashFlowTransactions.DataSet.Edit;
      Abort;
    end;

    ModalResult := mrOk;
  Finally
    LoadingSave := False;
  End;
end;

procedure TCashFlowTransactionInputView.FormCreate(Sender: TObject);
begin
  inherited;
  FViewModelBackup := TMemTableFactory.Make;
  tmrAllowSave.Enabled := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TCashFlowTransactionInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

  // F1 - Localizar Pessoa
  if (Key = VK_F1) and (edtperson_id.Focused or edtperson_name.Focused) then
  begin
    imgLocaPersonClick(imgLocaPerson);
    Exit;
  end;
end;

procedure TCashFlowTransactionInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TCashFlowTransactionInputView.Handle(AState: TEntityState; AViewModel: ICashFlowViewModel): Integer;
begin
  const LView: SH<TCashFlowTransactionInputView> = TCashFlowTransactionInputView.Create(nil);
  LView.Value.FState     := AState;
  LView.Value.FViewModel := AViewModel;
  Result                 := LView.Value.ShowModal;
end;

procedure TCashFlowTransactionInputView.imgLocaPaymentClick(Sender: TObject);
begin
  inherited;
  const LPk = TPaymentIndexView.HandleLocate;
  if (LPk > 0) then
    dtsCashFlowTransaction.DataSet.FieldByName('payment_id').Text := LPk.ToString;
end;

procedure TCashFlowTransactionInputView.imgLocaPersonClick(Sender: TObject);
begin
  const LPk = TPersonIndexView.HandleLocate;
  if (LPk > 0) then
    dtsCashFlowTransaction.DataSet.FieldByName('person_id').Text := LPk.ToString
end;

procedure TCashFlowTransactionInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (edttransaction_date.Date > 0) and (String(edthistory.Text).Trim > '') and
                 (StrInt(edtpayment_id.Text) > 0) and (String(edtpayment_name.Text).Trim > '') and
                 (String(cbxType.Text).Trim > '');
  inherited;
end;

function TCashFlowTransactionInputView.ValidateCurrentCashFlowTransaction: String;
begin
  var lErrors := EmptyStr;
  With dtsCashFlowTransaction.DataSet do
  begin
    if (FieldByName('transaction_date').AsDateTime <= 0) then
      lErrors := lErrors + 'O campo [Data] é obrigatório.' + #13;

    if FieldByName('history').AsString.Trim.IsEmpty then
      lErrors := lErrors + 'O campo [Histórico] é obrigatório.' + #13;

    if (FieldByName('payment_id').AsLargeInt <= 0) then
      lErrors := lErrors + 'O campo [Pagamento] é obrigatório.' + #13;

    if not (FieldByName('type').AsInteger in [0,1]) then
      lErrors := lErrors + 'O campo [Tipo] é obrigatório.' + #13;
  end;

  Result := lErrors;
end;


end.

