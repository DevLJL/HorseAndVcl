unit uPosPrinter.Input.View;

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
  uPosPrinter.ViewModel.Interfaces,
  uSmartPointer,
  uPosPrinter.Show.DTO,
  JvExStdCtrls,
  JvCombobox,
  JvDBCombobox;

type
  TPosPrinterInputView = class(TBaseInputView)
    dtsPosPrinter: TDataSource;
    Label35: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edtId: TDBEdit;
    Panel1: TPanel;
    edtname: TDBEdit;
    cbxmodel: TJvDBComboBox;
    cbxport: TDBComboBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit6: TDBEdit;
    chkflg_customer: TDBCheckBox;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBCheckBox4: TDBCheckBox;
    DBCheckBox5: TDBCheckBox;
    JvDBComboBox2: TJvDBComboBox;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
  private
    FViewModel: IPosPrinterViewModel;
    FHandleResult: TPosPrinterShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0): TPosPrinterShowDTO;
  end;

const
  TITLE_NAME = 'Impressora (POS)';

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
  uPosPrinter.Input.DTO,
  uPosPrinter.ViewModel,
  uPosPrinter.Service,
  uPosPrinter.Lib.Factory;

{ TPosPrinterInputView }
procedure TPosPrinterInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm           := True;
  dtsPosPrinter.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TPosPrinterViewModel.Make;
      case FState of
        TEntityState.Store: FViewModel.PosPrinter.Append;
        TEntityState.Update,
        TEntityState.View: Begin
          const LPosPrinterShowDTO: SH<TPosPrinterShowDTO> = TPosPrinterService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LPosPrinterShowDTO);
          FViewModel.PosPrinter.Edit;
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
      dtsPosPrinter.DataSet := FViewModel.PosPrinter.DataSet;
      if edtName.CanFocus then
        edtName.SetFocus;
    end)
  .Run;
end;

procedure TPosPrinterInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TPosPrinterInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TPosPrinterShowDTO>;
begin
  inherited;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Sempre salvar dataset para evitar erros
  if FViewModel.PosPrinter.State in [dsInsert, dsEdit] then
    FViewModel.PosPrinter.Post;

  // Iniciar Loading
  LoadingSave           := True;
  LoadingForm           := True;
  dtsPosPrinter.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LPosPrinterInputDTO: SH<TPosPrinterInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TPosPrinterService.Make.StoreAndShow(LPosPrinterInputDTO);
        TEntityState.Update: LSaved := TPosPrinterService.Make.UpdateAndShow(FEditPK, LPosPrinterInputDTO);
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

          FViewModel.PosPrinter.Edit;
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
        dtsPosPrinter.DataSet := FViewModel.PosPrinter.DataSet;
      end;
    end)
  .Run;
end;

procedure TPosPrinterInputView.FormCreate(Sender: TObject);
begin
  inherited;
  pgc.Pages[0].TabVisible := False;
  pgc.ActivePageIndex     := 0;
  tmrAllowSave.Enabled    := True;
  tmrAllowSaveTimer(tmrAllowSave);

  // Carregar Impressoras
  TPosPrinterLibFactory.Make.LoadPorts(cbxport.Items);
end;

procedure TPosPrinterInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TPosPrinterInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TPosPrinterInputView.Handle(AState: TEntityState; AEditPK: Int64): TPosPrinterShowDTO;
begin
  Result := nil;
  const LView: SH<TPosPrinterInputView> = TPosPrinterInputView.Create(nil);
  LView.Value.EditPK := AEditPK;
  LView.Value.State  := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TPosPrinterInputView.SetState(const Value: TEntityState);
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

procedure TPosPrinterInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (String(edtname.Text).Trim > '') and (String(cbxmodel.Text).Trim > '') and
                 (String(cbxport.Text).Trim > '');
  inherited;
end;

end.
