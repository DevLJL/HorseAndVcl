unit uConsumptionSale.Filter;

interface

type
  TConsumptionSaleStatus = (cssAll, cssFree, cssBusy, cssPreAccount);
  IConsumptionSaleFilter = interface
    ['{E6D65E5C-A780-4843-9372-3AA7396964A8}']

    function Status(AValue: TConsumptionSaleStatus): IConsumptionSaleFilter; overload;
    function Status: TConsumptionSaleStatus; overload;

    function Number(AValue: SmallInt): IConsumptionSaleFilter; overload;
    function Number: SmallInt overload;
  end;

  TConsumptionSaleFilter = class(TInterfacedObject, IConsumptionSaleFilter)
  private
    FStatus: TConsumptionSaleStatus;
    FNumber: SmallInt;
  public
    class function Make: IConsumptionSaleFilter;

    function Status(AValue: TConsumptionSaleStatus): IConsumptionSaleFilter; overload;
    function Status: TConsumptionSaleStatus; overload;

    function Number(AValue: SmallInt): IConsumptionSaleFilter; overload;
    function Number: SmallInt overload;
  end;

implementation

{ TConsumptionFilter }

class function TConsumptionSaleFilter.Make: IConsumptionSaleFilter;
begin
  Result := Self.Create;
end;

function TConsumptionSaleFilter.Number: SmallInt;
begin
  Result := FNumber;
end;

function TConsumptionSaleFilter.Number(AValue: SmallInt): IConsumptionSaleFilter;
begin
  Result := Self;
  FNumber := AValue;
end;

function TConsumptionSaleFilter.Status: TConsumptionSaleStatus;
begin
  Result := FStatus;
end;

function TConsumptionSaleFilter.Status(AValue: TConsumptionSaleStatus): IConsumptionSaleFilter;
begin
  Result := Self;
  FStatus := AValue;
end;

end.

