unit uSize.DataFactory;

interface

uses
  uBase.DataFactory,
  uSize.Show.DTO,
  uSize.Input.DTO,
  uSize.Persistence.UseCase.Interfaces,
  uSize.Persistence.UseCase;

type
  ISizeDataFactory = Interface
    ['{912CA5A0-9D50-4BA4-B322-D15D184DACEA}']
    function GenerateInsert: TSizeShowDTO;
    function GenerateInput: TSizeInputDTO;
  End;

  TSizeDataFactory = class(TBaseDataFactory, ISizeDataFactory)
  private
    FPersistence: ISizePersistenceUseCase;
    constructor Create(APersistenceUseCase: ISizePersistenceUseCase);
  public
    class function Make(APersistenceUseCase: ISizePersistenceUseCase = nil): ISizeDataFactory;
    function GenerateInsert: TSizeShowDTO;
    function GenerateInput: TSizeInputDTO;
  end;

implementation

{ TSizeDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection;

constructor TSizeDataFactory.Create(APersistenceUseCase: ISizePersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TSizePersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Size);
end;

function TSizeDataFactory.GenerateInput: TSizeInputDTO;
begin
  Result := TSizeInputDTO.Create;
  With Result do
  begin
    name        := TFaker.Size;
    acl_user_id := 1;
  end;
end;

function TSizeDataFactory.GenerateInsert: TSizeShowDTO;
begin
  const LInput: SH<TSizeInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TSizeDataFactory.Make(APersistenceUseCase: ISizePersistenceUseCase): ISizeDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
