unit uSaleItem.Input.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Data.DB, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Controls, Vcl.Buttons, uBase.Input.View,
  Skia, Skia.Vcl, JvExComCtrls, JvComCtrls,

  uAppVcl.Types,
  uZLMemTable.Interfaces,
  uSale.ViewModel.Interfaces;

type
  TSaleItemInputView = class(TBaseInputView)
    dtsSaleItem: TDataSource;
    Label22: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label16: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel5: TPanel;
    edtproduct_name: TDBEdit;
    edtQuantity: TDBEdit;
    edtPrice: TDBEdit;
    edtUnitDiscount: TDBEdit;
    edttotal: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit3: TDBEdit;
    Panel1: TPanel;
    memNote: TDBMemo;
    Panel2: TPanel;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmrAllowSaveTimer(Sender: TObject);
    procedure edttotalKeyPress(Sender: TObject; var Key: Char);
  private
    FState: TEntityState;
    FViewModel: ISaleViewModel;
    FViewModelBackup: IZLMemTable;
    FViewModelBackupRecNumber: Integer;
    procedure BeforeShow;
    function ValidateCurrentSaleItem: String;
  public
    class function Handle(AState: TEntityState; AViewModel: ISaleViewModel): Integer;
  end;

const
  TITLE_NAME = 'Venda > Item';

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

{ TSaleItemInputView }

procedure TSaleItemInputView.BeforeShow;
begin
  // Efetua uma cópia para restaurar se necessário
  dtsSaleItem.DataSet := FViewModel.SaleItems.DataSet;
  FViewModelBackup.FromDataSet(dtsSaleItem.DataSet);
  FViewModelBackupRecNumber := dtsSaleItem.DataSet.RecNo;

  // Iniciar Loading
  Try
    LoadingForm              := True;
    pnlBackground.Enabled    := False;
    pgc.Visible              := False;
    dtsSaleItem.DataSet := nil;

    case FState of
      TEntityState.Store: Begin
        lblTitle.Caption := TITLE_NAME + ' (Incluindo...)';
        FViewModel.SaleItems.DataSet.Append;
      end;
      TEntityState.Update,
      TEntityState.View: Begin
        lblTitle.Caption := TITLE_NAME + ' (Editando...)';
        FViewModel.SaleItems.DataSet.Edit;
      end;
    end;
  finally
    // Encerrar Loading
    LoadingForm              := false;
    pnlBackground.Enabled    := True;
    pgc.Visible              := True;
    dtsSaleItem.DataSet := FViewModel.SaleItems.DataSet;
    if edtQuantity.CanFocus then
      edtQuantity.SetFocus;
  end;
end;

procedure TSaleItemInputView.btnCancelClick(Sender: TObject);
begin
  inherited;

  // Cancelar Operação
  case FState of
    TEntityState.Store: Begin
      case dtsSaleItem.DataSet.State of
        dsInsert: dtsSaleItem.DataSet.Cancel;
        dsBrowse: dtsSaleItem.DataSet.Delete;
        dsEdit: Begin
          dtsSaleItem.DataSet.Cancel;
          dtsSaleItem.DataSet.Delete;
        end;
      end;
    end;
    TEntityState.Update: Begin
      // Restaurar dados anteriores (Evita erros)
      FViewModelBackup.DataSet.First;
      for var lI := 2 to FViewModelBackupRecNumber do
        FViewModelBackup.DataSet.Next;
      dtsSaleItem.DataSet.Edit;
      for var lI := 0 to Pred(dtsSaleItem.DataSet.Fields.Count) do
        dtsSaleItem.DataSet.Fields[lI].Value := FViewModelBackup.DataSet.FieldByName(dtsSaleItem.DataSet.Fields[lI].FieldName).Value;
      dtsSaleItem.DataSet.Post;
    end;
  end;

  ModalResult := MrCancel;
end;

procedure TSaleItemInputView.btnSaveClick(Sender: TObject);
begin
  btnFocus.SetFocus;
  Try
    // Ativar Loading
    LoadingSave := True;

    // Sempre salvar dataset para evitar erros
    if FViewModel.SaleItems.DataSet.State in [dsInsert, dsEdit] then
      FViewModel.SaleItems.DataSet.Post;

    // Validar dados
    const LErrors = ValidateCurrentSaleItem;
    if not LErrors.Trim.IsEmpty then
    begin
      TAlertView.Handle(LErrors);
      FViewModel.SaleItems.DataSet.Edit;
      Abort;
    end;

    ModalResult := mrOk;
  Finally
    LoadingSave := False;
  End;
end;

procedure TSaleItemInputView.edttotalKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if (key = #13) then
    btnSaveClick(btnSave);
end;

procedure TSaleItemInputView.FormCreate(Sender: TObject);
begin
  inherited;
  FViewModelBackup := TMemTableFactory.Make;
  tmrAllowSave.Enabled := True;
  tmrAllowSaveTimer(tmrAllowSave);
end;

procedure TSaleItemInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TSaleItemInputView.FormShow(Sender: TObject);
begin
  inherited;
  BeforeShow;
end;

class function TSaleItemInputView.Handle(AState: TEntityState; AViewModel: ISaleViewModel): Integer;
begin
  const LView: SH<TSaleItemInputView> = TSaleItemInputView.Create(nil);
  LView.Value.FState     := AState;
  LView.Value.FViewModel := AViewModel;
  Result                 := LView.Value.ShowModal;
end;

procedure TSaleItemInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  FormIsValid := (StrFloat(edtQuantity.Text) > 0) and (StrFloat(edtPrice.Text) > 0) and (StrFloat(edttotal.Text) > 0);
  inherited;
end;

function TSaleItemInputView.ValidateCurrentSaleItem: String;
begin
  var LErrors := EmptyStr;
  With dtsSaleItem.DataSet do
  begin
    if (FieldByName('quantity').AsFloat <= 0) then
      LErrors := 'O campo [Quantidade] deve ser superior a "ZERO".' + #13;
    if (FieldByName('price').AsFloat <= 0) then
      LErrors := 'O campo [Preço] deve ser superior a "ZERO".' + #13;
    if (FieldByName('total').AsFloat <= 0) then
      LErrors := 'O campo [Total] deve ser superior a "ZERO".' + #13;
  end;

  Result := LErrors;
end;


end.

