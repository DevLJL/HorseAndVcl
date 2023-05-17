unit uConsumption.Input.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons, uBase.Input.View,
  Skia, Skia.Vcl, Vcl.Grids, Vcl.DBGrids, JvExDBGrids,  JvExComCtrls, JvComCtrls,

  uAppVcl.Types,
  uConsumption.ViewModel.Interfaces,
  uSmartPointer,
  uConsumption.Show.DTO;

type
  TConsumptionInputView = class(TBaseInputView)
    dtsConsumption: TDataSource;
    Label35: TLabel;
    Label1: TLabel;
    edtId: TDBEdit;
    Panel1: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    edtnumber: TDBEdit;
    chkflg_active: TDBCheckBox;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
  private
    FViewModel: IConsumptionViewModel;
    FHandleResult: TConsumptionShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0): TConsumptionShowDTO;
  end;

const
  TITLE_NAME = 'Número de Consumo';

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
  uConsumption.Input.DTO,
  uConsumption.ViewModel,
  uConsumption.Service;

{ TConsumptionInputView }
procedure TConsumptionInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm      := True;
  dtsConsumption.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TConsumptionViewModel.Make;
      case FState of
        TEntityState.Store: FViewModel.Consumption.Append;
        TEntityState.Update,
        TEntityState.View: Begin
          const LConsumptionShowDTO: SH<TConsumptionShowDTO> = TConsumptionService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LConsumptionShowDTO);
          FViewModel.Consumption.Edit;
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
      dtsConsumption.DataSet := FViewModel.Consumption.DataSet;
      if edtnumber.CanFocus then
        edtnumber.SetFocus;
    end)
  .Run;
end;

procedure TConsumptionInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TConsumptionInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TConsumptionShowDTO>;
begin
  inherited;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Sempre salvar dataset para evitar erros
  if FViewModel.Consumption.State in [dsInsert, dsEdit] then
    FViewModel.Consumption.Post;

  // Iniciar Loading
  LoadingSave      := True;
  LoadingForm      := True;
  dtsConsumption.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LConsumptionInputDTO: SH<TConsumptionInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TConsumptionService.Make.StoreAndShow(LConsumptionInputDTO);
        TEntityState.Update: LSaved := TConsumptionService.Make.UpdateAndShow(FEditPK, LConsumptionInputDTO);
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

          FViewModel.Consumption.Edit;
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
        dtsConsumption.DataSet := FViewModel.Consumption.DataSet;
      end;
    end)
  .Run;
end;

procedure TConsumptionInputView.FormCreate(Sender: TObject);
begin
  inherited;
  pgc.Pages[0].TabVisible := False;
  pgc.ActivePageIndex     := 0;
  tmrAllowSave.Enabled    := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TConsumptionInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TConsumptionInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TConsumptionInputView.Handle(AState: TEntityState; AEditPK: Int64): TConsumptionShowDTO;
begin
  Result := nil;
  const LView: SH<TConsumptionInputView> = TConsumptionInputView.Create(nil);
  LView.Value.EditPK := AEditPK;
  LView.Value.State  := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TConsumptionInputView.SetState(const Value: TEntityState);
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

procedure TConsumptionInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (String(edtNumber.Text).Trim > '');
  inherited;
end;

end.

