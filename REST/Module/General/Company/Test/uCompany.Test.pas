unit uCompany.Test;

interface

uses
  DUnitX.TestFramework,
  uCompany.Persistence.UseCase.Interfaces,
  uCompany.Persistence.UseCase,
  uCompany.DataFactory;

type
  [TestFixture]
  TCompanyTest = class
  private
    FPersistence: ICompanyPersistenceUseCase;
    FDataFactory: ICompanyDataFactory;
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
  uCompany.Show.DTO,
  System.SysUtils,
  uCompany.Filter.DTO,
  System.Classes,
  uTestConnection;

{ TCompanyTest }

procedure TCompanyTest.Setup;
begin
  FPersistence := TCompanyPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Company);
  FDataFactory        := TCompanyDataFactory.Make(FPersistence);
end;

procedure TCompanyTest.should_update_by_id;
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

procedure TCompanyTest.should_find_by_id;
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

procedure TCompanyTest.should_delete_by_id;
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

procedure TCompanyTest.should_include;
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

procedure TCompanyTest.should_list_records;
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
    'send_email_app_default',
    'send_email_email',
    'send_email_identification',
    'send_email_user',
    'send_email_password',
    'send_email_smtp',
    'send_email_port',
    'send_email_ssl',
    'send_email_tls',
    'send_email_email_accountant',
    'send_email_footer_message',
    'send_email_header_message',
    'city_name',
    'city_state',
    'city_ibge_code'
  ];

begin
  // Inserir registros
  var LPks := '';
  for var I := 1 to EXPECTED_COUNT do
  begin
    const LStored: SH<TCompanyShowDTO> = FDataFactory.GenerateInsert;
    LPks := LPks + LStored.Value.id.ToString + ', ';
  end;
  LPks := Copy(LPks, 1, Length(LPks)-2);

  // Listar registros
  const CompanyFilterDTO: SH<TCompanyFilterDTO> = TCompanyFilterDTO.Create;
  CompanyFilterDTO.Value.where_pk_in := LPks;
  const LIndexResult = FPersistence.Index(CompanyFilterDTO);

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
  TDUnitX.RegisterTestFixture(TCompanyTest);
end.
