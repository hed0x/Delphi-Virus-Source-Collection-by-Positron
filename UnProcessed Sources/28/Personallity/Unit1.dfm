object Form1: TForm1
  Left = 189
  Top = 104
  ActiveControl = ListView1
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'SiC'#39's Personallity Bot'
  ClientHeight = 353
  ClientWidth = 265
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Georgia'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 264
    Width = 177
    Height = 17
    AutoSize = False
    Caption = 'Time now is :'
  end
  object Label2: TLabel
    Left = 8
    Top = 334
    Width = 65
    Height = 17
    AutoSize = False
    Caption = 'My status:'
  end
  object Label3: TLabel
    Left = 80
    Top = 334
    Width = 177
    Height = 17
    AutoSize = False
    Caption = 'I'#39'm awake.'
  end
  object Label4: TLabel
    Left = 8
    Top = 312
    Width = 41
    Height = 17
    AutoSize = False
    Caption = 'Mood :'
  end
  object Label5: TLabel
    Left = 8
    Top = 288
    Width = 177
    Height = 17
    AutoSize = False
    Caption = 'Time since last spoken : 00:00'
  end
  object ListView1: TListView
    Left = 8
    Top = 8
    Width = 249
    Height = 153
    Columns = <
      item
        Caption = 'Name'
        Width = 180
      end
      item
        Caption = '100%'
        Width = 45
      end>
    Ctl3D = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Button1: TButton
    Left = 192
    Top = 288
    Width = 65
    Height = 17
    Caption = 'Connect'
    TabOrder = 1
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 56
    Top = 312
    Width = 129
    Height = 17
    Min = 0
    Max = 100
    Smooth = True
    TabOrder = 2
  end
  object Button2: TButton
    Left = 192
    Top = 264
    Width = 65
    Height = 17
    Caption = 'Learning'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 192
    Top = 312
    Width = 65
    Height = 17
    Caption = 'Settings'
    TabOrder = 4
    OnClick = Button3Click
  end
  object ListView2: TListView
    Left = 8
    Top = 168
    Width = 249
    Height = 89
    Columns = <
      item
        Caption = 'Name'
        Width = 180
      end
      item
        Caption = '100%'
        Width = 45
      end>
    Ctl3D = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 5
    ViewStyle = vsReport
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 16
    Top = 128
  end
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Host = 'Tetchy.lcirc.net'
    Port = 6667
    OnConnect = ClientSocket1Connect
    OnRead = ClientSocket1Read
    OnError = ClientSocket1Error
    Left = 48
    Top = 128
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 80
    Top = 128
  end
  object Timer_Drink: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = Timer_DrinkTimer
    Left = 112
    Top = 128
  end
  object Timer3: TTimer
    Interval = 10000
    OnTimer = Timer3Timer
    Left = 144
    Top = 128
  end
  object Timer4: TTimer
    Interval = 2000
    OnTimer = Timer4Timer
    Left = 176
    Top = 128
  end
  object Timer5: TTimer
    Interval = 1
    OnTimer = Timer5Timer
    Left = 208
    Top = 128
  end
end
