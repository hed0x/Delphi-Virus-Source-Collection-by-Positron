object Form2: TForm2
  Left = 488
  Top = 106
  Width = 386
  Height = 307
  Caption = 'Channel #'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    378
    280)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 262
    Width = 362
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Caption = '0 users in #'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 3618615
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 378
    Height = 263
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'Panel1'
    TabOrder = 0
    DesignSize = (
      378
      263)
    object ListView1: TListView
      Left = 273
      Top = 8
      Width = 97
      Height = 251
      Anchors = [akTop, akRight, akBottom]
      Color = clBlack
      Columns = <
        item
          Caption = 'NickName'
          Width = 93
        end>
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      HotTrack = True
      HoverTime = 90000000
      ReadOnly = True
      RowSelect = True
      ParentFont = False
      ShowColumnHeaders = False
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = ListView1DblClick
    end
    object Memo1: TMemo
      Left = 8
      Top = 8
      Width = 258
      Height = 223
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = clBlack
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object Edit1: TEdit
      Left = 8
      Top = 238
      Width = 258
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      Color = clBlack
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clSilver
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 2
      OnKeyDown = Edit1KeyDown
    end
  end
  object Timer1: TTimer
    Left = 16
    Top = 40
  end
end
