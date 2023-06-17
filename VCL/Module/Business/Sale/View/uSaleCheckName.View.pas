unit uSaleCheckName.View;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Imaging.pngimage,
  Vcl.ExtCtrls,
  Vcl.Buttons,
  Skia,
  Skia.Vcl;

type
  TSaleCheckNameView = class(TForm)
    pnlBackground: TPanel;
    pnl02Message: TPanel;
    pnl03Botoes: TPanel;
    pnlNo: TPanel;
    btnNo: TSpeedButton;
    pnlYes: TPanel;
    btnYes: TSpeedButton;
    imgYes: TImage;
    pnl01Titulo: TPanel;
    imgFechar: TImage;
    imgMinimizar: TImage;
    imgRestaurar: TImage;
    Panel1: TPanel;
    lblTitulo: TLabel;
    SkAnimatedImage1: TSkAnimatedImage;
    edtName: TEdit;
    Label1: TLabel;
    Timer1: TTimer;
    Label2: TLabel;
    procedure btnNoClick(Sender: TObject);
    procedure btnYesClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure edtFieldEnter(Sender: TObject);
    procedure edtFieldExit(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FName: String;
  public
    class function Handle: String;
  end;

var
  SaleCheckNameView: TSaleCheckNameView;

implementation

uses
  uHlp,
  uSmartPointer,
  uAlert.View,
  uTrans;

Const
  COLOR_ON_ENTER: TColor = $00F3ECE4;
  COLOR_ON_EXIT: TColor  = clWindow;

{$R *.dfm}

class function TSaleCheckNameView.Handle: String;
begin
  const LView: SH<TSaleCheckNameView> = TSaleCheckNameView.Create(nil);
  if not (LView.Value.ShowModal = MrOK) then
  Begin
    Result := EmptyStr;
    Exit;
  End;

  Result := LView.Value.FName;
end;

procedure TSaleCheckNameView.Timer1Timer(Sender: TObject);
begin
  pnlYes.Visible := (String(edtName.Text).Trim.Length >= 3);
end;

procedure TSaleCheckNameView.btnNoClick(Sender: TObject);
begin
  ModalResult := MrCancel;
end;

procedure TSaleCheckNameView.btnYesClick(Sender: TObject);
begin
  if (String(edtName.Text).Trim.Length < 3) then
  Begin
    TAlertView.Handle('Nome/Identificação deve conter no mínimo "3" caracteres.', Trans.ValidationError);
    ModalResult := Mrcancel;
  End;

  FName := String(edtName.Text).Trim;
  ModalResult := MrOK;
end;

procedure TSaleCheckNameView.edtFieldEnter(Sender: TObject);
begin
  if (Sender is TEdit) then
    TEdit(Sender).Color := COLOR_ON_ENTER;
end;

procedure TSaleCheckNameView.edtFieldExit(Sender: TObject);
begin
  if (Sender is TEdit) then
    TEdit(Sender).Color := COLOR_ON_EXIT;
end;

procedure TSaleCheckNameView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Esc - Botão NÃO
  if (Key = VK_ESCAPE) then
  Begin
    btnNoClick(btnNo);
    Exit;
  End;

  // Enter - Botão SIM
  if (Key = VK_RETURN) then
  Begin
    btnYesClick(btnYes);
    Exit;
  End;
end;

procedure TSaleCheckNameView.FormShow(Sender: TObject);
begin
  CreateDarkBackground(Self);
  edtName.SetFocus;
end;

end.
