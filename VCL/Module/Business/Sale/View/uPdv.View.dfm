object PdvIndexView: TPdvIndexView
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'PdvView'
  ClientHeight = 720
  ClientWidth = 1024
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poDefault
  Scaled = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object pnlBackground: TPanel
    Left = 0
    Top = 0
    Width = 1024
    Height = 720
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object nbkMain: TNotebook
      Left = 0
      Top = 0
      Width = 1024
      Height = 720
      Align = alClient
      PageIndex = 2
      TabOrder = 0
      OnPageChanged = nbkMainPageChanged
      object TPage
        Left = 0
        Top = 0
        Caption = 'pageClosed'
        object pnlMainPage00Closed: TPanel
          Left = 0
          Top = 0
          Width = 1024
          Height = 720
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object Panel10: TPanel
            Left = 0
            Top = 0
            Width = 1024
            Height = 660
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object JvGradient2: TJvGradient
              Left = 0
              Top = 0
              Width = 1024
              Height = 660
              Style = grVertical
              StartColor = 15717063
              EndColor = clWhite
              ExplicitLeft = 320
              ExplicitTop = -84
              ExplicitHeight = 617
            end
            object Panel12: TPanel
              Left = 0
              Top = 0
              Width = 1024
              Height = 660
              Align = alClient
              BevelOuter = bvNone
              Caption = 'FECHADO'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 9591841
              Font.Height = -160
              Font.Name = 'Segoe UI Semibold'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              ExplicitTop = -3
            end
          end
          object Panel13: TPanel
            Left = 0
            Top = 660
            Width = 1024
            Height = 60
            Align = alBottom
            BevelOuter = bvNone
            Color = 3233304
            ParentBackground = False
            TabOrder = 1
            object btnOpenCashier: TJvTransparentButton
              AlignWithMargins = True
              Left = 81
              Top = 0
              Width = 943
              Height = 60
              Cursor = crHandPoint
              Margins.Left = 1
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alClient
              Caption = 'ABRIR CAIXA (ENTER)'
              Color = 4552994
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -27
              Font.Name = 'Segoe UI Semibold'
              Font.Style = [fsBold]
              HotTrackFont.Charset = DEFAULT_CHARSET
              HotTrackFont.Color = clWindowText
              HotTrackFont.Height = -27
              HotTrackFont.Name = 'Segoe UI Semibold'
              HotTrackFont.Style = []
              FrameStyle = fsNone
              ParentFont = False
              Transparent = False
              OnClick = btnOpenCashierClick
              ExplicitLeft = 552
              ExplicitWidth = 472
            end
            object btnCloseModal: TJvTransparentButton
              Left = 0
              Top = 0
              Width = 80
              Height = 60
              Cursor = crHandPoint
              Margins.Left = 10
              Margins.Top = 10
              Margins.Right = 10
              Margins.Bottom = 10
              Align = alLeft
              Caption = '     Sair      (Esc)'
              Color = 4269713
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -16
              Font.Name = 'Segoe UI Semibold'
              Font.Style = [fsBold]
              HotTrackFont.Charset = DEFAULT_CHARSET
              HotTrackFont.Color = clWindowText
              HotTrackFont.Height = -16
              HotTrackFont.Name = 'Segoe UI Semibold'
              HotTrackFont.Style = []
              FrameStyle = fsNone
              ParentFont = False
              Transparent = False
              WordWrap = True
              OnClick = btnCloseModalClick
            end
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pageOpened'
        object pnlMainPage01Opened: TPanel
          Left = 0
          Top = 0
          Width = 1024
          Height = 720
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object pnlAvailableContent: TPanel
            Left = 0
            Top = 0
            Width = 1024
            Height = 660
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            object JvGradient8: TJvGradient
              Left = 0
              Top = 0
              Width = 1024
              Height = 660
              Style = grVertical
              StartColor = 15717063
              EndColor = clWhite
              ExplicitLeft = 320
              ExplicitTop = -84
              ExplicitHeight = 617
            end
            object pnlCaixaStatus: TPanel
              Left = 0
              Top = 0
              Width = 1024
              Height = 660
              Align = alClient
              BevelOuter = bvNone
              Caption = 'LIVRE'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 9591841
              Font.Height = -160
              Font.Name = 'Segoe UI Semibold'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              DesignSize = (
                1024
                660)
              object lblTime: TLabel
                Left = 28
                Top = 6
                Width = 155
                Height = 89
                Caption = '08:00'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 9591841
                Font.Height = -67
                Font.Name = 'Segoe UI Light'
                Font.Style = []
                ParentFont = False
              end
              object lblDate: TLabel
                Left = 213
                Top = 25
                Width = 138
                Height = 30
                Caption = '01 / 02 / 2020'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 9591841
                Font.Height = -21
                Font.Name = 'Segoe UI Light'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object lblDayOfWeek: TLabel
                Left = 213
                Top = 50
                Width = 154
                Height = 30
                Caption = 'Segunda - Feira'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 9591841
                Font.Height = -21
                Font.Name = 'Segoe UI Light'
                Font.Style = [fsBold]
                ParentFont = False
              end
              object Label1: TLabel
                Left = 10
                Top = 703
                Width = 140
                Height = 14
                Anchors = [akLeft, akBottom]
                Caption = 'Consultar itens (F2)'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 9591841
                Font.Height = -11
                Font.Name = 'Courier New'
                Font.Style = [fsBold]
                ParentFont = False
                ExplicitTop = 602
              end
              object Label2: TLabel
                Left = 170
                Top = 703
                Width = 147
                Height = 14
                Anchors = [akLeft, akBottom]
                Caption = 'Vendas em espera (F5)'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 9591841
                Font.Height = -11
                Font.Name = 'Courier New'
                Font.Style = [fsBold]
                ParentFont = False
                ExplicitTop = 602
              end
              object Label7: TLabel
                Left = 10
                Top = 719
                Width = 126
                Height = 14
                Anchors = [akLeft, akBottom]
                Caption = 'Consultar EAN (F9)'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 9591841
                Font.Height = -11
                Font.Name = 'Courier New'
                Font.Style = [fsBold]
                ParentFont = False
                ExplicitTop = 618
              end
              object Label19: TLabel
                Left = 170
                Top = 719
                Width = 175
                Height = 14
                Anchors = [akLeft, akBottom]
                Caption = 'Hist'#243'rico de vendas (F10)'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 9591841
                Font.Height = -11
                Font.Name = 'Courier New'
                Font.Style = [fsBold]
                ParentFont = False
                ExplicitTop = 618
              end
              object Label25: TLabel
                Left = 365
                Top = 719
                Width = 196
                Height = 14
                Anchors = [akLeft, akBottom]
                Caption = 'Contas a Pagar/Receber (F12)'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 9591841
                Font.Height = -11
                Font.Name = 'Courier New'
                Font.Style = [fsBold]
                ParentFont = False
                ExplicitTop = 618
              end
              object Label29: TLabel
                Left = 365
                Top = 703
                Width = 105
                Height = 14
                Anchors = [akLeft, akBottom]
                Caption = 'Meu Caixa (F11)'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 9591841
                Font.Height = -11
                Font.Name = 'Courier New'
                Font.Style = [fsBold]
                ParentFont = False
                ExplicitTop = 602
              end
            end
          end
          object pnlAvailableButtons: TPanel
            Left = 0
            Top = 660
            Width = 1024
            Height = 60
            Align = alBottom
            BevelOuter = bvNone
            Color = 3233304
            ParentBackground = False
            TabOrder = 1
            object btnAppend: TJvTransparentButton
              AlignWithMargins = True
              Left = 324
              Top = 0
              Width = 700
              Height = 60
              Cursor = crHandPoint
              Margins.Left = 1
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alClient
              Caption = 'INICIAR (ENTER)'
              Color = 4552994
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -27
              Font.Name = 'Segoe UI Semibold'
              Font.Style = [fsBold]
              HotTrackFont.Charset = DEFAULT_CHARSET
              HotTrackFont.Color = clWindowText
              HotTrackFont.Height = -27
              HotTrackFont.Name = 'Segoe UI Semibold'
              HotTrackFont.Style = []
              FrameStyle = fsNone
              ParentFont = False
              Transparent = False
              OnClick = btnAppendClick
              ExplicitLeft = 552
              ExplicitWidth = 472
            end
            object btnCloseForm: TJvTransparentButton
              Left = 0
              Top = 0
              Width = 80
              Height = 60
              Cursor = crHandPoint
              Margins.Left = 10
              Margins.Top = 10
              Margins.Right = 10
              Margins.Bottom = 10
              Align = alLeft
              Caption = '     Sair      (Esc)'
              Color = 4269713
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -16
              Font.Name = 'Segoe UI Semibold'
              Font.Style = [fsBold]
              HotTrackFont.Charset = DEFAULT_CHARSET
              HotTrackFont.Color = clWindowText
              HotTrackFont.Height = -16
              HotTrackFont.Name = 'Segoe UI Semibold'
              HotTrackFont.Style = []
              FrameStyle = fsNone
              ParentFont = False
              Transparent = False
              WordWrap = True
              OnClick = btnCloseModalClick
            end
            object btnDelivery: TJvTransparentButton
              AlignWithMargins = True
              Left = 162
              Top = 0
              Width = 80
              Height = 60
              Cursor = crHandPoint
              Margins.Left = 1
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alLeft
              Caption = 'Entrega (F4)'
              Color = 4552994
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -16
              Font.Name = 'Segoe UI Semibold'
              Font.Style = [fsBold]
              HotTrackFont.Charset = DEFAULT_CHARSET
              HotTrackFont.Color = clWindowText
              HotTrackFont.Height = -16
              HotTrackFont.Name = 'Segoe UI Semibold'
              HotTrackFont.Style = []
              FrameStyle = fsNone
              ParentFont = False
              Transparent = False
              WordWrap = True
              OnClick = btnDeliveryClick
              ExplicitLeft = 160
            end
            object btnConsumptionNumber: TJvTransparentButton
              AlignWithMargins = True
              Left = 81
              Top = 0
              Width = 80
              Height = 60
              Cursor = crHandPoint
              Margins.Left = 1
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alLeft
              Caption = '  Fichas   (F3)'
              Color = 4552994
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -16
              Font.Name = 'Segoe UI Semibold'
              Font.Style = [fsBold]
              HotTrackFont.Charset = DEFAULT_CHARSET
              HotTrackFont.Color = clWindowText
              HotTrackFont.Height = -16
              HotTrackFont.Name = 'Segoe UI Semibold'
              HotTrackFont.Style = []
              FrameStyle = fsNone
              ParentFont = False
              Transparent = False
              WordWrap = True
              OnClick = btnConsumptionNumberClick
              ExplicitLeft = 80
            end
            object btnOnHoldSales: TJvTransparentButton
              AlignWithMargins = True
              Left = 243
              Top = 0
              Width = 80
              Height = 60
              Cursor = crHandPoint
              Margins.Left = 1
              Margins.Top = 0
              Margins.Right = 0
              Margins.Bottom = 0
              Align = alLeft
              Caption = ' Espera  (F5)'
              Color = 4552994
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -16
              Font.Name = 'Segoe UI Semibold'
              Font.Style = [fsBold]
              HotTrackFont.Charset = DEFAULT_CHARSET
              HotTrackFont.Color = clWindowText
              HotTrackFont.Height = -16
              HotTrackFont.Name = 'Segoe UI Semibold'
              HotTrackFont.Style = []
              FrameStyle = fsNone
              ParentFont = False
              Transparent = False
              WordWrap = True
              OnClick = btnOnHoldSalesClick
              ExplicitLeft = 321
              ExplicitTop = 3
            end
            object btnAppendButton: TButton
              Left = 1024
              Top = 0
              Width = 0
              Height = 60
              Align = alRight
              Caption = 'btnAppendButton'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 9591841
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              OnClick = btnAppendClick
            end
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pageInput'
        object pnlMainPage02Input: TPanel
          Left = 0
          Top = 0
          Width = 1024
          Height = 720
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object nbkInput: TNotebook
            Left = 0
            Top = 0
            Width = 1024
            Height = 720
            Align = alClient
            TabOrder = 0
            object TPage
              Left = 0
              Top = 0
              Caption = 'Items'
              object pnlInputPage00Data: TPanel
                Left = 0
                Top = 0
                Width = 1024
                Height = 720
                Align = alClient
                BevelOuter = bvNone
                Color = 16185078
                ParentBackground = False
                TabOrder = 0
                object Panel58: TPanel
                  Left = 0
                  Top = 121
                  Width = 633
                  Height = 599
                  Align = alLeft
                  BevelOuter = bvNone
                  Color = 16114652
                  ParentBackground = False
                  TabOrder = 0
                  object Panel59: TPanel
                    AlignWithMargins = True
                    Left = 5
                    Top = 65
                    Width = 623
                    Height = 469
                    Margins.Left = 5
                    Margins.Top = 5
                    Margins.Right = 5
                    Margins.Bottom = 5
                    Align = alClient
                    BevelOuter = bvNone
                    Color = 16445933
                    ParentBackground = False
                    TabOrder = 0
                    object Panel60: TPanel
                      Left = 0
                      Top = 359
                      Width = 623
                      Height = 110
                      Align = alBottom
                      BevelOuter = bvNone
                      Color = 7423770
                      ParentBackground = False
                      TabOrder = 0
                      object Panel61: TPanel
                        Left = 0
                        Top = 85
                        Width = 623
                        Height = 25
                        Margins.Left = 0
                        Margins.Top = 0
                        Margins.Right = 10
                        Margins.Bottom = 0
                        Align = alBottom
                        BevelOuter = bvNone
                        Color = 7423770
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = clWindowText
                        Font.Height = -11
                        Font.Name = 'Segoe UI Semibold'
                        Font.Style = []
                        ParentBackground = False
                        ParentFont = False
                        TabOrder = 0
                        ExplicitTop = 0
                        object Label15: TLabel
                          AlignWithMargins = True
                          Left = 36
                          Top = 0
                          Width = 103
                          Height = 25
                          Margins.Left = 5
                          Margins.Top = 0
                          Margins.Right = 0
                          Margins.Bottom = 0
                          Align = alLeft
                          Alignment = taCenter
                          Caption = 'TOTAL GERAL'
                          Font.Charset = DEFAULT_CHARSET
                          Font.Color = 15132390
                          Font.Height = -17
                          Font.Name = 'Segoe UI Semibold'
                          Font.Style = [fsBold]
                          ParentFont = False
                          ExplicitHeight = 23
                        end
                        object lblFinalValue: TLabel
                          AlignWithMargins = True
                          Left = 554
                          Top = 0
                          Width = 56
                          Height = 25
                          Margins.Left = 5
                          Margins.Top = 0
                          Margins.Right = 13
                          Margins.Bottom = 0
                          Align = alRight
                          Alignment = taCenter
                          Caption = 'R$ 0,00'
                          Font.Charset = DEFAULT_CHARSET
                          Font.Color = 15132390
                          Font.Height = -17
                          Font.Name = 'Segoe UI Semibold'
                          Font.Style = [fsBold]
                          ParentFont = False
                          ExplicitLeft = 563
                          ExplicitHeight = 23
                        end
                        object imgFinalValueInfo: TImage
                          AlignWithMargins = True
                          Left = 14
                          Top = 0
                          Width = 14
                          Height = 25
                          Cursor = crHandPoint
                          Hint = 'Ajuda [Clique aqui para mais informa'#231#245'es]'
                          Margins.Left = 14
                          Margins.Top = 0
                          Margins.Bottom = 0
                          Align = alLeft
                          Center = True
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
                          OnClick = imgFinalValueInfoClick
                          ExplicitLeft = 609
                          ExplicitTop = -19
                          ExplicitHeight = 44
                        end
                      end
                      object Panel62: TPanel
                        Left = 0
                        Top = 0
                        Width = 623
                        Height = 85
                        Align = alClient
                        BevelOuter = bvNone
                        Color = 9591841
                        Enabled = False
                        ParentBackground = False
                        TabOrder = 1
                        ExplicitLeft = -1
                        ExplicitTop = 22
                        ExplicitHeight = 59
                        object Label3: TLabel
                          AlignWithMargins = True
                          Left = 10
                          Top = 10
                          Width = 80
                          Height = 65
                          Margins.Left = 10
                          Margins.Top = 10
                          Margins.Right = 10
                          Margins.Bottom = 10
                          Align = alLeft
                          Caption = 'R$'
                          Font.Charset = DEFAULT_CHARSET
                          Font.Color = clWhite
                          Font.Height = -53
                          Font.Name = 'Segoe UI Semibold'
                          Font.Style = [fsBold]
                          ParentFont = False
                          ExplicitHeight = 39
                        end
                        object edtsum_sale_item_total: TDBEdit
                          AlignWithMargins = True
                          Left = 100
                          Top = 10
                          Width = 513
                          Height = 65
                          Margins.Left = 0
                          Margins.Top = 10
                          Margins.Right = 10
                          Margins.Bottom = 10
                          Align = alClient
                          BorderStyle = bsNone
                          Color = 9591841
                          DataField = 'sum_sale_item_total'
                          DataSource = dtsSale
                          Font.Charset = DEFAULT_CHARSET
                          Font.Color = clWhite
                          Font.Height = -53
                          Font.Name = 'Segoe UI Semibold'
                          Font.Style = [fsBold]
                          ParentFont = False
                          TabOrder = 0
                          ExplicitLeft = 125
                          ExplicitWidth = 490
                          ExplicitHeight = 39
                        end
                      end
                    end
                    object Panel6: TPanel
                      Left = 0
                      Top = 0
                      Width = 623
                      Height = 359
                      Align = alClient
                      BevelOuter = bvNone
                      BorderWidth = 1
                      Color = 15717063
                      ParentBackground = False
                      TabOrder = 1
                      ExplicitHeight = 360
                      object dbgSaleItems: TDBGrid
                        Left = 1
                        Top = 1
                        Width = 621
                        Height = 357
                        Cursor = crHandPoint
                        Align = alClient
                        BorderStyle = bsNone
                        Color = clWhite
                        DrawingStyle = gdsGradient
                        FixedColor = 15131349
                        GradientEndColor = 16381936
                        GradientStartColor = 15920607
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = clWindowText
                        Font.Height = -15
                        Font.Name = 'Tahoma'
                        Font.Style = []
                        ImeName = 'dbgSaleItems'
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
                            FieldName = 'action_delete'
                            Title.Alignment = taCenter
                            Title.Caption = ' '
                            Width = 25
                            Visible = True
                          end
                          item
                            Alignment = taRightJustify
                            Expanded = False
                            FieldName = 'quantity'
                            Font.Charset = DEFAULT_CHARSET
                            Font.Color = clWindowText
                            Font.Height = -15
                            Font.Name = 'Tahoma'
                            Font.Style = [fsBold]
                            Title.Alignment = taRightJustify
                            Title.Caption = 'Qde'
                            Width = 65
                            Visible = True
                          end
                          item
                            Expanded = False
                            FieldName = 'product_unit_name'
                            Title.Caption = 'UN'
                            Width = 40
                            Visible = True
                          end
                          item
                            Expanded = False
                            FieldName = 'product_name'
                            Title.Caption = 'Item'
                            Width = 220
                            Visible = True
                          end
                          item
                            Alignment = taRightJustify
                            Expanded = False
                            FieldName = 'price'
                            Title.Alignment = taRightJustify
                            Title.Caption = 'V. Unit'
                            Width = 80
                            Visible = True
                          end
                          item
                            Alignment = taRightJustify
                            Expanded = False
                            FieldName = 'unit_discount'
                            Title.Alignment = taRightJustify
                            Title.Caption = 'Desc. Unit.'
                            Width = 75
                            Visible = True
                          end
                          item
                            Alignment = taRightJustify
                            Expanded = False
                            FieldName = 'total'
                            Title.Alignment = taRightJustify
                            Title.Caption = 'Total'
                            Width = 80
                            Visible = True
                          end>
                      end
                    end
                  end
                  object Panel69: TPanel
                    AlignWithMargins = True
                    Left = 5
                    Top = 5
                    Width = 623
                    Height = 50
                    Margins.Left = 5
                    Margins.Top = 5
                    Margins.Right = 5
                    Margins.Bottom = 5
                    Align = alTop
                    BevelOuter = bvNone
                    Color = 16114652
                    ParentBackground = False
                    TabOrder = 1
                    object pnlsale_item_append: TPanel
                      AlignWithMargins = True
                      Left = 573
                      Top = 0
                      Width = 50
                      Height = 50
                      Cursor = crHandPoint
                      Margins.Left = 0
                      Margins.Top = 0
                      Margins.Right = 0
                      Margins.Bottom = 0
                      Align = alRight
                      BevelOuter = bvNone
                      Color = 16445933
                      ParentBackground = False
                      TabOrder = 0
                      object imgsale_item_append: TImage
                        Left = 0
                        Top = 0
                        Width = 50
                        Height = 50
                        Cursor = crHandPoint
                        Margins.Left = 10
                        Margins.Top = 10
                        Margins.Right = 10
                        Margins.Bottom = 10
                        Align = alClient
                        AutoSize = True
                        Center = True
                        Picture.Data = {
                          0954506E67496D61676589504E470D0A1A0A0000000D494844520000001E0000
                          001E08060000003B30AEA2000000017352474200AECE1CE90000000467414D41
                          0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
                          214944415478DAEDD6C109C2301406E0740347284EE008CDC1BB4E609D40EBCD
                          93F4A437BB417502BD2BD80D7482BA429D20FE8108B56DCC0B4444C883C7031B
                          F2197D8F346084E82F873D94157240585E94EB536A5A1410E108E542592B03B0
                          715F0F7BD8C31EF6F09FC1EA160A91BDC63A792B6DA930826BBE50A1837394D8
                          02B00D7965F22EF88032FA051CA2DCBF84564C085E6ECEB716ACF08859341219
                          656C8AD31E5F1F74761FF00C65E6101ED7512DAC7037FFB7100BFCBCAD89F838
                          6FC0AF8CF682A78B0C274DBA1E986039CF120FED4FCAF6D87D0EB8B286152E51
                          DB4E979DCB7528095678C4E89D6E44C9B005FE36AB4E6085C728B9E6F1031937
                          C7C609AC70DD8C274033EA3ED6B0C29B9789766C9CC2B5934F903B646A6AA666
                          3C01992B981F0E2F89C00000000049454E44AE426082}
                        OnClick = imgsale_item_appendClick
                        ExplicitWidth = 30
                        ExplicitHeight = 30
                      end
                    end
                    object Panel71: TPanel
                      AlignWithMargins = True
                      Left = 135
                      Top = 0
                      Width = 433
                      Height = 50
                      Margins.Left = 0
                      Margins.Top = 0
                      Margins.Right = 5
                      Margins.Bottom = 0
                      Align = alClient
                      BevelOuter = bvNone
                      Color = 16445933
                      ParentBackground = False
                      TabOrder = 1
                      TabStop = True
                      object Panel7: TPanel
                        Left = 0
                        Top = 0
                        Width = 42
                        Height = 50
                        Align = alLeft
                        BevelOuter = bvNone
                        TabOrder = 0
                        object imgsale_item_loca_product: TImage
                          Left = 0
                          Top = 0
                          Width = 42
                          Height = 50
                          Cursor = crHandPoint
                          Hint = 'F2 - Localizar Item'
                          Align = alClient
                          AutoSize = True
                          Center = True
                          ParentShowHint = False
                          Picture.Data = {
                            0954506E67496D61676589504E470D0A1A0A0000000D494844520000001E0000
                            001E08060000003B30AEA2000000017352474200AECE1CE90000000467414D41
                            0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000002
                            404944415478DABD97DD55C2401085773B88154807920A84377D123A8815182A
                            002B102B900EC0271FA103B0026205C60A742EB993B34493DDF0E39E3327C7FD
                            996FF6EECC2E5A73608B6F873DF95C8B0DC43A62118732B18DD86AFD367FAE5B
                            6F0F0076E5F324D673BA737EA3CA74F44FFE0AA01558A0A97CC604C0E954EC15
                            BB14E739E760EC8E81255C0A05FA3AA7159850ECF40BBB109BB98E1AD4999BE2
                            28DE118CAE09028B039CE34CEC5BEC5E162F9CB1888E3B6E7F65FD920AE0DCFB
                            41603ADE52DE912C9C3AFD907D40D9338E67353E5662570C7C16021E53DA852C
                            183A8E5E9C6036017E20FB1A41CAFC8B10F09652223956EC7BE12E1F7DE75CF1
                            35A742A9F54CD428370288D9878C85DC711B28D7020AF8C2077E20642A9091B3
                            5B94CF631B28D7E2683EA1960FACE79BEA25207D5060A4B21F000738F28151B7
                            A9D9CF6655203B2758773C3944DA1A9FB80BBC5297C9A0A57424B44C561FB84C
                            06D4DE09C0AAE034A48E91C589E18D730434E26E3B62FD10B096146A363E22A9
                            F66E409FD43D539CB1BEB3E525DF129A307824166EC0FA3376A068B83CB07324
                            C7AFB7D50375DFF0F2B86CCD6417BA7B0679464BC2D1D2A69F36F48160511978
                            C3C7EE7C1B022DC76E065D63EDBAB264411572FABB34C5DBAB01E6553FBFC001
                            D025FFC46582B735695039E7BC3F7FA994E0466851F8CB9AB10183303CC70F53
                            3CFA59531ED800C7B563C734EB81D6AA700AB066EABF41158CA2DEBB18CE0D55
                            F0EE17A43E02FF0155B0DEA1194DEBEF6CD01D98BBD4FF12D05662CFE784A2FD
                            008B2A4FE9B6992B200000000049454E44AE426082}
                          ShowHint = True
                          OnClick = imgsale_item_loca_productClick
                          ExplicitWidth = 44
                        end
                      end
                      object Panel8: TPanel
                        Left = 42
                        Top = 0
                        Width = 391
                        Height = 50
                        Align = alClient
                        BevelOuter = bvNone
                        TabOrder = 1
                        object Label21: TLabel
                          AlignWithMargins = True
                          Left = 5
                          Top = 0
                          Width = 381
                          Height = 20
                          Margins.Left = 5
                          Margins.Top = 0
                          Margins.Right = 5
                          Margins.Bottom = 0
                          Align = alTop
                          Caption = 'F2 - Localizar'
                          Color = 16445933
                          Font.Charset = DEFAULT_CHARSET
                          Font.Color = 5327153
                          Font.Height = -15
                          Font.Name = 'Segoe UI Semibold'
                          Font.Style = [fsBold]
                          ParentColor = False
                          ParentFont = False
                          ExplicitWidth = 90
                        end
                        object Image3: TImage
                          AlignWithMargins = True
                          Left = 372
                          Top = 20
                          Width = 14
                          Height = 30
                          Cursor = crHandPoint
                          Hint = 'Ajuda [Clique aqui para mais informa'#231#245'es]'
                          Margins.Left = 5
                          Margins.Top = 0
                          Margins.Right = 5
                          Margins.Bottom = 0
                          Align = alRight
                          AutoSize = True
                          Center = True
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
                          OnClick = Image3Click
                          ExplicitLeft = 5
                          ExplicitTop = 0
                          ExplicitHeight = 14
                        end
                        object edtsale_item_id: TEdit
                          AlignWithMargins = True
                          Left = 5
                          Top = 25
                          Width = 357
                          Height = 20
                          Margins.Left = 5
                          Margins.Top = 5
                          Margins.Right = 5
                          Margins.Bottom = 5
                          Align = alClient
                          BorderStyle = bsNone
                          CharCase = ecUpperCase
                          Color = 16445933
                          Font.Charset = DEFAULT_CHARSET
                          Font.Color = clWindowText
                          Font.Height = -15
                          Font.Name = 'Tahoma'
                          Font.Style = [fsBold]
                          ParentFont = False
                          TabOrder = 0
                          OnClick = edtFieldClick
                          OnKeyPress = edtsale_item_idKeyPress
                          ExplicitWidth = 381
                        end
                      end
                    end
                    object Panel5: TPanel
                      AlignWithMargins = True
                      Left = 0
                      Top = 0
                      Width = 130
                      Height = 50
                      Margins.Left = 0
                      Margins.Top = 0
                      Margins.Right = 5
                      Margins.Bottom = 0
                      Align = alLeft
                      BevelOuter = bvNone
                      Color = 16445933
                      ParentBackground = False
                      TabOrder = 2
                      TabStop = True
                      object Panel32: TPanel
                        Left = 0
                        Top = 0
                        Width = 130
                        Height = 50
                        Align = alClient
                        BevelOuter = bvNone
                        TabOrder = 0
                        object Label37: TLabel
                          AlignWithMargins = True
                          Left = 5
                          Top = 0
                          Width = 120
                          Height = 20
                          Margins.Left = 5
                          Margins.Top = 0
                          Margins.Right = 5
                          Margins.Bottom = 0
                          Align = alTop
                          Caption = 'F1 - Quantidade'
                          Color = 16445933
                          Font.Charset = DEFAULT_CHARSET
                          Font.Color = 5327153
                          Font.Height = -15
                          Font.Name = 'Segoe UI Semibold'
                          Font.Style = [fsBold]
                          ParentColor = False
                          ParentFont = False
                          ExplicitWidth = 108
                        end
                        object edtsale_item_quantity: TNumberBox
                          AlignWithMargins = True
                          Left = 5
                          Top = 25
                          Width = 120
                          Height = 20
                          Margins.Left = 5
                          Margins.Top = 5
                          Margins.Right = 5
                          Margins.Bottom = 5
                          Align = alClient
                          BorderStyle = bsNone
                          Color = 16445933
                          Decimal = 3
                          Font.Charset = DEFAULT_CHARSET
                          Font.Color = clWindowText
                          Font.Height = -15
                          Font.Name = 'Tahoma'
                          Font.Style = [fsBold]
                          Mode = nbmFloat
                          MaxValue = 100.000000000000000000
                          ParentFont = False
                          TabOrder = 0
                          Value = 1.000000000000000000
                          SpinButtonOptions.ButtonWidth = 20
                          SpinButtonOptions.Placement = nbspInline
                          SpinButtonOptions.ArrowColor = 5327153
                          SpinButtonOptions.ArrowPressedColor = clRed
                          UseUpDownKeys = False
                          OnClick = edtFieldClick
                          OnKeyPress = edtsale_item_quantityKeyPress
                        end
                      end
                    end
                  end
                  object Panel65: TPanel
                    AlignWithMargins = True
                    Left = 5
                    Top = 544
                    Width = 623
                    Height = 50
                    Margins.Left = 5
                    Margins.Top = 5
                    Margins.Right = 5
                    Margins.Bottom = 5
                    Align = alBottom
                    BevelOuter = bvNone
                    Color = 16114652
                    ParentBackground = False
                    TabOrder = 2
                    object btnReleaseSalePayment: TJvTransparentButton
                      AlignWithMargins = True
                      Left = 190
                      Top = 0
                      Width = 433
                      Height = 50
                      Cursor = crHandPoint
                      Margins.Left = 5
                      Margins.Top = 0
                      Margins.Right = 0
                      Margins.Bottom = 0
                      Align = alClient
                      Caption = 'Pagamento (F6)'
                      Color = 4552994
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = clWhite
                      Font.Height = -17
                      Font.Name = 'Segoe UI Semibold'
                      Font.Style = [fsBold]
                      HotTrackFont.Charset = DEFAULT_CHARSET
                      HotTrackFont.Color = clWindowText
                      HotTrackFont.Height = -17
                      HotTrackFont.Name = 'Segoe UI Semibold'
                      HotTrackFont.Style = []
                      FrameStyle = fsNone
                      ParentFont = False
                      Transparent = False
                      OnClick = btnReleaseSalePaymentClick
                      ExplicitLeft = 352
                      ExplicitWidth = 29
                    end
                    object btnCancel: TJvTransparentButton
                      AlignWithMargins = True
                      Left = 0
                      Top = 0
                      Width = 90
                      Height = 50
                      Cursor = crHandPoint
                      Margins.Left = 0
                      Margins.Top = 0
                      Margins.Right = 5
                      Margins.Bottom = 0
                      Align = alLeft
                      Caption = 'Cancelar (Esc)'
                      Color = 4269713
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = clWhite
                      Font.Height = -17
                      Font.Name = 'Segoe UI Semibold'
                      Font.Style = [fsBold]
                      HotTrackFont.Charset = DEFAULT_CHARSET
                      HotTrackFont.Color = clWindowText
                      HotTrackFont.Height = -17
                      HotTrackFont.Name = 'Segoe UI Semibold'
                      HotTrackFont.Style = []
                      FrameStyle = fsNone
                      ParentFont = False
                      Transparent = False
                      WordWrap = True
                      OnClick = btnCancelClick
                    end
                    object btnBackOrder: TJvTransparentButton
                      AlignWithMargins = True
                      Left = 95
                      Top = 0
                      Width = 90
                      Height = 50
                      Cursor = crHandPoint
                      Margins.Left = 0
                      Margins.Top = 0
                      Margins.Right = 0
                      Margins.Bottom = 0
                      Align = alLeft
                      Caption = 'Aguardar (F7)'
                      Color = clGray
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = clWhite
                      Font.Height = -17
                      Font.Name = 'Segoe UI Semibold'
                      Font.Style = [fsBold]
                      HotTrackFont.Charset = DEFAULT_CHARSET
                      HotTrackFont.Color = clWindowText
                      HotTrackFont.Height = -17
                      HotTrackFont.Name = 'Segoe UI Semibold'
                      HotTrackFont.Style = []
                      FrameStyle = fsNone
                      ParentFont = False
                      Transparent = False
                      WordWrap = True
                      OnClick = btnBackOrderClick
                      ExplicitLeft = 94
                    end
                  end
                end
                object Panel64: TPanel
                  Left = 633
                  Top = 121
                  Width = 391
                  Height = 599
                  Align = alClient
                  BevelOuter = bvNone
                  Color = 16114652
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWindowText
                  Font.Height = -11
                  Font.Name = 'Segoe UI Semibold'
                  Font.Style = []
                  ParentBackground = False
                  ParentFont = False
                  TabOrder = 1
                  object pnlWelcome: TPanel
                    AlignWithMargins = True
                    Left = 5
                    Top = 5
                    Width = 381
                    Height = 318
                    Margins.Left = 5
                    Margins.Top = 5
                    Margins.Right = 5
                    Margins.Bottom = 5
                    Align = alTop
                    BevelOuter = bvNone
                    TabOrder = 0
                    object Panel4: TPanel
                      Left = 0
                      Top = 0
                      Width = 381
                      Height = 24
                      Align = alTop
                      BevelOuter = bvNone
                      Color = 7423770
                      ParentBackground = False
                      TabOrder = 0
                      object Label27: TLabel
                        AlignWithMargins = True
                        Left = 10
                        Top = 0
                        Width = 361
                        Height = 23
                        Margins.Left = 10
                        Margins.Top = 0
                        Margins.Right = 10
                        Margins.Bottom = 0
                        Align = alTop
                        Alignment = taCenter
                        Caption = '# SEJAM BEM-VINDOS #'
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = 15132390
                        Font.Height = -17
                        Font.Name = 'Segoe UI Semibold'
                        Font.Style = [fsBold]
                        ParentFont = False
                        ExplicitWidth = 192
                      end
                    end
                    object Panel3: TPanel
                      Left = 0
                      Top = 24
                      Width = 381
                      Height = 294
                      Align = alClient
                      BevelOuter = bvNone
                      Color = 16445933
                      ParentBackground = False
                      TabOrder = 1
                      DesignSize = (
                        381
                        294)
                      object Label11: TLabel
                        Left = 11
                        Top = 129
                        Width = 74
                        Height = 16
                        Caption = 'Cliente (F5)'
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = 4802889
                        Font.Height = -13
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        ParentFont = False
                      end
                      object btnRemoverCodCliente: TJvTransparentButton
                        Left = 11
                        Top = 146
                        Width = 20
                        Height = 20
                        Cursor = crHandPoint
                        Hint = 'Remover Cliente'
                        Caption = '-'
                        Color = 16313319
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = clGray
                        Font.Height = -19
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        HotTrackFont.Charset = DEFAULT_CHARSET
                        HotTrackFont.Color = clWindowText
                        HotTrackFont.Height = -19
                        HotTrackFont.Name = 'Tahoma'
                        HotTrackFont.Style = []
                        FrameStyle = fsNone
                        ParentFont = False
                        ParentShowHint = False
                        ShowHint = True
                      end
                      object Label26: TLabel
                        Left = 11
                        Top = 72
                        Width = 171
                        Height = 16
                        Caption = 'Atendente/Vendedor (F4)'
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = 4802889
                        Font.Height = -13
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        ParentFont = False
                      end
                      object btnRemoverCodVend: TJvTransparentButton
                        Left = 11
                        Top = 89
                        Width = 20
                        Height = 20
                        Cursor = crHandPoint
                        Hint = 'Remover Vendedor'
                        Caption = '-'
                        Color = 16313319
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = clGray
                        Font.Height = -19
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        HotTrackFont.Charset = DEFAULT_CHARSET
                        HotTrackFont.Color = clWindowText
                        HotTrackFont.Height = -19
                        HotTrackFont.Name = 'Tahoma'
                        HotTrackFont.Style = []
                        FrameStyle = fsNone
                        ParentFont = False
                        ParentShowHint = False
                        ShowHint = True
                      end
                      object Label28: TLabel
                        Left = 11
                        Top = 10
                        Width = 72
                        Height = 16
                        Caption = 'N'#186' Pessoas'
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = 4802889
                        Font.Height = -13
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        ParentFont = False
                      end
                      object imgReduzirQde: TImage
                        Left = 11
                        Top = 26
                        Width = 26
                        Height = 26
                        Cursor = crHandPoint
                        AutoSize = True
                        Center = True
                        Picture.Data = {
                          0954506E67496D61676589504E470D0A1A0A0000000D494844520000001A0000
                          001A0806000000A94A4CCE000000017352474200AECE1CE90000000467414D41
                          0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000002
                          014944415478DAB5964F4854411C80E7AD0A49908A7488FE5CB2353B78900E1D
                          825AA8932D6C24425468822DABE04674EB52D0C193A2D0A1165CA34BFF9604C1
                          53D076562208124413D912E9B004A11DD2DDBE9FEFBD783CDE5B7D6F777EF0F1
                          9B9DDD37DFCCECBC9931944F4C4463115214BAE0325C8463506FFDA40C3F210F
                          3958482F7D58F56BCFF01048DD218843CA121D5095630BBEC2143C43B8535164
                          493AE02124A041058F39B88F6CD1536449CEC2189C734C5198F8043DCEA9748A
                          DA494FE1421502677C8638B2EFFF45489A4893703DE474F9C53BB8856CD3160D
                          5AA331AA6AD63B0610650D24F2E73F81980689C43C5C15D16D652E80664DA23F
                          9014D10B0A373549ECC8896899C249CDA27511C95B1C717D217279CB8B011B3C
                          0223D0E2AA2F89A8ECF1C0031865B59482769DF6E4D9C7EE7A3FD13D24E32124
                          323369652EAE7D89D6200B1B015DADD00FA7BCA6AEA0CCED5F677C13D12B0ABD
                          9A45CF457483C2B4AA6EB7AE1472560D8BE8A832CF904E4DA28F90B237D56BA4
                          B71A24B2D092ACE08C2D3A487A09576A28D986373084E897F3E03B4E9A51E61D
                          A11691B724BB47BAFBCE7086F41A4E435D48816C695FE08E326F46652F917C96
                          774A4EDB4408C95FABA38F60C5B985799EA80865347D7017DAA0710FC16F6B14
                          199885A23D928A2287F004E91274C37938EC78467AFB4399371E69FC3D14FC36
                          E27FA6BB96C2B454CDA40000000049454E44AE426082}
                        OnClick = imgReduzirQdeClick
                      end
                      object imgAumentarQde: TImage
                        Left = 67
                        Top = 26
                        Width = 26
                        Height = 26
                        Cursor = crHandPoint
                        AutoSize = True
                        Center = True
                        Picture.Data = {
                          0954506E67496D61676589504E470D0A1A0A0000000D494844520000001A0000
                          001A0806000000A94A4CCE000000017352474200AECE1CE90000000467414D41
                          0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
                          E24944415478DAB5964F48024114C66721E81454B720C80AEA5A740A82DCCE8A
                          7A8FB0EE415DBCE6599212BA96FD838E69794EC9AEB176E8A0441974CFE8D6C5
                          BEE73E171D37675ADC071FB3CCFACD6FDEEE9BB71A421173A94810C32A1485A6
                          A051C8807EA032F404E56A897CB9DF3A860270002DA836C351A1DF0378AE0502
                          80769C86B63401726401EBF1768118720D053D429CECB0B0594DE41B3DA00142
                          1C18325B74031D6B3CAE5728097D4327D098E2F754243107044894B351450CC6
                          1C7BE218B2BA9E36A8A8F9C8C23015D813C270ABE1A9C3336DC0B022ECF3A013
                          5E40142DD09EB09FBB9FA02481EE7061FA0CAA12E80D1701E906B5952BE8599A
                          A792FD60D0048625E93E1D910C342ECD3708D474D981535DFF0DACB781E14C9E
                          F703E47A5408F4C92977C63BB40FD5A5F9871AB715F826456FC31D1276230E48
                          F375025942BF437B2D068B40B4831D9F418704A26C2C9F4166BB05BD6098F509
                          5482C7018531DC6898B6613A62CF3A860B9D6CE029757E26A824A30A1355DC26
                          5FBB55971C19405AEFDF01CDA722233850F742BF025551E16C1A5D20CE8ACE53
                          7100302AAEB59ADBA75C02D2072DEE11720AED7642FE0451E051869A76839CD1
                          0494A074BB2AE530546EFE7F47A54C9D7A191A86A83F7E09FB3D3C42970054FA
                          ADF30B3735C8F176624F9E0000000049454E44AE426082}
                        OnClick = imgReduzirQdeClick
                      end
                      object Label13: TLabel
                        Left = 238
                        Top = 10
                        Width = 84
                        Height = 16
                        Caption = 'Identifica'#231#227'o'
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = 4802889
                        Font.Height = -13
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        ParentFont = False
                      end
                      object Label17: TLabel
                        Left = 103
                        Top = 10
                        Width = 59
                        Height = 16
                        Caption = 'Comanda'
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = 4802889
                        Font.Height = -13
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        ParentFont = False
                      end
                      object Label18: TLabel
                        Left = 188
                        Top = 10
                        Width = 32
                        Height = 16
                        Caption = 'Ficha'
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = 4802889
                        Font.Height = -13
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        ParentFont = False
                      end
                      object edtperson_name: TDBEdit
                        Left = 88
                        Top = 148
                        Width = 280
                        Height = 18
                        Cursor = crHandPoint
                        Hint = 'Trocar Cliente'
                        TabStop = False
                        Anchors = [akLeft, akTop, akRight]
                        AutoSize = False
                        BorderStyle = bsNone
                        CharCase = ecUpperCase
                        Color = 16313319
                        DataField = 'person_name'
                        DataSource = dtsSale
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = 4802889
                        Font.Height = -16
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        ParentFont = False
                        ParentShowHint = False
                        ReadOnly = True
                        ShowHint = True
                        TabOrder = 7
                        OnKeyDown = edtFieldKeyDown
                      end
                      object edtseller_name: TDBEdit
                        Left = 88
                        Top = 90
                        Width = 283
                        Height = 19
                        Cursor = crHandPoint
                        Hint = 'Trocar Vendedor'
                        TabStop = False
                        Anchors = [akLeft, akTop, akRight]
                        AutoSize = False
                        BorderStyle = bsNone
                        CharCase = ecUpperCase
                        Color = 16313319
                        DataField = 'seller_name'
                        DataSource = dtsSale
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = 4802889
                        Font.Height = -16
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        ParentFont = False
                        ParentShowHint = False
                        ReadOnly = True
                        ShowHint = True
                        TabOrder = 5
                        OnKeyDown = edtFieldKeyDown
                      end
                      object DBEdit1: TDBEdit
                        Left = 41
                        Top = 30
                        Width = 23
                        Height = 18
                        Cursor = crHandPoint
                        Hint = 'Trocar Cliente'
                        TabStop = False
                        AutoSize = False
                        BorderStyle = bsNone
                        Color = 16313319
                        DataField = 'amount_of_people'
                        DataSource = dtsSale
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = 5327153
                        Font.Height = -16
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        ParentFont = False
                        ParentShowHint = False
                        ReadOnly = True
                        ShowHint = True
                        TabOrder = 0
                        OnClick = edtFieldClick
                        OnKeyDown = edtFieldKeyDown
                      end
                      object edtseller_id: TDBEdit
                        Left = 36
                        Top = 90
                        Width = 50
                        Height = 19
                        Cursor = crHandPoint
                        Hint = 'Trocar Vendedor'
                        TabStop = False
                        AutoSize = False
                        BorderStyle = bsNone
                        Color = 16313319
                        DataField = 'seller_id'
                        DataSource = dtsSale
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = 5327153
                        Font.Height = -16
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        ParentFont = False
                        ParentShowHint = False
                        ShowHint = True
                        TabOrder = 4
                        OnClick = edtFieldClick
                        OnKeyDown = edtFieldKeyDown
                      end
                      object edtperson_id: TDBEdit
                        Left = 36
                        Top = 147
                        Width = 50
                        Height = 19
                        Cursor = crHandPoint
                        Hint = 'Trocar Vendedor'
                        TabStop = False
                        AutoSize = False
                        BorderStyle = bsNone
                        Color = 16313319
                        DataField = 'person_id'
                        DataSource = dtsSale
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = 5327153
                        Font.Height = -16
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        ParentFont = False
                        ParentShowHint = False
                        ShowHint = True
                        TabOrder = 6
                        OnClick = edtFieldClick
                        OnKeyDown = edtFieldKeyDown
                      end
                      object DBEdit3: TDBEdit
                        Left = 238
                        Top = 30
                        Width = 133
                        Height = 18
                        Cursor = crHandPoint
                        Hint = 'Trocar Cliente'
                        TabStop = False
                        Anchors = [akLeft, akTop, akRight]
                        AutoSize = False
                        BorderStyle = bsNone
                        CharCase = ecUpperCase
                        Color = 16313319
                        DataField = 'sale_check_name'
                        DataSource = dtsSale
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = 5327153
                        Font.Height = -16
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        ParentFont = False
                        ParentShowHint = False
                        ShowHint = True
                        TabOrder = 3
                        OnKeyDown = edtFieldKeyDown
                      end
                      object DBEdit4: TDBEdit
                        Left = 103
                        Top = 30
                        Width = 75
                        Height = 18
                        Cursor = crHandPoint
                        Hint = 'Trocar Cliente'
                        TabStop = False
                        AutoSize = False
                        BorderStyle = bsNone
                        Color = 16313319
                        DataField = 'sale_check_id'
                        DataSource = dtsSale
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = 4802889
                        Font.Height = -16
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        ParentFont = False
                        ParentShowHint = False
                        ReadOnly = True
                        ShowHint = True
                        TabOrder = 1
                        OnKeyDown = edtFieldKeyDown
                      end
                      object DBEdit5: TDBEdit
                        Left = 188
                        Top = 30
                        Width = 40
                        Height = 18
                        Cursor = crHandPoint
                        Hint = 'Trocar Cliente'
                        TabStop = False
                        AutoSize = False
                        BorderStyle = bsNone
                        Color = 16313319
                        DataField = 'consumption_number'
                        DataSource = dtsSale
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = 4802889
                        Font.Height = -16
                        Font.Name = 'Tahoma'
                        Font.Style = [fsBold]
                        ParentFont = False
                        ParentShowHint = False
                        ReadOnly = True
                        ShowHint = True
                        TabOrder = 2
                        OnKeyDown = edtFieldKeyDown
                      end
                      object Panel26: TPanel
                        Left = 11
                        Top = 171
                        Width = 360
                        Height = 113
                        Anchors = [akLeft, akTop, akRight]
                        BevelOuter = bvNone
                        BorderWidth = 1
                        Color = 7423770
                        ParentBackground = False
                        TabOrder = 8
                        object Panel29: TPanel
                          Left = 1
                          Top = 1
                          Width = 358
                          Height = 111
                          Align = alClient
                          BevelOuter = bvNone
                          Color = 16313319
                          Enabled = False
                          ParentBackground = False
                          TabOrder = 0
                          DesignSize = (
                            358
                            111)
                          object Label23: TLabel
                            Left = 5
                            Top = 5
                            Width = 50
                            Height = 20
                            Caption = 'End.:'
                            Font.Charset = DEFAULT_CHARSET
                            Font.Color = 4802889
                            Font.Height = -17
                            Font.Name = 'Courier New'
                            Font.Style = [fsBold]
                            ParentFont = False
                          end
                          object Label20: TLabel
                            Left = 5
                            Top = 26
                            Width = 50
                            Height = 20
                            Caption = 'N'#186'..:'
                            Font.Charset = DEFAULT_CHARSET
                            Font.Color = 4802889
                            Font.Height = -17
                            Font.Name = 'Courier New'
                            Font.Style = [fsBold]
                            ParentFont = False
                          end
                          object Label24: TLabel
                            Left = 5
                            Top = 46
                            Width = 50
                            Height = 20
                            Caption = 'Bai.:'
                            Font.Charset = DEFAULT_CHARSET
                            Font.Color = 4802889
                            Font.Height = -17
                            Font.Name = 'Courier New'
                            Font.Style = [fsBold]
                            ParentFont = False
                          end
                          object Label35: TLabel
                            Left = 5
                            Top = 67
                            Width = 50
                            Height = 20
                            Caption = 'UF..:'
                            Font.Charset = DEFAULT_CHARSET
                            Font.Color = 4802889
                            Font.Height = -17
                            Font.Name = 'Courier New'
                            Font.Style = [fsBold]
                            ParentFont = False
                          end
                          object Label36: TLabel
                            Left = 5
                            Top = 88
                            Width = 50
                            Height = 20
                            Caption = 'Ref.:'
                            Font.Charset = DEFAULT_CHARSET
                            Font.Color = 4802889
                            Font.Height = -17
                            Font.Name = 'Courier New'
                            Font.Style = [fsBold]
                            ParentFont = False
                          end
                          object DBEdit6: TDBEdit
                            Left = 57
                            Top = 5
                            Width = 297
                            Height = 18
                            Cursor = crHandPoint
                            Hint = 'Trocar Cliente'
                            TabStop = False
                            Anchors = [akLeft, akTop, akRight]
                            AutoSize = False
                            BorderStyle = bsNone
                            CharCase = ecUpperCase
                            Color = 16313319
                            DataField = 'person_address'
                            DataSource = dtsSale
                            Font.Charset = DEFAULT_CHARSET
                            Font.Color = 4802889
                            Font.Height = -16
                            Font.Name = 'Tahoma'
                            Font.Style = [fsBold]
                            ParentFont = False
                            ParentShowHint = False
                            ReadOnly = True
                            ShowHint = True
                            TabOrder = 0
                            OnKeyDown = edtFieldKeyDown
                          end
                          object DBEdit15: TDBEdit
                            Left = 57
                            Top = 26
                            Width = 50
                            Height = 18
                            Cursor = crHandPoint
                            Hint = 'Trocar Cliente'
                            TabStop = False
                            AutoSize = False
                            BorderStyle = bsNone
                            CharCase = ecUpperCase
                            Color = 16313319
                            DataField = 'person_address_number'
                            DataSource = dtsSale
                            Font.Charset = DEFAULT_CHARSET
                            Font.Color = 4802889
                            Font.Height = -16
                            Font.Name = 'Tahoma'
                            Font.Style = [fsBold]
                            ParentFont = False
                            ParentShowHint = False
                            ReadOnly = True
                            ShowHint = True
                            TabOrder = 1
                            OnKeyDown = edtFieldKeyDown
                          end
                          object DBEdit16: TDBEdit
                            Left = 112
                            Top = 26
                            Width = 242
                            Height = 18
                            Cursor = crHandPoint
                            Hint = 'Trocar Cliente'
                            TabStop = False
                            Anchors = [akLeft, akTop, akRight]
                            AutoSize = False
                            BorderStyle = bsNone
                            CharCase = ecUpperCase
                            Color = 16313319
                            DataField = 'person_complement'
                            DataSource = dtsSale
                            Font.Charset = DEFAULT_CHARSET
                            Font.Color = 4802889
                            Font.Height = -16
                            Font.Name = 'Tahoma'
                            Font.Style = [fsBold]
                            ParentFont = False
                            ParentShowHint = False
                            ReadOnly = True
                            ShowHint = True
                            TabOrder = 2
                            OnKeyDown = edtFieldKeyDown
                          end
                          object DBEdit17: TDBEdit
                            Left = 57
                            Top = 88
                            Width = 297
                            Height = 18
                            Cursor = crHandPoint
                            Hint = 'Trocar Cliente'
                            TabStop = False
                            Anchors = [akLeft, akTop, akRight]
                            AutoSize = False
                            BorderStyle = bsNone
                            CharCase = ecUpperCase
                            Color = 16313319
                            DataField = 'person_reference_point'
                            DataSource = dtsSale
                            Font.Charset = DEFAULT_CHARSET
                            Font.Color = 4802889
                            Font.Height = -16
                            Font.Name = 'Tahoma'
                            Font.Style = [fsBold]
                            ParentFont = False
                            ParentShowHint = False
                            ReadOnly = True
                            ShowHint = True
                            TabOrder = 3
                            OnKeyDown = edtFieldKeyDown
                          end
                          object DBEdit18: TDBEdit
                            Left = 57
                            Top = 46
                            Width = 297
                            Height = 18
                            Cursor = crHandPoint
                            Hint = 'Trocar Cliente'
                            TabStop = False
                            Anchors = [akLeft, akTop, akRight]
                            AutoSize = False
                            BorderStyle = bsNone
                            CharCase = ecUpperCase
                            Color = 16313319
                            DataField = 'person_district'
                            DataSource = dtsSale
                            Font.Charset = DEFAULT_CHARSET
                            Font.Color = 4802889
                            Font.Height = -16
                            Font.Name = 'Tahoma'
                            Font.Style = [fsBold]
                            ParentFont = False
                            ParentShowHint = False
                            ReadOnly = True
                            ShowHint = True
                            TabOrder = 4
                            OnKeyDown = edtFieldKeyDown
                          end
                          object DBEdit19: TDBEdit
                            Left = 87
                            Top = 67
                            Width = 267
                            Height = 18
                            Cursor = crHandPoint
                            Hint = 'Trocar Cliente'
                            TabStop = False
                            Anchors = [akLeft, akTop, akRight]
                            AutoSize = False
                            BorderStyle = bsNone
                            CharCase = ecUpperCase
                            Color = 16313319
                            DataField = 'person_city_name'
                            DataSource = dtsSale
                            Font.Charset = DEFAULT_CHARSET
                            Font.Color = 4802889
                            Font.Height = -16
                            Font.Name = 'Tahoma'
                            Font.Style = [fsBold]
                            ParentFont = False
                            ParentShowHint = False
                            ReadOnly = True
                            ShowHint = True
                            TabOrder = 5
                            OnKeyDown = edtFieldKeyDown
                          end
                          object DBEdit20: TDBEdit
                            Left = 57
                            Top = 67
                            Width = 25
                            Height = 18
                            Cursor = crHandPoint
                            Hint = 'Trocar Cliente'
                            TabStop = False
                            AutoSize = False
                            BorderStyle = bsNone
                            CharCase = ecUpperCase
                            Color = 16313319
                            DataField = 'person_city_state'
                            DataSource = dtsSale
                            Font.Charset = DEFAULT_CHARSET
                            Font.Color = 4802889
                            Font.Height = -16
                            Font.Name = 'Tahoma'
                            Font.Style = [fsBold]
                            ParentFont = False
                            ParentShowHint = False
                            ReadOnly = True
                            ShowHint = True
                            TabOrder = 6
                            OnKeyDown = edtFieldKeyDown
                          end
                        end
                      end
                    end
                  end
                  object Panel9: TPanel
                    AlignWithMargins = True
                    Left = 5
                    Top = 333
                    Width = 381
                    Height = 261
                    Margins.Left = 5
                    Margins.Top = 5
                    Margins.Right = 5
                    Margins.Bottom = 5
                    Align = alClient
                    BevelOuter = bvNone
                    TabOrder = 1
                    object Panel11: TPanel
                      Left = 0
                      Top = 0
                      Width = 381
                      Height = 261
                      Align = alClient
                      BevelOuter = bvNone
                      Caption = 'LOGO'
                      Color = 16445933
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = 7423770
                      Font.Height = -27
                      Font.Name = 'Segoe UI Semibold'
                      Font.Style = [fsBold]
                      ParentBackground = False
                      ParentFont = False
                      TabOrder = 0
                      object imgLogoPdv: TImage
                        Left = 0
                        Top = 0
                        Width = 381
                        Height = 261
                        Align = alClient
                        AutoSize = True
                        Center = True
                        ExplicitLeft = 176
                        ExplicitTop = 88
                        ExplicitWidth = 920
                        ExplicitHeight = 512
                      end
                    end
                  end
                end
                object pnlInfoSaleItemPriceLabel: TPanel
                  AlignWithMargins = True
                  Left = 0
                  Top = 61
                  Width = 1024
                  Height = 60
                  Margins.Left = 0
                  Margins.Top = 1
                  Margins.Right = 0
                  Margins.Bottom = 0
                  Align = alTop
                  BevelOuter = bvNone
                  Color = 7423770
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWhite
                  Font.Height = -27
                  Font.Name = 'Segoe UI Semibold'
                  Font.Style = [fsBold]
                  ParentBackground = False
                  ParentFont = False
                  TabOrder = 2
                end
                object pnlInfoSaleItemLabel: TPanel
                  Left = 0
                  Top = 0
                  Width = 1024
                  Height = 60
                  Align = alTop
                  BevelOuter = bvNone
                  Color = 7423770
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clWhite
                  Font.Height = -40
                  Font.Name = 'Segoe UI Semibold'
                  Font.Style = [fsBold]
                  ParentBackground = False
                  ParentFont = False
                  TabOrder = 3
                end
              end
            end
            object TPage
              Left = 0
              Top = 0
              Caption = 'Payment'
              object pnlInputPage01Payment: TPanel
                Left = 0
                Top = 0
                Width = 1024
                Height = 720
                Align = alClient
                BevelOuter = bvNone
                Color = 16185078
                ParentBackground = False
                TabOrder = 0
                DesignSize = (
                  1024
                  720)
                object Label8: TLabel
                  Left = 10
                  Top = 131
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
                object Label9: TLabel
                  Left = 10
                  Top = 155
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
                object Label10: TLabel
                  Left = 110
                  Top = 155
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
                object Label12: TLabel
                  Left = 210
                  Top = 155
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
                object Label30: TLabel
                  Left = 110
                  Top = 201
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
                object Label31: TLabel
                  Left = 210
                  Top = 201
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
                object Label32: TLabel
                  Left = 310
                  Top = 155
                  Width = 57
                  Height = 14
                  Caption = 'Frete (R$)'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -12
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentFont = False
                end
                object Label33: TLabel
                  Left = 310
                  Top = 201
                  Width = 67
                  Height = 14
                  Caption = 'Servi'#231'o (R$)'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -12
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentFont = False
                end
                object Label34: TLabel
                  Left = 10
                  Top = 201
                  Width = 59
                  Height = 14
                  Caption = 'Cover (R$)'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlack
                  Font.Height = -12
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentFont = False
                end
                object Label14: TLabel
                  Left = 20
                  Top = 262
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
                  Top = 265
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
                object pnlInfoSalePayment: TPanel
                  Left = 0
                  Top = 0
                  Width = 1024
                  Height = 121
                  Align = alTop
                  BevelOuter = bvNone
                  Color = 16185078
                  ParentBackground = False
                  TabOrder = 7
                  object Panel2: TPanel
                    AlignWithMargins = True
                    Left = 0
                    Top = 61
                    Width = 1024
                    Height = 60
                    Margins.Left = 0
                    Margins.Top = 1
                    Margins.Right = 0
                    Margins.Bottom = 0
                    Align = alClient
                    BevelOuter = bvNone
                    Caption = 'FINALIZANDO OPERA'#199#195'O...'
                    Color = 7423770
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWhite
                    Font.Height = -27
                    Font.Name = 'Segoe UI Semibold'
                    Font.Style = [fsBold]
                    ParentBackground = False
                    ParentFont = False
                    TabOrder = 0
                  end
                  object Panel19: TPanel
                    Left = 0
                    Top = 0
                    Width = 1024
                    Height = 60
                    Align = alTop
                    BevelOuter = bvNone
                    Caption = 'PAGAMENTO'
                    Color = 7423770
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWhite
                    Font.Height = -40
                    Font.Name = 'Segoe UI Semibold'
                    Font.Style = [fsBold]
                    ParentBackground = False
                    ParentFont = False
                    TabOrder = 1
                  end
                end
                object Panel39: TPanel
                  Left = 0
                  Top = 650
                  Width = 1024
                  Height = 70
                  Align = alBottom
                  BevelOuter = bvNone
                  Color = 16185078
                  ParentBackground = False
                  TabOrder = 8
                  object btnSave: TJvTransparentButton
                    AlignWithMargins = True
                    Left = 326
                    Top = 10
                    Width = 688
                    Height = 50
                    Cursor = crHandPoint
                    Margins.Left = 0
                    Margins.Top = 10
                    Margins.Right = 10
                    Margins.Bottom = 10
                    Align = alClient
                    Caption = 'Encerrar (End)'
                    Color = 4552994
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWhite
                    Font.Height = -20
                    Font.Name = 'Segoe UI Semibold'
                    Font.Style = [fsBold]
                    HotTrackFont.Charset = DEFAULT_CHARSET
                    HotTrackFont.Color = clWindowText
                    HotTrackFont.Height = -20
                    HotTrackFont.Name = 'Segoe UI Semibold'
                    HotTrackFont.Style = []
                    FrameStyle = fsNone
                    ParentFont = False
                    Transparent = False
                    OnClick = btnSaveClick
                    ExplicitTop = 8
                  end
                  object btnBackToItems: TJvTransparentButton
                    AlignWithMargins = True
                    Left = 10
                    Top = 10
                    Width = 306
                    Height = 50
                    Cursor = crHandPoint
                    Margins.Left = 10
                    Margins.Top = 10
                    Margins.Right = 10
                    Margins.Bottom = 10
                    Align = alLeft
                    Caption = 'Voltar (Esc)'
                    Color = 4269713
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWhite
                    Font.Height = -20
                    Font.Name = 'Segoe UI Semibold'
                    Font.Style = [fsBold]
                    HotTrackFont.Charset = DEFAULT_CHARSET
                    HotTrackFont.Color = clWindowText
                    HotTrackFont.Height = -20
                    HotTrackFont.Name = 'Segoe UI Semibold'
                    HotTrackFont.Style = []
                    FrameStyle = fsNone
                    ParentFont = False
                    Transparent = False
                    OnClick = btnBackToItemsClick
                  end
                end
                object Panel14: TPanel
                  Left = 10
                  Top = 149
                  Width = 390
                  Height = 1
                  BevelOuter = bvNone
                  Color = 14209468
                  ParentBackground = False
                  TabOrder = 9
                end
                object DBEdit2: TDBEdit
                  Left = 10
                  Top = 170
                  Width = 90
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
                  TabOrder = 0
                  OnClick = edtFieldClick
                  OnKeyDown = edtFieldKeyDown
                end
                object edtdiscount: TDBEdit
                  Left = 110
                  Top = 170
                  Width = 90
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
                  TabOrder = 1
                  OnClick = edtFieldClick
                  OnEnter = edtFieldEnter
                  OnExit = edtFieldExit
                  OnKeyDown = edtFieldKeyDown
                end
                object edtincrease: TDBEdit
                  Left = 210
                  Top = 170
                  Width = 90
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
                  TabOrder = 3
                  OnClick = edtFieldClick
                  OnEnter = edtFieldEnter
                  OnExit = edtFieldExit
                  OnKeyDown = edtFieldKeyDown
                end
                object edtperc_discount: TDBEdit
                  Left = 110
                  Top = 216
                  Width = 90
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
                  TabOrder = 2
                  OnClick = edtFieldClick
                  OnEnter = edtFieldEnter
                  OnExit = edtFieldExit
                  OnKeyDown = edtFieldKeyDown
                end
                object edtperc_increase: TDBEdit
                  Left = 210
                  Top = 216
                  Width = 90
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
                  TabOrder = 4
                  OnClick = edtFieldClick
                  OnEnter = edtFieldEnter
                  OnExit = edtFieldExit
                  OnKeyDown = edtFieldKeyDown
                end
                object DBEdit8: TDBEdit
                  Left = 310
                  Top = 170
                  Width = 90
                  Height = 26
                  TabStop = False
                  Color = clWhite
                  DataField = 'freight'
                  DataSource = dtsSale
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clRed
                  Font.Height = -15
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  ParentFont = False
                  TabOrder = 5
                  OnClick = edtFieldClick
                  OnEnter = edtFieldEnter
                  OnExit = edtFieldExit
                  OnKeyDown = edtFieldKeyDown
                end
                object DBEdit9: TDBEdit
                  Left = 310
                  Top = 216
                  Width = 90
                  Height = 26
                  TabStop = False
                  Color = clWhite
                  DataField = 'service_charge'
                  DataSource = dtsSale
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clRed
                  Font.Height = -15
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  ParentFont = False
                  TabOrder = 6
                  OnClick = edtFieldClick
                  OnEnter = edtFieldEnter
                  OnExit = edtFieldExit
                  OnKeyDown = edtFieldKeyDown
                end
                object DBEdit10: TDBEdit
                  Left = 10
                  Top = 216
                  Width = 90
                  Height = 26
                  TabStop = False
                  Color = clWhite
                  DataField = 'cover_charge'
                  DataSource = dtsSale
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clRed
                  Font.Height = -15
                  Font.Name = 'Tahoma'
                  Font.Style = [fsBold]
                  ParentFont = False
                  TabOrder = 10
                  OnClick = edtFieldClick
                  OnEnter = edtFieldEnter
                  OnExit = edtFieldExit
                  OnKeyDown = edtFieldKeyDown
                end
                object Panel1: TPanel
                  Left = 10
                  Top = 280
                  Width = 1004
                  Height = 1
                  Anchors = [akLeft, akTop, akRight]
                  BevelOuter = bvNone
                  Color = 14209468
                  ParentBackground = False
                  TabOrder = 11
                end
                object Panel20: TPanel
                  AlignWithMargins = True
                  Left = 10
                  Top = 281
                  Width = 1004
                  Height = 369
                  Margins.Left = 10
                  Margins.Top = 0
                  Margins.Right = 10
                  Margins.Bottom = 10
                  Anchors = [akLeft, akTop, akRight, akBottom]
                  BevelOuter = bvNone
                  Color = 16579576
                  ParentBackground = False
                  TabOrder = 12
                  object dbgSalePayments: TDBGrid
                    Left = 0
                    Top = 77
                    Width = 1004
                    Height = 235
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
                        Width = 450
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
                        FieldName = 'due_date'
                        Title.Caption = 'Vencimento'
                        Width = 120
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
                        FieldName = 'note'
                        Title.Caption = 'Detalhes'
                        Width = 300
                        Visible = True
                      end>
                  end
                  object Panel21: TPanel
                    Left = 0
                    Top = 0
                    Width = 1004
                    Height = 77
                    Align = alTop
                    BevelOuter = bvNone
                    Color = 16185078
                    ParentBackground = False
                    TabOrder = 1
                    DesignSize = (
                      1004
                      77)
                    object Label4: TLabel
                      Left = 717
                      Top = 8
                      Width = 160
                      Height = 18
                      Anchors = [akTop, akRight]
                      Caption = 'F7 - Digite o Valor R$'
                      Font.Charset = ANSI_CHARSET
                      Font.Color = clGray
                      Font.Height = -15
                      Font.Name = 'Tahoma'
                      Font.Style = [fsBold]
                      ParentFont = False
                      Transparent = True
                    end
                    object Label5: TLabel
                      Left = 0
                      Top = 8
                      Width = 116
                      Height = 18
                      Caption = 'F6 - Pagamento'
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = clGray
                      Font.Height = -15
                      Font.Name = 'Tahoma'
                      Font.Style = [fsBold]
                      ParentFont = False
                    end
                    object imgsale_payment_append: TImage
                      Left = 962
                      Top = 27
                      Width = 41
                      Height = 41
                      Cursor = crHandPoint
                      Anchors = [akTop, akRight]
                      Picture.Data = {
                        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000290000
                        00290806000000A86000F6000000017352474200AECE1CE90000000467414D41
                        0000B18F0BFC6105000000097048597300000EC400000EC401952B0E1B000003
                        0E4944415478DAEDD85D4853611807F0FF3ECED9DC67861F89665D1565480A15
                        115E849448481F284458E985759159A117E2A815518B15645AA06491E1450686
                        A97DA0DE58A45741E545DA8D82A6A5695B9E6DC739B7DE775031FCE89C6DAE11
                        E7D906637BCFCE6FEF39EFF33CE7C83658F7FB10E52193901232CAE2FF47F21E
                        377EF01C3CDEF945BF57C8E5D0AB34D03031FF06E9987321237E139A0E5F8151
                        AF5D748C9B9FC7D9762B5A06BAB04A6D882C92CE1CEB63F0B1F289A0F13975A7
                        30681B824AC1460EE970BB70343D0F96BC5241E3EFF7B5C1D45D03835A1759E4
                        3182BC2A02594590C64823C5CEA484949012329A90BFCA9ED7E70D44926A7332
                        B300770A2A05EDA4B6A71965CF2D30A8029132994C50D95C124981DB92B6E05E
                        BE198C5C49A07F86D1F72A56495E8C20A4C7330F273F0BB94C1E00244F54BDA8
                        F597CDE5A04B22A79D767416D52163DD4631474674CC385C48BD9E8304EDEA60
                        6672163B93B6E25191654591E667F56878D7021DAB118FF491C704378DDBFBAA
                        50B83D7745806F87079075B70829C644FFE1178DF443C9B9376AFF8AC1734FB1
                        362E31AC401F6941632F66215E1F1B70AE8A46D2A06D9993E7316EEE0A2B32CD
                        9A0FA7D7095640FB26284FBAE678AC37A4E05569435880C79BCCE81C7EB32025
                        8584A431EDB2A338FD20AC07CA42023EE8EBC09997D7B0461727781BC148BA90
                        3EDB27D07AA41A7B36EF080A38343186B45B87FEBA508246D2A0497CCC368971
                        53370C5A8DD0CD7E47E2A56CE8D51A7281A610B59DE8DA3DE7F5C0E721B362EA
                        10B5A35D35C518E1BE20865189FE734135189CDB89CC8434B497DC1434BEA2B5
                        1A0F3FB4213626B82BC6A02F69271DDF61CA2A417976E1B2E39EF7F7A2E07139
                        920D0920D53AB2489AE84748A2EF3DD1B8647DB7711C922D7B916C8C17B550C2
                        86A4415BB86F9C0D53177A20572E44A45ECE859255F8BBA85022E47B41B3A4A5
                        33327ABCAF680EF83CB7FE34FAA73E411BE22D96B02069B848C7A45368717E77
                        09D44A156EBC6EC4D0CC28F4AC36D49F0E1F928687A426879BF7277D0DA32635
                        5958431C51E44A86849490D1163F014CD185E75CC209EF0000000049454E44AE
                        426082}
                      OnClick = imgsale_payment_appendClick
                    end
                    object edtpayment_term_amount: TNumberBox
                      Tag = 1
                      Left = 717
                      Top = 27
                      Width = 244
                      Height = 41
                      Anchors = [akTop, akRight]
                      Color = clWhite
                      Font.Charset = ANSI_CHARSET
                      Font.Color = clGreen
                      Font.Height = -27
                      Font.Name = 'Calibri'
                      Font.Style = [fsBold]
                      Mode = nbmFloat
                      ParentFont = False
                      ParentShowHint = False
                      ShowHint = True
                      TabOrder = 1
                      OnClick = edtFieldClick
                      OnEnter = edtFieldEnter
                      OnExit = edtFieldExit
                      OnKeyDown = edtFieldKeyDown
                      OnKeyPress = edtpayment_term_amountKeyPress
                    end
                    object cbxPayment: TComboBox
                      Left = 0
                      Top = 27
                      Width = 707
                      Height = 41
                      Style = csDropDownList
                      Anchors = [akLeft, akTop, akRight]
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = clBlack
                      Font.Height = -27
                      Font.Name = 'Calibri'
                      Font.Style = [fsBold]
                      ParentFont = False
                      TabOrder = 0
                      OnEnter = edtFieldEnter
                      OnExit = edtFieldExit
                      OnKeyDown = edtFieldKeyDown
                    end
                  end
                  object Panel24: TPanel
                    AlignWithMargins = True
                    Left = 0
                    Top = 317
                    Width = 1004
                    Height = 52
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
                      Left = 316
                      Top = 0
                      Width = 250
                      Height = 52
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
                      object Panel22: TPanel
                        Left = 1
                        Top = 1
                        Width = 248
                        Height = 50
                        Align = alClient
                        BevelOuter = bvNone
                        Color = 16579576
                        ParentBackground = False
                        TabOrder = 0
                        object lblChange: TPanel
                          Left = 0
                          Top = 0
                          Width = 105
                          Height = 50
                          Margins.Left = 0
                          Margins.Top = 0
                          Margins.Right = 0
                          Margins.Bottom = 0
                          Align = alLeft
                          BevelOuter = bvNone
                          Caption = 'Troco:'
                          Font.Charset = ANSI_CHARSET
                          Font.Color = clBlack
                          Font.Height = -21
                          Font.Name = 'Tahoma'
                          Font.Style = []
                          ParentFont = False
                          TabOrder = 1
                        end
                        object edtchange: TDBEdit
                          Tag = 1
                          AlignWithMargins = True
                          Left = 115
                          Top = 10
                          Width = 123
                          Height = 40
                          Margins.Left = 10
                          Margins.Top = 10
                          Margins.Right = 10
                          Margins.Bottom = 0
                          TabStop = False
                          Align = alClient
                          BorderStyle = bsNone
                          Color = 16579576
                          DataField = 'remaining_change'
                          DataSource = dtsSale
                          Font.Charset = ANSI_CHARSET
                          Font.Color = clRed
                          Font.Height = -27
                          Font.Name = 'Tahoma'
                          Font.Style = [fsBold]
                          ParentFont = False
                          ParentShowHint = False
                          ReadOnly = True
                          ShowHint = False
                          TabOrder = 0
                          OnChange = edtchangeChange
                          OnClick = edtFieldClick
                          ExplicitLeft = 90
                          ExplicitWidth = 148
                        end
                      end
                    end
                    object Panel23: TPanel
                      Left = 576
                      Top = 0
                      Width = 428
                      Height = 52
                      Align = alRight
                      BevelOuter = bvNone
                      BorderWidth = 1
                      Color = 14209468
                      Enabled = False
                      ParentBackground = False
                      TabOrder = 1
                      object Panel25: TPanel
                        Left = 1
                        Top = 1
                        Width = 426
                        Height = 50
                        Align = alClient
                        BevelOuter = bvNone
                        Color = 16579576
                        ParentBackground = False
                        TabOrder = 0
                        object lblPago: TPanel
                          Left = 0
                          Top = 0
                          Width = 80
                          Height = 50
                          Margins.Left = 10
                          Margins.Top = 15
                          Margins.Right = 10
                          Margins.Bottom = 0
                          Align = alLeft
                          BevelOuter = bvNone
                          Caption = 'Pago:'
                          Font.Charset = ANSI_CHARSET
                          Font.Color = clBlack
                          Font.Height = -21
                          Font.Name = 'Tahoma'
                          Font.Style = []
                          ParentFont = False
                          TabOrder = 1
                        end
                        object edtsum_sale_payment_amount: TDBEdit
                          Tag = 1
                          AlignWithMargins = True
                          Left = 90
                          Top = 10
                          Width = 326
                          Height = 40
                          Margins.Left = 10
                          Margins.Top = 10
                          Margins.Right = 10
                          Margins.Bottom = 0
                          TabStop = False
                          Align = alClient
                          BorderStyle = bsNone
                          Color = 16579576
                          DataField = 'sum_sale_payment_amount'
                          DataSource = dtsSale
                          Font.Charset = ANSI_CHARSET
                          Font.Color = clGreen
                          Font.Height = -27
                          Font.Name = 'Tahoma'
                          Font.Style = [fsBold]
                          ParentFont = False
                          ParentShowHint = False
                          ReadOnly = True
                          ShowHint = False
                          TabOrder = 0
                          OnClick = edtFieldClick
                        end
                      end
                    end
                    object Panel27: TPanel
                      AlignWithMargins = True
                      Left = 0
                      Top = 0
                      Width = 306
                      Height = 52
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
                        Width = 304
                        Height = 50
                        Cursor = crHandPoint
                        Align = alClient
                        BevelOuter = bvNone
                        Color = 15658211
                        ParentBackground = False
                        TabOrder = 0
                        object btnDeleteAllSalePayments: TSpeedButton
                          Left = 50
                          Top = 0
                          Width = 254
                          Height = 50
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
                          ExplicitLeft = 38
                          ExplicitTop = 2
                          ExplicitWidth = 130
                          ExplicitHeight = 38
                        end
                        object Panel31: TPanel
                          Left = 0
                          Top = 0
                          Width = 50
                          Height = 50
                          Align = alLeft
                          BevelOuter = bvNone
                          Color = 12893085
                          ParentBackground = False
                          TabOrder = 0
                          object Image2: TImage
                            AlignWithMargins = True
                            Left = 5
                            Top = 5
                            Width = 40
                            Height = 40
                            Cursor = crHandPoint
                            Margins.Left = 5
                            Margins.Top = 5
                            Margins.Right = 5
                            Margins.Bottom = 5
                            Align = alClient
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
                            ExplicitWidth = 25
                            ExplicitHeight = 28
                          end
                        end
                      end
                    end
                  end
                end
                object Panel15: TPanel
                  AlignWithMargins = True
                  Left = 422
                  Top = 131
                  Width = 592
                  Height = 111
                  Margins.Left = 0
                  Margins.Top = 10
                  Margins.Right = 0
                  Margins.Bottom = 0
                  Anchors = [akLeft, akTop, akRight]
                  BevelOuter = bvNone
                  TabOrder = 13
                  object Panel16: TPanel
                    Left = 0
                    Top = 0
                    Width = 592
                    Height = 24
                    Align = alTop
                    BevelOuter = bvNone
                    Color = 7423770
                    ParentBackground = False
                    TabOrder = 0
                    object Label22: TLabel
                      AlignWithMargins = True
                      Left = 10
                      Top = 0
                      Width = 572
                      Height = 24
                      Margins.Left = 10
                      Margins.Top = 0
                      Margins.Right = 10
                      Margins.Bottom = 0
                      Align = alClient
                      Alignment = taRightJustify
                      Caption = 'TOTAL GERAL'
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = 15132390
                      Font.Height = -17
                      Font.Name = 'Segoe UI Semibold'
                      Font.Style = [fsBold]
                      ParentFont = False
                      ExplicitLeft = 479
                      ExplicitWidth = 103
                      ExplicitHeight = 23
                    end
                  end
                  object Panel17: TPanel
                    Left = 0
                    Top = 24
                    Width = 592
                    Height = 87
                    Align = alClient
                    BevelOuter = bvNone
                    Color = 9591841
                    Enabled = False
                    ParentBackground = False
                    TabOrder = 1
                    object Label6: TLabel
                      AlignWithMargins = True
                      Left = 10
                      Top = 0
                      Width = 79
                      Height = 87
                      Margins.Left = 10
                      Margins.Top = 0
                      Margins.Right = 10
                      Margins.Bottom = 0
                      Align = alLeft
                      Caption = 'R$'
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = clWhite
                      Font.Height = -67
                      Font.Name = 'Segoe UI Semibold'
                      Font.Style = [fsBold]
                      ParentFont = False
                      ExplicitHeight = 89
                    end
                    object edttotal: TDBEdit
                      AlignWithMargins = True
                      Left = 109
                      Top = 0
                      Width = 473
                      Height = 87
                      Margins.Left = 10
                      Margins.Top = 0
                      Margins.Right = 10
                      Margins.Bottom = 0
                      TabStop = False
                      Align = alClient
                      BorderStyle = bsNone
                      Color = 9591841
                      DataField = 'total'
                      DataSource = dtsSale
                      Font.Charset = DEFAULT_CHARSET
                      Font.Color = clWhite
                      Font.Height = -67
                      Font.Name = 'Segoe UI Semibold'
                      Font.Style = [fsBold]
                      ParentFont = False
                      TabOrder = 0
                      OnChange = edttotalChange
                    end
                  end
                end
              end
            end
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'pageLoading'
        object pnlMainPage03Loading: TPanel
          Left = 0
          Top = 0
          Width = 1024
          Height = 720
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object pnlLoading: TPanel
            Left = 0
            Top = 0
            Width = 1024
            Height = 660
            Align = alClient
            BevelOuter = bvNone
            Color = 16579576
            ParentBackground = False
            TabOrder = 0
            object JvGradient1: TJvGradient
              Left = 0
              Top = 0
              Width = 1024
              Height = 660
              Style = grVertical
              StartColor = 15717063
              EndColor = clWhite
              ExplicitLeft = 320
              ExplicitTop = -84
              ExplicitHeight = 617
            end
            object imgNoSearch: TSkAnimatedImage
              AlignWithMargins = True
              Left = 50
              Top = 50
              Width = 924
              Height = 560
              Margins.Left = 50
              Margins.Top = 50
              Margins.Right = 50
              Margins.Bottom = 50
              Align = alClient
              Opacity = 30
              Data = {
                7B2276223A22342E382E30222C226D657461223A7B2267223A224C6F74746965
                46696C657320414520312E302E30222C2261223A22222C226B223A22222C2264
                223A22222C227463223A22227D2C226672223A32392E39373030303132323037
                3033312C226970223A302C226F70223A33312E30303030303132363236353539
                2C2277223A3530302C2268223A3530302C226E6D223A224C6F6164696E672022
                2C22646464223A302C22617373657473223A5B5D2C226C6179657273223A5B7B
                22646464223A302C22696E64223A352C227479223A342C226E6D223A22526563
                74616E676C655F31222C227372223A312C226B73223A7B226F223A7B2261223A
                302C226B223A3130302C226978223A31317D2C2272223A7B2261223A302C226B
                223A34352C226978223A31307D2C2270223A7B2261223A312C226B223A5B7B22
                69223A7B2278223A302E3636372C2279223A317D2C226F223A7B2278223A302E
                3333332C2279223A307D2C2274223A302C2273223A5B3235302C3135372E3337
                352C305D2C22746F223A5B31352E3434382C31352E3433382C305D2C22746922
                3A5B302E3033312C2D302E3035322C305D7D2C7B2269223A7B2278223A302E36
                36372C2279223A317D2C226F223A7B2278223A302E3333332C2279223A307D2C
                2274223A31352C2273223A5B3334322E3638382C3235302C305D2C22746F223A
                5B2D302E3035392C302E3039382C305D2C227469223A5B31352E3434382C2D31
                352E3432372C305D7D2C7B2274223A33302E303030303031323231393235312C
                2273223A5B3235302C3334322E3536332C305D7D5D2C226978223A327D2C2261
                223A7B2261223A302C226B223A5B2D3132352C2D3130372C305D2C226978223A
                317D2C2273223A7B2261223A302C226B223A5B3130302C3130302C3130305D2C
                226978223A367D7D2C22616F223A302C22736861706573223A5B7B227479223A
                226772222C226974223A5B7B22696E64223A302C227479223A227368222C2269
                78223A312C226B73223A7B2261223A302C226B223A7B2269223A5B5B302C305D
                2C5B302C305D2C5B302C305D2C5B302C305D5D2C226F223A5B5B302C305D2C5B
                302C305D2C5B302C305D2C5B302C305D5D2C2276223A5B5B35372C2D35375D2C
                5B35372C35375D2C5B2D35372C35375D2C5B2D35372C2D35375D5D2C2263223A
                747275657D2C226978223A327D2C226E6D223A22506174682031222C226D6E22
                3A224144424520566563746F72205368617065202D2047726F7570222C226864
                223A66616C73657D2C7B227479223A227374222C2263223A7B2261223A302C22
                6B223A5B312C312C312C315D2C226978223A337D2C226F223A7B2261223A302C
                226B223A3130302C226978223A347D2C2277223A7B2261223A302C226B223A30
                2C226978223A357D2C226C63223A312C226C6A223A312C226D6C223A342C2262
                6D223A302C226E6D223A225374726F6B652031222C226D6E223A224144424520
                566563746F722047726170686963202D205374726F6B65222C226864223A6661
                6C73657D2C7B227479223A22666C222C2263223A7B2261223A302C226B223A5B
                302E33383832333532393431313736343730372C302E36393431313736343730
                3538383233352C302E393337323534393031393630373834332C315D2C226978
                223A347D2C226F223A7B2261223A302C226B223A3130302C226978223A357D2C
                2272223A312C22626D223A302C226E6D223A2246696C6C2031222C226D6E223A
                224144424520566563746F722047726170686963202D2046696C6C222C226864
                223A66616C73657D2C7B227479223A227472222C2270223A7B2261223A302C22
                6B223A5B2D3132352C2D3130375D2C226978223A327D2C2261223A7B2261223A
                302C226B223A5B302C305D2C226978223A317D2C2273223A7B2261223A302C22
                6B223A5B3130302C3130305D2C226978223A337D2C2272223A7B2261223A302C
                226B223A302C226978223A367D2C226F223A7B2261223A302C226B223A313030
                2C226978223A377D2C22736B223A7B2261223A302C226B223A302C226978223A
                347D2C227361223A7B2261223A302C226B223A302C226978223A357D2C226E6D
                223A225472616E73666F726D227D5D2C226E6D223A2252656374616E676C6520
                31222C226E70223A332C22636978223A322C22626D223A302C226978223A312C
                226D6E223A224144424520566563746F722047726F7570222C226864223A6661
                6C73657D5D2C226970223A302C226F70223A39302E3030303030333636353737
                35312C227374223A302C22626D223A307D2C7B22646464223A302C22696E6422
                3A362C227479223A342C226E6D223A2252656374616E676C655F32222C227372
                223A312C226B73223A7B226F223A7B2261223A302C226B223A3130302C226978
                223A31317D2C2272223A7B2261223A302C226B223A34352C226978223A31307D
                2C2270223A7B2261223A312C226B223A5B7B2269223A7B2278223A302E363637
                2C2279223A317D2C226F223A7B2278223A302E3333332C2279223A307D2C2274
                223A302C2273223A5B3334322E3638382C3235302C305D2C22746F223A5B302E
                3035322C2D302E3037332C305D2C227469223A5B2D302E30312C302C305D7D2C
                7B2269223A7B2278223A302E3636372C2279223A317D2C226F223A7B2278223A
                302E3333332C2279223A307D2C2274223A31352C2273223A5B3235302C333432
                2E3536332C305D2C22746F223A5B302E3130342C302C305D2C227469223A5B30
                2E3139382C2D302E3037332C305D7D2C7B2274223A33302E3030303030313232
                31393235312C2273223A5B3135372E3331332C3235302C305D7D5D2C22697822
                3A327D2C2261223A7B2261223A302C226B223A5B2D3132352C2D3130372C305D
                2C226978223A317D2C2273223A7B2261223A302C226B223A5B3130302C313030
                2C3130305D2C226978223A367D7D2C22616F223A302C22736861706573223A5B
                7B227479223A226772222C226974223A5B7B22696E64223A302C227479223A22
                7368222C226978223A312C226B73223A7B2261223A302C226B223A7B2269223A
                5B5B302C305D2C5B302C305D2C5B302C305D2C5B302C305D5D2C226F223A5B5B
                302C305D2C5B302C305D2C5B302C305D2C5B302C305D5D2C2276223A5B5B3537
                2C2D35375D2C5B35372C35375D2C5B2D35372C35375D2C5B2D35372C2D35375D
                5D2C2263223A747275657D2C226978223A327D2C226E6D223A22506174682031
                222C226D6E223A224144424520566563746F72205368617065202D2047726F75
                70222C226864223A66616C73657D2C7B227479223A227374222C2263223A7B22
                61223A302C226B223A5B312C312C312C315D2C226978223A337D2C226F223A7B
                2261223A302C226B223A3130302C226978223A347D2C2277223A7B2261223A30
                2C226B223A302C226978223A357D2C226C63223A312C226C6A223A312C226D6C
                223A342C22626D223A302C226E6D223A225374726F6B652031222C226D6E223A
                224144424520566563746F722047726170686963202D205374726F6B65222C22
                6864223A66616C73657D2C7B227479223A22666C222C2263223A7B2261223A30
                2C226B223A5B302E333834333133373235343930313936312C302E3437383433
                3133373235343930313936332C302E383738343331333732353439303139362C
                315D2C226978223A347D2C226F223A7B2261223A302C226B223A3130302C2269
                78223A357D2C2272223A312C22626D223A302C226E6D223A2246696C6C203122
                2C226D6E223A224144424520566563746F722047726170686963202D2046696C
                6C222C226864223A66616C73657D2C7B227479223A227472222C2270223A7B22
                61223A302C226B223A5B2D3132352C2D3130375D2C226978223A327D2C226122
                3A7B2261223A302C226B223A5B302C305D2C226978223A317D2C2273223A7B22
                61223A302C226B223A5B3130302C3130305D2C226978223A337D2C2272223A7B
                2261223A302C226B223A302C226978223A367D2C226F223A7B2261223A302C22
                6B223A3130302C226978223A377D2C22736B223A7B2261223A302C226B223A30
                2C226978223A347D2C227361223A7B2261223A302C226B223A302C226978223A
                357D2C226E6D223A225472616E73666F726D227D5D2C226E6D223A2252656374
                616E676C652031222C226E70223A332C22636978223A322C22626D223A302C22
                6978223A312C226D6E223A224144424520566563746F722047726F7570222C22
                6864223A66616C73657D5D2C226970223A302C226F70223A39302E3030303030
                33363635373735312C227374223A302C22626D223A307D2C7B22646464223A30
                2C22696E64223A372C227479223A342C226E6D223A2252656374616E676C655F
                33222C227372223A312C226B73223A7B226F223A7B2261223A302C226B223A31
                30302C226978223A31317D2C2272223A7B2261223A302C226B223A34352C2269
                78223A31307D2C2270223A7B2261223A312C226B223A5B7B2269223A7B227822
                3A302E3636372C2279223A317D2C226F223A7B2278223A302E3333332C227922
                3A307D2C2274223A302C2273223A5B3235302C3334322E3536332C305D2C2274
                6F223A5B302E3035322C302E3139382C305D2C227469223A5B302E30342C2D30
                2E3031322C305D7D2C7B2269223A7B2278223A302E3636372C2279223A317D2C
                226F223A7B2278223A302E3333332C2279223A307D2C2274223A31352C227322
                3A5B3135372E3331332C3235302C305D2C22746F223A5B2D302E3439322C302E
                3134352C305D2C227469223A5B302E3035322C2D302E3536332C305D7D2C7B22
                74223A33302E303030303031323231393235312C2273223A5B3235302C313537
                2E3337352C305D7D5D2C226978223A327D2C2261223A7B2261223A302C226B22
                3A5B2D3132352C2D3130372C305D2C226978223A317D2C2273223A7B2261223A
                302C226B223A5B3130302C3130302C3130305D2C226978223A367D7D2C22616F
                223A302C22736861706573223A5B7B227479223A226772222C226974223A5B7B
                22696E64223A302C227479223A227368222C226978223A312C226B73223A7B22
                61223A302C226B223A7B2269223A5B5B302C305D2C5B302C305D2C5B302C305D
                2C5B302C305D5D2C226F223A5B5B302C305D2C5B302C305D2C5B302C305D2C5B
                302C305D5D2C2276223A5B5B35372C2D35375D2C5B35372C35375D2C5B2D3537
                2C35375D2C5B2D35372C2D35375D5D2C2263223A747275657D2C226978223A32
                7D2C226E6D223A22506174682031222C226D6E223A224144424520566563746F
                72205368617065202D2047726F7570222C226864223A66616C73657D2C7B2274
                79223A227374222C2263223A7B2261223A302C226B223A5B312C312C312C315D
                2C226978223A337D2C226F223A7B2261223A302C226B223A3130302C22697822
                3A347D2C2277223A7B2261223A302C226B223A302C226978223A357D2C226C63
                223A312C226C6A223A312C226D6C223A342C22626D223A302C226E6D223A2253
                74726F6B652031222C226D6E223A224144424520566563746F72204772617068
                6963202D205374726F6B65222C226864223A66616C73657D2C7B227479223A22
                666C222C2263223A7B2261223A302C226B223A5B302E33383832333532393431
                313736343730372C302E363934313137363437303538383233352C302E393337
                323534393031393630373834332C315D2C226978223A347D2C226F223A7B2261
                223A302C226B223A3130302C226978223A357D2C2272223A312C22626D223A30
                2C226E6D223A2246696C6C2031222C226D6E223A224144424520566563746F72
                2047726170686963202D2046696C6C222C226864223A66616C73657D2C7B2274
                79223A227472222C2270223A7B2261223A302C226B223A5B2D3132352C2D3130
                375D2C226978223A327D2C2261223A7B2261223A302C226B223A5B302C305D2C
                226978223A317D2C2273223A7B2261223A302C226B223A5B3130302C3130305D
                2C226978223A337D2C2272223A7B2261223A302C226B223A302C226978223A36
                7D2C226F223A7B2261223A302C226B223A3130302C226978223A377D2C22736B
                223A7B2261223A302C226B223A302C226978223A347D2C227361223A7B226122
                3A302C226B223A302C226978223A357D2C226E6D223A225472616E73666F726D
                227D5D2C226E6D223A2252656374616E676C652031222C226E70223A332C2263
                6978223A322C22626D223A302C226978223A312C226D6E223A22414442452056
                6563746F722047726F7570222C226864223A66616C73657D5D2C226970223A30
                2C226F70223A39302E303030303033363635373735312C227374223A302C2262
                6D223A307D2C7B22646464223A302C22696E64223A382C227479223A342C226E
                6D223A2252656374616E676C655F34222C227372223A312C226B73223A7B226F
                223A7B2261223A302C226B223A3130302C226978223A31317D2C2272223A7B22
                61223A302C226B223A34352C226978223A31307D2C2270223A7B2261223A312C
                226B223A5B7B2269223A7B2278223A302E3636372C2279223A317D2C226F223A
                7B2278223A302E3333332C2279223A307D2C2274223A302C2273223A5B313537
                2E3331332C3235302C305D2C22746F223A5B31352E3434382C2D31352E343338
                2C305D2C227469223A5B2D302E3037392C302E3532352C305D7D2C7B2269223A
                7B2278223A302E3636372C2279223A317D2C226F223A7B2278223A302E333333
                2C2279223A307D2C2274223A31352C2273223A5B3235302C3135372E3337352C
                305D2C22746F223A5B302E3031392C2D302E3132352C305D2C227469223A5B2D
                31352E3434382C2D31352E3433382C305D7D2C7B2274223A33302E3030303030
                31323231393235312C2273223A5B3334322E3638382C3235302C305D7D5D2C22
                6978223A327D2C2261223A7B2261223A302C226B223A5B2D3132352C2D313037
                2C305D2C226978223A317D2C2273223A7B2261223A302C226B223A5B3130302C
                3130302C3130305D2C226978223A367D7D2C22616F223A302C22736861706573
                223A5B7B227479223A226772222C226974223A5B7B22696E64223A302C227479
                223A227368222C226978223A312C226B73223A7B2261223A302C226B223A7B22
                69223A5B5B302C305D2C5B302C305D2C5B302C305D2C5B302C305D5D2C226F22
                3A5B5B302C305D2C5B302C305D2C5B302C305D2C5B302C305D5D2C2276223A5B
                5B35372C2D35375D2C5B35372C35375D2C5B2D35372C35375D2C5B2D35372C2D
                35375D5D2C2263223A747275657D2C226978223A327D2C226E6D223A22506174
                682031222C226D6E223A224144424520566563746F72205368617065202D2047
                726F7570222C226864223A66616C73657D2C7B227479223A227374222C226322
                3A7B2261223A302C226B223A5B312C312C312C315D2C226978223A337D2C226F
                223A7B2261223A302C226B223A3130302C226978223A347D2C2277223A7B2261
                223A302C226B223A302C226978223A357D2C226C63223A312C226C6A223A312C
                226D6C223A342C22626D223A302C226E6D223A225374726F6B652031222C226D
                6E223A224144424520566563746F722047726170686963202D205374726F6B65
                222C226864223A66616C73657D2C7B227479223A22666C222C2263223A7B2261
                223A302C226B223A5B302E333834333133373235343930313936312C302E3437
                3834333133373235343930313936332C302E3837383433313337323534393031
                39362C315D2C226978223A347D2C226F223A7B2261223A302C226B223A313030
                2C226978223A357D2C2272223A312C22626D223A302C226E6D223A2246696C6C
                2031222C226D6E223A224144424520566563746F722047726170686963202D20
                46696C6C222C226864223A66616C73657D2C7B227479223A227472222C227022
                3A7B2261223A302C226B223A5B2D3132352C2D3130375D2C226978223A327D2C
                2261223A7B2261223A302C226B223A5B302C305D2C226978223A317D2C227322
                3A7B2261223A302C226B223A5B3130302C3130305D2C226978223A337D2C2272
                223A7B2261223A302C226B223A302C226978223A367D2C226F223A7B2261223A
                302C226B223A3130302C226978223A377D2C22736B223A7B2261223A302C226B
                223A302C226978223A347D2C227361223A7B2261223A302C226B223A302C2269
                78223A357D2C226E6D223A225472616E73666F726D227D5D2C226E6D223A2252
                656374616E676C652031222C226E70223A332C22636978223A322C22626D223A
                302C226978223A312C226D6E223A224144424520566563746F722047726F7570
                222C226864223A66616C73657D5D2C226970223A302C226F70223A39302E3030
                30303033363635373735312C227374223A302C22626D223A307D5D2C226D6172
                6B657273223A5B5D7D}
            end
          end
          object Panel40: TPanel
            Left = 0
            Top = 660
            Width = 1024
            Height = 60
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            object JvTransparentButton2: TPanel
              Left = 0
              Top = 0
              Width = 1024
              Height = 60
              Cursor = crHandPoint
              Align = alClient
              BevelOuter = bvNone
              Caption = 'Aguarde...'
              Color = 14711394
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -27
              Font.Name = 'Segoe UI Semibold'
              Font.Style = [fsBold]
              ParentBackground = False
              ParentFont = False
              TabOrder = 0
            end
          end
        end
      end
    end
  end
  object btnFocus: TButton
    Left = -1000
    Top = -1000
    Width = 75
    Height = 25
    Caption = 'Focus'
    TabOrder = 1
    TabStop = False
  end
  object tmrLivre: TTimer
    OnTimer = tmrLivreTimer
    Left = 960
    Top = 13
  end
  object dtsSale: TDataSource
    Left = 735
    Top = 13
  end
  object dtsSaleItems: TDataSource
    OnDataChange = dtsSaleItemsDataChange
    Left = 796
    Top = 13
  end
  object dtsSalePayments: TDataSource
    Left = 884
    Top = 13
  end
  object tmrUpdateLayout: TTimer
    Interval = 1
    OnTimer = tmrUpdateLayoutTimer
    Left = 944
    Top = 68
  end
end
