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
    memTenantMoreInfo: TRLMemo;
    pnlLogo: TRLPanel;
    imgLogo: TRLImage;
    memTenantAliasName: TRLMemo;
    bndFooter: TRLBand;
    RLSystemInfo1PageNumber: TRLSystemInfo;
    pnlDivisor2: TRLPanel;
    bndTopHeader: TRLBand;
    pnlDivisor: TRLPanel;
    bndSpacer1: TRLBand;
    RLSystemInfo4PageCount: TRLSystemInfo;
    lblSoftwareHouse: TRLLabel;
    lblTenantEin: TRLLabel;
    RLSystemInfo1FullDate: TRLSystemInfo;
    memTenantContacts: TRLMemo;
    RLPDFFilter1: TRLPDFFilter;
    procedure FormCreate(Sender: TObject); virtual;
  public
    FPath: String;
    procedure LoadTenant;
  end;

var
  BaseReport: TBaseReport;

implementation

uses
  uHlp,
  uRepository.Factory,
  uTenant;

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

procedure TBaseReport.LoadTenant;
begin
  const LTenant = TRepositoryFactory.Make.Tenant.Show(1);
  if not Assigned(LTenant) then
    Exit;

  // Fantasia, CNPJ e Razão
  memTenantAliasName.Lines.Text := lTenant.alias_name.ToUpper;
  lblTenantEin.Caption          := ValidateCpfCnpj(lTenant.legal_entity_number);
  memTenantMoreInfo.Lines.Add(lTenant.name.ToUpper);

  // Endereço
  memTenantMoreInfo.Lines.Clear;
  var LInfo := EmptyStr;
  if not lTenant.address.Trim.IsEmpty        then LInfo := LInfo + lTenant.address + ', ';
  if not lTenant.address_number.Trim.IsEmpty then LInfo := LInfo + lTenant.address_number + ', ';
  if not lTenant.complement.Trim.IsEmpty     then LInfo := LInfo + lTenant.complement + ' | ';
  if not lTenant.district.Trim.IsEmpty       then LInfo := LInfo + lTenant.district;
  if not LInfo.Trim.IsEmpty then
    memTenantMoreInfo.Lines.Add(LInfo);

  LInfo := EmptyStr;
  if not lTenant.city.name.Trim.IsEmpty  then LInfo := LInfo + lTenant.city.name + ' - ';
  if not lTenant.city.state.Trim.IsEmpty then LInfo := LInfo + lTenant.city.state + ', Cep: ';
  if not lTenant.zipcode.Trim.IsEmpty    then LInfo := LInfo + FormatZipCode(lTenant.zipcode);
  if not LInfo.Trim.IsEmpty then
    memTenantMoreInfo.Lines.Add(LInfo);

  // Contatos
  LInfo := EmptyStr;
  if not lTenant.phone_1.Trim.IsEmpty       then LInfo := LInfo + FormatPhone(lTenant.phone_1) + ' | ';
  if not lTenant.phone_2.Trim.IsEmpty       then LInfo := LInfo + FormatPhone(lTenant.phone_2) + ' | ';
  if not lTenant.company_email.Trim.IsEmpty then LInfo := LInfo + lTenant.company_email + ' | ';
  memTenantContacts.Lines.Clear;
  if not LInfo.Trim.IsEmpty then
    memTenantContacts.Lines.Add(LInfo);

  if Assigned(LTenant) then
    FreeAndNil(LTenant);
end;

end.
