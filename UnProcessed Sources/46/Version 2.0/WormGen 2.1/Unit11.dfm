object Form11: TForm11
  Left = 711
  Top = 105
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'DDoS'
  ClientHeight = 162
  ClientWidth = 233
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Courier New'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Homepage URL'
  end
  object Label2: TLabel
    Left = 24
    Top = 80
    Width = 73
    Height = 17
    AutoSize = False
    Caption = 'Year :'
    Layout = tlBottom
  end
  object Label3: TLabel
    Left = 24
    Top = 104
    Width = 73
    Height = 17
    AutoSize = False
    Caption = 'Month :'
    Layout = tlBottom
  end
  object Edit1: TEdit
    Left = 8
    Top = 24
    Width = 217
    Height = 22
    TabOrder = 0
    Text = 'http://site.com'
    OnChange = Edit1Change
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 56
    Width = 129
    Height = 17
    Caption = 'Date Trigger'
    TabOrder = 1
  end
  object Edit2: TEdit
    Left = 144
    Top = 80
    Width = 81
    Height = 22
    BevelInner = bvLowered
    BevelOuter = bvRaised
    MaxLength = 2
    TabOrder = 2
    Text = '04'
    OnChange = Edit2Change
  end
  object Edit3: TEdit
    Left = 144
    Top = 104
    Width = 81
    Height = 22
    BevelInner = bvLowered
    BevelOuter = bvRaised
    MaxLength = 2
    TabOrder = 3
    Text = '05'
    OnChange = Edit3Change
  end
  object Button1: TButton
    Left = 144
    Top = 136
    Width = 81
    Height = 17
    Caption = '&Okey'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 136
    Width = 17
    Height = 17
    Caption = '?'
    TabOrder = 5
    OnClick = Button2Click
  end
end
