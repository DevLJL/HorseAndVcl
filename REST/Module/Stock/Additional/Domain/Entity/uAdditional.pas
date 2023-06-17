unit uAdditional;

interface

uses
  uAppRest.Types,
  uAclUser,
  uBase.Entity,
  Data.DB,
  uAdditional.Types,
  uAdditionalProduct,
  System.Generics.Collections;

type
  TAdditional = class(TBaseEntity)
  private
    Fid: Int64;
    Fname: string;
    Fselection_type: TAdditionalSelectionType;
    Fprice_calculation_type: TAdditionalPriceCalculationType;
    Fcreated_at: TDateTime;
    Fupdated_at: TDateTime;
    Fupdated_by_acl_user_id: Int64;
    Fcreated_by_acl_user_id: Int64;

    // OneToOne
    Fupdated_by_acl_user: TAclUser;
    Fcreated_by_acl_user: TAclUser;

    // OneToMany
    Fadditional_products: TObjectList<TAdditionalProduct>;

    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property name: string read Fname write Fname;
    property selection_type: TAdditionalSelectionType read Fselection_type write Fselection_type;
    property price_calculation_type: TAdditionalPriceCalculationType read Fprice_calculation_type write Fprice_calculation_type;
    property created_at: TDateTime read Fcreated_at write Fcreated_at;
    property updated_at: TDateTime read Fupdated_at write Fupdated_at;
    property created_by_acl_user_id: Int64 read Fcreated_by_acl_user_id write Fcreated_by_acl_user_id;
    property updated_by_acl_user_id: Int64 read Fupdated_by_acl_user_id write Fupdated_by_acl_user_id;

    // OneToOne
    property created_by_acl_user: TAclUser read Fcreated_by_acl_user write Fcreated_by_acl_user;
    property updated_by_acl_user: TAclUser read Fupdated_by_acl_user write Fupdated_by_acl_user;

    // OneToMany
    property additional_products: TObjectList<TAdditionalProduct> read Fadditional_products write Fadditional_products;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uApplication.Exception,
  uTrans,
  uHlp;

{ TAdditional }

constructor TAdditional.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TAdditional.Destroy;
begin
  if Assigned(Fcreated_by_acl_user) then Fcreated_by_acl_user.Free;
  if Assigned(Fupdated_by_acl_user) then Fupdated_by_acl_user.Free;
  if Assigned(Fadditional_products) then Fadditional_products.Free;
  inherited;
end;

procedure TAdditional.Initialize;
begin
  Fcreated_by_acl_user := TAclUser.Create;
  Fupdated_by_acl_user := TAclUser.Create;
  Fadditional_products := TObjectList<TAdditionalProduct>.Create;
end;

function TAdditional.Validate: String;
begin
  Result := EmptyStr;
  const LIsInserting = (Fid = 0);

  if Fname.Trim.IsEmpty then
    Result := Result + Trans.FieldWasNotInformed('Nome') + #13;

  // AdditionalProduct
  for var lI := 0 to Pred(Fadditional_products.Count) do
  begin
    const LCurrentError = Fadditional_products.Items[lI].Validate;
    if not LCurrentError.Trim.IsEmpty then
      Result := Result + '   Adicional > Item ' + StrZero((lI+1).ToString,3) + ': ' + LCurrentError;
  end;
end;

end.
