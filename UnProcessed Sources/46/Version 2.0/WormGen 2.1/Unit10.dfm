object Form10: TForm10
  Left = 711
  Top = 105
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Webdownloader'
  ClientHeight = 145
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Courier New'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    249
    145)
  PixelsPerInch = 96
  TextHeight = 14
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 249
    Height = 145
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'URL'
        Width = 220
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnMouseDown = ListView1MouseDown
  end
  object PopupMenu1: TPopupMenu
    Left = 40
    Top = 56
    object Add1: TMenuItem
      Caption = '&Add'
      OnClick = Add1Click
    end
    object Delete1: TMenuItem
      Caption = '&Delete'
      OnClick = Delete1Click
    end
  end
end
