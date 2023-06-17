unit uProductPriceList;

interface

uses
  uBase.Entity,
  uPriceList;

type
  TProductPriceList = class(TBaseEntity)
  private
    Fid: Int64;
    Fproduct_id: Int64;
    Fprice: Double;
    Fprice_list_id: Int64;

    // OneToOne
    Fprice_list: TPriceList;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property product_id: Int64 read Fproduct_id write Fproduct_id;
    property price_list_id: Int64 read Fprice_list_id write Fprice_list_id;
    property price: Double read Fprice write Fprice;

    // OneToOne
    property price_list: TPriceList read Fprice_list write Fprice_list;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uHlp,
  uAppRest.Types,
  uApplication.Exception,
  uTrans;

{ TProductPriceList }

constructor TProductPriceList.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TProductPriceList.Destroy;
begin
  if Assigned(Fprice_list) then Fprice_list.Free;
  inherited;
end;

procedure TProductPriceList.Initialize;
begin
  Fprice_list := TPriceList.Create;
end;

function TProductPriceList.Validate: String;
begin
  Result := EmptyStr;
  const LIsInserting = (Fid = 0);

  if (FPrice <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Preço') + #13;

  if (Fprice_list_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Lista de Preço') + #13;
end;

end.

