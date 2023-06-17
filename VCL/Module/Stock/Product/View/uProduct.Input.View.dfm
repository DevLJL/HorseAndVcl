inherited ProductInputView: TProductInputView
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
        ExplicitWidth = 1002
        inherited tabMain: TTabSheet
          ExplicitWidth = 994
          inherited pnlMain: TPanel
            Width = 994
            ExplicitWidth = 994
            object Label22: TLabel
              Left = 10
              Top = 10
              Width = 99
              Height = 18
              Caption = 'Identifica'#231#227'o'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = 8747344
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
            end
            object Label1: TLabel
              Left = 167
              Top = 83
              Width = 32
              Height = 14
              Caption = 'Nome'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label2: TLabel
              Left = 157
              Top = 83
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
            object Label5: TLabel
              Left = 649
              Top = 83
              Width = 215
              Height = 14
              Caption = 'Nome Simplificado (M'#225'x: 25 caracteres)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label12: TLabel
              Left = 157
              Top = 129
              Width = 57
              Height = 14
              Caption = 'Refer'#234'ncia'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Image1: TImage
              Left = 296
              Top = 129
              Width = 14
              Height = 14
              Hint = 'Campo '#250'nico. O valor deste campo n'#227'o pode se repetir!'
              AutoSize = True
              Center = True
              ParentShowHint = False
              Picture.Data = {
                0954506E67496D61676589504E470D0A1A0A0000000D494844520000000E0000
                000E08060000001F482DD1000000017352474200AECE1CE90000000467414D41
                0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000000
                CF4944415478DA9591C10DC2300C45DB0D3242D9A0DD0026A06CD00D508E8833
                E2081B9411B201DD0036A02364847EA39FCA0A4D542C59B163BDF8DB298B95D6
                9E2E1D0EE7AE672F79F90778C3B185EF042E55E185C36458431FE18D063FBC7C
                2740E956C3EFE868635066B0CCBFDDC34C945A84FA2288585EEE4501F203EB35
                E2598D06458A9722E20AF1115E0530B6E456B9FEBDEE28CB413EFC805ACE0228
                33B6C837B1D49E52ADBA13A9631224D4F13B5CE63BCC0C72ED4FFE91A7A74C14
                35BA6380072D35677A46C3191E6BC0097F1A6F6D2AA1C08C0000000049454E44
                AE426082}
              ShowHint = True
            end
            object Label9: TLabel
              Left = 320
              Top = 129
              Width = 79
              Height = 14
              Caption = 'C'#243'd. de Barras'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Image2: TImage
              Left = 460
              Top = 129
              Width = 14
              Height = 14
              Hint = 'Campo '#250'nico. O valor deste campo n'#227'o pode se repetir!'
              AutoSize = True
              Center = True
              ParentShowHint = False
              Picture.Data = {
                0954506E67496D61676589504E470D0A1A0A0000000D494844520000000E0000
                000E08060000001F482DD1000000017352474200AECE1CE90000000467414D41
                0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000000
                CF4944415478DA9591C10DC2300C45DB0D3242D9A0DD0026A06CD00D508E8833
                E2081B9411B201DD0036A02364847EA39FCA0A4D542C59B163BDF8DB298B95D6
                9E2E1D0EE7AE672F79F90778C3B185EF042E55E185C36458431FE18D063FBC7C
                2740E956C3EFE868635066B0CCBFDDC34C945A84FA2288585EEE4501F203EB35
                E2598D06458A9722E20AF1115E0530B6E456B9FEBDEE28CB413EFC805ACE0228
                33B6C837B1D49E52ADBA13A9631224D4F13B5CE63BCC0C72ED4FFE91A7A74C14
                35BA6380072D35677A46C3191E6BC0097F1A6F6D2AA1C08C0000000049454E44
                AE426082}
              ShowHint = True
            end
            object Label10: TLabel
              Left = 484
              Top = 129
              Width = 84
              Height = 14
              Caption = 'C'#243'd. de F'#225'brica'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Image3: TImage
              Left = 625
              Top = 129
              Width = 14
              Height = 14
              Hint = 'Campo '#250'nico. O valor deste campo n'#227'o pode se repetir!'
              AutoSize = True
              Center = True
              ParentShowHint = False
              Picture.Data = {
                0954506E67496D61676589504E470D0A1A0A0000000D494844520000000E0000
                000E08060000001F482DD1000000017352474200AECE1CE90000000467414D41
                0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000000
                CF4944415478DA9591C10DC2300C45DB0D3242D9A0DD0026A06CD00D508E8833
                E2081B9411B201DD0036A02364847EA39FCA0A4D542C59B163BDF8DB298B95D6
                9E2E1D0EE7AE672F79F90778C3B185EF042E55E185C36458431FE18D063FBC7C
                2740E956C3EFE868635066B0CCBFDDC34C945A84FA2288585EEE4501F203EB35
                E2598D06458A9722E20AF1115E0530B6E456B9FEBDEE28CB413EFC805ACE0228
                33B6C837B1D49E52ADBA13A9631224D4F13B5CE63BCC0C72ED4FFE91A7A74C14
                35BA6380072D35677A46C3191E6BC0097F1A6F6D2AA1C08C0000000049454E44
                AE426082}
              ShowHint = True
            end
            object Label11: TLabel
              Left = 649
              Top = 129
              Width = 69
              Height = 14
              Caption = 'Identifica'#231#227'o'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -12
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
            end
            object Label3: TLabel
              Left = 157
              Top = 37
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
            object Label4: TLabel
              Left = 217
              Top = 37
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
            object imgInfocheck_value_before_insert: TImage
              AlignWithMargins = True
              Left = 970
              Top = 34
              Width = 14
              Height = 44
              Cursor = crHandPoint
              Hint = 'Ajuda [Clique aqui para mais informa'#231#245'es]'
              Margins.Left = 0
              Margins.Top = 0
              Margins.Bottom = 0
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
              OnClick = imgInfocheck_value_before_insertClick
            end
            object rdgcheck_value_before_insert: TDBRadioGroup
              Left = 480
              Top = 32
              Width = 488
              Height = 47
              Caption = 
                ' Ao efetuar o lan'#231'amento deste item em "Pedidos, Vendas, PDV e o' +
                'utras telas"'
              Columns = 2
              DataField = 'check_value_before_insert'
              DataSource = dtsProduct
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              Items.Strings = (
                'Inser'#231#227'o imediata'
                'Conferir valores antes de inserir')
              ParentFont = False
              TabOrder = 14
              Values.Strings = (
                '0'
                '1')
            end
            object Panel5: TPanel
              Left = 10
              Top = 28
              Width = 974
              Height = 1
              BevelOuter = bvNone
              Color = 14209468
              ParentBackground = False
              TabOrder = 12
            end
            object pnlFotoCapa: TPanel
              Left = 10
              Top = 37
              Width = 137
              Height = 133
              BevelOuter = bvNone
              BorderWidth = 1
              Color = 14209468
              ParentBackground = False
              TabOrder = 13
              object Panel46: TPanel
                Left = 1
                Top = 1
                Width = 135
                Height = 131
                Margins.Left = 0
                Margins.Top = 4
                Margins.Right = 0
                Margins.Bottom = 4
                Align = alClient
                BevelOuter = bvNone
                Caption = 'Imagem'
                Color = 16250354
                Font.Charset = DEFAULT_CHARSET
                Font.Color = 13550254
                Font.Height = -13
                Font.Name = 'Tahoma'
                Font.Style = [fsBold]
                ParentBackground = False
                ParentFont = False
                TabOrder = 0
                object Label83: TLabel
                  AlignWithMargins = True
                  Left = 5
                  Top = 5
                  Width = 125
                  Height = 42
                  Alignment = taCenter
                  AutoSize = False
                  Caption = 'Extens'#227'o: .jpg    Carregue imagem c/ resolu'#231#227'o de 135x135px'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = 13550254
                  Font.Height = -11
                  Font.Name = 'Tahoma'
                  Font.Style = []
                  ParentFont = False
                  WordWrap = True
                end
                object imgFotoCapa: TImage
                  Tag = 1
                  Left = 0
                  Top = 0
                  Width = 135
                  Height = 131
                  Cursor = crHandPoint
                  Margins.Left = 0
                  Margins.Top = 1
                  Margins.Right = 0
                  Margins.Bottom = 1
                  Align = alClient
                  Center = True
                  Stretch = True
                  OnClick = btnIncluirFotoCapaClick
                  ExplicitLeft = 33
                  ExplicitTop = 92
                  ExplicitHeight = 135
                end
                object btnIncluirFotoCapa: TImage
                  Left = 105
                  Top = 101
                  Width = 25
                  Height = 25
                  Cursor = crHandPoint
                  AutoSize = True
                  Picture.Data = {
                    0954506E67496D61676589504E470D0A1A0A0000000D49484452000000190000
                    00190806000000C4E98563000000017352474200AECE1CE90000000467414D41
                    0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
                    A64944415478DAE596C151C3301045E50E9C0AB02F9C9D0E9C0AE25480DD417C
                    E18A73E542A88050014E057107C9990BA602D401FC3F598146042379325CD0CC
                    8E13ADFCDF6AA5951CA93F68D1FF815CDECE333C1E60F109B78655CFD7DBC368
                    88009E60C9C030826643A01F219E002F502482391E378E2FF104D8AD73C05B80
                    3711004BFCB90B140B6915212F23220E699A90F78054D05E6117B0D237385F48
                    0DDB20BFDAEEC4BB5CC7E61C9035C46BB75376DF156C790E480A48EF0028CC59
                    C49242E3CFC482200700A62700DC8DAC896FD52EE5C01322F185F410492D01BE
                    B897C867F61AC1178B78255D7B03F249D7C488612C454A01740E6027A9620053
                    F9BDF38534105C89186B4ADB297400A6712756A60683B630ECCD080C0038C305
                    670F3F7D79683172515B082C04A01CC8274082E0015B10C2E8624F9092744DAC
                    3A590948DB003BBD84703BFE5A504E336BC21DB416907200853A5E158D39EA09
                    992BBFB388637A01990C680790C8ECE84F83EF780894EA580F2CC27BDE178E3F
                    575FC5C8F4B5A33E249C3B8833E8246A5A267DB50960F4D78AA4840B5F58C24C
                    630B7BB4CFBB0F4D7BCEAE86D79EBA0000000049454E44AE426082}
                  OnClick = btnIncluirFotoCapaClick
                end
                object btnRemoverFotoCapa: TImage
                  Left = 5
                  Top = 101
                  Width = 25
                  Height = 25
                  Cursor = crHandPoint
                  AutoSize = True
                  Picture.Data = {
                    0954506E67496D61676589504E470D0A1A0A0000000D49484452000000190000
                    00190806000000C4E98563000000017352474200AECE1CE90000000467414D41
                    0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
                    ED4944415478DAB5964B4BC340108077F4A842BD584983B43E1011B5A248F1D9
                    D4B7F868F10FD88B57FD07B6BFC0B3A716FF80D52A7851D3FA404FE62A8806C9
                    463D8801F56A9CD8186B6DB409CDC030CB3EE6DB99ECCE06C81F2247465D6846
                    0881305A3FAA17D5A50F8BA83C216A86D93A48FEE5078A3A0F73E80856B0B98A
                    335CA41451498C491DC64B82C80B413FF626F49D5B15016151669B174C21F2FC
                    B00638CA4B891D5110146276B297BF20F2DC603900F9208E499F0806449EED77
                    E9003B29321391499FF90C089D0DACA1899511F02551CFEE7912E84C9F16C515
                    F2EA1C80289EBD8B5A84F4E21D802D0700463440A77B3440D84108A66BAAFB96
                    E46EB253F20474B2EB991439B6155535963CBDBFBD980D2940273AD4C2DE4A37
                    43DC9BFB96B7FCB03840DE5F7FC3808EB7178DE4339A6A8BD1BC168F06E858DB
                    35DA26CBDB2E5D04A0A3AD1BD858761082A72BD4B2848D84730C8800E59AF17B
                    A85AC5F43A405008802F57BB828D58BBD4980351C43CFC4DDC28F5D288578BA6
                    9C5558C09AC8B1BCA8E4411ABCF806DC962F4D08C8DC7DBF27066898F523E8D2
                    9EDF1F80289B955246D20A6748438C06B2FFC60389B0C7B298DF0966B3A5C1FA
                    5584AD5BD83DFEA940923DB9570A07E1BFD5D2801B9F01751A9B018476EAAB34
                    47624E611B6D8A3D7D54CC7C7C00D4279024106AC6270000000049454E44AE42
                    6082}
                  OnClick = btnIncluirFotoCapaClick
                end
              end
            end
            object edtName: TDBEdit
              Left = 157
              Top = 98
              Width = 482
              Height = 26
              DataField = 'name'
              DataSource = dtsProduct
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
            object DBEdit5: TDBEdit
              Left = 649
              Top = 98
              Width = 335
              Height = 26
              DataField = 'simplified_name'
              DataSource = dtsProduct
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              MaxLength = 25
              ParentFont = False
              TabOrder = 3
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object edtsku_code: TDBEdit
              Left = 157
              Top = 144
              Width = 153
              Height = 26
              DataField = 'sku_code'
              DataSource = dtsProduct
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
            object DBEdit7: TDBEdit
              Left = 320
              Top = 144
              Width = 154
              Height = 26
              DataField = 'ean_code'
              DataSource = dtsProduct
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 5
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object DBEdit8: TDBEdit
              Left = 484
              Top = 144
              Width = 155
              Height = 26
              DataField = 'manufacturing_code'
              DataSource = dtsProduct
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 6
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = EdtFieldKeyDown
            end
            object DBEdit9: TDBEdit
              Left = 649
              Top = 144
              Width = 335
              Height = 26
              DataField = 'identification_code'
              DataSource = dtsProduct
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 7
              OnEnter = EdtFieldEnter
              OnExit = EdtFieldExit
              OnKeyDown = DBEdit9KeyDown
            end
            object DBEdit3: TDBEdit
              Left = 157
              Top = 52
              Width = 50
              Height = 26
              TabStop = False
              Color = 16053492
              DataField = 'id'
              DataSource = dtsProduct
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clGray
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              ReadOnly = True
              TabOrder = 0
              OnKeyDown = EdtFieldKeyDown
            end
            object JvDBComboBox1: TJvDBComboBox
              Left = 217
              Top = 52
              Width = 150
              Height = 26
              DataField = 'type'
              DataSource = dtsProduct
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -15
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              Items.Strings = (
                'Produto'
                'Servi'#231'o')
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
            object DBCheckBox4: TDBCheckBox
              Left = 380
              Top = 38
              Width = 91
              Height = 17
              Cursor = crHandPoint
              TabStop = False
              Caption = 'Descontinuado!'
              DataField = 'flg_discontinued'
              DataSource = dtsProduct
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 15
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object pgcNotes: TPageControl
              Left = 515
              Top = 438
              Width = 465
              Height = 126
              ActivePage = TabSheet1
              TabOrder = 11
              object TabSheet1: TTabSheet
                Caption = '     Descri'#231#227'o detalhada     '
                object DBMemo1: TDBMemo
                  Left = 0
                  Top = 0
                  Width = 457
                  Height = 97
                  TabStop = False
                  Align = alClient
                  DataField = 'complement_note'
                  DataSource = dtsProduct
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
              object TabSheet2: TTabSheet
                Caption = 'Observa'#231#227'o interna (Exibe apenas aqui)'
                ImageIndex = 1
                object DBMemo2: TDBMemo
                  Left = 0
                  Top = 0
                  Width = 457
                  Height = 97
                  TabStop = False
                  Align = alClient
                  DataField = 'internal_note'
                  DataSource = dtsProduct
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
            object pgcPriceAndQuantities: TPageControl
              Left = 10
              Top = 329
              Width = 497
              Height = 235
              ActivePage = TabSheet3
              TabOrder = 9
              object TabSheet3: TTabSheet
                Caption = '     Pre'#231'os     '
                object Panel3: TPanel
                  Left = 144
                  Top = 24
                  Width = 185
                  Height = 41
                  BevelOuter = bvNone
                  Color = 16579576
                  ParentBackground = False
                  TabOrder = 0
                end
                object Panel7: TPanel
                  Left = 0
                  Top = 0
                  Width = 489
                  Height = 41
                  Align = alTop
                  BevelOuter = bvNone
                  Color = 16579576
                  ParentBackground = False
                  TabOrder = 1
                  object Label14: TLabel
                    Left = 5
                    Top = 0
                    Width = 59
                    Height = 14
                    Caption = 'Custo (R$)'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -12
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    ParentFont = False
                  end
                  object Label15: TLabel
                    Left = 169
                    Top = 0
                    Width = 56
                    Height = 14
                    Caption = 'Lucro (%)'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -12
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    ParentFont = False
                  end
                  object Label16: TLabel
                    Left = 333
                    Top = 0
                    Width = 63
                    Height = 14
                    Caption = 'Venda (R$)'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -12
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    ParentFont = False
                  end
                  object DBEdit11: TDBEdit
                    Left = 5
                    Top = 15
                    Width = 154
                    Height = 26
                    DataField = 'cost'
                    DataSource = dtsProduct
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
                  object DBEdit12: TDBEdit
                    Left = 169
                    Top = 15
                    Width = 154
                    Height = 26
                    DataField = 'marketup'
                    DataSource = dtsProduct
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -15
                    Font.Name = 'Tahoma'
                    Font.Style = [fsBold]
                    ParentFont = False
                    TabOrder = 1
                    OnClick = EdtFieldClick
                    OnEnter = EdtFieldEnter
                    OnExit = EdtFieldExit
                    OnKeyDown = EdtFieldKeyDown
                  end
                  object DBEdit13: TDBEdit
                    Left = 333
                    Top = 15
                    Width = 151
                    Height = 26
                    DataField = 'price'
                    DataSource = dtsProduct
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
                    OnKeyDown = DBEdit13KeyDown
                  end
                end
                object Panel4: TPanel
                  AlignWithMargins = True
                  Left = 5
                  Top = 46
                  Width = 479
                  Height = 155
                  Margins.Left = 5
                  Margins.Top = 5
                  Margins.Right = 5
                  Margins.Bottom = 5
                  Align = alClient
                  BevelOuter = bvNone
                  BorderWidth = 1
                  Color = 14209468
                  ParentBackground = False
                  TabOrder = 2
                  object dbgProductPriceLists: TDBGrid
                    Left = 1
                    Top = 31
                    Width = 477
                    Height = 123
                    Cursor = crHandPoint
                    Align = alClient
                    BorderStyle = bsNone
                    Color = clWhite
                    DataSource = dtsProductPriceLists
                    DrawingStyle = gdsGradient
                    FixedColor = 15131349
                    GradientEndColor = 16381936
                    GradientStartColor = 15920607
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clWindowText
                    Font.Height = -15
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgTitleClick, dgTitleHotTrack]
                    ParentFont = False
                    TabOrder = 0
                    TitleFont.Charset = DEFAULT_CHARSET
                    TitleFont.Color = 8747344
                    TitleFont.Height = -13
                    TitleFont.Name = 'Tahoma'
                    TitleFont.Style = [fsBold]
                    OnCellClick = dbgProductPriceListsCellClick
                    OnDrawColumnCell = dbgProductPriceListsDrawColumnCell
                    OnKeyDown = dbgProductPriceListsKeyDown
                    Columns = <
                      item
                        Expanded = False
                        FieldName = 'action_delete'
                        ReadOnly = True
                        Title.Caption = ' '
                        Width = 25
                        Visible = True
                      end
                      item
                        Expanded = False
                        FieldName = 'price_list_id'
                        Title.Caption = 'Lista'
                        Width = 50
                        Visible = True
                      end
                      item
                        Color = 16579576
                        Expanded = False
                        FieldName = 'price_list_name'
                        Font.Charset = DEFAULT_CHARSET
                        Font.Color = clGray
                        Font.Height = -15
                        Font.Name = 'Tahoma'
                        Font.Style = []
                        ReadOnly = True
                        Title.Caption = 'Nome'
                        Width = 228
                        Visible = True
                      end
                      item
                        Alignment = taRightJustify
                        Expanded = False
                        FieldName = 'price'
                        Title.Alignment = taRightJustify
                        Title.Caption = 'Pre'#231'o'
                        Width = 124
                        Visible = True
                      end>
                  end
                  object Panel9: TPanel
                    Left = 1
                    Top = 1
                    Width = 477
                    Height = 30
                    Align = alTop
                    Alignment = taLeftJustify
                    BevelOuter = bvNone
                    Caption = '        Lista de Pre'#231'os'
                    Color = 16579576
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = 8747344
                    Font.Height = -12
                    Font.Name = 'Tahoma'
                    Font.Style = [fsBold]
                    ParentBackground = False
                    ParentFont = False
                    TabOrder = 1
                    object imgProductPriceListsAdd: TImage
                      AlignWithMargins = True
                      Left = 2
                      Top = 2
                      Width = 25
                      Height = 26
                      Cursor = crHandPoint
                      Margins.Left = 2
                      Margins.Top = 2
                      Margins.Right = 2
                      Margins.Bottom = 2
                      Align = alLeft
                      AutoSize = True
                      Center = True
                      Picture.Data = {
                        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000190000
                        00190806000000C4E98563000000017352474200AECE1CE90000000467414D41
                        0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000001
                        F44944415478DA6364C003D4BAFC05181818BD1818FEC703B98A402C0AC40250
                        E907407C018837DC2ADBB8109F398CB80D67A807E204244309810940CB0A89B2
                        04688101909A0FC406441A8E0C2E303032C6DD2ADD7019A725500BF693E07A6C
                        E01F101B037D7501C3122A5900031F80D811661123D40201A8057883A8DBBB90
                        41825798E1F69B470C4D7B6611B2E801D01245644B4091DC4048D796C4490CAA
                        2272604B7CE6E711E3A306A0458D8C505FDC272698C8B0E403D0124190253140
                        CE6262749061090824822C590F6404D0D0920D204B4041A540434BDE802CF90D
                        64B0208BC61BFB3284EAB962A81607A62C3E766E301B64113A38FBF43A43FDAE
                        E9E8C21F4096FC47174D360D6028734820D6A52896442DABC410C7EA134F756B
                        866CAB700CC5A0A002814F3FBF32BCFCFC1643FED69B870C459B7BD185FF822C
                        B90D64A810E35232E3E436C892B94046120D2D590DB2240EC858488C6A322D09
                        84E5F81740CC4E034B4005A5227DCA2EB0253D417C0CFFFE828A65457C3A3A3C
                        F318E40425199E7D7ACD50B2A58F900520F340C5FD07E4FA4481015250520360
                        D627088B02EC818D860354B0201168C1069800AE3A1E54682A9061C179A091F1
                        B7CAF0D4F168961500A93E7C6AD05CDF08C40B4071802E49D000A065A036971D
                        103B21F90E6410A85C01B9782303A4EDF501971900C505DBD800F5C9E2000000
                        0049454E44AE426082}
                      OnClick = imgProductPriceListsAddClick
                      ExplicitLeft = 10
                      ExplicitTop = 0
                      ExplicitHeight = 25
                    end
                  end
                end
              end
            end
            object pgcClassifications: TPageControl
              Left = 10
              Top = 185
              Width = 974
              Height = 128
              ActivePage = TabSheet5
              TabOrder = 8
              object TabSheet5: TTabSheet
                Caption = '     Classifica'#231#227'o     '
                object Panel8: TPanel
                  Left = 0
                  Top = 0
                  Width = 966
                  Height = 99
                  Align = alClient
                  BevelOuter = bvNone
                  Color = 16579576
                  ParentBackground = False
                  TabOrder = 0
                  object Label37: TLabel
                    Left = 15
                    Top = 7
                    Width = 129
                    Height = 14
                    Caption = 'F1 - Unidade de Medida'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -12
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    ParentFont = False
                  end
                  object Label13: TLabel
                    Left = 5
                    Top = 7
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
                  object Label71: TLabel
                    Left = 5
                    Top = 53
                    Width = 163
                    Height = 14
                    Caption = 'F1 - Local de Armazenamento'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -12
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    ParentFont = False
                  end
                  object Label19: TLabel
                    Left = 330
                    Top = 7
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
                  object Label18: TLabel
                    Left = 340
                    Top = 7
                    Width = 49
                    Height = 14
                    Caption = 'F1 - NCM'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -12
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    ParentFont = False
                  end
                  object Label35: TLabel
                    Left = 330
                    Top = 53
                    Width = 56
                    Height = 14
                    Caption = 'F1 - Marca'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -12
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    ParentFont = False
                  end
                  object Label36: TLabel
                    Left = 655
                    Top = 53
                    Width = 76
                    Height = 14
                    Caption = 'F1 - Categoria'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -12
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    ParentFont = False
                  end
                  object edtunit_name: TDBEdit
                    Left = 83
                    Top = 22
                    Width = 237
                    Height = 26
                    Color = 16053492
                    DataField = 'unit_name'
                    DataSource = dtsProduct
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
                  object Panel41: TPanel
                    Left = 5
                    Top = 22
                    Width = 26
                    Height = 26
                    Cursor = crHandPoint
                    BevelOuter = bvNone
                    BorderWidth = 1
                    Color = 5327153
                    ParentBackground = False
                    TabOrder = 11
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
                      object imgLocaUnit: TImage
                        Left = 0
                        Top = 0
                        Width = 24
                        Height = 24
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
                        OnClick = imgLocaUnitClick
                        ExplicitTop = 14
                        ExplicitWidth = 18
                        ExplicitHeight = 18
                      end
                    end
                  end
                  object edtunit_id: TDBEdit
                    Left = 32
                    Top = 22
                    Width = 50
                    Height = 26
                    DataField = 'unit_id'
                    DataSource = dtsProduct
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
                  object edtstorage_location_name: TDBEdit
                    Left = 83
                    Top = 68
                    Width = 237
                    Height = 26
                    Color = 16053492
                    DataField = 'storage_location_name'
                    DataSource = dtsProduct
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
                  object Panel43: TPanel
                    Left = 5
                    Top = 68
                    Width = 26
                    Height = 26
                    Cursor = crHandPoint
                    BevelOuter = bvNone
                    BorderWidth = 1
                    Color = 5327153
                    ParentBackground = False
                    TabOrder = 12
                    object Panel44: TPanel
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
                      object imgLocaStorageLocation: TImage
                        Left = 0
                        Top = 0
                        Width = 24
                        Height = 24
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
                        OnClick = imgLocaStorageLocationClick
                        ExplicitTop = 14
                        ExplicitWidth = 18
                        ExplicitHeight = 18
                      end
                    end
                  end
                  object edtstorage_location_id: TDBEdit
                    Left = 32
                    Top = 68
                    Width = 50
                    Height = 26
                    DataField = 'storage_location_id'
                    DataSource = dtsProduct
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
                  object edtncm_name: TDBEdit
                    Left = 508
                    Top = 22
                    Width = 453
                    Height = 26
                    Color = 16053492
                    DataField = 'ncm_name'
                    DataSource = dtsProduct
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
                  object edtncm_id: TDBEdit
                    Left = 357
                    Top = 22
                    Width = 50
                    Height = 26
                    DataField = 'ncm_id'
                    DataSource = dtsProduct
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
                  object Panel1: TPanel
                    Left = 330
                    Top = 22
                    Width = 26
                    Height = 26
                    Cursor = crHandPoint
                    BevelOuter = bvNone
                    BorderWidth = 1
                    Color = 5327153
                    ParentBackground = False
                    TabOrder = 13
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
                      object imgLocaNCM: TImage
                        Left = 0
                        Top = 0
                        Width = 24
                        Height = 24
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
                        OnClick = imgLocaNCMClick
                        ExplicitLeft = -1
                      end
                    end
                  end
                  object edtncm_code: TDBEdit
                    Left = 408
                    Top = 22
                    Width = 100
                    Height = 26
                    Color = 16053492
                    DataField = 'ncm_code'
                    DataSource = dtsProduct
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
                  object edtbrand_name: TDBEdit
                    Left = 408
                    Top = 68
                    Width = 237
                    Height = 26
                    Color = 16053492
                    DataField = 'brand_name'
                    DataSource = dtsProduct
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
                  object edtbrand_id: TDBEdit
                    Left = 357
                    Top = 68
                    Width = 50
                    Height = 26
                    DataField = 'brand_id'
                    DataSource = dtsProduct
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
                  object Panel37: TPanel
                    Left = 330
                    Top = 68
                    Width = 26
                    Height = 26
                    Cursor = crHandPoint
                    BevelOuter = bvNone
                    BorderWidth = 1
                    Color = 5327153
                    ParentBackground = False
                    TabOrder = 14
                    object Panel38: TPanel
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
                      object imgLocaBrand: TImage
                        Left = 0
                        Top = 0
                        Width = 24
                        Height = 24
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
                        OnClick = imgLocaBrandClick
                        ExplicitLeft = -4
                      end
                    end
                  end
                  object edtcategory_name: TDBEdit
                    Left = 733
                    Top = 68
                    Width = 228
                    Height = 26
                    Color = 16053492
                    DataField = 'category_name'
                    DataSource = dtsProduct
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clGray
                    Font.Height = -15
                    Font.Name = 'Tahoma'
                    Font.Style = [fsBold]
                    ParentFont = False
                    ReadOnly = True
                    TabOrder = 10
                    OnKeyDown = edtcategory_nameKeyDown
                  end
                  object Panel39: TPanel
                    Left = 655
                    Top = 68
                    Width = 26
                    Height = 26
                    Cursor = crHandPoint
                    BevelOuter = bvNone
                    BorderWidth = 1
                    Color = 5327153
                    ParentBackground = False
                    TabOrder = 15
                    object Panel40: TPanel
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
                      object imgLocaCategory: TImage
                        Left = 0
                        Top = 0
                        Width = 24
                        Height = 24
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
                        OnClick = imgLocaCategoryClick
                        ExplicitTop = 14
                        ExplicitWidth = 18
                        ExplicitHeight = 18
                      end
                    end
                  end
                  object edtcategory_id: TDBEdit
                    Left = 682
                    Top = 68
                    Width = 50
                    Height = 26
                    DataField = 'category_id'
                    DataSource = dtsProduct
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
                end
              end
              object TabSheet6: TTabSheet
                Caption = '     +     '
                ImageIndex = 1
                object Panel6: TPanel
                  Left = 0
                  Top = 0
                  Width = 966
                  Height = 99
                  Align = alClient
                  BevelOuter = bvNone
                  Color = 16579576
                  ParentBackground = False
                  TabOrder = 0
                  object Label34: TLabel
                    Left = 5
                    Top = 5
                    Width = 76
                    Height = 14
                    Caption = 'F1 - Tamanho'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -12
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    ParentFont = False
                  end
                  object edtsize_name: TDBEdit
                    Left = 83
                    Top = 22
                    Width = 237
                    Height = 26
                    Color = 16053492
                    DataField = 'size_name'
                    DataSource = dtsProduct
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clGray
                    Font.Height = -15
                    Font.Name = 'Tahoma'
                    Font.Style = [fsBold]
                    ParentFont = False
                    ReadOnly = True
                    TabOrder = 0
                    OnKeyDown = EdtFieldKeyDown
                  end
                  object Panel17: TPanel
                    Left = 5
                    Top = 22
                    Width = 26
                    Height = 26
                    Cursor = crHandPoint
                    BevelOuter = bvNone
                    BorderWidth = 1
                    Color = 5327153
                    ParentBackground = False
                    TabOrder = 1
                    object Panel19: TPanel
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
                      object imgLocaSize: TImage
                        Left = 0
                        Top = 0
                        Width = 24
                        Height = 24
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
                        OnClick = imgLocaSizeClick
                        ExplicitTop = 14
                        ExplicitWidth = 18
                        ExplicitHeight = 18
                      end
                    end
                  end
                  object edtsize_id: TDBEdit
                    Left = 32
                    Top = 22
                    Width = 50
                    Height = 26
                    DataField = 'size_id'
                    DataSource = dtsProduct
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
                end
              end
            end
            object PageControl1: TPageControl
              Left = 515
              Top = 329
              Width = 469
              Height = 100
              ActivePage = TabSheet8
              TabOrder = 10
              object TabSheet8: TTabSheet
                Caption = '     Quantidades     '
                ImageIndex = 1
                OnShow = TabSheet4Show
                object Panel15: TPanel
                  Left = 0
                  Top = 0
                  Width = 461
                  Height = 71
                  Align = alClient
                  BevelOuter = bvNone
                  Color = 16579576
                  ParentBackground = False
                  TabOrder = 0
                  object Label23: TLabel
                    Left = 332
                    Top = 5
                    Width = 39
                    Height = 14
                    Caption = 'M'#225'xima'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -12
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    ParentFont = False
                  end
                  object Label24: TLabel
                    Left = 168
                    Top = 5
                    Width = 36
                    Height = 14
                    Caption = 'M'#237'nima'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -12
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    ParentFont = False
                  end
                  object Label25: TLabel
                    Left = 4
                    Top = 5
                    Width = 66
                    Height = 14
                    Caption = 'Em Estoque'
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -12
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    ParentFont = False
                  end
                  object DBEdit6: TDBEdit
                    Left = 4
                    Top = 20
                    Width = 154
                    Height = 26
                    DataField = 'current_quantity'
                    DataSource = dtsProduct
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
                  object DBCheckBox2: TDBCheckBox
                    Left = 168
                    Top = 52
                    Width = 200
                    Height = 17
                    Cursor = crHandPoint
                    TabStop = False
                    Caption = 'Produto para pesagem em balan'#231'as.'
                    DataField = 'flg_product_for_scales'
                    DataSource = dtsProduct
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -11
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    ParentFont = False
                    TabOrder = 3
                    ValueChecked = '1'
                    ValueUnchecked = '0'
                  end
                  object DBCheckBox5: TDBCheckBox
                    Left = 4
                    Top = 51
                    Width = 116
                    Height = 17
                    Cursor = crHandPoint
                    TabStop = False
                    Caption = 'Controlar estoque.'
                    DataField = 'flg_to_move_the_stock'
                    DataSource = dtsProduct
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -11
                    Font.Name = 'Tahoma'
                    Font.Style = []
                    ParentFont = False
                    TabOrder = 4
                    ValueChecked = '1'
                    ValueUnchecked = '0'
                  end
                  object DBEdit10: TDBEdit
                    Left = 332
                    Top = 20
                    Width = 124
                    Height = 26
                    DataField = 'maximum_quantity'
                    DataSource = dtsProduct
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
                  object DBEdit17: TDBEdit
                    Left = 168
                    Top = 20
                    Width = 154
                    Height = 26
                    DataField = 'minimum_quantity'
                    DataSource = dtsProduct
                    Font.Charset = DEFAULT_CHARSET
                    Font.Color = clBlack
                    Font.Height = -15
                    Font.Name = 'Tahoma'
                    Font.Style = [fsBold]
                    ParentFont = False
                    TabOrder = 1
                    OnClick = EdtFieldClick
                    OnEnter = EdtFieldEnter
                    OnExit = EdtFieldExit
                    OnKeyDown = EdtFieldKeyDown
                  end
                end
              end
            end
            object DBCheckBox1: TDBCheckBox
              Left = 380
              Top = 61
              Width = 91
              Height = 17
              Cursor = crHandPoint
              TabStop = False
              Caption = 'Item adicional'
              DataField = 'flg_additional'
              DataSource = dtsProduct
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 16
              ValueChecked = '1'
              ValueUnchecked = '0'
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
        Width = 87
        Height = 40
        Caption = 'Produto'
        ExplicitLeft = 45
        ExplicitWidth = 87
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
  object dtsProduct: TDataSource [2]
    Left = 611
    Top = 1
  end
  object dtsProductPriceLists: TDataSource
    Left = 705
    Top = 1
  end
end
