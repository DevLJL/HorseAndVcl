unit uPersonContact.Input.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons, uBase.Input.View,
  Skia, Skia.Vcl, JvExComCtrls, JvComCtrls,

  uAppVcl.Types,
  uZLMemTable.Interfaces,
  uPerson.ViewModel.Interfaces;

type
  TPersonContactInputView = class(TBaseInputView)
    Label22: TLabel;
    Panel5: TPanel;
    dtsPersonContact: TDataSource;
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
    FViewModel: IPersonViewModel;
    FViewModelBackup: IZLMemTable;
    FViewModelBackupRecNumber: Integer;
    procedure BeforeShow;
    function ValidateCurrentPersonContact: String;
  public
    class function Handle(AState: TEntityState; AViewModel: IPersonViewModel): Integer;
  end;

const
  TITLE_NAME = 'Pessoa > Contato';

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

{ TPersonContactInputView }

procedure TPersonContactInputView.BeforeShow;
begin
  // Efetua uma cópia para restaurar se necessário
  dtsPersonContact.DataSet := FViewModel.PersonContacts.DataSet;
  FViewModelBackup.FromDataSet(dtsPersonContact.DataSet);
  FViewModelBackupRecNumber := dtsPersonContact.DataSet.RecNo;

  // Iniciar Loading
  Try
    LoadingForm              := True;
    pnlBackground.Enabled    := False;
    pgc.Visible              := False;
    dtsPersonContact.DataSet := nil;

    case FState of
      TEntityState.Store: Begin
        lblTitle.Caption := TITLE_NAME + ' (Incluindo...)';
        FViewModel.PersonContacts.DataSet.Append;
      end;
      TEntityState.Update,
      TEntityState.View: Begin
        lblTitle.Caption := TITLE_NAME + ' (Editando...)';
        FViewModel.PersonContacts.DataSet.Edit;
      end;
    end;
  finally
    // Encerrar Loading
    LoadingForm              := false;
    pnlBackground.Enabled    := True;
    pgc.Visible              := True;
    dtsPersonContact.DataSet := FViewModel.PersonContacts.DataSet;
    edtname.SetFocus;
  end;
end;

procedure TPersonContactInputView.btnCancelClick(Sender: TObject);
begin
  inherited;

  // Cancelar Operação
  case FState of
    TEntityState.Store: Begin
      case dtsPersonContact.DataSet.State of
        dsInsert: dtsPersonContact.DataSet.Cancel;
        dsBrowse: dtsPersonContact.DataSet.Delete;
        dsEdit: Begin
          dtsPersonContact.DataSet.Cancel;
          dtsPersonContact.DataSet.Delete;
        end;
      end;
    end;
    TEntityState.Update: Begin
      // Restaurar dados anteriores (Evita erros)
      FViewModelBackup.DataSet.First;
      for var lI := 2 to FViewModelBackupRecNumber do
        FViewModelBackup.DataSet.Next;
      dtsPersonContact.DataSet.Edit;
      for var lI := 0 to Pred(dtsPersonContact.DataSet.Fields.Count) do
        dtsPersonContact.DataSet.Fields[lI].Value := FViewModelBackup.DataSet.FieldByName(dtsPersonContact.DataSet.Fields[lI].FieldName).Value;
      dtsPersonContact.DataSet.Post;
    end;
  end;

  ModalResult := MrCancel;
end;

procedure TPersonContactInputView.btnSaveClick(Sender: TObject);
begin
  btnFocus.SetFocus;
  Try
    // Ativar Loading
    LoadingSave := True;

    // Sempre salvar dataset para evitar erros
    if FViewModel.PersonContacts.DataSet.State in [dsInsert, dsEdit] then
      FViewModel.PersonContacts.DataSet.Post;

    // Validar dados
    const LErrors = ValidateCurrentPersonContact;
    if not LErrors.Trim.IsEmpty then
    begin
      TAlertView.Handle(LErrors);
      FViewModel.PersonContacts.DataSet.Edit;
      Abort;
    end;

    ModalResult := mrOk;
  Finally
    LoadingSave := False;
  End;
end;

procedure TPersonContactInputView.FormCreate(Sender: TObject);
begin
  inherited;
  FViewModelBackup := TMemTableFactory.Make;
  tmrAllowSave.Enabled := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TPersonContactInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TPersonContactInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TPersonContactInputView.Handle(AState: TEntityState; AViewModel: IPersonViewModel): Integer;
begin
  const LView: SH<TPersonContactInputView> = TPersonContactInputView.Create(nil);
  LView.Value.FState     := AState;
  LView.Value.FViewModel := AViewModel;
  Result                 := LView.Value.ShowModal;
end;

procedure TPersonContactInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (String(edtname.Text).Trim > '') or (String(edtphone.Text).Trim > '') or
                 (String(edtemail.Text).Trim > '');
  inherited;
end;

function TPersonContactInputView.ValidateCurrentPersonContact: String;
begin
  var LErrors := EmptyStr;
  With dtsPersonContact.DataSet do
  begin
    const LIsInvalid = FieldByName('name').AsString.Trim.IsEmpty and
                       FieldByName('phone').AsString.Trim.IsEmpty and
                       FieldByName('email').AsString.Trim.IsEmpty;
    if LIsInvalid then
      LErrors := LErrors + 'O campo [Nome, Telefone ou E-mail] é obrigatório.' + #13;

    if not FieldByName('legal_entity_number').AsString.Trim.IsEmpty and not CpfOrCnpjIsValid(FieldByName('legal_entity_number').AsString) then
      LErrors := LErrors + 'O campo [CPF/CNPJ] é inválido.' + #13;
  end;

  Result := lErrors;
end;

end.

