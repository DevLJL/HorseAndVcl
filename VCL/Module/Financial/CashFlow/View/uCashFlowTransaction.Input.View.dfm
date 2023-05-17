inherited CashFlowTransactionInputView: TCashFlowTransactionInputView
  ClientHeight = 664
  ClientWidth = 623
  OnShow = FormShow
  ExplicitWidth = 623
  ExplicitHeight = 664
  TextHeight = 13
  inherited pnlBackground: TPanel
    Width = 623
    Height = 664
    ExplicitWidth = 623
    ExplicitHeight = 596
    inherited pnlBackground2: TPanel
      Width = 621
      Height = 617
      ExplicitWidth = 621
      ExplicitHeight = 549
      inherited imgNoSearch: TSkAnimatedImage
        Width = 521
        Height = 467
        ExplicitWidth = 521
        ExplicitHeight = 399
      end
      inherited pnlBottomButtons: TPanel
        Top = 567
        Width = 601
        ExplicitTop = 499
        ExplicitWidth = 601
        inherited pnlSave: TPanel
          Left = 431
          ExplicitLeft = 431
          inherited pnlSave2: TPanel
            inherited btnSave: TSpeedButton
              Caption = 'Confirmar (F6)'
              OnClick = btnSaveClick
            end
            inherited pnlSave3: TPanel
              inherited imgSave: TImage
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
          Left = 251
          ExplicitLeft = 251
          inherited pnlCancel2: TPanel
            inherited btnCancel: TSpeedButton
              Caption = 'Voltar (Esc)'
              OnClick = btnCancelClick
              ExplicitLeft = 38
            end
          end
        end
      end
      inherited pgc: TPageControl
        Width = 601
        Height = 547
        ExplicitWidth = 601
        ExplicitHeight = 479
        inherited tabMain: TTabSheet
          ExplicitWidth = 593
          ExplicitHeight = 518
          inherited pnlMain: TPanel
            Width = 593
            Height = 518
            ExplicitWidth = 593
            ExplicitHeight = 450
            object Label22: TLabel
              Left = 10
              Top = 10
              Width = 46
              Height = 18
              Caption = 'Dados'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label2: TLabel
              Left = 160
              Top = 62
              Width = 46
              Height = 14
              Caption = 'Hist'#243'rico'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label10: TLabel
              Left = 150
              Top = 62
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
            object Label1: TLabel
              Left = 10
              Top = 271
              Width = 89
              Height = 18
              Caption = 'Observa'#231#227'o'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label5: TLabel
              Left = 20
              Top = 62
              Width = 25
              Height = 14
              Caption = 'Data'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label8: TLabel
              Left = 10
              Top = 62
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
            object Label7: TLabel
              Left = 150
              Top = 112
              Width = 27
              Height = 14
              Caption = 'Valor'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label3: TLabel
              Left = 10
              Top = 161
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
              Top = 161
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
            object Label9: TLabel
              Left = 10
              Top = 210
              Width = 62
              Height = 14
              Caption = 'F1 - Pessoa'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label6: TLabel
              Left = 290
              Top = 112
              Width = 68
              Height = 14
              Caption = 'ID da Venda'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label11: TLabel
              Left = 19
              Top = 111
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
            object Label26: TLabel
              Left = 10
              Top = 111
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
            object Panel5: TPanel
              Left = 10
              Top = 28
              Width = 570
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 11
            end
            object edthistory: TDBEdit
              Left = 150
              Top = 77
              Width = 430
              Height = 26
              DataField = 'history'
              DataSource = dtsCashFlowTransaction
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 2
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
            end
            object Panel1: TPanel
              Left = 10
              Top = 289
              Width = 570
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 12
            end
            object chkflg_manual_transaction: TDBCheckBox
              Left = 10
              Top = 36
              Width = 217
              Height = 17
              Caption = 'Lan'#231'amento de transa'#231#227'o manual?'
              DataField = 'flg_manual_transaction'
              DataSource = dtsCashFlowTransaction
              TabOrder = 0
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object edttransaction_date: TJvDBDateEdit
              Left = 10
              Top = 77
              Width = 130
              Height = 26
              DataField = 'transaction_date'
              DataSource = dtsCashFlowTransaction
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ShowNullDate = False
              TabOrder = 1
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
            end
            object DBEdit1: TDBEdit
              Left = 150
              Top = 127
              Width = 130
              Height = 26
              DataField = 'amount'
              DataSource = dtsCashFlowTransaction
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 4
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
            end
            object edtpayment_name: TDBEdit
              Left = 88
              Top = 176
              Width = 492
              Height = 26
              Color = 16053492
              DataField = 'payment_name'
              DataSource = dtsCashFlowTransaction
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 7
            end
            object Panel4: TPanel
              Left = 10
              Top = 176
              Width = 26
              Height = 26
              Cursor = crHandPoint
              BevelOuter = bvNone
              Color = 5327153
              ParentBackground = False
              TabOrder = 13
              object Panel2: TPanel
                Left = 0
                Top = 0
                Width = 26
                Height = 26
                Cursor = crHandPoint
                Align = alClient
                BevelOuter = bvNone
                Color = 8747344
                ParentBackground = False
                TabOrder = 0
                object imgLocaPayment: TImage
                  Left = 0
                  Top = 0
                  Width = 26
                  Height = 26
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
                  ExplicitWidth = 18
                  ExplicitHeight = 18
                end
              end
            end
            object edtpayment_id: TDBEdit
              Left = 37
              Top = 176
              Width = 50
              Height = 26
              DataField = 'payment_id'
              DataSource = dtsCashFlowTransaction
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 6
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
            end
            object edtperson_name: TDBEdit
              Left = 88
              Top = 225
              Width = 492
              Height = 26
              Color = 16053492
              DataField = 'person_name'
              DataSource = dtsCashFlowTransaction
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 9
            end
            object Panel3: TPanel
              Left = 10
              Top = 225
              Width = 26
              Height = 26
              Cursor = crHandPoint
              BevelOuter = bvNone
              Color = 5327153
              ParentBackground = False
              TabOrder = 14
              object Panel6: TPanel
                Left = 0
                Top = 0
                Width = 26
                Height = 26
                Cursor = crHandPoint
                Align = alClient
                BevelOuter = bvNone
                Color = 8747344
                ParentBackground = False
                TabOrder = 0
                object imgLocaPerson: TImage
                  Left = 0
                  Top = 0
                  Width = 26
                  Height = 26
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
                  ExplicitWidth = 18
                  ExplicitHeight = 18
                end
              end
            end
            object edtperson_id: TDBEdit
              Left = 37
              Top = 225
              Width = 50
              Height = 26
              DataField = 'person_id'
              DataSource = dtsCashFlowTransaction
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 8
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
            end
            object DBEdit4: TDBEdit
              Left = 290
              Top = 127
              Width = 130
              Height = 26
              DataField = 'sale_id'
              DataSource = dtsCashFlowTransaction
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 5
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
            end
            object cbxType: TJvDBComboBox
              Left = 10
              Top = 127
              Width = 130
              Height = 26
              DataField = 'type'
              DataSource = dtsCashFlowTransaction
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              Items.Strings = (
                'D'#233'bito'
                'Cr'#233'dito')
              ParentFont = False
              TabOrder = 3
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
            end
            object memNote: TDBMemo
              Left = 10
              Top = 296
              Width = 570
              Height = 211
              DataField = 'note'
              DataSource = dtsCashFlowTransaction
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 10
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
            end
          end
        end
      end
    end
    inherited pnlTitle: TPanel
      Width = 621
      ExplicitWidth = 621
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
        Width = 279
        Height = 40
        Caption = 'Fluxo de Caixa > Contato'
        ExplicitLeft = 45
        ExplicitWidth = 279
      end
      inherited imgCloseTitle: TImage
        Left = 586
        ExplicitLeft = 563
      end
      inherited imgMinimizeTitle: TImage
        Left = 551
        ExplicitLeft = 528
      end
    end
  end
  object dtsCashFlowTransaction: TDataSource
    Left = 496
    Top = 1
  end
end
