unit uConsultEan.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExControls, JvButton,
  JvTransparentButton, Vcl.StdCtrls, JvExStdCtrls, JvEdit, JvValidateEdit,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons;

type
  TConsultEanView = class(TForm)
    pnlFundo: TPanel;
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    imgFechar: TImage;
    Label1: TLabel;
    Panel5: TPanel;
    edtProdCodigo: TEdit;
    Label2: TLabel;
    Panel1: TPanel;
    edtProdDescricao: TEdit;
    Label3: TLabel;
    Panel2: TPanel;
    edtProdPreco: TEdit;
    btnPesquisar: TSpeedButton;
    procedure imgFecharClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtProdCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure btnPesquisarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtProdCodigoEnter(Sender: TObject);
    procedure edtProdCodigoExit(Sender: TObject);
  private
    { Private declarations }
  public
    class function Handle: Integer;
  end;

var
  ConsultEanView: TConsultEanView;

implementation

{$R *.dfm}

uses
  uController.Factory,
  uAlert.View,
  uSmartPointer,
  uProduct.Show.DTO;

procedure TConsultEanView.btnPesquisarClick(Sender: TObject);
var
  lProductShowDTO: SH<TProductShowDTO>;
begin
  if String(edtProdCodigo.Text).Trim.IsEmpty then
    Exit;

  lProductShowDTO := TControllerFactory.Product.ShowByEanOrSkuCode(edtProdCodigo.Text);
  if not Assigned(lProductShowDTO.Value) then
  begin
    TAlertView.Handle('"PRODUTO" não localizado!');
    edtProdDescricao.Text   := '';
    edtProdPreco.Text := '0,00';
    Exit;
  end;

  edtProdDescricao.Text := lProductShowDTO.Value.name;
  edtProdPreco.Text     := FormatFloat('#,##0.00', lProductShowDTO.Value.price);
end;

procedure TConsultEanView.edtProdCodigoEnter(Sender: TObject);
begin
  if (Sender is TEdit) then
    (Sender as TEdit).Color := $00F7E8E1;
end;

procedure TConsultEanView.edtProdCodigoExit(Sender: TObject);
begin
  if (Sender is TEdit) then
    (Sender as TEdit).Color := clWindow;
end;

procedure TConsultEanView.edtProdCodigoKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13) and (edtProdCodigo.Text > '') Then
  Begin
    btnPesquisarClick(btnPesquisar);
    EXIT;
  End;
end;

procedure TConsultEanView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then
  Begin
    Close;
    EXIT;
  End;
end;

procedure TConsultEanView.FormShow(Sender: TObject);
begin
  edtProdCodigo.SetFocus;
end;

class function TConsultEanView.Handle: Integer;
var
  lView: TConsultEanView;
begin
  Try
    lView := TConsultEanView.Create(nil);
    lView.ShowModal;
  Finally
    if Assigned(lView) then
      FreeAndNil(lView);
  End;
end;

procedure TConsultEanView.imgFecharClick(Sender: TObject);
begin
  Close;
end;

end.
