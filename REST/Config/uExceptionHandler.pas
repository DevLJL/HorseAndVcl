unit uExceptionHandler;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
  SysUtils,
  {$ELSE}
  System.SysUtils,
  {$ENDIF}
  Horse, Horse.Commons;

CONST
  SERVER_HAS_GONE_AWAY = 'server has gone away';
  UNKNOWN_MYSQL_SERVER_HOST = 'unknown mysql server host';
  ERROR_IN_SQL_SYNTAX = 'you have an error in your sql syntax';
  ERROR_IN_SQL_FK_FAILS = 'cannot delete or update a parent row: a foreign key constraint fails';
  ERROR_IN_SQL_FK_NOT_EXISTS = 'cannot add or update a child row: a foreign key constraint fails';
  ERROR_IN_SQL_UNIQUE_FAILS = 'duplicate entry';

procedure ExceptionHandler(Req: THorseRequest; Res: THorseResponse; Next: {$IF DEFINED(FPC)}TNextProc{$ELSE}TProc{$ENDIF});

implementation

uses
  {$IF DEFINED(FPC)}
  fpjson, TypInfo;
  {$ELSE}
  System.JSON, System.TypInfo, uResponse, uAppRest.Types,
  uEntityValidation.Exception;
  {$ENDIF}

procedure SendError(ARes:THorseResponse; AJson: TJSONObject; AStatus: Integer);
begin
  ARes.Send<TJSONObject>(AJson).Status(AStatus);
end;

procedure ExceptionHandler(Req: THorseRequest; Res: THorseResponse; Next: {$IF DEFINED(FPC)}TNextProc{$ELSE}TProc{$ENDIF});
var
  LJSON: TJSONObject;
  lEMessage: String;
begin
  try
    Next();
  except
    on E: EHorseCallbackInterrupted do
      raise;
    on E: EHorseException do
    begin
      LJSON := TJSONObject.Create;
      LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('error', E.Error);
      if not E.Title.Trim.IsEmpty then
      begin
        LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('title', E.Title);
      end;
      if not E.&Unit.Trim.IsEmpty then
      begin
        LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('unit', E.&Unit);
      end;
      if E.Code <> 0 then
      begin
        LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('code', {$IF DEFINED(FPC)}TJSONIntegerNumber{$ELSE}TJSONNumber{$ENDIF}.Create(E.Code));
      end;
      if E.&Type <> TMessageType.Default then
      begin
        LJSON.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}('type', GetEnumName(TypeInfo(TMessageType), Integer(E.&Type)));
      end;
      SendError(Res, LJSON, E.Code);
    end;
    on E: TEntityValidationException do
    begin
      Response(Res)
        .Error(True)
        .Message(Format('Falha na validação dos dados. %s', [E.Message]));
    end;
    on E: Exception do
    begin
      LEMessage := E.Message;
      if (Pos(SERVER_HAS_GONE_AWAY, LEMessage.ToLower) > 0) or (Pos(UNKNOWN_MYSQL_SERVER_HOST, LEMessage.ToLower) > 0) then
        LEMessage := 'A conexão de rede falhou. Verifique as configuraõeses de rede e internet. Mensagem Técnica: ' + LEMessage + '.';

      if (Pos(ERROR_IN_SQL_SYNTAX, LEMessage.ToLower) > 0) Then
        LEMessage := 'Erro de sintaxe SQL. Mensagem Técnica: ' + LEMessage + '.';

      if (Pos(ERROR_IN_SQL_FK_FAILS, LEMessage.ToLower) > 0) Then
        LEMessage := 'Este registro está sendo utilizado em outras tabelas do sistema. Você não pode deletar! Mensagem Técnica: ' + LEMessage + '.';

      if (Pos(ERROR_IN_SQL_FK_NOT_EXISTS, LEMessage.ToLower) > 0) Then
        LEMessage := 'Você não pode vincular uma chave que não existe na tabela do banco de dados. Mensagem Técnica: ' + LEMessage + '.';

      if (Pos(ERROR_IN_SQL_UNIQUE_FAILS, LEMessage.ToLower) > 0) Then
        LEMessage := 'Entrada duplicada. Valor não pode repetir na tabela do banco de dados. Mensagem Técnica: ' + LEMessage + '.';

      Response(Res)
        .Error(True)
        .Message(LEMessage)
        .StatusCode(HTTP_INTERNAL_SERVER_ERROR);
    end;
  end;
end;

end.

