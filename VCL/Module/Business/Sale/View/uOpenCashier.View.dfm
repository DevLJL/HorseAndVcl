object OpenCashierView: TOpenCashierView
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'OpenCashierView'
  ClientHeight = 325
  ClientWidth = 578
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object pnlBackground: TPanel
    Left = 0
    Top = 0
    Width = 578
    Height = 325
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 1
    Color = 8747344
    ParentBackground = False
    TabOrder = 0
    object pnlBackground2: TPanel
      Left = 1
      Top = 46
      Width = 576
      Height = 278
      Align = alClient
      BevelOuter = bvNone
      Color = 16381936
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -24
      Font.Name = 'Segoe UI Light'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 0
      object Label1: TLabel
        Left = 20
        Top = 22
        Width = 168
        Height = 32
        Caption = 'Caixa / Esta'#231#227'o'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 8747344
        Font.Height = -24
        Font.Name = 'Segoe UI Light'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 20
        Top = 70
        Width = 105
        Height = 32
        Caption = 'Operador'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 8747344
        Font.Height = -24
        Font.Name = 'Segoe UI Light'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 20
        Top = 118
        Width = 51
        Height = 32
        Caption = 'Data'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 8747344
        Font.Height = -24
        Font.Name = 'Segoe UI Light'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 20
        Top = 166
        Width = 131
        Height = 32
        Caption = 'Saldo Inicial'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 8747344
        Font.Height = -24
        Font.Name = 'Segoe UI Light'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtStationId: TEdit
        Left = 203
        Top = 19
        Width = 350
        Height = 40
        TabStop = False
        Alignment = taCenter
        BorderStyle = bsNone
        Color = 15920863
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -24
        Font.Name = 'Segoe UI Light'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        Text = '001'
      end
      object edtLoggedInUser: TEdit
        Left = 203
        Top = 67
        Width = 350
        Height = 40
        TabStop = False
        Alignment = taCenter
        BorderStyle = bsNone
        Color = 15920863
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -24
        Font.Name = 'Segoe UI Light'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
        Text = 'LEAD'
      end
      object edtDateTime: TEdit
        Left = 203
        Top = 115
        Width = 350
        Height = 40
        TabStop = False
        Alignment = taCenter
        BorderStyle = bsNone
        Color = 15920863
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -24
        Font.Name = 'Segoe UI Light'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
        Text = '12/03/2023 as 20:37:00'
      end
      object edtopening_balance_amount: TNumberBox
        Left = 203
        Top = 163
        Width = 350
        Height = 40
        Alignment = taRightJustify
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -24
        Font.Name = 'Segoe UI Light'
        Font.Style = [fsBold]
        Mode = nbmFloat
        ParentFont = False
        TabOrder = 3
        OnKeyPress = edtopening_balance_amountKeyPress
      end
      object pnlCancel: TPanel
        AlignWithMargins = True
        Left = 203
        Top = 220
        Width = 170
        Height = 40
        Cursor = crHandPoint
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        BevelOuter = bvNone
        BorderWidth = 1
        Color = 8747344
        ParentBackground = False
        TabOrder = 4
        object pnlCancel2: TPanel
          Left = 1
          Top = 1
          Width = 168
          Height = 38
          Cursor = crHandPoint
          Align = alClient
          BevelOuter = bvNone
          Color = 15658211
          ParentBackground = False
          TabOrder = 0
          object btnCancel: TSpeedButton
            Left = 0
            Top = 0
            Width = 168
            Height = 38
            Cursor = crHandPoint
            Align = alClient
            Caption = 'Cancelar (Esc)'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 8747344
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = btnCancelClick
            ExplicitLeft = 38
            ExplicitTop = 2
            ExplicitWidth = 130
          end
        end
      end
      object pnlSave: TPanel
        Left = 383
        Top = 220
        Width = 170
        Height = 40
        BevelOuter = bvNone
        BorderWidth = 1
        Caption = 'Incompleto!'
        Color = 3299352
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 5
        object pnlSave2: TPanel
          Left = 1
          Top = 1
          Width = 168
          Height = 38
          Cursor = crHandPoint
          Align = alClient
          BevelOuter = bvNone
          Color = 5212710
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentBackground = False
          ParentFont = False
          TabOrder = 0
          object btnOpenCashier: TSpeedButton
            Left = 0
            Top = 0
            Width = 168
            Height = 38
            Cursor = crHandPoint
            Align = alClient
            Caption = 'Abrir (Enter)'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = btnOpenCashierClick
            ExplicitLeft = 142
            ExplicitTop = 2
            ExplicitWidth = 130
          end
        end
      end
    end
    object pnlTitle: TPanel
      Left = 1
      Top = 1
      Width = 576
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      Color = 8747344
      ParentBackground = False
      TabOrder = 1
      object lblTitle: TLabel
        AlignWithMargins = True
        Left = 0
        Top = 5
        Width = 576
        Height = 40
        Margins.Left = 0
        Margins.Top = 5
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        Alignment = taCenter
        Caption = 'ABERTURA DE CAIXA'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -27
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 287
        ExplicitHeight = 33
      end
    end
  end
end
