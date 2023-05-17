unit uBillPayReceive.Test;

interface

uses
  DUnitX.TestFramework,
  uBillPayReceive.Persistence.UseCase.Interfaces,
  uBillPayReceive.Persistence.UseCase,
  uBillPayReceive.DataFactory;

type
  [TestFixture]
  TBillPayReceiveTest = class
  private
    FPersistence: IBillPayReceivePersistenceUseCase;
    FDataFactory: IBillPayReceiveDataFactory;
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
  uBillPayReceive.Show.DTO,
  System.SysUtils,
  uBillPayReceive.Filter.DTO,
  System.Classes,
  uTestConnection;

{ TBillPayReceiveTest }

procedure TBillPayReceiveTest.Setup;
begin
  FPersistence := TBillPayReceivePersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).BillPayReceive);
  FDataFactory        := TBillPayReceiveDataFactory.Make(FPersistence);
end;

procedure TBillPayReceiveTest.should_update_by_id;
begin
  // Inserir registro para posteriormente atualizar
  const LStored = FDataFactory.GenerateInsert;

  // Gerar dados aleatórios
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

procedure TBillPayReceiveTest.should_find_by_id;
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

procedure TBillPayReceiveTest.should_delete_by_id;
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

procedure TBillPayReceiveTest.should_include;
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

procedure TBillPayReceiveTest.should_list_records;
const
  EXPECTED_COUNT = 3;
  EXPECTED_FIELDS: TArray<String> = [
    'id',
    'batch',
    'type',
    'short_description',
    'person_id',
    'chart_of_account_id',
    'cost_center_id',
    'bank_account_id',
    'payment_id',
    'due_date',
    'installment_quantity',
    'installment_number',
    'amount',
    'discount',
    'interest_and_fine',
    'net_amount',
    'status',
    'payment_date',
    'note',
    'sale_id',
    'created_at',
    'updated_at',
    'created_by_acl_user_id',
    'updated_by_acl_user_id',
    'created_by_acl_user_name',
    'updated_by_acl_user_name',
    'person_name',
    'chart_of_account_name',
    'cost_center_name',
    'bank_account_name',
    'payment_name'
  ];

begin
  // Inserir registros
  var LPks := '';
  for var I := 1 to EXPECTED_COUNT do
  begin
    const LStored: SH<TBillPayReceiveShowDTO> = FDataFactory.GenerateInsert;
    LPks := LPks + LStored.Value.id.ToString + ', ';
  end;
  LPks := Copy(LPks, 1, Length(LPks)-2);

  // Listar registros
  const BillPayReceiveFilterDTO: SH<TBillPayReceiveFilterDTO> = TBillPayReceiveFilterDTO.Create;
  BillPayReceiveFilterDTO.Value.where_pk_in := LPks;
  const LIndexResult = FPersistence.Index(BillPayReceiveFilterDTO);

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
  TDUnitX.RegisterTestFixture(TBillPayReceiveTest);
end.
