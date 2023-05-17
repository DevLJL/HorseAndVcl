unit uBank.Input.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons, uBase.Input.View,
  Skia, Skia.Vcl, Vcl.Grids, Vcl.DBGrids, JvExDBGrids,  JvExComCtrls, JvComCtrls,

  uAppVcl.Types,
  uBank.ViewModel.Interfaces,
  uSmartPointer,
  uBank.Show.DTO;

type
  TBankInputView = class(TBaseInputView)
    dtsBank: TDataSource;
    Label35: TLabel;
    Label1: TLabel;
    edtId: TDBEdit;
    Panel1: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    edtname: TDBEdit;
    edtcode: TDBEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
  private
    FViewModel: IBankViewModel;
    FHandleResult: TBankShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0): TBankShowDTO;
  end;

const
  TITLE_NAME = 'Banco';

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
  uBank.Input.DTO,
  uBank.ViewModel,
  uBank.Service;

{ TBankInputView }
procedure TBankInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm      := True;
  dtsBank.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TBankViewModel.Make;
      case FState of
        TEntityState.Store: FViewModel.Bank.Append;
        TEntityState.Update,
        TEntityState.View: Begin
          const LBankShowDTO: SH<TBankShowDTO> = TBankService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LBankShowDTO);
          FViewModel.Bank.Edit;
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
      dtsBank.DataSet := FViewModel.Bank.DataSet;
      if edtCode.CanFocus then
        edtCode.SetFocus;
    end)
  .Run;
end;

procedure TBankInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TBankInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TBankShowDTO>;
begin
  inherited;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Sempre salvar dataset para evitar erros
  if FViewModel.Bank.State in [dsInsert, dsEdit] then
    FViewModel.Bank.Post;

  // Iniciar Loading
  LoadingSave      := True;
  LoadingForm      := True;
  dtsBank.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LBankInputDTO: SH<TBankInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TBankService.Make.StoreAndShow(LBankInputDTO);
        TEntityState.Update: LSaved := TBankService.Make.UpdateAndShow(FEditPK, LBankInputDTO);
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

          FViewModel.Bank.Edit;
          NotificationView.Execute(Trans.RecordValidationFailed, tneError);
          Exit;
        end;

        // Retornar registro inserido/atualizado
        NotificationView.Execute(Trans.RecordSaved, tneSuccess);
        FHandleResult := LSaved.Right;
        ModalResult   := MrOK;
      finally
        // Encerrar Loading
        LoadingSave      := False;
        LoadingForm      := False;
        dtsBank.DataSet := FViewModel.Bank.DataSet;
      end;
    end)
  .Run;
end;

procedure TBankInputView.FormCreate(Sender: TObject);
begin
  inherited;
  pgc.Pages[0].TabVisible := False;
  pgc.ActivePageIndex     := 0;
  tmrAllowSave.Enabled    := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TBankInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
end;

procedure TBankInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TBankInputView.Handle(AState: TEntityState; AEditPK: Int64): TBankShowDTO;
begin
  Result := nil;
  const LView: SH<TBankInputView> = TBankInputView.Create(nil);
  LView.Value.EditPK := AEditPK;
  LView.Value.State  := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TBankInputView.SetState(const Value: TEntityState);
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

procedure TBankInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (String(edtcode.Text).Trim > '') and (String(edtname.Text).Trim > '');
  inherited;
end;

end.

