unit uCashFlow.Input.DTO;

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
  uCashFlowTransaction.Input.DTO;

type
  TCashFlowInputDTO = class(TBaseDTO)
  private
    Fclosing_note: String;
    Fname: String;
    Fstation_id: Int64;
    Facl_user_id: Int64;
    Fclosing_date: TDateTime;
    Ffinal_balance_amount: Double;
    Fopening_balance_amount: Double;
    Fopening_date: TDateTime;

    // OneToMany
    Fcash_flow_transactions: TObjectList<TCashFlowTransactionInputDTO>;
  public
    constructor Create;
    destructor Destroy; override;
    {$IFDEF APPREST}
    class function FromReq(AReq: THorseRequest): TCashFlowInputDTO;
    {$ENDIF}

    [SwagNumber]
    [SwagProp('station_id', 'Estação (ID)', true)]
    property station_id: Int64 read Fstation_id write Fstation_id;

    [SwagNumber]
    [SwagProp('opening_balance_amount', 'Valor de Abertura', false)]
    property opening_balance_amount: Double read Fopening_balance_amount write Fopening_balance_amount;

    [SwagNumber]
    [SwagProp('final_balance_amount', 'Saldo Final', false)]
    property final_balance_amount: Double read Ffinal_balance_amount write Ffinal_balance_amount;

    [SwagDate(DATETIME_DISPLAY_FORMAT)]
    [SwagProp('opening_date', 'Data de Abertura', true)]
    property opening_date: TDateTime read Fopening_date write Fopening_date;

    [SwagDate(DATETIME_DISPLAY_FORMAT)]
    [SwagProp('closing_date', 'Data de Fechamento', false)]
    property closing_date: TDateTime read Fclosing_date write Fclosing_date;

    [SwagString]
    [SwagProp('closing_note', 'Observação de Fechamento', false)]
    property closing_note: String read Fclosing_note write Fclosing_note;

    [SwagIgnore]
    [DISABLE]
    property acl_user_id: Int64 read Facl_user_id write Facl_user_id;

    // OneToMany
    property cash_flow_transactions: TObjectList<TCashFlowTransactionInputDTO> read Fcash_flow_transactions write Fcash_flow_transactions;
  end;

implementation

uses
  System.SysUtils,
  {$IFDEF APPREST}
  uMyClaims,
  {$ENDIF}
  uHlp;

{ TCashFlowInputDTO }

constructor TCashFlowInputDTO.Create;
begin
  inherited Create;
  Fcash_flow_transactions := TObjectList<TCashFlowTransactionInputDTO>.Create;
end;

destructor TCashFlowInputDTO.Destroy;
begin
  if Assigned(Fcash_flow_transactions) then
    FreeAndNil(Fcash_flow_transactions);
  inherited;
end;

{$IFDEF APPREST}
class function TCashFlowInputDTO.FromReq(AReq: THorseRequest): TCashFlowInputDTO;
begin
  if AReq.Body.Trim.IsEmpty then
    raise Exception.Create('Nenhum JSON informado!');

  Result             := TCashFlowInputDTO.FromJSON(AReq.Body);
  Result.acl_user_id := AReq.Session<TMyClaims>.IdToInt64;
end;
{$ENDIF}

end.

