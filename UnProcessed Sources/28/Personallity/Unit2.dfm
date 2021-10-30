object Form2: TForm2
  Left = 462
  Top = 105
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Bot Speaking'
  ClientHeight = 273
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Georgia'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label4: TLabel
    Left = 8
    Top = 8
    Width = 105
    Height = 17
    AutoSize = False
    Caption = 'Words :'
  end
  object Label5: TLabel
    Left = 8
    Top = 104
    Width = 89
    Height = 17
    AutoSize = False
    Caption = 'Bad words :'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 200
    Width = 273
    Height = 65
    Caption = 'Information'
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 16
      Width = 81
      Height = 17
      AutoSize = False
      Caption = 'Last Person :'
    end
    object Label2: TLabel
      Left = 96
      Top = 16
      Width = 169
      Height = 17
      AutoSize = False
      Caption = '-no one-'
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 40
      Width = 89
      Height = 17
      Caption = 'Silent mode'
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object CheckBox4: TCheckBox
      Left = 120
      Top = 40
      Width = 145
      Height = 17
      Caption = 'Insult disliked people'
      TabOrder = 1
    end
  end
  object ListView1: TListView
    Left = 8
    Top = 24
    Width = 193
    Height = 73
    Columns = <
      item
        Caption = 'Base Word'
        Width = 84
      end
      item
        Caption = 'Second Word'
        Width = 86
      end>
    Ctl3D = False
    TabOrder = 1
    ViewStyle = vsReport
  end
  object Button1: TButton
    Left = 208
    Top = 24
    Width = 73
    Height = 25
    Caption = 'Delete'
    TabOrder = 2
  end
  object ListView2: TListView
    Left = 8
    Top = 120
    Width = 193
    Height = 73
    Columns = <
      item
        Caption = 'Bad Words'
        Width = 175
      end>
    Ctl3D = False
    TabOrder = 3
    ViewStyle = vsReport
  end
  object Button2: TButton
    Left = 208
    Top = 120
    Width = 73
    Height = 25
    Caption = 'Delete'
    TabOrder = 4
  end
  object CheckBox2: TCheckBox
    Left = 208
    Top = 152
    Width = 73
    Height = 17
    Caption = 'Learn'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object CheckBox3: TCheckBox
    Left = 208
    Top = 56
    Width = 73
    Height = 17
    Caption = 'Learn'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
end
