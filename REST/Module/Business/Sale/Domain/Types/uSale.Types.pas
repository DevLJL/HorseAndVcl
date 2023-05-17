unit uSale.Types;

interface

{$SCOPEDENUMS ON}
type
  TSaleDeliveryStatus = (New, refused, Scheduled, Preparing, InTransit, Delivered, Canceled);
  TSaleType = (Normal, Consumption, Delivery);

  TSaleStatus = (Pending, Approved, Canceled);
  TSaleStatusHelper = record Helper for TSaleStatus
    function ToString : string;
    class function FromString(const AOper: string): TSaleStatus; static;
  end;

  TSaleGenerateBillingOperation = (Revert, Approve, Cancel);
  TSaleGenerateBillingOperationHelper = record Helper for TSaleGenerateBillingOperation
    function ToString : string;
    class function FromString(const AOper: string): TSaleGenerateBillingOperation; static;
  end;

implementation

uses
  System.SysUtils,
  System.TypInfo;

{ TSaleGenerateBillingOperationHelper }
class function TSaleGenerateBillingOperationHelper.FromString(const AOper: string): TSaleGenerateBillingOperation;
begin
  Result := TSaleGenerateBillingOperation(GetEnumValue(TypeInfo(TSaleGenerateBillingOperation), AOper));
end;

function TSaleGenerateBillingOperationHelper.ToString: string;
begin
  Result := GetEnumName(TypeInfo(TSaleGenerateBillingOperation), Integer(Self)).Trim;
end;


{ TSaleStatusHelper }
class function TSaleStatusHelper.FromString(const AOper: string): TSaleStatus;
begin
  Result := TSaleStatus(GetEnumValue(TypeInfo(TSaleStatus), AOper));
end;

function TSaleStatusHelper.ToString: string;
begin
  Result := GetEnumName(TypeInfo(TSaleStatus), Integer(Self)).Trim;
end;

end.
