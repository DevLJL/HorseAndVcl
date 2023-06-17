unit uPerson.DataFactory;

interface

uses
  uBase.DataFactory,
  uPerson.Show.DTO,
  uPerson.Input.DTO,
  uPerson.Persistence.UseCase.Interfaces,
  uPerson.Persistence.UseCase;

type
  IPersonDataFactory = Interface
    ['{4AC6770F-A06E-44C4-A322-73E6306329A9}']
    function GenerateInsert(AIsSeller: Boolean = False; AIsSupplier: Boolean = False; AIsCarrier: Boolean = False): TPersonShowDTO;
    function GenerateInput(AIsSeller: Boolean = False; AIsSupplier: Boolean = False; AIsCarrier: Boolean = False): TPersonInputDTO;
  End;

  TPersonDataFactory = class(TBaseDataFactory, IPersonDataFactory)
  private
    FPersistence: IPersonPersistenceUseCase;
    constructor Create(APersistenceUseCase: IPersonPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IPersonPersistenceUseCase = nil): IPersonDataFactory;
    function GenerateInsert(AIsSeller: Boolean = False; AIsSupplier: Boolean = False; AIsCarrier: Boolean = False): TPersonShowDTO;
    function GenerateInput(AIsSeller: Boolean = False; AIsSupplier: Boolean = False; AIsCarrier: Boolean = False): TPersonInputDTO;
  end;

implementation

{ TPersonDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uPerson.Types,
  uHlp,
  uCity.Show.DTO,
  uCity.DataFactory,
  uPersonContact.Input.DTO,
  uTestConnection;

constructor TPersonDataFactory.Create(APersistenceUseCase: IPersonPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TPersonPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).Person);
end;

function TPersonDataFactory.GenerateInput(AIsSeller, AIsSupplier, AIsCarrier: Boolean): TPersonInputDTO;
begin
  const CityShowDTO: SH<TCityShowDTO> = TCityDataFactory.Make.GenerateInsert;

  // Person
  Result := TPersonInputDTO.Create;
  With Result do
  begin
    name                    := TFaker.PersonName;
    alias_name              := name;
    legal_entity_number     := TFaker.GenerateCNPJ;
    icms_taxpayer           := TPersonIcmsTaxPayer.Yes;
    state_registration      := Random(99999).ToString;
    municipal_registration  := Random(99999).ToString;
    zipcode                 := Random(99999999).ToString;
    address                 := TFaker.LoremIpsum(60);
    address_number          := TFaker.LoremIpsum(15);
    complement              := TFaker.LoremIpsum(255);
    district                := TFaker.LoremIpsum(255);
    city_id                 := CityShowDTO.Value.id;
    reference_point         := TFaker.LoremIpsum(255);
    phone_1                 := FormatPhone('19'+Random(999999999).ToString);
    phone_2                 := FormatPhone('19'+Random(999999999).ToString);
    phone_3                 := FormatPhone('19'+Random(999999999).ToString);
    company_email           := TFaker.Email;
    financial_email         := TFaker.Email;
    internet_page           := TFaker.Email;
    note                    := TFaker.LoremIpsum(255);
    bank_note               := TFaker.LoremIpsum(255);
    commercial_note         := TFaker.LoremIpsum(255);
    flg_customer            := 1;
    flg_seller              := BoolInt(AIsSeller);
    flg_supplier            := BoolInt(AIsSupplier);
    flg_carrier             := BoolInt(AIsCarrier);
    flg_technician          := Random(1);
    flg_employee            := Random(1);
    flg_other               := Random(1);
    flg_final_customer      := Random(1);
    acl_user_id := 1;
  end;

  // PersonContact
  for var lI := 0 to 2 do
  begin
    Result.person_contacts.Add(TPersonContactInputDTO.Create);
    With Result.person_contacts.Last do
    begin
      name                := TFaker.PersonName;
      legal_entity_number := TFaker.GenerateCNPJ;
      &type               := 'Celular ' + lI.ToString;
      note                := TFaker.LoremIpsum(255);
      phone               := FormatPhone('19'+Random(999999999).ToString);
      email               := TFaker.Email;
    end;
  end;
end;

function TPersonDataFactory.GenerateInsert(AIsSeller, AIsSupplier, AIsCarrier: Boolean): TPersonShowDTO;
begin
  const LInput: SH<TPersonInputDTO> = GenerateInput(AIsSeller, AIsSupplier, AIsCarrier);
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TPersonDataFactory.Make(APersistenceUseCase: IPersonPersistenceUseCase): IPersonDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
