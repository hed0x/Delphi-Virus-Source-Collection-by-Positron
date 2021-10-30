object Form6: TForm6
  Left = 701
  Top = 335
  Width = 313
  Height = 292
  Caption = 'Denial Client'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnConstrainedResize = FormConstrainedResize
  OnCreate = FormCreate
  DesignSize = (
    305
    265)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 305
    Height = 248
    ActivePage = TabSheet3
    Anchors = [akLeft, akTop, akRight, akBottom]
    Style = tsButtons
    TabIndex = 0
    TabOrder = 0
    object TabSheet3: TTabSheet
      Caption = 'Managers'
      ImageIndex = 2
      DesignSize = (
        297
        217)
      object PageControl2: TPageControl
        Left = 0
        Top = 0
        Width = 297
        Height = 216
        ActivePage = TabSheet5
        Anchors = [akLeft, akTop, akRight, akBottom]
        BiDiMode = bdLeftToRight
        ParentBiDiMode = False
        Style = tsButtons
        TabIndex = 0
        TabOrder = 0
        object TabSheet5: TTabSheet
          Caption = 'File'
          DesignSize = (
            289
            185)
          object Label16: TLabel
            Left = 72
            Top = 167
            Width = 217
            Height = 17
            Anchors = [akLeft, akRight, akBottom]
            AutoSize = False
            Caption = 'C:\'
            WordWrap = True
          end
          object ComboBox1: TComboBox
            Left = 72
            Top = 0
            Width = 217
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            ItemHeight = 13
            ParentFont = False
            TabOrder = 0
            OnChange = ComboBox1Change
          end
          object Button6: TButton
            Left = 0
            Top = 0
            Width = 65
            Height = 22
            Caption = 'Get Drives'
            TabOrder = 1
            OnClick = Button6Click
          end
          object Button7: TButton
            Left = 0
            Top = 32
            Width = 65
            Height = 22
            Caption = 'Refresh'
            Enabled = False
            TabOrder = 2
            OnClick = Button7Click
          end
          object Button8: TButton
            Left = 0
            Top = 56
            Width = 65
            Height = 22
            Caption = 'Delete'
            Enabled = False
            TabOrder = 3
            OnClick = Button8Click
          end
          object Button9: TButton
            Left = 0
            Top = 80
            Width = 65
            Height = 22
            Caption = 'Delete Dir'
            Enabled = False
            TabOrder = 4
            OnClick = Button9Click
          end
          object Button10: TButton
            Left = 0
            Top = 104
            Width = 65
            Height = 22
            Caption = 'Execute'
            Enabled = False
            TabOrder = 5
            OnClick = Button10Click
          end
          object Button11: TButton
            Left = 0
            Top = 136
            Width = 65
            Height = 22
            Caption = 'Upload'
            TabOrder = 6
            OnClick = Button11Click
          end
          object Button12: TButton
            Left = 0
            Top = 160
            Width = 65
            Height = 22
            Caption = 'Download'
            Enabled = False
            TabOrder = 7
            OnClick = Button12Click
          end
          object ListView5: TListView
            Left = 72
            Top = 24
            Width = 217
            Height = 136
            Anchors = [akLeft, akTop, akRight, akBottom]
            Color = 16703168
            Columns = <
              item
                Caption = 'Name'
                Width = 100
              end
              item
                Caption = 'Size'
              end
              item
                Caption = 'Dir'
                Width = 47
              end>
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Lucida Console'
            Font.Style = []
            LargeImages = ImageList1
            ReadOnly = True
            RowSelect = True
            ParentFont = False
            SmallImages = ImageList1
            SortType = stData
            TabOrder = 8
            ViewStyle = vsReport
            OnDblClick = ListView5DblClick
          end
        end
        object TabSheet15: TTabSheet
          Caption = 'Regeditor'
          ImageIndex = 4
          DesignSize = (
            289
            185)
          object Label19: TLabel
            Left = 0
            Top = 167
            Width = 289
            Height = 17
            Anchors = [akLeft, akRight, akBottom]
            AutoSize = False
            Caption = 'ROOT\'
          end
          object RegValues: TListView
            Left = 184
            Top = 48
            Width = 105
            Height = 112
            Anchors = [akLeft, akTop, akRight, akBottom]
            Color = 16703168
            Columns = <
              item
                Caption = 'Key'
                Width = 80
              end
              item
                Caption = 'Value'
                Width = 93
              end>
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            ReadOnly = True
            RowSelect = True
            ParentFont = False
            SmallImages = ImageList2
            TabOrder = 0
            ViewStyle = vsReport
            OnClick = RegValuesClick
          end
          object RegView: TListView
            Left = 0
            Top = 48
            Width = 177
            Height = 112
            Anchors = [akLeft, akTop, akBottom]
            Color = 16703168
            Columns = <
              item
                Caption = 'Keys'
                Width = 173
              end>
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            Items.Data = {
              C20000000500000000000000FFFFFFFFFFFFFFFF000000000000000011484B45
              595F434C41535345535F524F4F5400000000FFFFFFFFFFFFFFFF000000000000
              000011484B45595F43555252454E545F5553455200000000FFFFFFFFFFFFFFFF
              000000000000000012484B45595F4C4F43414C5F4D414348494E4500000000FF
              FFFFFFFFFFFFFF00000000000000000A484B45595F555345525300000000FFFF
              FFFFFFFFFFFF000000000000000013484B45595F43555252454E545F434F4E46
              4947}
            ReadOnly = True
            RowSelect = True
            ParentFont = False
            SmallImages = ImageList1
            TabOrder = 1
            ViewStyle = vsReport
            OnDblClick = RegViewDblClick
          end
          object Button27: TButton
            Left = 72
            Top = 0
            Width = 65
            Height = 22
            Caption = 'Del Value'
            TabOrder = 2
            OnClick = Button27Click
          end
          object Button28: TButton
            Left = 0
            Top = 0
            Width = 65
            Height = 22
            Caption = 'Del Key'
            TabOrder = 3
            OnClick = Button28Click
          end
          object Button29: TButton
            Left = 0
            Top = 24
            Width = 65
            Height = 22
            Caption = 'Set Value'
            TabOrder = 4
            OnClick = Button29Click
          end
          object Edit15: TEdit
            Left = 184
            Top = 24
            Width = 105
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
            TabOrder = 5
          end
          object Button33: TButton
            Left = 224
            Top = 0
            Width = 65
            Height = 22
            Anchors = [akTop, akRight]
            Caption = 'Refresh'
            TabOrder = 6
            OnClick = Button33Click
          end
          object Edit16: TEdit
            Left = 72
            Top = 24
            Width = 105
            Height = 21
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
            TabOrder = 7
          end
        end
        object TabSheet6: TTabSheet
          Caption = 'Process'
          ImageIndex = 1
          DesignSize = (
            289
            185)
          object ListView3: TListView
            Left = 88
            Top = 0
            Width = 201
            Height = 184
            Anchors = [akLeft, akTop, akRight, akBottom]
            Color = 16703168
            Columns = <
              item
                Caption = 'PID'
                Width = 60
              end
              item
                Caption = 'Exename'
                Width = 121
              end>
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            ViewStyle = vsReport
          end
          object Button13: TButton
            Left = 0
            Top = 0
            Width = 81
            Height = 22
            Caption = 'Refresh'
            TabOrder = 1
            OnClick = Button13Click
          end
          object Button14: TButton
            Left = 0
            Top = 32
            Width = 81
            Height = 22
            Caption = 'Kill'
            TabOrder = 2
            OnClick = Button14Click
          end
        end
        object TabSheet7: TTabSheet
          Caption = 'Window'
          ImageIndex = 2
          DesignSize = (
            289
            185)
          object ListView4: TListView
            Left = 88
            Top = 24
            Width = 201
            Height = 160
            Anchors = [akLeft, akTop, akRight, akBottom]
            Color = 16703168
            Columns = <
              item
                Caption = 'Handle'
                Width = 70
              end
              item
                Caption = 'Caption'
                Width = 111
              end>
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
          end
          object Button15: TButton
            Left = 0
            Top = 0
            Width = 81
            Height = 22
            Caption = 'Chg Caption'
            TabOrder = 1
            OnClick = Button15Click
          end
          object Button16: TButton
            Left = 0
            Top = 64
            Width = 81
            Height = 22
            Caption = 'Hide'
            TabOrder = 2
            OnClick = Button16Click
          end
          object Button17: TButton
            Left = 0
            Top = 96
            Width = 81
            Height = 22
            Caption = 'Show'
            TabOrder = 3
            OnClick = Button17Click
          end
          object Button18: TButton
            Left = 0
            Top = 128
            Width = 81
            Height = 22
            Caption = 'Close'
            TabOrder = 4
            Visible = False
            OnClick = Button18Click
          end
          object Edit19: TEdit
            Left = 88
            Top = 0
            Width = 201
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            MaxLength = 40
            ParentFont = False
            TabOrder = 5
            Text = 'This window is overtaken.'
          end
          object Button3: TButton
            Left = 0
            Top = 32
            Width = 81
            Height = 22
            Caption = 'Refresh'
            TabOrder = 6
            OnClick = Button3Click
          end
        end
        object TabSheet14: TTabSheet
          Caption = 'Screen'
          ImageIndex = 3
          DesignSize = (
            289
            185)
          object Image1: TImage
            Left = 72
            Top = 16
            Width = 217
            Height = 168
            Anchors = [akLeft, akTop, akRight, akBottom]
            Stretch = True
          end
          object Label18: TLabel
            Left = 0
            Top = 128
            Width = 65
            Height = 17
            AutoSize = False
            Caption = 'Quality :'
          end
          object Label24: TLabel
            Left = 48
            Top = 144
            Width = 20
            Height = 17
            AutoSize = False
            Caption = '0-9'
            Layout = tlCenter
          end
          object Label25: TLabel
            Left = 72
            Top = 0
            Width = 217
            Height = 17
            Alignment = taCenter
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = '( If nothing happen, click again )'
            Transparent = True
          end
          object Button24: TButton
            Left = 0
            Top = 104
            Width = 65
            Height = 22
            Caption = 'Single Pic'
            TabOrder = 0
            OnClick = Button24Click
          end
          object Button25: TButton
            Left = 0
            Top = 40
            Width = 65
            Height = 22
            Caption = 'Start'
            TabOrder = 1
            OnClick = Button25Click
          end
          object Button26: TButton
            Left = 0
            Top = 72
            Width = 65
            Height = 22
            Caption = 'Stop'
            TabOrder = 2
            OnClick = Button26Click
          end
          object Edit21: TEdit
            Left = 0
            Top = 144
            Width = 41
            Height = 19
            Color = 16703168
            Ctl3D = False
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            ParentCtl3D = False
            ParentFont = False
            TabOrder = 3
            Text = '5'
          end
          object CheckBox1: TCheckBox
            Left = 0
            Top = 168
            Width = 71
            Height = 17
            Caption = 'Save pic'
            TabOrder = 4
            OnMouseUp = CheckBox1MouseUp
          end
          object RadioButton5: TRadioButton
            Left = 0
            Top = 16
            Width = 65
            Height = 17
            Caption = 'Screen'
            Checked = True
            TabOrder = 5
            TabStop = True
          end
          object RadioButton6: TRadioButton
            Left = 0
            Top = 0
            Width = 70
            Height = 17
            Caption = 'Webcam'
            TabOrder = 6
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Transfers'
      ImageIndex = 1
      DesignSize = (
        297
        217)
      object ListView2: TListView
        Left = 0
        Top = 0
        Width = 297
        Height = 184
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = 16703168
        Columns = <
          item
            Caption = 'IP'
            Width = 70
          end
          item
            Caption = 'Filename'
            Width = 70
          end
          item
            Caption = 'Done'
            Width = 45
          end
          item
            Caption = 'Bytes Sent'
            Width = 74
          end
          item
            Caption = 'U/D'
            Width = 34
          end>
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
      end
      object Button5: TButton
        Left = 176
        Top = 191
        Width = 113
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Cancel Transfer'
        TabOrder = 1
        OnClick = Button5Click
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Information'
      DesignSize = (
        297
        217)
      object PageControl4: TPageControl
        Left = 0
        Top = 0
        Width = 297
        Height = 216
        ActivePage = TabSheet11
        Anchors = [akLeft, akTop, akRight, akBottom]
        Style = tsButtons
        TabIndex = 0
        TabOrder = 0
        object TabSheet11: TTabSheet
          Caption = 'Information'
          DesignSize = (
            289
            185)
          object ListView1: TListView
            Left = 72
            Top = 0
            Width = 217
            Height = 184
            Anchors = [akLeft, akTop, akRight, akBottom]
            Color = 16703168
            Columns = <
              item
                Caption = 'Name'
                Width = 80
              end
              item
                Caption = 'Value'
                Width = 117
              end>
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
          end
          object Button4: TButton
            Left = 0
            Top = 40
            Width = 65
            Height = 22
            Caption = 'Server'
            TabOrder = 1
            OnClick = Button4Click
          end
          object Button1: TButton
            Left = 0
            Top = 8
            Width = 65
            Height = 22
            Caption = 'Grab Info'
            TabOrder = 2
            OnClick = Button1Click
          end
        end
        object TabSheet12: TTabSheet
          Caption = 'Registry Editor'
          ImageIndex = 1
          DesignSize = (
            289
            185)
          object Label8: TLabel
            Left = 0
            Top = 0
            Width = 289
            Height = 25
            Alignment = taCenter
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 
              'To grab this coded information, goto "information" and press "Gr' +
              'ab Info"'
            WordWrap = True
          end
          object RichEdit2: TRichEdit
            Left = 0
            Top = 32
            Width = 289
            Height = 152
            Anchors = [akLeft, akTop, akRight, akBottom]
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Georgia'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 0
            OnChange = RichEdit2Change
            OnKeyPress = RichEdit2KeyPress
          end
        end
        object TabSheet13: TTabSheet
          Caption = 'Bat Editor'
          ImageIndex = 2
          DesignSize = (
            289
            185)
          object Label17: TLabel
            Left = 0
            Top = 0
            Width = 56
            Height = 17
            AutoSize = False
            Caption = 'Save As :'
            Layout = tlBottom
          end
          object RichEdit1: TRichEdit
            Left = 0
            Top = 32
            Width = 289
            Height = 152
            Anchors = [akLeft, akTop, akRight, akBottom]
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Georgia'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 0
            OnKeyPress = RichEdit1KeyPress
          end
          object Button2: TButton
            Left = 184
            Top = 0
            Width = 105
            Height = 22
            Anchors = [akTop, akRight]
            Caption = 'Send && Run'
            TabOrder = 1
            OnClick = Button2Click
          end
          object Edit20: TEdit
            Left = 64
            Top = 0
            Width = 113
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            Text = 'C:\MyBat.Bat'
          end
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Config Serv'
      ImageIndex = 3
      DesignSize = (
        297
        217)
      object PageControl3: TPageControl
        Left = 0
        Top = 0
        Width = 297
        Height = 216
        ActivePage = TabSheet8
        Anchors = [akLeft, akTop, akRight, akBottom]
        Style = tsButtons
        TabIndex = 0
        TabOrder = 0
        object TabSheet8: TTabSheet
          Caption = 'Settings'
          object Label1: TLabel
            Left = 8
            Top = 8
            Width = 89
            Height = 17
            AutoSize = False
            Caption = 'Traffic Port :'
          end
          object Label2: TLabel
            Left = 8
            Top = 32
            Width = 89
            Height = 17
            AutoSize = False
            Caption = 'Transfer Port :'
          end
          object Label3: TLabel
            Left = 8
            Top = 56
            Width = 97
            Height = 17
            AutoSize = False
            Caption = 'Autostart :'
          end
          object Label6: TLabel
            Left = 104
            Top = 8
            Width = 89
            Height = 17
            AutoSize = False
            Caption = '(Default 2864)'
          end
          object Label7: TLabel
            Left = 104
            Top = 32
            Width = 89
            Height = 17
            AutoSize = False
            Caption = '(Default 2865)'
          end
          object Edit1: TEdit
            Left = 200
            Top = 8
            Width = 89
            Height = 21
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            MaxLength = 5
            ParentFont = False
            TabOrder = 0
            Text = '2864'
          end
          object Edit2: TEdit
            Left = 200
            Top = 32
            Width = 89
            Height = 21
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            MaxLength = 5
            ParentFont = False
            TabOrder = 1
            Text = '2865'
          end
          object RadioButton1: TRadioButton
            Left = 8
            Top = 120
            Width = 81
            Height = 17
            Caption = 'System.ini'
            TabOrder = 2
          end
          object RadioButton2: TRadioButton
            Left = 8
            Top = 96
            Width = 57
            Height = 17
            Caption = 'Win.ini'
            TabOrder = 3
          end
          object RadioButton3: TRadioButton
            Left = 8
            Top = 72
            Width = 65
            Height = 17
            Caption = 'Regedit'
            TabOrder = 4
          end
          object Edit3: TEdit
            Left = 136
            Top = 72
            Width = 65
            Height = 21
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            MaxLength = 40
            ParentFont = False
            TabOrder = 5
            Text = 'Key'
          end
          object Edit4: TEdit
            Left = 208
            Top = 72
            Width = 81
            Height = 21
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            MaxLength = 40
            ParentFont = False
            TabOrder = 6
            Text = 'Value'
          end
          object Edit5: TEdit
            Left = 136
            Top = 96
            Width = 153
            Height = 21
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            MaxLength = 40
            ParentFont = False
            TabOrder = 7
            Text = 'Exename'
          end
          object Edit6: TEdit
            Left = 136
            Top = 120
            Width = 153
            Height = 21
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            MaxLength = 40
            ParentFont = False
            TabOrder = 8
            Text = 'Exename'
          end
          object Button19: TButton
            Left = 200
            Top = 160
            Width = 89
            Height = 22
            Caption = 'Save Settings'
            TabOrder = 9
            OnClick = Button19Click
          end
          object Button20: TButton
            Left = 104
            Top = 160
            Width = 89
            Height = 22
            Caption = 'Read Settings'
            TabOrder = 10
            OnClick = Button20Click
          end
          object RadioButton4: TRadioButton
            Left = 8
            Top = 144
            Width = 81
            Height = 17
            Caption = 'None'
            Checked = True
            TabOrder = 11
            TabStop = True
          end
        end
        object TabSheet9: TTabSheet
          Caption = 'IRCBot'
          ImageIndex = 1
          object GroupBox1: TGroupBox
            Left = 0
            Top = 16
            Width = 289
            Height = 129
            Caption = 'IRC-Bot'
            TabOrder = 0
            object Label4: TLabel
              Left = 16
              Top = 24
              Width = 65
              Height = 17
              AutoSize = False
              Caption = 'IRC Nick :'
            end
            object Label5: TLabel
              Left = 16
              Top = 48
              Width = 89
              Height = 17
              AutoSize = False
              Caption = 'IRC Channel :'
            end
            object Label9: TLabel
              Left = 16
              Top = 72
              Width = 89
              Height = 17
              AutoSize = False
              Caption = 'IRC Server :'
            end
            object Label10: TLabel
              Left = 16
              Top = 96
              Width = 113
              Height = 17
              AutoSize = False
              Caption = 'IRC Channel Key :'
            end
            object Label11: TLabel
              Left = 128
              Top = 8
              Width = 145
              Height = 17
              AutoSize = False
              Caption = '(First)           (Backup)'
            end
            object Edit7: TEdit
              Left = 208
              Top = 24
              Width = 73
              Height = 21
              Color = 16703168
              Font.Charset = ANSI_CHARSET
              Font.Color = 5066067
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
              MaxLength = 40
              ParentFont = False
              TabOrder = 0
            end
            object Edit8: TEdit
              Left = 128
              Top = 24
              Width = 73
              Height = 21
              Color = 16703168
              Font.Charset = ANSI_CHARSET
              Font.Color = 5066067
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
              MaxLength = 40
              ParentFont = False
              TabOrder = 1
            end
            object Edit9: TEdit
              Left = 128
              Top = 48
              Width = 73
              Height = 21
              Color = 16703168
              Font.Charset = ANSI_CHARSET
              Font.Color = 5066067
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
              MaxLength = 40
              ParentFont = False
              TabOrder = 2
            end
            object Edit10: TEdit
              Left = 208
              Top = 48
              Width = 73
              Height = 21
              Color = 16703168
              Font.Charset = ANSI_CHARSET
              Font.Color = 5066067
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
              MaxLength = 40
              ParentFont = False
              TabOrder = 3
            end
            object Edit11: TEdit
              Left = 128
              Top = 72
              Width = 73
              Height = 21
              Color = 16703168
              Font.Charset = ANSI_CHARSET
              Font.Color = 5066067
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
              MaxLength = 40
              ParentFont = False
              TabOrder = 4
            end
            object Edit12: TEdit
              Left = 208
              Top = 72
              Width = 73
              Height = 21
              Color = 16703168
              Font.Charset = ANSI_CHARSET
              Font.Color = 5066067
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
              MaxLength = 40
              ParentFont = False
              TabOrder = 5
            end
            object Edit13: TEdit
              Left = 128
              Top = 96
              Width = 73
              Height = 21
              Color = 16703168
              Font.Charset = ANSI_CHARSET
              Font.Color = 5066067
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
              MaxLength = 40
              ParentFont = False
              TabOrder = 6
            end
            object Edit14: TEdit
              Left = 208
              Top = 96
              Width = 73
              Height = 21
              Color = 16703168
              Font.Charset = ANSI_CHARSET
              Font.Color = 5066067
              Font.Height = -11
              Font.Name = 'Verdana'
              Font.Style = []
              MaxLength = 40
              ParentFont = False
              TabOrder = 7
            end
          end
          object Button21: TButton
            Left = 192
            Top = 160
            Width = 89
            Height = 22
            Caption = 'Save Settings'
            TabOrder = 1
            OnClick = Button21Click
          end
          object Button22: TButton
            Left = 96
            Top = 160
            Width = 89
            Height = 22
            Caption = 'Read Settings'
            TabOrder = 2
            OnClick = Button22Click
          end
        end
        object TabSheet10: TTabSheet
          Caption = 'Pass'
          ImageIndex = 2
          object Label12: TLabel
            Left = 16
            Top = 16
            Width = 105
            Height = 17
            AutoSize = False
            Caption = 'Server Password'
          end
          object Label13: TLabel
            Left = 16
            Top = 64
            Width = 169
            Height = 17
            AutoSize = False
            Caption = 'New Server Password'
          end
          object Label14: TLabel
            Left = 152
            Top = 32
            Width = 137
            Height = 17
            Alignment = taCenter
            AutoSize = False
            Caption = '(Maxlength is 20 chars)'
          end
          object Label15: TLabel
            Left = 152
            Top = 80
            Width = 137
            Height = 17
            Alignment = taCenter
            AutoSize = False
            Caption = '(Maxlength is 20 chars)'
          end
          object Edit17: TEdit
            Left = 24
            Top = 32
            Width = 121
            Height = 21
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            MaxLength = 20
            ParentFont = False
            PasswordChar = '*'
            TabOrder = 0
          end
          object Edit18: TEdit
            Left = 24
            Top = 80
            Width = 121
            Height = 21
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            MaxLength = 20
            ParentFont = False
            PasswordChar = '*'
            TabOrder = 1
          end
          object Button23: TButton
            Left = 104
            Top = 152
            Width = 81
            Height = 22
            Caption = 'Save'
            TabOrder = 2
            OnClick = Button23Click
          end
        end
        object TabSheet16: TTabSheet
          Caption = 'Notify'
          ImageIndex = 3
          object Label20: TLabel
            Left = 16
            Top = 8
            Width = 89
            Height = 17
            AutoSize = False
            Caption = 'URL to CGI :'
          end
          object Label21: TLabel
            Left = 16
            Top = 96
            Width = 89
            Height = 17
            AutoSize = False
            Caption = 'URL to PHP :'
          end
          object Edit23: TEdit
            Left = 32
            Top = 24
            Width = 225
            Height = 21
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object Button30: TButton
            Left = 104
            Top = 64
            Width = 81
            Height = 22
            Caption = 'Set'
            TabOrder = 1
            OnClick = Button30Click
          end
          object Edit24: TEdit
            Left = 32
            Top = 112
            Width = 225
            Height = 21
            Color = 16703168
            Font.Charset = ANSI_CHARSET
            Font.Color = 5066067
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
          object Button31: TButton
            Left = 104
            Top = 152
            Width = 81
            Height = 22
            Caption = 'Set'
            TabOrder = 3
            OnClick = Button31Click
          end
        end
        object TabSheet17: TTabSheet
          Caption = 'Remove'
          ImageIndex = 4
          object Label23: TLabel
            Left = 8
            Top = 8
            Width = 273
            Height = 65
            Alignment = taCenter
            AutoSize = False
            Caption = 
              'Are you sure that you want to remove this server ? If so, click ' +
              'the Remove button and the server will remove itself from all sta' +
              'rtup optoins and its own exefile.'
            WordWrap = True
          end
          object Button32: TButton
            Left = 96
            Top = 80
            Width = 97
            Height = 22
            Caption = 'Remove'
            TabOrder = 0
            OnClick = Button32Click
          end
        end
      end
    end
  end
  object Panel1: TPanel
    Left = -304
    Top = 8
    Width = 305
    Height = 241
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    DesignSize = (
      305
      241)
    object Label22: TLabel
      Left = 40
      Top = 64
      Width = 225
      Height = 41
      Alignment = taCenter
      Anchors = [akLeft, akRight, akBottom]
      AutoSize = False
      Caption = 
        'This server is password protected. Please insert correct passwor' +
        'd or disconnect now.'
      WordWrap = True
    end
    object Edit25: TEdit
      Left = 72
      Top = 112
      Width = 161
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      Color = 6118749
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      MaxLength = 20
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 0
      Visible = False
      OnKeyDown = Edit25KeyDown
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 248
    Width = 305
    Height = 17
    Panels = <
      item
        Text = '127.0.0.1'
        Width = 90
      end
      item
        Text = '12345'
        Width = 40
      end
      item
        Text = 'Transfer 0 Byte'
        Width = 130
      end
      item
        Text = '100%'
        Width = 50
      end>
    SimplePanel = False
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 176
    Top = 240
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 272
    Top = 240
  end
  object Timer2: TTimer
    Interval = 500
    OnTimer = Timer2Timer
    Left = 144
    Top = 240
  end
  object Timer3: TTimer
    Interval = 100
    OnTimer = Timer3Timer
    Left = 208
    Top = 240
  end
  object ImageList1: TImageList
    Left = 240
    Top = 240
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000052
      84000052840073846B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006BD6C6000063
      9C00008CB50000739C0018637B000052840073846B0000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006BD6C600007B
      B5001084B500108CB500108CB500088CB500007BAD00106B9400000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004AFFFF000894
      C6001094BD00188CB500188CB5002194BD002994C600299CC600000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000008F7FF0052FF
      FF0039ADEF00318CC600298CC6003194C6003194C6003194C600006BA5000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000021F7FF004AEF
      FF0052EFFF005AF7FF005AF7FF0052DEFF0063ADEF005A94D6004294CE000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0031F7
      FF004AEFFF0029E7FF0021E7FF0039DEFF004AE7FF0031E7FF00000000009CAD
      AD00000000000000000000000000000000000000000000000000FFFFFF00C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000010D6FF0010D6FF00000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C60000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFFFFF00000000
      FFFF800700000000FFFF800700000000E7FF800700000000E0FF800700000000
      C03F800700000000C01F800700000000C01F800700000000C00F800700000000
      C00F800700000000C00F800700000000FF3F800700000000FFFF800F00000000
      FFFF801F00000000FFFF803F0000000000000000000000000000000000000000
      000000000000}
  end
  object PopupMenu1: TPopupMenu
    Left = 80
    Top = 240
    object Quality1: TMenuItem
      Caption = 'Quality'
      object N11: TMenuItem
        Caption = '1'
      end
      object N21: TMenuItem
        Caption = '2'
      end
      object N31: TMenuItem
        Caption = '3'
      end
      object N41: TMenuItem
        Caption = '4'
      end
      object N51: TMenuItem
        Caption = '5'
      end
      object N61: TMenuItem
        Caption = '6'
      end
      object N71: TMenuItem
        Caption = '7'
      end
      object N81: TMenuItem
        Caption = '8'
      end
      object N91: TMenuItem
        Caption = '9'
      end
      object N101: TMenuItem
        Caption = '10'
      end
    end
    object SaveImage1: TMenuItem
      Caption = 'Save Image'
      object Browse1: TMenuItem
        Caption = 'Browse...'
      end
      object none1: TMenuItem
        Caption = '<none>'
      end
      object DontSave1: TMenuItem
        Caption = 'Dont Save'
      end
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 112
    Top = 240
    object MenuItem1: TMenuItem
      Caption = 'Quality'
      object MenuItem2: TMenuItem
        Caption = '1'
      end
      object MenuItem3: TMenuItem
        Caption = '2'
      end
      object MenuItem4: TMenuItem
        Caption = '3'
      end
      object MenuItem5: TMenuItem
        Caption = '4'
      end
      object MenuItem6: TMenuItem
        Caption = '5'
      end
      object MenuItem7: TMenuItem
        Caption = '6'
      end
      object MenuItem8: TMenuItem
        Caption = '7'
      end
      object MenuItem9: TMenuItem
        Caption = '8'
      end
      object MenuItem10: TMenuItem
        Caption = '9'
      end
      object MenuItem11: TMenuItem
        Caption = '10'
      end
    end
    object MenuItem12: TMenuItem
      Caption = 'Save Image'
      object MenuItem13: TMenuItem
        Caption = 'Browse...'
      end
      object MenuItem14: TMenuItem
        Caption = '<none>'
      end
      object MenuItem15: TMenuItem
        Caption = 'Dont Save'
      end
    end
  end
  object Timer4: TTimer
    Interval = 1
    OnTimer = Timer4Timer
    Left = 48
    Top = 240
  end
  object timer_screen: TTimer
    Enabled = False
    Interval = 4000
    OnTimer = timer_screenTimer
    Left = 16
    Top = 240
  end
  object ImageList2: TImageList
    Left = 272
    Top = 208
    Bitmap = {
      494C010101000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000084848400000000000000000000000000000000008484
      840000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000848484008484840000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000848484008484840000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00000084000000840000008400FFFFFF000000840000008400FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF0000008400FFFFFF0000008400FFFFFF00000084000000FF0000008400FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF000000FF000000FF0000008400FFFFFF0000008400FFFFFF0000008400FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00000084000000840000008400FFFFFF00000084000000840000008400FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000008400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084848400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FFFF000000000000
      FFF9000000000000E1E100000000000000010000000000000001000000000000
      0001000000000000000100000000000000010000000000000001000000000000
      0001000000000000000100000000000000010000000000000001000000000000
      0003000000000000000700000000000000000000000000000000000000000000
      000000000000}
  end
end
