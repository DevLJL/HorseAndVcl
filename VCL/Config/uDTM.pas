unit uDTM;

interface

uses
  System.SysUtils,
  System.Classes,
  System.ImageList,
  Vcl.ImgList,
  Vcl.Controls;

type
  TDTM = class(TDataModule)
    imgListGrid: TImageList;
  end;

var
  DTM: TDTM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
