object FBiPWM: TFBiPWM
  Left = 402
  Top = 149
  ActiveControl = B_Fermer
  Caption = 'FBiPWM'
  ClientHeight = 215
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 297
    Height = 38
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 294
    object L_Pin: TLabel
      Left = 18
      Top = 12
      Width = 24
      Height = 12
      Caption = 'L_Pin'
      Color = clMenuBar
      ParentColor = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 179
    Width = 297
    Height = 36
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 150
    ExplicitWidth = 294
    DesignSize = (
      297
      36)
    object B_Fermer: TButton
      Left = 112
      Top = 6
      Width = 74
      Height = 19
      Anchors = [akTop]
      Caption = 'Fermer'
      TabOrder = 0
      OnClick = B_FermerClick
      ExplicitLeft = 110
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 109
    Width = 297
    Height = 71
    Align = alTop
    Caption = 'Rapport cyclique'
    TabOrder = 2
    ExplicitWidth = 294
    DesignSize = (
      297
      71)
    object Label1: TLabel
      Left = 96
      Top = 23
      Width = 101
      Height = 27
      Anchors = [akTop]
      AutoSize = False
      Caption = '100000 %'
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ExplicitLeft = 95
    end
    object B_Moins: TButton
      Left = 7
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
      TabOrder = 0
      OnClick = B_MoinsClick
    end
    object B_Plus: TButton
      Left = 233
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
      TabOrder = 1
      OnClick = B_PlusClick
      ExplicitLeft = 230
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 38
    Width = 297
    Height = 71
    Align = alTop
    Caption = 'Fr'#233'quence'
    TabOrder = 3
    ExplicitWidth = 294
    DesignSize = (
      297
      71)
    object Label2: TLabel
      Left = 96
      Top = 17
      Width = 101
      Height = 27
      Anchors = [akTop]
      AutoSize = False
      Caption = '100000 Hz'
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -23
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ExplicitLeft = 95
    end
    object B_MoinsFreq: TButton
      Left = 7
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
      TabOrder = 0
      OnClick = B_MoinsFreqClick
    end
    object B_PlusFreq: TButton
      Left = 239
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
      TabOrder = 1
      OnClick = B_PlusFreqClick
      ExplicitLeft = 236
    end
  end
end
