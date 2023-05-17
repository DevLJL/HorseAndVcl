unit uCategory.DataFactory;

interface

uses
  uBase.DataFactory,
  uCategory.Show.DTO,
  uCategory.Input.DTO,
  uCategory.Persistence.UseCase.Interfaces,
  uCategory.Persistence.UseCase;

type
  ICategoryDataFactory = Interface
    ['{7DA32579-EBB3-40ED-B9CF-33B1EE9016DB}']
    function GenerateInsert: TCategoryShowDTO;
    function GenerateInput: TCategoryInputDTO;
  End;

  TCategoryDataFactory = class(TBaseDataFactory, ICategoryDataFactory)
  private
    FPersistence: ICategoryPersistenceUseCase;
    constructor Create(APersistenceUseCase: ICategoryPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: ICategoryPersistenceUseCase = nil): ICategoryDataFactory;
    function GenerateInsert: TCategoryShowDTO;
    function GenerateInput: TCategoryInputDTO;
  end;

implementation

{ TCategoryDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection;

constructor TCategoryDataFactory.Create(APersistenceUseCase: ICategoryPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TCategoryPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Category);
end;

function TCategoryDataFactory.GenerateInput: TCategoryInputDTO;
begin
  Result := TCategoryInputDTO.Create;
  With Result do
  begin
    name        := TFaker.Category;
    acl_user_id := 1;
  end;
end;

function TCategoryDataFactory.GenerateInsert: TCategoryShowDTO;
begin
  const LInput: SH<TCategoryInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TCategoryDataFactory.Make(APersistenceUseCase: ICategoryPersistenceUseCase): ICategoryDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
