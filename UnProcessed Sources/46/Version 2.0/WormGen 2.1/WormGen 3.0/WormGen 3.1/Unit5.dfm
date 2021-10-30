object Form5: TForm5
  Left = 498
  Top = 182
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Submit Source'
  ClientHeight = 105
  ClientWidth = 233
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Lucida Console'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 11
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 73
    Height = 17
    AutoSize = False
    Caption = 'Made By :'
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 89
    Height = 17
    AutoSize = False
    Caption = 'Description :'
  end
  object Label3: TLabel
    Left = 8
    Top = 56
    Width = 73
    Height = 17
    AutoSize = False
    Caption = 'Name.snp :'
    Layout = tlCenter
  end
  object Button1: TButton
    Left = 160
    Top = 80
    Width = 65
    Height = 17
    Caption = '&Upload'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 104
    Top = 8
    Width = 121
    Height = 17
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    Text = 'Unknown'
  end
  object Edit2: TEdit
    Left = 104
    Top = 32
    Width = 121
    Height = 17
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    Text = 'Unknown'
  end
  object Edit3: TEdit
    Left = 104
    Top = 56
    Width = 121
    Height = 17
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
    Text = 'Unknown.snp'
  end
end
