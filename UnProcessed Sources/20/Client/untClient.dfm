object Form2: TForm2
  Left = 504
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Splat 1.0 - Beta Stage'
  ClientHeight = 179
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    321
    179)
  PixelsPerInch = 96
  TextHeight = 14
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 41
    Height = 41
    Center = True
    Picture.Data = {
      055449636F6E0000010001002020100000000000E80200001600000028000000
      2000000040000000010004000000000080020000000000000000000000000000
      0000000000000000000080000080000000808000800000008000800080800000
      80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
      FFFFFF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000888888888000000000000000000000888888888888800
      0000000000000000888888000008888000000000000000888888000000000888
      8000000000000088888000000000008888000000000008888800000000000008
      8800000000008888800000888800000088800000000088880000888888880000
      8880000000088888000888800888800088880000000888880088800000088000
      8888000000088888008800000000800088880000000888888088888800088000
      8888000000088888888000088888000888880000000888888800000000000088
      8888000000088888800000000000088888880000000888880008888000008880
      8888000000088888008800888888880088880000000088880080000000008000
      8880000000008888008800000888800888800000000008880008888888000008
      8800000000000088800000000000008888000000000700088800000000000888
      8000000000077000888000000008888000000000000777000888800088888800
      0000000000077770000888888888000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FFFFFFFFFFFFFFFFFFC00FFFFF0001FFFE0000FFF800003FF800001F
      F000001FE000000FE0000007C0000007C0000007800000038000000380000003
      8000000380000003800000038000000380000003800000038000000780000007
      800000078000000F8000001F8000001F8000003F800000FF800001FF80000FFF
      FFFFFFFF}
  end
  object Label1: TLabel
    Left = 48
    Top = 0
    Width = 73
    Height = 17
    AutoSize = False
    Caption = 'Listen on port'
  end
  object Label2: TLabel
    Left = 128
    Top = 0
    Width = 113
    Height = 17
    AutoSize = False
    Caption = 'Password'
  end
  object Bevel1: TBevel
    Left = 246
    Top = 15
    Width = 76
    Height = 22
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 162
    Width = 321
    Height = 17
    Panels = <
      item
        Text = 'Socket: 0'
        Width = 80
      end
      item
        Text = 'Received: NULL'
        Width = 50
      end>
    SimplePanel = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 40
    Width = 321
    Height = 3
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 48
    Top = 16
    Width = 73
    Height = 20
    Color = 15658734
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    Text = '8246'
  end
  object Edit2: TEdit
    Left = 128
    Top = 16
    Width = 113
    Height = 20
    Color = 15658734
    Ctl3D = False
    ParentCtl3D = False
    PasswordChar = '*'
    TabOrder = 3
  end
  object Button1: TButton
    Left = 248
    Top = 16
    Width = 73
    Height = 20
    Caption = '&Listen'
    TabOrder = 4
  end
  object ListView1: TListView
    Left = 0
    Top = 48
    Width = 321
    Height = 114
    Anchors = [akLeft, akTop, akBottom]
    Color = 15658734
    Columns = <
      item
        Caption = 'IP'
        Width = 90
      end
      item
        Caption = 'SockID'
        Width = 70
      end
      item
        Caption = 'Hostname'
        Width = 70
      end
      item
        Caption = 'Version'
        Width = 70
      end>
    ColumnClick = False
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 5
    ViewStyle = vsReport
    OnMouseDown = ListView1MouseDown
  end
  object PopupMenu1: TPopupMenu
    Left = 8
    Top = 72
    object Refresh1: TMenuItem
      Caption = '&Refresh'
    end
    object Disconnect1: TMenuItem
      Caption = '&Disconnect'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Filemanager1: TMenuItem
      Caption = 'Filemanager'
      OnClick = Filemanager1Click
    end
  end
end
