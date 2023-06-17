unit uAdditionalProduct;

interface

uses
  uBase.Entity,
  uProduct;

type
  TAdditionalProduct = class(TBaseEntity)
  private
    Fid: Int64;
    Fadditional_id: Int64;
    Fproduct_id: Int64;

    // OneToOne
    Fproduct: TProduct;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property additional_id: Int64 read Fadditional_id write Fadditional_id;
    property product_id: Int64 read Fproduct_id write Fproduct_id;

    // OneToOne
    property product: TProduct read Fproduct write Fproduct;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uHlp,
  uAppRest.Types,
  uApplication.Exception,
  uTrans;

{ TAdditionalProduct }

constructor TAdditionalProduct.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TAdditionalProduct.Destroy;
begin
  if Assigned(Fproduct) then Fproduct.Free;
  inherited;
end;

procedure TAdditionalProduct.Initialize;
begin
  Fproduct := TProduct.Create;
end;

function TAdditionalProduct.Validate: String;
begin
  Result := EmptyStr;
  const LIsInserting = (Fid = 0);

  if (Fproduct_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Produto (ID)') + #13;
end;

end.

