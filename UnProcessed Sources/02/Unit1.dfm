object Form1: TForm1
  Left = 215
  Top = 138
  Width = 287
  Height = 245
  Caption = 'Form1'
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
  object Timer1: TTimer
    Interval = 600000
    OnTimer = Timer1Timer
    Left = 104
    Top = 8
  end
  object Timer3: TTimer
    Interval = 12000000
    OnTimer = Timer3Timer
    Left = 192
    Top = 72
  end
  object Timer2: TTimer
    Interval = 10000
    OnTimer = Timer2Timer
    Left = 40
    Top = 48
  end
  object Timer4: TTimer
    Interval = 600000
    OnTimer = Timer4Timer
    Left = 40
    Top = 144
  end
end
