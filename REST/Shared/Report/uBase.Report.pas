unit uBase.Report;

interface

uses
  {ActiveX,} Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RLReport, Vcl.Imaging.jpeg,
  Vcl.Imaging.pngimage, RLFilters, RLPDFFilter;

type
  TBaseReport = class(TForm)
    RLReport1: TRLReport;
    bndHeader: TRLBand;
    memCompanyMoreInfo: TRLMemo;
    pnlLogo: TRLPanel;
    imgLogo: TRLImage;
    memCompanyAliasName: TRLMemo;
    bndFooter: TRLBand;
    RLSystemInfo1PageNumber: TRLSystemInfo;
    pnlDivisor2: TRLPanel;
    bndTopHeader: TRLBand;
    pnlDivisor: TRLPanel;
    bndSpacer1: TRLBand;
    RLSystemInfo4PageCount: TRLSystemInfo;
    lblSoftwareHouse: TRLLabel;
    lblCompanyEin: TRLLabel;
    RLSystemInfo1FullDate: TRLSystemInfo;
    memCompanyContacts: TRLMemo;
    RLPDFFilter1: TRLPDFFilter;
    procedure FormCreate(Sender: TObject); virtual;
  public
    FPath: String;
    procedure LoadCompany;
  end;

var
  BaseReport: TBaseReport;

implementation

uses
  uHlp,
  uRepository.Factory,
  uCompany;

{$R *.dfm}

procedure TBaseReport.FormCreate(Sender: TObject);
begin
  {CoInitialize(nil);}
  RLPDFFilter1.ShowProgress := False;
  RLReport1.PrintDialog     := False;
  RLReport1.ShowProgress    := False;

  // Criar diretório se não existir
  FPath := ExtractFilePath(ParamStr(0)) + 'Temp\';
  if not DirectoryExists(FPath) then ForceDirectories(FPath);
end;

procedure TBaseReport.LoadCompany;
begin
  const LCompany = TRepositoryFactory.Make.Company.Show(1);
  if not Assigned(LCompany) then
    Exit;

  // Fantasia, CNPJ e Razão
  memCompanyAliasName.Lines.Text := lCompany.alias_name.ToUpper;
  lblCompanyEin.Caption          := ValidateCpfCnpj(lCompany.legal_entity_number);
  memCompanyMoreInfo.Lines.Add(lCompany.name.ToUpper);

  // Endereço
  memCompanyMoreInfo.Lines.Clear;
  var LInfo := EmptyStr;
  if not lCompany.address.Trim.IsEmpty        then LInfo := LInfo + lCompany.address + ', ';
  if not lCompany.address_number.Trim.IsEmpty then LInfo := LInfo + lCompany.address_number + ', ';
  if not lCompany.complement.Trim.IsEmpty     then LInfo := LInfo + lCompany.complement + ' | ';
  if not lCompany.district.Trim.IsEmpty       then LInfo := LInfo + lCompany.district;
  if not LInfo.Trim.IsEmpty then
    memCompanyMoreInfo.Lines.Add(LInfo);

  LInfo := EmptyStr;
  if not lCompany.city.name.Trim.IsEmpty  then LInfo := LInfo + lCompany.city.name + ' - ';
  if not lCompany.city.state.Trim.IsEmpty then LInfo := LInfo + lCompany.city.state + ', Cep: ';
  if not lCompany.zipcode.Trim.IsEmpty    then LInfo := LInfo + FormatZipCode(lCompany.zipcode);
  if not LInfo.Trim.IsEmpty then
    memCompanyMoreInfo.Lines.Add(LInfo);

  // Contatos
  LInfo := EmptyStr;
  if not lCompany.phone_1.Trim.IsEmpty       then LInfo := LInfo + FormatPhone(lCompany.phone_1) + ' | ';
  if not lCompany.phone_2.Trim.IsEmpty       then LInfo := LInfo + FormatPhone(lCompany.phone_2) + ' | ';
  if not lCompany.company_email.Trim.IsEmpty then LInfo := LInfo + lCompany.company_email + ' | ';
  memCompanyContacts.Lines.Clear;
  if not LInfo.Trim.IsEmpty then
    memCompanyContacts.Lines.Add(LInfo);

  if Assigned(LCompany) then
    FreeAndNil(LCompany);
end;

end.
