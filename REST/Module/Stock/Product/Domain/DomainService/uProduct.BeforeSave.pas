unit uProduct.BeforeSave;

interface

uses
  uProduct,
  uAppRest.Types;

type
  IProductBeforeSave = Interface
    ['{0EB17DE3-DF7E-43BE-8774-8D98879AF631}']
    function Execute: IProductBeforeSave;
  end;

  TProductBeforeSave = class(TInterfacedObject, IProductBeforeSave)
  private
    FEntity: TProduct;
    FState: TEntityState;
    constructor Create(AEntity: TProduct; AStateEnum: TEntityState);
    function HandleProduct: IProductBeforeSave;
  public
    class function Make(AEntity: TProduct; AStateEnum: TEntityState): IProductBeforeSave;
    function Execute: IProductBeforeSave;
  end;

implementation

uses
  uHlp,
  System.SysUtils;

{ TProductBeforeSave }

constructor TProductBeforeSave.Create(AEntity: TProduct; AStateEnum: TEntityState);
begin
  inherited Create;
  FEntity := AEntity;
  FState  := AStateEnum;
end;

function TProductBeforeSave.Execute: IProductBeforeSave;
begin
  Result := Self;
  HandleProduct;
end;

function TProductBeforeSave.HandleProduct: IProductBeforeSave;
begin
  if FEntity.simplified_name.Trim.IsEmpty then
    FEntity.simplified_name := Copy(FEntity.name,1,25);

  // Gerar sku_code se estiver vazio
  if FEntity.sku_code.Trim.IsEmpty then
  begin
    FEntity.sku_code := FormatDateTime('YYMMDDHHNNSS', Now);
    FEntity.sku_code := StringReplace(FEntity.sku_code, ':', '', [rfReplaceAll]);
    FEntity.sku_code := StringReplace(FEntity.sku_code, '.', '', [rfReplaceAll]);
  end;
end;

class function TProductBeforeSave.Make(AEntity: TProduct; AStateEnum: TEntityState): IProductBeforeSave;
begin
  Result := Self.Create(AEntity, AStateEnum);
end;

end.


