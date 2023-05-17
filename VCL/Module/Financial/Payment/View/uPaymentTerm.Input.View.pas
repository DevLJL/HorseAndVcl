unit uPaymentTerm.Input.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons, uBase.Input.View,
  Skia, Skia.Vcl, JvExComCtrls, JvComCtrls,

  uAppVcl.Types,
  uZLMemTable.Interfaces,
  uPayment.ViewModel.Interfaces;

type
  TPaymentTermInputView = class(TBaseInputView)
    Label22: TLabel;
    Panel5: TPanel;
    dtsPaymentTerm: TDataSource;
    Label2: TLabel;
    Label10: TLabel;
    Label15: TLabel;
    Label27: TLabel;
    Label31: TLabel;
    Label6: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtname: TDBEdit;
    edtein: TDBEdit;
    edtphone: TDBEdit;
    edtemail: TDBEdit;
    cbxtype: TDBComboBox;
    Panel1: TPanel;
    memNote: TDBMemo;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
  private
    FState: TEntityState;
    FViewModel: IPaymentViewModel;
    FViewModelBackup: IZLMemTable;
    FViewModelBackupRecNumber: Integer;
    procedure BeforeShow;
    function ValidateCurrentPaymentTerm: String;
  public
    class function Handle(AState: TEntityState; AViewModel: IPaymentViewModel): Integer;
  end;

const
  TITLE_NAME = 'Pagamento > Contato';

implementation

uses
  Vcl.Dialogs,
  uHandle.Exception,
  uAlert.View,
  uMemTable.Factory,
  uHlp,
  uTrans,
  uSmartPointer;

{$R *.dfm}

{ TPaymentTermInputView }

procedure TPaymentTermInputView.BeforeShow;
begin
  // Efetua uma c�pia para restaurar se necess�rio
  dtsPaymentTerm.DataSet := FViewModel.PaymentTerms.DataSet;
  FViewModelBackup.FromDataSet(dtsPaymentTerm.DataSet);
  FViewModelBackupRecNumber := dtsPaymentTerm.DataSet.RecNo;

  // Iniciar Loading
  Try
    LoadingForm              := True;
    pnlBackground.Enabled    := False;
    pgc.Visible              := False;
    dtsPaymentTerm.DataSet := nil;

    case FState of
      TEntityState.Store: Begin
        lblTitle.Caption := TITLE_NAME + ' (Incluindo...)';
        FViewModel.PaymentTerms.DataSet.Append;
      end;
      TEntityState.Update,
      TEntityState.View: Begin
        lblTitle.Caption := TITLE_NAME + ' (Editando...)';
        FViewModel.PaymentTerms.DataSet.Edit;
      end;
    end;
  finally
    // Encerrar Loading
    LoadingForm              := false;
    pnlBackground.Enabled    := True;
    pgc.Visible              := True;
    dtsPaymentTerm.DataSet := FViewModel.PaymentTerms.DataSet;
    edtname.SetFocus;
  end;
end;

procedure TPaymentTermInputView.btnCancelClick(Sender: TObject);
begin
  inherited;

  // Cancelar Opera��o
  case FState of
    TEntityState.Store: Begin
      case dtsPaymentTerm.DataSet.State of
        dsInsert: dtsPaymentTerm.DataSet.Cancel;
        dsBrowse: dtsPaymentTerm.DataSet.Delete;
        dsEdit: Begin
          dtsPaymentTerm.DataSet.Cancel;
          dtsPaymentTerm.DataSet.Delete;
        end;
      end;
    end;
    TEntityState.Update: Begin
      // Restaurar dados anteriores (Evita erros)
      FViewModelBackup.DataSet.First;
      for var lI := 2 to FViewModelBackupRecNumber do
        FViewModelBackup.DataSet.Next;
      dtsPaymentTerm.DataSet.Edit;
      for var lI := 0 to Pred(dtsPaymentTerm.DataSet.Fields.Count) do
        dtsPaymentTerm.DataSet.Fields[lI].Value := FViewModelBackup.DataSet.FieldByName(dtsPaymentTerm.DataSet.Fields[lI].FieldName).Value;
      dtsPaymentTerm.DataSet.Post;
    end;
  end;

  ModalResult := MrCancel;
end;

procedure TPaymentTermInputView.btnSaveClick(Sender: TObject);
begin
  btnFocus.SetFocus;
  Try
    // Ativar Loading
    LoadingSave := True;

    // Sempre salvar dataset para evitar erros
    if FViewModel.PaymentTerms.DataSet.State in [dsInsert, dsEdit] then
      FViewModel.PaymentTerms.DataSet.Post;

    // Validar dados
    const LErrors = ValidateCurrentPaymentTerm;
    if not LErrors.Trim.IsEmpty then
    begin
      TAlertView.Handle(LErrors);
      FViewModel.PaymentTerms.DataSet.Edit;
      Abort;
    end;

    ModalResult := mrOk;
  Finally
    LoadingSave := False;
  End;
end;

procedure TPaymentTermInputView.FormCreate(Sender: TObject);
begin
  inherited;
  FViewModelBackup := TMemTableFactory.Make;
  tmrAllowSave.Enabled := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TPaymentTermInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;

  // Esc - Sair
  if (Key = VK_ESCAPE) then
  begin
    btnCancelClick(btnCancel);
    Exit;
  end;

  // F6 - Salvar
  if (Key = VK_F6) then
  begin
    btnSaveClick(btnSave);
    Exit;
  end;
end;

procedure TPaymentTermInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TPaymentTermInputView.Handle(AState: TEntityState; AViewModel: IPaymentViewModel): Integer;
begin
  const LView: SH<TPaymentTermInputView> = TPaymentTermInputView.Create(nil);
  LView.Value.FState     := AState;
  LView.Value.FViewModel := AViewModel;
  Result                 := LView.Value.ShowModal;
end;

procedure TPaymentTermInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (String(edtname.Text).Trim > '') or (String(edtphone.Text).Trim > '') or
                 (String(edtemail.Text).Trim > '');
  inherited;
end;

function TPaymentTermInputView.ValidateCurrentPaymentTerm: String;
begin
  var LErrors := EmptyStr;
  With dtsPaymentTerm.DataSet do
  begin
    const LIsInvalid = FieldByName('name').AsString.Trim.IsEmpty and
                       FieldByName('phone').AsString.Trim.IsEmpty and
                       FieldByName('email').AsString.Trim.IsEmpty;
    if LIsInvalid then
      LErrors := LErrors + 'O campo [Nome, Telefone ou E-mail] � obrigat�rio.' + #13;

    if not FieldByName('legal_entity_number').AsString.Trim.IsEmpty and not CpfOrCnpjIsValid(FieldByName('legal_entity_number').AsString) then
      LErrors := LErrors + 'O campo [CPF/CNPJ] � inv�lido.' + #13;
  end;

  Result := lErrors;
end;

end.

