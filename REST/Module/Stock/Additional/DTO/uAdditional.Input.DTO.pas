unit uAdditional.Input.DTO;

interface

uses
  uBase.DTO,
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  XSuperObject,
  uSmartPointer,
  uAdditional.Types,
  uAdditionalProduct.Input.DTO,
  System.Generics.Collections;

type
  TAdditionalInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Facl_user_id: Int64;
    Fselection_type: TAdditionalSelectionType;
    Fprice_calculation_type: TAdditionalPriceCalculationType;

    // OneToMany
    Fadditional_products: TObjectList<TAdditionalProductInputDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TAdditionalInputDTO;
    {$ENDIF}

    [SwagString(100)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;

    [SwagNumber]
    [SwagProp('selection_type', 'Tipo de Seleção [0-Única, 1-Múltipla]', false)]
    property selection_type: TAdditionalSelectionType read Fselection_type write Fselection_type;

    [SwagNumber]
    [SwagProp('price_calculation_type', 'Tipo de cálculo [0-Soma, 1-Maior]', false)]
    property price_calculation_type: TAdditionalPriceCalculationType read Fprice_calculation_type write Fprice_calculation_type;

    [SwagIgnore]
    [DISABLE]
    property acl_user_id: Int64 read Facl_user_id write Facl_user_id;

    // OneToMany
    property additional_products: TObjectList<TAdditionalProductInputDTO> read Fadditional_products write Fadditional_products;
  end;

implementation

uses
  System.SysUtils,
  {$IFDEF APPREST}
  uMyClaims,
  {$ENDIF}
  uHlp;

{ TAdditionalInputDTO }

constructor TAdditionalInputDTO.Create;
begin
  inherited Create;
  Fadditional_products := TObjectList<TAdditionalProductInputDTO>.Create;
end;

destructor TAdditionalInputDTO.Destroy;
begin
  if Assigned(Fadditional_products) then
    FreeAndNil(Fadditional_products);
  inherited;
end;

{$IFDEF APPREST}
class function TAdditionalInputDTO.FromReq(AReq: THorseRequest): TAdditionalInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TAdditionalInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := AReq.Session<TMyClaims>.IdToInt64;
end;
{$ENDIF}

end.

