unit uGlobalConfig.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uGlobalConfig.Show.DTO,
  uGlobalConfig.Input.DTO,
  uZLMemTable.Interfaces;

type
  IGlobalConfigViewModel = Interface(IBaseViewModel)
    ['{B55DD503-D464-4496-BBB6-8E5B96552085}']
    function  FromShowDTO(AInput: TGlobalConfigShowDTO): IGlobalConfigViewModel;
    function  ToInputDTO: TGlobalConfigInputDTO;
    function  EmptyDataSets: IGlobalConfigViewModel;
    function  SetEvents: IGlobalConfigViewModel;

    function  GlobalConfig: IZLMemTable;
  end;

implementation

end.

