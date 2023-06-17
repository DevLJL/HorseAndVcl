unit uPaymentTerm.Locate.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Skia, Data.DB, Vcl.Buttons, Vcl.Grids,
  Vcl.DBGrids, JvExDBGrids,  Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Skia.Vcl, Vcl.StdCtrls,

  uZLMemTable.Interfaces,
  uPayment.Show.DTO,
  uPaymentTerm.Show.DTO;

type
  TPaymentTermLocateView = class(TForm)
    pnlContent: TPanel;
    pnlTitle: TPanel;
    lblTitle: TLabel;
    pnlTitleBottomBar: TPanel;
    SkAnimatedImage1: TSkAnimatedImage;
    scbContent: TScrollBox;
    pnlGrid: TPanel;
    pnlGrid2: TPanel;
    pnlDbgrid: TPanel;
    lblNoSearch: TLabel;
    imgNoSearch2: TImage;
    imgNoSearch: TSkAnimatedImage;
    dbgPaymentTermList: TDBGrid;
    pnlSearch: TPanel;
    pnlSearch4: TPanel;
    pnlSearch2: TPanel;
    lblSearch: TLabel;
    pnlLocate: TPanel;
    pnlSave: TPanel;
    pnlSave2: TPanel;
    btnLocateConfirm: TSpeedButton;
    pnlSave3: TPanel;
    imgSave: TImage;
    pnlCancel: TPanel;
    pnlCancel2: TPanel;
    btnLocateClose: TSpeedButton;
    pnlCancel3: TPanel;
    imgCancel4: TImage;
    dtsPaymentTerm: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btnLocateCloseClick(Sender: TObject);
    procedure btnLocateConfirmClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbgPaymentTermListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FPaymentId: Int64;
    FPaymentTerm: IZLMemTable;
  public
    constructor Create(AOwner: TComponent; APaymentId: Int64);
    /// <summary> Retuns payment_term.id </summary>
    class function Handle(APaymentId: Int64): TPaymentTermShowDTO;
  end;

var
  PaymentTermLocateView: TPaymentTermLocateView;

implementation

uses
  uSmartPointer, uPayment.Service;

{$R *.dfm}

{ TPaymentTermLocateView }

procedure TPaymentTermLocateView.btnLocateCloseClick(Sender: TObject);
begin
  ModalResult := MrCancel;
end;

procedure TPaymentTermLocateView.btnLocateConfirmClick(Sender: TObject);
begin
  if (dtsPaymentTerm.DataSet.RecordCount = 0) then
    Exit;

  ModalResult := MrOK;
end;

constructor TPaymentTermLocateView.Create(AOwner: TComponent; APaymentId: Int64);
begin
  inherited Create(AOwner);
  FPaymentId := APaymentId;
end;

procedure TPaymentTermLocateView.dbgPaymentTermListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Bloquear Ctrl + Del
  if (ssCtrl in Shift) and (Key = VK_DELETE) then
    Key := 0;

  // Quando Enter Pressionado Editar
  if (Key = VK_RETURN) Then
  Begin
    btnLocateConfirmClick(Sender);
    Key := 0;
  End;
end;

procedure TPaymentTermLocateView.FormCreate(Sender: TObject);
begin
  FPaymentTerm := TPaymentService.Make.ListPaymentTerms(FPaymentId);
  dtsPaymentTerm.DataSet        := FPaymentTerm.DataSet;
  dbgPaymentTermList.DataSource := dtsPaymentTerm;
end;

procedure TPaymentTermLocateView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Esc - Fechar Modal quando estiver pesquisando
  if (Key = VK_ESCAPE) then
  begin
    btnLocateCloseClick(btnLocateClose);
    Exit;
  end;
end;

procedure TPaymentTermLocateView.FormShow(Sender: TObject);
begin
  dbgPaymentTermList.SetFocus;
end;

class function TPaymentTermLocateView.Handle(APaymentId: Int64): TPaymentTermShowDTO;
begin
  Result := Nil;

  const LView: SH<TPaymentTermLocateView> = TPaymentTermLocateView.Create(nil, APaymentId);
  if not (LView.Value.ShowModal = mrOK) then
    Exit;

  // Retornar Termo de Pagamento selecionado
  const LPaymentShowDTO: SH<TPaymentShowDTO> = TPaymentService.Make.Show(APaymentId);
  for var LPaymentTermShowDTO in LPaymentShowDTO.Value.payment_terms do
  begin
    if (LPaymentTermShowDTO.id = LView.Value.FPaymentTerm.FieldByName('id').AsLargeInt) then
    begin
      Result := LPaymentTermShowDTO;
      Break;
    end;
  end;
end;

end.
