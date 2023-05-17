unit uPaymentTerms.ViewModel;

interface

uses
  uZLMemTable.Interfaces,
  Data.DB,
  uPayment.ViewModel.Interfaces;

type
  TPaymentTermsViewModel = class(TInterfacedObject, IPaymentTermsViewModel)
  private
    [weak]
    FOwner: IPaymentViewModel;
    FPaymentTerms: IZLMemTable;
    constructor Create(AOwner: IPaymentViewModel);
  public
    class function Make(AOwner: IPaymentViewModel): IPaymentTermsViewModel;
    function  PaymentTerms: IZLMemTable;
    function  SetEvents: IPaymentTermsViewModel;
    procedure AfterInsert(DataSet: TDataSet);
  end;

implementation

{ TPaymentViewModel }

uses
  uMemTable.Factory,
  uHlp,
  uSmartPointer,
  System.SysUtils;

constructor TPaymentTermsViewModel.Create(AOwner: IPaymentViewModel);
begin
  inherited Create;
  FOwner := AOwner;

  FPaymentTerms := TMemTableFactory.Make
    .AddField('id', ftLargeint)
    .AddField('payment_id', ftLargeint)
    .AddField('description', ftString, 255)
    .AddField('number_of_installments', ftSmallint)
    .AddField('interval_between_installments', ftSmallint)
    .AddField('first_in', ftSmallint)
    .CreateDataSet
  .Active(True);

  // Formata��o padr�o e configurar eventos do DataSet
  FormatDataSet(FPaymentTerms.DataSet);
  SetEvents;
end;

function TPaymentTermsViewModel.SetEvents: IPaymentTermsViewModel;
begin
  Result := Self;
  FPaymentTerms.DataSet.AfterInsert := AfterInsert;
end;

function TPaymentTermsViewModel.PaymentTerms: IZLMemTable;
begin
  Result := FPaymentTerms;
end;

procedure TPaymentTermsViewModel.AfterInsert(DataSet: TDataSet);
begin
  FillDataSetWithZero(DataSet);
end;

class function TPaymentTermsViewModel.Make(AOwner: IPaymentViewModel): IPaymentTermsViewModel;
begin
  Result := Self.Create(AOwner);
end;

end.

