object fFormHYRecord_Slag: TfFormHYRecord_Slag
  Left = 330
  Top = 77
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 529
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
    Height = 529
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    AutoControlTabOrders = False
    LookAndFeel = FDM.dxLayoutWeb1
    object BtnOK: TButton
      Left = 332
      Top = 495
      Width = 70
      Height = 23
      Caption = #20445#23384
      TabOrder = 0
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 407
      Top = 495
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
      object Label41: TLabel
        Left = 1
        Top = 127
        Width = 48
        Height = 12
        Caption = #30707#33167#31181#31867
        Transparent = True
      end
      object Label43: TLabel
        Left = 3
        Top = 154
        Width = 48
        Height = 12
        Caption = #21161#30952#21058#31867
      end
      object cbxSgzl: TcxComboBox
        Left = 63
        Top = 123
        Hint = 'E.R_SGType'
        ParentFont = False
        TabOrder = 0
        Text = #35831#36873#25321
        Width = 162
      end
      object cxTextEdit1: TcxTextEdit
        Left = 80
        Top = -2
        Hint = 'E.R_Density'
        ParentFont = False
        TabOrder = 1
        Width = 145
      end
      object cxLabel1: TcxLabel
        Left = 1
        Top = 0
        Caption = #23494#24230#65288'g/cm3'#65289
        ParentFont = False
      end
      object cxLabel2: TcxLabel
        Left = 1
        Top = 24
        Caption = #27604#34920#38754#31215#65288#13217'/kg'#65289
        ParentFont = False
      end
      object cxTextEdit2: TcxTextEdit
        Left = 104
        Top = 22
        Hint = 'E.R_BiBiao'
        ParentFont = False
        TabOrder = 4
        Width = 121
      end
      object cxTextEdit3: TcxTextEdit
        Left = 104
        Top = 46
        Hint = 'E.R_ActivityIndex_7d'
        ParentFont = False
        TabOrder = 5
        Width = 121
      end
      object cxTextEdit4: TcxTextEdit
        Left = 104
        Top = 70
        Hint = 'E.R_ActivityIndex_28d'
        ParentFont = False
        TabOrder = 6
        Width = 121
      end
      object cxLabel3: TcxLabel
        Left = 1
        Top = 48
        Caption = #27963#24615#25351#25968#65288'%'#65289'7D'
        ParentFont = False
      end
      object cxLabel4: TcxLabel
        Left = 1
        Top = 72
        Caption = #27963#24615#25351#25968#65288'%'#65289'28D'
        ParentFont = False
      end
      object cxLabel5: TcxLabel
        Left = 235
        Top = 24
        Caption = #27969#21160#24230#27604#65288'%'#65289
        ParentFont = False
      end
      object cxLabel6: TcxLabel
        Left = 235
        Top = 48
        Caption = #21547#27700#37327#65288'%'#65289
        ParentFont = False
      end
      object cxLabel7: TcxLabel
        Left = 235
        Top = 72
        Caption = #19977#27687#21270#30827#65288'%'#65289
        ParentFont = False
      end
      object cxTextEdit5: TcxTextEdit
        Left = 312
        Top = 22
        Hint = 'E.R_FluidityRatio'
        ParentFont = False
        TabOrder = 12
        Width = 113
      end
      object cxTextEdit6: TcxTextEdit
        Left = 304
        Top = 46
        Hint = 'E.R_WaterContent'
        ParentFont = False
        TabOrder = 13
        Width = 121
      end
      object cxTextEdit7: TcxTextEdit
        Left = 312
        Top = 70
        Hint = 'E.R_SO3'
        ParentFont = False
        TabOrder = 14
        Width = 113
      end
      object cxTextEdit8: TcxTextEdit
        Left = 64
        Top = 94
        Hint = 'E.R_CL'
        ParentFont = False
        TabOrder = 15
        Width = 161
      end
      object cxTextEdit9: TcxTextEdit
        Left = 304
        Top = 94
        Hint = 'E.R_ShaoShi'
        ParentFont = False
        TabOrder = 16
        Width = 121
      end
      object cxLabel8: TcxLabel
        Left = 1
        Top = 96
        Caption = #27695#31163#23376#65288'%'#65289
        ParentFont = False
      end
      object cxLabel9: TcxLabel
        Left = 235
        Top = 96
        Caption = #28903#22833#37327#65288'%'#65289
        ParentFont = False
      end
      object cxLabel10: TcxLabel
        Left = 235
        Top = 125
        Caption = #30707#33167#25530#20837#37327#65288'%'#65289
        ParentFont = False
      end
      object cxTextEdit10: TcxTextEdit
        Left = 320
        Top = 123
        Hint = 'E.R_SGValue'
        ParentFont = False
        TabOrder = 20
        Width = 105
      end
      object cxLabel11: TcxLabel
        Left = 235
        Top = 149
        Caption = #21161#30952#21058#37327#65288'%'#65289
        ParentFont = False
      end
      object cxTextEdit11: TcxTextEdit
        Left = 320
        Top = 147
        Hint = 'E.R_ZMJVALUE'
        ParentFont = False
        TabOrder = 22
        Width = 105
      end
      object cxLabel12: TcxLabel
        Left = 0
        Top = 184
        Caption = #22791'   '#27880
        ParentFont = False
      end
      object cxMemo1: TcxMemo
        Left = 64
        Top = 176
        Hint = 'E.R_Remark'
        ParentFont = False
        TabOrder = 24
        Height = 57
        Width = 361
      end
      object cxTextEdit12: TcxTextEdit
        Left = 64
        Top = 150
        Hint = 'E.R_ZMJNAME'
        ParentFont = False
        TabOrder = 25
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
    object edtQualityGrade: TcxTextEdit
      Left = 93
      Top = 186
      Hint = 'E.R_QualityGrade'
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
          Caption = #36136#37327#31561#32423
          Control = edtQualityGrade
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
