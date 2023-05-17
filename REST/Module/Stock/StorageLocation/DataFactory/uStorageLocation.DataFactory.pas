unit uStorageLocation.DataFactory;

interface

uses
  uBase.DataFactory,
  uStorageLocation.Show.DTO,
  uStorageLocation.Input.DTO,
  uStorageLocation.Persistence.UseCase.Interfaces,
  uStorageLocation.Persistence.UseCase;

type
  IStorageLocationDataFactory = Interface
    ['{85E071FD-C6C9-4153-9460-253452856974}']
    function GenerateInsert: TStorageLocationShowDTO;
    function GenerateInput: TStorageLocationInputDTO;
  End;

  TStorageLocationDataFactory = class(TBaseDataFactory, IStorageLocationDataFactory)
  private
    FPersistence: IStorageLocationPersistenceUseCase;
    constructor Create(APersistenceUseCase: IStorageLocationPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IStorageLocationPersistenceUseCase = nil): IStorageLocationDataFactory;
    function GenerateInsert: TStorageLocationShowDTO;
    function GenerateInput: TStorageLocationInputDTO;
  end;

implementation

{ TStorageLocationDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection;

constructor TStorageLocationDataFactory.Create(APersistenceUseCase: IStorageLocationPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TStorageLocationPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).StorageLocation);
end;

function TStorageLocationDataFactory.GenerateInput: TStorageLocationInputDTO;
begin
  Result := TStorageLocationInputDTO.Create;
  With Result do
  begin
    name        := TFaker.Text(60);
    acl_user_id := 1;
  end;
end;

function TStorageLocationDataFactory.GenerateInsert: TStorageLocationShowDTO;
begin
  const LInput: SH<TStorageLocationInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TStorageLocationDataFactory.Make(APersistenceUseCase: IStorageLocationPersistenceUseCase): IStorageLocationDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
