{*******************************************************************************
  作者: dmzn@163.com 2014-6-02
  描述: 原材料
*******************************************************************************}
unit UFormBrick;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UFormBase, cxGraphics, dxLayoutControl, StdCtrls,
  cxMaskEdit, cxDropDownEdit, cxMCListBox, cxMemo, cxContainer, cxEdit,
  cxTextEdit, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxSkinsCore, dxSkinsDefaultPainters;

type
  TfFormBrick = class(TBaseForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    dxLayoutControl1Group2: TdxLayoutGroup;
    editD_value: TcxTextEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    BtnOK: TButton;
    dxLayoutControl1Item10: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item11: TdxLayoutItem;
    dxLayoutControl1Group5: TdxLayoutGroup;
    eeditD_memo: TcxTextEdit;
    dxLayoutControl1Item14: TdxLayoutItem;
    dxLayoutControl1Group9: TdxLayoutGroup;
    editD_ParamA: TcxTextEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    dxLayoutControl1Item13: TdxLayoutItem;
    editD_desc: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FRecordID: string;
    //记录号
    procedure InitFormData(const nID: string);
    //载入数据
    function isdbexists(const nid:string):boolean;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UFormCtrl, UAdjustForm, USysGrid,
  USysDB, USysConst;

var
  gForm: TfFormBrick = nil;
  //全局使用

class function TfFormBrick.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormBrick.Create(Application) do
    begin
      FRecordID := '';
      Caption := '添加';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormBrick.Create(Application) do
    begin
      FRecordID := nP.FParamA;
      Caption := '修改';
      editD_desc.Properties.ReadOnly := True;
      editD_desc.Style.TextColor := clGray;

      InitFormData(FRecordID);

      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormBrick.Create(Application);
        with gForm do
        begin
          Caption := '查看';
          FormStyle := fsStayOnTop;

          BtnOK.Visible := False;
        end;
      end;

      with gForm  do
      begin
        FRecordID := nP.FParamA;
        InitFormData(FRecordID);
        if not Showing then Show;
      end;
    end;
   cCmd_FormClose:
    begin
      if Assigned(gForm) then FreeAndNil(gForm);
    end;
  end;
end;

class function TfFormBrick.FormID: integer;
begin
  Result := cFI_FormBrick;
end;

//------------------------------------------------------------------------------
procedure TfFormBrick.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  ResetHintAllForm(Self, 'T', sTable_SysDict);
  //重置表名称
end;

procedure TfFormBrick.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  gForm := nil;
  Action := caFree;
end;

procedure TfFormBrick.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormBrick.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = VK_ESCAPE then
  begin
    Key := 0;
    Close;
  end;
end;

//Desc: 载入信息
procedure TfFormBrick.InitFormData(const nID: string);
var nStr: string;
begin
  if nID = '' then Exit;
  nStr := 'Select * From %s Where d_name=''%s'' and d_desc=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_BrickItem,nID]);
  LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '');
end;

//Desc: 保存数据
procedure TfFormBrick.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  editD_desc.Text := Trim(editD_desc.Text);
  if editD_desc.Text = '' then
  begin
    editD_desc.SetFocus;
    ShowMsg('请填写产品代码', sHint); Exit;
  end;

  if (FRecordID = '') and isdbexists(editD_desc.Text) then
  begin
    editD_desc.SetFocus;
    ShowMsg('请填写产品代码重复，请重新填写', sHint); Exit;
  end;

  editD_value.Text := Trim(editD_value.Text);
  if editD_value.Text = '' then
  begin
    editD_value.SetFocus;
    ShowMsg('请填写产品名称', sHint); Exit;
  end;

  if not IsNumber(editD_ParamA.Text, True) then
  begin
    editD_ParamA.SetFocus;
    ShowMsg('请输入单位重量', sHint); Exit;
  end;

  if strtofloat(editD_ParamA.Text)<0.000001 then
  begin
    editD_ParamA.SetFocus;
    ShowMsg('请正确输入单位重量', sHint); Exit;
  end;

  if FRecordID = '' then
  begin
    nStr := MakeSQLByStr([
            SF('d_name',sFlag_BrickItem),
            SF('d_desc', editD_desc.Text),
            SF('d_value', editD_value.Text),
            SF('d_memo', eeditD_memo.Text),
            SF('d_paramA', StrToFloat(editD_ParamA.Text), sfVal)
            ], sTable_SysDict, '', True);
  end else
  begin
    nStr := MakeSQLByStr([
            SF('d_value', editD_value.Text),
            SF('d_memo', eeditD_memo.Text),
            SF('d_paramA', StrToFloat(editD_ParamA.Text), sfVal)
            ], sTable_SysDict, 'd_name=''%s'' and d_desc=''%s''', false);
    nStr := Format(nStr,[sFlag_BrickItem,editD_desc.Text]);
  end;
  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nStr);
    FDM.ADOConn.CommitTrans;
    ModalResult := mrOK;
    ShowMsg('信息已保存', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('数据保存失败', '未知原因');
  end;
end;

function TfFormBrick.isdbexists(const nid: string): boolean;
var
  nStr : string;
begin
  nStr := 'select * from %s where d_name=''%s'' and d_desc=''%s''';
  nStr := Format(nStr,[sTable_SysDict,sFlag_BrickItem,nid]);
  Result := fdm.QueryTemp(nStr).RecordCount>0;
end;

initialization
  gControlManager.RegCtrl(TfFormBrick, TfFormBrick.FormID);
end.
