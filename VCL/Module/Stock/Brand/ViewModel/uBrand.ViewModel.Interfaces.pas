unit uBrand.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uBrand.Show.DTO,
  uBrand.Input.DTO,
  uZLMemTable.Interfaces;

type
  IBrandViewModel = Interface(IBaseViewModel)
    ['{5F4FFF81-1CE8-4D00-93DA-FC6222D1741E}']
    function  FromShowDTO(AInput: TBrandShowDTO): IBrandViewModel;
    function  ToInputDTO: TBrandInputDTO;
    function  EmptyDataSets: IBrandViewModel;
    function  SetEvents: IBrandViewModel;

    function  Brand: IZLMemTable;
  end;

implementation

end.


