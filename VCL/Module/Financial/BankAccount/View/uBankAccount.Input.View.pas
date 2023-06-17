unit uBankAccount.Input.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons, uBase.Input.View,
  Skia, Skia.Vcl, Vcl.Grids, Vcl.DBGrids, JvExDBGrids,  JvExComCtrls, JvComCtrls,

  uAppVcl.Types,
  uBankAccount.ViewModel.Interfaces,
  uSmartPointer,
  uBankAccount.Show.DTO;

type
  TBankAccountInputView = class(TBaseInputView)
    dtsBankAccount: TDataSource;
    Label35: TLabel;
    Label1: TLabel;
    edtId: TDBEdit;
    Panel1: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    Label23: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    edtname: TDBEdit;
    edtbank_id: TDBEdit;
    Panel10: TPanel;
    Panel12: TPanel;
    imgLocaBank: TImage;
    edtbank_name: TDBEdit;
    DBMemo1: TDBMemo;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
    procedure imgLocaBankClick(Sender: TObject);
  private
    FViewModel: IBankAccountViewModel;
    FHandleResult: TBankAccountShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0): TBankAccountShowDTO;
  end;

const
  TITLE_NAME = 'Conta Bancária';

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
  uBankAccount.Input.DTO,
  uBankAccount.ViewModel,
  uBankAccount.Service, uBank.Index.View;

{ TBankAccountInputView }
procedure TBankAccountInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm      := True;
  dtsBankAccount.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TBankAccountViewModel.Make;
      case FState of
        TEntityState.Store: FViewModel.BankAccount.Append;
        TEntityState.Update,
        TEntityState.View: Begin
          const LBankAccountShowDTO: SH<TBankAccountShowDTO> = TBankAccountService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LBankAccountShowDTO);
          FViewModel.BankAccount.Edit;
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
      dtsBankAccount.DataSet := FViewModel.BankAccount.DataSet;
      if edtName.CanFocus then
        edtName.SetFocus;
    end)
  .Run;
end;

procedure TBankAccountInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TBankAccountInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TBankAccountShowDTO>;
begin
  inherited;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Sempre salvar dataset para evitar erros
  if FViewModel.BankAccount.State in [dsInsert, dsEdit] then
    FViewModel.BankAccount.Post;

  // Iniciar Loading
  LoadingSave      := True;
  LoadingForm      := True;
  dtsBankAccount.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LBankAccountInputDTO: SH<TBankAccountInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TBankAccountService.Make.StoreAndShow(LBankAccountInputDTO);
        TEntityState.Update: LSaved := TBankAccountService.Make.UpdateAndShow(FEditPK, LBankAccountInputDTO);
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

          FViewModel.BankAccount.Edit;
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
        dtsBankAccount.DataSet := FViewModel.BankAccount.DataSet;
      end;
    end)
  .Run;
end;

procedure TBankAccountInputView.FormCreate(Sender: TObject);
begin
  inherited;
  pgc.Pages[0].TabVisible := False;
  pgc.ActivePageIndex     := 0;
  tmrAllowSave.Enabled    := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TBankAccountInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

  // F1 - Localizar Banco
  if (Key = VK_F1) and (edtbank_id.Focused or edtbank_name.Focused) then
  begin
    imgLocaBankClick(imgLocaBank);
    Exit;
  end;
end;

procedure TBankAccountInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TBankAccountInputView.Handle(AState: TEntityState; AEditPK: Int64): TBankAccountShowDTO;
begin
  Result := nil;
  const LView: SH<TBankAccountInputView> = TBankAccountInputView.Create(nil);
  LView.Value.EditPK := AEditPK;
  LView.Value.State  := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TBankAccountInputView.imgLocaBankClick(Sender: TObject);
begin
  const LPk = TBankIndexView.HandleLocate;
  if (lPk > 0) then
    dtsBankAccount.DataSet.FieldByName('bank_id').Text := LPk.ToString;
end;

procedure TBankAccountInputView.SetState(const Value: TEntityState);
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

procedure TBankAccountInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (String(edtname.Text).Trim > '') and (String(edtbank_id.Text).Trim > '') and
                 (String(edtbank_name.Text).Trim > '');
  inherited;
end;

end.

