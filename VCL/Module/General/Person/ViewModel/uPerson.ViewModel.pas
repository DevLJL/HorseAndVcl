unit uPerson.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uPerson.ViewModel.Interfaces,
  uPerson.Show.DTO,
  uPerson.Input.DTO;

type
  TPersonViewModel = class(TInterfacedObject, IPersonViewModel)
  private
    FPerson: IZLMemTable;
    FPersonContactsViewModel: IPersonContactsViewModel;
    constructor Create;
  public
    class function Make: IPersonViewModel;
    function  FromShowDTO(AInput: TPersonShowDTO): IPersonViewModel;
    function  ToInputDTO: TPersonInputDTO;
    function  EmptyDataSets: IPersonViewModel;

    function  Person: IZLMemTable;
    function  PersonContacts: IZLMemTable;

    function  SetEvents: IPersonViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure CityIdSetText(Sender: TField; const Text: string);
    procedure LegalEntityNumberGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure PhoneGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TPersonViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject,
  uPersonContacts.ViewModel,
  uPersonContact.Show.DTO,
  uPersonContact.Input.DTO,
  uCity.Show.DTO,
  uCity.Service;

constructor TPersonViewModel.Create;
begin
  inherited Create;

  FPerson := TMemTableFactory.Make
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
    .AddField('flg_customer', ftSmallInt)
    .AddField('flg_seller', ftSmallInt)
    .AddField('flg_supplier', ftSmallInt)
    .AddField('flg_carrier', ftSmallInt)
    .AddField('flg_technician', ftSmallInt)
    .AddField('flg_employee', ftSmallInt)
    .AddField('flg_other', ftSmallInt)
    .AddField('flg_final_customer', ftSmallInt)
    .AddField('created_at', ftDateTime)
    .AddField('updated_at', ftDateTime)
    .AddField('created_by_acl_user_id', ftLargeint)
    .AddField('updated_by_acl_user_id', ftLargeint)
    .AddField('city_name', ftString, 100) {virtual}
    .AddField('city_state', ftString, 100) {virtual}
    .AddField('city_ibge_code', ftString, 100) {virtual}
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formata��o padr�o e configurar eventos do DataSet
  FormatDataSet(FPerson.DataSet);
  SetEvents;

  FPersonContactsViewModel := TPersonContactsViewModel.Make(Self);
end;

procedure TPersonViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TPersonViewModel.SetEvents: IPersonViewModel;
begin
  Result := Self;

  FPerson.DataSet.AfterInsert                          := AfterInsert;
  FPerson.FieldByName('city_id').OnSetText             := CityIdSetText;
  FPerson.FieldByName('legal_entity_number').OnGetText := LegalEntityNumberGetText;
  FPerson.FieldByName('phone_1').OnGetText             := PhoneGetText;
  FPerson.FieldByName('phone_2').OnGetText             := PhoneGetText;
  FPerson.FieldByName('phone_3').OnGetText             := PhoneGetText;

  // Evitar Data Inválida
  for var LField in FPerson.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

procedure TPersonViewModel.CityIdSetText(Sender: TField; const Text: string);
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

procedure TPersonViewModel.LegalEntityNumberGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  const LFormated = ValidateCpfCnpj(Sender.AsString);
  case lFormated.Trim.IsEmpty of
    True:  Text := Sender.AsString;
    False: Text := lFormated;
  end;
end;

procedure TPersonViewModel.PhoneGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := FormatPhone(Sender.AsString);
end;

function TPersonViewModel.EmptyDataSets: IPersonViewModel;
begin
  Result := Self;

  FPerson.EmptyDataSet;
  PersonContacts.EmptyDataSet;
end;

function TPersonViewModel.Person: IZLMemTable;
begin
  Result := FPerson;
end;

function TPersonViewModel.PersonContacts: IZLMemTable;
begin
  Result := FPersonContactsViewModel.PersonContacts;
end;

procedure TPersonViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
  DataSet.FieldByName('flg_customer').AsInteger       := 1;
  DataSet.FieldByName('flg_final_customer').AsInteger := 1;
end;

function TPersonViewModel.FromShowDTO(AInput: TPersonShowDTO): IPersonViewModel;
begin
  Result := Self;

  // Person
  FPerson.EmptyDataSet.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;

  // PersonContacts
  PersonContacts.UnsignEvents;
  for var LPersonContact in AInput.person_contacts do
  begin
    MergeDataSet(LPersonContact.AsJSON, PersonContacts.DataSet, true);
    Application.ProcessMessages;
  end;
  PersonContacts.First;
  FPersonContactsViewModel.SetEvents;
end;

class function TPersonViewModel.Make: IPersonViewModel;
begin
  Result := Self.Create;
end;

function TPersonViewModel.ToInputDTO: TPersonInputDTO;
begin
  Try
    FPerson.UnsignEvents;
    PersonContacts.UnsignEvents;

    // Person
    Result := TPersonInputDTO.FromJSON(Person.ToJson);

    // PersonContacts
    const LPersonContacts = TMemTableFactory.Make.FromDataSet(PersonContacts.DataSet);
    LPersonContacts.First;
    while not LPersonContacts.Eof do
    begin
      Result.person_contacts.Add(TPersonContactInputDTO.Create);
      With Result.person_contacts.Last do
        FromJSON(LPersonContacts.ToJson);

      LPersonContacts.Next;
      Application.ProcessMessages;
    end;
  Finally
    SetEvents;
    FPersonContactsViewModel.SetEvents;
  End;
end;

end.


