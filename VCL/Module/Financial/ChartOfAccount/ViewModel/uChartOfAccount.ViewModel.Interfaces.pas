unit uChartOfAccount.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uChartOfAccount.Show.DTO,
  uChartOfAccount.Input.DTO,
  uZLMemTable.Interfaces;

type
  IChartOfAccountViewModel = Interface(IBaseViewModel)
    ['{7AB49534-A5F6-43ED-B1F2-1B6EB242425F}']
    function  FromShowDTO(AInput: TChartOfAccountShowDTO): IChartOfAccountViewModel;
    function  ToInputDTO: TChartOfAccountInputDTO;
    function  EmptyDataSets: IChartOfAccountViewModel;
    function  SetEvents: IChartOfAccountViewModel;

    function  ChartOfAccount: IZLMemTable;
  end;

implementation

end.


