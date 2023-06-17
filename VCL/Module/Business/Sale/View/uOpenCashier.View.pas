unit uOpenCashier.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Buttons, JvExStdCtrls, JvEdit,
  JvValidateEdit, Vcl.NumberBox;

type
  TOpenCashierView = class(TForm)
    pnlBackground: TPanel;
    pnlBackground2: TPanel;
    pnlTitle: TPanel;
    lblTitle: TLabel;
    Label1: TLabel;
    edtStationId: TEdit;
    Label2: TLabel;
    edtLoggedInUser: TEdit;
    Label3: TLabel;
    edtDateTime: TEdit;
    Label4: TLabel;
    edtopening_balance_amount: TNumberBox;
    pnlCancel: TPanel;
    pnlCancel2: TPanel;
    btnCancel: TSpeedButton;
    pnlSave: TPanel;
    pnlSave2: TPanel;
    btnOpenCashier: TSpeedButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOpenCashierClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtopening_balance_amountKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure BeforeShow;
  public
    class function Handle: Integer;
  end;

var
  OpenCashierView: TOpenCashierView;

implementation

{$R *.dfm}

uses
  uSmartPointer,
  uHlp,
  uEnv.Vcl,
  uUserLogged,
  uCashFlow.Service,
  uCashFlow.Input.DTO;

procedure TOpenCashierView.BeforeShow;
begin
  edtStationId.Text                    := StrZero(ENV_VCL.StationId.ToString,3);
  edtLoggedInUser.Text                 := UserLogged.Current.name;
  edtDateTime.Text                     := DateToStr(now);
  edtopening_balance_amount.ValueFloat := 0;
  edtopening_balance_amount.Alignment  := taCenter;
  if edtopening_balance_amount.CanFocus then
  begin
    edtopening_balance_amount.SetFocus;
    edtopening_balance_amount.SelectAll;
  end;
end;

procedure TOpenCashierView.btnCancelClick(Sender: TObject);
begin
  ModalResult := MrCancel;
end;

procedure TOpenCashierView.btnOpenCashierClick(Sender: TObject);
begin
  try
    LockControl(pnlBackground);

    // Inserir/Abrir Caixa
    const LCashFlowInputDTO: SH<TCashFlowInputDTO> = TCashFlowInputDTO.Create;
    With LCashFlowInputDTO.Value do
    begin
      station_id             := ENV_VCL.StationId;
      opening_balance_amount := edtopening_balance_amount.ValueFloat;
      opening_date           := now;
    end;
    const LEitherResult = TCashFlowService.Make.StoreAndShow(LCashFlowInputDTO, False);
    if not LEitherResult.Match then
      raise Exception.Create(LEitherResult.Left);

    ModalResult := MrOK;
  finally
    UnLockControl(pnlBackground);
  end;
end;

procedure TOpenCashierView.edtopening_balance_amountKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    btnOpenCashierClick(btnOpenCashier);
end;

procedure TOpenCashierView.FormCreate(Sender: TObject);
begin
  CreateDarkBackground(Self);
end;

procedure TOpenCashierView.FormShow(Sender: TObject);
begin
  BeforeShow;
end;

class function TOpenCashierView.Handle: Integer;
begin
  const LView: SH<TOpenCashierView> = TOpenCashierView.Create(nil);
  Result := lView.Value.ShowModal;
end;

end.
