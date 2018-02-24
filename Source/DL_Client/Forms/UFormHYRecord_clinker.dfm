object fFormHYRecord_clinker: TfFormHYRecord_clinker
  Left = 330
  Top = 77
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 460
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 488
    Height = 460
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    AutoControlTabOrders = False
    LookAndFeel = FDM.dxLayoutWeb1
    object BtnOK: TButton
      Left = 332
      Top = 426
      Width = 70
      Height = 23
      Caption = #20445#23384
      TabOrder = 0
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 407
      Top = 426
      Width = 70
      Height = 23
      Caption = #21462#28040
      TabOrder = 1
      OnClick = BtnExitClick
    end
    object EditID: TcxButtonEdit
      Left = 93
      Top = 36
      Hint = 'E.R_SerialNo'
      HelpType = htKeyword
      HelpKeyword = 'NU'
      ParentFont = False
      Properties.Buttons = <
        item
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 15
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 2
      Width = 121
    end
    object wPanel: TPanel
      Left = 23
      Top = 243
      Width = 424
      Height = 240
      Align = alClient
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 4
      object Bevel2: TBevel
        Left = 1
        Top = 230
        Width = 438
        Height = 7
        Shape = bsBottomLine
      end
      object cxLabel1: TcxLabel
        Left = 0
        Top = 0
        Caption = 'f-CaO'
        ParentFont = False
      end
      object cxLabel2: TcxLabel
        Left = 0
        Top = 24
        Caption = 'MgO'
        ParentFont = False
      end
      object cxLabel3: TcxLabel
        Left = 0
        Top = 72
        Caption = #28903#22833#37327
        ParentFont = False
      end
      object cxLabel4: TcxLabel
        Left = 0
        Top = 96
        Caption = #19981#28342#29289
        ParentFont = False
      end
      object cxLabel5: TcxLabel
        Left = 0
        Top = 120
        Caption = 'CaO/SiO2'
        ParentFont = False
      end
      object cxLabel6: TcxLabel
        Left = 0
        Top = 144
        Caption = '3CaO'#183'SiO2+2CaO'#183'SiO2'
        ParentFont = False
      end
      object cxLabel7: TcxLabel
        Left = 224
        Top = 0
        Caption = '3'#22825#25239#21387#24378#24230#65288'MPa'#65289
        ParentFont = False
      end
      object cxLabel8: TcxLabel
        Left = 224
        Top = 48
        Caption = #21021#20957#26102#38388#65288'min'#65289'3D'
        ParentFont = False
      end
      object cxLabel9: TcxLabel
        Left = 224
        Top = 72
        Caption = #32456#20957#26102#38388#65288'min'#65289'28D'
        ParentFont = False
      end
      object cxLabel10: TcxLabel
        Left = 224
        Top = 96
        Caption = #23433#23450#24615
        ParentFont = False
      end
      object cxLabel11: TcxLabel
        Left = 0
        Top = 48
        Caption = 'SO3'
        ParentFont = False
      end
      object cxLabel12: TcxLabel
        Left = 224
        Top = 24
        Caption = '28'#25239#21387#24378#24230#65288'MPa'#65289
        ParentFont = False
      end
      object cxTextEdit2: TcxTextEdit
        Left = 56
        Top = 0
        Hint = 'E.R_Fcao'
        ParentFont = False
        TabOrder = 12
        Width = 121
      end
      object cxTextEdit3: TcxTextEdit
        Left = 56
        Top = 24
        Hint = 'E.R_Mgo'
        ParentFont = False
        TabOrder = 13
        Width = 121
      end
      object cxTextEdit4: TcxTextEdit
        Left = 56
        Top = 48
        Hint = 'E.R_So3'
        ParentFont = False
        TabOrder = 14
        Width = 121
      end
      object cxTextEdit5: TcxTextEdit
        Left = 56
        Top = 72
        Hint = 'E.R_ShaoShi'
        ParentFont = False
        TabOrder = 15
        Width = 121
      end
      object cxTextEdit6: TcxTextEdit
        Left = 56
        Top = 96
        Hint = 'E.R_BuRong'
        ParentFont = False
        TabOrder = 16
        Width = 121
      end
      object cxTextEdit7: TcxTextEdit
        Left = 56
        Top = 120
        Hint = 'E.R_Alkalinity'
        ParentFont = False
        TabOrder = 17
        Width = 121
      end
      object cxTextEdit8: TcxTextEdit
        Left = 144
        Top = 144
        Hint = 'E.R_C3S_C2S'
        ParentFont = False
        TabOrder = 18
        Width = 289
      end
      object cxTextEdit9: TcxTextEdit
        Left = 336
        Top = 0
        Hint = 'E.R_3DYa1'
        ParentFont = False
        TabOrder = 19
        Width = 97
      end
      object cxTextEdit10: TcxTextEdit
        Left = 336
        Top = 24
        Hint = 'E.R_28Ya1'
        ParentFont = False
        TabOrder = 20
        Width = 97
      end
      object cxTextEdit11: TcxTextEdit
        Left = 336
        Top = 48
        Hint = 'E.R_3DChuNing'
        ParentFont = False
        TabOrder = 21
        Width = 97
      end
      object cxTextEdit12: TcxTextEdit
        Left = 336
        Top = 72
        Hint = 'E.R_28DZhongNing'
        ParentFont = False
        TabOrder = 22
        Width = 97
      end
      object cxComboBox1: TcxComboBox
        Left = 272
        Top = 96
        Hint = 'E.R_AnDing'
        ParentFont = False
        Properties.Items.Strings = (
          #21512#26684
          #19981#21512#26684)
        TabOrder = 23
        Text = 'cxComboBox1'
        Width = 161
      end
    end
    object EditDate: TcxDateEdit
      Left = 93
      Top = 86
      Hint = 'E.R_Date'
      ParentFont = False
      Properties.Kind = ckDateTime
      TabOrder = 5
      Width = 200
    end
    object EditMan: TcxTextEdit
      Left = 344
      Top = 86
      Hint = 'E.R_Man'
      ParentFont = False
      TabOrder = 6
      Width = 120
    end
    object EditQuaStart: TcxTextEdit
      Left = 93
      Top = 111
      Hint = 'E.R_BatQuaStart'
      ParentFont = False
      TabOrder = 7
      Width = 121
    end
    object cxComboBox2: TcxComboBox
      Left = 93
      Top = 161
      Hint = 'E.R_BatValid'
      ParentFont = False
      Properties.Items.Strings = (
        'Y'
        'N')
      TabOrder = 9
      Text = 'Y'
      Width = 121
    end
    object EditStock: TcxComboBox
      Left = 93
      Top = 61
      Hint = 'E.R_PID'
      ParentFont = False
      Properties.OnChange = EditStockPropertiesEditValueChanged
      TabOrder = 3
      Width = 200
    end
    object EditQuaEnd: TcxTextEdit
      Left = 93
      Top = 136
      Hint = 'E.R_BatQuaEnd'
      ParentFont = False
      TabOrder = 8
      Width = 121
    end
    object cbxCenterID: TcxComboBox
      Left = 344
      Top = 61
      Hint = 'E.R_CenterID'
      ParentFont = False
      TabOrder = 10
      Width = 120
    end
    object cxTextEdit1: TcxTextEdit
      Left = 93
      Top = 186
      Hint = 'E.R_Clinkertype'
      ParentFont = False
      TabOrder = 11
      Width = 121
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        Caption = #22522#26412#20449#24687
        object dxLayoutControl1Item1: TdxLayoutItem
          Caption = #20986#21378#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item7: TdxLayoutItem
            Caption = #25152#23646#21697#31181':'
            Control = EditStock
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item9: TdxLayoutItem
            Caption = #29983#20135#32447':'
            Control = cbxCenterID
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item2: TdxLayoutItem
            Caption = #20986#21378#26085#26399':'
            Control = EditDate
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item3: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #24405#20837#20154':'
            Control = EditMan
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Item5: TdxLayoutItem
          Caption = #25209#27425#37327'('#21544'):'
          Control = EditQuaStart
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item8: TdxLayoutItem
          Caption = #39044#35686#37327'('#21544'):'
          Control = EditQuaEnd
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item6: TdxLayoutItem
          Caption = #26159#21542#29983#25928':'
          Control = cxComboBox2
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item12: TdxLayoutItem
          Caption = #29087#26009#31181#31867
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group2: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #26816#39564#25968#25454
        object dxLayoutControl1Item4: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'Panel1'
          ShowCaption = False
          Control = wPanel
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group5: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        ShowCaption = False
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Item10: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button3'
          ShowCaption = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item11: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button4'
          ShowCaption = False
          Control = BtnExit
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
