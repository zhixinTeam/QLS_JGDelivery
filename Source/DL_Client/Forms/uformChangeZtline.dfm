object FormChangeZtLine: TFormChangeZtLine
  Left = 352
  Top = 278
  BorderStyle = bsToolWindow
  Caption = 'FormChangeZtLine'
  ClientHeight = 99
  ClientWidth = 255
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cbbZtLines: TcxComboBox
    Left = 8
    Top = 32
    ParentFont = False
    TabOrder = 0
    Width = 241
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 8
    Caption = #35831#36873#25321#26032#30340#35013#36710#36890#36947#21495
    ParentFont = False
  end
  object btnOk: TcxButton
    Left = 88
    Top = 64
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 2
    OnClick = btnOkClick
  end
  object BtnCancel: TcxButton
    Left = 168
    Top = 64
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    TabOrder = 3
    OnClick = BtnCancelClick
  end
end
