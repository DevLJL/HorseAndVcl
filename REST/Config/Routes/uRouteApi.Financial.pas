unit uRouteApi.Financial;

interface

uses
  Horse;

type
  TRouteApiFinancial = class
    class procedure Registry;
  end;

implementation

uses
  Horse.GBSwagger.Register,
  uBank.Controller,
  uCostCenter.Controller,
  uBankAccount.Controller,
  uChartOfAccount.Controller,
  uPayment.Controller,
  uBillPayReceive.Controller,
  uCashFlow.Controller;

{ TRouteApiFinancial }

class procedure TRouteApiFinancial.Registry;
begin
  With THorseGBSwaggerRegister do
  begin
    RegisterPath(TBankController);
    RegisterPath(TCostCenterController);
    RegisterPath(TBankAccountController);
    RegisterPath(TChartOfAccountController);
    RegisterPath(TPaymentController);
    RegisterPath(TBillPayReceiveController);
    RegisterPath(TCashFlowController);
  end;
end;

end.

