unit uSale.Report;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBase.Report, RLReport, Data.DB,
  RLFilters, RLPDFFilter, Vcl.Imaging.pngimage, uZLMemTable.Interfaces,
  uOutPutFileStream, uSale.Repository.Interfaces;

type
  TSaleReport = class(TBaseReport)
    dtsSale: TDataSource;
    dtsSaleItems: TDataSource;
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    RLPanel1: TRLPanel;
    RLPanel2: TRLPanel;
    RLPanel3: TRLPanel;
    lblData: TRLLabel;
    memPersonInfo: TRLMemo;
    RLLabel5: TRLLabel;
    memPersonContact: TRLMemo;
    lblReportTitle: TRLLabel;
    RLLabel4: TRLLabel;
    RLBand3: TRLBand;
    RLPanel4: TRLPanel;
    RLLabel9: TRLLabel;
    RLBand4: TRLBand;
    RLBand5: TRLBand;
    RLPanel5: TRLPanel;
    RLLabel11: TRLLabel;
    RLLabel12: TRLLabel;
    RLLabel13: TRLLabel;
    RLLabel15: TRLLabel;
    RLLabel16: TRLLabel;
    RLLabel17: TRLLabel;
    RLBand6: TRLBand;
    RLDBText1: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText6: TRLDBText;
    RLDBText8: TRLDBText;
    RLDBText9: TRLDBText;
    RLDBText10: TRLDBText;
    RLDBText11: TRLDBText;
    RLDBText12: TRLDBText;
    RLDBMemo1: TRLDBMemo;
    RLBand7: TRLBand;
    RLBand8: TRLBand;
    bndProductNote: TRLBand;
    RLDBMemo4: TRLDBMemo;
    RLPanel6: TRLPanel;
    RLLabel14: TRLLabel;
    RLPanel7: TRLPanel;
    RLLabel1: TRLLabel;
    RLDBText7: TRLDBText;
    RLLabel2: TRLLabel;
    RLDBText4: TRLDBText;
    RLLabel3: TRLLabel;
    RLDBText5: TRLDBText;
    RLLabel6: TRLLabel;
    RLDBText13: TRLDBText;
    RLPanel8: TRLPanel;
    bndPaymentTermNote: TRLBand;
    RLPanel15: TRLPanel;
    RLLabel8: TRLLabel;
    memPaymentTerm: TRLMemo;
    memPaymentTermTitle: TRLMemo;
    bndNote: TRLBand;
    RLPanel16: TRLPanel;
    RLLabel10: TRLLabel;
    RLDBMemo3: TRLDBMemo;
    RLBand11: TRLBand;
    dtsSalePayments: TDataSource;
    procedure RLBand6AfterPrint(Sender: TObject);
  private
    { Private declarations }
    FSale: IZLMemTable;
    FSaleItems: IZLMemTable;
    FSalePayments: IZLMemTable;
  public
    { Public declarations }
    class function Execute(AData: TDataForReportOutput): IOutPutFileStream;
    function Prepare(AData: TDataForReportOutput): TSaleReport;
  end;

var
  SaleReport: TSaleReport;

implementation

uses
  uHlp,
  RLPrinters,
  System.IOUtils,
  uSmartPointer;

{$R *.dfm}

class function TSaleReport.Execute(AData: TDataForReportOutput): IOutPutFileStream;
begin
  // Preparar Relatório
  const LView: SH<TSaleReport> = TSaleReport.Create(nil);
  LView.Value.LoadCompany;
  LView.Value.Prepare(AData);

  // Gerar PDF
  const LTitle    = Format('Venda_%s_%s', [FormatDateTime('dd_mm_yyyy', now), NextUUID]);
  const LPathFile = LView.Value.FPath + LTitle + '.pdf';
  LView.Value.RLReport1.SaveToFile(LPathFile);

  // Retornar Stream
  Result := TOutPutFileStream.Make(LPathFile);
end;

function TSaleReport.Prepare(AData: TDataForReportOutput): TSaleReport;
begin
  FSale         := AData.Sale;
  FSaleItems    := AData.SaleItems;
  FSalePayments := AData.SalePayments;

  // Formatar e Ligar DataSets
  FormatDataSet(FSale.DataSet);
  FormatDataSet(FSaleItems.DataSet);
  FormatDataSet(FSalePayments.DataSet);
  dtsSale.DataSet         := FSale.DataSet;
  dtsSaleItems.DataSet    := FSaleItems.DataSet;
  dtsSalePayments.DataSet := FSalePayments.DataSet;

  With dtsSale.DataSet do
  begin
    // Título do Relatório
    lblReportTitle.Caption := 'VENDA Nº ' + strZero(FieldByName('id').AsString,5);

    // Dados do Header
    var LDocs := 'Nenhum documento informado.';
    if not FieldByName('person_legal_entity_number').AsString.Trim.IsEmpty then
    begin
      case IsJuridicaDoc(FieldByName('person_legal_entity_number').AsString) of
        True:  LDocs := 'CNPJ: ' + validateCpfCnpj(FieldByName('person_legal_entity_number').AsString) + ' IE: ' + FieldByName('person_state_registration').AsString;
        False: LDocs := 'CPF: '  + validateCpfCnpj(FieldByName('person_legal_entity_number').AsString) + ' RG: ' + FieldByName('person_state_registration').AsString;
      end;
    end;

    // Fantasia e Endereço do Cliente
    memPersonInfo.Lines.Clear;
    memPersonInfo.Lines.Add(LDocs);
    memPersonInfo.Lines.Add('');
    memPersonInfo.Lines.Add(FieldByName('person_alias_name').AsString.Trim);
    memPersonInfo.Lines.Add(
      FieldByName('person_address').AsString + ' | ' +
      FieldByName('person_address_number').AsString + ' | ' +
      FieldByName('person_complement').AsString + ' | ' +
      FieldByName('person_district').AsString
    );
    var LCityInfo := FieldByName('person_city_name').AsString + ' | ' + FieldByName('person_city_state').AsString;
    if not FieldByName('person_zipcode').AsString.Trim.IsEmpty then
      LCityInfo := LCityInfo + ' | Cep: ' + formatZipCode(FieldByName('person_zipcode').AsString);
    memPersonInfo.Lines.Add(LCityInfo);

    // Contatos do Cliente
    memPersonContact.Lines.Clear;
    if not FieldByName('person_phone_1').AsString.Trim.IsEmpty then
      memPersonContact.Lines.Add(formatPhone(FieldByName('person_phone_1').AsString));

    if not FieldByName('person_phone_2').AsString.Trim.IsEmpty then
      memPersonContact.Lines.Add(formatPhone(FieldByName('person_phone_2').AsString));

    if not FieldByName('person_phone_3').AsString.Trim.IsEmpty then
      memPersonContact.Lines.Add(formatPhone(FieldByName('person_phone_3').AsString));

    if (memPersonContact.Lines.Count > 0) then
      memPersonContact.Lines.Add('');

    if not FieldByName('person_company_email').AsString.Trim.IsEmpty then
      memPersonContact.Lines.Add(FieldByName('person_company_email').AsString);

    if not FieldByName('person_financial_email').AsString.Trim.IsEmpty then
      memPersonContact.Lines.Add(FieldByName('person_financial_email').AsString);

    // Exibir Informações
    bndNote.Visible := not FieldByName('note').AsString.Trim.IsEmpty;

    // Limpar pontos se não existirem dados
    for var lI := 0 to Pred(memPersonInfo.Lines.Count) do
    begin
      if (removeDots(memPersonInfo.Lines[lI]) = EmptyStr) then
        memPersonInfo.Lines[lI] := EmptyStr;
    end;
  end;

  // Condição de Pagamento
  const LSpace = StringOfChar(' ', 5);
  memPaymentTerm.Lines.Clear;
  memPaymentTermTitle.Lines.Clear;
  memPaymentTermTitle.Lines.Add(
    AlignTextMargin('Pagamento',  22, sdLeft)  +LSpace+
    AlignTextMargin('Valor',      12, sdRight) +LSpace+
    AlignTextMargin('Vencimento', 10, sdLeft)  +LSpace
  );
  With dtsSalePayments.DataSet do
  begin
    First;
    while not Eof do
    begin
      var LBankAccountName := EmptyStr;
      const LPaymentName    = AlignTextMargin(FieldByName('payment_name').AsString, 22, sdLeft)+LSpace;
      const LAmount         = AlignTextMargin(FormatFloat('#,##0.00', FieldByName('amount').AsCurrency), 12, sdRight)+LSpace;
      const LExpirationDate = AlignTextMargin(FieldByName('due_date').AsString, 10, sdLeft)+LSpace;
      case (FieldByName('bank_account_id').AsInteger > 1) of
        True:  LBankAccountName := FieldByName('bank_account_name').AsString;
        False: LBankAccountName := '';
      end;

      memPaymentTerm.Lines.Add(
        LPaymentName+
        LAmount+
        LExpirationDate+
        LBankAccountName
      );
      if not FieldByName('note').AsString.Trim.IsEmpty then
      begin
        memPaymentTerm.Lines.Add('  ' + FieldByName('note').AsString);
        memPaymentTerm.Lines.Add('');
      end;

      Next;
    end;
  end;
  RLReport1.Prepare;
end;

procedure TSaleReport.RLBand6AfterPrint(Sender: TObject);
begin
  inherited;

  bndProductNote.Visible := not dtsSaleItems.DataSet.FieldByName('note').AsString.Trim.IsEmpty;
end;

end.
