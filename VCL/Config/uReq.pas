unit uReq;

interface

uses
  RESTRequest4D,
  System.SysUtils,
  System.JSON,
  System.Classes;


type
  {$SCOPEDENUMS ON}
  TReqType = (Get, Post, Put, Delete, Patch);

  IRes = interface
    ['{C98B8DC1-FE04-4FB6-B8D5-5831D86476CD}']
    function Content: string;
    function ContentLength: Cardinal;
    function ContentType: string;
    function ContentEncoding: string;
    function ContentStream: TStream;
    function StatusCode: Integer;
    function StatusText: string;
    function RawBytes: TBytes;
    function JSONValue: TJSONValue;
    function Headers: TStrings;
    function ETag: String;
    function StreamFileName: String;
    function OpenStreamFile: IRes;
  end;

  TRes = class(TInterfacedObject, IRes)
  private
    FResponse: IResponse;
    constructor Create(AResponse: IResponse);
  public
    class function Make(AResponse: IResponse): IRes;
    function Content: string;
    function ContentLength: Cardinal;
    function ContentType: string;
    function ContentEncoding: string;
    function ContentStream: TStream;
    function StatusCode: Integer;
    function StatusText: string;
    function RawBytes: TBytes;
    function JSONValue: TJSONValue;
    function Headers: TStrings;
    function ETag: String;
    function StreamFileName: String;
    function OpenStreamFile: IRes;
  end;

  IReq = Interface
    ['{8A335135-0710-414F-837A-2CE1B1452A97}']
    function Execute(AReqType: TReqType = TReqType.Get): IRes;
    function AddHeader(AName, AValue: string): IReq;
    function AddETag(AValue: string): IReq;
  end;

  TReq = class(TInterfacedObject, IReq)
  private
    FRequest: IRequest;
    constructor Create(AEndPoint, ABody: String);
  public
    function Execute(AReqType: TReqType = TReqType.Get): IRes;
    function AddHeader(AName, AValue: string): IReq;
    function AddETag(AValue: string): IReq;
  end;

  function Req(AEndPoint: String; ABody: String = ''): IReq;

implementation

uses
  uEnv.Vcl,
  uAclUser,
  uUserLogged,
  XSuperObject,
  uAppVcl.Types,
  ShellApi,
  Winapi.Windows,
  uSmartPointer;

{ TReq }

function Req(AEndPoint, ABody: String): IReq;
begin
  Result := TReq.Create(AEndPoint, ABody);
end;

function TReq.AddETag(AValue: string): IReq;
begin
  Result := Self;
  AddHeader('If-None-Match', AValue);
end;

function TReq.AddHeader(AName, AValue: string): IReq;
begin
  Result := Self;
  FRequest.AddHeader(AName, AValue);
end;

constructor TReq.Create(AEndPoint, ABody: String);
begin
  inherited Create;

  // Evitar erro de URI
  var LEndPoint := ENV_VCL.BaseURI;
  if not AEndPoint.Trim.IsEmpty then
  begin
    if (Copy(LEndPoint, LEndPoint.Length, 1) = '/') then LEndPoint := Copy(LEndPoint, 1, LEndPoint.Length-1);
    if (Copy(AEndPoint, 1, 1) = '/')                then AEndPoint := Copy(AEndPoint, 2, AEndPoint.Length);
    LEndPoint := LEndPoint + '/' + AEndPoint;
  end;

  // Configuração Default
  FRequest  := TRequest.New.BaseURL(LEndPoint)
    .TokenBearer (UserLogged.Current.last_token)
    .Accept      ('application/json')
    .AddHeader   ('Content-Type', 'application/json')
    .AddHeader   ('Accept',       'application/json');

  // Body
  if not ABody.Trim.IsEmpty then
    FRequest.AddBody(ABody);
end;

function TReq.Execute(AReqType: TReqType): IRes;
const
  LBODY = '{"login":"%s","login_password":"%s"}';
var
  LResponse: IResponse;
begin
  // Gerar novo token se tiver sido expirado
  const LTokenIsExpired = (Now > UserLogged.Current.last_expiration);
  if LTokenIsExpired then
  begin
    // Efetuar Requisição de login
    const LLoginResponse = TRequest.New.BaseURL(ENV_VCL.BaseURI + '/auth/login')
      .AddHeader ('Content-Type', 'application/json')
      .AddHeader ('Accept', 'application/json')
      .Accept    ('application/json')
      .AddBody   (Format(LBODY, [UserLogged.Current.login, UserLogged.Current.login_password]))
    .Post;
    if not (LLoginResponse.StatusCode = 200) then
      raise Exception.Create('Tentativa de login falhou!' + #13 + SO(LLoginResponse.Content).S['message']);

    // Carregar dados do usuário com novo token
    const LAclUser = TAclUser.FromJSON(SO(LLoginResponse.Content).O['data']);
    LAclUser.login_password := UserLogged.Current.login_password;
    UserLogged.Current(LAclUser);

    // Trocar token do Request
    FRequest.TokenBearer(UserLogged.Current.last_token);
  end;

  // Efetuar Requisição
  case AReqType of
    TReqType.Get:    LResponse := FRequest.Get;
    TReqType.Post:   LResponse := FRequest.Post;
    TReqType.Put:    LResponse := FRequest.Put;
    TReqType.Delete: LResponse := FRequest.Delete;
    TReqType.Patch:  LResponse := FRequest.Patch;
  end;
  Result := TRes.Make(LResponse);
end;



{ TRes }
function TRes.Content: string;
begin
  Result := FResponse.Content;
end;

function TRes.ContentEncoding: string;
begin
  Result := FResponse.ContentEncoding;
end;

function TRes.ContentLength: Cardinal;
begin
  Result := FResponse.ContentLength;
end;

function TRes.ContentStream: TStream;
begin
  Result := FResponse.ContentStream;
end;

function TRes.ContentType: string;
begin
  Result := FResponse.ContentType;
end;

constructor TRes.Create(AResponse: IResponse);
begin
  inherited Create;
  FResponse := AResponse;
end;

function TRes.ETag: String;
begin
  Result := FResponse.Headers.Values['ETag'];
end;

function TRes.Headers: TStrings;
begin
  Result := FResponse.Headers;
end;

function TRes.JSONValue: TJSONValue;
begin
  Result := FResponse.JSONValue;
end;

class function TRes.Make(AResponse: IResponse): IRes;
begin
  Result := Self.Create(AResponse);
end;

function TRes.OpenStreamFile: IRes;
begin
  Result := Self;

  const LTempFile = ExtractFilePath(ExtractFilePath(ParamStr(0))) + TEMP_FOLDER + StreamFileName;
  const LFileStream: SH<TFileStream> = TFileStream.Create(LTempFile, fmCreate);
  LFileStream.Value.CopyFrom(FResponse.ContentStream, FResponse.ContentStream.Size);

  // Executar arquivo temporário
  ShellExecute(0, 'open', PChar(LFileStream.Value.FileName), nil, nil, SW_SHOWNORMAL);
end;

function TRes.RawBytes: TBytes;
begin
  Result := FResponse.RawBytes;
end;

function TRes.StatusCode: Integer;
begin
  Result := FResponse.StatusCode;
end;

function TRes.StatusText: string;
begin
  Result := FResponse.StatusText;
end;

function TRes.StreamFileName: String;
begin
  const LContentDisposition = FResponse.Headers.Values['Content-Disposition'];
  const CopyPosInitial = Pos('filename="', LContentDisposition)+10;
  const CopyPosFinal   = Pos('.pdf', LContentDisposition) - CopyPosInitial+4;

  Result := Copy(LContentDisposition, CopyPosInitial, CopyPosFinal);
end;

end.
