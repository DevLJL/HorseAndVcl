unit uQueueEmail.Test;

interface

uses
  DUnitX.TestFramework,
  uQueueEmail.Persistence.UseCase.Interfaces,
  uQueueEmail.Persistence.UseCase,
  uQueueEmail.DataFactory;

type
  [TestFixture]
  TQueueEmailTest = class
  private
    FPersistence: IQueueEmailPersistenceUseCase;
    FDataFactory: IQueueEmailDataFactory;
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
    [Ignore]
    procedure should_send_email;

    [Test]
    procedure should_update_by_id;
  end;

implementation

uses
  uTestConnection,
  uRepository.Factory,
  uSmartPointer,
  uQueueEmail.Show.DTO,
  System.SysUtils,
  uQueueEmail.Filter.DTO,
  System.Classes,
  uHlp,
  uQueueEmail.SendPending.UseCase,
  uQueueEmail.Input.DTO,
  uFaker, uQueueEmail.Types,
  uQueueEmailContact.Input.DTO,
  uQueueEmailAttachment.Input.DTO;

{ TQueueEmailTest }

procedure TQueueEmailTest.Setup;
begin
  FPersistence := TQueueEmailPersistenceUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn).QueueEmail);
  FDataFactory := TQueueEmailDataFactory.Make(FPersistence);
end;

procedure TQueueEmailTest.should_update_by_id;
begin
  // Inserir registro para posteriormente atualizar
  const LStored = FDataFactory.GenerateInsert;

  // Gerar dados aleatórios
  const LInput = FDataFactory.GenerateInput;
  LInput.uuid := NextUUID;

  // Atualizar e localizar registro atualizado
  const LUpdatedId = FPersistence.Update(LStored.id, LInput);
  const LFound = FPersistence.Show(LUpdatedId);

  // Confirmar Valores
  Assert.IsTrue(Assigned(LFound));
  Assert.IsTrue(LStored.uuid <> LFound.uuid);

  // Limpar Dados
  FPersistence.Delete(LFound.id);
  LStored.Free;
  LInput.Free;
  LFound.Free;
end;

procedure TQueueEmailTest.should_find_by_id;
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

procedure TQueueEmailTest.should_delete_by_id;
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

procedure TQueueEmailTest.should_include;
begin
  // Inserir registro
  const LStored = FDataFactory.GenerateInsert;

  // Localizar registro inserido
  const LFound = FPersistence.Show(LStored.id);

  // Confirmar Valores
  Assert.IsTrue(Assigned(LFound));
  Assert.IsTrue(LFound.uuid = LStored.uuid);

  // Limpar Dados
  FPersistence.Delete(LFound.id);
  LStored.Free;
  LFound.Free;
end;

procedure TQueueEmailTest.should_list_records;
const
  EXPECTED_COUNT = 3;
  EXPECTED_FIELDS: TArray<String> = [
    'id',
    'uuid',
    'reply_to',
    'priority',
    'subject',
    'message',
    'sent',
    'sent_error',
    'current_retries',
    'created_at',
    'updated_at'
  ];

begin
  // Inserir registros
  var LPks := '';
  for var I := 1 to EXPECTED_COUNT do
  begin
    const LStored: SH<TQueueEmailShowDTO> = FDataFactory.GenerateInsert;
    LPks := LPks + LStored.Value.id.ToString + ', ';
  end;
  LPks := Copy(LPks, 1, Length(LPks)-2);

  // Listar registros
  const QueueEmailFilterDTO: SH<TQueueEmailFilterDTO> = TQueueEmailFilterDTO.Create;
  QueueEmailFilterDTO.Value.where_pk_in := LPks;
  const LIndexResult = FPersistence.Index(QueueEmailFilterDTO);

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

procedure TQueueEmailTest.should_send_email;
var
  LInput: TQueueEmailInputDTO;
  LFound: TQueueEmailShowDTO;
begin
  Try
    LInput := TQueueEmailInputDTO.Create;
    With LInput do
    begin
      uuid      := TFaker.GenerateUUID;
      priority  := TQueueEmailPriority.Normal;
      subject   := 'Assunto: Teste';
      &message  := 'Mensagem: Teste';
    end;

    // Destinatário
    LInput.queue_email_contacts.Add(TQueueEmailContactInputDTO.Create);
    With LInput.queue_email_contacts.Last do
    begin
      email := 'leonamjlima@outlook.com';
      name  := 'Leonam José de Lima';
      &type := TQueueEmailContactType.Recipient;
    end;

    // Anexo 1
    LInput.queue_email_attachments.Add(TQueueEmailAttachmentInputDTO.Create);
    With LInput.queue_email_attachments.Last do
    begin
      file_name := 'lego15x15.png';
      base64    := 'iVBORw0KGgoAAAANSUhEUgAAAA8AAAAPCAIAAAC0tAIdAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAA'+
                   'AAJcEhZcwAADsMAAA7DAcdvqGQAAAGLSURBVChTY3zCwMxANGCC0sQB8lQzMTCyg2hGLgZGbhiDA8QAuhTIZm'+
                   'Bk+A0kgO5m5GW4EvL/DBOXDdPX+3wiL38zyr99/UVY+O2/fxbf338RZrn1Q1Tq83PB9YwMQNUXnZmm9pfv3bv'+
                   'Xxkb/4cOHb9++zc5Kv3v37ocPH9LTow8e3PrmzZs5s2deimNkYuJnOGUk6uaTcu7cuerqjlevXgUGBuYXFHd3'+
                   'd69Zs0ZGRkNaWr2np0dNXeP1Vwamnzr/n3M5SUpKHjhwwMbGRkBAID09nZWV1cnJyczMzNTUdM6cOUDxWzcPS'+
                   'n5kZHok8N/QJOzx48eGhoYsLCz79+9/8ODB379/v379ChTU0tISFxcHart3bB7/NUYmQWGGO3fu/Pv378/vD9'+
                   'evXzc01L9+9divX7+UleW3rS85ePCgt7f3srmtEb8f/n/GwPiUl/lO8L/3XAzK7xnO/WOQkmRU/cSw9wuDkii'+
                   'DxjWGazL/3/Ewyl1nkDnB+P8HOATBoUoUoGnM/4UyiAAMDAC2GZ8jBGmexQAAAABJRU5ErkJggg==';
    end;

    // Anexo 2
    LInput.queue_email_attachments.Add(TQueueEmailAttachmentInputDTO.Create);
    With LInput.queue_email_attachments.Last do
    begin
      file_name := 'lego15x15_copy.png';
      base64    := 'iVBORw0KGgoAAAANSUhEUgAAAA8AAAAPCAIAAAC0tAIdAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAA'+
                   'AAJcEhZcwAADsMAAA7DAcdvqGQAAAGLSURBVChTY3zCwMxANGCC0sQB8lQzMTCyg2hGLgZGbhiDA8QAuhTIZm'+
                   'Bk+A0kgO5m5GW4EvL/DBOXDdPX+3wiL38zyr99/UVY+O2/fxbf338RZrn1Q1Tq83PB9YwMQNUXnZmm9pfv3bv'+
                   'Xxkb/4cOHb9++zc5Kv3v37ocPH9LTow8e3PrmzZs5s2deimNkYuJnOGUk6uaTcu7cuerqjlevXgUGBuYXFHd3'+
                   'd69Zs0ZGRkNaWr2np0dNXeP1Vwamnzr/n3M5SUpKHjhwwMbGRkBAID09nZWV1cnJyczMzNTUdM6cOUDxWzcPS'+
                   'n5kZHok8N/QJOzx48eGhoYsLCz79+9/8ODB379/v379ChTU0tISFxcHart3bB7/NUYmQWGGO3fu/Pv378/vD9'+
                   'evXzc01L9+9divX7+UleW3rS85ePCgt7f3srmtEb8f/n/GwPiUl/lO8L/3XAzK7xnO/WOQkmRU/cSw9wuDkii'+
                   'DxjWGazL/3/Ewyl1nkDnB+P8HOATBoUoUoGnM/4UyiAAMDAC2GZ8jBGmexQAAAABJRU5ErkJggg==';
    end;
    const LStoredId = FPersistence.Store(LInput);

    // Executar envio de e-mail
    const LUseCase = TQueueEmailSendPendingUseCase.Make(TRepositoryFactory.Make(TestConnection.Conn));
    LUseCase.Execute;

    LFound := FPersistence.Show(LStoredId);
    Assert.IsTrue(LFound.sent = TQueueEmailSent.Yes);
    Assert.IsTrue(LFound.queue_email_attachments.Count = 2);
  Finally
    if Assigned(LInput) then LInput.Free;
    if Assigned(LFound) then LFound.Free;
  End;
end;

initialization
  TDUnitX.RegisterTestFixture(TQueueEmailTest);
end.
