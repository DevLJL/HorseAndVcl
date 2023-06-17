unit uSale.SendPdfReportByEmail.UseCase;

interface

uses
  uSale.Repository.Interfaces,
  uOutPutFileStream,
  uQueueEmail.Repository.Interfaces;

type
  ISaleSendPdfReportByEmailUseCase = Interface
    ['{B5D65E59-90DC-428C-A10C-11BE3B021751}']
    function Execute(AId: Int64): ISaleSendPdfReportByEmailUseCase;
  End;

  TSaleSendPdfReportByEmailUseCase = class(TInterfacedObject, ISaleSendPdfReportByEmailUseCase)
  private
    FRepository: ISaleRepository;
    FQueueEmailRepository: IQueueEmailRepository;
    constructor Create(ARepository: ISaleRepository; AQueueEmailRepository: IQueueEmailRepository);
  public
    class function Make(ARepository: ISaleRepository; AQueueEmailRepository: IQueueEmailRepository): ISaleSendPdfReportByEmailUseCase;
    function Execute(AId: Int64): ISaleSendPdfReportByEmailUseCase;
  end;

implementation

{ TSaleSendPdfReportByEmailUseCase }

uses
  uSale.Report,
  uQueueEmail,
  uSmartPointer,
  uHlp,
  uQueueEmailAttachment,
  uApplication.Exception,
  System.SysUtils,
  uQueueEmail.Types,
  uQueueEmailContact;

constructor TSaleSendPdfReportByEmailUseCase.Create(ARepository: ISaleRepository; AQueueEmailRepository: IQueueEmailRepository);
begin
  inherited Create;
  FRepository           := ARepository;
  FQueueEmailRepository := AQueueEmailRepository;
end;

function TSaleSendPdfReportByEmailUseCase.Execute(AId: Int64): ISaleSendPdfReportByEmailUseCase;
begin
  Result := Self;

  // Gerar Relatório
  const LData = FRepository.DataForReport(AId);
  const LReport = TSaleReport.Execute(LData);

  // Mapear dados para Entity
  const LEntity: SH<TQueueEmail> = TQueueEmail.Create;
  With LEntity.Value do
  begin
    uuid       := NextUUID;
    subject    := 'Pedido #' + LData.Sale.FieldByName('id').AsString + ' c/ chave: ' + NextUUID;
    &message   := 'Pedido de Venda';
    priority   := TQueueEmailPriority.Normal;
  end;

  // Destinatários
  LEntity.Value.queue_email_contacts.Add(TQueueEmailContact.Create);
  With LEntity.Value.queue_email_contacts.Last do
  begin
    email     := LData.Sale.FieldByName('person_company_email').AsString;
    name      := LData.Sale.FieldByName('person_name').AsString;
    &type     := TQueueEmailContactType.Recipient;
  end;

  // Anexo
  LEntity.Value.queue_email_attachments.Add(TQueueEmailAttachment.Create);
  With LEntity.Value.queue_email_attachments.Last do
  begin
    file_name := 'Pedido_'+LData.Sale.FieldByName('id').AsString+'.pdf';
    base64    := LReport.ToBase64;
  end;

  // Incluir Envio de Email para ser processado em Task
  const LErrors = LEntity.Value.Validate;
  if not LErrors.Trim.IsEmpty then
    raise EEntityValidationException.Create(LErrors);
  FQueueEmailRepository.Store(LEntity);
end;

class function TSaleSendPdfReportByEmailUseCase.Make(ARepository: ISaleRepository; AQueueEmailRepository: IQueueEmailRepository): ISaleSendPdfReportByEmailUseCase;
begin
  Result := Self.Create(ARepository, AQueueEmailRepository);
end;

end.
