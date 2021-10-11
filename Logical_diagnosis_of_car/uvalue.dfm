object FValue: TFValue
  Left = 402
  Top = 149
  ActiveControl = B_sendValue
  Caption = 'FValue'
  ClientHeight = 151
  ClientWidth = 351
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    351
    151)
  PixelsPerInch = 120
  TextHeight = 16
  object L_Pin: TLabel
    Left = 9
    Top = 10
    Width = 30
    Height = 16
    Caption = 'L_Pin'
    Color = clMenuBar
    ParentColor = False
  end
  object B_sendValue: TButton
    Left = 255
    Top = 41
    Width = 91
    Height = 47
    Anchors = [akTop, akRight]
    Caption = '>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -40
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = B_sendValueClick
  end
  object B_Fermer: TButton
    Left = 9
    Top = 107
    Width = 338
    Height = 32
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Fermer'
    TabOrder = 1
    OnClick = B_FermerClick
  end
  object E_Value: TEdit
    Left = 16
    Top = 41
    Width = 232
    Height = 47
    Anchors = [akLeft, akTop, akRight]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -26
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = 'E_Value'
  end
end
