unit uInfo.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExControls, JvButton,
  JvTransparentButton, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Skia,
  Skia.Vcl;

type
  TInfoView = class(TForm)
    pnlFundoBorda: TPanel;
    pnl02Conteudo: TPanel;
    memInfo: TMemo;
    pnl01Topo: TPanel;
    lblTitulo: TLabel;
    btnExportText: TJvTransparentButton;
    Panel1: TPanel;
    pnl03Botoes: TPanel;
    btnOk: TJvTransparentButton;
    SkAnimatedImage1: TSkAnimatedImage;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnExportTextClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function Handle(AMessage: String; ATitle: String = ''): Integer;
  end;

var
  InfoView: TInfoView;

implementation

uses
  uHlp,
  Winapi.ShellAPI;

{$R *.dfm}

class function TInfoView.Handle(AMessage, ATitle: String): Integer;
Var
  lView: TInfoView;
begin
  lView := TInfoView.Create(nil);
  Try
    if not ATitle.Trim.IsEmpty then lView.lblTitulo.Caption := ATitle;
    lView.memInfo.Lines.Text := AMessage;

    Result := lView.ShowModal;
  Finally
    lView.Hide;
    FreeAndNil(lView);
  End;
end;

procedure TInfoView.btnExportTextClick(Sender: TObject);
Var
  sArquivo: String;
begin
  sArquivo := ExtractFileDir(application.ExeName)+'\info.txt';
  memInfo.Lines.SaveToFile(sArquivo);
  ShellExecute(0,Nil,PChar(sArquivo),'', Nil, SW_SHOWNORMAL);
end;

procedure TInfoView.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TInfoView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_Return) then
    btnOkClick(Sender);
end;

procedure TInfoView.FormShow(Sender: TObject);
begin
  CreateDarkBackground(Self);

  memInfo.Lines.Add('');
  memInfo.Lines.Add('Pressione a tecla [ENTER] para fechar a mensagem.');
end;

end.
