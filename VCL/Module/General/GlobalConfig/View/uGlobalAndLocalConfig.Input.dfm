inherited GlobalAndLocalConfigInputView: TGlobalAndLocalConfigInputView
  ClientHeight = 695
  ClientWidth = 653
  OnShow = FormShow
  ExplicitWidth = 653
  ExplicitHeight = 695
  TextHeight = 13
  inherited pnlBackground: TPanel
    Width = 653
    Height = 695
    ExplicitWidth = 653
    ExplicitHeight = 695
    inherited pnlBackground2: TPanel
      Width = 651
      Height = 648
      ExplicitWidth = 651
      ExplicitHeight = 648
      inherited imgNoSearch: TSkAnimatedImage
        Width = 551
        Height = 498
        ExplicitWidth = 551
        ExplicitHeight = 498
      end
      inherited pnlBottomButtons: TPanel
        Top = 598
        Width = 631
        ExplicitTop = 598
        ExplicitWidth = 631
        inherited pnlSave: TPanel
          Left = 461
          ExplicitLeft = 461
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
          Left = 281
          ExplicitLeft = 281
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
        Width = 631
        Height = 578
        ExplicitWidth = 631
        ExplicitHeight = 578
        inherited tabMain: TTabSheet
          ExplicitWidth = 623
          ExplicitHeight = 549
          inherited pnlMain: TPanel
            Width = 623
            Height = 549
            ExplicitWidth = 623
            ExplicitHeight = 549
            object Label2: TLabel
              Left = 10
              Top = 10
              Width = 164
              Height = 18
              Caption = 'PDV (Ponto de Venda)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label9: TLabel
              Left = 10
              Top = 55
              Width = 364
              Height = 16
              Caption = '01| Imprimir ticket no encerramento [L]............:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 5327153
              Font.Height = -12
              Font.Name = 'Courier New'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label5: TLabel
              Left = 390
              Top = 83
              Width = 144
              Height = 16
              Caption = 'Vias do ticket[L]:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 5327153
              Font.Height = -13
              Font.Name = 'Courier New'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Panel2: TPanel
              Left = 10
              Top = 28
              Width = 600
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 0
            end
            object pdv_ticket_option: TRadioGroup
              Left = 390
              Top = 39
              Width = 220
              Height = 35
              Columns = 3
              ItemIndex = 0
              Items.Strings = (
                'N'#227'o'
                'Sim'
                'Opcional')
              TabOrder = 1
            end
            object pdv_ticket_copies: TSpinEdit
              Tag = 1
              Left = 541
              Top = 78
              Width = 69
              Height = 23
              MaxValue = 0
              MinValue = 0
              TabOrder = 2
              Value = 1
            end
          end
        end
      end
    end
    inherited pnlTitle: TPanel
      Width = 651
      ExplicitWidth = 651
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
        Caption = 'Par'#226'metros'
        ExplicitLeft = 45
        ExplicitWidth = 123
      end
      inherited imgCloseTitle: TImage
        Left = 616
        OnClick = btnCancelClick
        ExplicitLeft = 563
      end
      inherited imgMinimizeTitle: TImage
        Left = 581
        ExplicitLeft = 528
      end
    end
  end
  object dtsGlobalConfig: TDataSource [2]
    Left = 427
    Top = 1
  end
  inherited tmrAllowSave: TTimer
    Left = 320
  end
end
