object Form1: TForm1
  Left = 190
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'WormGen 3.1'
  ClientHeight = 260
  ClientWidth = 313
  Color = clBtnFace
  TransparentColorValue = clFuchsia
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Lucida Console'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 11
  object Panel1: TPanel
    Left = 0
    Top = 243
    Width = 158
    Height = 17
    Alignment = taLeftJustify
    BevelOuter = bvLowered
    Caption = 'File: Unnamed.dpr'
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 160
    Top = 243
    Width = 93
    Height = 17
    Alignment = taLeftJustify
    BevelOuter = bvLowered
    Caption = 'Size: 0 kb'
    TabOrder = 1
  end
  object Panel3: TPanel
    Left = 256
    Top = 243
    Width = 57
    Height = 17
    Alignment = taLeftJustify
    BevelOuter = bvLowered
    TabOrder = 2
    object ProgressBar1: TProgressBar
      Left = 0
      Top = 0
      Width = 57
      Height = 17
      Min = 0
      Max = 100
      Smooth = True
      TabOrder = 0
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 313
    Height = 241
    ActivePage = TabSheet1
    HotTrack = True
    Style = tsButtons
    TabIndex = 0
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = 'Build'
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 81
        Height = 17
        AutoSize = False
        Caption = 'Worm Name :'
        Layout = tlCenter
      end
      object Label3: TLabel
        Left = 8
        Top = 144
        Width = 289
        Height = 57
        AutoSize = False
        Caption = 
          'By using this software, you are accepting full responsibility fo' +
          'r your creations/actions. The author cannot be held responsible ' +
          'for any damage/creations created by this program.'
        WordWrap = True
      end
      object Edit1: TEdit
        Left = 88
        Top = 0
        Width = 129
        Height = 17
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        Text = 'Unnamed'
      end
      object Button1: TButton
        Left = 224
        Top = 0
        Width = 81
        Height = 17
        Caption = '&Change'
        TabOrder = 1
        OnClick = Button1Click
      end
      object ListView1: TListView
        Left = 0
        Top = 24
        Width = 305
        Height = 89
        Columns = <
          item
            Caption = 'Name'
            Width = 60
          end
          item
            Caption = 'Size'
          end
          item
            Caption = 'Description'
            Width = 110
          end
          item
            Caption = 'Made By'
            Width = 65
          end>
        ColumnClick = False
        Ctl3D = False
        DragCursor = crDefault
        DragKind = dkDock
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        GridLines = True
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        TabOrder = 2
        ViewStyle = vsReport
      end
      object Button2: TButton
        Left = 0
        Top = 120
        Width = 57
        Height = 17
        Caption = '&Delete'
        TabOrder = 3
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 56
        Top = 120
        Width = 57
        Height = 17
        Caption = '&Rename'
        TabOrder = 4
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 112
        Top = 120
        Width = 57
        Height = 17
        Caption = '&Edit'
        TabOrder = 5
        OnClick = Button4Click
      end
      object Button5: TButton
        Left = 248
        Top = 120
        Width = 57
        Height = 17
        Caption = '&Build'
        TabOrder = 6
        OnClick = Button5Click
      end
      object Button9: TButton
        Left = 168
        Top = 120
        Width = 57
        Height = 17
        Caption = 'Help'
        TabOrder = 7
        OnClick = Button9Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Library'
      ImageIndex = 1
      object Label2: TLabel
        Left = 0
        Top = 0
        Width = 305
        Height = 17
        AutoSize = False
        Caption = 'No file selected.'
        Layout = tlCenter
      end
      object ListView2: TListView
        Left = 0
        Top = 24
        Width = 305
        Height = 161
        Columns = <
          item
            Caption = 'Name'
            Width = 60
          end
          item
            Caption = 'Size'
          end
          item
            Caption = 'Description'
            Width = 110
          end
          item
            Caption = 'Made By'
            Width = 65
          end>
        ColumnClick = False
        Ctl3D = False
        DragCursor = crDefault
        DragKind = dkDock
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        GridLines = True
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = ListView2Click
        OnMouseUp = ListView2MouseUp
      end
      object Button6: TButton
        Left = 0
        Top = 192
        Width = 57
        Height = 17
        Caption = '&Delete'
        TabOrder = 1
        OnClick = Button6Click
      end
      object Button7: TButton
        Left = 56
        Top = 192
        Width = 57
        Height = 17
        Caption = '&Rename'
        TabOrder = 2
        OnClick = Button7Click
      end
      object Button8: TButton
        Left = 112
        Top = 192
        Width = 57
        Height = 17
        Caption = '&Edit'
        TabOrder = 3
        OnClick = Button8Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Update'
      ImageIndex = 2
      object Label4: TLabel
        Left = 0
        Top = 8
        Width = 305
        Height = 17
        AutoSize = False
        Caption = '0 New updates'
      end
      object Label5: TLabel
        Left = 0
        Top = 160
        Width = 57
        Height = 17
        AutoSize = False
        Caption = 'Progress'
        Layout = tlCenter
      end
      object Label6: TLabel
        Left = 0
        Top = 184
        Width = 65
        Height = 17
        AutoSize = False
        Caption = 'Status'
        Layout = tlCenter
      end
      object up: TLabel
        Left = 96
        Top = 72
        Width = 97
        Height = 33
        AutoSize = False
        Visible = False
      end
      object Button11: TButton
        Left = 96
        Top = 136
        Width = 89
        Height = 17
        Caption = '&Install'
        TabOrder = 2
        OnClick = Button11Click
      end
      object ListView3: TListView
        Left = 0
        Top = 24
        Width = 305
        Height = 105
        Columns = <
          item
            Caption = 'Name'
            Width = 60
          end
          item
            Caption = 'Size'
          end
          item
            Caption = 'Description'
            Width = 110
          end
          item
            Caption = 'Made By'
            Width = 65
          end>
        ColumnClick = False
        Ctl3D = False
        DragCursor = crDefault
        DragKind = dkDock
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        GridLines = True
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        TabOrder = 0
        ViewStyle = vsReport
      end
      object Button10: TButton
        Left = 216
        Top = 136
        Width = 89
        Height = 17
        Caption = '&Get Updates'
        TabOrder = 1
        OnClick = Button10Click
      end
      object Panel4: TPanel
        Left = 96
        Top = 160
        Width = 209
        Height = 17
        Alignment = taLeftJustify
        Caption = ' 0%'
        TabOrder = 3
      end
      object Panel5: TPanel
        Left = 96
        Top = 184
        Width = 209
        Height = 17
        Alignment = taLeftJustify
        Caption = ' none'
        TabOrder = 4
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Config'
      ImageIndex = 3
      object Label10: TLabel
        Left = 0
        Top = 192
        Width = 49
        Height = 17
        AutoSize = False
        Caption = 'Host :'
        Layout = tlCenter
      end
      object Button22: TButton
        Left = 208
        Top = 192
        Width = 41
        Height = 17
        Caption = 'Save'
        TabOrder = 5
        OnClick = Button22Click
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 305
        Height = 65
        Caption = '&Build Options'
        TabOrder = 0
        object CheckBox1: TCheckBox
          Left = 8
          Top = 16
          Width = 233
          Height = 17
          Caption = 'Remove Found Comments'
          TabOrder = 0
        end
        object Button12: TButton
          Left = 248
          Top = 16
          Width = 49
          Height = 17
          Caption = 'Help'
          TabOrder = 1
          OnClick = Button12Click
        end
        object CheckBox2: TCheckBox
          Left = 8
          Top = 40
          Width = 233
          Height = 17
          Caption = 'Auto-check for updates'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object Button13: TButton
          Left = 248
          Top = 40
          Width = 49
          Height = 17
          Caption = 'Help'
          TabOrder = 3
          OnClick = Button13Click
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 72
        Width = 305
        Height = 113
        Caption = 'Client Options'
        TabOrder = 1
        object CheckBox3: TCheckBox
          Left = 8
          Top = 16
          Width = 233
          Height = 17
          Caption = 'Save window positions'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object CheckBox4: TCheckBox
          Left = 8
          Top = 40
          Width = 233
          Height = 17
          Caption = 'Check for update at startup'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object CheckBox5: TCheckBox
          Left = 8
          Top = 64
          Width = 233
          Height = 17
          Caption = 'Show message on new updates'
          TabOrder = 2
        end
        object CheckBox6: TCheckBox
          Left = 8
          Top = 88
          Width = 233
          Height = 17
          Caption = 'Minimize to tray on close'
          TabOrder = 3
        end
        object Button15: TButton
          Left = 248
          Top = 16
          Width = 49
          Height = 17
          Caption = 'Help'
          TabOrder = 4
          OnClick = Button15Click
        end
        object Button16: TButton
          Left = 248
          Top = 40
          Width = 49
          Height = 17
          Caption = 'Help'
          TabOrder = 5
          OnClick = Button16Click
        end
        object Button17: TButton
          Left = 248
          Top = 64
          Width = 49
          Height = 17
          Caption = 'Help'
          TabOrder = 6
          OnClick = Button17Click
        end
        object Button18: TButton
          Left = 248
          Top = 88
          Width = 49
          Height = 17
          Caption = 'Help'
          TabOrder = 7
          OnClick = Button18Click
        end
      end
      object Button14: TButton
        Left = 248
        Top = 192
        Width = 57
        Height = 17
        Caption = 'Default'
        TabOrder = 2
        OnClick = Button14Click
      end
      object Edit2: TEdit
        Left = 48
        Top = 192
        Width = 105
        Height = 17
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 3
        Text = 'p0ke.no-ip.com'
      end
      object Edit3: TEdit
        Left = 160
        Top = 192
        Width = 41
        Height = 17
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 4
        Text = '23064'
        OnKeyPress = Edit3KeyPress
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Submit'
      ImageIndex = 4
      object Label7: TLabel
        Left = 0
        Top = 192
        Width = 65
        Height = 17
        AutoSize = False
        Caption = 'Status :'
        Layout = tlCenter
      end
      object Label8: TLabel
        Left = 72
        Top = 192
        Width = 233
        Height = 17
        AutoSize = False
        Caption = 'Disconnected.'
        Layout = tlCenter
      end
      object Label12: TLabel
        Left = 8
        Top = 155
        Width = 49
        Height = 17
        AutoSize = False
        Caption = 'Uses :'
        Layout = tlCenter
      end
      object balle: TPageControl
        Left = 0
        Top = 0
        Width = 305
        Height = 153
        ActivePage = TabSheet6
        TabIndex = 0
        TabOrder = 0
        object TabSheet6: TTabSheet
          Caption = 'Snippet'
          object count_snippet: TLabel
            Left = 0
            Top = 112
            Width = 297
            Height = 17
            AutoSize = False
            Caption = '0:0 [0 lines; 0 chars]'
            Layout = tlCenter
          end
          object Memo5: TMemo
            Left = 0
            Top = 0
            Width = 297
            Height = 113
            ScrollBars = ssVertical
            TabOrder = 0
            OnChange = Memo5Change
          end
        end
        object TabSheet7: TTabSheet
          Caption = 'Types'
          ImageIndex = 1
          object count_types: TLabel
            Left = 0
            Top = 112
            Width = 297
            Height = 17
            AutoSize = False
            Caption = '0:0 [0 lines; 0 chars]'
            Layout = tlCenter
          end
          object Memo4: TMemo
            Left = 0
            Top = 0
            Width = 297
            Height = 113
            ScrollBars = ssVertical
            TabOrder = 0
            OnChange = Memo4Change
          end
        end
        object TabSheet8: TTabSheet
          Caption = 'Const'
          ImageIndex = 2
          object count_consts: TLabel
            Left = 0
            Top = 112
            Width = 297
            Height = 17
            AutoSize = False
            Caption = '0:0 [0 lines; 0 chars]'
            Layout = tlCenter
          end
          object Label9: TLabel
            Left = 0
            Top = 0
            Width = 145
            Height = 17
            AutoSize = False
            Caption = 'Dont type "Const"'
            Layout = tlCenter
          end
          object Memo3: TMemo
            Left = 0
            Top = 16
            Width = 297
            Height = 97
            ScrollBars = ssVertical
            TabOrder = 0
            OnChange = Memo3Change
          end
        end
        object TabSheet9: TTabSheet
          Caption = 'Vars'
          ImageIndex = 3
          object count_vars: TLabel
            Left = 0
            Top = 112
            Width = 297
            Height = 17
            AutoSize = False
            Caption = '0:0 [0 lines; 0 chars]'
            Layout = tlCenter
          end
          object Label11: TLabel
            Left = 0
            Top = 0
            Width = 145
            Height = 17
            AutoSize = False
            Caption = 'Dont type "Var"'
            Layout = tlCenter
          end
          object Memo2: TMemo
            Left = 0
            Top = 16
            Width = 297
            Height = 97
            ScrollBars = ssVertical
            TabOrder = 0
            OnChange = Memo2Change
          end
        end
        object TabSheet10: TTabSheet
          Caption = 'Declares'
          ImageIndex = 4
          object count_declare: TLabel
            Left = 0
            Top = 112
            Width = 297
            Height = 17
            AutoSize = False
            Caption = '0:0 [0 lines; 0 chars]'
            Layout = tlCenter
          end
          object Memo1: TMemo
            Left = 0
            Top = 0
            Width = 297
            Height = 113
            ScrollBars = ssVertical
            TabOrder = 0
            OnChange = Memo1Change
          end
        end
      end
      object Button19: TButton
        Left = 0
        Top = 176
        Width = 65
        Height = 17
        Caption = '&Submit'
        TabOrder = 1
        OnClick = Button19Click
      end
      object Button20: TButton
        Left = 240
        Top = 176
        Width = 65
        Height = 17
        Caption = 'Help'
        TabOrder = 2
        OnClick = Button20Click
      end
      object Button21: TButton
        Left = 64
        Top = 176
        Width = 129
        Height = 17
        Caption = 'Upload a new .pas'
        TabOrder = 3
        OnClick = Button21Click
      end
      object Edit4: TEdit
        Left = 64
        Top = 155
        Width = 241
        Height = 17
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 4
        Text = 'Windows, Messages;'
      end
    end
  end
  object Update: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 23064
    OnConnecting = UpdateConnecting
    OnConnect = UpdateConnect
    OnDisconnect = UpdateDisconnect
    OnRead = UpdateRead
    OnError = UpdateError
    Left = 144
    Top = 72
  end
  object Submit: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 23064
    OnConnecting = SubmitConnecting
    OnConnect = SubmitConnect
    OnDisconnect = SubmitDisconnect
    OnError = SubmitError
    Left = 112
    Top = 72
  end
  object PopupMenu1: TPopupMenu
    Left = 48
    Top = 72
    object Show1: TMenuItem
      Caption = '&Show'
      OnClick = Show1Click
    end
    object Exit1: TMenuItem
      Caption = '&Exit'
      OnClick = Exit1Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 600000
    OnTimer = Timer1Timer
    Left = 80
    Top = 72
  end
  object OpenDialog1: TOpenDialog
    Left = 16
    Top = 72
  end
  object Timer2: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer2Timer
    Left = 176
    Top = 72
  end
end
