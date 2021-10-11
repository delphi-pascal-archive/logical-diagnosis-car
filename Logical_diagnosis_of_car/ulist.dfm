object FList: TFList
  Left = 402
  Top = 149
  ActiveControl = B_Fermer
  Caption = 'FList'
  ClientHeight = 426
  ClientWidth = 380
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 362
    Width = 380
    Height = 64
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      380
      64)
    object B_Fermer: TButton
      Left = 272
      Top = 6
      Width = 94
      Height = 43
      Anchors = [akLeft, akRight, akBottom]
      Caption = 'Fermer'
      TabOrder = 0
      OnClick = B_FermerClick
    end
    object B_sendValue: TButton
      Left = 11
      Top = 6
      Width = 91
      Height = 43
      Anchors = [akTop, akRight]
      Caption = '>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -40
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = B_sendValueClick
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 280
    Width = 380
    Height = 82
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      380
      82)
    object E_Value: TEdit
      Left = 11
      Top = 23
      Width = 239
      Height = 39
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -26
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'E_Value'
    end
    object BitBtn1: TBitBtn
      Left = 291
      Top = 15
      Width = 75
      Height = 47
      Caption = '&OK'
      TabOrder = 1
      OnClick = BitBtn1Click
      Kind = bkOK
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 50
    Width = 380
    Height = 230
    Align = alClient
    Caption = 'Value'
    TabOrder = 2
    object StringGrid1: TStringGrid
      Left = 2
      Top = 18
      Width = 376
      Height = 210
      Align = alClient
      ColCount = 3
      FixedCols = 0
      GridLineWidth = 0
      TabOrder = 0
      OnClick = StringGrid1Click
      OnDrawCell = StringGrid1DrawCell
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 380
    Height = 50
    Align = alTop
    TabOrder = 3
    object L_Pin: TLabel
      Left = 9
      Top = 10
      Width = 30
      Height = 16
      Caption = 'L_Pin'
      Color = clBtnFace
      ParentColor = False
    end
  end
end
