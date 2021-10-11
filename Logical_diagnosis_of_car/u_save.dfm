object FSave: TFSave
  Left = 279
  Top = 111
  ActiveControl = FileListBox1
  Caption = 'Sauvegarde de fichier'
  ClientHeight = 389
  ClientWidth = 392
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
  PixelsPerInch = 120
  TextHeight = 16
  object GroupBox1: TGroupBox
    Left = 0
    Top = 57
    Width = 392
    Height = 282
    Align = alClient
    Caption = 'Liste des fichiers'
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 183
      Top = 18
      Width = 9
      Height = 189
      Align = alRight
    end
    object FileListBox1: TFileListBox
      Left = 192
      Top = 18
      Width = 198
      Height = 189
      Align = alRight
      ExtendedSelect = False
      FileType = [ftReadOnly, ftHidden, ftSystem, ftVolumeID, ftArchive, ftNormal]
      ItemHeight = 16
      TabOrder = 0
      OnClick = FileListBox1Click
      OnDblClick = FileListBox1DblClick
    end
    object Panel2: TPanel
      Left = 2
      Top = 207
      Width = 388
      Height = 73
      Align = alBottom
      TabOrder = 1
      DesignSize = (
        388
        73)
      object Label1: TLabel
        Left = 17
        Top = 24
        Width = 92
        Height = 16
        Caption = 'Nom du fichier :'
        Color = clNone
        ParentColor = False
      end
      object Edit1: TEdit
        Left = 110
        Top = 24
        Width = 168
        Height = 24
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = 'Edit1'
      end
      object RadioGroup1: TRadioGroup
        Left = 278
        Top = 1
        Width = 109
        Height = 71
        Align = alRight
        Caption = 'Type de fichier'
        ItemIndex = 0
        Items.Strings = (
          'xml'
          'csv')
        TabOrder = 1
      end
    end
    object TreeView1: TTreeView
      Left = 2
      Top = 18
      Width = 181
      Height = 189
      Align = alClient
      Images = ImageList1
      Indent = 19
      TabOrder = 2
      OnClick = TreeView1Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 0
    Width = 392
    Height = 57
    Align = alTop
    Caption = 'Lecteur'
    TabOrder = 1
    DesignSize = (
      392
      57)
    object ComboDrive: TComboBox
      Left = 14
      Top = 8
      Width = 359
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 16
      TabOrder = 0
      Text = 'ComboDrive'
      OnSelect = ComboDriveSelect
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 339
    Width = 392
    Height = 50
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      392
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
      Left = 304
      Top = 13
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Annuler'
      TabOrder = 1
      OnClick = B_AnnulerClick
    end
  end
  object ImageList1: TImageList
    Left = 372
    Top = 295
  end
end
