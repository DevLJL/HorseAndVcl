unit uPaymentTerm;

interface

uses
  uBase.Entity;

type
  TPaymentTerm = class(TBaseEntity)
  private
    Fnumber_of_installments: SmallInt;
    Fpayment_id: Int64;
    Fid: Int64;
    Fdescription: string;
    Finterval_between_installments: SmallInt;
    Ffirst_in: SmallInt;
    procedure Initialize;
  public
    constructor Create; overload;
    destructor Destroy; override;

    property id: Int64 read Fid write Fid;
    property payment_id: Int64 read Fpayment_id write Fpayment_id;
    property description: string read Fdescription write Fdescription;
    property number_of_installments: SmallInt read Fnumber_of_installments write Fnumber_of_installments;
    property interval_between_installments: SmallInt read Finterval_between_installments write Finterval_between_installments;
    property first_in: SmallInt read Ffirst_in write Ffirst_in;

    function Validate: String; override;
  end;

implementation

uses
  System.SysUtils,
  uHlp,
  uAppRest.Types,
  uApplication.Exception;

{ TPaymentTerm }

constructor TPaymentTerm.Create;
begin
  inherited Create;
  Initialize;
end;

destructor TPaymentTerm.Destroy;
begin
  inherited;
end;

procedure TPaymentTerm.Initialize;
begin
//
end;

function TPaymentTerm.Validate: String;
var
  LIsInserting: Boolean;
begin
  Result := EmptyStr;
  LIsInserting := Fid = 0;
end;

end.

