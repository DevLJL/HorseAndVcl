inherited SalePaymentInputView: TSalePaymentInputView
  ClientHeight = 494
  ClientWidth = 632
  OnShow = FormShow
  ExplicitWidth = 632
  ExplicitHeight = 494
  TextHeight = 13
  inherited pnlBackground: TPanel
    Width = 632
    Height = 494
    ExplicitWidth = 624
    ExplicitHeight = 484
    inherited pnlBackground2: TPanel
      Width = 630
      Height = 447
      ExplicitWidth = 622
      ExplicitHeight = 437
      inherited imgNoSearch: TSkAnimatedImage
        Width = 530
        Height = 297
        ExplicitWidth = 522
        ExplicitHeight = 287
      end
      inherited pnlBottomButtons: TPanel
        Top = 397
        Width = 610
        ExplicitTop = 387
        ExplicitWidth = 602
        inherited pnlSave: TPanel
          Left = 440
          ExplicitLeft = 432
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
          Left = 260
          ExplicitLeft = 252
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
        Width = 610
        Height = 377
        ExplicitWidth = 602
        ExplicitHeight = 367
        inherited tabMain: TTabSheet
          ExplicitWidth = 602
          ExplicitHeight = 348
          inherited pnlMain: TPanel
            Width = 602
            Height = 348
            ExplicitWidth = 594
            ExplicitHeight = 338
            object Label10: TLabel
              Left = 10
              Top = 37
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
              Top = 37
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
            object Label2: TLabel
              Left = 10
              Top = 86
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
            object Label3: TLabel
              Left = 20
              Top = 86
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
            object Label5: TLabel
              Left = 20
              Top = 135
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
            object Label6: TLabel
              Left = 10
              Top = 135
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
              Left = 160
              Top = 135
              Width = 45
              Height = 14
              Caption = 'Valor R$'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label22: TLabel
              Left = 10
              Top = 10
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
            object Label1: TLabel
              Left = 10
              Top = 196
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
            object Label7: TLabel
              Left = 150
              Top = 135
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
            object edtpayment_name: TDBEdit
              Left = 88
              Top = 52
              Width = 502
              Height = 26
              Color = 16053492
              DataField = 'payment_name'
              DataSource = dtsSalePayment
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
              Top = 52
              Width = 26
              Height = 26
              Cursor = crHandPoint
              BevelOuter = bvNone
              Color = 5327153
              ParentBackground = False
              TabOrder = 7
              object Panel5: TPanel
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
              Top = 52
              Width = 50
              Height = 26
              DataField = 'payment_id'
              DataSource = dtsSalePayment
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
            object edtbank_account_name: TDBEdit
              Left = 88
              Top = 101
              Width = 502
              Height = 26
              Color = 16053492
              DataField = 'bank_account_name'
              DataSource = dtsSalePayment
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
            object Panel1: TPanel
              Left = 10
              Top = 101
              Width = 26
              Height = 26
              Cursor = crHandPoint
              BevelOuter = bvNone
              Color = 5327153
              ParentBackground = False
              TabOrder = 8
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
                object imgLocaBankAccount: TImage
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
                  OnClick = imgLocaBankAccountClick
                  ExplicitTop = 14
                  ExplicitWidth = 18
                  ExplicitHeight = 18
                end
              end
            end
            object edtbank_account_id: TDBEdit
              Left = 37
              Top = 101
              Width = 50
              Height = 26
              DataField = 'bank_account_id'
              DataSource = dtsSalePayment
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
            object edtdue_date: TJvDBDateEdit
              Left = 10
              Top = 150
              Width = 130
              Height = 26
              DataField = 'due_date'
              DataSource = dtsSalePayment
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ShowNullDate = False
              TabOrder = 4
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtamount: TDBEdit
              Left = 150
              Top = 150
              Width = 130
              Height = 26
              DataField = 'amount'
              DataSource = dtsSalePayment
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
            object memnote: TDBMemo
              Left = 10
              Top = 223
              Width = 580
              Height = 114
              DataField = 'note'
              DataSource = dtsSalePayment
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
            object Panel3: TPanel
              Left = 10
              Top = 28
              Width = 580
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 9
            end
            object Panel6: TPanel
              Left = 10
              Top = 214
              Width = 580
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 10
            end
          end
        end
      end
    end
    inherited pnlTitle: TPanel
      Width = 630
      ExplicitWidth = 622
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
        Width = 223
        Height = 40
        Caption = 'Venda > Pagamento'
        ExplicitLeft = 45
        ExplicitWidth = 223
      end
      inherited imgCloseTitle: TImage
        Left = 595
        ExplicitLeft = 563
      end
      inherited imgMinimizeTitle: TImage
        Left = 560
        ExplicitLeft = 528
      end
    end
  end
  object dtsSalePayment: TDataSource
    Left = 496
    Top = 1
  end
end
