object ConsultEanView: TConsultEanView
  Left = 0
  Top = 0
  BorderStyle = bsNone
  BorderWidth = 2
  ClientHeight = 292
  ClientWidth = 806
  Color = 4205830
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poDesktopCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object pnlFundo: TPanel
    Left = 0
    Top = 62
    Width = 806
    Height = 230
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    Color = 16250354
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    ExplicitLeft = 56
    ExplicitTop = 65
    object Label1: TLabel
      Left = 20
      Top = 20
      Width = 171
      Height = 26
      Caption = 'C'#243'digo (Ref, Barras)'
      Color = 7754764
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10117144
      Font.Height = -21
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Label2: TLabel
      Left = 20
      Top = 121
      Width = 83
      Height = 26
      Caption = 'Descri'#231#227'o'
      Color = 7754764
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10117144
      Font.Height = -21
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Label3: TLabel
      Left = 620
      Top = 122
      Width = 49
      Height = 26
      Caption = 'Pre'#231'o'
      Color = 7754764
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 10117144
      Font.Height = -21
      Font.Name = 'Calibri'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Panel5: TPanel
      Left = 20
      Top = 45
      Width = 370
      Height = 35
      BevelOuter = bvNone
      BorderWidth = 1
      Color = 7754764
      ParentBackground = False
      TabOrder = 0
      TabStop = True
      object btnPesquisar: TSpeedButton
        Left = 269
        Top = 1
        Width = 100
        Height = 33
        Cursor = crHandPoint
        Align = alRight
        Caption = 'Pesquisar'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -21
        Font.Name = 'Segoe UI Light'
        Font.Style = [fsBold]
        NumGlyphs = 2
        ParentFont = False
        OnClick = btnPesquisarClick
        ExplicitLeft = 200
      end
      object edtProdCodigo: TEdit
        Left = 1
        Top = 1
        Width = 268
        Height = 33
        Align = alClient
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10117144
        Font.Height = -21
        Font.Name = 'Calibri'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnEnter = edtProdCodigoEnter
        OnExit = edtProdCodigoExit
        OnKeyPress = edtProdCodigoKeyPress
      end
    end
    object Panel1: TPanel
      Left = 20
      Top = 146
      Width = 590
      Height = 35
      BevelOuter = bvNone
      BorderWidth = 1
      Color = 7754764
      ParentBackground = False
      TabOrder = 1
      object edtProdDescricao: TEdit
        Left = 1
        Top = 1
        Width = 588
        Height = 33
        Align = alClient
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10117144
        Font.Height = -21
        Font.Name = 'Calibri'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
    end
    object Panel2: TPanel
      Left = 620
      Top = 147
      Width = 150
      Height = 35
      BevelOuter = bvNone
      BorderWidth = 1
      Color = 7754764
      ParentBackground = False
      TabOrder = 2
      object edtProdPreco: TEdit
        Left = 1
        Top = 1
        Width = 148
        Height = 33
        Align = alClient
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 10117144
        Font.Height = -21
        Font.Name = 'Calibri'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object pnlTitulo: TPanel
    Left = 0
    Top = 0
    Width = 806
    Height = 62
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Color = 7754764
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -40
    Font.Name = 'Segoe UI Light'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    object lblTitulo: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 358
      Height = 42
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      Caption = 'CONSULTA POR C'#211'DIGO'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -29
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitHeight = 35
    end
    object imgFechar: TImage
      Left = 771
      Top = 0
      Width = 35
      Height = 62
      Cursor = crHandPoint
      Align = alRight
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
        00200806000000737A7AF4000000017352474200AECE1CE90000000467414D41
        0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000002
        1B4944415478DA636400022EB71401206500C4FE0CB4071F80F8E2B75D733680
        388C5007AC07520174B01C191C003AC291116839C8E2F574B61C060C410EE807
        320A06C8010DA30E1875C0D072003F0F17C3FFFFFF193E7DFD8E5D9E9B8B4149
        4A94E1FCED87D47780BEB21CC3B6AE620601A023D27BE7332CD9750CC3718BAB
        D2199C8DB518CEDD7AC8E090DFC6F0F7DF3FEA396075630E8397853E9C9FD9B7
        9061D1CE2370CB1756A632B89AE8C0E513DA6733AC3E708A7A0E684C0C622889
        F04411CB9DB89861EDA1330CF32B5218DC4D75E1E2EF3F7F65702DEE62B8FEF0
        19F51C0002338A131862DDAC51C4AEDC7FC2A0A32803E77FF8F28D21B67526C3
        BE73D7883192F45C30BD288121CEDD1AAB1CC8F2F8B6590C7BCE5E25D638F2B2
        E1CC92448618572B14B13F7FFF3284D64F61D875FA0A294691EE0050569B5992
        C0E06B65882157366325C3D4F57B68E7007C96C340C5CC550C93D7EDA6BE03B0
        59FE1118E7A76FDC677031D146515B396B35C3A4B5BBA8EB80DEAC48860C7F27
        14CB53BAE7316C3B719161525E0C43B2B73D8A7A50363C76E536F51CD09511CE
        901DE802B73C1568F956A0E530D0971DC590EEE708E78312E43624798A1DC0CE
        C6CA3013580E6803F37CC3FCF50C5B8F5FC050D39E16CA106C6FCA307FFB6186
        F6259BA91B053402A30E1875C0A803C00E480032E60F900302619DD3FD40CA81
        CE962F00764E1319613CA02340D1A04F8181A4808340BC01E8800F00CF74E637
        D98CBC810000000049454E44AE426082}
      OnClick = imgFecharClick
      ExplicitLeft = 772
    end
  end
end
