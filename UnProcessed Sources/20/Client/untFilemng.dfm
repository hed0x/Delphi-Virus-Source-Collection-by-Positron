object Form3: TForm3
  Left = 834
  Top = 107
  Width = 297
  Height = 293
  Caption = 'Splat 1.0 - Filemanager'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    289
    266)
  PixelsPerInch = 96
  TextHeight = 14
  object ComboBox1: TComboBox
    Left = 8
    Top = 8
    Width = 129
    Height = 22
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    Color = 15658734
    Ctl3D = True
    ItemHeight = 14
    ParentCtl3D = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 8
    Top = 32
    Width = 273
    Height = 3
    Anchors = [akLeft, akTop, akRight]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
  end
  object Button1: TButton
    Left = 144
    Top = 8
    Width = 65
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Get Drives'
    TabOrder = 2
  end
  object Button2: TButton
    Left = 216
    Top = 8
    Width = 65
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Refresh'
    TabOrder = 3
  end
  object ListView1: TListView
    Left = 8
    Top = 64
    Width = 201
    Height = 97
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = 15658734
    Columns = <
      item
        Caption = 'Name'
        Width = 60
      end
      item
        Caption = 'Attribute'
        Width = 60
      end
      item
        Caption = 'Size'
        Width = 60
      end>
    ColumnClick = False
    Ctl3D = False
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 4
    ViewStyle = vsReport
  end
  object Button3: TButton
    Left = 216
    Top = 40
    Width = 65
    Height = 20
    Anchors = [akTop, akRight]
    Caption = 'Go To'
    TabOrder = 5
  end
  object Edit1: TEdit
    Left = 8
    Top = 40
    Width = 201
    Height = 20
    Anchors = [akLeft, akTop, akRight]
    Color = 15658734
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 6
    Text = 'C:\'
  end
  object Button4: TButton
    Left = 216
    Top = 64
    Width = 65
    Height = 20
    Anchors = [akTop, akRight]
    Caption = 'Download'
    TabOrder = 7
  end
  object Button5: TButton
    Left = 216
    Top = 88
    Width = 65
    Height = 20
    Anchors = [akTop, akRight]
    Caption = 'Upload'
    TabOrder = 8
  end
  object Button6: TButton
    Left = 216
    Top = 112
    Width = 65
    Height = 20
    Anchors = [akTop, akRight]
    Caption = 'Delete'
    TabOrder = 9
  end
  object Button7: TButton
    Left = 216
    Top = 136
    Width = 65
    Height = 20
    Anchors = [akTop, akRight]
    Caption = 'Execute'
    TabOrder = 10
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 249
    Width = 289
    Height = 17
    Panels = <
      item
        Text = 'Socket: 0'
        Width = 80
      end
      item
        Text = 'Received: NULL'
        Width = 50
      end>
    SimplePanel = False
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 168
    Width = 273
    Height = 73
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Downloading'
    TabOrder = 12
    DesignSize = (
      273
      73)
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 81
      Height = 17
      AutoSize = False
      Caption = 'Filename'
    end
    object Label2: TLabel
      Left = 8
      Top = 32
      Width = 81
      Height = 17
      AutoSize = False
      Caption = 'Time Remaining'
    end
    object Label3: TLabel
      Left = 184
      Top = 48
      Width = 81
      Height = 17
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = '0.00 kb/s'
    end
    object Label4: TLabel
      Left = 88
      Top = 16
      Width = 177
      Height = 17
      AutoSize = False
      Caption = ':"null"'
    end
    object Label5: TLabel
      Left = 88
      Top = 32
      Width = 177
      Height = 17
      AutoSize = False
      Caption = ':"null"'
    end
    object ProgressBar1: TProgressBar
      Left = 8
      Top = 48
      Width = 169
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Min = 0
      Max = 100
      Smooth = True
      TabOrder = 0
    end
  end
end
