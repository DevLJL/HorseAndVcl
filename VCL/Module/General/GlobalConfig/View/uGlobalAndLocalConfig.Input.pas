unit uGlobalAndLocalConfig.Input;

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
  Vcl.Grids,
  Vcl.DBGrids,
  JvExDBGrids,
  JvExComCtrls,
  JvComCtrls,
  uAppVcl.Types,
  uGlobalConfig.ViewModel.Interfaces,
  uSmartPointer,
  uGlobalConfig.Show.DTO, Vcl.Forms, Vcl.Samples.Spin;

type
  TGlobalAndLocalConfigInputView = class(TBaseInputView)
    dtsGlobalConfig: TDataSource;
    Label2: TLabel;
    Panel2: TPanel;
    Label9: TLabel;
    pdv_ticket_option: TRadioGroup;
    Label5: TLabel;
    pdv_ticket_copies: TSpinEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
  private
    FViewModel: IGlobalConfigViewModel;
    FHandleResult: TGlobalConfigShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
    procedure LoadLocalConfig;
    procedure SaveLocalConfig;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0): TGlobalConfigShowDTO;
  end;

const
  TITLE_NAME = 'Parâmetros';

implementation

{$R *.dfm}

uses
  uToast.View,
  Quick.Threads,
  uGlobalConfig.ViewModel,
  uGlobalConfig.Service,
  uApplicationError.View,
  uEither,
  uGlobalConfig.Input.DTO,
  uAlert.View,
  uTrans,
  uEnv.Vcl;

{ TGlobalConfigInputView }
procedure TGlobalAndLocalConfigInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm             := True;
  dtsGlobalConfig.DataSet := nil;

  // Configuração Local
  LoadLocalConfig;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TGlobalConfigViewModel.Make;
      case FState of
        TEntityState.Store: FViewModel.GlobalConfig.Append;
        TEntityState.Update,
        TEntityState.View: Begin
          const LGlobalConfigShowDTO: SH<TGlobalConfigShowDTO> = TGlobalConfigService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LGlobalConfigShowDTO);
          FViewModel.GlobalConfig.Edit;
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
      dtsGlobalConfig.DataSet := FViewModel.GlobalConfig.DataSet;
    end)
  .Run;
end;

procedure TGlobalAndLocalConfigInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TGlobalAndLocalConfigInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TGlobalConfigShowDTO>;
begin
  inherited;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Sempre salvar dataset para evitar erros
  if FViewModel.GlobalConfig.State in [dsInsert, dsEdit] then
    FViewModel.GlobalConfig.Post;

  // Iniciar Loading
  LoadingSave             := True;
  LoadingForm             := True;
  dtsGlobalConfig.DataSet := nil;
  SaveLocalConfig;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LGlobalConfigInputDTO: SH<TGlobalConfigInputDTO> = FViewModel.ToInputDTO;
      LSaved := TGlobalConfigService.Make.UpdateAndShow(FEditPK, LGlobalConfigInputDTO);
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

          FViewModel.GlobalConfig.Edit;
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
        dtsGlobalConfig.DataSet := FViewModel.GlobalConfig.DataSet;
      end;
    end)
  .Run;
end;

procedure TGlobalAndLocalConfigInputView.FormCreate(Sender: TObject);
begin
  inherited;
  pgc.ActivePageIndex  := 0;
  tmrAllowSave.Enabled := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TGlobalAndLocalConfigInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TGlobalAndLocalConfigInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TGlobalAndLocalConfigInputView.Handle(AState: TEntityState; AEditPK: Int64): TGlobalConfigShowDTO;
begin
  Result := nil;
  const LView: SH<TGlobalAndLocalConfigInputView> = TGlobalAndLocalConfigInputView.Create(nil);
  LView.Value.EditPK := AEditPK;
  LView.Value.State  := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TGlobalAndLocalConfigInputView.LoadLocalConfig;
begin
  pdv_ticket_option.ItemIndex := Ord(ENV_VCL.PdvTicketOption);
  pdv_ticket_copies.Value     := ENV_VCL.PdvTicketCopies;
end;

procedure TGlobalAndLocalConfigInputView.SaveLocalConfig;
begin
  ENV_VCL.PdvTicketOption := TPdvTicketOption(pdv_ticket_option.ItemIndex);
  ENV_VCL.PdvTicketCopies := pdv_ticket_copies.Value;
end;

procedure TGlobalAndLocalConfigInputView.SetState(const Value: TEntityState);
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

procedure TGlobalAndLocalConfigInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := True;
  inherited;
end;

end.
