unit uCashFlow.Input.View;

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
  Vcl.NumberBox,
  JvSpin,
  JvExMask,
  JvToolEdit,
  uAppVcl.Types,
  uCashFlow.ViewModel.Interfaces,
  uSmartPointer,
  uCashFlow.Show.DTO;

type
  TCashFlowInputView = class(TBaseInputView)
    dtsCashFlow: TDataSource;
    dtsCashFlowTransactions: TDataSource;
    Label35: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label23: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    imgCashFlowTransactionListAdd: TImage;
    edtId: TDBEdit;
    Panel1: TPanel;
    edtopening_balance_amount: TDBEdit;
    edtstation_id: TDBEdit;
    Panel10: TPanel;
    Panel12: TPanel;
    imgLocaStation: TImage;
    edtstation_name: TDBEdit;
    DBEdit1: TDBEdit;
    DBMemo1: TDBMemo;
    edtopening_date: TJvDateEdit;
    edtopening_time: TJvTimeEdit;
    edtclosing_date: TJvDateEdit;
    edtclosing_time: TJvTimeEdit;
    Panel2: TPanel;
    dbgCashFlowTransactionList: TDBGrid;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
    procedure btnCashFlowTransactionsEditClick(Sender: TObject);
    procedure btnCashFlowTransactionsDeleteClick(Sender: TObject);
    procedure imgLocaStationClick(Sender: TObject);
    procedure imgCashFlowTransactionListAddClick(Sender: TObject);
    procedure dbgCashFlowTransactionListCellClick(Column: TColumn);
    procedure dbgCashFlowTransactionListDblClick(Sender: TObject);
    procedure dbgCashFlowTransactionListDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    FViewModel: ICashFlowViewModel;
    FHandleResult: TCashFlowShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0): TCashFlowShowDTO;
  end;

const
  TITLE_NAME = 'Fluxo de Caixa';

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
  uCashFlow.Input.DTO,
  uCashFlow.ViewModel,
  uCashFlow.Service,
  uHlp,
  uCashFlowTransaction.Input.View,
  uIndexResult,
  uBankAccount.Index.View,
  uStation.Index.View,
  System.DateUtils;

{ TCashFlowInputView }
procedure TCashFlowInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm                     := True;
  dtsCashFlow.DataSet             := nil;
  dtsCashFlowTransactions.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TCashFlowViewModel.Make;
      case FState of
        TEntityState.Store: FViewModel.CashFlow.Append;
        TEntityState.Update,
        TEntityState.View: Begin
          const LCashFlowShowDTO: SH<TCashFlowShowDTO> = TCashFlowService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LCashFlowShowDTO);
          FViewModel.CashFlow.Edit;
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
      // Carregar data e hora
      edtopening_date.Date     := FViewModel.CashFlow.FieldByName('opening_date').AsDateTime;
      edtopening_time.Time     := FViewModel.CashFlow.FieldByName('opening_date').AsDateTime;
      edtclosing_date.Date     := FViewModel.CashFlow.FieldByName('closing_date').AsDateTime;
      edtclosing_time.Time     := FViewModel.CashFlow.FieldByName('closing_date').AsDateTime;

      // Encerrar Loading
      LoadingForm                     := False;
      dtsCashFlow.DataSet             := FViewModel.CashFlow.DataSet;
      dtsCashFlowTransactions.DataSet := FViewModel.CashFlowTransactions.DataSet;
      if edtstation_id.CanFocus then
        edtstation_id.SetFocus;
    end)
  .Run;
end;

procedure TCashFlowInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TCashFlowInputView.btnCashFlowTransactionsDeleteClick(Sender: TObject);
begin
  // Mensagem de Sim/Não
  if not (TYesOrNoView.Handle(Trans.DoYouWantToDeleteSelectedRecord, Trans.Exclusion) = mrOK) then
    Exit;

  Try
    LockControl(pnlBackground);

    dtsCashFlowTransactions.DataSet.Delete;
    NotificationView.Execute(Trans.RecordDeleted, tneError);
  Finally
    UnLockControl(pnlBackground);
  End;
end;

procedure TCashFlowInputView.btnCashFlowTransactionsEditClick(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsCashFlowTransactions.DataSet) and dtsCashFlowTransactions.DataSet.Active and (dtsCashFlowTransactions.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  Try
    LockControl(pnlBackground);

    // Incluir Novo Contato
    TCashFlowTransactionInputView.Handle(TEntityState.Update, FViewModel);
  Finally
    UnLockControl(pnlBackground);
  End;
end;

procedure TCashFlowInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TCashFlowShowDTO>;
  function HandleDateTime(ADate: TDateTime; ATime: TTime): TDateTime;
  begin
    Result := EncodeDateTime(
      YearOf(ADate),
      MonthOf(ADate),
      DayOf(ADate),
      HourOf(ATime),
      MinuteOf(ATime),
      SecondOf(ADate),
      0
    );
  end;
begin
  inherited;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Sempre salvar dataset para evitar erros
  if FViewModel.CashFlow.State in [dsInsert, dsEdit] then
  begin
    FViewModel.CashFlow.FieldByName('opening_date').AsDateTime := HandleDateTime(edtopening_date.Date, edtopening_time.Time);
    FViewModel.CashFlow.FieldByName('closing_date').AsDateTime := HandleDateTime(edtclosing_date.Date, edtclosing_time.Time);
    FViewModel.CashFlow.Post;
  end;

  // Iniciar Loading
  LoadingSave             := True;
  LoadingForm             := True;
  dtsCashFlow.DataSet      := nil;
  dtsCashFlowTransactions.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LCashFlowInputDTO: SH<TCashFlowInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TCashFlowService.Make.StoreAndShow(LCashFlowInputDTO);
        TEntityState.Update: LSaved := TCashFlowService.Make.UpdateAndShow(FEditPK, LCashFlowInputDTO);
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

          FViewModel.CashFlow.Edit;
          NotificationView.Execute(Trans.RecordValidationFailed, tneError);
          Exit;
        end;

        // Retornar registro inserido/atualizado
        NotificationView.Execute(Trans.RecordSaved, tneSuccess);
        FHandleResult := LSaved.Right;
        ModalResult   := MrOK;
      finally
        // Encerrar Loading
        LoadingSave             := False;
        LoadingForm             := False;
        dtsCashFlow.DataSet      := FViewModel.CashFlow.DataSet;
        dtsCashFlowTransactions.DataSet := FViewModel.CashFlowTransactions.DataSet;
      end;
    end)
  .Run;
end;

procedure TCashFlowInputView.dbgCashFlowTransactionListCellClick(Column: TColumn);
begin
  inherited;
  const LKeepGoing = Assigned(dtsCashFlowTransactions.DataSet) and dtsCashFlowTransactions.DataSet.Active and (dtsCashFlowTransactions.DataSet.RecordCount > 0);
  if not lKeepGoing then
    Exit;

  // Editar
  if (AnsiLowerCase(Column.FieldName) = 'action_edit') then
    btnCashFlowTransactionsEditClick(dbgCashFlowTransactionList);

  // Deletar
  if (AnsiLowerCase(Column.FieldName) = 'action_delete') then
    btnCashFlowTransactionsDeleteClick(dbgCashFlowTransactionList);
end;

procedure TCashFlowInputView.dbgCashFlowTransactionListDblClick(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsCashFlowTransactions.DataSet) and dtsCashFlowTransactions.DataSet.Active and (dtsCashFlowTransactions.DataSet.RecordCount > 0);
  if not lKeepGoing then
    Exit;

  Try
    LockControl(pnlBackground);

    // Incluir Novo Registro
    TCashFlowTransactionInputView.Handle(TEntityState.Update, FViewModel);
  Finally
    UnLockControl(pnlBackground);
  End;
end;

procedure TCashFlowInputView.dbgCashFlowTransactionListDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  const LKeepGoing = Assigned(dtsCashFlowTransactions.DataSet) and (dtsCashFlowTransactions.DataSet.Active) and (dtsCashFlowTransactions.DataSet.RecordCount > 0);
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

procedure TCashFlowInputView.FormCreate(Sender: TObject);
begin
  inherited;
  pgc.ActivePageIndex           := 0;
  tmrAllowSave.Enabled          := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TCashFlowInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

  // F1 - Localizar Station
  if (Key = VK_F1) and (edtstation_id.Focused or edtstation_name.Focused) then
  begin
    imgLocaStationClick(imgLocaStation);
    Exit;
  end;
end;

procedure TCashFlowInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TCashFlowInputView.Handle(AState: TEntityState; AEditPK: Int64): TCashFlowShowDTO;
begin
  Result := nil;
  const LView: SH<TCashFlowInputView> = TCashFlowInputView.Create(nil);
  LView.Value.EditPK := AEditPK;
  LView.Value.State  := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TCashFlowInputView.imgCashFlowTransactionListAddClick(Sender: TObject);
begin
  inherited;
  Try
    LockControl(pnlBackground);

    // Incluir Novo Registro
    TCashFlowTransactionInputView.Handle(TEntityState.Store, FViewModel);
  Finally
    UnLockControl(pnlBackground);
  End;
end;

procedure TCashFlowInputView.imgLocaStationClick(Sender: TObject);
begin
  const LPk = TStationIndexView.HandleLocate;
  if (lPk > 0) then
    dtsCashFlow.DataSet.FieldByName('station_id').Text := LPk.ToString;
end;

procedure TCashFlowInputView.SetState(const Value: TEntityState);
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

procedure TCashFlowInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (String(edtstation_id.Text).Trim > '') and (edtopening_date.Date > 0);
  inherited;
end;

end.
