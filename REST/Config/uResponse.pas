unit uResponse;

interface

uses
  Horse.Response,
  XSuperObject,
  uAppRest.Types,
  uTrans;

type
  IResponse = Interface
    ['{E1281FF6-9B2C-41E5-AEC6-D14B00BA44C1}']
    function StatusCode(AValue: SmallInt): IResponse; overload;
    function StatusCode: SmallInt; overload;

    function &Message(AValue: String): IResponse; overload;
    function &Message: String; overload;

    function Data(AValue: TObject): IResponse; overload;
    function Data(AValue: ISuperObject): IResponse; overload;
    function Data(AValue: String): IResponse; overload;

    function ContentType(AValue: String): IResponse; overload;
    function ContentType: String; overload;

    function Error(AValue: Boolean): IResponse; overload;
    function Error: Boolean; overload;

    function Send: IResponse;
    function SendError: IResponse;
  End;

  TResponse = class(TInterfacedObject, IResponse)
  private
    FRes: THorseResponse;
    FStatusCode: SmallInt;
    FMessage: String;
    FData: ISuperObject;
    FContentType: String;
    FError: Boolean;
    constructor Create(ARes: THorseResponse);
    destructor Destroy; override;
  public
    function StatusCode(AValue: SmallInt): IResponse; overload;
    function StatusCode: SmallInt; overload;

    function &Message(AValue: String): IResponse; overload;
    function &Message: String; overload;

    function Data(AValue: TObject): IResponse; overload;
    function Data(AValue: ISuperObject): IResponse; overload;
    function Data(AValue: String): IResponse; overload;

    function ContentType(AValue: String): IResponse; overload;
    function ContentType: String; overload;

    function Error(AValue: Boolean): IResponse; overload;
    function Error: Boolean; overload;

    function Send: IResponse;
    function SendError: IResponse;
  end;

function Response(ARes: THorseResponse): IResponse;

implementation

uses
  System.SysUtils,
  System.Classes,
  uHlp,
  System.JSON;

function Response(ARes: THorseResponse): IResponse;
begin
  Result := TResponse.Create(ARes);
end;

{ TResponse }
function TResponse.ContentType: String;
begin
  Result := FContentType;
end;

function TResponse.ContentType(AValue: String): IResponse;
begin
  Result := Self;
  FContentType := AValue;
end;

constructor TResponse.Create(ARes: THorseResponse);
begin
  inherited Create;
  FData       := SO;
  FRes        := ARes;
  ContentType('application/json');
  StatusCode(HTTP_OK);
  Error(False);
  &Message(SUCCESS_MESSAGE);
end;

function TResponse.Data(AValue: TObject): IResponse;
begin
  Result := Self;
  case Assigned(AValue) of
    True:  FData.O['data']    := AValue.AsJSONObject;
    False: FData.Null['data'] := jNull;
  end;
end;

function TResponse.Data(AValue: ISuperObject): IResponse;
begin
  Result := Self;
  case Assigned(AValue) of
    True:  FData.O['data']    := AValue;
    False: FData.Null['data'] := jNull;
  end;
end;

function TResponse.Error: Boolean;
begin
  Result := FError;
end;

function TResponse.Error(AValue: Boolean): IResponse;
begin
  Result           := Self;
  FError           := AValue;
  FData.B['error'] := AValue;
end;

function TResponse.Message: String;
begin
  Result := FMessage;
end;

function TResponse.Message(AValue: String): IResponse;
begin
  Result             := Self;
  FMessage           := AValue;
  FData.S['message'] := FMessage;
end;

function TResponse.Send: IResponse;
begin
  FRes
    .ContentType(FContentType)
    .Send<TJSONObject>(TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(FData.AsJSON), 0) as TJSONObject)
    .Status(FStatusCode);
end;

function TResponse.SendError: IResponse;
begin
  if (FStatusCode = HTTP_OK) then
    StatusCode(HTTP_BAD_REQUEST);

  if (FMessage = SUCCESS_MESSAGE) or (FMessage.IsEmpty) then
    &Message(OOPS_MESSAGE);

  Error(True);
  Data(nil);
  Send;
end;

function TResponse.StatusCode: SmallInt;
begin
  Result := FStatusCode;
end;

function TResponse.StatusCode(AValue: SmallInt): IResponse;
begin
  Result          := Self;
  FStatusCode     := AValue;
  FData.I['code'] := FStatusCode;
end;

function TResponse.Data(AValue: String): IResponse;
begin
  Result := Self;
  case AValue.Trim.IsEmpty of
    True:  FData.Null['data'] := jNull;
    False: FData.S['data']    := AValue;
  end;
end;

destructor TResponse.Destroy;
begin
  case FError of
    True:  SendError;
    False: Send;
  end;
  inherited;
end;

end.
