unit uConsumption.Test;

interface

uses
  DUnitX.TestFramework,
  uConsumption.Persistence.UseCase.Interfaces,
  uConsumption.Persistence.UseCase,
  uConsumption.DataFactory;

type
  [TestFixture]
  TConsumptionTest = class
  private
    FPersistence: IConsumptionPersistenceUseCase;
    FDataFactory: IConsumptionDataFactory;
  public
    [Setup]
    procedure Setup;

    [Test]
    procedure should_delete_by_id;

    [Test]
    procedure should_find_by_id;

    [Test]
    procedure should_include;

    [Test]
    procedure should_list_records;

    [Test]
    procedure should_update_by_id;
  end;

implementation

uses
  uRepository.Factory,
  uSmartPointer,
  uConsumption.Show.DTO,
  System.SysUtils,
  uConsumption.Filter.DTO,
  System.Classes,
  uTestConnection;

{ TConsumptionTest }

procedure TConsumptionTest.Setup;
begin
  FPersistence := TConsumptionPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Consumption);
  FDataFactory        := TConsumptionDataFactory.Make(FPersistence);
end;

procedure TConsumptionTest.should_update_by_id;
begin
  // Inserir registro para posteriormente atualizar
  const LStored = FDataFactory.GenerateInsert;

  // Gerar dados aleat�rios
  const LInput = FDataFactory.GenerateInput;
//  LInput.name := 'Edit'+ LInput.name;

  // Atualizar e localizar registro atualizado
  const LUpdatedId = FPersistence.Update(LStored.id, LInput);
  const LFound = FPersistence.Show(LUpdatedId);

  // Confirmar Valores
  Assert.IsTrue(Assigned(LFound));
//  Assert.IsTrue(LStored.name <> LFound.name);

  // Limpar Dados
  FPersistence.Delete(LFound.id);
  LStored.Free;
  LInput.Free;
  LFound.Free;
end;

procedure TConsumptionTest.should_find_by_id;
begin
  // Inserir registro para posteriormente localizar
  const LStored = FDataFactory.GenerateInsert;

  // Localizar registro inserido
  const LFound = FPersistence.Show(LStored.id);

  // Confirmar Valores
  Assert.IsTrue(Assigned(LFound));

  // Limpar Dados
  FPersistence.Delete(LFound.id);
  LStored.Free;
  LFound.Free;
end;

procedure TConsumptionTest.should_delete_by_id;
begin
  // Inserir registro para posteriormente deletar
  const LStored = FDataFactory.GenerateInsert;

  // Deletar registro
  FPersistence.Delete(LStored.id);

  // Tentar localizar registro deletado
  const LFound = FPersistence.Show(LStored.id);

  // Confirmar Valores
  Assert.IsTrue(not Assigned(LFound));

  // Destruir Objetos
  LStored.Free;
  LFound.Free;
end;

procedure TConsumptionTest.should_include;
begin
  // Inserir registro
  const LStored = FDataFactory.GenerateInsert;

  // Localizar registro inserido
  const LFound = FPersistence.Show(LStored.id);

  // Confirmar Valores
  Assert.IsTrue(Assigned(LFound));
//  Assert.IsTrue(LFound.name = LStored.name);

  // Limpar Dados
  FPersistence.Delete(LFound.id);
  LStored.Free;
  LFound.Free;
end;

procedure TConsumptionTest.should_list_records;
const
  EXPECTED_COUNT = 3;
  EXPECTED_FIELDS: TArray<String> = [
    'id',
    'number',
    'flg_active',
    'created_at',
    'updated_at',
    'created_by_acl_user_id',
    'updated_by_acl_user_id',
    'created_by_acl_user_name',
    'updated_by_acl_user_name'
  ];

begin
  // Inserir registros
  var LPks := '';
  for var I := 1 to EXPECTED_COUNT do
  begin
    const LStored: SH<TConsumptionShowDTO> = FDataFactory.GenerateInsert;
    LPks := LPks + LStored.Value.id.ToString + ', ';
  end;
  LPks := Copy(LPks, 1, Length(LPks)-2);

  // Listar registros
  const ConsumptionFilterDTO: SH<TConsumptionFilterDTO> = TConsumptionFilterDTO.Create;
  ConsumptionFilterDTO.Value.where_pk_in := LPks;
  const LIndexResult = FPersistence.Index(ConsumptionFilterDTO);

  // Verificar se foram inseridos 3 registros
  Assert.IsTrue(LIndexResult.AllPagesRecordCount = EXPECTED_COUNT);

  // Verificar exist�ncia dos campos
  for var CurrentField in EXPECTED_FIELDS do
    Assert.IsTrue(Assigned(LIndexResult.Data.FindField(CurrentField)), 'Campo n�o encontrado: ' + CurrentField);

  // Verificar quantidade de campos retornados
  Assert.IsTrue(Length(EXPECTED_FIELDS) = LIndexResult.Data.FieldCount);

  // Limpar Dados
  FPersistence.DeleteByIdRange(LPks);
end;

initialization
  TDUnitX.RegisterTestFixture(TConsumptionTest);
end.
