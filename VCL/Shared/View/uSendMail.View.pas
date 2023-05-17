unit uSendMail.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Mask, Vcl.DBCtrls;

type
  TSendMailView = class(TForm)
    pnlBackground: TPanel;
    pnlContent: TPanel;
    pgc: TPageControl;
    tabMain: TTabSheet;
    pnlGeral: TPanel;
    Panel7: TPanel;
    pnlTitulo: TPanel;
    Label2: TLabel;
    imgCloseTitle: TImage;
    imgMinimizeTitle: TImage;
    imgTitle: TImage;
    pnlTitle2: TPanel;
    pnlBottomButtons: TPanel;
    pnlSave: TPanel;
    pnlSave2: TPanel;
    btnSendMail: TSpeedButton;
    pnlSave3: TPanel;
    imgSave: TImage;
    pnlCancel: TPanel;
    pnlCancel2: TPanel;
    btnCancel: TSpeedButton;
    pnlCancel3: TPanel;
    imgCancel4: TImage;
    btnFocus: TButton;
    Label12: TLabel;
    edtRecipient: TEdit;
    imgRecipientAdd: TImage;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    ltbRecipientList: TListBox;
    Label3: TLabel;
    edtRecipientCopy: TEdit;
    imgRecipientCopyAdd: TImage;
    Panel3: TPanel;
    Panel4: TPanel;
    Label4: TLabel;
    ltbRecipientCopyList: TListBox;
    Label5: TLabel;
    memBodyMessage: TMemo;
    Panel5: TPanel;
    Panel6: TPanel;
    ltbAttachments: TListBox;
    Label7: TLabel;
    Label10: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    edtSubject: TEdit;
    Label9: TLabel;
    Label11: TLabel;
    procedure imgMinimizeTitleClick(Sender: TObject);
    procedure imgCloseTitleClick(Sender: TObject);
    procedure imgRecipientAddClick(Sender: TObject);
    procedure ltbRecipientListDblClick(Sender: TObject);
    procedure edtRecipientKeyPress(Sender: TObject; var Key: Char);
    procedure edtRecipientCopyKeyPress(Sender: TObject; var Key: Char);
    procedure imgRecipientCopyAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSendMailClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtRecipientEnter(Sender: TObject);
    procedure edtRecipientExit(Sender: TObject);
    procedure edtRecipientKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ltbRecipientCopyListDblClick(Sender: TObject);
    procedure ltbAttachmentsDblClick(Sender: TObject);
  private
    { Private declarations }
    FRecipients: String;
    FRecipientsCopy: String;
    FSubject: String;
    FBodyMessage: String;
    FAttachments: String;
  public
    { Public declarations }
    class function Handle(ARecipients, ARecipientsCopy, ASubject, ABodyMessage, AAttachments: String): Integer;
    function BeforeShow: TSendMailView;
  end;

var
  SendMailView: TSendMailView;

implementation

uses
  uHlp,
  uAlert.View,
  uNotificationView,
  uYesOrNo.View,
  Winapi.ShellAPI, uSession.DTM;

Const
  COLOR_ON_ENTER: TColor = $00F3ECE4;
  COLOR_ON_EXIT: TColor  = clWindow;

{$R *.dfm}

class function TSendMailView.Handle(ARecipients, ARecipientsCopy, ASubject, ABodyMessage, AAttachments: String): Integer;
var
  lView: TSendMailView;
begin
  lView := TSendMailView.Create(nil);
  try
    lView.FRecipients     := ARecipients;
    lView.FRecipientsCopy := ARecipientsCopy;
    lView.FSubject        := ASubject;
    lView.FBodyMessage    := ABodyMessage;
    lView.FAttachments    := AAttachments;
    Result := lView.ShowModal;
  finally
    lView.Free;
  end;
end;

function TSendMailView.BeforeShow: TSendMailView;
var
  lStrList: TStringList;
  lI: Integer;
begin
  Result := Self;

  Try
    lStrList := TStringList.Create;

    // Destinatários
    if not FRecipients.Trim.IsEmpty then
    begin
      parseDelimited(lStrList, FRecipients, ';');
      ltbRecipientList.Clear;
      for lI := 0 to Pred(lStrList.Count) do
        ltbRecipientList.Items.Add(lStrList[lI]);
    end;

    // Cópia
    if not FRecipientsCopy.Trim.IsEmpty then
    begin
      ltbRecipientCopyList.Clear;
      parseDelimited(lStrList, FRecipientsCopy, ';');
      for lI := 0 to Pred(lStrList.Count) do
        ltbRecipientCopyList.Items.Add(lStrList[lI]);
    end;

    // Assunto
    edtSubject.Text := FSubject;

    // Mensagem
    memBodyMessage.Clear;
//    memBodyMessage.Lines.Add(Session.CompanyDefault.send_email_header_message);
    memBodyMessage.Lines.Add('');
    memBodyMessage.Lines.Add(FBodyMessage);
    memBodyMessage.Lines.Add('');
//    memBodyMessage.Lines.Add(Session.CompanyDefault.send_email_footer_message);

    // Anexos
    if not FAttachments.Trim.IsEmpty then
    begin
      ltbAttachments.Clear;
      parseDelimited(lStrList, FAttachments, ';');
      for lI := 0 to Pred(lStrList.Count) do
        ltbAttachments.Items.Add(lStrList[lI]);
    end;
  Finally
    lStrList.Free;
  End;
end;

procedure TSendMailView.btnSendMailClick(Sender: TObject);
var
  lError: String;
  lI: Integer;
begin
  // Verificar destinatários
  if (ltbRecipientList.Items.Count <= 0) then
  begin
    if not String(edtRecipient.Text).Trim.IsEmpty and EmailIsValid(edtRecipient.Text) then
      ltbRecipientList.Items.Add(edtRecipient.Text);

    if (ltbRecipientList.Items.Count <= 0) then
      lError := lError + 'O Campo [Destinatário] é obrigatório.' + #13;
  end;

  // Verificar Cópia
  if (ltbRecipientCopyList.Items.Count <= 0) then
  begin
    if not String(edtRecipientCopy.Text).Trim.IsEmpty and EmailIsValid(edtRecipientCopy.Text) then
      ltbRecipientCopyList.Items.Add(edtRecipientCopy.Text);
  end;

  // Verificar Assunto
  if String(edtSubject.Text).Trim.IsEmpty then
    lError := lError + 'O Campo [Assunto] é obrigatório.' + #13;

  // Verificar Mensagem
  if String(memBodyMessage.Text).Trim.IsEmpty then
    lError := lError + 'O Campo [Mensagem] é obrigatório.' + #13;

  // Bloquear se não validar campos
  if not lError.Trim.IsEmpty then
  begin
    TAlertView.Handle(lError);
    Abort;
  end;

  // Mensagem de Confirmação
  if not (TYesOrNoView.Handle('Confirma envio de e-mail para: ' + ltbRecipientList.Items[0]) = mrOk) then
    Exit;

  // Destinatários
  FRecipients := EmptyStr;
  for lI := 0 to Pred(ltbRecipientList.Count) do
    FRecipients := FRecipients + ltbRecipientList.Items[lI] + ';';

  // Cópia
  FRecipientsCopy := EmptyStr;
  for lI := 0 to Pred(ltbRecipientCopyList.Count) do
    FRecipientsCopy := FRecipientsCopy + ltbRecipientCopyList.Items[lI] + ';';

  // Asunto
  FSubject := edtSubject.Text;

  // Mensagem
  FBodyMessage := memBodyMessage.Text;

  // Anexos
  FAttachments := EmptyStr;
  for lI := 0 to Pred(ltbAttachments.Count) do
    FAttachments := FAttachments + ltbAttachments.Items[lI] + ';';

  // Enviar E-mail
  SessionDTM.SendMail(
    FSubject,
    FRecipients,
    FRecipientsCopy,
    FBodyMessage,
    FAttachments
  );
  NotificationView.Execute('Processo será realizado em segundo plano.', tneInfo);
  ModalResult := mrOk;
end;

procedure TSendMailView.edtRecipientCopyKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13) then
    imgRecipientCopyAddClick(imgRecipientCopyAdd);
end;

procedure TSendMailView.edtRecipientEnter(Sender: TObject);
begin
 if (Sender is TEdit) then
    TEdit(Sender).Color := COLOR_ON_ENTER;
end;

procedure TSendMailView.edtRecipientExit(Sender: TObject);
begin
  if (Sender is TEdit) then
    TEdit(Sender).Color := COLOR_ON_EXIT;
end;

procedure TSendMailView.edtRecipientKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Focus no proximo campo
  if (Key = VK_RETURN) then
    Perform(WM_NEXTDLGCTL,0,0);
end;

procedure TSendMailView.edtRecipientKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    imgRecipientAddClick(imgRecipientAdd);
end;

procedure TSendMailView.FormCreate(Sender: TObject);
begin
  pgc.Pages[0].TabVisible := False;
  pgc.ActivePageIndex := 0;
  createTransparentBackground(Self);
end;

procedure TSendMailView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Esc - SAIR
  if (Key = VK_ESCAPE) then
  begin
    imgCloseTitleClick(imgCloseTitle);
    Exit;
  end;
end;

procedure TSendMailView.FormShow(Sender: TObject);
begin
  BeforeShow;
  edtRecipient.SetFocus;
end;

procedure TSendMailView.imgCloseTitleClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TSendMailView.imgMinimizeTitleClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TSendMailView.imgRecipientAddClick(Sender: TObject);
begin
  if String(edtRecipient.Text).Trim.IsEmpty then Exit;

  // Validar E-mail
  if not EmailIsValid(edtRecipient.Text) then
  begin
    TAlertView.Handle('E-mail inválido: ' + edtRecipient.Text);
    Abort;
  end;

  // Adicionar em Lista
  ltbRecipientList.Items.Add(edtRecipient.Text);
  edtRecipient.Clear;
  edtRecipient.SetFocus;
end;

procedure TSendMailView.imgRecipientCopyAddClick(Sender: TObject);
begin
  if String(edtRecipientCopy.Text).Trim.IsEmpty then Exit;

  // Validar E-mail
  if not EmailIsValid(edtRecipientCopy.Text) then
  begin
    TAlertView.Handle('E-mail inválido: ' + edtRecipientCopy.Text);
    Abort;
  end;

  // Adicionar em Lista
  ltbRecipientCopyList.Items.Add(edtRecipientCopy.Text);
  edtRecipientCopy.Clear;
  edtRecipientCopy.SetFocus;
end;

procedure TSendMailView.ltbAttachmentsDblClick(Sender: TObject);
var
  lPathFile: string;
begin
  if (ltbAttachments.Count <= 0) then Exit;

  lPathFile := ltbAttachments.Items[ltbAttachments.ItemIndex];
  if not FileExists(lPathFile) then
    raise Exception.Create('Arquivo não existe no caminho informado.');

  ShellExecute(0, Nil, PChar(lPathFile), '', Nil, SW_SHOWNORMAL);
end;

procedure TSendMailView.ltbRecipientCopyListDblClick(Sender: TObject);
begin
  ltbRecipientCopyList.DeleteSelected;
end;

procedure TSendMailView.ltbRecipientListDblClick(Sender: TObject);
begin
  ltbRecipientList.DeleteSelected;
end;

end.
