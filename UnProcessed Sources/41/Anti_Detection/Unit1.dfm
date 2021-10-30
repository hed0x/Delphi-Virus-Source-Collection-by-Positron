object Form1: TForm1
  Left = 192
  Top = 107
  Width = 433
  Height = 388
  Caption = 'Denial Anti-Detection'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Georgia'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  DesignSize = (
    425
    361)
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 59
    Height = 17
    AutoSize = False
    Caption = 'Alpha 1 :'
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 59
    Height = 17
    AutoSize = False
    Caption = 'Alpha 2 :'
  end
  object Edit1: TEdit
    Left = 72
    Top = 8
    Width = 265
    Height = 20
    Anchors = [akLeft, akTop, akRight]
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 72
    Top = 32
    Width = 265
    Height = 20
    Anchors = [akLeft, akTop, akRight]
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
  end
  object Button1: TButton
    Left = 344
    Top = 32
    Width = 73
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Generate'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Panel1: TPanel
    Left = 8
    Top = 56
    Width = 409
    Height = 3
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 152
    Top = 64
    Width = 185
    Height = 249
    Anchors = [akLeft, akTop, akRight, akBottom]
    Ctl3D = False
    ParentCtl3D = False
    ScrollBars = ssBoth
    TabOrder = 4
  end
  object Edit3: TEdit
    Left = 8
    Top = 320
    Width = 329
    Height = 20
    Anchors = [akLeft, akRight, akBottom]
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 5
  end
  object Button2: TButton
    Left = 344
    Top = 320
    Width = 73
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = 'Browse'
    TabOrder = 6
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 344
    Top = 64
    Width = 73
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Src String'
    TabOrder = 7
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 344
    Top = 88
    Width = 73
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Chg String'
    TabOrder = 8
    OnClick = Button4Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 344
    Width = 425
    Height = 17
    Panels = <
      item
        Text = '100% Loaded'
        Width = 100
      end
      item
        Text = 'Just doing nothing..'
        Width = 50
      end>
    SimplePanel = False
  end
  object ListBox1: TListBox
    Left = 11
    Top = 64
    Width = 142
    Height = 249
    Anchors = [akLeft, akTop, akBottom]
    Ctl3D = False
    ItemHeight = 14
    ParentCtl3D = False
    TabOrder = 10
    OnDblClick = ListBox1DblClick
  end
  object Button5: TButton
    Left = 344
    Top = 112
    Width = 73
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Save File'
    TabOrder = 11
    OnClick = Button5Click
  end
  object Memo2: TMemo
    Left = 168
    Top = 120
    Width = 113
    Height = 57
    Lines.Strings = (
      'Memo2')
    ScrollBars = ssBoth
    TabOrder = 12
    Visible = False
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Pascal files|*.pas|Delphi Project files|*.dpr'
    Left = 192
    Top = 144
  end
end
