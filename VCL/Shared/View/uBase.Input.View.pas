unit uBase.Input.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Buttons, Vcl.Imaging.pngimage, Vcl.WinXCtrls, Skia, Skia.Vcl,
  JvSpin, Vcl.Mask, JvExMask, JvToolEdit;

type
  TBaseInputView = class(TForm)
    pnlBackground: TPanel;
    pnlBackground2: TPanel;
    pnlBottomButtons: TPanel;
    pnlSave: TPanel;
    pnlSave2: TPanel;
    pnlSave3: TPanel;
    imgSave: TImage;
    pnlCancel: TPanel;
    pnlCancel2: TPanel;
    btnCancel: TSpeedButton;
    pnlCancel3: TPanel;
    imgCancel4: TImage;
    pgc: TPageControl;
    tabMain: TTabSheet;
    pnlMain: TPanel;
    btnFocus: TButton;
    pnlTitle: TPanel;
    imgTitle: TImage;
    lblTitle: TLabel;
    imgCloseTitle: TImage;
    imgMinimizeTitle: TImage;
    IndicatorLoadButtonSave: TActivityIndicator;
    IndicatorLoadFormLabel: TLabel;
    imgNoSearch: TSkAnimatedImage;
    IndicatorLoadForm: TSkAnimatedImage;
    btnSave: TSpeedButton;
    tmrAllowSave: TTimer;
    procedure imgMinimizeTitleClick(Sender: TObject); virtual;
    procedure FormCreate(Sender: TObject); virtual;
    procedure EdtFieldEnter(Sender: TObject); virtual;
    procedure EdtFieldExit(Sender: TObject); virtual;
    procedure EdtFieldKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
    procedure EdtFieldKeyPress(Sender: TObject; var Key: Char); virtual;
    procedure EdtFieldClick(Sender: TObject); virtual;
    procedure ToggleSwitch1Click(Sender: TObject); virtual;
    procedure ImageShowHintClick(Sender: TObject); virtual;
    procedure pnlTitleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tmrAllowSaveTimer(Sender: TObject); virtual;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FLoadingSave: Boolean;
    FLoadingForm: Boolean;
    FFormIsValid: Boolean;
    procedure SetLoadingForm(const Value: Boolean);
    procedure SetLoadingSave(const Value: Boolean);
  public
    property LoadingSave: Boolean read FLoadingSave write SetLoadingSave;
    property LoadingForm: Boolean read FLoadingForm write SetLoadingForm;
    property FormIsValid: Boolean read FFormIsValid write FFormIsValid;
  end;

implementation

{$R *.dfm}

uses
  uHlp,
  Vcl.DBCtrls,
  uToast.View,
  uAppVcl.Types,
  uYesOrNo.View,
  uTrans,
  Vcl.NumberBox;

Const
  COLOR_ON_ENTER: TColor = $00F3ECE4;
  COLOR_ON_EXIT: TColor  = clWindow;


{ TBaseInputView }

procedure TBaseInputView.EdtFieldClick(Sender: TObject);
begin
  if (Sender is TEdit) then
    TEdit(Sender).SelectAll;

  if (Sender is TDBEdit) then
    TDBEdit(Sender).SelectAll;

  if (Sender is TNumberBox) then
    TNumberBox(Sender).SelectAll;
end;

procedure TBaseInputView.EdtFieldEnter(Sender: TObject);
begin
 if (Sender is TEdit) then
    TEdit(Sender).Color := COLOR_ON_ENTER;

 if (Sender is TDBEdit) then
    TDBEdit(Sender).Color := COLOR_ON_ENTER;

  if (Sender is TComboBox) then
    TComboBox(Sender).Color := COLOR_ON_ENTER;

  if (Sender is TDBComboBox) then
    TDBComboBox(Sender).Color := COLOR_ON_ENTER;

  if (Sender is TMemo) then
    TMemo(Sender).Color := COLOR_ON_ENTER;

  if (Sender is TDBMemo) then
    TDBMemo(Sender).Color := COLOR_ON_ENTER;

  if (Sender is TNumberBox) then
    TNumberBox(Sender).Color := COLOR_ON_ENTER;

  if (Sender is TJvDateEdit) then
    TJvDateEdit(Sender).Color := COLOR_ON_ENTER;

  if (Sender is TJvTimeEdit) then
    TJvTimeEdit(Sender).Color := COLOR_ON_ENTER;
end;

procedure TBaseInputView.EdtFieldExit(Sender: TObject);
begin
  if (Sender is TEdit) then
    TEdit(Sender).Color := COLOR_ON_EXIT;

  if (Sender is TDBEdit) then
    TDBEdit(Sender).Color := COLOR_ON_EXIT;

  if (Sender is TComboBox) then
    TComboBox(Sender).Color := COLOR_ON_EXIT;

  if (Sender is TDBComboBox) then
    TDBComboBox(Sender).Color := COLOR_ON_EXIT;

  if (Sender is TMemo) then
    TMemo(Sender).Color := COLOR_ON_EXIT;

  if (Sender is TDBMemo) then
    TDBMemo(Sender).Color := COLOR_ON_EXIT;

  if (Sender is TNumberBox) then
    TNumberBox(Sender).Color := COLOR_ON_EXIT;

  if (Sender is TJvDateEdit) then
    TJvDateEdit(Sender).Color := COLOR_ON_EXIT;

  if (Sender is TJvTimeEdit) then
    TJvTimeEdit(Sender).Color := COLOR_ON_EXIT;
end;

procedure TBaseInputView.EdtFieldKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Focus no proximo campo
  if (Key = VK_RETURN) then
    Perform(WM_NEXTDLGCTL,0,0);
end;

procedure TBaseInputView.EdtFieldKeyPress(Sender: TObject; var Key: Char);
begin
//
end;

procedure TBaseInputView.FormCreate(Sender: TObject);
begin
  FFormIsValid                    := True;
  pgc.ActivePageIndex             := 0;
  IndicatorLoadButtonSave.Animate := False;
  IndicatorLoadButtonSave.Visible := False;
  CreateDarkBackground(Self);
end;

procedure TBaseInputView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  // Não permitir atalhos enquanto estiver carregando
  if (LoadingSave or LoadingForm) then
  begin
    Key := 0;
    Exit;
  end;
end;

procedure TBaseInputView.ImageShowHintClick(Sender: TObject);
begin
  MessageDlg(TImage(Sender).Hint, mtInformation, [mbOK], 0);
end;

procedure TBaseInputView.imgMinimizeTitleClick(Sender: TObject);
begin
  Application.Minimize;
  ToastView.Execute(Trans.YourAppHasBeenMinimized, tneInfo);
end;

procedure TBaseInputView.pnlTitleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  sc_DragMove = $f012;
begin
  ReleaseCapture;
  Perform(wm_SysCommand, sc_DragMove, 0);
end;

procedure TBaseInputView.SetLoadingForm(const Value: Boolean);
var
  lLeft,
  lTop: Integer;
begin
  FLoadingForm := Value;

  case FLoadingForm of
    True: Begin
      // Ativar Loading
      IndicatorLoadForm.Visible           := True;
      IndicatorLoadForm.Animation.Enabled := True;
      IndicatorLoadFormLabel.Visible      := True;
      imgNoSearch.Animation.Enabled       := True;
      imgNoSearch.Visible                 := True;
      Screen.Cursor                       := crHourGlass;
      pnlBackground.Enabled               := False;
      pgc.Visible                         := False;
    end;
    False: Begin
      IndicatorLoadForm.Visible           := False;
      IndicatorLoadForm.Animation.Enabled := False;
      IndicatorLoadFormLabel.Visible      := False;
      imgNoSearch.Visible                 := False;
      imgNoSearch.Animation.Enabled       := False;
      Screen.Cursor                       := crDefault;
      pnlBackground.Enabled               := True;
      pgc.Visible                         := True;
    end;
  end;
end;

procedure TBaseInputView.SetLoadingSave(const Value: Boolean);
begin
  FLoadingSave := Value;

  case FLoadingSave of
    True: Begin
      IndicatorLoadButtonSave.Visible := True;
      IndicatorLoadButtonSave.Animate := True;
      imgSave.Visible                 := False;
      Screen.Cursor                   := crHourGlass;
    end;
    False: Begin
      IndicatorLoadButtonSave.Visible := False;
      IndicatorLoadButtonSave.Animate := False;
      imgSave.Visible                 := True;
      Screen.Cursor                   := crDefault;
    End;
  end;
end;

procedure TBaseInputView.tmrAllowSaveTimer(Sender: TObject);
begin
  // Para permanecer efeito de loading ao salvar registro
  if FLoadingSave then
    FFormIsValid := true;

  case FFormIsValid of
    True: Begin
      if not pnlSave2.Visible then
      begin
        pnlSave2.Visible := True;
        pnlSave.Color    := pnlSave3.Color;
        pnlSave.Cursor   := crHandPoint;
      end;
    End;
    False: Begin
      if pnlSave2.Visible then
      begin
        pnlSave2.Visible := False;
        pnlSave.Color    := pnlCancel.Color;
        pnlSave.Cursor   := crNo;
      end;
    End;
  end;
end;

procedure TBaseInputView.ToggleSwitch1Click(Sender: TObject);
begin
  case TToggleSwitch(Sender).IsOn of
    True: Begin
      TToggleSwitch(Sender).FrameColor := clGreen;
      TToggleSwitch(Sender).ThumbColor := clGreen;
    End;
    False: Begin
      TToggleSwitch(Sender).FrameColor := clGray;
      TToggleSwitch(Sender).ThumbColor := clGray;
    End;
  end;
end;

end.
