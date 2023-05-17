inherited BillPayReceiveInputView: TBillPayReceiveInputView
  ClientHeight = 542
  ClientWidth = 1024
  OnShow = FormShow
  ExplicitWidth = 1024
  ExplicitHeight = 542
  TextHeight = 13
  inherited pnlBackground: TPanel
    Width = 1024
    Height = 542
    ExplicitWidth = 600
    ExplicitHeight = 600
    inherited pnlBackground2: TPanel
      Width = 1022
      Height = 495
      ExplicitWidth = 598
      ExplicitHeight = 553
      inherited imgNoSearch: TSkAnimatedImage
        Width = 922
        Height = 345
        ExplicitWidth = 498
        ExplicitHeight = 403
      end
      inherited pnlBottomButtons: TPanel
        Top = 445
        Width = 1002
        ExplicitTop = 503
        ExplicitWidth = 578
        inherited pnlSave: TPanel
          Left = 832
          ExplicitLeft = 408
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
          ExplicitLeft = 228
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
        Height = 425
        ExplicitWidth = 578
        ExplicitHeight = 483
        inherited tabMain: TTabSheet
          ExplicitWidth = 994
          ExplicitHeight = 396
          inherited pnlMain: TPanel
            Width = 994
            Height = 396
            ExplicitWidth = 570
            ExplicitHeight = 454
            object Label22: TLabel
              Left = 10
              Top = 10
              Width = 43
              Height = 18
              Caption = 'T'#237'tulo'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label35: TLabel
              Left = 10
              Top = 32
              Width = 12
              Height = 14
              Caption = 'ID'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label3: TLabel
              Left = 190
              Top = 32
              Width = 51
              Height = 14
              Caption = 'Descri'#231#227'o'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label5: TLabel
              Left = 180
              Top = 32
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
              Left = 79
              Top = 31
              Width = 24
              Height = 14
              Caption = 'Tipo'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label37: TLabel
              Left = 10
              Top = 80
              Width = 275
              Height = 14
              Caption = 'F1 - Pessoa (Cliente, Fornecedor, Colaborador, ...)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label1: TLabel
              Left = 606
              Top = 31
              Width = 108
              Height = 14
              Caption = 'F1 - Plano de Conta'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label2: TLabel
              Left = 606
              Top = 80
              Width = 115
              Height = 14
              Caption = 'F1 - Centro de Custo'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label6: TLabel
              Left = 20
              Top = 162
              Width = 105
              Height = 14
              Caption = 'F1 - Conta Banc'#225'ria'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label7: TLabel
              Left = 20
              Top = 211
              Width = 87
              Height = 14
              Caption = 'F1 - Pagamento'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label8: TLabel
              Left = 20
              Top = 257
              Width = 66
              Height = 14
              Caption = 'Vencimento'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label9: TLabel
              Left = 10
              Top = 257
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
            object Label14: TLabel
              Left = 298
              Top = 257
              Width = 88
              Height = 14
              Caption = 'Valor de Origem'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label15: TLabel
              Left = 288
              Top = 257
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
            object Label16: TLabel
              Left = 429
              Top = 257
              Width = 70
              Height = 14
              Caption = 'Desconto (-)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label20: TLabel
              Left = 570
              Top = 257
              Width = 84
              Height = 14
              Caption = 'Juros/Multa (+)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label17: TLabel
              Left = 721
              Top = 257
              Width = 80
              Height = 14
              Caption = 'Valor L'#237'quido'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label21: TLabel
              Left = 711
              Top = 257
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
            object Label23: TLabel
              Left = 10
              Top = 339
              Width = 35
              Height = 14
              Caption = 'Status'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label24: TLabel
              Left = 150
              Top = 339
              Width = 109
              Height = 14
              Caption = 'Data do Pagamento'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label25: TLabel
              Left = 429
              Top = 162
              Width = 63
              Height = 14
              Caption = 'Observa'#231#227'o'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label26: TLabel
              Left = 70
              Top = 31
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
            object Label27: TLabel
              Left = 10
              Top = 162
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
            object Label28: TLabel
              Left = 10
              Top = 211
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
            object Label29: TLabel
              Left = 10
              Top = 141
              Width = 60
              Height = 18
              Caption = 'FATURA'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label30: TLabel
              Left = 10
              Top = 318
              Width = 59
              Height = 18
              Caption = 'STATUS'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label12: TLabel
              Left = 160
              Top = 257
              Width = 102
              Height = 14
              Caption = 'N'#250'mero da Parcela'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label13: TLabel
              Left = 150
              Top = 257
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
            object Label10: TLabel
              Left = 205
              Top = 275
              Width = 18
              Height = 18
              Caption = 'de'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
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
              TabOrder = 23
            end
            object edtId: TDBEdit
              Left = 10
              Top = 47
              Width = 50
              Height = 26
              TabStop = False
              Color = 16053492
              DataField = 'id'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Calibri'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 0
              OnClick = EdtFieldClick
              OnKeyDown = EdtFieldKeyDown
            end
            object edtshort_description: TDBEdit
              Left = 180
              Top = 47
              Width = 416
              Height = 26
              DataField = 'short_description'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 2
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object cbxType: TJvDBComboBox
              Left = 70
              Top = 47
              Width = 100
              Height = 26
              DataField = 'type'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              Items.Strings = (
                'D'#233'bito'
                'Cr'#233'dito')
              ParentFont = False
              TabOrder = 1
              UpdateFieldImmediatelly = True
              Values.Strings = (
                '0'
                '1')
              ListSettings.OutfilteredValueFont.Charset = DEFAULT_CHARSET
              ListSettings.OutfilteredValueFont.Color = clRed
              ListSettings.OutfilteredValueFont.Height = -11
              ListSettings.OutfilteredValueFont.Name = 'Tahoma'
              ListSettings.OutfilteredValueFont.Style = []
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtperson_name: TDBEdit
              Left = 88
              Top = 95
              Width = 508
              Height = 26
              Color = 16053492
              DataField = 'person_name'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 6
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
              TabOrder = 24
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
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
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
            object edtchart_of_account_name: TDBEdit
              Left = 684
              Top = 46
              Width = 300
              Height = 26
              Color = 16053492
              DataField = 'chart_of_account_name'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 4
              OnKeyDown = EdtFieldKeyDown
            end
            object Panel1: TPanel
              Left = 606
              Top = 46
              Width = 26
              Height = 26
              Cursor = crHandPoint
              BevelOuter = bvNone
              BorderWidth = 1
              Color = 5327153
              ParentBackground = False
              TabOrder = 25
              object Panel2: TPanel
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
                object imgLocaChartOfAccount: TImage
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
                  OnClick = imgLocaChartOfAccountClick
                  ExplicitTop = 14
                end
              end
            end
            object edtchart_of_account_id: TDBEdit
              Left = 633
              Top = 46
              Width = 50
              Height = 26
              DataField = 'chart_of_account_id'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
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
            object edtcost_center_name: TDBEdit
              Left = 684
              Top = 94
              Width = 300
              Height = 26
              Color = 16053492
              DataField = 'cost_center_name'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 8
              OnKeyDown = EdtFieldKeyDown
            end
            object Panel3: TPanel
              Left = 606
              Top = 94
              Width = 26
              Height = 26
              Cursor = crHandPoint
              BevelOuter = bvNone
              BorderWidth = 1
              Color = 5327153
              ParentBackground = False
              TabOrder = 26
              object Panel4: TPanel
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
                object imgLocaCostCenter: TImage
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
                  OnClick = imgLocaCostCenterClick
                  ExplicitTop = 14
                end
              end
            end
            object edtcost_center_id: TDBEdit
              Left = 633
              Top = 94
              Width = 50
              Height = 26
              DataField = 'cost_center_id'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 7
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtbank_account_name: TDBEdit
              Left = 88
              Top = 177
              Width = 331
              Height = 26
              Color = 16053492
              DataField = 'bank_account_name'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 10
              OnKeyDown = EdtFieldKeyDown
            end
            object Panel6: TPanel
              Left = 10
              Top = 177
              Width = 26
              Height = 26
              Cursor = crHandPoint
              BevelOuter = bvNone
              BorderWidth = 1
              Color = 5327153
              ParentBackground = False
              TabOrder = 27
              object Panel7: TPanel
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
                object imgLocaBankAccount: TImage
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
                  OnClick = imgLocaBankAccountClick
                  ExplicitTop = 14
                end
              end
            end
            object edtbank_account_id: TDBEdit
              Left = 37
              Top = 177
              Width = 50
              Height = 26
              DataField = 'bank_account_id'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 9
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtpayment_name: TDBEdit
              Left = 88
              Top = 226
              Width = 331
              Height = 26
              Color = 16053492
              DataField = 'payment_name'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 12
              OnKeyDown = EdtFieldKeyDown
            end
            object Panel8: TPanel
              Left = 10
              Top = 226
              Width = 26
              Height = 26
              Cursor = crHandPoint
              BevelOuter = bvNone
              BorderWidth = 1
              Color = 5327153
              ParentBackground = False
              TabOrder = 28
              object Panel9: TPanel
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
                object imgLocaPayment: TImage
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
                  OnClick = imgLocaPaymentClick
                  ExplicitTop = 14
                end
              end
            end
            object edtpayment_id: TDBEdit
              Left = 37
              Top = 226
              Width = 50
              Height = 26
              DataField = 'payment_id'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 11
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtdue_date: TJvDBDateEdit
              Left = 10
              Top = 272
              Width = 130
              Height = 26
              DataField = 'due_date'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ShowNullDate = False
              TabOrder = 14
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtinstallment_quantity: TDBEdit
              Left = 228
              Top = 272
              Width = 50
              Height = 26
              DataField = 'installment_quantity'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 16
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtamount: TDBEdit
              Left = 288
              Top = 272
              Width = 131
              Height = 26
              DataField = 'amount'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 17
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtdiscount: TDBEdit
              Left = 429
              Top = 272
              Width = 131
              Height = 26
              DataField = 'discount'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 18
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtinterest_and_fine: TDBEdit
              Left = 570
              Top = 272
              Width = 131
              Height = 26
              DataField = 'interest_and_fine'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 19
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtnet_amount: TDBEdit
              Left = 711
              Top = 272
              Width = 131
              Height = 26
              Color = 16053492
              DataField = 'net_amount'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 20
              OnKeyDown = EdtFieldKeyDown
            end
            object JvDBComboBox2: TJvDBComboBox
              Left = 10
              Top = 354
              Width = 130
              Height = 26
              DataField = 'status'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              Items.Strings = (
                'Pendente'
                'Conclu'#237'do'
                'Cancelado')
              ParentFont = False
              TabOrder = 21
              UpdateFieldImmediatelly = True
              Values.Strings = (
                '0'
                '1'
                '2')
              ListSettings.OutfilteredValueFont.Charset = DEFAULT_CHARSET
              ListSettings.OutfilteredValueFont.Color = clRed
              ListSettings.OutfilteredValueFont.Height = -11
              ListSettings.OutfilteredValueFont.Name = 'Tahoma'
              ListSettings.OutfilteredValueFont.Style = []
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object JvDBDateEdit2: TJvDBDateEdit
              Left = 150
              Top = 354
              Width = 130
              Height = 26
              DataField = 'payment_date'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ShowNullDate = False
              TabOrder = 22
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object DBMemo1: TDBMemo
              Left = 429
              Top = 177
              Width = 555
              Height = 75
              TabStop = False
              DataField = 'note'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 13
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
            end
            object Panel10: TPanel
              Left = 10
              Top = 159
              Width = 974
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 29
            end
            object Panel11: TPanel
              Left = 10
              Top = 336
              Width = 974
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 30
            end
            object edtinstallment_number: TDBEdit
              Left = 150
              Top = 272
              Width = 50
              Height = 26
              DataField = 'installment_number'
              DataSource = dtsBillPayReceive
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 15
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
          end
        end
      end
    end
    inherited pnlTitle: TPanel
      Width = 1022
      ExplicitWidth = 598
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
        Width = 264
        Caption = 'Contas a Pagar/Receber'
        ExplicitLeft = 45
        ExplicitWidth = 264
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
  object dtsBillPayReceive: TDataSource [2]
    Left = 619
    Top = 1
  end
end
