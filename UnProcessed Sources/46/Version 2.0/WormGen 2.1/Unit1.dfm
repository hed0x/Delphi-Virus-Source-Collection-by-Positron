object Form1: TForm1
  Left = 190
  Top = 105
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'p0ke'#39's WormGen 2.2'
  ClientHeight = 251
  ClientWidth = 513
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Comic Sans MS'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 0
    Width = 81
    Height = 17
    AutoSize = False
    Caption = 'Project Name :'
    Layout = tlBottom
  end
  object Label2: TLabel
    Left = 24
    Top = 24
    Width = 65
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = 'Detection :'
    Layout = tlBottom
  end
  object Label3: TLabel
    Left = 8
    Top = 48
    Width = 105
    Height = 17
    AutoSize = False
    Caption = 'Spread Methods :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Comic Sans MS'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 368
    Top = 144
    Width = 73
    Height = 17
    AutoSize = False
    Caption = '(year, month)'
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 234
    Width = 513
    Height = 17
    Panels = <
      item
        Text = 'Libraries : Windows'
        Width = 150
      end
      item
        Text = 'Trigger Date : 04/04'
        Width = 105
      end
      item
        Text = 'DDoS Date : 04/04'
        Width = 97
      end
      item
        Text = 'Site : http://'
        Width = 50
      end>
    SimplePanel = False
  end
  object Edit1: TEdit
    Left = 88
    Top = 0
    Width = 193
    Height = 23
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 88
    Top = 24
    Width = 193
    Height = 17
    Caption = 'Try to make source undetected'
    TabOrder = 2
  end
  object CheckBox2: TCheckBox
    Left = 8
    Top = 72
    Width = 185
    Height = 17
    Caption = 'Drop Copies In Network Shares'
    TabOrder = 3
  end
  object CheckBox3: TCheckBox
    Left = 8
    Top = 96
    Width = 89
    Height = 17
    Caption = 'Mass-Mailing'
    TabOrder = 4
    OnKeyDown = CheckBox3KeyDown
    OnMouseUp = CheckBox3MouseUp
  end
  object CheckBox5: TCheckBox
    Left = 16
    Top = 120
    Width = 169
    Height = 17
    Caption = 'Scan choosen files for mails'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnKeyDown = CheckBox5KeyDown
    OnMouseUp = CheckBox5MouseUp
  end
  object CheckBox6: TCheckBox
    Left = 16
    Top = 144
    Width = 161
    Height = 17
    Caption = 'Scan txt, html, htm, doc, vbs'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnKeyDown = CheckBox6KeyDown
    OnMouseUp = CheckBox6MouseUp
  end
  object Button1: TButton
    Left = 184
    Top = 120
    Width = 65
    Height = 17
    Caption = 'Edit List'
    TabOrder = 7
    OnClick = Button1Click
  end
  object CheckBox7: TCheckBox
    Left = 16
    Top = 168
    Width = 201
    Height = 17
    Caption = 'Grab subject and bodies from files'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnKeyDown = CheckBox7KeyDown
    OnMouseUp = CheckBox7MouseUp
  end
  object CheckBox8: TCheckBox
    Left = 16
    Top = 192
    Width = 169
    Height = 17
    Caption = 'Add own subjects and bodies'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Comic Sans MS'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnKeyDown = CheckBox8KeyDown
    OnMouseUp = CheckBox8MouseUp
  end
  object Button2: TButton
    Left = 184
    Top = 192
    Width = 65
    Height = 17
    Caption = 'Edit Mail'
    TabOrder = 10
    OnClick = Button2Click
  end
  object CheckBox9: TCheckBox
    Left = 8
    Top = 216
    Width = 177
    Height = 17
    Caption = 'Drop copies in choosen folders'
    TabOrder = 11
  end
  object Button3: TButton
    Left = 184
    Top = 216
    Width = 65
    Height = 17
    Caption = 'Edit Names'
    TabOrder = 12
    OnClick = Button3Click
  end
  object CheckBox10: TCheckBox
    Left = 256
    Top = 72
    Width = 177
    Height = 17
    Caption = 'Drop IRC-Script for spreading'
    TabOrder = 13
  end
  object Button4: TButton
    Left = 440
    Top = 72
    Width = 65
    Height = 17
    Caption = 'Edit Script'
    TabOrder = 14
    OnClick = Button4Click
  end
  object CheckBox11: TCheckBox
    Left = 256
    Top = 120
    Width = 105
    Height = 17
    Caption = 'Activate IRC bot'
    TabOrder = 15
    OnKeyDown = CheckBox11KeyDown
    OnMouseUp = CheckBox11MouseUp
  end
  object Button5: TButton
    Left = 440
    Top = 120
    Width = 65
    Height = 17
    Caption = 'Edit Bot'
    TabOrder = 16
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 8
    Top = 24
    Width = 17
    Height = 17
    Caption = '?'
    TabOrder = 17
    OnClick = Button6Click
  end
  object CheckBox4: TCheckBox
    Left = 256
    Top = 144
    Width = 105
    Height = 17
    Caption = 'Time Execution'
    TabOrder = 18
  end
  object CheckBox12: TCheckBox
    Left = 256
    Top = 216
    Width = 73
    Height = 17
    Caption = 'Autostart'
    TabOrder = 19
  end
  object Panel1: TPanel
    Left = 8
    Top = 120
    Width = 3
    Height = 89
    TabOrder = 20
  end
  object Memo1: TMemo
    Left = 288
    Top = 0
    Width = 217
    Height = 65
    Lines.Strings = (
      'I want to dedicate this message to '
      'gates. Gates, you suck. Gates'
      'you really are homosexual. etc')
    ScrollBars = ssVertical
    TabOrder = 21
  end
  object CheckBox13: TCheckBox
    Left = 256
    Top = 168
    Width = 105
    Height = 17
    Caption = 'DDoS Homepage'
    TabOrder = 22
  end
  object Button9: TButton
    Left = 440
    Top = 168
    Width = 65
    Height = 17
    Caption = 'Edit ddos'
    TabOrder = 23
    OnClick = Button9Click
  end
  object CheckBox14: TCheckBox
    Left = 256
    Top = 96
    Width = 145
    Height = 17
    Caption = 'Visit site (for counters)'
    TabOrder = 24
  end
  object Button10: TButton
    Left = 440
    Top = 96
    Width = 65
    Height = 17
    Caption = 'Edit Site'
    TabOrder = 25
    OnClick = Button10Click
  end
  object CheckBox15: TCheckBox
    Left = 256
    Top = 192
    Width = 89
    Height = 17
    Caption = 'Mass WebDL'
    TabOrder = 26
  end
  object Button11: TButton
    Left = 440
    Top = 192
    Width = 65
    Height = 17
    Caption = 'Edit Urls'
    TabOrder = 27
    OnClick = Button11Click
  end
  object Edit2: TEdit
    Left = 440
    Top = 141
    Width = 65
    Height = 23
    MaxLength = 5
    TabOrder = 28
    Text = '04/03'
    OnChange = Edit2Change
  end
  object Edit3: TEdit
    Left = 368
    Top = 208
    Width = 137
    Height = 23
    TabOrder = 29
    Visible = False
  end
  object MainMenu1: TMainMenu
    Left = 240
    Top = 48
    object File1: TMenuItem
      Caption = '&File'
      object Build1: TMenuItem
        Caption = '&Build'
        OnClick = Build1Click
      end
      object Exit1: TMenuItem
        Caption = '&About'
        OnClick = Exit1Click
      end
      object Exit2: TMenuItem
        Caption = '-'
      end
      object Exit3: TMenuItem
        Caption = '&Exit'
        OnClick = Exit3Click
      end
    end
  end
end
