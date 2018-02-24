{
   称重误差参数设置
}
unit UFramePoundWuCha;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, ADODB, cxLabel,
  UBitmapPanel, cxSplitter, dxLayoutControl, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, cxTextEdit, cxMaskEdit,
  cxButtonEdit, Menus, StdCtrls, cxButtons,IniFiles;

type
  TfFramePoundWuCha = class(TfFrameNormal)
    cxLevel2: TcxGridLevel;
    cxLevel3: TcxGridLevel;
    cxView2: TcxGridDBTableView;
    cxView3: TcxGridDBTableView;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure cxGrid1ActiveTabChanged(Sender: TcxCustomGrid;
      ALevel: TcxGridLevel);
  private
    { Private declarations }
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  protected
    procedure OnLoadGridConfig(const nIni: TIniFile); override;
    procedure OnSaveGridConfig(const nIni: TIniFile); override;
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

var
  fFramePoundWuCha: TfFramePoundWuCha;

implementation

{$R *.dfm}
uses
  ULibFun, USysFun, USysConst, USysGrid, USysDB, UMgrControl, UFormBase,
  UFormPWuCha, UDataModule,USysDataDict;

class function TfFramePoundWuCha.FrameID: integer;
begin
  Result := cFI_FramePoundWc;
end;

//Desc: 数据查询SQL
function TfFramePoundWuCha.InitFormDataSQL(const nWhere: string): string;
var nStr: string;
begin
  Result := 'Select * From ' + sTable_PoundWucha;
  if nWhere <> '' then
  begin
    Result := Result + ' Where (' + nWhere + ')';
    Result := Result + ' Order By ID';
  end
  else begin
    Result := '';
  end;
end;


procedure TfFramePoundWuCha.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  np.FParamA := sFlag_wuchaType_D;
  if cxGrid1.ActiveView=cxView2 then
  begin
    np.FParamA := sFlag_wuchaType_S;
  end
  else if cxGrid1.ActiveView=cxView3 then
  begin
    np.FParamA := sFlag_wuchaType_Z;
  end;
  CreateBaseFormItem(cFI_FormPoundWc, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

procedure TfFramePoundWuCha.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FCommand := cCmd_EditData;

    np.FParamA := sFlag_wuchaType_D;
    if cxGrid1.ActiveView=cxView2 then
    begin
      np.FParamA := sFlag_wuchaType_S;
    end
    else if cxGrid1.ActiveView=cxView3 then
    begin
      np.FParamA := sFlag_wuchaType_Z;
    end;

    nP.FParamB := SQLQuery.FieldByName('ID').AsString;

    CreateBaseFormItem(cFI_FormPoundWc, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;
  end;
end;

procedure TfFramePoundWuCha.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('ID').AsString;
  if not QueryDlg('确定要删除编号为[ ' + nStr + ' ]的误差值吗', sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nSQL := 'Delete From %s Where ID=''%s''';
    nSQL := Format(nSQL, [sTable_PoundWucha, nStr]);
    FDM.ExecuteSQL(nSQL);
    FDM.ADOConn.CommitTrans;

    InitFormData(FWhere);
    ShowMsg('记录已成功删除', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('记录删除失败', sError);
  end;
end;

procedure TfFramePoundWuCha.cxGrid1ActiveTabChanged(Sender: TcxCustomGrid;
  ALevel: TcxGridLevel);
begin
  if cxGrid1.ActiveView = cxView1 then
  begin
    FWhere := 'w_type is null or w_type=''1''';
  end
  else if cxGrid1.ActiveView = cxView2 then
  begin
    FWhere := 'w_type=''2''';
  end
  else if cxGrid1.ActiveView = cxView3  then
  begin
    FWhere := 'w_type=''3''';
  end;
  InitFormData(FWhere);
end;

procedure TfFramePoundWuCha.OnLoadGridConfig(const nIni: TIniFile);
begin
  inherited;
  gSysEntityManager.BuildViewColumn(cxView2, 'MAIN_E04');
  gSysEntityManager.BuildViewColumn(cxView3, 'MAIN_E04');
  cxGrid1.ActiveLevel := cxLevel1;
  cxGrid1ActiveTabChanged(cxGrid1, cxGrid1.ActiveLevel);
end;

procedure TfFramePoundWuCha.OnSaveGridConfig(const nIni: TIniFile);
begin
  inherited;
//
end;

initialization
  gControlManager.RegCtrl(TfFramePoundWuCha, TfFramePoundWuCha.FrameID);

end.
