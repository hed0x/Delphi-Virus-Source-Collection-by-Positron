object Form1: TForm1
  Left = 190
  Top = 106
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'aIRC'
  ClientHeight = 257
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Lucida Console'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 11
  object Panel1: TPanel
    Left = 0
    Top = 240
    Width = 289
    Height = 17
    Alignment = taLeftJustify
    BevelOuter = bvLowered
    Caption = 'IrcBot - Disconnected'
    TabOrder = 0
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 289
    Height = 240
    ActivePage = TabSheet3
    Style = tsButtons
    TabIndex = 2
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Status'
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 81
        Height = 17
        AutoSize = False
        Caption = 'Users'
        Layout = tlCenter
      end
      object ListView1: TListView
        Left = 0
        Top = 16
        Width = 281
        Height = 105
        Columns = <
          item
            Caption = 'NickName'
            Width = 100
          end
          item
            Caption = 'Connected'
            Width = 70
          end
          item
            Caption = 'First Word'
            Width = 100
          end
          item
            Caption = 'Sex'
            Width = 30
          end
          item
            Caption = 'Channel'
          end>
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        GridLines = True
        HotTrack = True
        HoverTime = 90000000
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        TabOrder = 0
        ViewStyle = vsReport
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 128
        Width = 281
        Height = 84
        Caption = 'Settings'
        TabOrder = 1
        object CheckBox1: TCheckBox
          Left = 8
          Top = 16
          Width = 129
          Height = 17
          Caption = 'Learning'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object CheckBox2: TCheckBox
          Left = 8
          Top = 40
          Width = 129
          Height = 17
          Caption = 'Silence'
          TabOrder = 1
        end
        object CheckBox3: TCheckBox
          Left = 152
          Top = 40
          Width = 121
          Height = 17
          Caption = 'Use badwords'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object CheckBox4: TCheckBox
          Left = 152
          Top = 16
          Width = 121
          Height = 17
          Caption = 'Insult people'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object CheckBox5: TCheckBox
          Left = 8
          Top = 64
          Width = 265
          Height = 17
          Caption = 'Ask if person is male/female (Beta)'
          TabOrder = 4
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'RawIrc'
      ImageIndex = 1
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 281
        Height = 185
        Ctl3D = True
        ParentCtl3D = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object ComboBox1: TComboBox
        Left = 0
        Top = 192
        Width = 281
        Height = 19
        Style = csSimple
        Ctl3D = True
        ItemHeight = 11
        ParentCtl3D = False
        TabOrder = 1
        OnKeyUp = ComboBox1KeyUp
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Connection'
      ImageIndex = 2
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 89
        Height = 17
        AutoSize = False
        Caption = 'Bot Nickname'
        Layout = tlCenter
      end
      object Label3: TLabel
        Left = 8
        Top = 32
        Width = 89
        Height = 17
        AutoSize = False
        Caption = 'Alt Nickname'
        Layout = tlCenter
      end
      object Label4: TLabel
        Left = 8
        Top = 56
        Width = 89
        Height = 17
        AutoSize = False
        Caption = 'Ident'
        Layout = tlCenter
      end
      object Label5: TLabel
        Left = 8
        Top = 128
        Width = 121
        Height = 17
        AutoSize = False
        Caption = 'Channels to Join'
        Layout = tlCenter
      end
      object Label8: TLabel
        Left = 8
        Top = 80
        Width = 89
        Height = 17
        AutoSize = False
        Caption = 'Server Host'
        Layout = tlCenter
      end
      object Label9: TLabel
        Left = 8
        Top = 104
        Width = 89
        Height = 17
        AutoSize = False
        Caption = 'Server Port'
        Layout = tlCenter
      end
      object Edit1: TEdit
        Left = 104
        Top = 8
        Width = 169
        Height = 17
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        Text = 'p3wk'
      end
      object Edit2: TEdit
        Left = 104
        Top = 32
        Width = 169
        Height = 17
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 1
        Text = 'p3wk'
      end
      object Edit3: TEdit
        Left = 104
        Top = 56
        Width = 169
        Height = 17
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 2
        Text = 'p3wk'
      end
      object Memo2: TMemo
        Left = 16
        Top = 144
        Width = 257
        Height = 41
        Ctl3D = False
        Lines.Strings = (
          '#box')
        ParentCtl3D = False
        ScrollBars = ssVertical
        TabOrder = 3
      end
      object Button1: TButton
        Left = 200
        Top = 192
        Width = 73
        Height = 17
        Caption = 'Go for it'
        TabOrder = 4
        OnClick = Button1Click
      end
      object Edit4: TEdit
        Left = 104
        Top = 80
        Width = 169
        Height = 17
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 5
        Text = 'irc2.crackinggear.net'
      end
      object Edit5: TEdit
        Left = 104
        Top = 104
        Width = 169
        Height = 17
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 6
        Text = '6667'
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'WordList'
      ImageIndex = 3
      object Label6: TLabel
        Left = 0
        Top = 136
        Width = 89
        Height = 17
        AutoSize = False
        Caption = 'Bad Words :'
      end
      object Label7: TLabel
        Left = 144
        Top = 136
        Width = 89
        Height = 17
        AutoSize = False
        Caption = 'Hello Words :'
      end
      object ListView2: TListView
        Left = 0
        Top = 72
        Width = 281
        Height = 58
        Columns = <
          item
            Caption = 'Word 1'
            Width = 87
          end
          item
            Caption = 'Word 2'
            Width = 87
          end
          item
            Caption = 'Word 3'
            Width = 87
          end>
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        GridLines = True
        HotTrack = True
        HoverTime = 90000000
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        TabOrder = 3
        ViewStyle = vsReport
      end
      object ListView3: TListView
        Left = 0
        Top = 152
        Width = 137
        Height = 50
        Columns = <
          item
            Caption = 'The F-Words'
            Width = 115
          end>
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        GridLines = True
        HotTrack = True
        HoverTime = 90000000
        Items.Data = {
          9D0000000600000000000000FFFFFFFFFFFFFFFF000000000000000004467563
          6B00000000FFFFFFFFFFFFFFFF00000000000000000443756E7400000000FFFF
          FFFFFFFFFFFF00000000000000000346616700000000FFFFFFFFFFFFFFFF0000
          0000000000000347617900000000FFFFFFFFFFFFFFFF00000000000000000453
          68697400000000FFFFFFFFFFFFFFFF0000000000000000055075737379}
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        TabOrder = 1
        ViewStyle = vsReport
      end
      object ListView4: TListView
        Left = 144
        Top = 152
        Width = 137
        Height = 50
        Columns = <
          item
            Caption = 'Whatsup doug'#39
            Width = 115
          end>
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        GridLines = True
        HotTrack = True
        HoverTime = 90000000
        Items.Data = {
          9C0000000600000000000000FFFFFFFFFFFFFFFF000000000000000002486900
          000000FFFFFFFFFFFFFFFF00000000000000000548656C6C6F00000000FFFFFF
          FFFFFFFFFF0000000000000000075768617473757000000000FFFFFFFFFFFFFF
          FF00000000000000000353757000000000FFFFFFFFFFFFFFFF00000000000000
          0002596F00000000FFFFFFFFFFFFFFFF000000000000000003486579}
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        TabOrder = 0
        ViewStyle = vsReport
      end
      object ListView5: TListView
        Left = 0
        Top = 0
        Width = 281
        Height = 58
        Columns = <
          item
            Caption = 'Word 1'
            Width = 130
          end
          item
            Caption = 'Word 2'
            Width = 130
          end>
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        GridLines = True
        HotTrack = True
        HoverTime = 90000000
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        TabOrder = 2
        ViewStyle = vsReport
      end
    end
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnecting = ClientSocket1Connecting
    OnConnect = ClientSocket1Connect
    OnDisconnect = ClientSocket1Disconnect
    OnRead = ClientSocket1Read
    OnError = ClientSocket1Error
    Left = 216
    Top = 64
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 248
    Top = 64
  end
end
