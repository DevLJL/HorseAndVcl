unit uNcm.DataFactory;

interface

uses
  uBase.DataFactory,
  uNcm.Show.DTO,
  uNcm.Input.DTO,
  uNcm.Persistence.UseCase.Interfaces,
  uNcm.Persistence.UseCase;

type
  INcmDataFactory = Interface
    ['{A95D54B6-1D3F-4168-AF32-D2355A3AC15C}']
    function GenerateInsert: TNcmShowDTO;
    function GenerateInput: TNcmInputDTO;
  End;

  TNcmDataFactory = class(TBaseDataFactory, INcmDataFactory)
  private
    FPersistence: INcmPersistenceUseCase;
    constructor Create(APersistenceUseCase: INcmPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: INcmPersistenceUseCase = nil): INcmDataFactory;
    function GenerateInsert: TNcmShowDTO;
    function GenerateInput: TNcmInputDTO;
  end;

implementation

{ TNcmDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection;

constructor TNcmDataFactory.Create(APersistenceUseCase: INcmPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TNcmPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Ncm);
end;

function TNcmDataFactory.GenerateInput: TNcmInputDTO;
begin
  Result := TNcmInputDTO.Create;
  With Result do
  begin
    name                   := TFaker.Text(60);
    code                   := TFaker.NumberStr(8);
    national_rate          := TFaker.NumberFloat;
    imported_rate          := TFaker.NumberFloat;
    state_rate             := TFaker.NumberFloat;
    municipal_rate         := TFaker.NumberFloat;
    cest                   := TFaker.NumberStr(8);
    additional_information := TFaker.Text(255);
    start_of_validity      := now;
    end_of_validity        := IncMonth(Now,1);
    acl_user_id := 1;
  end;
end;

function TNcmDataFactory.GenerateInsert: TNcmShowDTO;
begin
  const LInput: SH<TNcmInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TNcmDataFactory.Make(APersistenceUseCase: INcmPersistenceUseCase): INcmDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
