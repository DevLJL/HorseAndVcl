unit uBase.Repository.Interfaces;

interface

uses
  uZLConnection.Interfaces,
  uBase.Entity,
  Data.DB,
  
  uSelectWithFilter,
  uIndexResult,
  uFilter;

type
  IBaseRepository = Interface
    ['{DF8FA88E-A8C3-4D32-891D-A903B1DC12C3}']

    function Conn: IZLConnection;
    function SetManageTransaction(AValue: Boolean): IBaseRepository;
    function Delete(AId: Int64): Boolean;
    function DeleteByIdRange(AId: String): Boolean;
    function Index(AFilter: IFilter): IIndexResult;
    function ShowById(AId: Int64): TBaseEntity;
    function Store(AEntity: TBaseEntity): Int64;
    function Update(AId: Int64; AEntity: TBaseEntity): Int64;
    function DataSetToEntity(ADtsBrand: TDataSet): TBaseEntity;
    function SelectAllWithFilter(AFilter: IFilter): TOutPutSelectAlLFilter;
  end;

implementation

end.
