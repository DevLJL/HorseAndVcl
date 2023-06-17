unit uPayment.Input.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons, uBase.Input.View,
  Skia, Skia.Vcl, Vcl.Grids, Vcl.DBGrids, JvExDBGrids,  JvExComCtrls, JvComCtrls,

  uAppVcl.Types,
  uPayment.ViewModel.Interfaces,
  uSmartPointer,
  uPayment.Show.DTO,
  Vcl.NumberBox;

type
  TPaymentInputView = class(TBaseInputView)
    dtsPayment: TDataSource;
    dtsPaymentTerms: TDataSource;
    Label35: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    imgPaymentTermListAdd: TImage;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label23: TLabel;
    Label13: TLabel;
    edtId: TDBEdit;
    Panel1: TPanel;
    edtname: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    dbgPaymentTermList: TDBGrid;
    Panel2: TPanel;
    edtDescription: TEdit;
    edtNumberOfInstallments: TNumberBox;
    edtIntervalBetweenInstallments: TNumberBox;
    edtFirstIn: TNumberBox;
    edtbank_account_default_id: TDBEdit;
    Panel10: TPanel;
    Panel12: TPanel;
    imgLocaBankAccountDefault: TImage;
    edtbank_account_default_name: TDBEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
    procedure btnPaymentTermsEditClick(Sender: TObject);
    procedure btnPaymentTermsDeleteClick(Sender: TObject);
    procedure imgLocaBankAccountDefaultClick(Sender: TObject);
    procedure imgPaymentTermListAddClick(Sender: TObject);
    procedure edtFirstInKeyPress(Sender: TObject; var Key: Char);
    procedure dbgPaymentTermListCellClick(Column: TColumn);
    procedure dbgPaymentTermListDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
  private
    FViewModel: IPaymentViewModel;
    FHandleResult: TPaymentShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0): TPaymentShowDTO;
  end;

const
  TITLE_NAME = 'Pagamento';

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
  uPayment.Input.DTO,
  uPayment.ViewModel,
  uPayment.Service,
  uHlp,
  uPaymentTerm.Input.View,
  uIndexResult,
  uBankAccount.Index.View;

{ TPaymentInputView }
procedure TPaymentInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm             := True;
  dtsPayment.DataSet      := nil;
  dtsPaymentTerms.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TPaymentViewModel.Make;
      case FState of
        TEntityState.Store: FViewModel.Payment.Append;
        TEntityState.Update,
        TEntityState.View: Begin
          const LPaymentShowDTO: SH<TPaymentShowDTO> = TPaymentService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LPaymentShowDTO);
          FViewModel.Payment.Edit;
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
      LoadingForm             := False;
      dtsPayment.DataSet      := FViewModel.Payment.DataSet;
      dtsPaymentTerms.DataSet := FViewModel.PaymentTerms.DataSet;
      if edtName.CanFocus then
        edtName.SetFocus;
    end)
  .Run;
end;

procedure TPaymentInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TPaymentInputView.btnPaymentTermsDeleteClick(Sender: TObject);
begin
  // Mensagem de Sim/Não
  if not (TYesOrNoView.Handle(Trans.DoYouWantToDeleteSelectedRecord, Trans.Exclusion) = mrOK) then
    Exit;

  Try
    LockControl(pnlBackground);

    dtsPaymentTerms.DataSet.Delete;
    ToastView.Execute(Trans.RecordDeleted, tneError);
  Finally
    UnLockControl(pnlBackground);
  End;
end;

procedure TPaymentInputView.btnPaymentTermsEditClick(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsPaymentTerms.DataSet) and dtsPaymentTerms.DataSet.Active and (dtsPaymentTerms.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  Try
    LockControl(pnlBackground);

    // Incluir Novo Contato
    TPaymentTermInputView.Handle(TEntityState.Update, FViewModel);
  Finally
    UnLockControl(pnlBackground);
  End;
end;

procedure TPaymentInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TPaymentShowDTO>;
begin
  inherited;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Sempre salvar dataset para evitar erros
  if FViewModel.Payment.State in [dsInsert, dsEdit] then
    FViewModel.Payment.Post;

  // Iniciar Loading
  LoadingSave             := True;
  LoadingForm             := True;
  dtsPayment.DataSet      := nil;
  dtsPaymentTerms.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LPaymentInputDTO: SH<TPaymentInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TPaymentService.Make.StoreAndShow(LPaymentInputDTO);
        TEntityState.Update: LSaved := TPaymentService.Make.UpdateAndShow(FEditPK, LPaymentInputDTO);
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

          FViewModel.Payment.Edit;
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
        dtsPayment.DataSet      := FViewModel.Payment.DataSet;
        dtsPaymentTerms.DataSet := FViewModel.PaymentTerms.DataSet;
      end;
    end)
  .Run;
end;

procedure TPaymentInputView.dbgPaymentTermListCellClick(Column: TColumn);
begin
  const LKeepGoing = Assigned(dtsPaymentTerms.DataSet) and dtsPaymentTerms.DataSet.Active and (dtsPaymentTerms.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  // Deletar
  if (AnsiLowerCase(Column.FieldName) = 'action_delete') then
    btnPaymentTermsDeleteClick(dbgPaymentTermList);
end;

procedure TPaymentInputView.dbgPaymentTermListDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  const LKeepGoing = Assigned(dtsPaymentTerms.DataSet) and (dtsPaymentTerms.DataSet.Active) and (dtsPaymentTerms.DataSet.RecordCount > 0);
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

procedure TPaymentInputView.edtFirstInKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if (Key = #13) then
    imgPaymentTermListAddClick(imgPaymentTermListAdd);
end;

procedure TPaymentInputView.FormCreate(Sender: TObject);
begin
  inherited;
  pgc.ActivePageIndex           := 0;
  tmrAllowSave.Enabled          := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TPaymentInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

  // F1 - Localizar Conta Bancária Default
  if (Key = VK_F1) and (edtbank_account_default_id.Focused or edtbank_account_default_name.Focused) then
  begin
    imgLocaBankAccountDefaultClick(imgLocaBankAccountDefault);
    Exit;
  end;
end;

procedure TPaymentInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TPaymentInputView.Handle(AState: TEntityState; AEditPK: Int64): TPaymentShowDTO;
begin
  Result := nil;
  const LView: SH<TPaymentInputView> = TPaymentInputView.Create(nil);
  LView.Value.EditPK := AEditPK;
  LView.Value.State  := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TPaymentInputView.imgLocaBankAccountDefaultClick(Sender: TObject);
begin
  const LPk = TBankAccountIndexView.HandleLocate;
  if (lPk > 0) then
    dtsPayment.DataSet.FieldByName('bank_account_default_id').Text := lPk.ToString;
end;

procedure TPaymentInputView.imgPaymentTermListAddClick(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsPayment.DataSet) and (dtsPayment.DataSet.State in [dsInsert, dsEdit])
                and Assigned(dtsPaymentTerms.DataSet) and dtsPaymentTerms.DataSet.Active;
  if not LKeepGoing then
    Exit;

  // Verificar campos antes de inserir
  var LErrors := EmptyStr;
  if String(edtDescription.Text).Trim.IsEmpty then
    LErrors := 'Campo "Descrição" é obrigatório.' + #13;
  if (edtNumberOfInstallments.ValueInt < 1) then
    LErrors := 'Campo "Parcelas" precisa ser maior que "ZERO".' + #13;
  if not LErrors.Trim.IsEmpty then
  begin
    TAlertView.Handle(LErrors);
    Abort;
  end;

  // Inserir dados
  try
    LockControl(pnlBackground);

    With dtsPaymentTerms.DataSet do
    begin
      Append;
      FieldByName('description').AsString                    := edtDescription.Text;
      FieldByName('number_of_installments').AsInteger        := edtNumberOfInstallments.ValueInt;
      FieldByName('interval_between_installments').AsInteger := edtIntervalBetweenInstallments.ValueInt;
      FieldByName('first_in').AsInteger                      := edtFirstIn.ValueInt;
      Post;
    end;

  finally
    UnLockControl(pnlBackground);
    edtDescription.Clear;
    edtNumberOfInstallments.ValueInt := 1;
    if edtDescription.CanFocus then
      edtDescription.SetFocus;
  end;
end;

procedure TPaymentInputView.SetState(const Value: TEntityState);
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

procedure TPaymentInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (String(edtname.Text).Trim > '') and (String(edtbank_account_default_id.Text).Trim > '') and
                 (String(edtbank_account_default_name.Text).Trim > '');
  inherited;
end;

end.

