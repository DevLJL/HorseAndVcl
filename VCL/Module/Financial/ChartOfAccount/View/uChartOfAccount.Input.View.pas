unit uChartOfAccount.Input.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons, uBase.Input.View,
  Skia, Skia.Vcl, Vcl.Grids, Vcl.DBGrids, JvExDBGrids,  JvExComCtrls, JvComCtrls,

  uAppVcl.Types,
  uChartOfAccount.ViewModel.Interfaces,
  uSmartPointer,
  uChartOfAccount.Show.DTO;

type
  TChartOfAccountInputView = class(TBaseInputView)
    dtsChartOfAccount: TDataSource;
    Label35: TLabel;
    Label1: TLabel;
    edtId: TDBEdit;
    Panel1: TPanel;
    Label2: TLabel;
    Label10: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtname: TDBEdit;
    edthierarchy_code: TDBEdit;
    DBRadioGroup1: TDBRadioGroup;
    DBMemo1: TDBMemo;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
  private
    FViewModel: IChartOfAccountViewModel;
    FHandleResult: TChartOfAccountShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0): TChartOfAccountShowDTO;
  end;

const
  TITLE_NAME = 'Plano de Conta';

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
  uChartOfAccount.Input.DTO,
  uChartOfAccount.ViewModel,
  uChartOfAccount.Service;

{ TChartOfAccountInputView }
procedure TChartOfAccountInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm      := True;
  dtsChartOfAccount.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TChartOfAccountViewModel.Make;
      case FState of
        TEntityState.Store: FViewModel.ChartOfAccount.Append;
        TEntityState.Update,
        TEntityState.View: Begin
          const LChartOfAccountShowDTO: SH<TChartOfAccountShowDTO> = TChartOfAccountService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LChartOfAccountShowDTO);
          FViewModel.ChartOfAccount.Edit;
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
      dtsChartOfAccount.DataSet := FViewModel.ChartOfAccount.DataSet;
      if edthierarchy_code.CanFocus then
        edthierarchy_code.SetFocus;
    end)
  .Run;
end;

procedure TChartOfAccountInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TChartOfAccountInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TChartOfAccountShowDTO>;
begin
  inherited;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Sempre salvar dataset para evitar erros
  if FViewModel.ChartOfAccount.State in [dsInsert, dsEdit] then
    FViewModel.ChartOfAccount.Post;

  // Iniciar Loading
  LoadingSave      := True;
  LoadingForm      := True;
  dtsChartOfAccount.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LChartOfAccountInputDTO: SH<TChartOfAccountInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TChartOfAccountService.Make.StoreAndShow(LChartOfAccountInputDTO);
        TEntityState.Update: LSaved := TChartOfAccountService.Make.UpdateAndShow(FEditPK, LChartOfAccountInputDTO);
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

          FViewModel.ChartOfAccount.Edit;
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
        dtsChartOfAccount.DataSet := FViewModel.ChartOfAccount.DataSet;
      end;
    end)
  .Run;
end;

procedure TChartOfAccountInputView.FormCreate(Sender: TObject);
begin
  inherited;
  pgc.Pages[0].TabVisible := False;
  pgc.ActivePageIndex     := 0;
  tmrAllowSave.Enabled    := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TChartOfAccountInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TChartOfAccountInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TChartOfAccountInputView.Handle(AState: TEntityState; AEditPK: Int64): TChartOfAccountShowDTO;
begin
  Result := nil;
  const LView: SH<TChartOfAccountInputView> = TChartOfAccountInputView.Create(nil);
  LView.Value.EditPK := AEditPK;
  LView.Value.State  := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TChartOfAccountInputView.SetState(const Value: TEntityState);
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

procedure TChartOfAccountInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (String(edthierarchy_code.Text).Trim > '') and (String(edtname.Text).Trim > '');
  inherited;
end;

end.

