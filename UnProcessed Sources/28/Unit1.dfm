object Form1: TForm1
  Left = 189
  Top = 105
  Width = 500
  Height = 358
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Georgia'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    492
    331)
  PixelsPerInch = 96
  TextHeight = 14
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 492
    Height = 251
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Base'
        Width = 168
      end
      item
        Caption = 'Secondary'
        Width = 160
      end
      item
        Caption = 'Third Part'
        Width = 163
      end>
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Georgia'
    Font.Style = []
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Edit1: TEdit
    Left = 0
    Top = 258
    Width = 412
    Height = 22
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    OnKeyDown = Edit1KeyDown
  end
  object Button1: TButton
    Left = 419
    Top = 258
    Width = 73
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'Add Words'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 419
    Top = 306
    Width = 73
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'Say Rand'
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 0
    Top = 282
    Width = 412
    Height = 49
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 4
  end
  object Button3: TButton
    Left = 419
    Top = 282
    Width = 73
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'Connect'
    TabOrder = 5
    OnClick = Button3Click
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Host = 'irc.elfnet.org'
    Port = 6667
    OnConnect = ClientSocket1Connect
    OnRead = ClientSocket1Read
    OnError = ClientSocket1Error
    Left = 8
    Top = 24
  end
end
