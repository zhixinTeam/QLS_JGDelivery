inherited fFormBrick: TfFormBrick
  Left = 476
  Top = 257
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 183
  ClientWidth = 372
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 372
    Height = 183
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    LookAndFeel = FDM.dxLayoutWeb1
    object editD_value: TcxTextEdit
      Left = 123
      Top = 61
      Hint = 'T.d_value'
      ParentFont = False
      Properties.MaxLength = 30
      TabOrder = 1
      OnKeyDown = FormKeyDown
      Width = 138
    end
    object BtnOK: TButton
      Left = 217
      Top = 149
      Width = 69
      Height = 23
      Caption = #20445#23384
      TabOrder = 4
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 291
      Top = 149
      Width = 70
      Height = 23
      Caption = #21462#28040
      TabOrder = 5
      OnClick = BtnExitClick
    end
    object eeditD_memo: TcxTextEdit
      Left = 123
      Top = 86
      Hint = 'T.d_memo'
      ParentFont = False
      Properties.MaxLength = 20
      TabOrder = 2
      OnKeyDown = FormKeyDown
      Width = 222
    end
    object editD_ParamA: TcxTextEdit
      Left = 123
      Top = 111
      Hint = 'T.d_paramA'
      HelpType = htKeyword
      HelpKeyword = 'D'
      ParentFont = False
      TabOrder = 3
      Text = '0'
      Width = 107
    end
    object editD_desc: TcxTextEdit
      Left = 123
      Top = 36
      Hint = 'T.D_Desc'
      ParentFont = False
      Properties.MaxLength = 30
      TabOrder = 0
      OnKeyDown = FormKeyDown
      Width = 282
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        Caption = #22522#26412#20449#24687
        object dxLayoutControl1Group9: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayoutControl1Item13: TdxLayoutItem
            Caption = #20135#21697#20195#30721':'
            Control = editD_desc
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item2: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #20135#21697#21517#31216':'
            Control = editD_value
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item14: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #22411#21495#35268#26684':'
            Control = eeditD_memo
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Item1: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #21333#20301#37325#37327'('#21544'/'#24179'):'
          Control = editD_ParamA
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
    object dxLayoutControl1Group2: TdxLayoutGroup
      AutoAligns = [aaHorizontal]
      AlignVert = avClient
      Caption = #38468#21152#20449#24687
    end
  end
end
