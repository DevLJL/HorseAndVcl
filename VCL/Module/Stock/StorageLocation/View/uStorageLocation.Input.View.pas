unit uStorageLocation.Input.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons, uBase.Input.View,
  Skia, Skia.Vcl, Vcl.Grids, Vcl.DBGrids, JvExDBGrids,  JvExComCtrls, JvComCtrls,

  uAppVcl.Types,
  uStorageLocation.ViewModel.Interfaces,
  uSmartPointer,
  uStorageLocation.Show.DTO;

type
  TStorageLocationInputView = class(TBaseInputView)
    dtsStorageLocation: TDataSource;
    Label35: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    edtId: TDBEdit;
    Panel1: TPanel;
    edtname: TDBEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
  private
    FViewModel: IStorageLocationViewModel;
    FHandleResult: TStorageLocationShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0): TStorageLocationShowDTO;
  end;

const
  TITLE_NAME = 'Local de Armazenamento';

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
  uStorageLocation.Input.DTO,
  uStorageLocation.ViewModel,
  uStorageLocation.Service;

{ TStorageLocationInputView }
procedure TStorageLocationInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm      := True;
  dtsStorageLocation.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TStorageLocationViewModel.Make;
      case FState of
        TEntityState.Store: FViewModel.StorageLocation.Append;
        TEntityState.Update,
        TEntityState.View: Begin
          const LStorageLocationShowDTO: SH<TStorageLocationShowDTO> = TStorageLocationService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LStorageLocationShowDTO);
          FViewModel.StorageLocation.Edit;
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
      dtsStorageLocation.DataSet := FViewModel.StorageLocation.DataSet;
      if edtName.CanFocus then
        edtName.SetFocus;
    end)
  .Run;
end;

procedure TStorageLocationInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TStorageLocationInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TStorageLocationShowDTO>;
begin
  inherited;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Sempre salvar dataset para evitar erros
  if FViewModel.StorageLocation.State in [dsInsert, dsEdit] then
    FViewModel.StorageLocation.Post;

  // Iniciar Loading
  LoadingSave      := True;
  LoadingForm      := True;
  dtsStorageLocation.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LStorageLocationInputDTO: SH<TStorageLocationInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TStorageLocationService.Make.StoreAndShow(LStorageLocationInputDTO);
        TEntityState.Update: LSaved := TStorageLocationService.Make.UpdateAndShow(FEditPK, LStorageLocationInputDTO);
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

          FViewModel.StorageLocation.Edit;
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
        dtsStorageLocation.DataSet := FViewModel.StorageLocation.DataSet;
      end;
    end)
  .Run;
end;

procedure TStorageLocationInputView.FormCreate(Sender: TObject);
begin
  inherited;
  pgc.Pages[0].TabVisible := False;
  pgc.ActivePageIndex     := 0;
  tmrAllowSave.Enabled    := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TStorageLocationInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TStorageLocationInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TStorageLocationInputView.Handle(AState: TEntityState; AEditPK: Int64): TStorageLocationShowDTO;
begin
  Result := nil;
  const LView: SH<TStorageLocationInputView> = TStorageLocationInputView.Create(nil);
  LView.Value.EditPK := AEditPK;
  LView.Value.State  := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TStorageLocationInputView.SetState(const Value: TEntityState);
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

procedure TStorageLocationInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (String(edtname.Text).Trim > '');
  inherited;
end;

end.

