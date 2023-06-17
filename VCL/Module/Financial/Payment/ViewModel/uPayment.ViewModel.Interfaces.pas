unit uPayment.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uPayment.Show.DTO,
  uPayment.Input.DTO,
  uZLMemTable.Interfaces;

type
  IPaymentViewModel = Interface(IBaseViewModel)
    ['{254E038B-E4C8-40C9-9045-1BE64FEDD7CE}']
    function  FromShowDTO(AInput: TPaymentShowDTO): IPaymentViewModel;
    function  ToInputDTO: TPaymentInputDTO;
    function  EmptyDataSets: IPaymentViewModel;
    function  SetEvents: IPaymentViewModel;

    function  Payment: IZLMemTable;
    function  PaymentTerms: IZLMemTable;
  end;

  IPaymentTermsViewModel = Interface
    ['{433E05AA-2DF1-4450-A1CA-0BFDC46DA0E8}']
    function  PaymentTerms: IZLMemTable;
    function  SetEvents: IPaymentTermsViewModel;
  End;

implementation

end.
