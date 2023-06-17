unit uApplicationError.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvExControls, JvButton,
  JvTransparentButton, Vcl.StdCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Skia,
  Skia.Vcl;

type
  TApplicationErrorView = class(TForm)
    pnlFundoBorda: TPanel;
    pnl02Conteudo: TPanel;
    memInfo: TMemo;
    pnl03Botoes: TPanel;
    btnOk: TJvTransparentButton;
    Panel1: TPanel;
    btnExportText: TJvTransparentButton;
    SkAnimatedImage1: TSkAnimatedImage;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnExportTextClick(Sender: TObject);
  private
  public
    class function Handle(AMessage: String): Integer; overload;
    class function Handle(AException: Exception): Integer; overload;
  end;

implementation

uses
  uHlp,
  Winapi.ShellAPI,
  uHandle.Exception,
  uSmartPointer;

{$R *.dfm}

procedure TApplicationErrorView.btnExportTextClick(Sender: TObject);
begin
  const LArquivo = ExtractFileDir(application.ExeName)+'\alert.txt';
  memInfo.Lines.SaveToFile(LArquivo);
  ShellExecute(0,Nil,PChar(LArquivo),'', Nil, SW_SHOWNORMAL);
end;

procedure TApplicationErrorView.btnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TApplicationErrorView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_Return) and (Shift = [ssShift]) then
    btnOkClick(Sender);
end;

procedure TApplicationErrorView.FormShow(Sender: TObject);
begin
  CreateDarkBackground(Self);

  memInfo.Lines.Add('');
  memInfo.Lines.Add('Pressione a tecla [SHIFT] + [ENTER] para fechar a mensagem.');
end;

class function TApplicationErrorView.Handle(AMessage: String): Integer;
begin
  try
    const LView: SH<TApplicationErrorView> = TApplicationErrorView.Create(nil);
    LView.Value.memInfo.Lines.Text := AMessage;

    Result := lView.Value.ShowModal;
  except
  end;
end;

class function TApplicationErrorView.Handle(AException: Exception): Integer;
begin
  try
    const LView: SH<TApplicationErrorView> = TApplicationErrorView.Create(nil);
    const LMessage = 'Oops. Algum erro aconteceu!' + #13 +
                     THandleException.TranslateToLayMessage(AException.Message) + #13 + #13 +
                     'Mensagem Técnica: ' + #13 + AException.Message;
    LView.Value.memInfo.Lines.Text := LMessage;

    Result := LView.Value.ShowModal;
  except
  end;
end;

end.
