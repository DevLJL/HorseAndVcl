unit uPerson.Test;

interface

uses
  DUnitX.TestFramework,
  uPerson.Persistence.UseCase,
  uPerson.Persistence.UseCase.Interfaces,
  uPerson.DataFactory;

type
  [TestFixture]
  TPersonTest = class
  private
    FPersistence: IPersonPersistenceUseCase;
    FDataFactory: IPersonDataFactory;
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
  uPerson.Show.DTO,
  System.SysUtils,
  uPerson.Filter.DTO,
  System.Classes,
  uTestConnection;

{ TPersonTest }

procedure TPersonTest.Setup;
begin
  FPersistence := TPersonPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Person);
  FDataFactory        := TPersonDataFactory.Make(FPersistence);
end;

procedure TPersonTest.should_update_by_id;
begin
  // Inserir registro para posteriormente atualizar
  const LStored = FDataFactory.GenerateInsert;

  // Gerar dados aleatórios
  const LInput = FDataFactory.GenerateInput;
  LInput.name := 'Edit'+ LInput.name;

  // Atualizar e localizar registro atualizado
  const LUpdatedId = FPersistence.Update(LStored.id, LInput);
  const LFound = FPersistence.Show(LUpdatedId);

  // Confirmar Valores
  Assert.IsTrue(Assigned(LFound));
  Assert.IsTrue(LStored.name <> LFound.name);

  // Limpar Dados
  FPersistence.Delete(LFound.id);
  LStored.Free;
  LInput.Free;
  LFound.Free;
end;

procedure TPersonTest.should_find_by_id;
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

procedure TPersonTest.should_delete_by_id;
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

procedure TPersonTest.should_include;
begin
  // Inserir registro
  const LStored = FDataFactory.GenerateInsert;

  // Localizar registro inserido
  const LFound = FPersistence.Show(LStored.id);

  // Confirmar Valores
  Assert.IsTrue(Assigned(LFound));
  Assert.IsTrue(LFound.name = LStored.name);

  // Limpar Dados
  FPersistence.Delete(LFound.id);
  LStored.Free;
  LFound.Free;
end;

procedure TPersonTest.should_list_records;
const
  EXPECTED_COUNT = 3;
  EXPECTED_FIELDS: TArray<String> = [
    'id',
    'name',
    'alias_name',
    'legal_entity_number',
    'icms_taxpayer',
    'state_registration',
    'municipal_registration',
    'zipcode',
    'address',
    'address_number',
    'complement',
    'district',
    'city_id',
    'reference_point',
    'phone_1',
    'phone_2',
    'phone_3',
    'company_email',
    'financial_email',
    'internet_page',
    'note',
    'bank_note',
    'commercial_note',
    'flg_customer',
    'flg_seller',
    'flg_supplier',
    'flg_carrier',
    'flg_technician',
    'flg_employee',
    'flg_other',
    'flg_final_customer',
    'created_at',
    'updated_at',
    'created_by_acl_user_id',
    'updated_by_acl_user_id',
    'city_name',
    'city_state',
    'city_ibge_code',
    'city_country',
    'city_country_ibge_code',
    'created_by_acl_user_name',
    'updated_by_acl_user_name'
  ];

begin
  // Inserir registros
  var LPks := '';
  for var I := 1 to EXPECTED_COUNT do
  begin
    const LStored: SH<TPersonShowDTO> = FDataFactory.GenerateInsert;
    LPks := LPks + LStored.Value.id.ToString + ', ';
  end;
  LPks := Copy(LPks, 1, Length(LPks)-2);

  // Listar registros
  const PersonFilterDTO: SH<TPersonFilterDTO> = TPersonFilterDTO.Create;
  PersonFilterDTO.Value.where_pk_in := LPks;
  const LIndexResult = FPersistence.Index(PersonFilterDTO);

  // Verificar se foram inseridos 3 registros
  Assert.IsTrue(LIndexResult.AllPagesRecordCount = EXPECTED_COUNT);

  // Verificar existência dos campos
  for var CurrentField in EXPECTED_FIELDS do
    Assert.IsTrue(Assigned(LIndexResult.Data.FindField(CurrentField)), 'Campo não encontrado: ' + CurrentField);

  // Verificar quantidade de campos retornados
  Assert.IsTrue(Length(EXPECTED_FIELDS) = LIndexResult.Data.FieldCount);

  // Limpar Dados
  FPersistence.DeleteByIdRange(LPks);
end;

initialization
  TDUnitX.RegisterTestFixture(TPersonTest);
end.
