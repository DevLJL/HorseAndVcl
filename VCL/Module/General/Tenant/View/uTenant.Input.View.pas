unit uTenant.Input.View;

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
  uTenant.ViewModel.Interfaces,
  uSmartPointer,
  uTenant.Show.DTO;

type
  TTenantInputView = class(TBaseInputView)
    dtsTenant: TDataSource;
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
    edtId: TDBEdit;
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
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Panel29: TPanel;
    Panel30: TPanel;
    Label13: TLabel;
    Panel31: TPanel;
    chksend_email_app_default: TDBCheckBox;
    pnlEmailConfiguration: TPanel;
    Label14: TLabel;
    Label17: TLabel;
    Label22: TLabel;
    Label26: TLabel;
    Label33: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    RadioGroup1: TRadioGroup;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    Panel33: TPanel;
    Label34: TLabel;
    Panel34: TPanel;
    Panel35: TPanel;
    Label36: TLabel;
    Label37: TLabel;
    Label45: TLabel;
    DBEdit7: TDBEdit;
    Button1: TButton;
    DBEdit2: TDBEdit;
    Panel36: TPanel;
    Label38: TLabel;
    Label42: TLabel;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
    procedure imgLocaLegalNumberEntityClick(Sender: TObject);
    procedure imgLocaCityClick(Sender: TObject);
    procedure imgLocaZipcodeClick(Sender: TObject);
    procedure chksend_email_app_defaultClick(Sender: TObject);
  private
    FViewModel: ITenantViewModel;
    FHandleResult: TTenantShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0): TTenantShowDTO;
  end;

const
  TITLE_NAME = 'Companhia';

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
  uTenant.Input.DTO,
  uTenant.ViewModel,
  uTenant.Service,
  uHlp,
  uCity.Index.View,
  uSearchLegalEntityNumber.Lib,
  uSearchZipCode.Lib,
  uIndexResult,
  uCity.Service,
  uCity.Filter.DTO,
  uCity.Input.DTO,
  uCity.Show.DTO;

{ TTenantInputView }
procedure TTenantInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm        := True;
  dtsTenant.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TTenantViewModel.Make;
      case FState of
        TEntityState.Store: FViewModel.Tenant.Append;
        TEntityState.Update,
        TEntityState.View: Begin
          const LTenantShowDTO: SH<TTenantShowDTO> = TTenantService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LTenantShowDTO);
          FViewModel.Tenant.Edit;
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
      LoadingForm        := False;
      dtsTenant.DataSet := FViewModel.Tenant.DataSet;
      if edtName.CanFocus then
        edtName.SetFocus;
    end)
  .Run;
end;

procedure TTenantInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TTenantInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TTenantShowDTO>;
begin
  inherited;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Sempre salvar dataset para evitar erros
  if FViewModel.Tenant.State in [dsInsert, dsEdit] then
    FViewModel.Tenant.Post;

  // Iniciar Loading
  LoadingSave               := True;
  LoadingForm               := True;
  dtsTenant.DataSet         := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LTenantInputDTO: SH<TTenantInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TTenantService.Make.StoreAndShow(LTenantInputDTO);
        TEntityState.Update: LSaved := TTenantService.Make.UpdateAndShow(FEditPK, LTenantInputDTO);
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

          FViewModel.Tenant.Edit;
          ToastView.Execute(Trans.RecordValidationFailed, tneError);
          Exit;
        end;

        // Retornar registro inserido/atualizado
        ToastView.Execute(Trans.RecordSaved, tneSuccess);
        FHandleResult := LSaved.Right;
        ModalResult   := MrOK;
      finally
        // Encerrar Loading
        LoadingSave        := False;
        LoadingForm        := False;
        dtsTenant.DataSet := FViewModel.Tenant.DataSet;
      end;
    end)
  .Run;
end;

procedure TTenantInputView.chksend_email_app_defaultClick(Sender: TObject);
begin
  inherited;
  pnlEmailConfiguration.Visible := not chksend_email_app_default.Checked;
end;

procedure TTenantInputView.FormCreate(Sender: TObject);
begin
  inherited;
  pgc.ActivePageIndex           := 0;
  loadLegalEntityNumber.Visible := False;
  loadZipCode.Visible           := False;
  tmrAllowSave.Enabled          := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TTenantInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TTenantInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TTenantInputView.Handle(AState: TEntityState; AEditPK: Int64): TTenantShowDTO;
begin
  Result := nil;
  const LView: SH<TTenantInputView> = TTenantInputView.Create(nil);
  LView.Value.EditPK := AEditPK;
  LView.Value.State  := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TTenantInputView.imgLocaCityClick(Sender: TObject);
begin
  const LPk = TCityIndexView.HandleLocate;
  if (lPk > 0) then
    dtsTenant.DataSet.FieldByName('city_id').Text := lPk.ToString;
end;

procedure TTenantInputView.imgLocaLegalNumberEntityClick(Sender: TObject);
var
  LLegalEntityNumber: String;
  LLib: ISearchLegalEntityNumberLib;
begin
  if loadLegalEntityNumber.Animate then
    Exit;

  // Interromper se CNPJ inválido
  if edtstate_registration.CanFocus then
    edtstate_registration.SetFocus;
  LLegalEntityNumber := removeDots(dtsTenant.DataSet.FieldByName('legal_entity_number').AsString);
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
        lKeepGoing := Assigned(dtsTenant.DataSet) and dtsTenant.DataSet.Active and (dtsTenant.DataSet.State in [dsInsert, dsEdit]);
        if not lKeepGoing then
          Exit;

        // Carregar Resultado
        With dtsTenant.DataSet do
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
procedure TTenantInputView.imgLocaZipcodeClick(Sender: TObject);
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
  LZipCode := removeDots(dtsTenant.DataSet.FieldByName('zipcode').AsString);
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
        const LKeepGoing = assigned(dtsTenant.DataSet) and dtsTenant.DataSet.Active and (dtsTenant.DataSet.State in [dsInsert, dsEdit]);
        if not LKeepGoing then
          Exit;

        // Carregar resultado
        With dtsTenant.DataSet do
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

procedure TTenantInputView.SetState(const Value: TEntityState);
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

procedure TTenantInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (String(edtname.Text).Trim > '') and (String(edtaddress.Text).Trim > '') and
                 (String(edtdistrict.Text).Trim > '') and (String(edtcity_id.Text).Trim > '') and
                 (String(edtcity_name.Text).Trim > '') and (String(edtphone_1.Text).Trim > '');
  inherited;
end;

end.
