object Form3: TForm3
  Left = 746
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Edit File'
  ClientHeight = 145
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
    Left = 0
    Top = 0
    Width = 97
    Height = 17
    AutoSize = False
    Caption = 'Description :'
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 8
    Top = 120
    Width = 121
    Height = 17
    AutoSize = False
    Caption = '%file%'
    Layout = tlCenter
  end
  object Memo1: TMemo
    Left = 8
    Top = 16
    Width = 217
    Height = 97
    Ctl3D = False
    ParentCtl3D = False
    ScrollBars = ssVertical
    TabOrder = 0
    OnKeyDown = Memo1KeyDown
    OnKeyPress = Memo1KeyPress
  end
  object Button1: TButton
    Left = 136
    Top = 120
    Width = 89
    Height = 17
    Caption = '&Change'
    TabOrder = 1
    OnClick = Button1Click
  end
end
