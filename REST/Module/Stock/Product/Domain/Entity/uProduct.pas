unit uProduct;

interface

uses
  uAppRest.Types,
  uAclUser,
  uBase.Entity,
  Data.DB,
  uUnit,
  uNCM,
  uStorageLocation,
  uCategory,
  uSize,
  uBrand,
  uProduct.Types,
  uProductPriceList,
  System.Generics.Collections;

type
  TProduct = class(TBaseEntity)
  private
    Fid: Int64;
    Fname: string;
    Fgross_weight: Double;
    Fcost: Double;
    Fgenre: TProductGenre;
    Funit_id: Int64;
    Fncm_id: Int64;
    Fpacking_weight: Double;
    Fprice: Double;
    Fcurrent_quantity: Double;
    Fmarketup: Double;
    Fflg_to_move_the_stock: SmallInt;
    Fstorage_location_id: Int64;
    Fmanufacturing_code: String;
    Fsku_code: String;
    Fmaximum_quantity: Double;
    Fflg_product_for_scales: SmallInt;
    Fflg_additional: SmallInt;
    Fean_code: String;
    Ftype: TProductType;
    Fcomplement_note: String;
    Fnet_weight: Double;
    Fcategory_id: Int64;
    Fsize_id: Int64;
    Fbrand_id: Int64;
    Fsimplified_name: String;
    Fminimum_quantity: Double;
    Fflg_discontinued: SmallInt;
    Finternal_note: String;
    Fidentification_code: String;
    Fcreated_at: TDateTime;
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;
    Fcheck_value_before_insert: TProductCheckValueBeforeInsert;

    // OneToOne
    Funit: TUnit;
    Fncm: TNCM;
    Fstorage_location: TStorageLocation;
    Fcategory: TCategory;
    Fsize: TSize;
    Fbrand: TBrand;
    Fupdated_by_acl_user: TAclUser;
    Fcreated_by_acl_user: TAclUser;

    // OneToMany
    Fproduct_price_lists: TObjectList<TProductPriceList>;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property name: string read Fname write Fname;
    property simplified_name: String read Fsimplified_name write Fsimplified_name;
    property &type: TProductType read Ftype write Ftype;
    property sku_code: String read Fsku_code write Fsku_code;
    property ean_code: String read Fean_code write Fean_code;
    property manufacturing_code: String read Fmanufacturing_code write Fmanufacturing_code;
    property identification_code: String read Fidentification_code write Fidentification_code;
    property cost: Double read Fcost write Fcost;
    property marketup: Double read Fmarketup write Fmarketup;
    property price: Double read Fprice write Fprice;
    property current_quantity: Double read Fcurrent_quantity write Fcurrent_quantity;
    property minimum_quantity: Double read Fminimum_quantity write Fminimum_quantity;
    property maximum_quantity: Double read Fmaximum_quantity write Fmaximum_quantity;
    property gross_weight: Double read Fgross_weight write Fgross_weight;
    property net_weight: Double read Fnet_weight write Fnet_weight;
    property packing_weight: Double read Fpacking_weight write Fpacking_weight;
    property flg_to_move_the_stock: SmallInt read Fflg_to_move_the_stock write Fflg_to_move_the_stock;
    property flg_product_for_scales: SmallInt read Fflg_product_for_scales write Fflg_product_for_scales;
    property flg_additional: SmallInt read Fflg_additional write Fflg_additional;
    property internal_note: String read Finternal_note write Finternal_note;
    property complement_note: String read Fcomplement_note write Fcomplement_note;
    property flg_discontinued: SmallInt read Fflg_discontinued write Fflg_discontinued;
    property unit_id: Int64 read Funit_id write Funit_id;
    property ncm_id: Int64 read Fncm_id write Fncm_id;
    property category_id: Int64 read Fcategory_id write Fcategory_id;
    property brand_id: Int64 read Fbrand_id write Fbrand_id;
    property size_id: Int64 read Fsize_id write Fsize_id;
    property storage_location_id: Int64 read Fstorage_location_id write Fstorage_location_id;
    property genre: TProductGenre read Fgenre write Fgenre;
    property check_value_before_insert: TProductCheckValueBeforeInsert read Fcheck_value_before_insert write Fcheck_value_before_insert;
    property created_at: TDateTime read Fcreated_at write Fcreated_at;
    property updated_at: TDateTime read Fupdated_at write Fupdated_at;
    property created_by_acl_user_id: Int64 read Fcreated_by_acl_user_id write Fcreated_by_acl_user_id;
    property updated_by_acl_user_id: Int64 read Fupdated_by_acl_user_id write Fupdated_by_acl_user_id;

    // OneToOne
    property &unit: TUnit read Funit write Funit;
    property ncm: TNCM read Fncm write Fncm;
    property category: TCategory read Fcategory write Fcategory;
    property brand: TBrand read Fbrand write Fbrand;
    property size: TSize read Fsize write Fsize;
    property storage_location: TStorageLocation read Fstorage_location write Fstorage_location;
    property created_by_acl_user: TAclUser read Fcreated_by_acl_user write Fcreated_by_acl_user;
    property updated_by_acl_user: TAclUser read Fupdated_by_acl_user write Fupdated_by_acl_user;

    // OneToMany
    property product_price_lists: TObjectList<TProductPriceList> read Fproduct_price_lists write Fproduct_price_lists;

    function Validate: String; override;
    procedure BeforeSave(AState: TEntityState);
    function BeforeSaveAndValidate(AState: TEntityState): String;
  end;

implementation

uses
  System.SysUtils,
  uProduct.BeforeSave,
  uTrans,
  uHlp;

{ TProduct }

procedure TProduct.BeforeSave(AState: TEntityState);
begin
  TProductBeforeSave.Make(Self, AState).Execute;
end;

function TProduct.BeforeSaveAndValidate(AState: TEntityState): String;
begin
  BeforeSave(AState);
  Result := Validate;
end;

constructor TProduct.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TProduct.Destroy;
begin
  if Assigned(Funit)                then Funit.Free;
  if Assigned(Fncm)                 then Fncm.Free;
  if Assigned(Fcategory)            then Fcategory.Free;
  if Assigned(Fbrand)               then Fbrand.Free;
  if Assigned(Fsize)                then Fsize.Free;
  if Assigned(Fstorage_location)    then Fstorage_location.Free;
  if Assigned(Fcreated_by_acl_user) then Fcreated_by_acl_user.Free;
  if Assigned(Fupdated_by_acl_user) then Fupdated_by_acl_user.Free;
  if Assigned(Fproduct_price_lists)     then Fproduct_price_lists.Free;
  inherited;
end;

procedure TProduct.Initialize;
begin
  Fcreated_at          := now;
  Funit                := TUnit.Create;
  Fncm                 := TNCM.Create;
  Fcategory            := TCategory.Create;
  Fbrand               := TBrand.Create;
  Fsize                := TSize.Create;
  Fstorage_location    := TStorageLocation.Create;
  Fcreated_by_acl_user := TAclUser.Create;
  Fupdated_by_acl_user := TAclUser.Create;
  Fproduct_price_lists     := TObjectList<TProductPriceList>.Create;
end;

function TProduct.Validate: String;
begin
  const LIsInserting = (Fid = 0);
  Result := EmptyStr;

  if Fname.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome');

  if (Funit_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('Unidade de Medida');

  if (Fncm_id <= 0) then
    Result := Result + Trans.FieldWasNotInformed('NCM');

  if Fsku_code.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Referência');

  // ProductPriceList
  for var lI := 0 to Pred(Fproduct_price_lists.Count) do
  begin
    const LCurrentError = Fproduct_price_lists.Items[lI].Validate;
    if not LCurrentError.Trim.IsEmpty then
      Result := Result + '   Lista de Preço > Item ' + StrZero((lI+1).ToString,3) + ': ' + LCurrentError;
  end;
end;

end.

