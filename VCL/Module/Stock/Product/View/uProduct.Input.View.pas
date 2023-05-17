unit uProduct.Input.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons, uBase.Input.View,
  Skia, Skia.Vcl, Vcl.Grids, Vcl.DBGrids, JvExDBGrids,  JvExComCtrls, JvComCtrls,
  JvExStdCtrls, JvCombobox, JvDBCombobox,

  uAppVcl.Types,
  uProduct.ViewModel.Interfaces,
  uSmartPointer,
  uProduct.Show.DTO;

type
  TProductInputView = class(TBaseInputView)
    dtsProduct: TDataSource;
    Label22: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label12: TLabel;
    Image1: TImage;
    Label37: TLabel;
    Label9: TLabel;
    Image2: TImage;
    Label10: TLabel;
    Image3: TImage;
    Label11: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label23: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label71: TLabel;
    Label34: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label13: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Panel5: TPanel;
    pnlFotoCapa: TPanel;
    Panel46: TPanel;
    Label83: TLabel;
    imgFotoCapa: TImage;
    btnIncluirFotoCapa: TImage;
    btnRemoverFotoCapa: TImage;
    edtName: TDBEdit;
    DBEdit5: TDBEdit;
    edtsku_code: TDBEdit;
    edtunit_name: TDBEdit;
    Panel41: TPanel;
    Panel42: TPanel;
    imgLocaUnit: TImage;
    edtunit_id: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit3: TDBEdit;
    JvDBComboBox1: TJvDBComboBox;
    DBCheckBox4: TDBCheckBox;
    DBMemo1: TDBMemo;
    DBMemo2: TDBMemo;
    Panel6: TPanel;
    edtbrand_name: TDBEdit;
    Panel37: TPanel;
    Panel38: TPanel;
    imgLocaBrand: TImage;
    edtbrand_id: TDBEdit;
    edtcategory_name: TDBEdit;
    Panel39: TPanel;
    Panel40: TPanel;
    imgLocaCategory: TImage;
    edtcategory_id: TDBEdit;
    edtstorage_location_name: TDBEdit;
    Panel43: TPanel;
    Panel44: TPanel;
    imgLocaStorageLocation: TImage;
    edtstorage_location_id: TDBEdit;
    edtsize_name: TDBEdit;
    Panel17: TPanel;
    Panel19: TPanel;
    imgLocaSize: TImage;
    edtsize_id: TDBEdit;
    Panel7: TPanel;
    Panel8: TPanel;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    edtncm_code: TDBEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    imgLocaNCM: TImage;
    edtncm_id: TDBEdit;
    edtncm_name: TDBEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
    procedure imgLocaUnitClick(Sender: TObject);
    procedure imgLocaCategoryClick(Sender: TObject);
    procedure imgLocaBrandClick(Sender: TObject);
    procedure imgLocaStorageLocationClick(Sender: TObject);
    procedure imgLocaSizeClick(Sender: TObject);
    procedure imgLocaNCMClick(Sender: TObject);
    procedure btnIncluirFotoCapaClick(Sender: TObject);
  private
    FViewModel: IProductViewModel;
    FHandleResult: TProductShowDTO;
    FState: TEntityState;
    FEditPK: Int64;
    procedure BeforeShow;
    procedure SetState(const Value: TEntityState);
    property  State: TEntityState read FState write SetState;
    property  EditPk: Int64 read FEditPk write FEditPk;
  public
    class function Handle(AState: TEntityState; AEditPK: Int64 = 0): TProductShowDTO;
  end;

const
  TITLE_NAME = 'Produto';

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
  uProduct.Input.DTO,
  uProduct.ViewModel,
  uProduct.Service,
  uUnit.Index.View,
  uCategory.Index.View,
  uBrand.Index.View,
  uStorageLocation.Index.View,
  uSize.Index.View,
  uNcm.Index.View,
  uHlp;

{ TProductInputView }
procedure TProductInputView.BeforeShow;
begin
  // Iniciar Loading
  LoadingForm      := True;
  dtsProduct.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      FViewModel := TProductViewModel.Make;
      case FState of
        TEntityState.Store: FViewModel.Product.Append;
        TEntityState.Update,
        TEntityState.View: Begin
          const LProductShowDTO: SH<TProductShowDTO> = TProductService.Make.Show(FEditPK);
          FViewModel.FromShowDTO(LProductShowDTO);
          FViewModel.Product.Edit;
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
      dtsProduct.DataSet := FViewModel.Product.DataSet;
      if edtName.CanFocus then
        edtName.SetFocus;
    end)
  .Run;
end;

procedure TProductInputView.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := MrCancel;
end;

procedure TProductInputView.btnIncluirFotoCapaClick(Sender: TObject);
begin
  inherited;
  TApplicationErrorView.Handle(Trans.FeatureDisabled);
end;

procedure TProductInputView.btnSaveClick(Sender: TObject);
var
  LSaved: Either<String, TProductShowDTO>;
begin
  inherited;

  // Não prosseguir se estiver carregando
  btnFocus.SetFocus;
  if LoadingSave or LoadingForm then
    Exit;

  // Sempre salvar dataset para evitar erros
  if FViewModel.Product.State in [dsInsert, dsEdit] then
    FViewModel.Product.Post;

  // Iniciar Loading
  LoadingSave      := True;
  LoadingForm      := True;
  dtsProduct.DataSet := nil;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      const LProductInputDTO: SH<TProductInputDTO> = FViewModel.ToInputDTO;
      case FState of
        TEntityState.Store:  LSaved := TProductService.Make.StoreAndShow(LProductInputDTO);
        TEntityState.Update: LSaved := TProductService.Make.UpdateAndShow(FEditPK, LProductInputDTO);
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

          FViewModel.Product.Edit;
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
        dtsProduct.DataSet := FViewModel.Product.DataSet;
      end;
    end)
  .Run;
end;

procedure TProductInputView.FormCreate(Sender: TObject);
begin
  inherited;
  pgc.Pages[0].TabVisible := False;
  pgc.ActivePageIndex     := 0;
  tmrAllowSave.Enabled    := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TProductInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

  // F1 - Localizar Unidade de Medida
  if (Key = VK_F1) and (edtunit_id.Focused or edtunit_name.Focused) then
  begin
    imgLocaUnitClick(imgLocaUnit);
    Exit;
  end;

  // F1 - Localizar Categoria
  if (Key = VK_F1) and (edtcategory_id.Focused or edtcategory_name.Focused) then
  begin
    imgLocaCategoryClick(imgLocaCategory);
    Exit;
  end;

  // F1 - Localizar Marca
  if (Key = VK_F1) and (edtbrand_id.Focused or edtbrand_name.Focused) then
  begin
    imgLocaBrandClick(imgLocaBrand);
    Exit;
  end;

  // F1 - Localizar Local de Armazenamento
  if (Key = VK_F1) and (edtstorage_location_id.Focused or edtstorage_location_name.Focused) then
  begin
    imgLocaStorageLocationClick(imgLocaStorageLocation);
    Exit;
  end;

  // F1 - Tamanho
  if (Key = VK_F1) and (edtsize_id.Focused or edtsize_name.Focused) then
  begin
    imgLocaSizeClick(imgLocaSize);
    Exit;
  end;

  // F1 - Localizar NCM
  if (Key = VK_F1) and (edtncm_id.Focused or edtncm_name.Focused or edtncm_code.Focused) then
  begin
    imgLocaNCMClick(imgLocaNCM);
    Exit;
  end;
end;

procedure TProductInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TProductInputView.Handle(AState: TEntityState; AEditPK: Int64): TProductShowDTO;
begin
  Result := nil;
  const LView: SH<TProductInputView> = TProductInputView.Create(nil);
  LView.Value.EditPK := AEditPK;
  LView.Value.State  := AState;
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  Result := LView.Value.FHandleResult;
end;

procedure TProductInputView.imgLocaBrandClick(Sender: TObject);
begin
  const LPk = TBrandIndexView.HandleLocate;
  if (LPk > 0) then
    dtsProduct.DataSet.FieldByName('brand_id').Text := LPk.ToString;
end;

procedure TProductInputView.imgLocaCategoryClick(Sender: TObject);
begin
  const LPk = TCategoryIndexView.HandleLocate;
  if (LPk > 0) then
    dtsProduct.DataSet.FieldByName('category_id').Text := LPk.ToString;
end;

procedure TProductInputView.imgLocaNCMClick(Sender: TObject);
begin
  const LPk = TNcmIndexView.HandleLocate;
  if (LPk > 0) then
    dtsProduct.DataSet.FieldByName('ncm_id').Text := LPk.ToString;
end;

procedure TProductInputView.imgLocaSizeClick(Sender: TObject);
begin
  const LPk = TSizeIndexView.HandleLocate;
  if (LPk > 0) then
    dtsProduct.DataSet.FieldByName('size_id').Text := LPk.ToString;
end;

procedure TProductInputView.imgLocaStorageLocationClick(Sender: TObject);
begin
  const LPk = TStorageLocationIndexView.HandleLocate;
  if (LPk > 0) then
    dtsProduct.DataSet.FieldByName('storage_location_id').Text := LPk.ToString;
end;

procedure TProductInputView.imgLocaUnitClick(Sender: TObject);
begin
  const LPk = TUnitIndexView.HandleLocate;
  if (LPk > 0) then
    dtsProduct.DataSet.FieldByName('unit_id').Text := LPk.ToString;
end;

procedure TProductInputView.SetState(const Value: TEntityState);
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

procedure TProductInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (String(edtName.Text).Trim > '') and (StrInt(edtunit_id.Text) > 0)
                 and (StrInt(edtncm_id.Text) > 0);
  inherited;
end;

end.

