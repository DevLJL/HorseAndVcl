unit uCity.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uCity.Show.DTO,
  uCity.Input.DTO,
  uZLMemTable.Interfaces;

type
  ICityViewModel = Interface(IBaseViewModel)
    ['{8A31F6BD-8F53-451C-B59F-6C2073F1D262}']
    function  FromShowDTO(AInput: TCityShowDTO): ICityViewModel;
    function  ToInputDTO: TCityInputDTO;
    function  EmptyDataSets: ICityViewModel;
    function  SetEvents: ICityViewModel;

    function  City: IZLMemTable;
  end;

implementation

end.
