unit uPayment.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uPayment.Show.DTO,
  uPayment.Input.DTO,
  uZLMemTable.Interfaces;

type
  IPaymentViewModel = Interface(IBaseViewModel)
    ['{DFFE2945-2496-4373-B50B-4ED3D293B2A0}']
    function  FromShowDTO(AInput: TPaymentShowDTO): IPaymentViewModel;
    function  ToInputDTO: TPaymentInputDTO;
    function  EmptyDataSets: IPaymentViewModel;
    function  SetEvents: IPaymentViewModel;

    function  Payment: IZLMemTable;
    function  PaymentTerms: IZLMemTable;
  end;

  IPaymentTermsViewModel = Interface
    ['{A22A23BD-BBAD-461F-9BDB-E46E3CE68CF3}']
    function  PaymentTerms: IZLMemTable;
    function  SetEvents: IPaymentTermsViewModel;
  End;

implementation

end.
