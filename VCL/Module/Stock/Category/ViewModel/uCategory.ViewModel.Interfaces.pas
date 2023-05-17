unit uCategory.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uCategory.Show.DTO,
  uCategory.Input.DTO,
  uZLMemTable.Interfaces;

type
  ICategoryViewModel = Interface(IBaseViewModel)
    ['{8A30C852-72AA-4EA9-87C1-FA65C8DA3012}']
    function  FromShowDTO(AInput: TCategoryShowDTO): ICategoryViewModel;
    function  ToInputDTO: TCategoryInputDTO;
    function  EmptyDataSets: ICategoryViewModel;
    function  SetEvents: ICategoryViewModel;

    function  Category: IZLMemTable;
  end;

implementation

end.


