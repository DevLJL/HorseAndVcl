unit uCompany.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uCompany.ViewModel.Interfaces,
  uCompany.Show.DTO,
  uCompany.Input.DTO;

type
  TCompanyViewModel = class(TInterfacedObject, ICompanyViewModel)
  private
    FCompany: IZLMemTable;
    constructor Create;
  public
    class function Make: ICompanyViewModel;
    function  FromShowDTO(AInput: TCompanyShowDTO): ICompanyViewModel;
    function  ToInputDTO: TCompanyInputDTO;
    function  EmptyDataSets: ICompanyViewModel;

    function  Company: IZLMemTable;

    function  SetEvents: ICompanyViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure CityIdSetText(Sender: TField; const Text: string);
    procedure LegalEntityNumberGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure PhoneGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TCompanyViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject,
  uCity.Show.DTO,
  uCity.Service;

constructor TCompanyViewModel.Create;
begin
  inherited Create;

  FCompany := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('name', ftString, 100)
    .AddField('alias_name', ftString, 255)
    .AddField('legal_entity_number', ftString, 20)
    .AddField('icms_taxpayer', ftSmallInt)
    .AddField('state_registration', ftString, 20)
    .AddField('municipal_registration', ftString, 20)
    .AddField('zipcode', ftString, 10)
    .AddField('address', ftString, 255)
    .AddField('address_number', ftString, 15)
    .AddField('complement', ftString, 255)
    .AddField('district', ftString, 255)
    .AddField('city_id', ftLargeInt)
    .AddField('reference_point', ftString, 255)
    .AddField('phone_1', ftString, 14)
    .AddField('phone_2', ftString, 14)
    .AddField('phone_3', ftString, 14)
    .AddField('company_email', ftString, 255)
    .AddField('financial_email', ftString, 255)
    .AddField('internet_page', ftString, 255)
    .AddField('note', ftString, 5000)
    .AddField('bank_note', ftString, 5000)
    .AddField('commercial_note', ftString, 5000)
    .AddField('send_email_app_default', ftSmallint)
    .AddField('send_email_email', ftString, 255)
    .AddField('send_email_identification', ftString, 255)
    .AddField('send_email_user', ftString, 255)
    .AddField('send_email_password', ftString, 100)
    .AddField('send_email_smtp', ftString, 100)
    .AddField('send_email_port', ftString, 10)
    .AddField('send_email_ssl', ftSmallint)
    .AddField('send_email_tls', ftSmallint)
    .AddField('send_email_email_accountant', ftString, 255)
    .AddField('send_email_footer_message', ftString, 5000)
    .AddField('send_email_header_message', ftString, 5000)
    .AddField('city_name', ftString, 100) {virtual}
    .AddField('city_state', ftString, 100) {virtual}
    .AddField('city_ibge_code', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formata��o padr�o e configurar eventos do DataSet
  FormatDataSet(FCompany.DataSet);
  SetEvents;
end;

procedure TCompanyViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TCompanyViewModel.SetEvents: ICompanyViewModel;
begin
  Result := Self;

  FCompany.DataSet.AfterInsert                          := AfterInsert;
  FCompany.FieldByName('city_id').OnSetText             := CityIdSetText;
  FCompany.FieldByName('legal_entity_number').OnGetText := LegalEntityNumberGetText;
  FCompany.FieldByName('phone_1').OnGetText             := PhoneGetText;
  FCompany.FieldByName('phone_2').OnGetText             := PhoneGetText;
  FCompany.FieldByName('phone_3').OnGetText             := PhoneGetText;

  // Evitar Data Inválida
  for var LField in FCompany.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

procedure TCompanyViewModel.CityIdSetText(Sender: TField; const Text: string);
begin
  Try
    LockControl;

    const LKeepGoing = Sender.DataSet.Active and (Sender.DataSet.State in [dsInsert, dsEdit]);
    if not LKeepGoing then
      Exit;

    Sender.AsLargeInt := StrInt64(Text);
    const LCityShowDTO: SH<TCityShowDTO> = TCityService.Make.Show(Sender.AsLargeInt);
    if not Assigned(lCityShowDTO.Value) then
    begin
      Sender.DataSet.FieldByName('city_id').Clear;
      Sender.DataSet.FieldByName('city_name').Clear;
      Sender.DataSet.FieldByName('city_state').Clear;
      Sender.DataSet.FieldByName('city_ibge_code').Clear;
      Exit;
    end;

    // Carregar com dados encontrados
    With lCityShowDTO.Value do
    begin
      Sender.DataSet.FieldByName('city_id').AsLargeInt      := id;
      Sender.DataSet.FieldByName('city_name').AsString      := name;
      Sender.DataSet.FieldByName('city_state').AsString     := state;
      Sender.DataSet.FieldByName('city_ibge_code').AsString := ibge_code;
    end;
  Finally
    UnLockControl;
  End;
end;

procedure TCompanyViewModel.LegalEntityNumberGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  const LFormated = ValidateCpfCnpj(Sender.AsString);
  case lFormated.Trim.IsEmpty of
    True:  Text := Sender.AsString;
    False: Text := lFormated;
  end;
end;

procedure TCompanyViewModel.PhoneGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := FormatPhone(Sender.AsString);
end;

function TCompanyViewModel.EmptyDataSets: ICompanyViewModel;
begin
  Result := Self;

  FCompany.EmptyDataSet;
end;

function TCompanyViewModel.Company: IZLMemTable;
begin
  Result := FCompany;
end;

procedure TCompanyViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TCompanyViewModel.FromShowDTO(AInput: TCompanyShowDTO): ICompanyViewModel;
begin
  Result := Self;

  // Company
  FCompany.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TCompanyViewModel.Make: ICompanyViewModel;
begin
  Result := Self.Create;
end;

function TCompanyViewModel.ToInputDTO: TCompanyInputDTO;
begin
  Try
    FCompany.UnsignEvents;

    // Company
    Result := TCompanyInputDTO.FromJSON(Company.ToJson);
  Finally
    SetEvents;
  End;
end;

end.


