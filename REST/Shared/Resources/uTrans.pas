unit uTrans;

interface

uses
  SysUtils,
  System.Classes,
  uTrans.Types,
  uTrans.Sale;

type
  TTrans = class
  private
    FLanguageType: TLanguageType;
    FTransSale: TTransSale;
  public
    constructor Create;
    destructor  Destroy; override;
    function Sale: TTransSale;

    function OopsMessage: String;
    function SuccessMessage: String;
    function ValidationError: String;
    function RecordNotFound: String;
    function RecordNotFoundWithId(AValue: String): String;
    function RecordNotFoundWithId2(AValue: String): String;
    function UncategorizedException: String;
    function FieldWasNotInformed(AValue: String): String;
    function FieldWithValueIsInvalid(AValue, AValue2: String): String;
    function FieldWithValueIsInUse(AValue, AValue2: String): String;
    function FieldValueMustContainMaximumOfCharacters(AValue, AValue2: String): String;
    function FieldValueMustContainExactlyCharacters(AValue, AValue2: String): String;
    function YourAppHasBeenMinimized: String;
    function DoYouWantToDeleteSelectedRecord: String;
    function Exclusion: String;
    function AbortOperation: String;
    function Printing: String;
    function RecordDeletionFailed: String;
    function RecordDeleted: String;
    function RecordValidationFailed: String;
    function RecordSaved: String;
    function FieldIsRequired(const AValue: String): String;
    function FieldIsInvalid(const AValue: String): String;
    function NumberIsLessThan(const ALabelNumber, AValueNumber: String): String;
    function DataInsertionFailure: String;
    function NoJsonFilterReported: String;
    function IncorrectCredentials: String;
    function FeatureDisabled: String;
    function SendEmailSuccessfullyRequested: String;
  end;

var
  Trans: TTrans;

const
  SUCCESS_MESSAGE = 'Operação realizada com sucesso.';
  OOPS_MESSAGE = 'Oops. Algum erro aconteceu!';

implementation

{ TTrans }

uses
  {$IFDEF APPREST}
  uEnv.Rest;
  {$ELSE}
  uEnv.Vcl;
  {$ENDIF}

function TTrans.AbortOperation: String;
begin
  Result := 'Abortar';
end;

constructor TTrans.Create;
begin
  {$IFDEF APPREST}
  if (ENV_REST.Language = 'PT-BR') then FLanguageType := TLanguageType.ltPtBr;
  if (ENV_REST.Language = 'EN-US') then FLanguageType := TLanguageType.ltEnUs;
  {$ELSE}
  if (ENV_VCL.Language = 'PT-BR') then FLanguageType := TLanguageType.ltPtBr;
  if (ENV_VCL.Language = 'EN-US') then FLanguageType := TLanguageType.ltEnUs;
  {$ENDIF}

  FTransSale := TTransSale.Create;
end;

function TTrans.DataInsertionFailure: String;
begin
  Result := 'Falha na inserção dos dados.';
end;

destructor TTrans.Destroy;
begin
  if Assigned(FTransSale) then FreeAndNil(FTransSale);
  inherited;
end;

function TTrans.DoYouWantToDeleteSelectedRecord: String;
begin
  Result := 'Deseja apagar o registro selecionado?';
end;

function TTrans.Exclusion: String;
begin
  Result := 'Exclusão'
end;

function TTrans.FeatureDisabled: String;
begin
  Result := 'Recurso desativado temporariamente.';
end;

function TTrans.FieldIsInvalid(const AValue: String): String;
begin
  Result := Format('O campo [%s] é inválido.', [AValue]);
end;

function TTrans.FieldIsRequired(const AValue: String): String;
begin
  Result := Format('O campo [%s] � obrigatório.', [AValue]);
end;

function TTrans.FieldValueMustContainMaximumOfCharacters(AValue, AValue2: String): String;
begin
  Result := Format('O campo [%s] deve conter no máximo [%s] caractere(s).', [AValue, AValue2]);
end;

function TTrans.FieldValueMustContainExactlyCharacters(AValue, AValue2: String): String;
begin
  Result := Format('O campo [%s] deve conter [%s] caractere(s).', [AValue, AValue2]);
end;

function TTrans.FieldWasNotInformed(AValue: String): String;
begin
  Result := Format('O campo %s não foi informado.', [AValue]);
end;

function TTrans.FieldWithValueIsInvalid(AValue, AValue2: String): String;
begin
  Result := Format('O campo %s com o conteúdo %s é inválido.', [AValue, AValue2]);
end;

function TTrans.IncorrectCredentials: String;
begin
  Result := 'Usuário não encontrado. Verifique suas credenciais e tente novamente.';
end;

function TTrans.FieldWithValueIsInUse(AValue, AValue2: String): String;
begin
  Result := Format('O campo [%s] com o valor [%s] já está em uso.', [AValue, AValue2]);
end;

function TTrans.NoJsonFilterReported: String;
begin
  Result := 'Nenhum Filtro no formato JSON informado!';
end;

function TTrans.NumberIsLessThan(const ALabelNumber, AValueNumber: String): String;
begin
  Result := Format('O número [%s] é inferior a %s.', [ALabelNumber, AValueNumber]);
end;

function TTrans.OopsMessage: String;
begin
  Result := OOPS_MESSAGE;
end;

function TTrans.Printing: String;
begin
  Result := 'Impressão';
end;

function TTrans.RecordDeleted: String;
begin
  Result := 'Registro deletado com sucesso!';
end;

function TTrans.RecordDeletionFailed: String;
begin
  Result := 'Exclusão de registro falhou!';
end;

function TTrans.RecordNotFound: String;
begin
  Result := 'Registro não encontrado.';
end;

function TTrans.RecordNotFoundWithId(AValue: String): String;
begin
  Result := Format('Registro não encontrado com ID: [%s].', [AValue]);
end;

function TTrans.RecordNotFoundWithId2(AValue: String): String;
begin
  Result := Format('Registro não encontrado com ID: [%d]. Verifique se o mesmo não foi modificado/apagado por outro terminal.', [AValue]);
end;

function TTrans.RecordSaved: String;
begin
  Result := 'Registro salvo com sucesso!';
end;

function TTrans.RecordValidationFailed: String;
begin
  Result := 'Falha na validação dos dados!';
end;

function TTrans.Sale: TTransSale;
begin
  Result := FTransSale;
end;

function TTrans.SendEmailSuccessfullyRequested: String;
begin
  Result := 'Envio de e-mail requisitado com sucesso';
end;

function TTrans.SuccessMessage: String;
begin
  Result := SUCCESS_MESSAGE;
end;

function TTrans.UncategorizedException: String;
begin
  Result := 'Exceção não catalogada';
end;

function TTrans.ValidationError: String;
begin
  Result := 'Falha na validação dos dados';
end;

function TTrans.YourAppHasBeenMinimized: String;
begin
  Result := 'Seu aplicativo foi minimizado';
end;

initialization
  Trans := TTrans.Create();

finalization
  FreeAndNil(TRANS);

end.

