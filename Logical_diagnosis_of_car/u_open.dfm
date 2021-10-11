object FOpen: TFOpen
  Left = 638
  Top = 140
  ActiveControl = B_OK
  Caption = 'Ouvrir Fichier'
  ClientHeight = 341
  ClientWidth = 598
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
    Top = 57
    Width = 598
    Height = 234
    Align = alClient
    Caption = 'Liste des fichiers'
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 253
      Top = 18
      Width = 9
      Height = 164
      Align = alRight
    end
    object FileListBox1: TFileListBox
      Left = 262
      Top = 18
      Width = 334
      Height = 164
      Align = alRight
      FileType = [ftReadOnly, ftHidden, ftSystem, ftVolumeID, ftArchive, ftNormal]
      ItemHeight = 16
      TabOrder = 0
      OnClick = FileListBox1Click
      OnDblClick = FileListBox1DblClick
    end
    object Panel2: TPanel
      Left = 2
      Top = 182
      Width = 594
      Height = 50
      Align = alBottom
      TabOrder = 1
      DesignSize = (
        594
        50)
      object Label1: TLabel
        Left = 17
        Top = 18
        Width = 92
        Height = 16
        Caption = 'Nom du fichier :'
        Color = clNone
        ParentColor = False
      end
      object Edit1: TEdit
        Left = 110
        Top = 11
        Width = 476
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = 'Edit1'
      end
    end
    object TreeView1: TTreeView
      Left = 2
      Top = 18
      Width = 251
      Height = 164
      Align = alClient
      Images = ImageList1
      Indent = 19
      StateImages = ImageList1
      TabOrder = 2
      OnClick = TreeView1Click
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 291
    Width = 598
    Height = 50
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      598
      50)
    object B_OK: TButton
      Tag = 1
      Left = 14
      Top = 13
      Width = 74
      Height = 25
      Caption = 'OK'
      TabOrder = 0
      OnClick = B_OKClick
    end
    object B_Annuler: TButton
      Left = 512
      Top = 13
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Annuler'
      TabOrder = 1
      OnClick = B_AnnulerClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 598
    Height = 57
    Align = alTop
    Caption = 'Lecteur'
    TabOrder = 2
    DesignSize = (
      598
      57)
    object ComboDrive: TComboBox
      Left = 14
      Top = 8
      Width = 565
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 16
      TabOrder = 0
      Text = 'ComboDrive'
      OnSelect = ComboDriveSelect
    end
  end
  object ImageList1: TImageList
    Left = 354
    Top = 295
  end
end
