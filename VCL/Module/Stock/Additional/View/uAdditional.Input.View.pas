unit uAdditional.Input.View;

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
  Vcl.Forms,
  JvExDBGrids,
  JvExComCtrls,
  JvComCtrls,
  uAppVcl.Types,
  uAdditional.ViewModel.Interfaces,
  uSmartPointer,
  uAdditional.Show.DTO,
  uProduct.Index.View;

type
  TAdditionalInputView = class(TBaseInputView)
    dtsAdditional: TDataSource;
    Label35: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    edtId: TDBEdit;
    Panel1: TPanel;
    edtname: TDBEdit;
    DBRadioGroup1: TDBRadioGroup;
    DBRadioGroup2: TDBRadioGroup;
    Label22: TLabel;
    Panel5: TPanel;
    Panel2: TPanel;
    dbgAdditionalProducts: TDBGrid;
    dtsAdditionalProducts: TDataSource;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
    procedure dbgAdditionalProductsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgAdditionalProductsCellClick(Column: TColumn);
    procedure btnAdditionalProductsDeleteClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure imgPersonContactsAddClick(Sender: TObject);
  private
    FViewModel: IAdditionalViewModel;
    FHandleResult: TAdditionalShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    FProductIndexView: TProductIndexView;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0): TAdditionalShowDTO;
  end;

const
  TITLE_NAME = 'Adicional';

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
  uAdditional.Input.DTO,
  uAdditional.ViewModel,
  uAdditional.Service,
  uHlp, uProduct.Show.DTO, uProduct.Service;

{ TAdditionalInputView }
procedure TAdditionalInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm                   := True;
  dtsAdditional.DataSet         := nil;
  dtsAdditionalProducts.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TAdditionalViewModel.Make;
      case FState of
        TEntityState.Store: FViewModel.Additional.Append;
        TEntityState.Update,
        TEntityState.View: Begin
          const LAdditionalShowDTO: SH<TAdditionalShowDTO> = TAdditionalService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LAdditionalShowDTO);
          FViewModel.Additional.Edit;
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
      LoadingForm                   := false;
      dtsAdditional.DataSet         := FViewModel.Additional.DataSet;
      dtsAdditionalProducts.DataSet := FViewModel.AdditionalProducts.DataSet;
      if edtName.CanFocus then
        edtName.SetFocus;
    end)
  .Run;
end;

procedure TAdditionalInputView.btnAdditionalProductsDeleteClick(Sender: TObject);
begin
  // Mensagem de Sim/Não
  if not (TYesOrNoView.Handle(Trans.DoYouWantToDeleteSelectedRecord, Trans.Exclusion) = mrOK) then
    Exit;

  Try
    LockControl(pnlBackground);

    dtsAdditionalProducts.DataSet.Delete;
    ToastView.Execute(Trans.RecordDeleted, tneError);
  Finally
    UnLockControl(pnlBackground);
  End;
end;

procedure TAdditionalInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TAdditionalInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TAdditionalShowDTO>;
begin
  inherited;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Sempre salvar dataset para evitar erros
  if FViewModel.Additional.State in [dsInsert, dsEdit] then
    FViewModel.Additional.Post;

  // Iniciar Loading
  LoadingSave                   := True;
  LoadingForm                   := True;
  dtsAdditional.DataSet         := nil;
  dtsAdditionalProducts.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LAdditionalInputDTO: SH<TAdditionalInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TAdditionalService.Make.StoreAndShow(LAdditionalInputDTO);
        TEntityState.Update: LSaved := TAdditionalService.Make.UpdateAndShow(FEditPK, LAdditionalInputDTO);
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

          FViewModel.Additional.Edit;
          ToastView.Execute(Trans.RecordValidationFailed, tneError);
          Exit;
        end;

        // Retornar registro inserido/atualizado
        ToastView.Execute(Trans.RecordSaved, tneSuccess);
        FHandleResult := LSaved.Right;
        ModalResult   := MrOK;
      finally
        // Encerrar Loading
        LoadingSave                   := False;
        LoadingForm                   := False;
        dtsAdditional.DataSet         := FViewModel.Additional.DataSet;
        dtsAdditionalProducts.DataSet := FViewModel.AdditionalProducts.DataSet;
      end;
    end)
  .Run;
end;

procedure TAdditionalInputView.dbgAdditionalProductsCellClick(Column: TColumn);
begin
  inherited;
  const LKeepGoing = Assigned(dtsAdditionalProducts.DataSet) and dtsAdditionalProducts.DataSet.Active and (dtsAdditionalProducts.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  // Deletar
  if (AnsiLowerCase(Column.FieldName) = 'action_delete') then
    btnAdditionalProductsDeleteClick(dbgAdditionalProducts);
end;

procedure TAdditionalInputView.dbgAdditionalProductsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  const LKeepGoing = Assigned(dtsAdditionalProducts.DataSet) and (dtsAdditionalProducts.DataSet.Active) and (dtsAdditionalProducts.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  // Exibir imagem de Deletar
  if (AnsiLowerCase(Column.FieldName) = 'action_delete') then
  begin
    TDBGrid(Sender).Canvas.FillRect(Rect);
    DTM.imgListGrid.Draw(TDBGrid(Sender).Canvas, Rect.Left +1,Rect.Top + 1, 1);
  end;
end;

procedure TAdditionalInputView.FormCreate(Sender: TObject);
begin
  inherited;
  pgc.Pages[0].TabVisible := False;
  pgc.ActivePageIndex     := 0;
  tmrAllowSave.Enabled    := True;
  tmrAllowSaveTimer(tmrAllowSave);

  // Instanciar uma única vez pesquisa de itens
  FProductIndexView := TProductIndexView.Create(nil);
  FProductIndexView.SetLayoutLocate(False);
end;

procedure TAdditionalInputView.FormDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FProductIndexView) then
    FProductIndexView.Free;
end;

procedure TAdditionalInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TAdditionalInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TAdditionalInputView.Handle(AState: TEntityState; AEditPK: Int64): TAdditionalShowDTO;
begin
  Result := nil;
  const LView: SH<TAdditionalInputView> = TAdditionalInputView.Create(nil);
  LView.Value.EditPK := AEditPK;
  LView.Value.State  := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TAdditionalInputView.imgPersonContactsAddClick(Sender: TObject);
begin
  // Criar fundo transparente
  const LDarkBackground: SH<TForm> = TForm.Create(nil);
  CreateDarkBackground(LDarkBackground.Value);

  // Instanciar uma única vez
  if not (FProductIndexView.AShowModal = mrOK) then Exit;
  if not (FProductIndexView.LocateResult > 0) then Exit;

  // Localizar Item
  const LProductShowDTO: SH<TProductShowDTO> = TProductService.Make.Show(FProductIndexView.LocateResult);
  dtsAdditionalProducts.DataSet.Append;
  dtsAdditionalProducts.DataSet.FieldByName('product_id').AsLargeInt := LProductShowDTO.Value.id;
  dtsAdditionalProducts.DataSet.FieldByName('product_name').AsString := LProductShowDTO.Value.name;
  dtsAdditionalProducts.DataSet.Post;
end;

procedure TAdditionalInputView.SetState(const Value: TEntityState);
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

procedure TAdditionalInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (String(edtname.Text).Trim > '');
  inherited;
end;

end.
