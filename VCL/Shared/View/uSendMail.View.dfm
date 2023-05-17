object SendMailView: TSendMailView
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'SendMailView'
  ClientHeight = 652
  ClientWidth = 986
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poDesktopCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object pnlBackground: TPanel
    Left = 0
    Top = 0
    Width = 986
    Height = 652
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 1
    Color = 8747344
    ParentBackground = False
    TabOrder = 0
    object pnlContent: TPanel
      Left = 1
      Top = 1
      Width = 984
      Height = 650
      Align = alClient
      BevelOuter = bvNone
      Color = 16381936
      ParentBackground = False
      TabOrder = 0
      object pgc: TPageControl
        AlignWithMargins = True
        Left = 20
        Top = 83
        Width = 944
        Height = 487
        Margins.Left = 20
        Margins.Top = 10
        Margins.Right = 20
        Margins.Bottom = 20
        ActivePage = tabMain
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitLeft = 76
        object tabMain: TTabSheet
          Caption = '     Geral     '
          object pnlGeral: TPanel
            Left = 0
            Top = 0
            Width = 936
            Height = 454
            Align = alClient
            BevelOuter = bvNone
            Color = 16381936
            ParentBackground = False
            TabOrder = 0
            DesignSize = (
              936
              454)
            object Label12: TLabel
              Left = 20
              Top = 10
              Width = 105
              Height = 14
              Caption = 'Para (Destinat'#225'rio):'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object imgRecipientAdd: TImage
              Left = 436
              Top = 25
              Width = 26
              Height = 26
              Cursor = crHandPoint
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
              OnClick = imgRecipientAddClick
            end
            object Label3: TLabel
              Left = 472
              Top = 10
              Width = 33
              Height = 14
              Caption = 'C'#243'pia:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object imgRecipientCopyAdd: TImage
              Left = 898
              Top = 25
              Width = 26
              Height = 26
              Cursor = crHandPoint
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
              OnClick = imgRecipientCopyAddClick
            end
            object Label5: TLabel
              Left = 20
              Top = 183
              Width = 58
              Height = 14
              Caption = 'Mensagem'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label7: TLabel
              Left = 10
              Top = 358
              Width = 40
              Height = 14
              Caption = 'Anexos'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label10: TLabel
              Left = 10
              Top = 10
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
              Left = 10
              Top = 183
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
            object Label8: TLabel
              Left = 20
              Top = 132
              Width = 44
              Height = 14
              Caption = 'Assunto'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label9: TLabel
              Left = 10
              Top = 132
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
            object edtRecipient: TEdit
              Left = 10
              Top = 25
              Width = 425
              Height = 26
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              OnEnter = edtRecipientEnter
              OnExit = edtRecipientExit
              OnKeyDown = edtRecipientKeyDown
              OnKeyPress = edtRecipientKeyPress
            end
            object Panel1: TPanel
              Left = 10
              Top = 52
              Width = 452
              Height = 70
              BevelOuter = bvNone
              BorderWidth = 1
              Color = clGray
              ParentBackground = False
              TabOrder = 1
              object Panel2: TPanel
                Left = 1
                Top = 48
                Width = 450
                Height = 21
                Align = alBottom
                BevelOuter = bvNone
                Color = clWhite
                ParentBackground = False
                TabOrder = 0
                object Label1: TLabel
                  AlignWithMargins = True
                  Left = 3
                  Top = 3
                  Width = 444
                  Height = 15
                  Align = alClient
                  Alignment = taCenter
                  Caption = '[Duplo clique] para remover o item.'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clGray
                  Font.Height = -12
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentFont = False
                  ExplicitWidth = 195
                  ExplicitHeight = 14
                end
              end
              object ltbRecipientList: TListBox
                Left = 1
                Top = 1
                Width = 450
                Height = 47
                TabStop = False
                Align = alClient
                BorderStyle = bsNone
                ItemHeight = 18
                TabOrder = 1
                OnDblClick = ltbRecipientListDblClick
              end
            end
            object edtRecipientCopy: TEdit
              Left = 472
              Top = 25
              Width = 425
              Height = 26
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 2
              OnEnter = edtRecipientEnter
              OnExit = edtRecipientExit
              OnKeyDown = edtRecipientKeyDown
              OnKeyPress = edtRecipientCopyKeyPress
            end
            object Panel3: TPanel
              Left = 472
              Top = 52
              Width = 452
              Height = 70
              BevelOuter = bvNone
              BorderWidth = 1
              Color = clGray
              ParentBackground = False
              TabOrder = 3
              object Panel4: TPanel
                Left = 1
                Top = 48
                Width = 450
                Height = 21
                Align = alBottom
                BevelOuter = bvNone
                Color = clWhite
                ParentBackground = False
                TabOrder = 0
                object Label4: TLabel
                  AlignWithMargins = True
                  Left = 3
                  Top = 3
                  Width = 444
                  Height = 15
                  Align = alClient
                  Alignment = taCenter
                  Caption = '[Duplo clique] para remover o item.'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clGray
                  Font.Height = -12
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentFont = False
                  ExplicitWidth = 195
                  ExplicitHeight = 14
                end
              end
              object ltbRecipientCopyList: TListBox
                Left = 1
                Top = 1
                Width = 450
                Height = 47
                TabStop = False
                Align = alClient
                BorderStyle = bsNone
                ItemHeight = 18
                TabOrder = 1
                OnDblClick = ltbRecipientCopyListDblClick
              end
            end
            object memBodyMessage: TMemo
              Left = 10
              Top = 198
              Width = 914
              Height = 150
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 5
              OnEnter = edtRecipientEnter
              OnExit = edtRecipientExit
            end
            object Panel5: TPanel
              Left = 10
              Top = 373
              Width = 914
              Height = 70
              Anchors = [akLeft, akTop, akBottom]
              BevelOuter = bvNone
              BorderWidth = 1
              Color = clGray
              ParentBackground = False
              TabOrder = 6
              object Panel6: TPanel
                Left = 1
                Top = 48
                Width = 912
                Height = 21
                Align = alBottom
                BevelOuter = bvNone
                Color = clWhite
                ParentBackground = False
                TabOrder = 0
                object Label11: TLabel
                  AlignWithMargins = True
                  Left = 3
                  Top = 3
                  Width = 906
                  Height = 15
                  Align = alClient
                  Alignment = taCenter
                  Caption = '[Duplo clique] para abrir o item.'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clGray
                  Font.Height = -12
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentFont = False
                  ExplicitWidth = 173
                  ExplicitHeight = 14
                end
              end
              object ltbAttachments: TListBox
                Left = 1
                Top = 1
                Width = 912
                Height = 47
                TabStop = False
                Align = alClient
                BorderStyle = bsNone
                ItemHeight = 18
                TabOrder = 1
                OnDblClick = ltbAttachmentsDblClick
              end
            end
            object edtSubject: TEdit
              Left = 10
              Top = 147
              Width = 914
              Height = 26
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 4
              OnEnter = edtRecipientEnter
              OnExit = edtRecipientExit
              OnKeyPress = edtRecipientKeyPress
            end
          end
        end
      end
      object Panel7: TPanel
        AlignWithMargins = True
        Left = 20
        Top = 53
        Width = 944
        Height = 20
        Hint = 
          '[L-1] = Configura'#231#227'o em m'#225'quina Local; [R-2] = Configura'#231#227'o em r' +
          'ede; '
        Margins.Left = 20
        Margins.Top = 0
        Margins.Right = 20
        Margins.Bottom = 0
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 
          'Aten'#231#227'o: Se o e-mail for inv'#225'lido ou inexistente, o sistema n'#227'o ' +
          'ir'#225' acusar erro. O sistema valida apenas o envio(disparo do e-ma' +
          'il) e n'#227'o o retorno.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 185
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object pnlTitulo: TPanel
        AlignWithMargins = True
        Left = 20
        Top = 20
        Width = 944
        Height = 33
        Margins.Left = 20
        Margins.Top = 20
        Margins.Right = 20
        Margins.Bottom = 0
        Align = alTop
        BevelOuter = bvNone
        Color = 16381936
        ParentBackground = False
        TabOrder = 2
        object Label2: TLabel
          AlignWithMargins = True
          Left = 37
          Top = 0
          Width = 172
          Height = 32
          Margins.Left = 5
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alLeft
          Caption = 'Envio de E-mail'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 8747344
          Font.Height = -24
          Font.Name = 'Segoe UI Light'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object imgCloseTitle: TImage
          AlignWithMargins = True
          Left = 912
          Top = 0
          Width = 32
          Height = 32
          Cursor = crHandPoint
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 0
          Align = alRight
          Center = True
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000190000
            00190806000000C4E98563000000017352474200AECE1CE90000000467414D41
            0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000002
            4E4944415478DA9D56D171DB300C253B81BA813C41A2096A4F107B82DA1334FE
            4BAF699B5CDA4BAE3F4927B03B41992E906E606D606D502D90B00FA74705A625
            5A09EF708A49000F201EC0589358D38FDF33F940DE437248469155414AC8BDBB
            FEB44EF9B109E75F2173E5F4D0BA03D8721008008EF159418E55C44E2286D414
            C3F323C8A90A44325B00ACEC0521C0038DC4D925640DA3DA2416EC4E9979002B
            3490ED0110851914AB815715AEF881194A509300643B144A2AD4430122B00DFD
            54F031D22092EA052318BD164005FC8F3F2FE0EBD27273CB6B5A683AE26C8ECF
            89317EE9AECFF7AE6E7AF62D37D6DEE2CF9FB0FB1BD909796AECBFB56AA362C1
            6AA5FCDB347D523D3D3E167F7E7CD1677225729E431CEC6651465B9E2DAC72B4
            C7739CE5AC55DE04E12792113308FB9D2481AD6428AC7356218AA28BAFE4E4EC
            2AB3F68D5CC55153338F88ED2A0540902933AD05C4737FD447D928A3B09234A7
            CD7630088DC6046A96F785BB392F13FA01C46890221E07ADC16E0DC26A6BD403
            22C4D80490644D22808A3559AB1A159DF47EAE49252052C4B9E962570F8B4886
            8D89581781ECB04B00DAC68914DB3E31CDA8691D45ACDBE9133678086266A331
            1077BC14FB0364D9450A022140FF0B9938652719DC1A8EA9AED955BC64FA76D4
            226716127C33BB3AD22B7150BC122063B1C7464D73FD9E08C0963F4BEF9F26F7
            379F074F6302AC58C3FDF724AA4168B89AB5580F703E37CF2FA3D82D743BF4BD
            F161BA0630019237BEE25EC6F3778C3CE81E7EE323B0C090212BF9FF803D64CD
            3E9288C751763523970C5DEA35FD0FC9585A0E3CB3F02C0000000049454E44AE
            426082}
          OnClick = imgCloseTitleClick
          ExplicitLeft = 726
          ExplicitTop = 1
        end
        object imgMinimizeTitle: TImage
          AlignWithMargins = True
          Left = 875
          Top = 0
          Width = 32
          Height = 32
          Cursor = crHandPoint
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 5
          Margins.Bottom = 0
          Align = alRight
          Center = True
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000190000
            00190806000000C4E98563000000017352474200AECE1CE90000000467414D41
            0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
            DA4944415478DAAD96DF51C24010C6EF2A3074A0150015483A800E4205CAA3E3
            033AA3E32358018C0D182B201D4807C40AA403FC3ED8C59D04720472333B8164
            6F7FFBE76EEFBCAB18FD87D7088F0EE4967F2191C81AB284E490AFF4ED31ABB2
            E303C627F20C0D02DF019B9F0411C04C3C5703293D16CF9D4443781B9240AE8D
            6E0CD8FA2804004EFC9449541C42B2E2A4B2632F70C84FCC3C82962508005458
            88223D1F868C1FC8001DEC09E846E75B0815FA9BCDE6C37B7F570750802D04C4
            0CC47B083EF4C50BE6BC7B2EC044F42D196136E60AE1CB8EBE3C17604089DB2D
            9E35ECB5BC89E2E0CAB800B49268BA848CF1E38902C07313008170B5DDD3AED7
            82430680A40D423443A9376171C9E546895E5CD5B0FB63EB290BE017925B484B
            EB81773DB7DB337547AC7D2C08692812DA5C2944374F1CEAA67586C946E6CD2A
            1801326D10A2AB76EA0D71BB711A02D85D3FD01DAF75696AC7EF3738EC751592
            386903CE74CF0BA2A0D391B3BD4B3E96BAE799003DF052D819F0BD2F28681E33
            B7EB0075CF1305E4CE74F3E2C948801E5C5418856A64EE03339947406CBBC7B1
            335E4F382793EC19AFD1D95B8C5E3632A9436E6D1EBCAD082CC163ECFE2F0955
            637B5B913A9452EC43B36539B6253202F5DE958BE7DB08ABEAF7076C97FD7112
            7FAD0C0000000049454E44AE426082}
          OnClick = imgMinimizeTitleClick
          ExplicitLeft = 689
          ExplicitTop = 1
        end
        object imgTitle: TImage
          Left = 0
          Top = 0
          Width = 32
          Height = 32
          Align = alLeft
          Center = True
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000190000
            00190806000000C4E98563000000017352474200AECE1CE90000000467414D41
            0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
            4E4944415478DADD96CD6DC24010853DA92025B80497E05460D301AE20E64694
            034110E508544052014E0571092EC125D081332F7AC0C444CB1A2B0831D268B5
            7FF3CDBCDD3548700193DB81A44FAF5FDA46FFC8A80069CC404DEF6B217D5F09
            2095A9262BDE9EDFCF8DAEF1726D26EC6E01DB411074A5BE61062B05E51D83DF
            6BB3501F32E94CFD11FD3D4483665CBCB60B75BCF2004426C1A5FA54F76D77B1
            8E203F9BC6F36120B26677A4734B4F7946566A27C464874551D3341F229223BB
            963C984F59F540E7EB560C37C42C84CE390F11814A1D8B09F825CF1F7BFD20B0
            643C8B45EEA039B22FD4634EE1CC8A1352265E1023CF868092803AF0306F8881
            0152B5E5E1F884D295BD200E78CA4A8F1EF3F543183861370C0EE75573EC1317
            A32F04B767E158F2A271A7D72F575708AEE3C90FA15A89F2CF8174F965C4FB78
            70541322E1F61BBAA13F1297807C0365D3E54F0F647E540000000049454E44AE
            426082}
          ExplicitLeft = 8
          ExplicitTop = 1
        end
        object pnlTitle2: TPanel
          Left = 0
          Top = 32
          Width = 944
          Height = 1
          Align = alBottom
          BevelOuter = bvNone
          Color = 14209468
          ParentBackground = False
          TabOrder = 0
        end
      end
      object pnlBottomButtons: TPanel
        AlignWithMargins = True
        Left = 20
        Top = 590
        Width = 944
        Height = 40
        Margins.Left = 20
        Margins.Top = 0
        Margins.Right = 20
        Margins.Bottom = 20
        Align = alBottom
        BevelOuter = bvNone
        Color = 16381936
        ParentBackground = False
        TabOrder = 3
        object pnlSave: TPanel
          Left = 774
          Top = 0
          Width = 170
          Height = 40
          Cursor = crHandPoint
          Align = alRight
          BevelOuter = bvNone
          BorderWidth = 1
          Color = 3299352
          ParentBackground = False
          TabOrder = 0
          object pnlSave2: TPanel
            Left = 1
            Top = 1
            Width = 168
            Height = 38
            Cursor = crHandPoint
            Align = alClient
            BevelOuter = bvNone
            Color = 5212710
            ParentBackground = False
            TabOrder = 0
            object btnSendMail: TSpeedButton
              Left = 38
              Top = 0
              Width = 130
              Height = 38
              Cursor = crHandPoint
              Align = alClient
              Caption = 'Enviar E-mail'
              Flat = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWhite
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              OnClick = btnSendMailClick
              ExplicitLeft = 62
              ExplicitTop = 2
            end
            object pnlSave3: TPanel
              Left = 0
              Top = 0
              Width = 38
              Height = 38
              Align = alLeft
              BevelOuter = bvNone
              Color = 4552994
              ParentBackground = False
              TabOrder = 0
              object imgSave: TImage
                AlignWithMargins = True
                Left = 5
                Top = 5
                Width = 25
                Height = 28
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
                  494944415478DADD96816DC2301045E3640146C80819219D00BA0199A06102CA
                  04C004B41340276846C808198101A2A4FF4B3FD484CA38444588934EC167E7DE
                  DDB70D98E00E669E07D2B6ED379EC93F324A425A2B50C9C75A2C3F7542486975
                  9319633E6ECD8E74391E4B0D8F84751026DDC2F70C22B40DC3301F987C82C71A
                  3E57D119FC8DE31304D5675ABCB317225E7A0092AE40F806BEC27BC72ED70584
                  D634CD1CE39D860B7CDE78CAB3B0A57642ACEAB82801F493F2B1BA9E3C9C9FA9
                  EB57CC57BD1C6E88B5903AE7DA44262A104B053893E78F77FD20B4BAAED3288A
                  A839AB3FC0534D71CF0E57A49C7A412C79F602140254818779432C1821655F1E
                  C59792AE180571C067EAF4E2323F3E4489A71AC6C1EF7E558A7DF1608C85F0F4
                  AC1D4BDE9177F5F8720D85F0385EFD2284156CFF16C8905F46DE8F174737310B
                  EEDFA127FA23710FC80F0BD6F77603C30F9F0000000049454E44AE426082}
                ExplicitLeft = 13
                ExplicitTop = 10
              end
            end
          end
        end
        object pnlCancel: TPanel
          AlignWithMargins = True
          Left = 594
          Top = 0
          Width = 170
          Height = 40
          Cursor = crHandPoint
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 0
          Align = alRight
          BevelOuter = bvNone
          BorderWidth = 1
          Color = 8747344
          ParentBackground = False
          TabOrder = 1
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
              Left = 38
              Top = 0
              Width = 130
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
              OnClick = imgCloseTitleClick
              ExplicitLeft = 54
              ExplicitTop = 2
            end
            object pnlCancel3: TPanel
              Left = 0
              Top = 0
              Width = 38
              Height = 38
              Align = alLeft
              BevelOuter = bvNone
              Color = 12893085
              ParentBackground = False
              TabOrder = 0
              object imgCancel4: TImage
                AlignWithMargins = True
                Left = 5
                Top = 5
                Width = 25
                Height = 28
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
                  DA4944415478DABD56D171C2300CB5F9E083AF74033241610398A06182C20485
                  091A26A01B1026289D0036804E001BE03F3E38A04FA0E45463A781E4AA3B5D63
                  4BD6B3A42753ADFE417451C7F3F91CE04F07DA846EB5D6F34A410040C13FA181
                  D836D01EC096A5414EA7530B811616809436ECEB5220C862C165A29B8FA109B4
                  0F9DB00B952E7C18040043116C8C60B1B04D198C64005B723708377AC365DA72
                  598C655FA92B11CCE17008EBF5BAB917E4E6A61CB895361BEB485D0941DFB35A
                  ADD62F0CC26C5AF0728EA0BDE3F11820489A99D9EFF761A3D130A2674A7948A0
                  1D0001DF8E0E52FA5D3A68F54766D7E4B292ACB1D72E0222837DE0D088F76530
                  C5E069D9C87F28C1BD201C6895D3EC0D377A89FDAE957D46023EB7758260F0E8
                  E66FBE1B21183576EAB1652448FB7803E26AB6A75F2B3B43617792403B1C72DF
                  24F8B57CCF88D5B7EC25D08E66C7308E3D41E8122FD0AF9C4B64F385EF01689F
                  E8BF26DB2A553627D030C7EF3709AC2CBC6F101FDEF1F2864196AF24C1884068
                  11A902AF29D817C1E795CB95E4F922EE8EB39E4B1083834FAA02B14A76E9C93B
                  3E62B6D34FEA8CCBF1A8100091A3CFEBF8D278284DF073155958197D236E27A5
                  30A14F047A59A14AD02CD1BC19D70319550120E95DF85FA232F20397BB1C8499
                  AADF3F0000000049454E44AE426082}
                OnClick = imgCloseTitleClick
                ExplicitTop = 4
              end
            end
          end
        end
      end
    end
  end
  object btnFocus: TButton
    Left = -1000
    Top = 240
    Width = 75
    Height = 25
    Caption = 'btnFocus'
    TabOrder = 1
  end
end
