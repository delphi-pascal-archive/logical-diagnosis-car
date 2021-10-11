object F_AjoutBoitier: TF_AjoutBoitier
  Left = 398
  Top = 212
  Caption = 'Ajouter un boitier'
  ClientHeight = 95
  ClientWidth = 296
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  DesignSize = (
    296
    95)
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 7
    Top = 12
    Width = 67
    Height = 12
    Caption = 'Nom du boitier'
    Color = clMenuBar
    ParentColor = False
  end
  object Label2: TLabel
    Left = 7
    Top = 36
    Width = 88
    Height = 12
    Caption = 'Adresse du boitier :'
    Color = clMenuBar
    ParentColor = False
  end
  object E_NomBoitier: TEdit
    Left = 127
    Top = 6
    Width = 150
    Height = 20
    TabOrder = 0
    Text = 'E_NomBoitier'
  end
  object E_Adresse: TEdit
    Left = 127
    Top = 29
    Width = 60
    Height = 20
    TabOrder = 1
    Text = 'E_Adresse'
  end
  object BitBtn1: TBitBtn
    Left = 12
    Top = 66
    Width = 78
    Height = 23
    Caption = '&OK'
    TabOrder = 2
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 216
    Top = 66
    Width = 74
    Height = 23
    Anchors = [akTop, akRight]
    Caption = 'Annuler'
    TabOrder = 3
    Kind = bkCancel
  end
end
