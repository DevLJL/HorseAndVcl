unit uTenant.ViewModel.Interfaces;

interface

uses
  uBase.ViewModel.Interfaces,
  uTenant.Show.DTO,
  uTenant.Input.DTO,
  uZLMemTable.Interfaces;

type
  ITenantViewModel = Interface(IBaseViewModel)
    ['{55988B4A-A33B-4D84-ADF7-71CD539676F0}']
    function  FromShowDTO(AInput: TTenantShowDTO): ITenantViewModel;
    function  ToInputDTO: TTenantInputDTO;
    function  EmptyDataSets: ITenantViewModel;
    function  SetEvents: ITenantViewModel;

    function  Tenant: IZLMemTable;
  end;

implementation

end.

