unit uProduct.Test;

interface

uses
  DUnitX.TestFramework,
  uProduct.Persistence.UseCase.Interfaces,
  uProduct.Persistence.UseCase,
  uProduct.DataFactory;

type
  [TestFixture]
  TProductTest = class
  private
    FPersistence: IProductPersistenceUseCase;
    FDataFactory: IProductDataFactory;
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
  uProduct.Show.DTO,
  System.SysUtils,
  uProduct.Filter.DTO,
  System.Classes,
  uTestConnection;

{ TProductTest }

procedure TProductTest.Setup;
begin
  FPersistence := TProductPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Product);
  FDataFactory        := TProductDataFactory.Make(FPersistence);
end;

procedure TProductTest.should_update_by_id;
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

procedure TProductTest.should_find_by_id;
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

procedure TProductTest.should_delete_by_id;
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

procedure TProductTest.should_include;
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

procedure TProductTest.should_list_records;
const
  EXPECTED_COUNT = 3;
  EXPECTED_FIELDS: TArray<String> = [
    'id',
    'name',
    'simplified_name',
    'type',
    'sku_code',
    'ean_code',
    'manufacturing_code',
    'identification_code',
    'cost',
    'marketup',
    'price',
    'current_quantity',
    'minimum_quantity',
    'maximum_quantity',
    'gross_weight',
    'net_weight',
    'packing_weight',
    'flg_to_move_the_stock',
    'flg_product_for_scales',
    'internal_note',
    'complement_note',
    'flg_discontinued',
    'unit_id',
    'ncm_id',
    'category_id',
    'brand_id',
    'size_id',
    'storage_location_id',
    'genre',
    'created_at',
    'updated_at',
    'created_by_acl_user_id',
    'updated_by_acl_user_id',
    'unit_name',
    'ncm_code',
    'ncm_name',
    'category_name',
    'brand_name',
    'size_name',
    'storage_location_name',
    'created_by_acl_user_name',
    'updated_by_acl_user_name'
  ];

begin
  // Inserir registros
  var LPks := '';
  for var I := 1 to EXPECTED_COUNT do
  begin
    const LStored: SH<TProductShowDTO> = FDataFactory.GenerateInsert;
    LPks := LPks + LStored.Value.id.ToString + ', ';
  end;
  LPks := Copy(LPks, 1, Length(LPks)-2);

  // Listar registros
  const ProductFilterDTO: SH<TProductFilterDTO> = TProductFilterDTO.Create;
  ProductFilterDTO.Value.where_pk_in := LPks;
  const LIndexResult = FPersistence.Index(ProductFilterDTO);

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
  TDUnitX.RegisterTestFixture(TProductTest);
end.
