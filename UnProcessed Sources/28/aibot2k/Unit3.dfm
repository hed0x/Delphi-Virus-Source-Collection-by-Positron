object Form3: TForm3
  Left = 874
  Top = 106
  Width = 297
  Height = 252
  Caption = 'PrivMsg $'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    289
    225)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 289
    Height = 225
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      289
      225)
    object Memo1: TMemo
      Left = 8
      Top = 8
      Width = 273
      Height = 185
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object Edit1: TEdit
      Left = 8
      Top = 200
      Width = 273
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnKeyUp = Edit1KeyUp
    end
  end
end
