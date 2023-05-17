inherited SaleInputView: TSaleInputView
  ClientWidth = 1024
  OnShow = FormShow
  ExplicitWidth = 1024
  TextHeight = 13
  inherited pnlBackground: TPanel
    Width = 1024
    ExplicitWidth = 1024
    inherited pnlBackground2: TPanel
      Width = 1022
      ExplicitWidth = 1022
      inherited imgNoSearch: TSkAnimatedImage
        Width = 922
        ExplicitWidth = 922
      end
      inherited pnlBottomButtons: TPanel
        Width = 1002
        ExplicitWidth = 1002
        inherited pnlSave: TPanel
          Left = 832
          ExplicitLeft = 832
          inherited pnlSave2: TPanel
            inherited btnSave: TSpeedButton
              OnClick = btnSaveClick
            end
            inherited pnlSave3: TPanel
              OnClick = btnSaveClick
              inherited imgSave: TImage
                OnClick = btnSaveClick
                ExplicitLeft = -7
                ExplicitTop = 4
              end
              inherited IndicatorLoadButtonSave: TActivityIndicator
                ExplicitWidth = 24
                ExplicitHeight = 24
              end
            end
          end
        end
        inherited pnlCancel: TPanel
          Left = 652
          ExplicitLeft = 652
          inherited pnlCancel2: TPanel
            inherited btnCancel: TSpeedButton
              OnClick = btnCancelClick
              ExplicitLeft = 38
            end
            inherited pnlCancel3: TPanel
              OnClick = btnCancelClick
              inherited imgCancel4: TImage
                OnClick = btnCancelClick
              end
            end
          end
        end
      end
      inherited pgc: TPageControl
        Width = 1002
        ActivePage = TabSheet3
        ExplicitWidth = 1002
        inherited tabMain: TTabSheet
          ExplicitWidth = 994
          inherited pnlMain: TPanel
            Width = 994
            ExplicitWidth = 994
            object Label22: TLabel
              Left = 10
              Top = 10
              Width = 75
              Height = 18
              Caption = 'Venda N'#186':'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label37: TLabel
              Left = 10
              Top = 80
              Width = 62
              Height = 14
              Caption = 'F1 - Cliente'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label10: TLabel
              Left = 10
              Top = 34
              Width = 8
              Height = 14
              Caption = '*'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label4: TLabel
              Left = 20
              Top = 34
              Width = 152
              Height = 14
              Caption = 'F1 - Vendedor / Atendente'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label2: TLabel
              Left = 10
              Top = 141
              Width = 149
              Height = 18
              Caption = 'Produtos / Servi'#231'os'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Panel5: TPanel
              Left = 10
              Top = 28
              Width = 974
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 4
            end
            object edtId: TDBEdit
              Left = 88
              Top = 10
              Width = 58
              Height = 18
              TabStop = False
              BorderStyle = bsNone
              Color = 16579576
              DataField = 'id'
              DataSource = dtsSale
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Calibri'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 5
              OnClick = EdtFieldClick
              OnKeyDown = EdtFieldKeyDown
            end
            object edtperson_name: TDBEdit
              Left = 88
              Top = 95
              Width = 394
              Height = 26
              Color = 16053492
              DataField = 'person_name'
              DataSource = dtsSale
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 3
              OnKeyDown = EdtFieldKeyDown
            end
            object Panel41: TPanel
              Left = 10
              Top = 95
              Width = 26
              Height = 26
              Cursor = crHandPoint
              BevelOuter = bvNone
              BorderWidth = 1
              Color = 5327153
              ParentBackground = False
              TabOrder = 6
              object Panel42: TPanel
                Left = 1
                Top = 1
                Width = 24
                Height = 24
                Cursor = crHandPoint
                Align = alClient
                BevelOuter = bvNone
                Color = 8747344
                ParentBackground = False
                TabOrder = 0
                object imgLocaPerson: TImage
                  Left = 0
                  Top = 0
                  Width = 18
                  Height = 18
                  Align = alClient
                  AutoSize = True
                  Center = True
                  Picture.Data = {
                    0954506E67496D61676589504E470D0A1A0A0000000D49484452000000120000
                    0012080600000056CE8E57000000017352474200AECE1CE90000000467414D41
                    0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
                    414944415478DAA5938171C2300C45ADCB00850DC2040D1B94094A2600262899
                    80D205B84E001B1426209DA0D9A0E904658284FF13B9C7E56C27477DF7CFC696
                    9E14498809ACBAAE47D85EA0391443FC5D4247E85D444A6B2B014882ED431D73
                    E8A44F043E434BE815B0AD1704088DCF1A790BE38BDE199B85063A5755F51645
                    D1CE07DAABD34A1D3650017DE22EEF64FD054DC401B18F53E802119A32AB6050
                    C7038BBB84E314676672C2B908D4928DD8BB40744EE09CE2BCC39EF574B6F982
                    20C80C5821509BAAC87820688D6DE1028DB4D86CFBA10742DB664CC4138105A7
                    D1ACA7D0EC58D2D87920ACCFC2B4D39B7533C310C6B8DBC09E81E60C260EC88A
                    436727D7B4B3C4EC72358D5585DA96BC946E26A4DFFCCF9A3A69031E15F84368
                    F793C593C91F6448E72CE8FBBF100BFA65D5A107E8700FC4829E6E8A9ADD03E1
                    BA02035FC005512468860000000049454E44AE426082}
                  OnClick = imgLocaPersonClick
                  ExplicitTop = 14
                end
              end
            end
            object edtperson_id: TDBEdit
              Left = 37
              Top = 95
              Width = 50
              Height = 26
              DataField = 'person_id'
              DataSource = dtsSale
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 2
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtseller_name: TDBEdit
              Left = 88
              Top = 49
              Width = 394
              Height = 26
              Color = 16053492
              DataField = 'seller_name'
              DataSource = dtsSale
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 1
              OnKeyDown = EdtFieldKeyDown
            end
            object Panel4: TPanel
              Left = 10
              Top = 49
              Width = 26
              Height = 26
              Cursor = crHandPoint
              BevelOuter = bvNone
              BorderWidth = 1
              Color = 5327153
              ParentBackground = False
              TabOrder = 7
              object Panel1: TPanel
                Left = 1
                Top = 1
                Width = 24
                Height = 24
                Cursor = crHandPoint
                Align = alClient
                BevelOuter = bvNone
                Color = 8747344
                ParentBackground = False
                TabOrder = 0
                object imgLocaSeller: TImage
                  Left = 0
                  Top = 0
                  Width = 18
                  Height = 18
                  Align = alClient
                  AutoSize = True
                  Center = True
                  Picture.Data = {
                    0954506E67496D61676589504E470D0A1A0A0000000D49484452000000120000
                    0012080600000056CE8E57000000017352474200AECE1CE90000000467414D41
                    0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
                    414944415478DAA5938171C2300C45ADCB00850DC2040D1B94094A2600262899
                    80D205B84E001B1426209DA0D9A0E904658284FF13B9C7E56C27477DF7CFC696
                    9E14498809ACBAAE47D85EA0391443FC5D4247E85D444A6B2B014882ED431D73
                    E8A44F043E434BE815B0AD1704088DCF1A790BE38BDE199B85063A5755F51645
                    D1CE07DAABD34A1D3650017DE22EEF64FD054DC401B18F53E802119A32AB6050
                    C7038BBB84E314676672C2B908D4928DD8BB40744EE09CE2BCC39EF574B6F982
                    20C80C5821509BAAC87820688D6DE1028DB4D86CFBA10742DB664CC4138105A7
                    D1ACA7D0EC58D2D87920ACCFC2B4D39B7533C310C6B8DBC09E81E60C260EC88A
                    436727D7B4B3C4EC72358D5585DA96BC946E26A4DFFCCF9A3A69031E15F84368
                    F793C593C91F6448E72CE8FBBF100BFA65D5A107E8700FC4829E6E8A9ADD03E1
                    BA02035FC005512468860000000049454E44AE426082}
                  OnClick = imgLocaSellerClick
                  ExplicitTop = 14
                end
              end
            end
            object edtseller_id: TDBEdit
              Left = 37
              Top = 49
              Width = 50
              Height = 26
              DataField = 'seller_id'
              DataSource = dtsSale
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object pgcNote: TPageControl
              Left = 492
              Top = 36
              Width = 492
              Height = 85
              ActivePage = TabSheet1
              TabOrder = 8
              TabStop = False
              object TabSheet1: TTabSheet
                Caption = '   Observa'#231#227'o Impressa   '
                object Panel12: TPanel
                  Left = 0
                  Top = 0
                  Width = 484
                  Height = 56
                  Align = alClient
                  BevelOuter = bvNone
                  BorderWidth = 1
                  Color = clSilver
                  ParentBackground = False
                  TabOrder = 0
                  object DBMemo1: TDBMemo
                    Left = 1
                    Top = 1
                    Width = 482
                    Height = 54
                    TabStop = False
                    Align = alClient
                    BorderStyle = bsNone
                    DataField = 'note'
                    DataSource = dtsSale
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -15
                    Font.Name = 'Tahoma'
                    Font.Style = [fsBold]
                    ParentFont = False
                    TabOrder = 0
                    OnEnter = EdtFieldEnter
                    OnExit = EdtFieldExit
                  end
                end
              end
              object TabSheet2: TTabSheet
                Caption = '   Observa'#231#227'o Interna   '
                ImageIndex = 1
                object Panel13: TPanel
                  Left = 0
                  Top = 0
                  Width = 484
                  Height = 56
                  Align = alClient
                  BevelOuter = bvNone
                  BorderWidth = 1
                  Color = clSilver
                  ParentBackground = False
                  TabOrder = 0
                  object DBMemo2: TDBMemo
                    Left = 1
                    Top = 1
                    Width = 482
                    Height = 54
                    TabStop = False
                    Align = alClient
                    BorderStyle = bsNone
                    DataField = 'internal_note'
                    DataSource = dtsSale
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -15
                    Font.Name = 'Tahoma'
                    Font.Style = [fsBold]
                    ParentFont = False
                    TabOrder = 0
                    OnEnter = EdtFieldEnter
                    OnExit = EdtFieldExit
                  end
                end
              end
            end
            object Panel2: TPanel
              Left = 10
              Top = 159
              Width = 974
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 9
            end
            object Panel6: TPanel
              AlignWithMargins = True
              Left = 10
              Top = 163
              Width = 974
              Height = 401
              Margins.Left = 10
              Margins.Top = 0
              Margins.Right = 10
              Margins.Bottom = 10
              Anchors = [akLeft, akTop, akRight, akBottom]
              BevelOuter = bvNone
              Color = 16579576
              ParentBackground = False
              TabOrder = 10
              object dbgSaleItems: TDBGrid
                Left = 0
                Top = 51
                Width = 974
                Height = 310
                Cursor = crHandPoint
                Align = alClient
                Color = clWhite
                DataSource = dtsSaleItems
                DrawingStyle = gdsGradient
                FixedColor = 15131349
                GradientEndColor = 16381936
                GradientStartColor = 15920607
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'Tahoma'
                Font.Style = []
                Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgTitleClick, dgTitleHotTrack]
                ParentFont = False
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = 8747344
                TitleFont.Height = -13
                TitleFont.Name = 'Tahoma'
                TitleFont.Style = [fsBold]
                OnCellClick = dbgSaleItemsCellClick
                OnDrawColumnCell = dbgSaleItemsDrawColumnCell
                OnDblClick = btnSaleItemsEditClick
                Columns = <
                  item
                    Alignment = taCenter
                    Expanded = False
                    FieldName = 'action_edit'
                    Title.Alignment = taCenter
                    Title.Caption = ' '
                    Width = 25
                    Visible = True
                  end
                  item
                    Alignment = taCenter
                    Expanded = False
                    FieldName = 'action_delete'
                    Title.Alignment = taCenter
                    Title.Caption = ' '
                    Width = 25
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'product_name'
                    Title.Caption = 'Item'
                    Width = 316
                    Visible = True
                  end
                  item
                    Alignment = taRightJustify
                    Expanded = False
                    FieldName = 'quantity'
                    Title.Alignment = taRightJustify
                    Title.Caption = 'Qde'
                    Width = 60
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'product_unit_name'
                    Title.Caption = 'Unid.'
                    Width = 50
                    Visible = True
                  end
                  item
                    Alignment = taRightJustify
                    Expanded = False
                    FieldName = 'price'
                    Title.Alignment = taRightJustify
                    Title.Caption = 'Pre'#231'o Unit.'
                    Width = 80
                    Visible = True
                  end
                  item
                    Alignment = taRightJustify
                    Expanded = False
                    FieldName = 'unit_discount'
                    Title.Alignment = taRightJustify
                    Title.Caption = 'Desc. Unit.'
                    Width = 80
                    Visible = True
                  end
                  item
                    Alignment = taRightJustify
                    Expanded = False
                    FieldName = 'subtotal'
                    Title.Alignment = taRightJustify
                    Title.Caption = 'Subtotal'
                    Width = 90
                    Visible = True
                  end
                  item
                    Alignment = taRightJustify
                    Expanded = False
                    FieldName = 'total'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clGreen
                    Font.Height = -15
                    Font.Name = 'Tahoma'
                    Font.Style = [fsBold]
                    Title.Alignment = taRightJustify
                    Title.Caption = 'Total'
                    Width = 120
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'note'
                    Title.Caption = 'Detalhes'
                    Width = 300
                    Visible = True
                  end>
              end
              object Panel9: TPanel
                Left = 0
                Top = 0
                Width = 974
                Height = 51
                Align = alTop
                BevelOuter = bvNone
                Color = 16579576
                ParentBackground = False
                TabOrder = 1
                DesignSize = (
                  974
                  51)
                object Label8: TLabel
                  Left = 0
                  Top = 35
                  Width = 8
                  Height = 14
                  Caption = '*'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clRed
                  Font.Height = -12
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  ParentFont = False
                end
                object Label15: TLabel
                  Left = 177
                  Top = 8
                  Width = 167
                  Height = 14
                  Caption = 'Descri'#231#227'o do produto / servi'#231'o'
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clBlack
                  Font.Height = -12
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentFont = False
                  Transparent = True
                end
                object Label23: TLabel
                  Left = 734
                  Top = 8
                  Width = 61
                  Height = 14
                  Anchors = [akTop, akRight]
                  Caption = 'Pre'#231'o Unit.'
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clBlack
                  Font.Height = -12
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentFont = False
                  Transparent = True
                end
                object Label24: TLabel
                  Left = 651
                  Top = 8
                  Width = 63
                  Height = 14
                  Anchors = [akTop, akRight]
                  Caption = 'Quantidade'
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clBlack
                  Font.Height = -12
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentFont = False
                  Transparent = True
                end
                object Label25: TLabel
                  Left = 857
                  Top = 8
                  Width = 72
                  Height = 14
                  Anchors = [akTop, akRight]
                  Caption = 'Total (Enter)'
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clBlack
                  Font.Height = -12
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentFont = False
                  Transparent = True
                end
                object Label27: TLabel
                  Left = 719
                  Top = 27
                  Width = 10
                  Height = 18
                  Alignment = taRightJustify
                  Anchors = [akTop, akRight]
                  Caption = 'X'
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clBlack
                  Font.Height = -15
                  Font.Name = 'Arial'
                  Font.Style = [fsBold]
                  ParentFont = False
                  Transparent = True
                end
                object Label28: TLabel
                  Left = 843
                  Top = 27
                  Width = 9
                  Height = 18
                  Alignment = taRightJustify
                  Anchors = [akTop, akRight]
                  Caption = '='
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clBlack
                  Font.Height = -15
                  Font.Name = 'Arial'
                  Font.Style = [fsBold]
                  ParentFont = False
                  Transparent = True
                end
                object imgsale_item_append: TImage
                  Left = 948
                  Top = 23
                  Width = 26
                  Height = 26
                  Cursor = crHandPoint
                  Anchors = [akTop, akRight]
                  AutoSize = True
                  ParentShowHint = False
                  Picture.Data = {
                    0954506E67496D61676589504E470D0A1A0A0000000D494844520000001A0000
                    001A0806000000A94A4CCE000000017352474200AECE1CE90000000467414D41
                    0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
                    8C4944415478DA6354EBF237606060980FC4BA40CCCC407D700E8893198116DD
                    02325469600132780DB2E83F8D2D0183C165111F3B3783BDB23183388F308AF8
                    F69B47199E7E7C453D8B0A6D6318322C4230C43FFDFCCA6035259EE1F7BF3FD4
                    B16856702D83BD92315639F739590C0FDE3F1BB568385A044ACA813A4E0CACCC
                    2C70310F752B065D09EC85C7C2B39B195E7D7907E71FB87786E1CE9BC7842DB2
                    5630609817DA40D085B8C0C17B6719D2D636131774F8820A1F00E5ABA4550D0C
                    975FDC26CE2250F02D8FEE6050119625C9A2DA9DD318565DDA85550E67625010
                    9462D899328D684B4071D5B66F2E4E79BCA90E147CA06024048E3EB8C050B0A9
                    1B1C7464590402F52EE90C51869E38E541856AC892528677DF3EE2750C51F968
                    7954078391B40686F8F7DF3F194AB6F631ECB97D92A0AF89AE2636C4F73348F3
                    8BA188771F5CC830E7D47A8296106D1108A888C8326C4D9C0CE7138A7CB22D02
                    0150E228734800C747F6FA76BC914F91459400BA5A741F482BD0D89E7B208B1C
                    800C50B9C14A234BDE02710A0023AABC32C07C1C6D0000000049454E44AE4260
                    82}
                  ShowHint = False
                  OnClick = imgsale_item_appendClick
                end
                object Label1: TLabel
                  Left = 0
                  Top = 8
                  Width = 51
                  Height = 14
                  Caption = 'F2 - Item'
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clBlack
                  Font.Height = -12
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentFont = False
                  Transparent = True
                end
                object Panel10: TPanel
                  Left = 0
                  Top = 23
                  Width = 26
                  Height = 26
                  Cursor = crHandPoint
                  BevelOuter = bvNone
                  BorderWidth = 1
                  Color = 5327153
                  ParentBackground = False
                  TabOrder = 5
                  object Panel11: TPanel
                    Left = 1
                    Top = 1
                    Width = 24
                    Height = 24
                    Cursor = crHandPoint
                    Align = alClient
                    BevelOuter = bvNone
                    Color = 8747344
                    ParentBackground = False
                    TabOrder = 0
                    object imgsale_item_loca_product: TImage
                      Left = 0
                      Top = 0
                      Width = 18
                      Height = 18
                      Align = alClient
                      AutoSize = True
                      Center = True
                      Picture.Data = {
                        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000120000
                        0012080600000056CE8E57000000017352474200AECE1CE90000000467414D41
                        0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
                        414944415478DAA5938171C2300C45ADCB00850DC2040D1B94094A2600262899
                        80D205B84E001B1426209DA0D9A0E904658284FF13B9C7E56C27477DF7CFC696
                        9E14498809ACBAAE47D85EA0391443FC5D4247E85D444A6B2B014882ED431D73
                        E8A44F043E434BE815B0AD1704088DCF1A790BE38BDE199B85063A5755F51645
                        D1CE07DAABD34A1D3650017DE22EEF64FD054DC401B18F53E802119A32AB6050
                        C7038BBB84E314676672C2B908D4928DD8BB40744EE09CE2BCC39EF574B6F982
                        20C80C5821509BAAC87820688D6DE1028DB4D86CFBA10742DB664CC4138105A7
                        D1ACA7D0EC58D2D87920ACCFC2B4D39B7533C310C6B8DBC09E81E60C260EC88A
                        436727D7B4B3C4EC72358D5585DA96BC946E26A4DFFCCF9A3A69031E15F84368
                        F793C593C91F6448E72CE8FBBF100BFA65D5A107E8700FC4829E6E8A9ADD03E1
                        BA02035FC005512468860000000049454E44AE426082}
                      OnClick = imgsale_item_loca_productClick
                      ExplicitTop = 14
                    end
                  end
                end
                object edtsale_item_id: TEdit
                  Tag = 1
                  Left = 27
                  Top = 23
                  Width = 140
                  Height = 26
                  Color = clWhite
                  Font.Charset = ANSI_CHARSET
                  Font.Color = 7754764
                  Font.Height = -15
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  ParentFont = False
                  ParentShowHint = False
                  ShowHint = False
                  TabOrder = 0
                  OnClick = EdtFieldClick
                  OnEnter = EdtFieldEnter
                  OnExit = EdtFieldExit
                  OnKeyDown = EdtFieldKeyDown
                end
                object edtsale_item_name: TEdit
                  Tag = 1
                  Left = 177
                  Top = 23
                  Width = 464
                  Height = 26
                  Anchors = [akLeft, akTop, akRight]
                  Color = 16053492
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clGray
                  Font.Height = -15
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  MaxLength = 85
                  ParentFont = False
                  ReadOnly = True
                  TabOrder = 1
                  OnKeyDown = EdtFieldKeyDown
                end
                object edtsale_item_price: TNumberBox
                  Tag = 1
                  Left = 734
                  Top = 23
                  Width = 104
                  Height = 26
                  Anchors = [akTop, akRight]
                  Color = clWhite
                  Font.Charset = ANSI_CHARSET
                  Font.Color = 7754764
                  Font.Height = -15
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  Mode = nbmFloat
                  ParentFont = False
                  ParentShowHint = False
                  ShowHint = False
                  TabOrder = 3
                  OnClick = EdtFieldClick
                  OnExit = EdtFieldExit
                  OnKeyDown = EdtFieldKeyDown
                end
                object edtsale_item_quantity: TNumberBox
                  Tag = 1
                  Left = 651
                  Top = 23
                  Width = 64
                  Height = 26
                  Anchors = [akTop, akRight]
                  Color = clWhite
                  Font.Charset = ANSI_CHARSET
                  Font.Color = 7754764
                  Font.Height = -15
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  Mode = nbmFloat
                  ParentFont = False
                  ParentShowHint = False
                  ShowHint = False
                  TabOrder = 2
                  OnClick = EdtFieldClick
                  OnExit = EdtFieldExit
                  OnKeyDown = EdtFieldKeyDown
                end
                object edtsale_item_total: TNumberBox
                  Tag = 1
                  Left = 857
                  Top = 23
                  Width = 90
                  Height = 26
                  Anchors = [akTop, akRight]
                  Color = 16053492
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clGreen
                  Font.Height = -15
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  Mode = nbmFloat
                  ParentFont = False
                  ParentShowHint = False
                  ReadOnly = True
                  ShowHint = True
                  TabOrder = 4
                  OnClick = EdtFieldClick
                  OnExit = EdtFieldExit
                  OnKeyDown = EdtFieldKeyDown
                  OnKeyPress = edtsale_item_totalKeyPress
                end
              end
              object Panel15: TPanel
                AlignWithMargins = True
                Left = 0
                Top = 366
                Width = 974
                Height = 35
                Margins.Left = 0
                Margins.Top = 5
                Margins.Right = 0
                Margins.Bottom = 0
                Align = alBottom
                BevelOuter = bvNone
                Color = 16579576
                ParentBackground = False
                TabOrder = 2
                object Image1: TImage
                  AlignWithMargins = True
                  Left = 621
                  Top = 0
                  Width = 14
                  Height = 14
                  Cursor = crHandPoint
                  Hint = 
                    'Este valor cont'#233'm apenas o total dos itens. Desconto e acr'#233'scimo' +
                    ' da fatura n'#227'o contemplam este valor.'
                  Margins.Left = 0
                  Margins.Top = 0
                  Margins.Bottom = 0
                  Align = alRight
                  AutoSize = True
                  ParentShowHint = False
                  Picture.Data = {
                    0954506E67496D61676589504E470D0A1A0A0000000D494844520000000E0000
                    000E08060000001F482DD1000000017352474200AECE1CE90000000467414D41
                    0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
                    264944415478DA6D52CB6DC24010F5BA01960EA082E00E28012A000BE51629F8
                    9423708A72728872E380A9C0748252414C057107C97BD60C7A5859E9696767E7
                    CD3F247256AF1F314DD30DC429300222D00067607F78796ADC36B8F0F8F6B9C6
                    45520B54C0D5E40760698E7290AB1BD14825B003DEF1D926BD031BFED36E8EFF
                    7380829E2E8C024561464C75020C18D9A3407FC43503321237964AC64846AAAD
                    B6C41CD0696EE46FD61C5C9068F458E23D9614A77867F25E92F8EB794B3DD1C4
                    D2B2D9E27F278E6B27DEBA25E4DAC692F79CD2D1D153ADDCA318901495647AF6
                    64163C67180C7B06EC60A30EAD846E02C11E3FDA394935816E2EBA2DAEE76E1C
                    5AB00DBFF867F8D1B66AEDFDD095EB8A9695FBEAAD1CC9C5DDCA09995BB490DD
                    6C65C94FBAE47FA8149C29F5ED03410000000049454E44AE426082}
                  ShowHint = True
                  ExplicitLeft = 619
                end
                object Panel25: TPanel
                  AlignWithMargins = True
                  Left = 0
                  Top = 0
                  Width = 200
                  Height = 35
                  Margins.Left = 0
                  Margins.Top = 0
                  Margins.Right = 10
                  Margins.Bottom = 0
                  Align = alLeft
                  BevelOuter = bvNone
                  BorderWidth = 1
                  Color = 14209468
                  Enabled = False
                  ParentBackground = False
                  TabOrder = 0
                  object Panel26: TPanel
                    Left = 1
                    Top = 1
                    Width = 198
                    Height = 33
                    Align = alClient
                    BevelOuter = bvNone
                    Color = 16579576
                    ParentBackground = False
                    TabOrder = 0
                    object Label17: TLabel
                      AlignWithMargins = True
                      Left = 5
                      Top = 2
                      Width = 54
                      Height = 25
                      Margins.Left = 5
                      Margins.Top = 2
                      Margins.Right = 5
                      Margins.Bottom = 2
                      Align = alLeft
                      Caption = 'Itens:'
                      Font.Charset = ANSI_CHARSET
                      Font.Color = clGray
                      Font.Height = -21
                      Font.Name = 'Tahoma'
                      Font.Style = []
                      ParentFont = False
                      Transparent = True
                    end
                    object edtsum_sale_item_quantity: TDBEdit
                      Tag = 1
                      AlignWithMargins = True
                      Left = 64
                      Top = 2
                      Width = 129
                      Height = 29
                      Margins.Left = 0
                      Margins.Top = 2
                      Margins.Right = 5
                      Margins.Bottom = 2
                      TabStop = False
                      Align = alClient
                      BorderStyle = bsNone
                      Color = 16579576
                      DataField = 'sum_sale_item_quantity'
                      DataSource = dtsSale
                      Font.Charset = ANSI_CHARSET
                      Font.Color = clGray
                      Font.Height = -21
                      Font.Name = 'Tahoma'
                      Font.Style = [fsBold]
                      ParentFont = False
                      ParentShowHint = False
                      ReadOnly = True
                      ShowHint = False
                      TabOrder = 0
                      OnClick = EdtFieldClick
                    end
                  end
                end
                object Panel29: TPanel
                  AlignWithMargins = True
                  Left = 638
                  Top = 0
                  Width = 336
                  Height = 35
                  Margins.Left = 0
                  Margins.Top = 0
                  Margins.Right = 0
                  Margins.Bottom = 0
                  Align = alRight
                  BevelOuter = bvNone
                  BorderWidth = 1
                  Color = 14209468
                  Enabled = False
                  ParentBackground = False
                  TabOrder = 1
                  object Panel30: TPanel
                    Left = 1
                    Top = 1
                    Width = 334
                    Height = 33
                    Align = alClient
                    BevelOuter = bvNone
                    Color = 16579576
                    ParentBackground = False
                    TabOrder = 0
                    object Label6: TLabel
                      AlignWithMargins = True
                      Left = 5
                      Top = 2
                      Width = 46
                      Height = 25
                      Margins.Left = 5
                      Margins.Top = 2
                      Margins.Right = 5
                      Margins.Bottom = 2
                      Align = alLeft
                      Caption = 'Total'
                      Font.Charset = ANSI_CHARSET
                      Font.Color = clBlack
                      Font.Height = -21
                      Font.Name = 'Tahoma'
                      Font.Style = []
                      ParentFont = False
                      Transparent = True
                    end
                    object edtsum_sale_item_total: TDBEdit
                      Tag = 1
                      AlignWithMargins = True
                      Left = 56
                      Top = 2
                      Width = 273
                      Height = 29
                      Margins.Left = 0
                      Margins.Top = 2
                      Margins.Right = 5
                      Margins.Bottom = 2
                      TabStop = False
                      Align = alClient
                      BorderStyle = bsNone
                      Color = 16579576
                      DataField = 'sum_sale_item_total'
                      DataSource = dtsSale
                      Font.Charset = ANSI_CHARSET
                      Font.Color = clGreen
                      Font.Height = -21
                      Font.Name = 'Tahoma'
                      Font.Style = [fsBold]
                      ParentFont = False
                      ParentShowHint = False
                      ReadOnly = True
                      ShowHint = False
                      TabOrder = 0
                    end
                  end
                end
              end
            end
          end
        end
        object TabSheet3: TTabSheet
          Caption = '     Fatura     '
          ImageIndex = 1
          object Panel3: TPanel
            Left = 0
            Top = 0
            Width = 994
            Height = 574
            Align = alClient
            BevelOuter = bvNone
            Color = 16579576
            ParentBackground = False
            TabOrder = 0
            DesignSize = (
              994
              574)
            object Label3: TLabel
              Left = 10
              Top = 10
              Width = 102
              Height = 18
              Caption = 'Totalizadores'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label5: TLabel
              Left = 10
              Top = 34
              Width = 83
              Height = 14
              Caption = 'Total dos Itens'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label7: TLabel
              Left = 140
              Top = 34
              Width = 80
              Height = 14
              Caption = 'Desconto (R$)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label9: TLabel
              Left = 270
              Top = 34
              Width = 83
              Height = 14
              Caption = 'Acr'#233'scimo (R$)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label11: TLabel
              Left = 140
              Top = 80
              Width = 78
              Height = 14
              Caption = 'Desconto (%)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label12: TLabel
              Left = 270
              Top = 80
              Width = 81
              Height = 14
              Caption = 'Acr'#233'scimo (%)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label14: TLabel
              Left = 20
              Top = 141
              Width = 177
              Height = 18
              Caption = 'Condi'#231#227'o de Pagamento'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label16: TLabel
              Left = 10
              Top = 144
              Width = 8
              Height = 14
              Caption = '*'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Panel7: TPanel
              Left = 10
              Top = 28
              Width = 974
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 1
            end
            object edtsum_sale_item_total2: TDBEdit
              Left = 10
              Top = 49
              Width = 120
              Height = 26
              TabStop = False
              Color = 16053492
              DataField = 'sum_sale_item_total'
              DataSource = dtsSale
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 2
              OnClick = EdtFieldClick
              OnKeyDown = EdtFieldKeyDown
            end
            object edtdiscount: TDBEdit
              Left = 140
              Top = 49
              Width = 120
              Height = 26
              TabStop = False
              Color = clWhite
              DataField = 'discount'
              DataSource = dtsSale
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clOlive
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 3
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtincrease: TDBEdit
              Left = 270
              Top = 49
              Width = 120
              Height = 26
              TabStop = False
              Color = clWhite
              DataField = 'increase'
              DataSource = dtsSale
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 4
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtperc_discount: TDBEdit
              Left = 140
              Top = 95
              Width = 120
              Height = 26
              TabStop = False
              Color = clWhite
              DataField = 'perc_discount'
              DataSource = dtsSale
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clOlive
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 5
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtperc_increase: TDBEdit
              Left = 270
              Top = 95
              Width = 120
              Height = 26
              TabStop = False
              Color = clWhite
              DataField = 'perc_increase'
              DataSource = dtsSale
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 6
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object Panel8: TPanel
              Left = 410
              Top = 49
              Width = 574
              Height = 72
              BevelOuter = bvNone
              BorderWidth = 1
              Color = 14209468
              Enabled = False
              ParentBackground = False
              TabOrder = 7
              object Panel16: TPanel
                Left = 1
                Top = 1
                Width = 572
                Height = 70
                Align = alClient
                BevelOuter = bvNone
                Color = 16579576
                ParentBackground = False
                TabOrder = 0
                object edttotal: TDBEdit
                  AlignWithMargins = True
                  Left = 181
                  Top = 0
                  Width = 381
                  Height = 70
                  Margins.Left = 10
                  Margins.Top = 0
                  Margins.Right = 10
                  Margins.Bottom = 0
                  TabStop = False
                  Align = alClient
                  BorderStyle = bsNone
                  Color = 16579576
                  DataField = 'total'
                  DataSource = dtsSale
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clGreen
                  Font.Height = -53
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  ParentFont = False
                  ReadOnly = True
                  TabOrder = 0
                end
                object Panel14: TPanel
                  AlignWithMargins = True
                  Left = 10
                  Top = 0
                  Width = 161
                  Height = 63
                  Margins.Left = 10
                  Margins.Top = 0
                  Margins.Right = 0
                  Margins.Bottom = 7
                  Align = alLeft
                  BevelOuter = bvNone
                  Caption = 'Total:'
                  Color = 16579576
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = 8747344
                  Font.Height = -53
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  ParentBackground = False
                  ParentFont = False
                  TabOrder = 1
                end
              end
            end
            object Panel17: TPanel
              Left = 10
              Top = 159
              Width = 974
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 8
            end
            object Panel20: TPanel
              AlignWithMargins = True
              Left = 10
              Top = 160
              Width = 974
              Height = 404
              Margins.Left = 10
              Margins.Top = 0
              Margins.Right = 10
              Margins.Bottom = 10
              Anchors = [akLeft, akTop, akRight, akBottom]
              BevelOuter = bvNone
              Color = 16579576
              ParentBackground = False
              TabOrder = 0
              object dbgSalePayments: TDBGrid
                Left = 0
                Top = 51
                Width = 974
                Height = 313
                Cursor = crHandPoint
                Align = alClient
                Color = clWhite
                DataSource = dtsSalePayments
                DrawingStyle = gdsGradient
                FixedColor = 15131349
                GradientEndColor = 16381936
                GradientStartColor = 15920607
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -15
                Font.Name = 'Tahoma'
                Font.Style = []
                Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgTitleClick, dgTitleHotTrack]
                ParentFont = False
                TabOrder = 0
                TitleFont.Charset = DEFAULT_CHARSET
                TitleFont.Color = 8747344
                TitleFont.Height = -13
                TitleFont.Name = 'Tahoma'
                TitleFont.Style = [fsBold]
                OnCellClick = dbgSalePaymentsCellClick
                OnDrawColumnCell = dbgSalePaymentsDrawColumnCell
                OnDblClick = btnSalePaymentsEditClick
                Columns = <
                  item
                    Alignment = taCenter
                    Expanded = False
                    FieldName = 'action_edit'
                    Title.Alignment = taCenter
                    Title.Caption = ' '
                    Width = 25
                    Visible = True
                  end
                  item
                    Alignment = taCenter
                    Expanded = False
                    FieldName = 'action_delete'
                    Title.Alignment = taCenter
                    Title.Caption = ' '
                    Width = 25
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'payment_name'
                    Title.Caption = 'Pagamento'
                    Width = 316
                    Visible = True
                  end
                  item
                    Alignment = taRightJustify
                    Expanded = False
                    FieldName = 'amount'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clGreen
                    Font.Height = -15
                    Font.Name = 'Tahoma'
                    Font.Style = [fsBold]
                    Title.Caption = 'Valor'
                    Width = 120
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'due_date'
                    Title.Caption = 'Vencimento'
                    Width = 120
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'bank_account_name'
                    Title.Caption = 'Conta Banc'#225'ria'
                    Width = 200
                    Visible = True
                  end
                  item
                    Expanded = False
                    FieldName = 'note'
                    Title.Caption = 'Detalhes'
                    Width = 300
                    Visible = True
                  end>
              end
              object Panel21: TPanel
                Left = 0
                Top = 0
                Width = 974
                Height = 51
                Align = alTop
                BevelOuter = bvNone
                Color = 16579576
                ParentBackground = False
                TabOrder = 1
                DesignSize = (
                  974
                  51)
                object Label29: TLabel
                  Left = 826
                  Top = 8
                  Width = 91
                  Height = 14
                  Anchors = [akTop, akRight]
                  Caption = 'Digite o Valor R$'
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clBlack
                  Font.Height = -12
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentFont = False
                  Transparent = True
                end
                object imgsale_payment_append: TImage
                  Left = 948
                  Top = 23
                  Width = 26
                  Height = 26
                  Cursor = crHandPoint
                  Anchors = [akTop, akRight]
                  AutoSize = True
                  ParentShowHint = False
                  Picture.Data = {
                    0954506E67496D61676589504E470D0A1A0A0000000D494844520000001A0000
                    001A0806000000A94A4CCE000000017352474200AECE1CE90000000467414D41
                    0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
                    8C4944415478DA6354EBF237606060980FC4BA40CCCC407D700E8893198116DD
                    02325469600132780DB2E83F8D2D0183C165111F3B3783BDB23183388F308AF8
                    F69B47199E7E7C453D8B0A6D6318322C4230C43FFDFCCA6035259EE1F7BF3FD4
                    B16856702D83BD92315639F739590C0FDE3F1BB568385A044ACA813A4E0CACCC
                    2C70310F752B065D09EC85C7C2B39B195E7D7907E71FB87786E1CE9BC7842DB2
                    5630609817DA40D085B8C0C17B6719D2D636131774F8820A1F00E5ABA4550D0C
                    975FDC26CE2250F02D8FEE6050119625C9A2DA9DD318565DDA85550E67625010
                    9462D899328D684B4071D5B66F2E4E79BCA90E147CA06024048E3EB8C050B0A9
                    1B1C7464590402F52EE90C51869E38E541856AC892528677DF3EE2750C51F968
                    7954078391B40686F8F7DF3F194AB6F631ECB97D92A0AF89AE2636C4F73348F3
                    8BA188771F5CC830E7D47A8296106D1108A888C8326C4D9C0CE7138A7CB22D02
                    0150E228734800C747F6FA76BC914F91459400BA5A741F482BD0D89E7B208B1C
                    800C50B9C14A234BDE02710A0023AABC32C07C1C6D0000000049454E44AE4260
                    82}
                  ShowHint = False
                  OnClick = imgsale_payment_appendClick
                end
                object Label21: TLabel
                  Left = 0
                  Top = 8
                  Width = 62
                  Height = 14
                  Caption = 'Pagamento'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -12
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentFont = False
                end
                object edtpayment_term_amount: TNumberBox
                  Tag = 1
                  Left = 826
                  Top = 23
                  Width = 121
                  Height = 26
                  Anchors = [akTop, akRight]
                  Color = clWhite
                  Font.Charset = ANSI_CHARSET
                  Font.Color = clGreen
                  Font.Height = -15
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  Mode = nbmFloat
                  ParentFont = False
                  ParentShowHint = False
                  ShowHint = True
                  TabOrder = 1
                  OnClick = EdtFieldClick
                  OnEnter = EdtFieldEnter
                  OnExit = EdtFieldExit
                  OnKeyDown = EdtFieldKeyDown
                  OnKeyPress = edtpayment_term_amountKeyPress
                end
                object cbxPayment: TComboBox
                  Left = 0
                  Top = 23
                  Width = 816
                  Height = 26
                  Style = csDropDownList
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -15
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  ParentFont = False
                  TabOrder = 0
                  OnEnter = EdtFieldEnter
                  OnExit = EdtFieldExit
                  OnKeyDown = EdtFieldKeyDown
                end
              end
              object Panel24: TPanel
                AlignWithMargins = True
                Left = 0
                Top = 369
                Width = 974
                Height = 35
                Margins.Left = 0
                Margins.Top = 5
                Margins.Right = 0
                Margins.Bottom = 0
                Align = alBottom
                BevelOuter = bvNone
                Color = 16579576
                ParentBackground = False
                TabOrder = 2
                object Panel18: TPanel
                  AlignWithMargins = True
                  Left = 292
                  Top = 0
                  Width = 336
                  Height = 35
                  Margins.Left = 0
                  Margins.Top = 0
                  Margins.Right = 10
                  Margins.Bottom = 0
                  Align = alRight
                  BevelOuter = bvNone
                  BorderWidth = 1
                  Color = 14209468
                  Enabled = False
                  ParentBackground = False
                  TabOrder = 0
                  object Panel19: TPanel
                    Left = 1
                    Top = 1
                    Width = 334
                    Height = 33
                    Align = alClient
                    BevelOuter = bvNone
                    Color = 16579576
                    ParentBackground = False
                    TabOrder = 0
                    object lblChange: TLabel
                      AlignWithMargins = True
                      Left = 5
                      Top = 2
                      Width = 59
                      Height = 29
                      Margins.Left = 5
                      Margins.Top = 2
                      Margins.Right = 5
                      Margins.Bottom = 2
                      Align = alLeft
                      Caption = 'Troco:'
                      Font.Charset = ANSI_CHARSET
                      Font.Color = clBlack
                      Font.Height = -21
                      Font.Name = 'Tahoma'
                      Font.Style = []
                      ParentFont = False
                      Transparent = True
                      ExplicitHeight = 25
                    end
                    object edtchange: TDBEdit
                      Tag = 1
                      AlignWithMargins = True
                      Left = 69
                      Top = 2
                      Width = 260
                      Height = 29
                      Margins.Left = 0
                      Margins.Top = 2
                      Margins.Right = 5
                      Margins.Bottom = 2
                      TabStop = False
                      Align = alClient
                      BorderStyle = bsNone
                      Color = 16579576
                      DataField = 'remaining_change'
                      DataSource = dtsSale
                      Font.Charset = ANSI_CHARSET
                      Font.Color = clRed
                      Font.Height = -21
                      Font.Name = 'Tahoma'
                      Font.Style = [fsBold]
                      ParentFont = False
                      ParentShowHint = False
                      ReadOnly = True
                      ShowHint = False
                      TabOrder = 0
                      OnChange = edtchangeChange
                      OnClick = EdtFieldClick
                    end
                  end
                end
                object Panel22: TPanel
                  Left = 638
                  Top = 0
                  Width = 336
                  Height = 35
                  Align = alRight
                  BevelOuter = bvNone
                  BorderWidth = 1
                  Color = 14209468
                  Enabled = False
                  ParentBackground = False
                  TabOrder = 1
                  object Panel23: TPanel
                    Left = 1
                    Top = 1
                    Width = 334
                    Height = 33
                    Align = alClient
                    BevelOuter = bvNone
                    Color = 16579576
                    ParentBackground = False
                    TabOrder = 0
                    object Label20: TLabel
                      AlignWithMargins = True
                      Left = 5
                      Top = 2
                      Width = 108
                      Height = 29
                      Margins.Left = 5
                      Margins.Top = 2
                      Margins.Right = 5
                      Margins.Bottom = 2
                      Align = alLeft
                      Caption = 'Valor Pago:'
                      Font.Charset = ANSI_CHARSET
                      Font.Color = clBlack
                      Font.Height = -21
                      Font.Name = 'Tahoma'
                      Font.Style = []
                      ParentFont = False
                      Transparent = True
                      ExplicitHeight = 25
                    end
                    object edtsum_sale_payment_amount: TDBEdit
                      Tag = 1
                      AlignWithMargins = True
                      Left = 118
                      Top = 2
                      Width = 211
                      Height = 29
                      Margins.Left = 0
                      Margins.Top = 2
                      Margins.Right = 5
                      Margins.Bottom = 2
                      TabStop = False
                      Align = alClient
                      BorderStyle = bsNone
                      Color = 16579576
                      DataField = 'sum_sale_payment_amount'
                      DataSource = dtsSale
                      Font.Charset = ANSI_CHARSET
                      Font.Color = clGreen
                      Font.Height = -21
                      Font.Name = 'Tahoma'
                      Font.Style = [fsBold]
                      ParentFont = False
                      ParentShowHint = False
                      ReadOnly = True
                      ShowHint = False
                      TabOrder = 0
                      OnClick = EdtFieldClick
                    end
                  end
                end
                object Panel27: TPanel
                  AlignWithMargins = True
                  Left = 0
                  Top = 0
                  Width = 170
                  Height = 35
                  Cursor = crHandPoint
                  Margins.Left = 0
                  Margins.Top = 0
                  Margins.Right = 10
                  Margins.Bottom = 0
                  Align = alLeft
                  BevelOuter = bvNone
                  BorderWidth = 1
                  Color = 8747344
                  ParentBackground = False
                  TabOrder = 2
                  object Panel28: TPanel
                    Left = 1
                    Top = 1
                    Width = 168
                    Height = 33
                    Cursor = crHandPoint
                    Align = alClient
                    BevelOuter = bvNone
                    Color = 15658211
                    ParentBackground = False
                    TabOrder = 0
                    object btnDeleteAllSalePayments: TSpeedButton
                      Left = 38
                      Top = 0
                      Width = 130
                      Height = 33
                      Cursor = crHandPoint
                      Align = alClient
                      Caption = 'Limpar'
                      Flat = True
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = 8747344
                      Font.Height = -13
                      Font.Name = 'Tahoma'
                      Font.Style = [fsBold]
                      ParentFont = False
                      OnClick = btnDeleteAllSalePaymentsClick
                      ExplicitTop = 2
                      ExplicitHeight = 38
                    end
                    object Panel31: TPanel
                      Left = 0
                      Top = 0
                      Width = 38
                      Height = 33
                      Align = alLeft
                      BevelOuter = bvNone
                      Color = 12893085
                      ParentBackground = False
                      TabOrder = 0
                      object Image2: TImage
                        AlignWithMargins = True
                        Left = 5
                        Top = 5
                        Width = 25
                        Height = 23
                        Cursor = crHandPoint
                        Margins.Left = 5
                        Margins.Top = 5
                        Margins.Right = 5
                        Margins.Bottom = 5
                        Align = alLeft
                        Center = True
                        Picture.Data = {
                          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000190000
                          00190806000000C4E98563000000017352474200AECE1CE90000000467414D41
                          0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
                          BE4944415478DAB5968159C23014849B096404D8A03841994099403B81324165
                          027002D8409C806E001B8013E004D43BB8E82396520AE4FBF23D4A93FCC9BDCB
                          03175DD08AA26821BC38E78655E3DC85900CE18DBD0AD41802401B61A1C70E20
                          DFB7804C109ED107008CAF2ED776BB4DB0F01C1F9788DD53E31B41700A0212F4
                          1E20F9D52100BC228CD06700F4EBCC390B22CBAEF4C8532C6F01A965D9C61000
                          6204E68256ED5659F61288B76C0AC0F41C058E42A47FAC7E279972007AE7008E
                          4200E08EE9A056F0AAB6A32A21C6A2D49CB27CE92404B7D1C7000D1A434C3D6A
                          19C89049967C0B8158ABD6FA6E5EB26E6AED1D4278029E248FF637DA37D6A677
                          F4A7689F9B5DBD1264530239A804CE00FC45FBB5A8A4CB4C6EB8BB38324551F3
                          FE4B642C6E218F081F659ACB0899A4623BB88C92392E01CD4288BFCD7DFF326C
                          189328070756361B0C212E8470100777B4AB07E621AC4F18B7927C9474ADEFFC
                          F810320C21744E4CBAE4999804EFCA09EF4893FA65212BD13BE6F8533CA77AD7
                          D62999D08D31C8DAAC31921AB6E516E2ADD8951C0BBF902672811C3D8DFEACCC
                          5FC67B4ED71ABEBE1D8514758E5ED24ED6330B19452536ACD13E4FFD91F801B4
                          BFE472EF0833320000000049454E44AE426082}
                        ExplicitTop = 4
                        ExplicitHeight = 28
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
    inherited pnlTitle: TPanel
      Width = 1022
      ExplicitWidth = 1022
      inherited imgTitle: TImage
        Width = 25
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000190000
          00190806000000C4E98563000000017352474200AECE1CE90000000467414D41
          0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
          6E4944415478DAB5968D51C3300C85EDCB008409081B9409683768364827A04C
          4098806C4037A04CD032016C403B011E2097A0D79339135CFF1EBAF3B9499EFC
          45B2A5548EE3580A21EE686076D99B94723BBDC9FE331E17348EA4DB981A49A2
          35CD4F22CCAE69818301C0C2CF0C985AAD5F0A1000D681901B72FC604045D3BB
          270327500E0411341EBD22FD651284F7E153F8F711B64A85CC385521D6E644F2
          15E8D3E5EC09D25505F8D4399007A4C2A3DF937E910C61D08EA6F919ADA2B180
          1E90255DBC0400E0846254E64D4B31E3395E64A50B57B2B00CC8EF610A98C0E0
          5FDA7432304D59F6076244A5CC3EE5D079A3FF81F47D5F1545816EDC88DF95FC
          48C2D60208ADF85AEF092A78E7703A1D45031253F19D86B88EA2B67B02754990
          98238C8E9A0A89FE68A540FEBB0BC7A58B23512990D0B6BD25408D1FA9A7CB19
          0D3DC73F90B92ECE24086C1886252D6203ED85D1EC1812F3D16A6D6DA5A1E98A
          2F5FC599C6C82F75EB011C696CBE016BDCF402CC34BF930000000049454E44AE
          426082}
        ExplicitLeft = 10
        ExplicitTop = 10
        ExplicitWidth = 25
        ExplicitHeight = 25
      end
      inherited lblTitle: TLabel
        Left = 45
        Width = 123
        Height = 40
        Caption = 'Pagamento'
        ExplicitLeft = 45
        ExplicitWidth = 123
      end
      inherited imgCloseTitle: TImage
        Left = 987
        OnClick = btnCancelClick
        ExplicitLeft = 563
      end
      inherited imgMinimizeTitle: TImage
        Left = 952
        ExplicitLeft = 528
      end
    end
  end
  object dtsSale: TDataSource [2]
    Left = 603
    Top = 1
  end
  object dtsSaleItems: TDataSource
    Left = 665
    Top = 1
  end
  object dtsSalePayments: TDataSource
    Left = 753
    Top = 1
  end
end
