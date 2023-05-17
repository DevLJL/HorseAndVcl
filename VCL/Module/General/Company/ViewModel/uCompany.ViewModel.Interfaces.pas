unit uCompany.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uCompany.Show.DTO,
  uCompany.Input.DTO,
  uZLMemTable.Interfaces;

type
  ICompanyViewModel = Interface(IBaseViewModel)
    ['{0A3ADCEE-CFD9-47A3-9034-E724B6F5A416}']
    function  FromShowDTO(AInput: TCompanyShowDTO): ICompanyViewModel;
    function  ToInputDTO: TCompanyInputDTO;
    function  EmptyDataSets: ICompanyViewModel;
    function  SetEvents: ICompanyViewModel;

    function  Company: IZLMemTable;
  end;

implementation

end.

