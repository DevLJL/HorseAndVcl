unit uBrand.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uBrand.Show.DTO,
  uBrand.Input.DTO,
  uZLMemTable.Interfaces;

type
  IBrandViewModel = Interface(IBaseViewModel)
    ['{7AB49534-A5F6-43ED-B1F2-1B6EB242425F}']
    function  FromShowDTO(AInput: TBrandShowDTO): IBrandViewModel;
    function  ToInputDTO: TBrandInputDTO;
    function  EmptyDataSets: IBrandViewModel;
    function  SetEvents: IBrandViewModel;

    function  Brand: IZLMemTable;
  end;

implementation

end.


