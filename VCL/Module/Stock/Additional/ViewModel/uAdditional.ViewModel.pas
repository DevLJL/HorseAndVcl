unit uAdditional.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uAdditional.ViewModel.Interfaces,
  uAdditional.Show.DTO,
  uAdditional.Input.DTO;

type
  TAdditionalViewModel = class(TInterfacedObject, IAdditionalViewModel)
  private
    FAdditional: IZLMemTable;
    FAdditionalProductsViewModel: IAdditionalProductsViewModel;
    constructor Create;
  public
    class function Make: IAdditionalViewModel;
    function  FromShowDTO(AInput: TAdditionalShowDTO): IAdditionalViewModel;
    function  ToInputDTO: TAdditionalInputDTO;
    function  EmptyDataSets: IAdditionalViewModel;

    function  Additional: IZLMemTable;
    function  AdditionalProducts: IZLMemTable;

    function  SetEvents: IAdditionalViewModel;
    procedure AfterInsert(DataSet: TDataSet);
    procedure DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  end;

implementation

{ TAdditionalViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils,
  Vcl.Forms,
  XSuperObject,
  uAdditionalProducts.ViewModel,
  uAdditionalProduct.Show.DTO,
  uAdditionalProduct.Input.DTO;

constructor TAdditionalViewModel.Create;
begin
  inherited Create;

  FAdditional := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('name', ftString, 100)
    .AddField('selection_type', ftSmallint)
    .AddField('price_calculation_type', ftSmallint)
    .AddField('created_at', ftDateTime)
    .AddField('updated_at', ftDateTime)
    .AddField('created_by_acl_user_id', ftLargeInt)
    .AddField('updated_by_acl_user_id', ftLargeInt)
    .AddField('created_by_acl_user_name', ftString, 100) {virtual}
    .AddField('updated_by_acl_user_name', ftString, 100) {virtual}
    .CreateDataSet
  .Active(True);

  // Formatação padrão e configurar eventos do DataSet
  FormatDataSet(FAdditional.DataSet);
  SetEvents;

  FAdditionalProductsViewModel := TAdditionalProductsViewModel.Make(Self);
end;

procedure TAdditionalViewModel.DateTimeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  case (Sender.AsDateTime <= 0) of
    True:  Text := EmptyStr;
    False: Text := Sender.AsString;
  end;
end;

function TAdditionalViewModel.SetEvents: IAdditionalViewModel;
begin
  Result := Self;
  FAdditional.DataSet.AfterInsert := AfterInsert;

  // Evitar Data Inválida
  for var LField in FAdditional.Fields do
  begin
    if (LField.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp]) then
      LField.OnGetText := DateTimeGetText;
  end;
end;

function TAdditionalViewModel.EmptyDataSets: IAdditionalViewModel;
begin
  Result := Self;
  FAdditional.EmptyDataSet;
  AdditionalProducts.EmptyDataSet;
end;

function TAdditionalViewModel.Additional: IZLMemTable;
begin
  Result := FAdditional;
end;

procedure TAdditionalViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

function TAdditionalViewModel.FromShowDTO(AInput: TAdditionalShowDTO): IAdditionalViewModel;
begin
  Result := Self;

  FAdditional.EmptyDataSet.UnsignEvents.FromJson(AInput.AsJSON);
  SetEvents;

  // AdditionalProducts
  AdditionalProducts.UnsignEvents;
  for var LAdditionalProduct in AInput.additional_products do
  begin
    MergeDataSet(LAdditionalProduct.AsJSON, AdditionalProducts.DataSet, true);
    Application.ProcessMessages;
  end;
  AdditionalProducts.First;
  FAdditionalProductsViewModel.SetEvents;
end;

class function TAdditionalViewModel.Make: IAdditionalViewModel;
begin
  Result := TAdditionalViewModel.Create;
end;

function TAdditionalViewModel.AdditionalProducts: IZLMemTable;
begin
  Result := FAdditionalProductsViewModel.AdditionalProducts;
end;

function TAdditionalViewModel.ToInputDTO: TAdditionalInputDTO;
begin
  Try
    FAdditional.UnsignEvents;
    AdditionalProducts.UnsignEvents;

    // Additional
    Result := TAdditionalInputDTO.FromJSON(Additional.ToJson);

    // AdditionalProducts
    const LAdditionalProducts = TMemTableFactory.Make.FromDataSet(AdditionalProducts.DataSet);
    LAdditionalProducts.First;
    while not LAdditionalProducts.Eof do
    begin
      Result.additional_products.Add(TAdditionalProductInputDTO.Create);
      With Result.additional_products.Last do
        FromJSON(LAdditionalProducts.ToJson);

      LAdditionalProducts.Next;
      Application.ProcessMessages;
    end;
  Finally
    SetEvents;
    FAdditionalProductsViewModel.SetEvents;
  End;
end;

end.


