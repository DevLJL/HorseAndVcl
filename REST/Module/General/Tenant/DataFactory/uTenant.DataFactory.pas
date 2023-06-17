unit uTenant.DataFactory;

interface

uses
  uBase.DataFactory,
  uTenant.Show.DTO,
  uTenant.Input.DTO,
  uTenant.Persistence.UseCase.Interfaces,
  uTenant.Persistence.UseCase;

type
  ITenantDataFactory = Interface
    ['{D9EBBFC4-5F79-4007-AD39-A62C3BFC8059}']
    function GenerateInsert: TTenantShowDTO;
    function GenerateInput: TTenantInputDTO;
  End;

  TTenantDataFactory = class(TBaseDataFactory, ITenantDataFactory)
  private
    FPersistence: ITenantPersistenceUseCase;
    constructor Create(APersistenceUseCase: ITenantPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: ITenantPersistenceUseCase = nil): ITenantDataFactory;
    function GenerateInsert: TTenantShowDTO;
    function GenerateInput: TTenantInputDTO;
  end;

implementation

{ TTenantDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uCity.Show.DTO,
  uCity.DataFactory,
  uHlp;

constructor TTenantDataFactory.Create(APersistenceUseCase: ITenantPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
end;

function TTenantDataFactory.GenerateInput: TTenantInputDTO;
begin
  const CityShowDTO: SH<TCityShowDTO> = TCityDataFactory.Make.GenerateInsert;

  Result := TTenantInputDTO.Create;
  With Result do
  begin
    name                        := TFaker.PersonName;
    alias_name                  := name;
    legal_entity_number         := TFaker.GenerateCNPJ;
    icms_taxpayer               := 1;
    state_registration          := Random(99999).ToString;
    municipal_registration      := Random(99999).ToString;
    zipcode                     := Random(99999999).ToString;
    address                     := TFaker.Text(60);
    address_number              := TFaker.Text(15);
    complement                  := TFaker.Text(255);
    district                    := TFaker.Text(255);
    city_id                     := CityShowDTO.Value.id;
    reference_point             := TFaker.Text(255);
    phone_1                     := FormatPhone('19'+Random(999999999).ToString);
    phone_2                     := FormatPhone('19'+Random(999999999).ToString);
    phone_3                     := FormatPhone('19'+Random(999999999).ToString);
    company_email               := TFaker.Email;
    financial_email             := TFaker.Email;
    internet_page               := TFaker.Email;
    note                        := TFaker.Text(255);
    bank_note                   := TFaker.Text(255);
    commercial_note             := TFaker.Text(255);
    send_email_app_default      := Random(1);
    send_email_email            := TFaker.Email;
    send_email_identification   := TFaker.PersonName;
    send_email_user             := TFaker.Email;
    send_email_password         := TFaker.GenerateUUID;
    send_email_smtp             := TFaker.Text(10);
    send_email_port             := TFaker.NumberStr(4);
    send_email_ssl              := Random(1);
    send_email_tls              := Random(1);
    send_email_email_accountant := TFaker.Email;
    send_email_footer_message   := TFaker.Text(255);
    send_email_header_message   := TFaker.Text(255);
    acl_user_id                 := 1;
  end;
end;

function TTenantDataFactory.GenerateInsert: TTenantShowDTO;
begin
  const LInput: SH<TTenantInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TTenantDataFactory.Make(APersistenceUseCase: ITenantPersistenceUseCase): ITenantDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
