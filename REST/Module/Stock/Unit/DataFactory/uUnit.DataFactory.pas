unit uUnit.DataFactory;

interface

uses
  uBase.DataFactory,
  uUnit.Show.DTO,
  uUnit.Input.DTO,
  uUnit.Persistence.UseCase.Interfaces,
  uUnit.Persistence.UseCase;

type
  IUnitDataFactory = Interface
    ['{E4C5E02D-D8BF-47ED-B744-FCF54F4B5684}']
    function GenerateInsert: TUnitShowDTO;
    function GenerateInput: TUnitInputDTO;
  End;

  TUnitDataFactory = class(TBaseDataFactory, IUnitDataFactory)
  private
    FPersistence: IUnitPersistenceUseCase;
    constructor Create(APersistenceUseCase: IUnitPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IUnitPersistenceUseCase = nil): IUnitDataFactory;
    function GenerateInsert: TUnitShowDTO;
    function GenerateInput: TUnitInputDTO;
  end;

implementation

{ TUnitDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection;

constructor TUnitDataFactory.Create(APersistenceUseCase: IUnitPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TUnitPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).&Unit);
end;

function TUnitDataFactory.GenerateInput: TUnitInputDTO;
begin
  Result := TUnitInputDTO.Create;
  With Result do
  begin
    name        := TFaker.Unit;
    description := TFaker.Text(100);
    acl_user_id := 1;
  end;
end;

function TUnitDataFactory.GenerateInsert: TUnitShowDTO;
begin
  const LInput: SH<TUnitInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TUnitDataFactory.Make(APersistenceUseCase: IUnitPersistenceUseCase): IUnitDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
