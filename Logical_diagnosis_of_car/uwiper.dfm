object FWiper: TFWiper
  Left = 471
  Top = 307
  ActiveControl = B_Stop
  Caption = 'Commande essui vitre'
  ClientHeight = 139
  ClientWidth = 285
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
    Width = 285
    Height = 26
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 294
    object L_Pin: TLabel
      Left = 18
      Top = 8
      Width = 24
      Height = 12
      Caption = 'L_Pin'
      Color = clMenuBar
      ParentColor = False
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 26
    Width = 285
    Height = 60
    Align = alTop
    Caption = 'Commande'
    TabOrder = 1
    ExplicitWidth = 294
    DesignSize = (
      285
      60)
    object B_Stop: TButton
      Left = 18
      Top = 20
      Width = 42
      Height = 30
      Caption = 'Stop'
      TabOrder = 0
      OnClick = B_StopClick
    end
    object B_Slow: TButton
      Left = 121
      Top = 20
      Width = 42
      Height = 30
      Anchors = [akTop]
      Caption = '>'
      TabOrder = 1
      OnClick = B_SlowClick
      ExplicitLeft = 125
    end
    object B_Fast: TButton
      Left = 203
      Top = 20
      Width = 42
      Height = 30
      Anchors = [akTop, akRight]
      Caption = '>>'
      TabOrder = 2
      OnClick = B_FastClick
      ExplicitLeft = 212
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 86
    Width = 285
    Height = 53
    Align = alClient
    TabOrder = 2
    ExplicitWidth = 294
    ExplicitHeight = 54
    DesignSize = (
      285
      53)
    object B_Fermer: TButton
      Left = 100
      Top = 16
      Width = 86
      Height = 25
      Anchors = [akTop]
      Caption = 'Fermer'
      TabOrder = 0
      OnClick = B_FermerClick
      ExplicitLeft = 104
    end
  end
end
