unit uCategory.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uCategory.Show.DTO,
  uCategory.Input.DTO,
  uZLMemTable.Interfaces;

type
  ICategoryViewModel = Interface(IBaseViewModel)
    ['{B2525177-5F84-4A07-B9EE-3EEEB0432EFE}']
    function  FromShowDTO(AInput: TCategoryShowDTO): ICategoryViewModel;
    function  ToInputDTO: TCategoryInputDTO;
    function  EmptyDataSets: ICategoryViewModel;
    function  SetEvents: ICategoryViewModel;

    function  Category: IZLMemTable;
  end;

implementation

end.


