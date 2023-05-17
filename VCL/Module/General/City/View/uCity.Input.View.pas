unit uCity.Input.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons, uBase.Input.View,
  Skia, Skia.Vcl, Vcl.Grids, Vcl.DBGrids, JvExDBGrids,  JvExComCtrls, JvComCtrls,

  uAppVcl.Types,
  uCity.ViewModel,
  uCity.ViewModel.Interfaces,
  uCity.Show.DTO;

type
  TCityInputView = class(TBaseInputView)
    dtsCity: TDataSource;
    Label35: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    edtId: TDBEdit;
    Panel1: TPanel;
    edtname: TDBEdit;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    edtCountry: TDBEdit;
    edtibge_code: TDBEdit;
    edtCountryIbgeCode: TDBEdit;
    edtIdentification: TDBEdit;
    cbxState: TDBComboBox;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
  private
    FViewModel: ICityViewModel;
    FHandleResult: TCityShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0): TCityShowDTO;
  end;

const
  TITLE_NAME = 'Cidade';

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
  uHlp,
  uTrans,
  uSmartPointer,
  uCity.Input.DTO,
  uCity.Service;

{ TCityInputView }
procedure TCityInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm     := True;
  dtsCity.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TCityViewModel.Make;
      case FState of
        TEntityState.Store: FViewModel.City.Append;
        TEntityState.Update,
        TEntityState.View: Begin
          const LCityShowDTO: SH<TCityShowDTO> = TCityService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LCityShowDTO);
          FViewModel.City.Edit;
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
      dtsCity.DataSet := FViewModel.City.DataSet;
      if edtName.CanFocus then
        edtName.SetFocus;
    end)
  .Run;
end;

procedure TCityInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TCityInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TCityShowDTO>;
begin
  inherited;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Sempre salvar dataset para evitar erros
  if FViewModel.City.State in [dsInsert, dsEdit] then
    FViewModel.City.Post;

  // Iniciar Loading
  LoadingSave      := True;
  LoadingForm      := True;
  dtsCity.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LCityInputDTO: SH<TCityInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TCityService.Make.StoreAndShow(LCityInputDTO);
        TEntityState.Update: LSaved := TCityService.Make.UpdateAndShow(FEditPK, LCityInputDTO);
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

          FViewModel.City.Edit;
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
        dtsCity.DataSet := FViewModel.City.DataSet;
      end;
    end)
  .Run;
end;

procedure TCityInputView.FormCreate(Sender: TObject);
begin
  inherited;
  pgc.Pages[0].TabVisible := False;
  pgc.ActivePageIndex     := 0;
  tmrAllowSave.Enabled    := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TCityInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TCityInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TCityInputView.Handle(AState: TEntityState; AEditPK: Int64): TCityShowDTO;
begin
  Result := nil;
  const LView: SH<TCityInputView> = TCityInputView.Create(nil);
  LView.Value.EditPK := AEditPK;
  LView.Value.State  := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TCityInputView.SetState(const Value: TEntityState);
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

procedure TCityInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (String(edtname.Text).Trim > '') and (String(cbxState.Text).Trim > '') and
                 (String(edtCountry.Text).Trim > '') and (StrInt(edtibge_code.Text) > 0) and
                 (StrInt(edtCountryIbgeCode.Text) > 0);
  inherited;
end;

end.

end.

