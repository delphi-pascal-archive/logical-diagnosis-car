object F_Configuration: TF_Configuration
  Left = 396
  Top = 154
  ActiveControl = CB_Langue
  Caption = 'Configuration'
  ClientHeight = 370
  ClientWidth = 597
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 597
    Height = 56
    Align = alTop
    Caption = 'Langue par defaut'
    TabOrder = 0
    object Label2: TLabel
      Left = 14
      Top = 20
      Width = 104
      Height = 16
      Caption = 'Langue par defaut'
      Color = clMenuBar
      ParentColor = False
    end
    object CB_Langue: TComboBox
      Left = 174
      Top = 16
      Width = 156
      Height = 24
      ItemHeight = 16
      TabOrder = 0
      Text = 'CB_Langue'
      OnChange = CB_LangueChange
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 320
    Width = 597
    Height = 50
    Align = alBottom
    TabOrder = 1
    object B_Save: TBitBtn
      Left = 28
      Top = 11
      Width = 109
      Height = 30
      Caption = 'Enregistrer'
      Default = True
      TabOrder = 0
      OnClick = B_SaveClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object B_Exit: TBitBtn
      Left = 472
      Top = 11
      Width = 120
      Height = 30
      TabOrder = 1
      OnClick = B_QuitterClick
      Kind = bkClose
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 56
    Width = 597
    Height = 264
    Align = alClient
    Caption = 'Configuration Communication'
    TabOrder = 2
    object Grid_Boitier: TStringGrid
      Left = 2
      Top = 18
      Width = 593
      Height = 244
      Align = alClient
      ColCount = 2
      DefaultColWidth = 200
      FixedColor = 16704404
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
      TabOrder = 0
      OnClick = Grid_BoitierClick
      OnSelectCell = Grid_BoitierSelectCell
      ColWidths = (
        200
        230)
    end
  end
end
