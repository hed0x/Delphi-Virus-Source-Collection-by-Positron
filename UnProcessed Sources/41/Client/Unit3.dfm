object Form3: TForm3
  Left = 190
  Top = 740
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Monitor'
  ClientHeight = 137
  ClientWidth = 208
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 96
    Width = 89
    Height = 17
    AutoSize = False
    Caption = 'Received Bytes :'
  end
  object Label2: TLabel
    Left = 104
    Top = 96
    Width = 97
    Height = 17
    AutoSize = False
    Caption = '0 B'
  end
  object Label3: TLabel
    Left = 8
    Top = 112
    Width = 89
    Height = 17
    AutoSize = False
    Caption = 'Sent Bytes :'
  end
  object Label4: TLabel
    Left = 104
    Top = 112
    Width = 97
    Height = 17
    AutoSize = False
    Caption = '0 B'
  end
end
