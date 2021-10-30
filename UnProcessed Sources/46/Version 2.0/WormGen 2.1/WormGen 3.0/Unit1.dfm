object Form1: TForm1
  Left = 192
  Top = 107
  Width = 313
  Height = 294
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'p0ke'#39's WormGen 3.01'
  Color = clBtnFace
  TransparentColorValue = clFuchsia
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnConstrainedResize = FormConstrainedResize
  OnCreate = FormCreate
  DesignSize = (
    305
    267)
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 242
    Width = 305
    Height = 17
    Align = alNone
    Anchors = [akLeft, akRight, akBottom]
    Panels = <
      item
        Text = 'DPR Size : ~0.000 kb'
        Width = 150
      end
      item
        Text = 'Generating : 0%'
        Width = 50
      end>
    SimplePanel = False
  end
  object ProgressBar1: TProgressBar
    Left = 96
    Top = 225
    Width = 150
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Min = 0
    Max = 100
    Smooth = True
    TabOrder = 1
  end
  object Button1: TButton
    Left = 248
    Top = 225
    Width = 57
    Height = 17
    Anchors = [akRight, akBottom]
    Caption = '&Build'
    TabOrder = 2
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 177
    Width = 305
    Height = 41
    Anchors = [akLeft, akRight, akBottom]
    Caption = '&Settings'
    TabOrder = 3
    DesignSize = (
      305
      41)
    object CheckBox2: TCheckBox
      Left = 8
      Top = 16
      Width = 145
      Height = 17
      Caption = '&Remove found comments'
      TabOrder = 0
    end
    object Button7: TButton
      Left = 152
      Top = 16
      Width = 145
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Check for wormgen-update'
      TabOrder = 1
      OnClick = Button7Click
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 305
    Height = 177
    ActivePage = TabSheet2
    Anchors = [akLeft, akTop, akRight, akBottom]
    Style = tsButtons
    TabIndex = 1
    TabOrder = 4
    object TabSheet1: TTabSheet
      Caption = 'Features'
      DesignSize = (
        297
        146)
      object Label1: TLabel
        Left = 0
        Top = 128
        Width = 297
        Height = 17
        Alignment = taCenter
        Anchors = [akLeft, akRight, akBottom]
        AutoSize = False
        Caption = 'Note : Contact the author if source is not working.'
      end
      object ListView3: TListView
        Left = 0
        Top = 0
        Width = 297
        Height = 129
        Anchors = [akLeft, akTop, akRight, akBottom]
        Checkboxes = True
        Columns = <
          item
            Caption = 'Filename'
            Width = 80
          end
          item
            Caption = 'Description'
            Width = 90
          end
          item
            Caption = 'Author'
            Width = 55
          end
          item
            Caption = 'Size'
          end>
        Ctl3D = False
        HotTrack = True
        HoverTime = 90000
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = ListView3DblClick
      end
      object RichEdit1: TRichEdit
        Left = 8
        Top = 24
        Width = 257
        Height = 97
        Lines.Strings = (
          'RichEdit1')
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 1
        Visible = False
        WordWrap = False
      end
    end
    object TabSheet2: TTabSheet
      Caption = #39'Plugins'#39
      ImageIndex = 1
      DesignSize = (
        297
        146)
      object Label6: TLabel
        Left = 0
        Top = 128
        Width = 153
        Height = 17
        Anchors = [akLeft, akRight, akBottom]
        AutoSize = False
        Caption = '0 New '#39'plugins'#39' to download'
      end
      object Button2: TButton
        Left = 232
        Top = 128
        Width = 65
        Height = 17
        Anchors = [akRight, akBottom]
        Caption = '&Update'
        TabOrder = 0
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 160
        Top = 128
        Width = 65
        Height = 17
        Anchors = [akRight, akBottom]
        Caption = '&Download'
        TabOrder = 1
        OnClick = Button3Click
      end
      object Memo5: TMemo
        Left = 40
        Top = 0
        Width = 241
        Height = 65
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 2
        Visible = False
        WordWrap = False
      end
      object Memo6: TMemo
        Left = 0
        Top = 0
        Width = 89
        Height = 65
        Lines.Strings = (
          'Memo6')
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 3
        Visible = False
        WordWrap = False
      end
      object ListView1: TListView
        Left = 0
        Top = 0
        Width = 297
        Height = 121
        Anchors = [akLeft, akTop, akRight, akBottom]
        Checkboxes = True
        Columns = <
          item
            Caption = 'Filename'
            Width = 80
          end
          item
            Caption = 'Description'
            Width = 70
          end
          item
            Caption = 'Author'
            Width = 55
          end
          item
            Caption = 'Size'
          end
          item
            Caption = 'ID'
            Width = 40
          end>
        Ctl3D = False
        HotTrack = True
        HoverTime = 90000
        ReadOnly = True
        RowSelect = True
        SortType = stBoth
        TabOrder = 4
        ViewStyle = vsReport
      end
    end
    object TabSheet4: TTabSheet
      Caption = '&Library'
      ImageIndex = 3
      DesignSize = (
        297
        146)
      object Button4: TButton
        Left = 128
        Top = 128
        Width = 81
        Height = 17
        Anchors = [akRight, akBottom]
        Caption = '&Delete'
        TabOrder = 0
        OnClick = Button4Click
      end
      object Button6: TButton
        Left = 216
        Top = 128
        Width = 81
        Height = 17
        Anchors = [akRight, akBottom]
        Caption = '&Refresh'
        TabOrder = 1
        OnClick = Button6Click
      end
      object ListView2: TListView
        Left = 0
        Top = 0
        Width = 297
        Height = 121
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Filename'
            Width = 80
          end
          item
            Caption = 'Description'
            Width = 90
          end
          item
            Caption = 'Author'
            Width = 55
          end
          item
            Caption = 'Size'
          end>
        Ctl3D = False
        HotTrack = True
        HoverTime = 90000
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 2
        ViewStyle = vsReport
        OnDblClick = ListView2DblClick
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Submit Snippet'
      ImageIndex = 4
      DesignSize = (
        297
        146)
      object Label7: TLabel
        Left = 216
        Top = 0
        Width = 81
        Height = 17
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = 'Made By :'
      end
      object Label8: TLabel
        Left = 216
        Top = 40
        Width = 81
        Height = 17
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = 'Description :'
      end
      object Label13: TLabel
        Left = 216
        Top = 80
        Width = 81
        Height = 17
        Anchors = [akTop, akRight]
        AutoSize = False
        Caption = 'FileName :'
      end
      object PageControl2: TPageControl
        Left = 0
        Top = 0
        Width = 209
        Height = 145
        ActivePage = TabSheet9
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabIndex = 3
        TabOrder = 0
        object TabSheet6: TTabSheet
          Caption = 'Code'
          DesignSize = (
            201
            117)
          object Label2: TLabel
            Left = 0
            Top = 104
            Width = 201
            Height = 17
            Anchors = [akLeft, akRight, akBottom]
            AutoSize = False
            Caption = '0:0 [0 lines;0 chars]'
          end
          object Memo1: TMemo
            Left = 0
            Top = 0
            Width = 201
            Height = 105
            Anchors = [akLeft, akTop, akRight, akBottom]
            TabOrder = 0
            OnChange = Memo1Change
          end
        end
        object TabSheet7: TTabSheet
          Caption = 'Vars'
          ImageIndex = 1
          DesignSize = (
            201
            117)
          object Label3: TLabel
            Left = 0
            Top = 104
            Width = 201
            Height = 17
            Anchors = [akLeft, akRight, akBottom]
            AutoSize = False
            Caption = '0:0 [0 lines;0 chars]'
          end
          object Label12: TLabel
            Left = 0
            Top = 0
            Width = 201
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 'Dont write "Var"'
          end
          object Memo2: TMemo
            Left = 0
            Top = 16
            Width = 201
            Height = 89
            Anchors = [akLeft, akTop, akRight, akBottom]
            TabOrder = 0
            OnChange = Memo2Change
          end
        end
        object TabSheet8: TTabSheet
          Caption = 'Consts'
          ImageIndex = 2
          DesignSize = (
            201
            117)
          object Label4: TLabel
            Left = 0
            Top = 104
            Width = 201
            Height = 13
            Anchors = [akLeft, akRight, akBottom]
            AutoSize = False
            Caption = '0:0 [0 lines;0 chars]'
          end
          object Label11: TLabel
            Left = 0
            Top = 0
            Width = 201
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 'Dont write "Const"'
          end
          object Memo3: TMemo
            Left = 0
            Top = 16
            Width = 201
            Height = 89
            Anchors = [akLeft, akTop, akRight, akBottom]
            TabOrder = 0
            OnChange = Memo3Change
          end
        end
        object TabSheet9: TTabSheet
          Caption = 'Uses'
          ImageIndex = 3
          DesignSize = (
            201
            117)
          object Label9: TLabel
            Left = 0
            Top = 104
            Width = 201
            Height = 13
            Anchors = [akLeft, akRight, akBottom]
            AutoSize = False
            Caption = '0:0 [0 lines;0 chars]'
          end
          object Label10: TLabel
            Left = 0
            Top = 0
            Width = 201
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 'Dont write "Uses"'
          end
          object Memo7: TMemo
            Left = 0
            Top = 16
            Width = 201
            Height = 89
            Anchors = [akLeft, akTop, akRight, akBottom]
            Lines.Strings = (
              'Windows, System;')
            TabOrder = 0
            OnChange = Memo7Change
          end
        end
      end
      object Button5: TButton
        Left = 216
        Top = 128
        Width = 81
        Height = 17
        Anchors = [akRight, akBottom]
        Caption = '&Submit'
        TabOrder = 1
        OnClick = Button5Click
      end
      object Edit1: TEdit
        Left = 216
        Top = 16
        Width = 81
        Height = 19
        Anchors = [akTop, akRight]
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 2
        Text = 'Unknown'
      end
      object Edit2: TEdit
        Left = 216
        Top = 56
        Width = 81
        Height = 19
        Anchors = [akTop, akRight]
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 3
        Text = 'None'
      end
      object Edit4: TEdit
        Left = 216
        Top = 96
        Width = 81
        Height = 19
        Anchors = [akTop, akRight]
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 4
        Text = 'Test'
      end
    end
    object TabSheet3: TTabSheet
      Caption = '&About'
      ImageIndex = 2
      DesignSize = (
        297
        146)
      object Image1: TImage
        Left = 0
        Top = 0
        Width = 65
        Height = 57
        Picture.Data = {
          07544269746D617076020000424D760200000000000076000000280000002000
          0000200000000100040000000000000200000000000000000000100000000000
          0000000000000000800000800000008080008000000080008000808000008080
          8000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
          FF00DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD777777777777777777777DD
          DDDDDD777777777777777777777777777DDDDD77777000007777777000007777
          7DDDDDD7770119990077700111990777DDDDDDDD70119999907770119999907D
          DDDDDDDD01199999907770111999990DDDDDDDDD01199999900000119999990D
          DDDDDDDD01119999900000119999990DDDDDDDDD01199999990001199999990D
          DDDDDDDD01119999990001119999990DDDDDDDDD01199999990001199999990D
          DDDDDD00111999999900011999999990DDDDDD01199999999900011199999999
          0DDDDD011999999999000119999999990DDDDD01119999999900011999999999
          0DDDDD011999901119000119901999990DDDDD01199990019900019900199999
          0DDDDD011199900119999999001199990DDDDD01199990D011999990D0111999
          0DDDDD01199990D011199990D01199990DDDDD01119990D011999990D0119999
          0DDDDD01199990D011999990D01199990DDDDDD0199990D011199990D0111990
          DDDDDDD0119990D011999990D0119990DDDDDDDD099990D011999990D011990D
          DDDDDDDDD00000D011199990DD0000DDDDDDDDDDDDDDDDD011999990DDDDDDDD
          DDDDDDDDDDDDDDDD0000000DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
          DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
          DDDD}
        Stretch = True
        Transparent = True
      end
      object Panel1: TPanel
        Left = 72
        Top = 0
        Width = 225
        Height = 145
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
        DesignSize = (
          225
          145)
        object Label5: TLabel
          Left = 8
          Top = 8
          Width = 209
          Height = 17
          Alignment = taCenter
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'WormGen 3.01'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Memo4: TMemo
          Left = 8
          Top = 24
          Width = 209
          Height = 113
          Anchors = [akLeft, akTop, akRight, akBottom]
          BorderStyle = bsNone
          Color = clBtnFace
          Ctl3D = False
          Lines.Strings = (
            'This was made by p0ke/SiC'
            ''
            'Thanks to following :'
            '-- #swevx'
            '-- #vxers'
            '-- #vxtrader'
            '-- #trinity'
            'Lucifer0000, Read101, NakedCrew, '
            'TzorCelan, Psyphen, ~UE~, n00nah, '
            'Drocon, Da`Great`1, Positron, '
            'Nastradamus,Elf, D-oNe, k0nsl, '
            'MegaSecurity, Astalavista ')
          ParentCtl3D = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
  end
  object Edit3: TEdit
    Left = 0
    Top = 223
    Width = 89
    Height = 19
    Anchors = [akLeft, akBottom]
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 5
    Text = 'my_worm1.dpr'
  end
  object Panel2: TPanel
    Left = 0
    Top = 262
    Width = 305
    Height = 3
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 6
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 232
    Top = 120
  end
  object Timer2: TTimer
    Interval = 200
    OnTimer = Timer2Timer
    Left = 264
    Top = 120
  end
  object PopupMenu1: TPopupMenu
    Left = 200
    Top = 120
    object Edit5: TMenuItem
      Caption = '&Edit'
      object Uses1: TMenuItem
        Caption = '&Uses'
      end
      object Vars1: TMenuItem
        Caption = '&Vars'
      end
      object Consts1: TMenuItem
        Caption = '&Const'
      end
      object Source1: TMenuItem
        Caption = '&Source'
      end
    end
  end
end
