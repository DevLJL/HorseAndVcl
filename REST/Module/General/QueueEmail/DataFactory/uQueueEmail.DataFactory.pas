unit uQueueEmail.DataFactory;

interface

uses
  uBase.DataFactory,
  uQueueEmail.Show.DTO,
  uQueueEmail.Input.DTO,
  uQueueEmail.Persistence.UseCase.Interfaces,
  uQueueEmail.Persistence.UseCase;

type
  IQueueEmailDataFactory = Interface
    ['{711003F6-6201-4489-B922-E859AAEC304F}']
    function GenerateInsert: TQueueEmailShowDTO;
    function GenerateInput: TQueueEmailInputDTO;
  End;

  TQueueEmailDataFactory = class(TBaseDataFactory, IQueueEmailDataFactory)
  private
    FPersistence: IQueueEmailPersistenceUseCase;
    constructor Create(APersistenceUseCase: IQueueEmailPersistenceUseCase);
  public
    class function Make(APersistenceUseCase: IQueueEmailPersistenceUseCase = nil): IQueueEmailDataFactory;
    function GenerateInsert: TQueueEmailShowDTO;
    function GenerateInput: TQueueEmailInputDTO;
  end;

implementation

{ TQueueEmailDataFactory }

uses
  uSmartPointer,
  uFaker,
  System.SysUtils,
  uRepository.Factory,
  uTestConnection, uQueueEmail.Types, uQueueEmailContact.Input.DTO;

constructor TQueueEmailDataFactory.Create(APersistenceUseCase: IQueueEmailPersistenceUseCase);
begin
  inherited Create;
  FPersistence := APersistenceUseCase;
  if not Assigned(FPersistence) then
    FPersistence := TQueueEmailPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).QueueEmail);
end;

function TQueueEmailDataFactory.GenerateInput: TQueueEmailInputDTO;
begin
  Result := TQueueEmailInputDTO.Create;
  With Result do
  begin
    uuid                := TFaker.GenerateUUID;
    priority            := TQueueEmailPriority.Normal;
    subject             := 'Assunto XXX';
    &message            := TFaker.LoremIpsum;
    sent                := TQueueEmailSent(random(2));
    current_retries     := 0;
  end;

  // Destinatário
  for var lI := 0 to 2 do
  begin
    Result.queue_email_contacts.Add(TQueueEmailContactInputDTO.Create);
    With Result.queue_email_contacts.Last do
    begin
      name  := TFaker.PersonName;
      email := TFaker.Email;
      &type := TQueueEmailContactType.Recipient;
    end;
  end;
end;

function TQueueEmailDataFactory.GenerateInsert: TQueueEmailShowDTO;
begin
  const LInput: SH<TQueueEmailInputDTO> = GenerateInput;
  const StoreAndShowResult = FPersistence.StoreAndShow(LInput);
  if not StoreAndShowResult.Match then
    raise Exception.Create(StoreAndShowResult.Left);

  Result := StoreAndShowResult.Right;
end;

class function TQueueEmailDataFactory.Make(APersistenceUseCase: IQueueEmailPersistenceUseCase): IQueueEmailDataFactory;
begin
  Result := Self.Create(APersistenceUseCase);
end;

end.
