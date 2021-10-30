object Form3: TForm3
  Left = 768
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Settings'
  ClientHeight = 169
  ClientWidth = 209
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Georgia'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 69
    Height = 14
    Caption = 'iRC Server :'
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 79
    Height = 14
    Caption = 'iRC Channel :'
  end
  object Label3: TLabel
    Left = 8
    Top = 88
    Width = 89
    Height = 14
    Caption = 'iRC Nickname :'
  end
  object Edit1: TEdit
    Left = 16
    Top = 24
    Width = 121
    Height = 22
    TabOrder = 0
    Text = 'Tetchy.lcirc.net'
  end
  object Edit2: TEdit
    Left = 144
    Top = 24
    Width = 57
    Height = 22
    TabOrder = 1
    Text = '6667'
  end
  object Edit3: TEdit
    Left = 16
    Top = 64
    Width = 185
    Height = 22
    TabOrder = 2
    Text = '#herman-group'
  end
  object Edit4: TEdit
    Left = 16
    Top = 104
    Width = 121
    Height = 22
    TabOrder = 3
    Text = 'juden'
  end
  object Button1: TButton
    Left = 144
    Top = 104
    Width = 57
    Height = 17
    Caption = 'Change'
    TabOrder = 4
  end
  object Button2: TButton
    Left = 8
    Top = 136
    Width = 65
    Height = 25
    Caption = '&Save'
    TabOrder = 5
    OnClick = Button2Click
  end
end
