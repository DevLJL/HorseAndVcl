unit uPerson.Input.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons, uBase.Input.View,
  Skia, Skia.Vcl, Vcl.Grids, Vcl.DBGrids, JvExDBGrids,  JvExComCtrls, JvComCtrls,

  uAppVcl.Types,
  uPerson.ViewModel.Interfaces,
  uSmartPointer,
  uPerson.Show.DTO;

type
  TPersonInputView = class(TBaseInputView)
    dtsPerson: TDataSource;
    Label22: TLabel;
    Label35: TLabel;
    Label1: TLabel;
    Label15: TLabel;
    Label4: TLabel;
    Label16: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    Label21: TLabel;
    Label7: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label8: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Panel5: TPanel;
    edtId: TDBEdit;
    chkflg_seller: TDBCheckBox;
    chkflg_supplier: TDBCheckBox;
    chkflg_carrier: TDBCheckBox;
    chkflg_technician: TDBCheckBox;
    chkflg_employee: TDBCheckBox;
    chkflg_other: TDBCheckBox;
    chkflg_customer: TDBCheckBox;
    chkflg_final_customer: TDBCheckBox;
    Panel1: TPanel;
    edtlegal_entity_number: TDBEdit;
    edtstate_registration: TDBEdit;
    edtmunicipal_registration: TDBEdit;
    Panel26: TPanel;
    Panel27: TPanel;
    imgLocaLegalNumberEntity: TImage;
    loadLegalEntityNumber: TActivityIndicator;
    rdgicms_taxpayer: TDBRadioGroup;
    edtname: TDBEdit;
    edtalias_name: TDBEdit;
    Panel2: TPanel;
    edtzipcode: TDBEdit;
    edtaddress: TDBEdit;
    Panel7: TPanel;
    Panel9: TPanel;
    imgLocaZipcode: TImage;
    edtaddress_number: TDBEdit;
    edtcomplement: TDBEdit;
    edtdistrict: TDBEdit;
    edtcity_id: TDBEdit;
    Panel10: TPanel;
    Panel12: TPanel;
    imgLocaCity: TImage;
    edtcity_name: TDBEdit;
    edtcity_state: TDBEdit;
    edtreference_point: TDBEdit;
    Panel3: TPanel;
    edtphone_1: TDBEdit;
    edtphone_2: TDBEdit;
    edtphone_3: TDBEdit;
    edtinternet_page: TDBEdit;
    edtcompany_email: TDBEdit;
    edtfinancial_email: TDBEdit;
    loadZipCode: TActivityIndicator;
    TabSheet1: TTabSheet;
    Panel16: TPanel;
    Panel20: TPanel;
    Label42: TLabel;
    Panel21: TPanel;
    Panel22: TPanel;
    memNote: TDBMemo;
    Panel17: TPanel;
    Label33: TLabel;
    Panel18: TPanel;
    Panel19: TPanel;
    membank_note: TDBMemo;
    Panel23: TPanel;
    Label34: TLabel;
    Panel24: TPanel;
    Panel25: TPanel;
    memcommercial_note: TDBMemo;
    TabSheet2: TTabSheet;
    dtsPersonContacts: TDataSource;
    pnlContact: TPanel;
    dbgPersonContacts: TDBGrid;
    Panel29: TPanel;
    imgPersonContactsAdd: TImage;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
    procedure dbgPersonContactsCellClick(Column: TColumn);
    procedure dbgPersonContactsDblClick(Sender: TObject);
    procedure dbgPersonContactsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure imgPersonContactsAddClick(Sender: TObject);
    procedure btnPersonContactsEditClick(Sender: TObject);
    procedure btnPersonContactsDeleteClick(Sender: TObject);
    procedure imgLocaLegalNumberEntityClick(Sender: TObject);
    procedure imgLocaCityClick(Sender: TObject);
    procedure imgLocaZipcodeClick(Sender: TObject);
  private
    FViewModel: IPersonViewModel;
    FHandleResult: TPersonShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    FPhone1: String;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0; APhone1: String = ''): TPersonShowDTO;
  end;

const
  TITLE_NAME = 'Pessoa';

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
  uPerson.Input.DTO,
  uPerson.ViewModel,
  uPerson.Service,
  uHlp,
  uCity.Index.View,
  uPersonContact.Input.View,
  uSearchLegalEntityNumber.Lib,
  uSearchZipCode.Lib,
  uIndexResult,
  uCity.Service,
  uCity.Filter.DTO,
  uCity.Input.DTO,
  uCity.Show.DTO;

{ TPersonInputView }
procedure TPersonInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm               := True;
  dtsPerson.DataSet         := nil;
  dtsPersonContacts.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TPersonViewModel.Make;
      case FState of
        TEntityState.Store: Begin
          FViewModel.Person.Append;
          if not FPhone1.Trim.IsEmpty then
            FViewModel.Person.FieldByName('phone_1').Text := FPhone1;
        End;
        TEntityState.Update,
        TEntityState.View: Begin
          const LPersonShowDTO: SH<TPersonShowDTO> = TPersonService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LPersonShowDTO);
          FViewModel.Person.Edit;
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
      LoadingForm               := False;
      dtsPerson.DataSet         := FViewModel.Person.DataSet;
      dtsPersonContacts.DataSet := FViewModel.PersonContacts.DataSet;
      if edtName.CanFocus then
        edtName.SetFocus;
    end)
  .Run;
end;

procedure TPersonInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TPersonInputView.btnPersonContactsDeleteClick(Sender: TObject);
begin
  // Mensagem de Sim/Não
  if not (TYesOrNoView.Handle(Trans.DoYouWantToDeleteSelectedRecord, Trans.Exclusion) = mrOK) then
    Exit;

  Try
    LockControl(pnlBackground);

    dtsPersonContacts.DataSet.Delete;
    ToastView.Execute(Trans.RecordDeleted, tneError);
  Finally
    UnLockControl(pnlBackground);
  End;
end;

procedure TPersonInputView.btnPersonContactsEditClick(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsPersonContacts.DataSet) and dtsPersonContacts.DataSet.Active and (dtsPersonContacts.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  Try
    LockControl(pnlBackground);

    // Incluir Novo Contato
    TPersonContactInputView.Handle(TEntityState.Update, FViewModel);
  Finally
    UnLockControl(pnlBackground);
  End;
end;

procedure TPersonInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TPersonShowDTO>;
begin
  inherited;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Sempre salvar dataset para evitar erros
  if FViewModel.Person.State in [dsInsert, dsEdit] then
    FViewModel.Person.Post;

  // Iniciar Loading
  LoadingSave               := True;
  LoadingForm               := True;
  dtsPerson.DataSet         := nil;
  dtsPersonContacts.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LPersonInputDTO: SH<TPersonInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TPersonService.Make.StoreAndShow(LPersonInputDTO);
        TEntityState.Update: LSaved := TPersonService.Make.UpdateAndShow(FEditPK, LPersonInputDTO);
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

          FViewModel.Person.Edit;
          ToastView.Execute(Trans.RecordValidationFailed, tneError);
          Exit;
        end;

        // Retornar registro inserido/atualizado
        ToastView.Execute(Trans.RecordSaved, tneSuccess);
        FHandleResult := LSaved.Right;
        ModalResult   := MrOK;
      finally
        // Encerrar Loading
        LoadingSave               := False;
        LoadingForm               := False;
        dtsPerson.DataSet         := FViewModel.Person.DataSet;
        dtsPersonContacts.DataSet := FViewModel.PersonContacts.DataSet;
      end;
    end)
  .Run;
end;

procedure TPersonInputView.dbgPersonContactsCellClick(Column: TColumn);
begin
  inherited;
  const LKeepGoing = Assigned(dtsPersonContacts.DataSet) and dtsPersonContacts.DataSet.Active and (dtsPersonContacts.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  // Editar
  if (AnsiLowerCase(Column.FieldName) = 'action_edit') then
    btnPersonContactsEditClick(dbgPersonContacts);

  // Deletar
  if (AnsiLowerCase(Column.FieldName) = 'action_delete') then
    btnPersonContactsDeleteClick(dbgPersonContacts);
end;

procedure TPersonInputView.dbgPersonContactsDblClick(Sender: TObject);
begin
  const LKeepGoing = Assigned(dtsPersonContacts.DataSet) and dtsPersonContacts.DataSet.Active and (dtsPersonContacts.DataSet.RecordCount > 0);
  if not LKeepGoing then
    Exit;

  Try
    LockControl(pnlBackground);

    // Editar Contato
    TPersonContactInputView.Handle(TEntityState.Update, FViewModel);
  Finally
    UnLockControl(pnlBackground);
  End;
end;

procedure TPersonInputView.dbgPersonContactsDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  const LKeepGoing = Assigned(dtsPersonContacts.DataSet) and (dtsPersonContacts.DataSet.Active) and (dtsPersonContacts.DataSet.RecordCount > 0);
  if not LKeepGoing then
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

procedure TPersonInputView.FormCreate(Sender: TObject);
begin
  inherited;
  pgc.ActivePageIndex           := 0;
  loadLegalEntityNumber.Visible := False;
  loadZipCode.Visible           := False;
  tmrAllowSave.Enabled          := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TPersonInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

  // F1 - Localizar CPF/CNPJ
  if (Key = VK_F1) and (edtlegal_entity_number.Focused) then
  begin
    imgLocaLegalNumberEntityClick(imgLocaLegalNumberEntity);
    Exit;
  end;

  // F1 - Localizar Cep
  if (Key = VK_F1) and (edtzipcode.Focused) then
  begin
    imgLocaZipcodeClick(imgLocaZipcode);
    Exit;
  end;

  // F1 - Localizar Cidade
  if (Key = VK_F1) and (edtcity_id.Focused or edtcity_name.Focused or edtcity_state.Focused) then
  begin
    imgLocaCityClick(imgLocaCity);
    Exit;
  end;
end;

procedure TPersonInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TPersonInputView.Handle(AState: TEntityState; AEditPK: Int64; APhone1: String): TPersonShowDTO;
begin
  Result := nil;
  const LView: SH<TPersonInputView> = TPersonInputView.Create(nil);
  LView.Value.EditPK  := AEditPK;
  LView.Value.FPhone1 := OnlyNumbers(APhone1);
  LView.Value.State   := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TPersonInputView.imgLocaCityClick(Sender: TObject);
begin
  const LPk = TCityIndexView.HandleLocate;
  if (lPk > 0) then
    dtsPerson.DataSet.FieldByName('city_id').Text := lPk.ToString;
end;

procedure TPersonInputView.imgLocaLegalNumberEntityClick(Sender: TObject);
var
  LLegalEntityNumber: String;
  LLib: ISearchLegalEntityNumberLib;
begin
  if loadLegalEntityNumber.Animate then
    Exit;

  // Interromper se CNPJ inválido
  if edtstate_registration.CanFocus then
    edtstate_registration.SetFocus;
  LLegalEntityNumber := removeDots(dtsPerson.DataSet.FieldByName('legal_entity_number').AsString);
  if (Length(LLegalEntityNumber) <> 14) or (validateCpfCnpj(LLegalEntityNumber).Trim.IsEmpty) Then
  Begin
    ToastView.Execute('CNPJ informado é inválido!', tneError);
    Exit;
  End;

  // Iniciar Loading
  loadLegalEntityNumber.Visible := True;
  loadLegalEntityNumber.Animate := True;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      LLib := TSearchLegalEntityNumberLib.Make(LLegalEntityNumber).Execute;
    end)
  .OnException_Sync(
    procedure(ATask : ITask; AException : Exception)
    begin
      MessageDlg(
        Trans.OopsMessage + #13 +
        THandleException.TranslateToLayMessage(AException.Message) + #13 + #13 +
        'Mensagem Técnica: ' + AException.Message,
        mtWarning, [mbOK], 0
      );
    end)
  .OnTerminated_Sync(
    procedure(ATask: ITask)
    var
      lKeepGoing: Boolean;
    begin
      Try
        // Exibir erro se ocorrer
        if not LLib.ResponseError.Trim.IsEmpty then
        begin
          ToastView.Execute(LLib.ResponseError, tneError);
          Exit;
        end;

        // Evitar erros
        lKeepGoing := Assigned(dtsPerson.DataSet) and dtsPerson.DataSet.Active and (dtsPerson.DataSet.State in [dsInsert, dsEdit]);
        if not lKeepGoing then
          Exit;

        // Carregar Resultado
        With dtsPerson.DataSet do
        begin
          FieldByName('name').AsString           := LLib.ResponseData.Name;
          FieldByName('alias_name').AsString     := LLib.ResponseData.AliasName;
          FieldByName('phone_1').AsString        := LLib.ResponseData.Phone;
          FieldByName('company_email').AsString  := LLib.ResponseData.Email;
          FieldByName('address').AsString        := LLib.ResponseData.Address;
          FieldByName('address_number').AsString := LLib.ResponseData.AddressNumber;
          FieldByName('district').AsString       := LLib.ResponseData.District;
          FieldByName('zipcode').AsString        := LLib.ResponseData.ZipCode;
        end;

        // Localizar/cadastrar cidade pelo cep
        if (Length(LLib.ResponseData.ZipCode) = 8) then
          imgLocaZipcodeClick(imgLocaZipcode);
      finally
        // Encerrar Loading
        loadLegalEntityNumber.Visible := False;
        loadLegalEntityNumber.Animate := False;
      end;
    end)
  .Run;
end;
procedure TPersonInputView.imgLocaZipcodeClick(Sender: TObject);
var
  LZipCode: String;
  LLib: ISearchZipCodeLib;
  LIndexResult: IIndexResult;
begin
  if loadZipCode.Animate then
    Exit;

  // Interromper se cep inválido
  if edtaddress.CanFocus then
    edtaddress.SetFocus;
  LZipCode := removeDots(dtsPerson.DataSet.FieldByName('zipcode').AsString);
  if (Length(LZipCode) <> 8) Then
  begin
    ToastView.Execute('Cep deve conter 8 caracteres.', tneError);
    Exit;
  End;

  // Ativar Loading
  loadZipCode.Visible := True;
  loadZipCode.Animate := True;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      // Localizar endereço por API
      LLib := TSearchZipcodeLib.Make(LZipCode).Execute;
      if not LLib.ResponseError.Trim.IsEmpty then
        raise Exception.Create(LLib.ResponseError);

      // Se não existir, cria
      const LCityService = TCityService.Make;
      const LCityFilter: SH<TCityFilterDTO> = TCityFilterDTO.Create;
      LCityFilter.Value.ibge_code := LLib.ResponseData.CityIbgeCode;
      LIndexResult := LCityService.Index(LCityFilter).Right;
      if LIndexResult.Data.IsEmpty then
      begin
        const LCityInputDTO: SH<TCityInputDTO> = TCityInputDTO.Create;
        With LCityInputDTO.Value do
        begin
          name              := LLib.ResponseData.City;
          state             := LLib.ResponseData.State;
          country           := LLib.ResponseData.Country;
          ibge_code         := LLib.ResponseData.CityIbgeCode;
          country_ibge_code := LLib.ResponseData.CountryIbgeCode;
        end;
        const LResult = LCityService.StoreAndShow(LCityInputDTO);
        case LResult.Match of
          False: raise Exception.Create(LResult.Left);
          True:  const LCityStored: SH<TCityShowDTO> = LResult.Right;
        end;

        LIndexResult := LCityService.Index(LCityFilter).Right;
      end;
    end)
  .OnException_Sync(
    procedure(ATask : ITask; AException : Exception)
    begin
      MessageDlg(
        Trans.OopsMessage + #13 + #13 +
        AException.Message,
        mtWarning, [mbOK], 0
      );
    end)
  .OnTerminated_Sync(
    procedure(ATask: ITask)
    begin
      Try
        // Task Falhou
        const LTaskFailed = ATask.Failed or not Assigned(LIndexResult);
        if LTaskFailed then
          Exit;

        // Evitar erros
        const LKeepGoing = assigned(dtsPerson.DataSet) and dtsPerson.DataSet.Active and (dtsPerson.DataSet.State in [dsInsert, dsEdit]);
        if not LKeepGoing then
          Exit;

        // Carregar resultado
        With dtsPerson.DataSet do
        begin
          FieldByName('address').AsString     := LLib.ResponseData.Address;
          FieldByName('district').AsString    := LLib.ResponseData.District;
          FieldByName('city_id').AsLargeInt   := LIndexResult.Data.FieldByName('id').AsLargeInt;
          FieldByName('city_name').AsString   := LIndexResult.Data.FieldByName('name').AsString;
          FieldByName('city_state').AsString  := LIndexResult.Data.FieldByName('state').AsString;
        end;
      finally
        loadZipCode.Visible := False;
        loadZipCode.Animate := False;
      end;
    end)
  .Run;
end;

procedure TPersonInputView.imgPersonContactsAddClick(Sender: TObject);
begin
  inherited;
  Try
    LockControl(pnlBackground);

    // Incluir Novo Registro
    TPersonContactInputView.Handle(TEntityState.Store, FViewModel);
  Finally
    UnLockControl(pnlBackground);
  End;
end;

procedure TPersonInputView.SetState(const Value: TEntityState);
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

procedure TPersonInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (String(edtname.Text).Trim > '') and (String(edtaddress.Text).Trim > '') and
                 (String(edtdistrict.Text).Trim > '') and (String(edtcity_id.Text).Trim > '') and
                 (String(edtcity_name.Text).Trim > '') and (String(edtphone_1.Text).Trim > '');
  inherited;
end;

end.

