unit uCashFlow.Index.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBase.Index.View, Data.DB,
  Vcl.WinXCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Menus, Skia, Skia.Vcl, Vcl.NumberBox,

  uIndexResult,
  uAppVcl.Types,
  uCashFlow.Show.DTO,
  uBase.DTO;

type
  TCashFlowIndexView = class(TBaseIndexView)
    tmrDoSearch: TTimer;
    pnlLocate: TPanel;
    imgLocateAppend: TImage;
    imgLocateEdit: TImage;
    lblLocateAppend: TLabel;
    lblLocateEdit: TLabel;
    pnlSave: TPanel;
    pnlSave2: TPanel;
    btnLocateConfirm: TSpeedButton;
    pnlSave3: TPanel;
    imgSave: TImage;
    pnlCancel: TPanel;
    pnlCancel2: TPanel;
    btnLocateClose: TSpeedButton;
    pnlCancel3: TPanel;
    imgCancel4: TImage;
    lblFilterIndex2: TLabel;
    cbxFilterIndex: TComboBox;
    ppmOptions: TPopupMenu;
    mniRegistros1: TMenuItem;
    mniAppend: TMenuItem;
    mniEdit: TMenuItem;
    mniDelete: TMenuItem;
    mniView: TMenuItem;
    N1: TMenuItem;
    mniGrade1: TMenuItem;
    mniSaveGridConfig: TMenuItem;
    mniDeleteGridConfig: TMenuItem;
    chkFilterGeneralResearchMethodAnyPart: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure edtSearchValueChange(Sender: TObject);
    procedure tmrDoSearchTimer(Sender: TObject);
    procedure imgSearchClearClick(Sender: TObject);
    procedure edtSearchValueKeyPress(Sender: TObject; var Key: Char);
    procedure imgDoSearchClick(Sender: TObject);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure btnEditClick(Sender: TObject);
    procedure btnAppendClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnNavigationClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSplitViewApplyClick(Sender: TObject);
    procedure imgFilterCleanClick(Sender: TObject);
    procedure mniSaveGridConfigClick(Sender: TObject);
    procedure mniDeleteGridConfigClick(Sender: TObject);
    procedure btnLocateConfirmClick(Sender: TObject);
    procedure btnLocateCloseClick(Sender: TObject);
    procedure imgOptionsClick(Sender: TObject);
    procedure cbxFilterIndexSelect(Sender: TObject);
  private
    FIndexResult: IIndexResult;
    FFilterOrderBy: String;
    FLayoutLocate: Boolean;
    FLocateResult: Integer;
    procedure CleanFilter;
    procedure DoSearch(ACurrentPage: Integer = 1; ATryLocateId: Int64 = 0);
    procedure SetLocateResult(const Value: Integer);
  public
    class function HandleLocate: Int64;
    property  LocateResult: Integer read FLocateResult write SetLocateResult;
    procedure SetLayoutLocate(ABackgroundTransparent: Boolean = True);
  end;

var
  CashFlowIndexView: TCashFlowIndexView;

implementation

uses
  uHlp,
  System.StrUtils,
  uCashFlow.Input.View,
  uToast.View,
  uDTM,
  uYesOrNo.View,
  uAlert.View,
  Quick.Threads,
  uHandle.Exception,
  uUserLogged,
  DataSet.Serialize,
  uApplicationError.View,
  uSmartPointer,
  uTrans,
  XSuperObject,
  uCashFlow.Service,
  uCashFlow.Filter.DTO,
  uEnv.Vcl,
  uEither;

{$R *.dfm}

procedure TCashFlowIndexView.SetLayoutLocate(ABackgroundTransparent: Boolean);
const
  L_ACTIONS: TArray<String> = ['action_edit','action_delete','action_view','action_option'];
begin
  FLayoutLocate      := true;
  pnlNavigator.Align := alNone;
  pnlLocate.Visible  := true;
  pnlLocate.Align    := alNone;
  pnlLocate.Align    := alBottom;
  pnlNavigator.Align := alBottom;

  lblTitle.Caption           := 'Pesquisando... Fluxo de Caixas';
  pnlAppend.Width            := 0;
  Self.BorderStyle           := bsNone;
  pnlBackground.BorderWidth  := 1;
  pnlBackground.Color        := $00857950;
  if ABackgroundTransparent then
    CreateDarkBackground(Self);

  // Varrer dbgrid e esconder botoes
  for var lI := 0 to DBGrid1.Columns.Count-1 do
  begin
    if MatchStr(AnsiLowerCase(DBGrid1.Columns[lI].FieldName), L_ACTIONS) Then
      DBGrid1.Columns[lI].Visible := False;
  end;
end;

procedure TCashFlowIndexView.SetLocateResult(const Value: Integer);
begin
  FLocateResult := Value;
end;

procedure TCashFlowIndexView.btnAppendClick(Sender: TObject);
begin
  inherited;

  Try
    LockControl(pnlBackground);

    // Incluir Novo Registro
    const LStored: SH<TCashFlowShowDTO> = TCashFlowInputView.Handle(TEntityState.Store);
    if not Assigned(LStored.Value) then
      Exit;

    // Atualizar Listagem
    DoSearch(1, LStored.Value.id);
  Finally
    UnLockControl(pnlBackground);
    if edtSearchValue.CanFocus then
      edtSearchValue.SetFocus;
  End;
end;

procedure TCashFlowIndexView.btnDeleteClick(Sender: TObject);
begin
  // Evitar erros
  const LKeepGoing = Assigned(dtsIndex.DataSet) and dtsIndex.DataSet.Active and (dtsIndex.DataSet.RecordCount > 0) and (LoadingSearch = False);
  if not LKeepGoing then
    Exit;

  // Mensagem de Sim/Não
  if not (TYesOrNoView.Handle(Trans.DoYouWantToDeleteSelectedRecord, Trans.Exclusion) = mrOK) then
    Exit;

  Try
    LockControl(pnlBackground);
    if not TCashFlowService.Make.Delete(dtsIndex.DataSet.Fields[0].AsLargeInt) then
    begin
      TAlertView.Handle(Trans.RecordDeletionFailed);
      Exit;
    end;

    dtsIndex.DataSet.Delete;
    ToastView.Execute(Trans.RecordDeleted, tneError);
  Finally
    UnLockControl(pnlBackground);
    if edtSearchValue.CanFocus then edtSearchValue.SetFocus;
  End;
end;

procedure TCashFlowIndexView.btnEditClick(Sender: TObject);
begin
  // Evitar erros
  const LKeepGoing = Assigned(dtsIndex.DataSet) and dtsIndex.DataSet.Active and (dtsIndex.DataSet.RecordCount > 0) and (dtsIndex.DataSet.Fields[0].AsLargeInt > 0) and (LoadingSearch = False);
  if not LKeepGoing then
    Exit;

  Try
    LockControl(pnlBackground);

    // Editar Registro
    const LUpdated: SH<TCashFlowShowDTO> = TCashFlowInputView.Handle(TEntityState.Update, dtsIndex.DataSet.Fields[0].AsLargeInt);
    if not Assigned(LUpdated.Value) then
      Exit;

    // Atualizar Listagem
    DoSearch(1, LUpdated.Value.id);
  Finally
    UnLockControl(pnlBackground);
    if edtSearchValue.CanFocus then
      edtSearchValue.SetFocus;
  End;
end;

procedure TCashFlowIndexView.btnLocateCloseClick(Sender: TObject);
begin
  inherited;
  FLocateResult := -1;
  ModalResult   := MrCancel;
end;

procedure TCashFlowIndexView.btnLocateConfirmClick(Sender: TObject);
begin
  inherited;
  const LKeepGoing = FLayoutLocate and Assigned(dtsIndex.DataSet) and dtsIndex.DataSet.Active and (dtsIndex.DataSet.RecordCount > 0) and (LoadingSearch = False);
  if not LKeepGoing then
    Exit;

  FLocateResult := dtsIndex.DataSet.Fields[0].AsLargeInt;
  ModalResult   := mrOK;
end;

procedure TCashFlowIndexView.btnNavigationClick(Sender: TObject);
begin
  inherited;

  // Primeira página
  if (Sender = btnNavFirst) then
  begin
    DoSearch;
    Exit;
  end;

  // Voltar página
  if (Sender = btnNavPrior) then
  begin
    DoSearch(edtNavCurrentPage.ValueInt-1);
    Exit;
  end;

  // Próxima Página
  if (Sender = btnNavNext) then
  begin
    DoSearch(edtNavCurrentPage.ValueInt+1);
    Exit;
  end;

  // Última página
  if (Sender = btnNavLast) then
  begin
    DoSearch(edtNavLastPageNumber.ValueInt);
    Exit;
  end;
end;

procedure TCashFlowIndexView.btnSplitViewApplyClick(Sender: TObject);
begin
  inherited;
  SplitView1.Opened := False;
  DoSearch;
  if edtSearchValue.CanFocus then
    edtSearchValue.SetFocus;
end;

procedure TCashFlowIndexView.btnViewClick(Sender: TObject);
begin
  // Evitar erros
  const LKeepGoing = Assigned(dtsIndex.DataSet) and dtsIndex.DataSet.Active and (dtsIndex.DataSet.RecordCount > 0) and (dtsIndex.DataSet.Fields[0].AsLargeInt > 0) and (LoadingSearch = False);
  if not LKeepGoing then
    Exit;

  // Visualizar Registro
  TCashFlowInputView.Handle(TEntityState.View, dtsIndex.DataSet.Fields[0].AsLargeInt);
end;

procedure TCashFlowIndexView.cbxFilterIndexSelect(Sender: TObject);
begin
  inherited;
  lblSearchTitle.Caption := 'F5 - Pesquise por: "' + cbxFilterIndex.Text + '"';
end;

procedure TCashFlowIndexView.CleanFilter;
begin
  // Modo de Pesquisa
  const LMustSearchAnyPart = (Ord(UserLogged.Current.acl_role.general_search_method) = 1);
  chkFilterGeneralResearchMethodAnyPart.OnClick := nil;
  chkFilterGeneralResearchMethodAnyPart.Checked := LMustSearchAnyPart;
  chkFilterGeneralResearchMethodAnyPart.OnClick := imgDoSearchClick;

  // Indexadores
  cbxFilterIndex.ItemIndex := 0;
  cbxFilterIndexSelect(cbxFilterIndex);

  // Ordenar por
  FFilterOrderBy := 'cash_flow.station_id';

  // Limite de Registros p/ Página
  edtNavLimitPerPage.ValueInt := ENV_VCL.LimitPerPage;

  // Limpar Input de Pesquisa e Fazer Refresh
  edtSearchValue.OnChange := nil;
  edtSearchValue.Clear;
  edtSearchValue.OnChange := edtSearchValueChange;
end;

procedure TCashFlowIndexView.DBGrid1CellClick(Column: TColumn);
begin
  inherited;
  const LKeepGoing = Assigned(dtsIndex.DataSet) and dtsIndex.DataSet.Active and (dtsIndex.DataSet.RecordCount > 0) and (LoadingSearch = False);
  if not LKeepGoing then
    Exit;

  // Editar
  if (AnsiLowerCase(Column.FieldName) = 'action_edit') then
    btnEditClick(DBGrid1);

  // Deletar
  if (AnsiLowerCase(Column.FieldName) = 'action_delete') then
    btnDeleteClick(DBGrid1);

  // Visualizar
  if (AnsiLowerCase(Column.FieldName) = 'action_view') then
    btnViewClick(DBGrid1);
end;

procedure TCashFlowIndexView.DBGrid1DblClick(Sender: TObject);
begin
  inherited;
  case FLayoutLocate of
    False: btnEditClick(DBGrid1);
    True:  btnLocateConfirmClick(Sender);
  end;
end;

procedure TCashFlowIndexView.DBGrid1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  // Bloquear Ctrl + Del
  if (ssCtrl in Shift) and (Key = VK_DELETE) then
    Key := 0;

  // Focus em pesquisa
  If (Shift = [ssShift]) and (key = VK_TAB) then
  Begin
    if edtSearchValue.CanFocus then
      edtSearchValue.SetFocus;
    Key := 0;
  End;

  // Quando Enter Pressionado Editar
  if (Key = VK_RETURN) Then
  Begin
    case FLayoutLocate of
      False: btnEditClick(Sender);
      True:  btnLocateConfirmClick(Sender);
    end;
    Key := 0;
  End;
end;

procedure TCashFlowIndexView.DBGrid1TitleClick(Column: TColumn);
const
  L_ACTIONS: TArray<String> = ['action_edit','action_delete','action_view','action_option'];
  L_DESC = ':D';
var
  LCurrentIndex: String;
begin
  Try
    DBGrid1.Enabled := False;

    // -------------------------------------------------------------------------
    // Ordenar Tabela Temporária
    // -------------------------------------------------------------------------
    const LSelectedColumn = AnsiLowerCase(Column.FieldName).Trim;
    if LSelectedColumn.IsEmpty then Exit;
    if MatchStr(Column.FieldName, L_ACTIONS) Then
      Exit;

    // Ordenar por titulo do grid
    const LLastIndex = StringReplace(FIndexResult.Data.IndexFieldNames, L_DESC, '', [rfReplaceAll]);
    const LReverseOrder = (LLastIndex = LSelectedColumn) and (Pos(L_DESC, FIndexResult.Data.IndexFieldNames) > 0);
    if (LLastIndex <> LSelectedColumn) then
      LCurrentIndex := LSelectedColumn
    else Begin
      if LLastIndex.IsEmpty then
        LCurrentIndex := LSelectedColumn + L_DESC
      else Begin
        case LReverseOrder of
          True:  LCurrentIndex := LSelectedColumn;
          False: LCurrentIndex := LSelectedColumn + L_DESC;
        end;
      end;
    end;
    FIndexResult.Data.IndexFieldNames(LCurrentIndex);
    // -------------------------------------------------------------------------


    // -------------------------------------------------------------------------
    // OrderBy do BackEnd
    // -------------------------------------------------------------------------
    FFilterOrderBy := 'cash_flow.'+LSelectedColumn;
    if (LSelectedColumn = 'created_by_acl_user_name') then FFilterOrderBy := 'created_by_acl_user.name';
    if (LSelectedColumn = 'updated_by_acl_user_name') then FFilterOrderBy := 'updated_by_acl_user.name';

    // Verificar se coluna clicada é habilitada para pesquisa em EdtSearchValue.Text
    // Se for, deixa posicionado o Indexador
    var LFound := False;
    for var LI := 0 to Pred(cbxFilterIndex.Items.Count) do
    begin
      if (Column.Title.Caption.ToLower.Trim = cbxFilterIndex.Items[LI].Trim.ToLower) then
      begin
        cbxFilterIndex.ItemIndex := LI;
        cbxFilterIndexSelect(cbxFilterIndex);
        LFound := True;
        Break;
      end;
    end;

    // Se não encontrar acima, tenta localizar por semelhança
    if not LFound then
    Begin
      for var LI := Pred(cbxFilterIndex.Items.Count) downto 0 do
      begin
        if (Pos(Column.Title.Caption.ToLower.Trim, cbxFilterIndex.Items[LI].Trim.ToLower) > 0) then
        begin
          cbxFilterIndex.ItemIndex := LI;
          cbxFilterIndexSelect(cbxFilterIndex);
          LFound := True;
          Break;
        end;
      end;
    End;

    // Pesquisar na api apenas se grade estiver vazia
    if FIndexResult.Data.DataSet.IsEmpty then
      DoSearch;
  finally
    DBGrid1.Enabled := True;
  end;
end;

procedure TCashFlowIndexView.DoSearch(ACurrentPage: Integer; ATryLocateId: Int64);
var
  LSearchValue: String;
  LIndexResult: Either<String, IIndexResult>;
begin
  // Evitar erro
  if LoadingSearch then
    Exit;

  // ---------------------------------------------------------------------------
  // Filto de Dados
  // ---------------------------------------------------------------------------
  const LFilter: SH<TCashFlowFilterDTO> = TCashFlowFilterDTO.Create;
  With LFilter.Value do
  begin
    current_page   := ACurrentPage;
    limit_per_page := edtNavLimitPerPage.ValueInt;
    order_by       := FFilterOrderBy;

    // Conteúdo de Pesquisa
    case chkFilterGeneralResearchMethodAnyPart.Checked of
      True:  LSearchValue := '%'+edtSearchValue.Text;
      False: LSearchValue := edtSearchValue.Text;
    end;

    // Filtros
    case cbxFilterIndex.ItemIndex of
      0:  custom_search_content := LSearchValue; {Pesquisa Customizada}
      1:  id_search_content     := StrInt64(edtSearchValue.Text); {ID}
    end;
  end;
  // ---------------------------------------------------------------------------


  // Iniciar Loading
  LoadingSearch           := True;
  pnlNavigator.Enabled    := False;
  edtSearchValue.OnChange := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      LIndexResult := TCashFlowService.Make.Index(LFilter);
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
        // Verificar retorno da Task
        if ATask.Failed then Exit;
        case LIndexResult.Match of
          True:  FIndexResult := LIndexResult.Right;
          False: Begin
            TApplicationErrorView.Handle(LIndexResult.Left);
            Exit;
          End;
        end;

        DBGrid1.DataSource           := dtsIndex;
        dtsIndex.DataSet             := FIndexResult.Data.DataSet;
        edtNavCurrentPage.Text       := FIndexResult.CurrentPage.ToString;
        edtNavLimitPerPage.Text      := FIndexResult.LimitPerPage.ToString;
        btnNavPrior.Enabled          := FIndexResult.NavPrior;
        btnNavNext.Enabled           := FIndexResult.NavNext;
        btnNavFirst.Enabled          := FIndexResult.NavFirst;
        btnNavLast.Enabled           := FIndexResult.NavLast;
        edtNavLastPageNumber.Text    := FIndexResult.LastPageNumber.ToString;
        lblNavShowingRecords.Caption := 'Exibindo '+FIndexResult.CurrentPageRecordCount.ToString+
                                        ' registro(s) de '+FIndexResult.AllPagesRecordCount.ToString+'.';
        if (ATryLocateId > 0) then
          dtsIndex.DataSet.Locate('id', VarArrayOf([ATryLocateId]), []);
        FormatDataSet(dtsIndex.DataSet);
      finally
        // Encerrar Loading
        pnlNavigator.Enabled    := True;
        edtSearchValue.OnChange := edtSearchValueChange;
        LoadingSearch           := False;
      end;
    end)
  .Run;
end;

procedure TCashFlowIndexView.edtSearchValueChange(Sender: TObject);
begin
  inherited;
  if tmrDoSearch.Enabled then
    tmrDoSearch.Enabled := False;
  tmrDoSearch.Enabled := True;
end;

procedure TCashFlowIndexView.edtSearchValueKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  If (Key = #13) Then
  Begin
    if (tmrDoSearch.Enabled and (LoadingSearch = False)) then
    begin
      tmrDoSearch.Enabled := False;
      DoSearch;
    end;
    if DBGrid1.CanFocus then DBGrid1.SetFocus;
    DBGrid1.SelectedIndex := 3;
    Exit;
  End;
end;

procedure TCashFlowIndexView.FormCreate(Sender: TObject);
begin
  inherited;

  // Colunas de Pesquisa da Tabela
  cbxFilterIndex.Clear;
  cbxFilterIndex.Items.Add('ID ou ID da Estação');
  cbxFilterIndex.Items.Add('ID');

  // Carregar Config do Grid
  DBGridLoadConfig(DBGrid1, '');

  // Abrir pesquisa
  CleanFilter;
  DoSearch;
end;

procedure TCashFlowIndexView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  // INS - Novo Registro
  if (Key = VK_INSERT) then
  begin
    btnAppendClick(btnAppend);
    Exit;
  end;

  // F5 - Atualizar e setar focus em pesquisa
  if (Key = VK_F5) then
  begin
    DoSearch;
    if edtSearchValue.CanFocus then edtSearchValue.SelectAll;
    Exit;
  end;

  // Esc - Fechar Modal quando estiver pesquisando
  if (Key = VK_ESCAPE) and FLayoutLocate then
  begin
    btnLocateCloseClick(btnLocateClose);
    Exit;
  end;
end;

class function TCashFlowIndexView.HandleLocate: Int64;
begin
  Result := -1;

  const LView: SH<TCashFlowIndexView> = TCashFlowIndexView.Create(nil);
  LView.Value.SetLayoutLocate;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.LocateResult;
end;

procedure TCashFlowIndexView.imgDoSearchClick(Sender: TObject);
begin
  inherited;
  DoSearch;
end;

procedure TCashFlowIndexView.imgFilterCleanClick(Sender: TObject);
begin
  inherited;
  CleanFilter;
end;

procedure TCashFlowIndexView.imgOptionsClick(Sender: TObject);
begin
  inherited;
  ppmOptions.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

procedure TCashFlowIndexView.imgSearchClearClick(Sender: TObject);
begin
  inherited;
  CleanFilter;
  DoSearch;
end;

procedure TCashFlowIndexView.mniDeleteGridConfigClick(Sender: TObject);
begin
  inherited;
  // Excluir Grid
  dbgridDeleteConfig(DBGrid1, '');
  ToastView.Execute('Feche e abra a janela para carregar a nova configura��o.');
end;

procedure TCashFlowIndexView.mniSaveGridConfigClick(Sender: TObject);
begin
  inherited;
  // Salvar Config do Grid
  dbgridSaveConfig(DBGrid1, '');
  ToastView.Execute('Grade Salva');
end;

procedure TCashFlowIndexView.tmrDoSearchTimer(Sender: TObject);
begin
  inherited;
  tmrDoSearch.Enabled := False;
  DoSearch;
end;

end.
