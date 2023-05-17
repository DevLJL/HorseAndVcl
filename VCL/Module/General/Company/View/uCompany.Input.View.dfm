inherited CompanyInputView: TCompanyInputView
  ClientHeight = 695
  ClientWidth = 1024
  OnShow = FormShow
  ExplicitWidth = 1024
  ExplicitHeight = 695
  TextHeight = 13
  inherited pnlBackground: TPanel
    Width = 1024
    Height = 695
    ExplicitWidth = 1024
    ExplicitHeight = 550
    inherited pnlBackground2: TPanel
      Width = 1022
      Height = 648
      ExplicitWidth = 1022
      ExplicitHeight = 503
      inherited imgNoSearch: TSkAnimatedImage
        Width = 922
        Height = 498
        ExplicitWidth = 922
        ExplicitHeight = 353
      end
      inherited pnlBottomButtons: TPanel
        Top = 598
        Width = 1002
        ExplicitTop = 453
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
        Height = 578
        ActivePage = TabSheet1
        ExplicitWidth = 1002
        ExplicitHeight = 433
        inherited tabMain: TTabSheet
          ExplicitWidth = 994
          ExplicitHeight = 549
          inherited pnlMain: TPanel
            Width = 994
            Height = 549
            ExplicitWidth = 994
            ExplicitHeight = 404
            object Label35: TLabel
              Left = 10
              Top = 34
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
            object Label1: TLabel
              Left = 10
              Top = 10
              Width = 116
              Height = 18
              Caption = 'Ficha Cadastral'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label15: TLabel
              Left = 66
              Top = 34
              Width = 77
              Height = 14
              Caption = 'F1 - CPF/CNPJ'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label4: TLabel
              Left = 492
              Top = 34
              Width = 39
              Height = 14
              Caption = 'RG / IE'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label16: TLabel
              Left = 672
              Top = 34
              Width = 99
              Height = 14
              Caption = 'Inscri'#231#227'o Municipal'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label3: TLabel
              Left = 20
              Top = 82
              Width = 110
              Height = 14
              Caption = 'Nome / Raz'#227'o Social'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label5: TLabel
              Left = 10
              Top = 82
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
            object Label6: TLabel
              Left = 492
              Top = 82
              Width = 96
              Height = 14
              Caption = 'Apelido / Fantasia'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label2: TLabel
              Left = 10
              Top = 143
              Width = 69
              Height = 18
              Caption = 'Endere'#231'o'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label21: TLabel
              Left = 10
              Top = 168
              Width = 46
              Height = 14
              Caption = 'F1 - Cep'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label7: TLabel
              Left = 156
              Top = 168
              Width = 52
              Height = 14
              Caption = 'Endere'#231'o'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label18: TLabel
              Left = 672
              Top = 168
              Width = 43
              Height = 14
              Caption = 'N'#250'mero'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label19: TLabel
              Left = 752
              Top = 168
              Width = 76
              Height = 14
              Caption = 'Complemento'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label20: TLabel
              Left = 20
              Top = 217
              Width = 30
              Height = 14
              Caption = 'Bairro'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label23: TLabel
              Left = 333
              Top = 217
              Width = 61
              Height = 14
              Caption = 'F1 - Cidade'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label24: TLabel
              Left = 672
              Top = 217
              Width = 112
              Height = 14
              Caption = 'Ponto de Refer'#234'ncia'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label25: TLabel
              Left = 632
              Top = 217
              Width = 14
              Height = 14
              Caption = 'UF'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label8: TLabel
              Left = 10
              Top = 278
              Width = 58
              Height = 18
              Caption = 'Contato'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label27: TLabel
              Left = 20
              Top = 302
              Width = 49
              Height = 14
              Caption = 'Telefone'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label28: TLabel
              Left = 170
              Top = 302
              Width = 60
              Height = 14
              Caption = 'Telefone 2'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label29: TLabel
              Left = 330
              Top = 302
              Width = 60
              Height = 14
              Caption = 'Telefone 3'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label30: TLabel
              Left = 492
              Top = 302
              Width = 103
              Height = 14
              Caption = 'P'#225'gina de Internet'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label31: TLabel
              Left = 10
              Top = 351
              Width = 31
              Height = 14
              Caption = 'E-mail'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label32: TLabel
              Left = 492
              Top = 351
              Width = 90
              Height = 14
              Caption = 'E-mail (Finan'#231'as)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label9: TLabel
              Left = 146
              Top = 168
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
              Left = 324
              Top = 217
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
            object Label11: TLabel
              Left = 10
              Top = 302
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
            object Label12: TLabel
              Left = 10
              Top = 217
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
            object edtId: TDBEdit
              Left = 10
              Top = 49
              Width = 50
              Height = 26
              TabStop = False
              Color = 16053492
              DataField = 'id'
              DataSource = dtsCompany
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
            object Panel1: TPanel
              Left = 10
              Top = 28
              Width = 974
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 1
            end
            object edtlegal_entity_number: TDBEdit
              Left = 66
              Top = 48
              Width = 170
              Height = 26
              DataField = 'legal_entity_number'
              DataSource = dtsCompany
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
            object edtstate_registration: TDBEdit
              Left = 492
              Top = 49
              Width = 170
              Height = 26
              DataField = 'state_registration'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 3
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtmunicipal_registration: TDBEdit
              Left = 672
              Top = 49
              Width = 170
              Height = 26
              DataField = 'municipal_registration'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 4
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object Panel26: TPanel
              Left = 237
              Top = 48
              Width = 26
              Height = 26
              Cursor = crHandPoint
              BevelOuter = bvNone
              BorderWidth = 1
              Color = 5327153
              ParentBackground = False
              TabOrder = 5
              object Panel27: TPanel
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
                object imgLocaLegalNumberEntity: TImage
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
                  OnClick = imgLocaLegalNumberEntityClick
                  ExplicitLeft = 4
                  ExplicitTop = 16
                end
              end
            end
            object loadLegalEntityNumber: TActivityIndicator
              Left = 211
              Top = 49
              IndicatorSize = aisSmall
              IndicatorType = aitRotatingSector
            end
            object rdgicms_taxpayer: TDBRadioGroup
              Left = 277
              Top = 34
              Width = 205
              Height = 41
              Caption = '  Contribuinte de ICMS?  '
              Columns = 3
              DataField = 'icms_taxpayer'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              Items.Strings = (
                'N'#227'o'
                'Sim'
                'Isento')
              ParentFont = False
              TabOrder = 7
              Values.Strings = (
                '0'
                '1'
                '2')
            end
            object edtname: TDBEdit
              Left = 10
              Top = 97
              Width = 472
              Height = 26
              DataField = 'name'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 8
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtalias_name: TDBEdit
              Left = 492
              Top = 97
              Width = 492
              Height = 26
              DataField = 'alias_name'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 9
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object Panel2: TPanel
              Left = 10
              Top = 161
              Width = 974
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 10
            end
            object edtzipcode: TDBEdit
              Left = 10
              Top = 183
              Width = 99
              Height = 26
              DataField = 'zipcode'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 11
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtaddress: TDBEdit
              Left = 146
              Top = 183
              Width = 516
              Height = 26
              DataField = 'address'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 12
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object Panel7: TPanel
              Left = 110
              Top = 183
              Width = 26
              Height = 26
              Cursor = crHandPoint
              BevelOuter = bvNone
              BorderWidth = 1
              Color = 5327153
              ParentBackground = False
              TabOrder = 13
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
                object imgLocaZipcode: TImage
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
                  OnClick = imgLocaZipcodeClick
                  ExplicitLeft = 4
                  ExplicitTop = 16
                end
              end
            end
            object edtaddress_number: TDBEdit
              Left = 672
              Top = 183
              Width = 70
              Height = 26
              DataField = 'address_number'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 14
              OnClick = EdtFieldClick
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtcomplement: TDBEdit
              Left = 752
              Top = 183
              Width = 232
              Height = 26
              DataField = 'complement'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 15
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtdistrict: TDBEdit
              Left = 10
              Top = 232
              Width = 303
              Height = 26
              DataField = 'district'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 16
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtcity_id: TDBEdit
              Left = 350
              Top = 232
              Width = 50
              Height = 26
              DataField = 'city_id'
              DataSource = dtsCompany
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
            object Panel10: TPanel
              Left = 323
              Top = 232
              Width = 26
              Height = 26
              Cursor = crHandPoint
              BevelOuter = bvNone
              BorderWidth = 1
              Color = 5327153
              ParentBackground = False
              TabOrder = 18
              object Panel12: TPanel
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
                object imgLocaCity: TImage
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
                  OnClick = imgLocaCityClick
                  ExplicitTop = 14
                end
              end
            end
            object edtcity_name: TDBEdit
              Left = 401
              Top = 232
              Width = 230
              Height = 26
              Color = 16053492
              DataField = 'city_name'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 19
              OnKeyDown = EdtFieldKeyDown
            end
            object edtcity_state: TDBEdit
              Left = 632
              Top = 232
              Width = 30
              Height = 26
              Color = 16053492
              DataField = 'city_state'
              DataSource = dtsCompany
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
            object edtreference_point: TDBEdit
              Left = 672
              Top = 232
              Width = 312
              Height = 26
              DataField = 'reference_point'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 21
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object Panel3: TPanel
              Left = 10
              Top = 296
              Width = 974
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 22
            end
            object edtphone_1: TDBEdit
              Left = 10
              Top = 317
              Width = 150
              Height = 26
              DataField = 'phone_1'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 23
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtphone_2: TDBEdit
              Left = 170
              Top = 317
              Width = 150
              Height = 26
              DataField = 'phone_2'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 24
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtphone_3: TDBEdit
              Left = 330
              Top = 317
              Width = 152
              Height = 26
              DataField = 'phone_3'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 25
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtinternet_page: TDBEdit
              Left = 492
              Top = 317
              Width = 492
              Height = 26
              DataField = 'internet_page'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 26
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtcompany_email: TDBEdit
              Left = 10
              Top = 366
              Width = 472
              Height = 26
              DataField = 'company_email'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 27
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtfinancial_email: TDBEdit
              Left = 492
              Top = 366
              Width = 492
              Height = 26
              DataField = 'financial_email'
              DataSource = dtsCompany
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 28
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object loadZipCode: TActivityIndicator
              Left = 85
              Top = 184
              IndicatorSize = aisSmall
              IndicatorType = aitRotatingSector
            end
          end
        end
        object TabSheet1: TTabSheet
          Caption = '     E-mail     '
          ImageIndex = 1
          object Panel29: TPanel
            Left = 0
            Top = 0
            Width = 994
            Height = 549
            Align = alClient
            BevelOuter = bvNone
            Color = 16579576
            ParentBackground = False
            TabOrder = 0
            ExplicitHeight = 548
            object Panel30: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 10
              Width = 984
              Height = 25
              Margins.Left = 5
              Margins.Top = 10
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              BevelOuter = bvNone
              BorderWidth = 5
              Color = 16579576
              ParentBackground = False
              TabOrder = 0
              ExplicitWidth = 1008
              object Label13: TLabel
                Left = 5
                Top = 1
                Width = 278
                Height = 18
                Caption = 'Configura'#231#227'o para disparo de e-mails'
                Color = 16513782
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 8747344
                Font.Height = -15
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentColor = False
                ParentFont = False
              end
              object Panel31: TPanel
                Left = 5
                Top = 19
                Width = 974
                Height = 1
                Align = alBottom
                BevelOuter = bvNone
                Color = 14209468
                ParentBackground = False
                TabOrder = 0
                ExplicitWidth = 998
              end
              object chksend_email_app_default: TDBCheckBox
                Left = 768
                Top = 2
                Width = 211
                Height = 17
                Caption = 'Utilizar configura'#231#227'o interna do app.'
                DataField = 'send_email_app_default'
                DataSource = dtsCompany
                TabOrder = 1
                ValueChecked = '1'
                ValueUnchecked = '0'
                OnClick = chksend_email_app_defaultClick
              end
            end
            object pnlEmailConfiguration: TPanel
              AlignWithMargins = True
              Left = 10
              Top = 40
              Width = 974
              Height = 133
              Margins.Left = 10
              Margins.Top = 0
              Margins.Right = 10
              Margins.Bottom = 10
              Align = alTop
              BevelOuter = bvNone
              Color = 16579576
              ParentBackground = False
              TabOrder = 1
              ExplicitWidth = 998
              object Label14: TLabel
                Left = 10
                Top = 0
                Width = 31
                Height = 14
                Caption = 'E-mail'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = 'Tahoma'
                Font.Style = []
                ParentFont = False
              end
              object Label17: TLabel
                Left = 10
                Top = 46
                Width = 316
                Height = 14
                Caption = 'Usu'#225'rio (IMAP deve estar ativo na configura'#231#227'o do e-mail)'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = 'Tahoma'
                Font.Style = []
                ParentFont = False
              end
              object Label22: TLabel
                Left = 370
                Top = 46
                Width = 34
                Height = 14
                Caption = 'Senha'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = 'Tahoma'
                Font.Style = []
                ParentFont = False
              end
              object Label26: TLabel
                Left = 10
                Top = 92
                Width = 79
                Height = 14
                Caption = 'Servidor SMTP'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = 'Tahoma'
                Font.Style = []
                ParentFont = False
              end
              object Label33: TLabel
                Left = 370
                Top = 92
                Width = 29
                Height = 14
                Caption = 'Porta'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = 'Tahoma'
                Font.Style = []
                ParentFont = False
              end
              object Label39: TLabel
                Left = 0
                Top = 0
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
              object Label40: TLabel
                Left = 0
                Top = 46
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
              object Label41: TLabel
                Left = 0
                Top = 92
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
              object Label43: TLabel
                Left = 360
                Top = 46
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
              object Label44: TLabel
                Left = 360
                Top = 92
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
              object DBEdit1: TDBEdit
                Left = 0
                Top = 15
                Width = 350
                Height = 26
                DataField = 'send_email_email'
                DataSource = dtsCompany
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
              object DBEdit3: TDBEdit
                Left = 0
                Top = 61
                Width = 350
                Height = 26
                DataField = 'send_email_user'
                DataSource = dtsCompany
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -15
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 1
                OnEnter = EdtFieldEnter
                OnExit = EdtFieldExit
                OnKeyDown = EdtFieldKeyDown
              end
              object DBEdit4: TDBEdit
                Left = 360
                Top = 61
                Width = 350
                Height = 26
                DataField = 'send_email_password'
                DataSource = dtsCompany
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -15
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
                PasswordChar = '*'
                TabOrder = 2
                OnEnter = EdtFieldEnter
                OnExit = EdtFieldExit
                OnKeyDown = EdtFieldKeyDown
              end
              object DBEdit5: TDBEdit
                Left = 0
                Top = 107
                Width = 350
                Height = 26
                DataField = 'send_email_smtp'
                DataSource = dtsCompany
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -15
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 3
                OnEnter = EdtFieldEnter
                OnExit = EdtFieldExit
                OnKeyDown = EdtFieldKeyDown
              end
              object DBEdit6: TDBEdit
                Left = 360
                Top = 107
                Width = 50
                Height = 26
                DataField = 'send_email_port'
                DataSource = dtsCompany
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -15
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 4
                OnEnter = EdtFieldEnter
                OnExit = EdtFieldExit
                OnKeyDown = EdtFieldKeyDown
              end
              object RadioGroup1: TRadioGroup
                Left = 431
                Top = 92
                Width = 144
                Height = 41
                Caption = ' Tipo de autentica'#231#227'o '
                TabOrder = 5
              end
              object DBCheckBox2: TDBCheckBox
                Left = 442
                Top = 113
                Width = 41
                Height = 17
                Caption = 'SSL'
                DataField = 'send_email_ssl'
                DataSource = dtsCompany
                TabOrder = 6
                ValueChecked = '1'
                ValueUnchecked = '0'
              end
              object DBCheckBox3: TDBCheckBox
                Left = 498
                Top = 113
                Width = 41
                Height = 17
                Caption = 'TLS'
                DataField = 'send_email_tls'
                DataSource = dtsCompany
                TabOrder = 7
                ValueChecked = '1'
                ValueUnchecked = '0'
              end
            end
            object Panel33: TPanel
              AlignWithMargins = True
              Left = 5
              Top = 244
              Width = 984
              Height = 25
              Margins.Left = 5
              Margins.Top = 10
              Margins.Right = 5
              Margins.Bottom = 5
              Align = alTop
              BevelOuter = bvNone
              BorderWidth = 5
              Color = 16579576
              ParentBackground = False
              TabOrder = 2
              ExplicitWidth = 1008
              object Label34: TLabel
                Left = 5
                Top = 1
                Width = 220
                Height = 18
                Caption = 'Mensagem no corpo do e-mail'
                Color = 16513782
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 8747344
                Font.Height = -15
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentColor = False
                ParentFont = False
              end
              object Panel34: TPanel
                Left = 5
                Top = 19
                Width = 974
                Height = 1
                Align = alBottom
                BevelOuter = bvNone
                Color = 14209468
                ParentBackground = False
                TabOrder = 0
                ExplicitWidth = 998
              end
            end
            object Panel35: TPanel
              AlignWithMargins = True
              Left = 10
              Top = 183
              Width = 974
              Height = 41
              Margins.Left = 10
              Margins.Top = 0
              Margins.Right = 10
              Margins.Bottom = 10
              Align = alTop
              BevelOuter = bvNone
              Color = 16579576
              ParentBackground = False
              TabOrder = 3
              ExplicitWidth = 998
              object Label36: TLabel
                Left = 360
                Top = 0
                Width = 102
                Height = 14
                Caption = 'E-mail do contador'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = 'Tahoma'
                Font.Style = []
                ParentFont = False
              end
              object Label37: TLabel
                Left = 10
                Top = 0
                Width = 256
                Height = 14
                Caption = 'Identifica'#231#227'o do e-mail (Ex: Nome da empresa)'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = 'Tahoma'
                Font.Style = []
                ParentFont = False
              end
              object Label45: TLabel
                Left = 0
                Top = 0
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
              object DBEdit7: TDBEdit
                Left = 360
                Top = 15
                Width = 350
                Height = 26
                DataField = 'send_email_email_accountant'
                DataSource = dtsCompany
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -15
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 1
                OnEnter = EdtFieldEnter
                OnExit = EdtFieldExit
                OnKeyDown = EdtFieldKeyDown
              end
              object Button1: TButton
                Left = 720
                Top = 15
                Width = 160
                Height = 26
                Caption = 'Testar envio de e-mail'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = 'Tahoma'
                Font.Style = []
                ParentFont = False
                TabOrder = 2
              end
              object DBEdit2: TDBEdit
                Left = 0
                Top = 15
                Width = 350
                Height = 26
                DataField = 'send_email_identification'
                DataSource = dtsCompany
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
            object Panel36: TPanel
              AlignWithMargins = True
              Left = 10
              Top = 274
              Width = 974
              Height = 265
              Margins.Left = 10
              Margins.Top = 0
              Margins.Right = 10
              Margins.Bottom = 10
              Align = alClient
              BevelOuter = bvNone
              Color = 16579576
              ParentBackground = False
              TabOrder = 4
              ExplicitWidth = 998
              ExplicitHeight = 355
              object Label38: TLabel
                Left = 0
                Top = 0
                Width = 55
                Height = 14
                Caption = 'Cabe'#231'alho'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = 'Tahoma'
                Font.Style = []
                ParentFont = False
              end
              object Label42: TLabel
                Left = 0
                Top = 136
                Width = 41
                Height = 14
                Caption = 'Rodap'#233
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -12
                Font.Name = 'Tahoma'
                Font.Style = []
                ParentFont = False
              end
              object DBMemo1: TDBMemo
                Left = 0
                Top = 15
                Width = 974
                Height = 113
                DataField = 'send_email_header_message'
                DataSource = dtsCompany
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -15
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 0
              end
              object DBMemo2: TDBMemo
                Left = 0
                Top = 151
                Width = 974
                Height = 113
                DataField = 'send_email_footer_message'
                DataSource = dtsCompany
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlack
                Font.Height = -15
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentFont = False
                TabOrder = 1
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
        Width = 125
        Caption = 'Companhia'
        ExplicitLeft = 45
        ExplicitWidth = 125
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
  object dtsCompany: TDataSource [2]
    Left = 819
    Top = 1
  end
end
