unit uBillPayReceive.Input.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons, uBase.Input.View,
  Skia, Skia.Vcl, Vcl.Grids, Vcl.DBGrids, JvExDBGrids,  JvExComCtrls, JvComCtrls,

  uAppVcl.Types,
  uBillPayReceive.ViewModel.Interfaces,
  uSmartPointer,
  uBillPayReceive.Show.DTO, JvExMask, JvToolEdit, JvDBControls, JvExStdCtrls,
  JvCombobox, JvDBCombobox;

type
  TBillPayReceiveInputView = class(TBaseInputView)
    dtsBillPayReceive: TDataSource;
    Label22: TLabel;
    Label35: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Label37: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label20: TLabel;
    Label17: TLabel;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label10: TLabel;
    Panel5: TPanel;
    edtId: TDBEdit;
    edtshort_description: TDBEdit;
    cbxType: TJvDBComboBox;
    edtperson_name: TDBEdit;
    Panel41: TPanel;
    Panel42: TPanel;
    imgLocaPerson: TImage;
    edtperson_id: TDBEdit;
    edtchart_of_account_name: TDBEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    imgLocaChartOfAccount: TImage;
    edtchart_of_account_id: TDBEdit;
    edtcost_center_name: TDBEdit;
    Panel3: TPanel;
    Panel4: TPanel;
    imgLocaCostCenter: TImage;
    edtcost_center_id: TDBEdit;
    edtbank_account_name: TDBEdit;
    Panel6: TPanel;
    Panel7: TPanel;
    imgLocaBankAccount: TImage;
    edtbank_account_id: TDBEdit;
    edtpayment_name: TDBEdit;
    Panel8: TPanel;
    Panel9: TPanel;
    imgLocaPayment: TImage;
    edtpayment_id: TDBEdit;
    edtdue_date: TJvDBDateEdit;
    edtinstallment_quantity: TDBEdit;
    edtamount: TDBEdit;
    edtdiscount: TDBEdit;
    edtinterest_and_fine: TDBEdit;
    edtnet_amount: TDBEdit;
    JvDBComboBox2: TJvDBComboBox;
    JvDBDateEdit2: TJvDBDateEdit;
    DBMemo1: TDBMemo;
    Panel10: TPanel;
    Panel11: TPanel;
    edtinstallment_number: TDBEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
    procedure imgLocaChartOfAccountClick(Sender: TObject);
    procedure imgLocaPersonClick(Sender: TObject);
    procedure imgLocaCostCenterClick(Sender: TObject);
    procedure imgLocaBankAccountClick(Sender: TObject);
    procedure imgLocaPaymentClick(Sender: TObject);
  private
    FViewModel: IBillPayReceiveViewModel;
    FHandleResult: TBillPayReceiveShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0): TBillPayReceiveShowDTO;
  end;

const
  TITLE_NAME = 'Contas a Pagar/Receber';

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
  uBillPayReceive.Input.DTO,
  uBillPayReceive.ViewModel,
  uBillPayReceive.Service, uChartOfAccount.Index.View, uPerson.Index.View,
  uCostCenter.Index.View, uBankAccount.Index.View, uPayment.Index.View, uHlp;

{ TBillPayReceiveInputView }
procedure TBillPayReceiveInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm      := True;
  dtsBillPayReceive.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TBillPayReceiveViewModel.Make;
      case FState of
        TEntityState.Store: FViewModel.BillPayReceive.Append;
        TEntityState.Update,
        TEntityState.View: Begin
          const LBillPayReceiveShowDTO: SH<TBillPayReceiveShowDTO> = TBillPayReceiveService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LBillPayReceiveShowDTO);
          FViewModel.BillPayReceive.Edit;
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
      // Encerrar Loading
      LoadingForm      := false;
      dtsBillPayReceive.DataSet := FViewModel.BillPayReceive.DataSet;
      if cbxType.CanFocus then
        cbxType.SetFocus;
    end)
  .Run;
end;

procedure TBillPayReceiveInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TBillPayReceiveInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TBillPayReceiveShowDTO>;
begin
  inherited;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Sempre salvar dataset para evitar erros
  if FViewModel.BillPayReceive.State in [dsInsert, dsEdit] then
    FViewModel.BillPayReceive.Post;

  // Iniciar Loading
  LoadingSave      := True;
  LoadingForm      := True;
  dtsBillPayReceive.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LBillPayReceiveInputDTO: SH<TBillPayReceiveInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TBillPayReceiveService.Make.StoreAndShow(LBillPayReceiveInputDTO);
        TEntityState.Update: LSaved := TBillPayReceiveService.Make.UpdateAndShow(FEditPK, LBillPayReceiveInputDTO);
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

          FViewModel.BillPayReceive.Edit;
          ToastView.Execute(Trans.RecordValidationFailed, tneError);
          Exit;
        end;

        // Retornar registro inserido/atualizado
        ToastView.Execute(Trans.RecordSaved, tneSuccess);
        FHandleResult := LSaved.Right;
        ModalResult   := MrOK;
      finally
        // Encerrar Loading
        LoadingSave      := False;
        LoadingForm      := False;
        dtsBillPayReceive.DataSet := FViewModel.BillPayReceive.DataSet;
      end;
    end)
  .Run;
end;

procedure TBillPayReceiveInputView.FormCreate(Sender: TObject);
begin
  inherited;
  pgc.Pages[0].TabVisible := False;
  pgc.ActivePageIndex     := 0;
  tmrAllowSave.Enabled    := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TBillPayReceiveInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

  // F1 - Localizar ChartOfAccount
  if (Key = VK_F1) and (edtchart_of_account_id.Focused or edtchart_of_account_name.Focused) then
  begin
    imgLocaChartOfAccountClick(imgLocaChartOfAccount);
    Exit;
  end;

  // F1 - Localizar Person
  if (Key = VK_F1) and (edtperson_id.Focused or edtperson_name.Focused) then
  begin
    imgLocaPersonClick(imgLocaPerson);
    Exit;
  end;

  // F1 - Localizar CostCenter
  if (Key = VK_F1) and (edtcost_center_id.Focused or edtcost_center_name.Focused) then
  begin
    imgLocaCostCenterClick(imgLocaCostCenter);
    Exit;
  end;

  // F1 - Localizar BankAccount
  if (Key = VK_F1) and (edtbank_account_id.Focused or edtbank_account_name.Focused) then
  begin
    imgLocaBankAccountClick(imgLocaBankAccount);
    Exit;
  end;

  // F1 - Localizar Payment
  if (Key = VK_F1) and (edtpayment_id.Focused or edtpayment_name.Focused) then
  begin
    imgLocaPaymentClick(imgLocaPayment);
    Exit;
  end;
end;

procedure TBillPayReceiveInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TBillPayReceiveInputView.Handle(AState: TEntityState; AEditPK: Int64): TBillPayReceiveShowDTO;
begin
  Result := nil;
  const LView: SH<TBillPayReceiveInputView> = TBillPayReceiveInputView.Create(nil);
  LView.Value.EditPK := AEditPK;
  LView.Value.State  := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TBillPayReceiveInputView.imgLocaBankAccountClick(Sender: TObject);
begin
  inherited;
  const LPk = TBankAccountIndexView.HandleLocate;
  if (LPk > 0) then
    dtsBillPayReceive.DataSet.FieldByName('bank_account_id').Text := LPk.ToString;
end;

procedure TBillPayReceiveInputView.imgLocaChartOfAccountClick(Sender: TObject);
begin
  inherited;
  const LPk = TChartOfAccountIndexView.HandleLocate;
  if (LPk > 0) then
    dtsBillPayReceive.DataSet.FieldByName('chart_of_account_id').Text := LPk.ToString;
end;

procedure TBillPayReceiveInputView.imgLocaCostCenterClick(Sender: TObject);
begin
  inherited;
  const LPk = TCostCenterIndexView.HandleLocate;
  if (LPk > 0) then
    dtsBillPayReceive.DataSet.FieldByName('cost_center_id').Text := LPk.ToString;
end;

procedure TBillPayReceiveInputView.imgLocaPaymentClick(Sender: TObject);
begin
  inherited;
  const LPk = TPaymentIndexView.HandleLocate;
  if (LPk > 0) then
    dtsBillPayReceive.DataSet.FieldByName('payment_id').Text := LPk.ToString;
end;

procedure TBillPayReceiveInputView.imgLocaPersonClick(Sender: TObject);
begin
  inherited;
  const LPk = TPersonIndexView.HandleLocate;
  if (LPk > 0) then
    dtsBillPayReceive.DataSet.FieldByName('person_id').Text := LPk.ToString;
end;

procedure TBillPayReceiveInputView.SetState(const Value: TEntityState);
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

procedure TBillPayReceiveInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (cbxType.ItemIndex >= 0) and (String(edtshort_description.Text).Trim > '') and
              (String(edtbank_account_id.Text).Trim > '') and (String(edtpayment_id.Text).Trim > '') and
              (edtdue_date.date > 0) and (StrInt(edtinstallment_number.Text) > 0) and
              (StrInt(edtinstallment_quantity.Text) > 0) and (StrFloat(edtamount.Text) > 0);
  inherited;
end;

end.

