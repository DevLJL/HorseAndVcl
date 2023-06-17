unit uSale.SendPrintTicketToQueue;

interface

uses
  uSale.Repository.Interfaces,
  uRepository.Factory,
  uPosPrinter.Repository.Interfaces,
  System.Classes;

type
  ISaleSendTicketPrintToQueue = Interface
    ['{679DCF59-F7F8-4755-A785-D6013BDE7955}']
    function Execute(ASaleId, APosPrinterId: Int64; ACopies: SmallInt): ISaleSendTicketPrintToQueue;
  End;

  TSaleSendTicketPrintToQueue = class(TInterfacedObject, ISaleSendTicketPrintToQueue)
  private
    FSaleRepository: ISaleRepository;
    FPosPrinterRepository: IPosPrinterRepository;
    FContent: TStringList;
    FData: TDataForReportOutput;
    FSaleId: Int64;
    FPosPrinterId: Int64;
    FCols: SmallInt;
    FCopies: SmallInt;
    constructor Create(ARepositories: IRepositoryFactory);
    procedure FindSaleData;
    procedure SetColumnSize;
    procedure CreateTicketContent;
    procedure SetHeaderContent;
    procedure SetItems;
    procedure SetPayments;
    procedure SetFooter;
  public
    class function Make(ARepositories: IRepositoryFactory): ISaleSendTicketPrintToQueue;
    function Execute(ASaleId, APosPrinterId: Int64; ACopies: SmallInt): ISaleSendTicketPrintToQueue;
  end;

implementation

{ TSaleSendTicketPrintToQueue }

uses
  uTrans,
  System.SysUtils,
  uHlp,
  uPosPrinter,
  uSmartPointer,
  uCache;

class function TSaleSendTicketPrintToQueue.Make(ARepositories: IRepositoryFactory): ISaleSendTicketPrintToQueue;
begin
  Result := Self.Create(ARepositories);
end;

constructor TSaleSendTicketPrintToQueue.Create(ARepositories: IRepositoryFactory);
begin
  inherited Create;
  FSaleRepository       := ARepositories.Sale;
  FPosPrinterRepository := ARepositories.PosPrinter;
  FContent              := TStringList.Create;
end;

function TSaleSendTicketPrintToQueue.Execute(ASaleId, APosPrinterId: Int64; ACopies: SmallInt): ISaleSendTicketPrintToQueue;
begin
  Result        := Self;
  FSaleId       := ASaleId;
  FPosPrinterId := APosPrinterId;
  FCopies       := ACopies;

  FindSaleData;
  SetColumnSize;
  CreateTicketContent;

  // Adicionar em Fila (Cache) para impressão
  Cache.PushPosPrinterContent(FPosPrinterId, FContent, FCopies);
end;

procedure TSaleSendTicketPrintToQueue.FindSaleData;
begin
  FData := FSaleRepository.DataForReport(FSaleId);
  if FData.Sale.IsEmpty then
    raise Exception.Create(Trans.RecordNotFoundWithId(FSaleId.ToString));
end;

procedure TSaleSendTicketPrintToQueue.SetColumnSize;
begin
  const LPosPrinter: SH<TPosPrinter> = FPosPrinterRepository.Show(FPosPrinterId);
  if not Assigned(LPosPrinter.Value) then
    raise Exception.Create('Impressora PosPrinter não encontrada. '+Trans.RecordNotFoundWithId(FPosPrinterId.ToString));

  FCols := LPosPrinter.Value.columns;
end;

procedure TSaleSendTicketPrintToQueue.CreateTicketContent;
begin
  SetHeaderContent;
  SetItems;
  SetPayments;
  SetFooter;
end;

procedure TSaleSendTicketPrintToQueue.SetHeaderContent;
begin
  With FData.Sale do
  begin
    // Titulo
    FContent.Clear;
    FContent.Add(AlignTextMargin('Venda', FCols, sdCenter));
    FContent.Add(AlignTextMargin('Código: ' + StrZero(FieldByName('id').AsString,5), FCols, sdCenter));
    FContent.Add(' ');

    // Dados do Cliente
    const LPersonLegalEntityNumber = ValidateCpfCnpj(FieldByName('person_legal_entity_number').AsString);
    FContent.Add(FieldByName('person_name').AsString + ' "' + FieldByName('person_id').AsString + '"');
    if (LPersonLegalEntityNumber > '') or (FieldByName('person_state_registration').AsString > '') Then
      FContent.Add(LPersonLegalEntityNumber + '     ' + FieldByName('person_state_registration').AsString);
  end;
end;

procedure TSaleSendTicketPrintToQueue.SetItems;
begin
  // Produtos
  FContent.Add(Repl('-', FCols));
  FContent.Add('MERCADORIA(S) / SERVICO(S)');
  FContent.Add(Repl('-', FCols));
  FContent.Add('Descricao' + Repl(' ', FCols-34) + 'Qde       Preço     Total');
  FContent.Add(Repl('-', FCols));
  With FData.SaleItems do
  begin
    First;
    while not Eof do
    Begin
      // Desconto
      var LDiscountUnit := '';
      if (FieldByName('unit_discount').AsCurrency > 0) then
        LDiscountUnit := ' - ' + FormatCurr('##,###,##0.00', FieldByName('unit_discount').AsCurrency);

      // Descricao
      FContent.Add(FieldByName('product_name').AsString + ' [' + FieldByName('product_sku_code').AsString + ']');

      // Observação
      if not FieldByName('note').AsString.Trim.IsEmpty then
        FContent.Add('  ' + FieldByName('note').AsString);

      // Qde, Unid, Preco, Desconto Total
      FContent.Add(
        AlignTextMargin(
          FormatCurr('##,###,##0.00', FieldByName('quantity').AsCurrency) + '  ' +
          FieldByName('product_unit_name').AsString + ' X ' +
          FormatCurr('##,###,##0.00', FieldByName('price').AsCurrency) + LDiscountUnit + ' = ' +
          FormatCurr('##,###,##0.00', FieldByName('total').AsCurrency), FCols, sdRight
        )
      );

      // Próximo
      Next;
    End;
  end;
  FContent.Add(Repl('-', FCols));

  With FData.Sale do
  begin
    // Totalizadores
    if (FieldByName('sum_sale_item_total').AsCurrency <> FieldByName('total').AsCurrency) Then
      FContent.Add(AlignTextMargin(' Subtotal: ' + FormatCurr('#,##0.00', FieldByName('sum_sale_item_total').AsCurrency),FCols,sdRight));

     if (FieldByName('discount').AsCurrency > 0) then
      FContent.Add(AlignTextMargin(' Desconto: ' + FormatCurr('#,##0.00', FieldByName('discount').AsCurrency),FCols,sdRight));

    if (FieldByName('increase').AsCurrency > 0) then
      FContent.Add(AlignTextMargin('Acrescimo: ' + FormatCurr('#,##0.00', FieldByName('increase').AsCurrency),FCols,sdRight));

    FContent.Add(AlignTextMargin('     TOTAL: R$ ' + SpaceStr(FormatCurr('#,##0.00', FieldByName('total').AsCurrency), 14, sdLeft), FCols, sdRight));
  end;
end;

procedure TSaleSendTicketPrintToQueue.SetPayments;
begin
  With FData.SalePayments do
  begin
    // Forma de pagamento
    if (RecordCount > 0) then
    Begin
      FContent.Add(Repl('-', FCols));
      FContent.Add('DETALHAMENTO DA FATURA');
      FContent.Add(Repl('-', FCols));
      First;
      var LCont := 0;
      while not Eof do
      Begin
        Inc(LCont);
        FContent.Add(
          StrZero(LCont.ToString,2) + ' ' +
          FieldByName('due_date').AsString + ' ' +
          FormatCurr('#,##0.00', FieldByName('amount').AsCurrency) + ' - ' +
          FieldByName('payment_name').AsString
        );

        // Próximo
        Next;
      End;
      FContent.Add('');
    End;
  end;
end;

procedure TSaleSendTicketPrintToQueue.SetFooter;
begin
  With FData.Sale do
  begin
    // Observação
    if not FieldByName('note').AsString.Trim.IsEmpty then
    Begin
      FContent.Add('- OBSERVACAO');
      FContent.Add(FieldByName('note').AsString);
      FContent.Add(' ');
    End;

    // Informações adicionais
    FContent.Add('Vendedor/Responsavel:   ' + Copy(FieldByName('seller_name').AsString,1,10) + '. "' + FieldByName('seller_id').AsString + '"');
    FContent.Add('');
  end;

  // Assinatura
  FContent.Add('');
  FContent.Add('');
  FContent.Add(Repl('_', FCols));
  FContent.Add(AlignTextMargin('Assinatura', FCols, sdRight));
end;

end.
