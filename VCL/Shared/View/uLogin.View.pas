unit uLogin.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.WinXCtrls;

type
  TLoginView = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Panel3: TPanel;
    LbUsuario: TLabel;
    edtLogin: TEdit;
    LbSenha: TLabel;
    edtLoginPassword: TEdit;
    pnlLogin3: TPanel;
    pnlLogin2: TPanel;
    btnLogin: TSpeedButton;
    pnlLogin: TPanel;
    imgLogin: TImage;
    pnlCancel: TPanel;
    pnlCancel2: TPanel;
    btnCancel: TSpeedButton;
    pnlCancel3: TPanel;
    imgCancel4: TImage;
    pnlBackground: TPanel;
    ActivityIndicator1: TActivityIndicator;
    procedure btnLoginClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtLoginKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtLoginPasswordKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    { Public declarations }
    class function ChangeUserLogger: integer;
  end;

var
  LoginView: TLoginView;

implementation

{$R *.dfm}

uses
  uEnv.Vcl,
  Quick.Threads,
  uApplicationError.View,
  RESTRequest4D,
  XSuperObject,
  uAclUser,
  uUserLogged,
  uSmartPointer;

procedure TLoginView.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TLoginView.btnLoginClick(Sender: TObject);
const
  LBODY = '{"login":"%s","login_password":"%s"}';
var
  LRequest: IRequest;
  LResponse: IResponse;
begin
  // Iniciar Loading
  imgLogin.Visible           := False;
  ActivityIndicator1.Animate := True;
  ActivityIndicator1.Visible := True;
  pnlBackground.Enabled      := False;
  LRequest                   := TRequest.New;

  // Executar Task
  TRunTask.Execute(
    procedure(ATask: ITask)
    begin
      // Efetuar Requisição de login
      LResponse := LRequest.BaseURL(ENV_VCL.BaseURI + '/AclUsers/Login')
        .AddHeader ('Content-Type', 'application/json')
        .AddHeader ('Accept', 'application/json')
        .Accept    ('application/json')
        .AddBody   (Format(LBODY, [edtLogin.Text, edtLoginPassword.Text]))
        .Post;
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
        if not (LResponse.StatusCode = 200) then
        begin
          ShowMessage(SO(LResponse.Content).S['message']);
          Exit;
        end;

        // Carregar dados do usuário, Configuração Global e Dados da Empresa
        const LAclUser = TAclUser.FromJSON(SO(lResponse.Content).O['data']);
        LAclUser.login_password := edtLoginPassword.Text;
        UserLogged.Current(LAclUser, True);

        ModalResult := mrOK;
      finally
        ActivityIndicator1.Animate := False;
        ActivityIndicator1.Visible := False;
        imgLogin.Visible           := True;
        pnlBackground.Enabled      := True;
      end;
    end)
  .Run;
end;

class function TLoginView.ChangeUserLogger: integer;
begin
  const lView: SH<TLoginView> = TLoginView.Create(nil);
  Result := lView.Value.ShowModal;
end;

procedure TLoginView.edtLoginKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Focus no proximo campo
  if (Key = VK_RETURN) then
    Perform(WM_NEXTDLGCTL,0,0);
end;

procedure TLoginView.edtLoginPasswordKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    btnLoginClick(btnLogin);
end;

procedure TLoginView.FormCreate(Sender: TObject);
begin
  ActivityIndicator1.Visible := False;
end;

procedure TLoginView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // ESC - Fechar
  if (Key = VK_ESCAPE) then
  begin
    btnCancelClick(btnCancel);
    Exit;
  end;
end;

procedure TLoginView.FormShow(Sender: TObject);
begin
  edtLogin.Text         := 'lead';
  edtLoginPassword.Text := 'lead321';
end;

end.
