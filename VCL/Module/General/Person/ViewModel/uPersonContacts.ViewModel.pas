unit uPersonContacts.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uPerson.ViewModel.Interfaces;

type
  TPersonContactsViewModel = class(TInterfacedObject, IPersonContactsViewModel)
  private
    [weak]
    FOwner: IPersonViewModel;
    FPersonContacts: IZLMemTable;
    constructor Create(AOwner: IPersonViewModel);
  public
    class function Make(AOwner: IPersonViewModel): IPersonContactsViewModel;
    function  PersonContacts: IZLMemTable;
    function  SetEvents: IPersonContactsViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure LegalEntityNumberGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure PhoneGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TPersonViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils;

constructor TPersonContactsViewModel.Create(AOwner: IPersonViewModel);
begin
  inherited Create;
  FOwner := AOwner;

  FPersonContacts := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('person_id', ftLargeint)
    .AddField('name', ftString, 100)
    .AddField('legal_entity_number', ftString, 20)
    .AddField('type', ftString, 100)
    .AddField('note', ftString, 5000)
    .AddField('phone', ftString, 40)
    .AddField('email', ftString, 255)
    .CreateDataSet
  .Active(True);

  // Formata��o padr�o e configurar eventos do DataSet
  FormatDataSet(FPersonContacts.DataSet);
  SetEvents;
end;

function TPersonContactsViewModel.SetEvents: IPersonContactsViewModel;
begin
  Result := Self;

  FPersonContacts.DataSet.AfterInsert                          := AfterInsert;
  FPersonContacts.FieldByName('legal_entity_number').OnGetText := LegalEntityNumberGetText;
  FPersonContacts.FieldByName('phone').OnGetText               := PhoneGetText;
end;

procedure TPersonContactsViewModel.LegalEntityNumberGetText(Sender: TField; var Text: string; DisplayText: Boolean);
var
  lFormated: String;
begin
  lFormated := ValidateCpfCnpj(Sender.AsString);
  case lFormated.Trim.IsEmpty of
    True:  Text := Sender.AsString;
    False: Text := lFormated;
  end;
end;

procedure TPersonContactsViewModel.PhoneGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := FormatPhone(Sender.AsString);
end;


function TPersonContactsViewModel.PersonContacts: IZLMemTable;
begin
  Result := FPersonContacts;
end;

procedure TPersonContactsViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
  DataSet.FieldByName('type').AsString := 'Celular';
end;

class function TPersonContactsViewModel.Make(AOwner: IPersonViewModel): IPersonContactsViewModel;
begin
  Result := Self.Create(AOwner);
end;

end.

