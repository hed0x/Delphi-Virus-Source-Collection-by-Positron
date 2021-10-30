object Form4: TForm4
  Left = 192
  Top = 107
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 81
  ClientWidth = 121
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 121
    Height = 81
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 105
      Height = 65
      Alignment = taCenter
      AutoSize = False
      Caption = '0 new updates for download'
      Layout = tlCenter
      WordWrap = True
    end
  end
  object Timer1: TTimer
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 88
    Top = 48
  end
end
