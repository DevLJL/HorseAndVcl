unit uUserLogged;

interface

uses
  SysUtils,
  uAclUser;

type
  TUserLogged = class
  private
    FUser: TAclUser;
  public
    constructor Create;
    destructor Destroy; override;

    function Current: TAclUser; overload;
    function Current(AUser: TAclUser): TUserLogged; overload;
    function CurrentRefresh: TUserLogged;
  end;

var
  UserLogged: TUserLogged;

implementation

uses
  System.Variants,
  Data.DB,
  uHlp,
  uEnv.Vcl;

{ TUserLogged }

function TUserLogged.Current: TAclUser;
begin
  Result := FUser;
end;

function TUserLogged.Current(AUser: TAclUser): TUserLogged;
begin
  Result := Self;
  if Assigned(FUser) then
    FreeAndNil(FUser);

  FUser := AUser;
end;

function TUserLogged.CurrentRefresh: TUserLogged;
begin
//
end;

destructor TUserLogged.Destroy;
begin
  if Assigned(FUser) then FUser.Free;
  inherited;
end;

constructor TUserLogged.Create;
begin
  inherited Create;
end;


initialization
  UserLogged := TUserLogged.Create;
finalization
  FreeAndNil(UserLogged);

end.

