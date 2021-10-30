object Form2: TForm2
  Left = 190
  Top = 403
  Width = 297
  Height = 337
  Caption = 'Denial 1.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnConstrainedResize = FormConstrainedResize
  OnCreate = FormCreate
  DesignSize = (
    289
    291)
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 248
    Top = 24
    Width = 33
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Add'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 248
    Top = 56
    Width = 33
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Del'
    OnClick = SpeedButton2Click
  end
  object Label1: TLabel
    Left = 160
    Top = 1
    Width = 41
    Height = 17
    Anchors = [akTop, akRight]
    AutoSize = False
    Caption = 'Port :'
  end
  object Label2: TLabel
    Left = 8
    Top = 0
    Width = 33
    Height = 17
    AutoSize = False
    Caption = 'IP :'
  end
  object ListView1: TListView
    Left = 8
    Top = 24
    Width = 233
    Height = 225
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = 16703168
    Columns = <
      item
        Caption = 'Status'
      end
      item
        Caption = 'IP'
        Width = 112
      end
      item
        Caption = 'Port'
        Width = 70
      end>
    Ctl3D = False
    Font.Charset = ANSI_CHARSET
    Font.Color = 5066067
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ListView1DblClick
  end
  object StatusBar1: TStatusBar
    Left = 8
    Top = 266
    Width = 241
    Height = 17
    Align = alNone
    Anchors = [akLeft, akRight, akBottom]
    Panels = <
      item
        Text = 'Denial'
        Width = 120
      end
      item
        Text = '0/0 Online'
        Width = 50
      end>
    SimplePanel = False
  end
  object Edit1: TEdit
    Left = 40
    Top = 0
    Width = 113
    Height = 19
    Anchors = [akLeft, akTop, akRight]
    Color = 16703168
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 5066067
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    Text = '127.0.0.1'
  end
  object Edit2: TEdit
    Left = 208
    Top = 1
    Width = 73
    Height = 19
    Anchors = [akTop, akRight]
    Color = 16703168
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 5066067
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    Text = '2864'
  end
  object Button2: TButton
    Left = 248
    Top = 88
    Width = 33
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Mon'
    TabOrder = 4
    OnClick = Button2Click
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 250
    Width = 241
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Autoupdate Victim List'
    Checked = True
    State = cbChecked
    TabOrder = 5
    OnClick = CheckBox1Click
  end
  object Timer1: TTimer
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 208
    Top = 112
  end
  object Timer2: TTimer
    Interval = 2000
    OnTimer = Timer2Timer
    Left = 208
    Top = 80
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = ClientSocket1Connect
    OnDisconnect = ClientSocket1Disconnect
    OnError = ClientSocket1Error
    Left = 208
    Top = 144
  end
  object MainMenu1: TMainMenu
    Left = 208
    Top = 48
    object File1: TMenuItem
      Caption = '&File'
      object Exit1: TMenuItem
        Caption = '&Exit'
        OnClick = Exit1Click
      end
    end
    object About1: TMenuItem
      Caption = '&About'
      object About2: TMenuItem
        Caption = '&About'
        OnClick = About2Click
      end
    end
  end
end
