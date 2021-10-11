object FOnOff: TFOnOff
  Left = 545
  Top = 192
  ActiveControl = B_On
  Caption = 'Activation Sortie'
  ClientHeight = 115
  ClientWidth = 205
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
  DesignSize = (
    205
    115)
  PixelsPerInch = 96
  TextHeight = 12
  object L_Pin: TLabel
    Left = 7
    Top = 8
    Width = 24
    Height = 12
    Caption = 'L_Pin'
    Color = clMenuBar
    ParentColor = False
  end
  object B_On: TButton
    Left = 6
    Top = 30
    Width = 68
    Height = 38
    Caption = 'On'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = B_OnClick
  end
  object B_Off: TButton
    Left = 132
    Top = 30
    Width = 68
    Height = 38
    Anchors = [akTop, akRight]
    Caption = 'Off'
    TabOrder = 1
    OnClick = B_OffClick
  end
  object B_Fermer: TButton
    Left = 6
    Top = 84
    Width = 194
    Height = 24
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Fermer'
    TabOrder = 2
    OnClick = B_FermerClick
  end
end
