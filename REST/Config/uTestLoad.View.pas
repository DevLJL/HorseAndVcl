unit uTestLoad.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.WinXCtrls,
  Vcl.StdCtrls, Vcl.Imaging.pngimage;

type
  TTestLoadView = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TestLoadView: TTestLoadView;

implementation

{$R *.dfm}

end.
