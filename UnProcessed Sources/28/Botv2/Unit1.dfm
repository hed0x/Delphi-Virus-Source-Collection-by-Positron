object Form1: TForm1
  Left = 216
  Top = 131
  Width = 441
  Height = 268
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Georgia'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    433
    241)
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 320
    Top = 8
    Width = 94
    Height = 14
    Anchors = [akTop, akRight]
    Caption = 'Server Address :'
  end
  object Label2: TLabel
    Left = 320
    Top = 48
    Width = 98
    Height = 14
    Anchors = [akTop, akRight]
    Caption = 'Server Channel :'
  end
  object Label3: TLabel
    Left = 320
    Top = 88
    Width = 62
    Height = 14
    Anchors = [akTop, akRight]
    Caption = 'Bot Name :'
  end
  object ListView1: TListView
    Left = 8
    Top = 8
    Width = 305
    Height = 169
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Word 1'
        Width = 70
      end
      item
        Caption = 'Word 2'
        Width = 70
      end
      item
        Caption = 'Word 3'
        Width = 70
      end
      item
        Caption = 'Word 4'
        Width = 70
      end>
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Button1: TButton
    Left = 320
    Top = 184
    Width = 105
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Enter'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 320
    Top = 160
    Width = 105
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Say'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 184
    Width = 305
    Height = 22
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
    Text = 'Hello im a sexy fucker'
  end
  object Edit2: TEdit
    Left = 328
    Top = 208
    Width = 89
    Height = 22
    Anchors = [akTop, akRight]
    TabOrder = 4
    Text = 'SubjectWord'
  end
  object Edit3: TEdit
    Left = 320
    Top = 24
    Width = 105
    Height = 22
    Anchors = [akTop, akRight]
    TabOrder = 5
    Text = 'irc.elfnet.org'
  end
  object Edit4: TEdit
    Left = 320
    Top = 64
    Width = 105
    Height = 22
    Anchors = [akTop, akRight]
    TabOrder = 6
    Text = '#blah'
  end
  object Edit5: TEdit
    Left = 320
    Top = 104
    Width = 105
    Height = 22
    Anchors = [akTop, akRight]
    TabOrder = 7
    Text = 'teh_jew'
  end
  object Button3: TButton
    Left = 320
    Top = 136
    Width = 105
    Height = 17
    Anchors = [akTop, akRight]
    Caption = 'Connect'
    TabOrder = 8
    OnClick = Button3Click
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 216
    Width = 313
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Allow bot to talk when he feels for it :)'
    TabOrder = 9
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 6667
    OnConnect = ClientSocket1Connect
    OnRead = ClientSocket1Read
    Left = 280
    Top = 168
  end
end
