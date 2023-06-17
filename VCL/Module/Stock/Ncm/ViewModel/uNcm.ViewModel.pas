unit uNcm.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uNcm.ViewModel.Interfaces,
  uNcm.Show.DTO,
  uNcm.Input.DTO;

type
  TNcmViewModel = class(TInterfacedObject, INcmViewModel)
  private
    FNcm: IZLMemTable;
    constructor Create;
  public
    class function Make: INcmViewModel;
    function  FromShowDTO(AInput: TNcmShowDTO): INcmViewModel;
    function  ToInputDTO: TNcmInputDTO;
    function  EmptyDataSets: INcmViewModel;

    function  Ncm: IZLMemTable;

    function  SetEvents: INcmViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TNcmViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject;

constructor TNcmViewModel.Create;
begin
  inherited Create;

  FNcm := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('name', ftString, 255)
    .AddField('code', ftString, 8)
    .AddField('national_rate', ftFloat)
    .AddField('imported_rate', ftFloat)
    .AddField('state_rate', ftFloat)
    .AddField('municipal_rate', ftFloat)
    .AddField('cest', ftString, 45)
    .AddField('additional_information', ftString, 5000)
    .AddField('start_of_validity', ftDate)
    .AddField('end_of_validity', ftDate)
    .AddField('created_at', ftDateTime)
    .AddField('updated_at', ftDateTime)
    .AddField('created_by_acl_user_id', ftLargeint)
    .AddField('updated_by_acl_user_id', ftLargeint)
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formatação padrão e configurar eventos do DataSet
  FormatDataSet(FNcm.DataSet);
  SetEvents;
end;

procedure TNcmViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TNcmViewModel.SetEvents: INcmViewModel;
begin
  Result := Self;
  FNcm.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FNcm.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TNcmViewModel.EmptyDataSets: INcmViewModel;
begin
  Result := Self;
  FNcm.EmptyDataSet;
end;

function TNcmViewModel.Ncm: IZLMemTable;
begin
  Result := FNcm;
end;

procedure TNcmViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TNcmViewModel.FromShowDTO(AInput: TNcmShowDTO): INcmViewModel;
begin
  Result := Self;

  FNcm.EmptyDataSet.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;
end;

class function TNcmViewModel.Make: INcmViewModel;
begin
  Result := TNcmViewModel.Create;
end;

function TNcmViewModel.ToInputDTO: TNcmInputDTO;
begin
  FNcm.UnsignEvents;
  Try
    Result := TNcmInputDTO.FromJSON(Ncm.ToJson);
  Finally
    SetEvents;
  End;
end;

end.


