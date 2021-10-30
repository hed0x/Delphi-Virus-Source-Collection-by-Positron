object Form1: TForm1
  Left = 190
  Top = 105
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'p0ke'#39's WormGen 2.0'
  ClientHeight = 314
  ClientWidth = 337
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Comic Sans MS'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 81
    Height = 17
    AutoSize = False
    Caption = 'Project Name :'
  end
  object Label2: TLabel
    Left = 8
    Top = 32
    Width = 89
    Height = 17
    AutoSize = False
    Caption = 'Detection :'
  end
  object Label3: TLabel
    Left = 8
    Top = 56
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 297
    Width = 337
    Height = 17
    Panels = <
      item
        Text = 'Libraries : Windows'
        Width = 150
      end>
    SimplePanel = False
  end
  object Edit1: TEdit
    Left = 104
    Top = 8
    Width = 225
    Height = 23
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 104
    Top = 32
    Width = 225
    Height = 17
    Caption = 'Try to make source undetected'
    TabOrder = 2
  end
  object CheckBox2: TCheckBox
    Left = 16
    Top = 80
    Width = 185
    Height = 17
    Caption = 'Drop Copies In Network Shares'
    TabOrder = 3
  end
  object CheckBox3: TCheckBox
    Left = 16
    Top = 104
    Width = 89
    Height = 17
    Caption = 'Mass-Mailing'
    TabOrder = 4
    OnKeyDown = CheckBox3KeyDown
    OnMouseUp = CheckBox3MouseUp
  end
  object CheckBox5: TCheckBox
    Left = 24
    Top = 128
    Width = 169
    Height = 17
    Caption = 'Scan choosen files for mails'
    TabOrder = 5
    OnKeyDown = CheckBox5KeyDown
    OnMouseUp = CheckBox5MouseUp
  end
  object CheckBox6: TCheckBox
    Left = 24
    Top = 152
    Width = 161
    Height = 17
    Caption = 'Scan txt, html, htm, doc, vbs'
    TabOrder = 6
    OnKeyDown = CheckBox6KeyDown
    OnMouseUp = CheckBox6MouseUp
  end
  object Button1: TButton
    Left = 264
    Top = 128
    Width = 65
    Height = 17
    Caption = 'Edit List'
    TabOrder = 7
    OnClick = Button1Click
  end
  object CheckBox7: TCheckBox
    Left = 24
    Top = 176
    Width = 201
    Height = 17
    Caption = 'Grab subject and bodies from files'
    TabOrder = 8
    OnKeyDown = CheckBox7KeyDown
    OnMouseUp = CheckBox7MouseUp
  end
  object CheckBox8: TCheckBox
    Left = 24
    Top = 200
    Width = 169
    Height = 17
    Caption = 'Add own subjects and bodies'
    TabOrder = 9
    OnKeyDown = CheckBox8KeyDown
    OnMouseUp = CheckBox8MouseUp
  end
  object Button2: TButton
    Left = 264
    Top = 200
    Width = 65
    Height = 17
    Caption = 'Edit Mail'
    TabOrder = 10
    OnClick = Button2Click
  end
  object CheckBox9: TCheckBox
    Left = 16
    Top = 224
    Width = 177
    Height = 17
    Caption = 'Drop copies in choosen folders'
    TabOrder = 11
  end
  object Button3: TButton
    Left = 264
    Top = 224
    Width = 65
    Height = 17
    Caption = 'Edit Names'
    TabOrder = 12
    OnClick = Button3Click
  end
  object CheckBox10: TCheckBox
    Left = 16
    Top = 248
    Width = 177
    Height = 17
    Caption = 'Drop IRC-Script for spreading'
    TabOrder = 13
  end
  object Button4: TButton
    Left = 264
    Top = 248
    Width = 65
    Height = 17
    Caption = 'Edit Script'
    TabOrder = 14
    OnClick = Button4Click
  end
  object CheckBox11: TCheckBox
    Left = 16
    Top = 272
    Width = 105
    Height = 17
    Caption = 'Activate IRC bot'
    TabOrder = 15
    OnKeyDown = CheckBox11KeyDown
    OnMouseUp = CheckBox11MouseUp
  end
  object Button5: TButton
    Left = 264
    Top = 272
    Width = 65
    Height = 17
    Caption = 'Edit Bot'
    TabOrder = 16
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 312
    Top = 32
    Width = 17
    Height = 17
    Caption = '?'
    TabOrder = 17
    OnClick = Button6Click
  end
  object MainMenu1: TMainMenu
    Left = 296
    Top = 152
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
