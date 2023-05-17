unit uSaleItem;

interface

uses
  uBase.Entity,
  uProduct;

type
  TSaleItem = class(TBaseEntity)
  private
    Fid: Int64;
    Fsale_id: Int64;
    Funit_discount: double;
    Fproduct_id: Int64;
    Fprice: double;
    Fnote: string;
    Fquantity: double;
    Fseller_id: Int64;

    // OneToOne
    Fproduct: TProduct;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property sale_id: Int64 read Fsale_id write Fsale_id;
    property product_id: Int64 read Fproduct_id write Fproduct_id;
    property quantity: double read Fquantity write Fquantity;
    property price: double read Fprice write Fprice;
    property unit_discount: double read Funit_discount write Funit_discount;
    function subtotal: double;
    function total: double;
    property seller_id: Int64 read Fseller_id write Fseller_id;
    property note: string read Fnote write Fnote;

    // OneToOne
    property product: TProduct read Fproduct write Fproduct;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uHlp,
  uAppRest.Types,
  uApplication.Exception, uTrans;

{ TSaleItem }

constructor TSaleItem.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TSaleItem.Destroy;
begin
  if Assigned(Fproduct) then Fproduct.Free;
  inherited;
end;

procedure TSaleItem.Initialize;
begin
  Fproduct := TProduct.Create;
end;

function TSaleItem.subtotal: double;
begin
  Result := (Fquantity * Fprice);
end;

function TSaleItem.total: double;
begin
  Result := subtotal - (Fquantity * Funit_discount);
end;

function TSaleItem.Validate: String;
begin
  Result := EmptyStr;
  const LIsInserting = (Fid = 0);

  if (Fproduct_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Produto/Serviço') + #13;

  if (Fquantity <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Quantidade') + #13;

  if (Fprice <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Preço') + #13;

  if (Fseller_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Vendedor/Atendente') + #13;
end;

end.

