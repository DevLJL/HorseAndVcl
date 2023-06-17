unit uChartOfAccount.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uChartOfAccount.Show.DTO,
  uChartOfAccount.Input.DTO,
  uZLMemTable.Interfaces;

type
  IChartOfAccountViewModel = Interface(IBaseViewModel)
    ['{7C3C4ACF-7F59-4561-BF84-CAD1CC9EDF4C}']
    function  FromShowDTO(AInput: TChartOfAccountShowDTO): IChartOfAccountViewModel;
    function  ToInputDTO: TChartOfAccountInputDTO;
    function  EmptyDataSets: IChartOfAccountViewModel;
    function  SetEvents: IChartOfAccountViewModel;

    function  ChartOfAccount: IZLMemTable;
  end;

implementation

end.


