unit uCity.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uCity.Show.DTO,
  uCity.Input.DTO,
  uZLMemTable.Interfaces;

type
  ICityViewModel = Interface(IBaseViewModel)
    ['{A8E4B373-676C-45E7-BBA6-352F6632D98D}']
    function  FromShowDTO(AInput: TCityShowDTO): ICityViewModel;
    function  ToInputDTO: TCityInputDTO;
    function  EmptyDataSets: ICityViewModel;
    function  SetEvents: ICityViewModel;

    function  City: IZLMemTable;
  end;

implementation

end.
