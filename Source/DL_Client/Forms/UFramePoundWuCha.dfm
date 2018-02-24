inherited fFramePoundWuCha: TfFramePoundWuCha
  Width = 713
  inherited ToolBar1: TToolBar
    Width = 713
    inherited BtnAdd: TToolButton
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 157
    Width = 713
    Height = 210
    LevelTabs.Slants.Kind = skCutCorner
    LevelTabs.Style = 9
    RootLevelOptions.DetailTabsPosition = dtpTop
    OnActiveTabChanged = cxGrid1ActiveTabChanged
    object cxView2: TcxGridDBTableView [1]
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = DataSource1
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    object cxView3: TcxGridDBTableView [2]
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = DataSource1
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    inherited cxLevel1: TcxGridLevel
      Caption = #21253#35013#35823#24046
    end
    object cxLevel2: TcxGridLevel
      Caption = #25955#35013#35823#24046
      GridView = cxView2
    end
    object cxLevel3: TcxGridLevel
      Caption = #30742#22359#35823#24046
      GridView = cxView3
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 713
    Height = 90
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupDetail1: TdxLayoutGroup
        Caption = #32534#36753#20449#24687
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 149
    Width = 713
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 713
    inherited TitleBar: TcxLabel
      Caption = #31216#37325#35823#24046#35774#32622
      Style.IsFontAssigned = True
      Width = 713
      AnchorX = 357
      AnchorY = 11
    end
  end
end
