unit uTrans.Sale;

interface

uses
  uTrans.Types;

type
  TTransSale = class
  private
    FLanguageType: TLanguageType;
  public
    constructor Create;
    function SaleIsAlreadyInStatus(AValue: String): String;
  end;

implementation

{ TTransSale }

uses
  {$IFDEF APPREST}
  uEnv.Rest,
  {$ELSE}
  uEnv.Vcl,
  {$ENDIF}
  System.SysUtils;

constructor TTransSale.Create;
begin
  {$IFDEF APPREST}
  if (ENV_REST.Language = 'PT-BR') then FLanguageType := TLanguageType.ltPtBr;
  if (ENV_REST.Language = 'EN-US') then FLanguageType := TLanguageType.ltEnUs;
  {$ELSE}
  if (ENV_VCL.Language = 'PT-BR') then FLanguageType := TLanguageType.ltPtBr;
  if (ENV_VCL.Language = 'EN-US') then FLanguageType := TLanguageType.ltEnUs;
  {$ENDIF}
end;

function TTransSale.SaleIsAlreadyInStatus(AValue: String): String;
begin
  Result := Format('Venda está com status de [%s].', [AValue]);
end;
end.
