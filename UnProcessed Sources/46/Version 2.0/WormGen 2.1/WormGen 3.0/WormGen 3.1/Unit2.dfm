object Form2: TForm2
  Left = 513
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Rename File'
  ClientHeight = 113
  ClientWidth = 225
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
    Top = 32
    Width = 105
    Height = 17
    AutoSize = False
    Caption = 'New Name :'
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 209
    Height = 17
    AutoSize = False
    Caption = 'Library\file.snp'
  end
  object Label3: TLabel
    Left = 8
    Top = 48
    Width = 209
    Height = 41
    AutoSize = False
    Caption = 
      'Note: WormGen will find this library as a new snippet cus it doe' +
      'snt have orginal name.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Lucida Console'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object Label4: TLabel
    Left = 184
    Top = 32
    Width = 33
    Height = 17
    AutoSize = False
    Caption = '.snp'
    Layout = tlCenter
  end
  object Edit1: TEdit
    Left = 88
    Top = 32
    Width = 97
    Height = 17
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    Text = 'newname'
  end
  object Button1: TButton
    Left = 144
    Top = 88
    Width = 73
    Height = 17
    Caption = '&Change'
    TabOrder = 1
    OnClick = Button1Click
  end
end
