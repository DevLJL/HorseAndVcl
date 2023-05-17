unit uPayment.Input.DTO;

interface

uses
  {$IFDEF APPREST}
  Horse.Request,
  GBSwagger.Model.Attributes,
  uAppRest.Types,
  {$ENDIF}
  uBase.DTO,
  XSuperObject,
  uSmartPointer,
  System.Generics.Collections,
  uPaymentTerm.Input.DTO;

type
  TPaymentInputDTO = class(TBaseDTO)
  private
    Fname: String;
    Facl_user_id: Int64;
    Fflg_active: SmallInt;
    Fbank_account_default_id: Int64;
    Fflg_active_at_pos: SmallInt;
    Fflg_post_as_received: SmallInt;

    // OneToMany
    Fpayment_terms: TObjectList<TPaymentTermInputDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TPaymentInputDTO;
    {$ENDIF}

    [SwagString(255)]
    [SwagProp('name', 'Nome', true)]
    property name: String read Fname write Fname;

    [SwagNumber(0,1)]
    [SwagProp('flg_post_as_received', 'Incluir como recebido', false)]
    property flg_post_as_received: SmallInt read Fflg_post_as_received write Fflg_post_as_received;

    [SwagNumber(0,1)]
    [SwagProp('flg_active', 'Ativo', false)]
    property flg_active: SmallInt read Fflg_active write Fflg_active;

    [SwagNumber(0,1)]
    [SwagProp('flg_active_at_pos', 'Ativo em POS(Point of Sale)', false)]
    property flg_active_at_pos: SmallInt read Fflg_active_at_pos write Fflg_active_at_pos;

    [SwagNumber]
    [SwagProp('bank_account_default_id', 'Conta Bancária Padrão (ID)', true)]
    property bank_account_default_id: Int64 read Fbank_account_default_id write Fbank_account_default_id;

    [SwagIgnore]
    [DISABLE]
    property acl_user_id: Int64 read Facl_user_id write Facl_user_id;

    // OneToMany
    property payment_terms: TObjectList<TPaymentTermInputDTO> read Fpayment_terms write Fpayment_terms;
  end;

implementation

uses
  System.SysUtils,
  {$IFDEF APPREST}
  uMyClaims,
  {$ENDIF}
  uHlp;

{ TPaymentInputDTO }

constructor TPaymentInputDTO.Create;
begin
  inherited Create;
  Fpayment_terms := TObjectList<TPaymentTermInputDTO>.Create;
end;

destructor TPaymentInputDTO.Destroy;
begin
  if Assigned(Fpayment_terms) then
    FreeAndNil(Fpayment_terms);
  inherited;
end;

{$IFDEF APPREST}
class function TPaymentInputDTO.FromReq(AReq: THorseRequest): TPaymentInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TPaymentInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := StrInt(AReq.Session<TMyClaims>.Id);
end;
{$ENDIF}

end.

