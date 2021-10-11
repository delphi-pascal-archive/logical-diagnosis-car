object FBridge: TFBridge
  Left = 290
  Top = 186
  ActiveControl = B_Left
  Caption = 'Commande bridge'
  ClientHeight = 203
  ClientWidth = 346
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 0
    Top = 41
    Width = 346
    Height = 55
    Align = alBottom
    Caption = 'Bridge'
    TabOrder = 0
    ExplicitTop = 51
    ExplicitWidth = 345
    object B_Left: TButton
      Left = 59
      Top = 16
      Width = 36
      Height = 27
      Caption = '<'
      TabOrder = 0
      OnClick = B_LeftClick
    end
    object B_Stop: TButton
      Left = 12
      Top = 16
      Width = 36
      Height = 27
      Caption = 'Stop'
      TabOrder = 1
      OnClick = B_StopClick
    end
    object B_Right: TButton
      Left = 107
      Top = 16
      Width = 36
      Height = 27
      Caption = '>'
      TabOrder = 2
      OnClick = B_RightClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 96
    Width = 346
    Height = 71
    Align = alBottom
    Caption = 'Rapport cyclique'
    TabOrder = 1
    ExplicitTop = 106
    ExplicitWidth = 345
    DesignSize = (
      346
      71)
    object Label1: TLabel
      Left = 115
      Top = 23
      Width = 100
      Height = 27
      Anchors = [akTop]
      AutoSize = False
      Caption = '100000 %'
      Color = clMenuBar
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object B_Plus: TButton
      Left = 279
      Top = 17
      Width = 56
      Height = 39
      Anchors = [akTop, akRight]
      Caption = '>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = B_PlusClick
      ExplicitLeft = 278
    end
    object B_Moins: TButton
      Left = 12
      Top = 17
      Width = 56
      Height = 39
      Caption = '<'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = B_MoinsClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 167
    Width = 346
    Height = 36
    Align = alBottom
    TabOrder = 2
    ExplicitTop = 177
    ExplicitWidth = 345
    DesignSize = (
      346
      36)
    object B_Fermer: TButton
      Left = 135
      Top = 6
      Width = 74
      Height = 19
      Anchors = [akTop]
      Caption = 'Fermer'
      TabOrder = 0
      OnClick = B_FermerClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 346
    Height = 41
    Align = alClient
    TabOrder = 3
    ExplicitWidth = 345
    ExplicitHeight = 51
    object L_pin: TLabel
      Left = 12
      Top = 9
      Width = 24
      Height = 12
      Caption = 'L_pin'
      Color = clMenuBar
      ParentColor = False
    end
  end
end
