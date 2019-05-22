{*******************************************************************************
  ����: dmzn@163.com 2014-10-20
  ����: �Զ�����ͨ����
*******************************************************************************}
unit UFramePoundAutoItem;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UMgrPoundTunnels, UBusinessConst, UFrameBase, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, StdCtrls,
  UTransEdit, ExtCtrls, cxRadioGroup, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxLabel, ULEDFont, DateUtils, Menus;

type
  TfFrameAutoPoundItem = class(TBaseFrame)
    GroupBox1: TGroupBox;
    EditValue: TLEDFontNum;
    GroupBox3: TGroupBox;
    ImageGS: TImage;
    Label16: TLabel;
    Label17: TLabel;
    ImageBT: TImage;
    Label18: TLabel;
    ImageBQ: TImage;
    ImageOff: TImage;
    ImageOn: TImage;
    HintLabel: TcxLabel;
    EditTruck: TcxComboBox;
    EditMID: TcxComboBox;
    EditPID: TcxComboBox;
    EditMValue: TcxTextEdit;
    EditPValue: TcxTextEdit;
    EditJValue: TcxTextEdit;
    Timer1: TTimer;
    EditBill: TcxComboBox;
    EditZValue: TcxTextEdit;
    GroupBox2: TGroupBox;
    RadioPD: TcxRadioButton;
    RadioCC: TcxRadioButton;
    EditMemo: TcxTextEdit;
    EditWValue: TcxTextEdit;
    RadioLS: TcxRadioButton;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    Timer2: TTimer;
    Timer_ReadCard: TTimer;
    TimerDelay: TTimer;
    MemoLog: TZnTransMemo;
    Timer_SaveFail: TTimer;
    Timer_SaveDone: TTimer;
    EditZWc: TcxTextEdit;
    EditFWc: TcxTextEdit;
    PMclose: TPopupMenu;
    N1: TMenuItem;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer_ReadCardTimer(Sender: TObject);
    procedure TimerDelayTimer(Sender: TObject);
    procedure Timer_SaveFailTimer(Sender: TObject);
    procedure Timer_SaveDoneTimer(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
    FCardUsed: string;
    //��Ƭ����
    FIsWeighting,FIsSaveing: Boolean;
    //���ر�ʶ
    FPoundTunnel: PPTTunnelItem;
    //��վͨ��
    FLastGS,FLastBT,FLastBQ: Int64;
    //�ϴλ
    FBillItems: TLadingBillItems;
    FUIData,FInnerData: TLadingBillItem;
    //��������
    FLastCardDone: Int64;
    FLastCard, FCardTmp, FLastReader: string;
    //�ϴο���
    FListA: TStrings;
    FSampleIndex: Integer;
    FValueSamples: array of Double;
    //���ݲ���
    FEmptyPoundWeight: Double;
    FEmptyPoundInit: Int64;
    FEmptyPoundIdleLong: Int64;
    FEmptyPoundIdleShort: Int64;
    //�հ���ʱ
    FMemPoundSanZ,FMemPoundSanZ_db,FMemPoundSanF,FMemPoundSanF_db:Double;
    FMemPoundBrickZ,FMemPoundBrickZ_db,FMemPoundBrickF,FMemPoundBrickF_db:Double;
    FPoundVoice: string;
    //�����쳣��������
    FBrickItemList:TList;
    procedure SetUIData(const nReset: Boolean; const nOnlyData: Boolean = False);
    //��������
    procedure SetImageStatus(const nImage: TImage; const nOff: Boolean);
    //����״̬
    procedure SetTunnel(const nTunnel: PPTTunnelItem);
    //����ͨ��
    procedure OnPoundDataEvent(const nValue: Double);
    procedure OnPoundData(const nValue: Double);
    //��ȡ����
    procedure LoadBillItems(const nCard: string);
    //��ȡ������
    procedure InitSamples;
    procedure AddSample(const nValue: Double);
    function IsValidSamaple: Boolean;
    //�������
    function SavePoundSale(var nDaiWc:string): Boolean;
    function SavePoundData(var nHint:string): Boolean;
    //�������
    procedure WriteLog(nEvent: string);
    //��¼��־
    procedure PlayVoice(const nStrtext: string);
    //��������
    procedure initBrickItems;
    function getBrickItem(const stockno:string):PBrickItem;
    function getPrePInfo(const nTruck:string;var nPrePValue:Double;var nPrePMan:string;var nPrePTime:TDateTime):Boolean;
  public
    { Public declarations }
    class function FrameID: integer; override;
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    //����̳�
    procedure PoundOutWeight;
    //�ذ���ͷ����
    property PoundTunnel: PPTTunnelItem read FPoundTunnel write SetTunnel;
    //�������
    property Additional: TStrings read FListA write FListA;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UFormBase, {$IFDEF HR1847}UKRTruckProber,{$ELSE}UMgrTruckProbe,{$ENDIF}
  UMgrRemoteVoice, UMgrVoiceNet, UDataModule, USysBusiness,
  USysLoger, USysConst, USysDB;

const
  cFlag_ON    = 10;
  cFlag_OFF   = 20;

class function TfFrameAutoPoundItem.FrameID: integer;
begin
  Result := 0;
end;

procedure TfFrameAutoPoundItem.OnCreateFrame;
begin
  inherited;
  FBrickItemList := TList.Create;
  FPoundTunnel := nil;
  FIsWeighting := False;

  FIsSaveing := False;
  FEmptyPoundInit := 0;
  FListA := TStringList.Create;
  initBrickItems;
end;

procedure TfFrameAutoPoundItem.OnDestroyFrame;
var
  i:integer;
  nItem:PBrickItem;
begin
  gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
  //�رձ�ͷ�˿�
  FListA.Free;
  for i := FBrickItemList.Count-1 downto 0 do
  begin
    nItem := PBrickItem(FBrickItemList.Items[i]);
    Dispose(nItem);
  end;
  FBrickItemList.Clear;
  
  inherited;
end;

procedure TfFrameAutoPoundItem.PoundOutWeight;
begin
  PlayVoice(FPoundTunnel.FName + '����');
end;

//Desc: ��������״̬ͼ��
procedure TfFrameAutoPoundItem.SetImageStatus(const nImage: TImage;
  const nOff: Boolean);
begin
  if nOff then
  begin
    if nImage.Tag <> cFlag_OFF then
    begin
      nImage.Tag := cFlag_OFF;
      nImage.Picture.Bitmap := ImageOff.Picture.Bitmap;
    end;
  end else
  begin
    if nImage.Tag <> cFlag_ON then
    begin
      nImage.Tag := cFlag_ON;
      nImage.Picture.Bitmap := ImageOn.Picture.Bitmap;
    end;
  end;
end;

procedure TfFrameAutoPoundItem.WriteLog(nEvent: string);
var nInt: Integer;
begin
  with MemoLog do
  try
    Lines.BeginUpdate;
    if Lines.Count > 20 then
     for nInt:=1 to 10 do
      Lines.Delete(0);
    //�������

    Lines.Add(DateTime2Str(Now) + #9 + nEvent);
  finally
    Lines.EndUpdate;
    Perform(EM_SCROLLCARET,0,0);
    Application.ProcessMessages;
  end;
end;

procedure WriteSysLog(const nEvent: string);
begin
  gSysLoger.AddLog(TfFrameAutoPoundItem, '�Զ�����ҵ��', nEvent);
end;

//------------------------------------------------------------------------------
//Desc: ��������״̬
procedure TfFrameAutoPoundItem.Timer1Timer(Sender: TObject);
begin
  SetImageStatus(ImageGS, GetTickCount - FLastGS > 5 * 1000);
  SetImageStatus(ImageBT, GetTickCount - FLastBT > 5 * 1000);
  SetImageStatus(ImageBQ, GetTickCount - FLastBQ > 5 * 1000);
end;

//Desc: �رպ��̵�
procedure TfFrameAutoPoundItem.Timer2Timer(Sender: TObject);
var
  nStr: string;
begin
  Timer2.Tag := Timer2.Tag + 1;
  if Timer2.Tag < 10 then Exit;

  Timer2.Tag := 0;
  Timer2.Enabled := False;
  nStr:=TunnelOC(FPoundTunnel.FID,sFlag_No);
end;

//Desc: ����ͨ��
procedure TfFrameAutoPoundItem.SetTunnel(const nTunnel: PPTTunnelItem);
var nStr: string;
begin
  FPoundTunnel := nTunnel;
  if Assigned(FPoundTunnel.FOptions) then
  begin
    nStr := FPoundTunnel.FOptions.Values['EmptyWeight'];

    if IsNumber(nStr, True) then
         FEmptyPoundWeight := StrToFloat(nStr)
    else FEmptyPoundWeight := 100;

    FEmptyPoundWeight := FEmptyPoundWeight / 1000;
    //unit kilo

    nStr := FPoundTunnel.FOptions.Values['EmptyIdleLong'];
    if IsNumber(nStr, False) then
         FEmptyPoundIdleLong := StrToInt64(nStr)
    else FEmptyPoundIdleLong := 5;

    FEmptyPoundIdleLong := FEmptyPoundIdleLong * 60 * 1000;
    //unit min

    nStr := FPoundTunnel.FOptions.Values['EmptyIdleShort'];
    if IsNumber(nStr, False) then
         FEmptyPoundIdleShort := StrToInt64(nStr)
    else FEmptyPoundIdleShort := 10;

    FEmptyPoundIdleShort := FEmptyPoundIdleShort * 1000;
    //unit second
  end;
  SetUIData(True);
end;

//Desc: ���ý�������
procedure TfFrameAutoPoundItem.SetUIData(const nReset,nOnlyData: Boolean);
var nStr: string;
    nInt: Integer;
    nVal: Double;
    nItem: TLadingBillItem;
begin
  if nReset then
  begin
    FillChar(nItem, SizeOf(nItem), #0);
    //init

    with nItem do
    begin
      FPModel := sFlag_PoundPD;
      FFactory := gSysParam.FFactNum;
    end;

    FUIData := nItem;
    FInnerData := nItem;
    if nOnlyData then Exit;

    SetLength(FBillItems, 0);
    EditValue.Text := '0.00';
    EditBill.Properties.Items.Clear;

    FIsSaveing := False;
    FIsWeighting := False;
    FEmptyPoundInit := 0;
    
    gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
    //�رձ�ͷ�˿�
    EditZWc.Text:='0.00';
    EditFWc.Text:='0.00';
  end;

  with FUIData do
  begin
    EditBill.Text := FID;
    EditTruck.Text := FTruck;
    EditMID.Text := FStockName;
    EditPID.Text := FCusName;

    EditMValue.Text := Format('%.2f', [FMData.FValue]);
    EditPValue.Text := Format('%.2f', [FPData.FValue]);
    EditZValue.Text := Format('%.2f', [FValue]);

    if (FValue > 0) and (FMData.FValue > 0) and (FPData.FValue > 0) then
    begin
      nVal := FMData.FValue - FPData.FValue;
      EditJValue.Text := Format('%.2f', [nVal]);
      EditWValue.Text := Format('%.2f', [FValue - nVal]);
    end else
    begin
      EditJValue.Text := '0.00';
      EditWValue.Text := '0.00';
    end;

    RadioPD.Checked := FPModel = sFlag_PoundPD;
    RadioCC.Checked := FPModel = sFlag_PoundCC;
    RadioLS.Checked := FPModel = sFlag_PoundLS;

    RadioLS.Enabled := (FPoundID = '') and (FID = '');
    //�ѳƹ�����������,������ʱģʽ
    RadioCC.Enabled := FID <> '';
    //ֻ�������г���ģʽ

    EditBill.Properties.ReadOnly := (FID = '') and (FTruck <> '');
    EditTruck.Properties.ReadOnly := FTruck <> '';
    EditMID.Properties.ReadOnly := (FID <> '') or (FPoundID <> '');
    EditPID.Properties.ReadOnly := (FID <> '') or (FPoundID <> '');
    //�����������

    EditMemo.Properties.ReadOnly := True;
    EditMValue.Properties.ReadOnly := not FPoundTunnel.FUserInput;
    EditPValue.Properties.ReadOnly := not FPoundTunnel.FUserInput;
    EditJValue.Properties.ReadOnly := True;
    EditZValue.Properties.ReadOnly := True;
    EditWValue.Properties.ReadOnly := True;
    //������������

    if FTruck = '' then
    begin
      EditMemo.Text := '';
      Exit;
    end;
  end;

  nInt := Length(FBillItems);
  if nInt > 0 then
  begin
    if nInt > 1 then
         nStr := '���۲���'
    else nStr := '����';

    if FCardUsed = sFlag_Provide then nStr := '��Ӧ';

    if FUIData.FNextStatus = sFlag_TruckBFP then
    begin
      RadioCC.Enabled := False;
      EditMemo.Text := nStr + '��Ƥ��';
    end else
    begin
      RadioCC.Enabled := True;
      EditMemo.Text := nStr + '��ë��';
    end;
  end else
  begin
    if RadioLS.Checked then
      EditMemo.Text := '������ʱ����';
    //xxxxx

    if RadioPD.Checked then
      EditMemo.Text := '������Գ���';
    //xxxxx
  end;
end;

//Date: 2014-09-19
//Parm: �ſ��򽻻�����
//Desc: ��ȡnCard��Ӧ�Ľ�����
procedure TfFrameAutoPoundItem.LoadBillItems(const nCard: string);
var nRet: Boolean;
    nStr,nHint,nPos,nVoice: string;
    nIdx,nInt: Integer;
    nBills: TLadingBillItems;
    nNStatus: string;
    nbrickitem:PBrickItem;
  nIsPreTruck:Boolean;
  nPrePValue:Double;
  nPrePMan:string;
  nPrePTime:TDateTime;    
begin
  nStr := Format('��ȡ������[ %s ],��ʼִ��ҵ��.', [nCard]);
  WriteLog(nStr);
  FMemPoundSanZ := 0;
  FMemPoundSanZ_db := 0;
  FMemPoundSanF := 0;
  FMemPoundSanF_db := 0;

  FMemPoundbrickZ := 0;
  FMemPoundbrickZ_db := 0;
  FMemPoundbrickF := 0;
  FMemPoundbrickF_db := 0;

  FCardUsed := GetCardUsed(nCard);
  nStr := Format('lixw-debug:��ȡ��������[ %s ].', [FCardUsed]);
  WriteLog(nStr);
  if (FCardUsed=sFlag_Provide) then
  begin
    if (not GetPurchaseOrders(nCard, sFlag_TruckBFP, nBills)) then
    begin
      SetUIData(True);
      Exit;
    end;
  end
  else if (FCardUsed = sFlag_sale) then
  begin
    if (not GetLadingBills(nCard, sFlag_TruckBFP, nBills)) then
    begin
      SetUIData(True);
      Exit;
    end;
  end
  else if (FCardUsed = sFlag_other) then
  begin
    if (not GetPurchaseOrders(nCard, sFlag_TruckBFP, nBills)) then
    begin
      SetUIData(True);
      Exit;
    end;
    for nIdx := Low(nbills) to High(nBills) do
    begin
      nbills[nIdx].FSelected := True;
      nIsPreTruck := getPrePInfo(nBills[nIdx].Ftruck,nPrePValue,nPrePMan,nPrePTime);
      //�̶���Ԥ��Ƥ�أ�������ʷ����Ϊ0
      if (nIsPreTruck) and (nBills[nIdx].FCardKeep)
        and (nBills[nIdx].FStatus=sFlag_TruckIn)
        and (nBills[nIdx].FNextStatus=sFlag_TruckBFP) then
      begin
        nBills[nIdx].FPData.FStation := '';
        nBills[nIdx].FPData.FValue := 0;
        nBills[nIdx].FPData.FDate := 0;
        nBills[nIdx].FPData.FOperator := '';

        nBills[nIdx].FMData.FStation := '';
        nBills[nIdx].FMData.FValue := 0;
        nBills[nIdx].FMData.FDate := 0;
        nBills[nIdx].FMData.FOperator := '';
      end
      //����Ƥ�غ�ë��
      else begin
        //��һ״̬Ϊë�أ�Ƥ�ش���0��ë�ص���0
        if (nBills[nIdx].FNextStatus=sFlag_TruckBFM) and (nBills[nIdx].FPData.FValue>0.0001) and (nBills[nIdx].FMData.FValue<0.0001) then
        begin
          nBills[nIdx].FMData.FValue := nBills[nIdx].FPData.FValue;
          nBills[nIdx].FMData.FStation := nBills[nIdx].FPData.FStation;
          nBills[nIdx].FMData.FDate := nBills[nIdx].FPData.FDate;
          nBills[nIdx].FMData.FOperator := nBills[nIdx].FPData.FOperator;

          nBills[nIdx].FPData.FStation := '';
          nBills[nIdx].FPData.FValue := 0;
          nBills[nIdx].FPData.FDate := Now;
          nBills[nIdx].FPData.FOperator := '';
        end;
      end;      
    end;
  end;
  WriteLog('lixw-debug:��ȡ������Ϣ���,length(nBills)='+IntTostr(Length(nBills)));
//  if FCardUsed=sFlag_Provide then
//       nRet := GetPurchaseOrders(nCard, sFlag_TruckBFP, nBills)
//  else nRet := GetLadingBills(nCard, sFlag_TruckBFP, nBills);

  if (Length(nBills) < 1)
  then
  begin
    SetUIData(True);
    Timer_ReadCard.Enabled:=True;
    Exit;
  end;
  
  nHint := '';
  nInt := 0;

  for nIdx:=Low(nBills) to High(nBills) do
  with nBills[nIdx] do
  begin
    {$IFDEF QlS}
    if (FStatus=sFlag_TruckNone) then
    begin
      if FCardUsed=sFlag_Sale then
      begin
        if SaveLadingBills(nHint, sFlag_TruckIn, nBills) then
        begin
          ShowMsg('���������ɹ�', sHint);
          LoadBillItems(FCardTmp);
          Exit;
        end else
        begin
          ShowMsg('��������ʧ��', sHint);
        end;
      end
      else
      begin
        if SavePurchaseOrders(sFlag_TruckIn, nBills) then
        begin
          ShowMsg('���������ɹ�', sHint);
          LoadBillItems(FCardTmp);
          Exit;
        end else
        begin
          ShowMsg('��������ʧ��', sHint);
        end;
      end;
    end;
    {$ELSE}
    if GetAutoInFactory(FStockNo) and (FNextStatus=sFlag_TruckNone) then
    begin
      if SavePurchaseOrders(sFlag_TruckIn, nBills) then
      begin
        ShowMsg('���������ɹ�', sHint);
        LoadBillItems(FCardTmp);
        Exit;
      end else
      begin
        ShowMsg('��������ʧ��', sHint);
      end;
    end;
    {$ENDIF}
    if (FStatus <> sFlag_TruckBFP) and (FNextStatus = sFlag_TruckZT) then
      FNextStatus := sFlag_TruckBFP;
    //״̬У��
    FSelected := (FNextStatus = sFlag_TruckBFP) or
                 (FNextStatus = sFlag_TruckBFM);
    //�ɳ���״̬�ж�

    if FSelected then
    begin
      Inc(nInt);
      Continue;
    end;

    nStr := '��.����:[ %s ] ״̬:[ %-6s -> %-6s ]   ';
    if nIdx < High(nBills) then nStr := nStr + #13#10;

    nStr := Format(nStr, [FID,
            TruckStatusToStr(FStatus), TruckStatusToStr(FNextStatus)]);
    nHint := nHint + nStr;
    nNStatus:= TruckStatusToStr(FNextStatus);
    nStr := '���� %s ���ܹ���,Ӧ�� %s ';
    if nNStatus='�ŻҴ�' then
      nNStatus:='ȥ��Ʊ��'
    else if nNStatus='ջ̨' then
      nNStatus:='ȥ��Ʊ��';
    nStr := Format(nStr, [FTruck, nNStatus]);
    writelog('lixw-debug'+nStr);
    {$IFNDEF DEBUG}
    PlayVoice(nStr);
    {$ENDIF}
  end;

  if nInt = 0 then
  begin
    nHint := '�ó�����ǰ���ܹ���,��������: ' + #13#10#13#10 + nHint;
    WriteSysLog(nStr);
    Timer_ReadCard.Enabled:=True;
    Exit;
  end;

  {$IFDEF RemoteSnap}
  if not VerifySnapTruck(FLastReader, nBills[0], nHint, nPos) then
  begin
    nVoice := '%s����ʶ��ʧ��,���ƶ���������ϵ����Ա';
    nVoice := Format(nVoice, [nBills[0].FTruck]);
    PlayVoice(nVoice);
    RemoteSnapDisPlay(nPos, nHint,sFlag_No);
    WriteSysLog(nHint);
    SetUIData(True);
    Timer_ReadCard.Enabled:=True;
    Exit;
  end
  else
  begin
    if nHint <> '' then
    begin
      RemoteSnapDisPlay(nPos, nHint,sFlag_Yes);
      WriteSysLog(nHint);
    end;
  end;
  {$ENDIF}

  EditBill.Properties.Items.Clear;
  SetLength(FBillItems, nInt);
  nInt := 0;

  for nIdx:=Low(nBills) to High(nBills) do
  with nBills[nIdx] do
  begin
    if FSelected then
    begin
      if (FCardUsed <> sFlag_other) then FPoundID := '';
      //�ñ����������;
      
      if nInt = 0 then
           FInnerData := nBills[nIdx]
      else FInnerData.FValue := FInnerData.FValue + FValue;
      //�ۼ���

      EditBill.Properties.Items.Add(FID);
      FBillItems[nInt] := nBills[nIdx];
      Inc(nInt);
    end;
  end;

  FInnerData.FPModel := sFlag_PoundPD;
  FUIData := FInnerData;
  SetUIData(False);

  nInt := SecondsBetween(Now, FUIData.FPData.FDate);
  if (nInt > 0) and (nInt < FPoundTunnel.FCardInterval) then
  begin
    nStr := '�ſ�[ %s ]��ȴ� %d �����ܹ���';
    nStr := Format(nStr, [nCard, FPoundTunnel.FCardInterval - nInt]);

    WriteLog(nStr);
    //PlayVoice(nStr);

    nStr := Format('��վ[ %s.%s ]: ',[FPoundTunnel.FID,
            FPoundTunnel.FName]) + nStr;
    WriteSysLog(nStr);
    SetUIData(True);
    Timer_ReadCard.Enabled:=True;
    Exit;
  end;

  InitSamples;
  //��ʼ������
  with gSysParam,nBills[0] do
  begin
    nbrickitem := getBrickItem(Fstockno);
    if Assigned(nbrickitem) then
    begin
      try
        if GetPoundWc(StrToFloat(EditZValue.Text)*nbrickitem.FTonOfPerSquare,FMemPoundbrickZ_db,FMemPoundbrickF_db,sFlag_wuchaType_Z) then
        begin
          WriteSysLog('ש������'+floattostr(FMemPoundbrickZ_db)+' ��'+floattostr(FMemPoundbrickF_db));
        end else
          WriteSysLog('ש����get wucha Error');
      except
        on e:Exception do
        begin
          WriteSysLog(e.Message);
        end;
      end;
    end
    else if (Fszbz='1') and (FType = sFlag_San) then
    begin
      try
        if GetPoundWc(StrToFloat(EditZValue.Text),FMemPoundSanZ_db,FMemPoundSanF_db,sFlag_wuchaType_S) then
        begin
          WriteSysLog('ɢװ����'+floattostr(FMemPoundSanZ_db)+' ��'+floattostr(FMemPoundSanF_db));
        end else
          WriteSysLog('ɢװ��get wucha Error');
      except
        on e:Exception do
        begin
          WriteSysLog(e.Message);
        end;
      end;
    end
    else if FDaiPercent and (FType = sFlag_Dai) then
    begin
      try
        if GetPoundWc(StrToFloat(EditZValue.Text),FPoundDaiZ_1,FPoundDaiF_1) then
        begin
          WriteSysLog('��װ����'+floattostr(FPoundDaiZ_1)+' ��'+floattostr(FPoundDaiF_1));
        end else
          WriteSysLog('��װ��get wucha Error');
      except
        on e:Exception do
        begin
          WriteSysLog(e.Message);
        end;
      end;
    end;
  end;

  if (not FPoundTunnel.FUserInput) then
  begin
    if gPoundTunnelManager.ActivePort(FPoundTunnel.FID, OnPoundDataEvent, True) then
    begin
      Sleep(700);
      WriteLog('PoundValue: '+EditValue.Text+' STDvalue: '+floattostr(FPoundTunnel.FPort.FMinValue));
      if StrToFloat(EditValue.Text) > FPoundTunnel.FPort.FMinValue then
      begin
        gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
        //�رձ�ͷ
        Timer_ReadCard.Enabled:=True;
        Exit;
      end;
    end else
    begin
      Timer_ReadCard.Enabled:=True;
      Exit;
    end;
  end;
  {$IFNDEF DEBUG}
  nStr:=OpenDoor(nCard,'0');
  {$ENDIF}
  //������ڵ�բ  
  //
  WriteLog(nCard+'�������բ');
  //{$ENDIF}
  {$IFNDEF DEBUG}
  PlayVoice(EditTruck.Text+'ˢ���ɹ����ϰ�����Ϩ��ͣ��');
  {$ENDIF}
  FLastCardDone := 0;

  FIsSaveing := False;
  FIsWeighting := True;
end;

//------------------------------------------------------------------------------
//Desc: �ɶ�ʱ��ȡ������
procedure TfFrameAutoPoundItem.Timer_ReadCardTimer(Sender: TObject);
var nStr,nCard: string;
    nLast: Int64;
begin
  if gSysParam.FIsManual then Exit;
  Timer_ReadCard.Tag := Timer_ReadCard.Tag + 1;
  if Timer_ReadCard.Tag < 5 then Exit;

  Timer_ReadCard.Tag := 0;
  if FIsWeighting then Exit;

  try
    WriteLog('���ڶ�ȡ�ſ���.');
    nCard := Trim(ReadPoundCard(FLastReader, FPoundTunnel.FID));
    if nCard = '' then Exit;
    Timer_ReadCard.Enabled:=False;
    if nCard <> FLastCard then
    begin
      FLastCardDone := 0;
      //�¿�ʱ����
    end;
    
    nLast := Trunc((GetTickCount - FLastCardDone) / 1000);
    if nLast < FPoundTunnel.FCardInterval then
    begin
      nStr := '�ſ�[ %s ]��ȴ� %d �����ܹ���';
      nStr := Format(nStr, [nCard, FPoundTunnel.FCardInterval - nLast]);

      WriteLog(nStr);
      //PlayVoice(nStr);

      nStr := Format('��վ[ %s.%s ]: ',[FPoundTunnel.FID,
              FPoundTunnel.FName]) + nStr;
      WriteSysLog(nStr);
      Timer_ReadCard.Enabled:=True;
      Exit;
    end;

    FCardTmp := nCard;
    EditBill.Text := nCard;
    LoadBillItems(nCard);
  except
    on E: Exception do
    begin
      nStr := Format('��վ[ %s.%s ]: ',[FPoundTunnel.FID,
              FPoundTunnel.FName]) + E.Message;
      WriteSysLog(nStr);

      SetUIData(True);
      //����������
      Timer_ReadCard.Enabled:=True;
    end;
  end;
end;

//Desc: ��������
function TfFrameAutoPoundItem.SavePoundSale(var nDaiWc:string): Boolean;
var nStr,nFoutData: string;
    nVal,nNet,nZhikaYL: Double;
    nSQL, nPrePUse: string;
  nBrickItem:PBrickItem;
begin
  Result := False;
  //init
  nDaiWc:='';
  if FBillItems[0].FNextStatus = sFlag_TruckBFP then
  begin
    if FUIData.FPData.FValue <= 0 then
    begin
      WriteLog('���ȳ���Ƥ��');
      Timer_ReadCard.Enabled:=True;
      Exit;
    end;
    if FBillItems[0].FType = sFlag_San then
    begin
      {$IFDEF YDKP}
        {$IFDEF XHPZ}
        nNet := GetTruckEmptyValue(FUIData.FTruck, nPrePUse);
        nVal := nNet * 1000 - FUIData.FPData.FValue * 1000;

        if (nNet > 0) and (Abs(nVal) > gSysParam.FPoundSanF) then
        begin
          nStr := '����[%s]ʵʱƤ�����ϴ�,��֪ͨ˾����鳵��';
          nStr := Format(nStr, [FUIData.FTruck]);
          {$IFNDEF DEBUG}
          PlayVoice(nStr);
          {$ENDIF}

          nStr := '����[ %s ]ʵʱƤ�����ϴ�,��������:' + #13#10#13#10 +
                  '��.ʵʱƤ��: %.2f��' + #13#10 +
                  '��.��ʷƤ��: %.2f��' + #13#10 +
                  '��.�����: %.2f����' + #13#10#13#10 +
                  '�Ƿ��������?';
          nStr := Format(nStr, [FUIData.FTruck, FUIData.FPData.FValue,
                  nNet, nVal]);
          if not QueryDlg(nStr, sAsk) then
          begin
            FIsSaveing := True;
            Result:=True;
            Exit;
          end;
        end;
        {$ELSE}
        nNet := GetTruckEmptyValue(FUIData.FTruck, nPrePUse);
        if (FloatRelation(FUIData.FPData.FValue,nNet,rtGreater,100)) and (nNet>0) then
        begin
          nStr := '����[%s]ʵʱƤ�����ϴ�,����'+FormatFloat('0.00',FUIData.FPData.FValue-nNet)+'��,����ϵ��������Ա';
          nStr := Format(nStr, [FUIData.FTruck]);
          nDaiWc:=nStr;

          FIsSaveing := True;
          Result := True;
          Exit;
        end;
        {$ENDIF}
      {$ELSE}
      nNet := GetTruckEmptyValue(FUIData.FTruck, nPrePUse);
      nVal := nNet * 1000 - FUIData.FPData.FValue * 1000;

      if (nNet > 0) and (Abs(nVal) > gSysParam.FPoundSanF) then
      begin
        nStr := '����[%s]ʵʱƤ�����ϴ�,��֪ͨ˾����鳵��';
        nStr := Format(nStr, [FUIData.FTruck]);
        {$IFNDEF DEBUG}
        PlayVoice(nStr);
        {$ENDIF}

        nStr := '����[ %s ]ʵʱƤ�����ϴ�,��������:' + #13#10#13#10 +
                '��.ʵʱƤ��: %.2f��' + #13#10 +
                '��.��ʷƤ��: %.2f��' + #13#10 +
                '��.�����: %.2f����' + #13#10#13#10 +
                '�Ƿ��������?';
        nStr := Format(nStr, [FUIData.FTruck, FUIData.FPData.FValue,
                nNet, nVal]);

        WriteLog(nStr);

        if not QueryDlg(nStr, sAsk) then
        begin
          FIsSaveing := True;
          Result:=True;

          nStr := 'Ƥ�������[: %.2f����],����������ֹ����';
          nStr := Format(nStr,[nVal]);
          FDM.WriteSysLog(sFlag_PoundWuCha, FUIData.FTruck, nStr);
          Exit;
        end;
        nStr := 'Ƥ�������[: %.2f����],���������������';
        nStr := Format(nStr,[nVal]);
        FDM.WriteSysLog(sFlag_PoundWuCha, FUIData.FTruck, nStr);
      end;
      {$ENDIF}
    end;
  end else
  begin
    if FUIData.FMData.FValue <= 0 then
    begin
      WriteLog('���ȳ���ë��');
      Exit;
    end;
  end;

  if (FUIData.FPData.FValue > 0) and (FUIData.FMData.FValue > 0) then
  begin
    if FBillItems[0].FYSValid <> sFlag_Yes then //�ж��Ƿ�ճ�����
    begin
      if FUIData.FPData.FValue > FUIData.FMData.FValue then
      begin
        WriteLog('Ƥ��ӦС��ë��');
        nStr := '���������쳣������ϵ˾��������Ա';
        nDaiWc:=nStr;
        FIsSaveing := True;
        Result := True;
        Exit;
      end;

      nNet := FUIData.FMData.FValue - FUIData.FPData.FValue;
      //����
      nVal := nNet * 1000 - FInnerData.FValue * 1000;
      //�뿪Ʊ�����(����)

      with gSysParam,FBillItems[0] do
      begin
        nBrickItem := getBrickItem(FStockNo);
        if Assigned(nBrickItem) then
        begin
        	nVal := nNet * 1000 - FInnerData.FValue * nbrickitem.FTonOfPerSquare * 1000;
          if nVal>0 then
          begin
            FMemPoundBrickZ := Float2Float(FInnerData.FValue * FMemPoundBrickZ_db * 1000,
                                         cPrecision, False);
          end
          else begin
            FMemPoundBrickF := Float2Float(FInnerData.FValue * FMemPoundBrickF_db * 1000,
                                         cPrecision, False);
          end;
        end
        else if (Fszbz='1') and (FType=sFlag_San) then
        begin
          FMemPoundSanZ := Float2Float(FInnerData.FValue * FMemPoundSanZ_db * 1000,
                                         cPrecision, False);
          FMemPoundSanF := Float2Float(FInnerData.FValue * FMemPoundSanF_db * 1000,
                                         cPrecision, False);
          EditZWc.Text:=FloatToStr(FMemPoundSanZ);
          EditFWc.Text:=FloatToStr(FMemPoundSanF);
        end
        else if FDaiPercent and (FType = sFlag_Dai) then
        begin
          FPoundDaiZ := Float2Float(FInnerData.FValue * FPoundDaiZ_1 * 1000,
                                         cPrecision, False);
          FPoundDaiF := Float2Float(FInnerData.FValue * FPoundDaiF_1 * 1000,
                                         cPrecision, False);
          EditZWc.Text:=FloatToStr(FPoundDaiZ);
          EditFWc.Text:=FloatToStr(FPoundDaiF);
        end;

        if Assigned(nBrickItem) then
        begin
          nVal := nNet * 1000 - FInnerData.FValue * nbrickitem.FTonOfPerSquare * 1000;
          
          if ((nVal>0) and (FMemPoundBrickZ>0) and(nVal>FMemPoundBrickZ)) or
             ((nVal<0) and (FMemPoundBrickF>0) and (Abs(nval)>FMemPoundBrickF)) then
          begin
            WriteLog('�����ֵ��'+floattostr(FMemPoundBrickZ)+'  �����ֵ��'+floattostr(FMemPoundBrickF));
            nStr := '����[%s]ʵ��װ�������ϴ���֪ͨ˾���˶�';
            nStr := Format(nStr, [FTruck]);

            nStr := '����[ %s ]ʵ��װ�������ϴ�,��������:' + #13#10#13#10 +
                    '������: %.2f��,' +// #13#10 +
                    'װ����: %.2f��,';// +// #13#10 +
                    //'�����: %.2f����';
            if nVal > 0.000001 then
              nStr := nStr+'��ж%.2f����';
            if nVal < 0.000001 then
              nStr := nStr+'�벹%.2f����';

            nSQL := 'Insert into '+sTable_PoundDevia+' (D_Bill,D_Truck,D_CusID,D_CusName,'+
                    'D_StockName,D_PlanValue,D_JValue,D_DeviaValue,D_Date) values ('''+FID+
                    ''','''+FTruck+''','''+FCusID+''','''+FCusName+''','''+FStockName+
                    ''','''+FloatToStr(FInnerData.FValue)+''','''+FormatFloat('0.00',nNet)+
                    ''','''+FormatFloat('0.00',nVal)+''','''+FormatDateTime('yyyy-mm-dd hh:mm:ss',Now)+''')';
            FDM.ExecuteSQL(nSQL);
            nStr := Format(nStr, [FTruck, FInnerData.FValue*nbrickitem.FTonOfPerSquare, nNet, Abs(nVal)]);
            if not VerifyManualEventRecord(FID + sFlag_ManualC, nStr) then
            begin
              AddManualEventRecord(FID + sFlag_ManualC, FTruck, nStr, '����',sFlag_Solution_YN, '��װ');
              WriteLog(nStr);
              nStr := '����[n1]%s�����뿪Ʊ�����ϴ�,��˶�';
              nStr := Format(nStr, [FTruck]);
              {$IFNDEF DEBUG}
              PlayVoice(nStr);
              {$ENDIF}
              nDaiWc := nStr;
              Result:=True;
              Exit;
            end;
          end;
        end
        else if ((FType = sFlag_Dai) and (
            ((nVal > 0) and (FPoundDaiZ > 0) and (nVal > FPoundDaiZ)) or
            ((nVal < 0) and (FPoundDaiF > 0) and (Abs(nVal) > FPoundDaiF)))) then
        begin
          WriteLog('�����ֵ��'+floattostr(FPoundDaiZ)+'  �����ֵ��'+floattostr(FPoundDaiF));
          nStr := '����[%s]ʵ��װ�������ϴ���֪ͨ˾���������';
          nStr := Format(nStr, [FTruck]);

          nStr := '����[ %s ]ʵ��װ�������ϴ�,��������:' + #13#10#13#10 +
                  '������: %.2f��,' +// #13#10 +
                  'װ����: %.2f��,';// +// #13#10 +
                  //'�����: %.2f����';
          if nVal > 0.000001 then
            nStr := nStr+'��ж��%.2f����';
          if nVal < 0.000001 then
            nStr := nStr+'�벹��%.2f����';

          nSQL := 'Insert into '+sTable_PoundDevia+' (D_Bill,D_Truck,D_CusID,D_CusName,'+
                  'D_StockName,D_PlanValue,D_JValue,D_DeviaValue,D_Date) values ('''+FID+
                  ''','''+FTruck+''','''+FCusID+''','''+FCusName+''','''+FStockName+
                  ''','''+FloatToStr(FInnerData.FValue)+''','''+FormatFloat('0.00',nNet)+
                  ''','''+FormatFloat('0.00',nVal)+''','''+FormatDateTime('yyyy-mm-dd hh:mm:ss',Now)+''')';
          FDM.ExecuteSQL(nSQL);

          nStr := Format(nStr, [FTruck, FInnerData.FValue, nNet, Abs(nVal)]);

          if not VerifyManualEventRecord(FID + sFlag_ManualC, nStr) then
          begin
            AddManualEventRecord(FID + sFlag_ManualC, FTruck, nStr, '����',sFlag_Solution_YN, '��װ');
            WriteLog(nStr);
            nStr := '����[n1]%s�����뿪Ʊ�����ϴ�,�貹��';
            if nVal>0.000001 then
            begin
              nStr := '����[n1]%s�����뿪Ʊ�����ϴ�,��ж��';
            end;
            nStr := Format(nStr, [FTruck]);
            {$IFNDEF DEBUG}
            PlayVoice(nStr);
            {$ENDIF}
            nDaiWc:=nStr;
            Result:=True;
            Exit;
          end;
        end
        else if ((Fszbz='1') and (FType = sFlag_San) and (
            ((nVal > 0) and (FMemPoundSanZ > 0) and (nVal > FMemPoundSanZ)) or
            ((nVal < 0) and (FMemPoundSanF > 0) and (Abs(nVal) > FMemPoundSanF)))) then
        begin
          WriteLog('�����ֵ��'+floattostr(FMemPoundSanZ)+'  �����ֵ��'+floattostr(FMemPoundSanF));
          nStr := '����[%s]ʵ��װ�������ϴ���֪ͨ˾���˶�';
          nStr := Format(nStr, [FTruck]);

          nStr := '����[ %s ]ʵ��װ�������ϴ�,��������:' + #13#10#13#10 +
                  '������: %.2f��,' +// #13#10 +
                  'װ����: %.2f��,';// +// #13#10 +
                  //'�����: %.2f����';
          if nVal > 0.000001 then
            nStr := nStr+'��ж%.2f����';
          if nVal < 0.000001 then
            nStr := nStr+'�벹%.2f����';

          nSQL := 'Insert into '+sTable_PoundDevia+' (D_Bill,D_Truck,D_CusID,D_CusName,'+
                  'D_StockName,D_PlanValue,D_JValue,D_DeviaValue,D_Date) values ('''+FID+
                  ''','''+FTruck+''','''+FCusID+''','''+FCusName+''','''+FStockName+
                  ''','''+FloatToStr(FInnerData.FValue)+''','''+FormatFloat('0.00',nNet)+
                  ''','''+FormatFloat('0.00',nVal)+''','''+FormatDateTime('yyyy-mm-dd hh:mm:ss',Now)+''')';
          FDM.ExecuteSQL(nSQL);

          nStr := Format(nStr, [FTruck, FInnerData.FValue, nNet, Abs(nVal)]);

          if not VerifyManualEventRecord(FID + sFlag_ManualC, nStr) then
          begin
            AddManualEventRecord(FID + sFlag_ManualC, FTruck, nStr, '����',sFlag_Solution_YN, '��װ');
            WriteLog(nStr);
            nStr := '����[n1]%s�����뿪Ʊ�����ϴ�,��˶�';
            nStr := Format(nStr, [FTruck]);
            {$IFNDEF DEBUG}
            PlayVoice(nStr);
            {$ENDIF}
            nDaiWc:=nStr;
            Result:=True;
            Exit;
          end;
        end;
        nZhikaYL:=GetZhikaYL(FRecID);
        if FType = sFlag_Dai then
        begin
          if nZhikaYL<0 then
          begin
            Result:=True;
            nStr := '����[ %s ]����������,��������:' + #13#10#13#10 +
                    '������: %.2f��,' + #13#10 +
                    'װ����: %.2f��,' + #13#10 +
                    '�貹����: %.2f��';
            nStr := Format(nStr, [FTruck, nZhikaYL, FInnerData.FValue, Abs(nZhikaYL)]);
            nDaiWc:=nStr;
            Exit;
          end;
        end else
        begin
          if nZhikaYL+FInnerData.FValue-nNet<0 then
          begin
            Result:=True;
            nStr := '����[ %s ]����������,��������:' + #13#10#13#10 +
                    '������: %.2f��,' + #13#10 +
                    'װ����: %.2f��,' + #13#10 +
                    '�貹����: %.2f��';
            nStr := Format(nStr, [FTruck, nZhikaYL, nNet, Abs(nZhikaYL+FInnerData.FValue-nNet)]);
            nDaiWc:=nStr;
            Exit;
          end;
        end;
        {$IFDEF ZXKP}
        if (FType = sFlag_San) and
          (Pos('����',FStockName)<=0) and
          (nNet > 0) and (nNet < 48) then
        begin
          nStr := '����[%s]���ؽ�С,��֪ͨ˾��Ա��鳵��';
          nStr := Format(nStr, [FUIData.FTruck]);
          {$IFNDEF DEBUG}
          PlayVoice(nStr);
          {$ENDIF}

          nStr := '����[ %s ]����С��48��,��������:' + #13#10#13#10 +
                  '��.Ƥ��: %.2f��' + #13#10 +
                  '��.ë��: %.2f��' + #13#10 +
                  '��.����: %.2f��' + #13#10#13#10 +
                  '�Ƿ��������?';
          nStr := Format(nStr, [FUIData.FTruck, FUIData.FPData.FValue,
                  FUIData.FMData.FValue, nNet]);
          if not QueryDlg(nStr, sAsk) then
          begin
            FIsSaveing := True;
            Result:=True;
            Exit;
          end;
        end;
        {$ENDIF}
      end;
    end else
    begin
      {$IFDEF YDKP}
        {$IFDEF XHPZ}
        nNet := GetTruckEmptyValue(FUIData.FTruck, nPrePUse);
        nVal := nNet * 1000 - FUIData.FPData.FValue * 1000;

        if (nNet > 0) and (Abs(nVal) > gSysParam.FPoundSanF) then
        begin
          nStr := '����[%s]ʵʱƤ�����ϴ�,��֪ͨ˾����鳵��';
          nStr := Format(nStr, [FUIData.FTruck]);
          {$IFNDEF DEBUG}
          PlayVoice(nStr);
          {$ENDIF}

          nStr := '����[ %s ]ʵʱƤ�����ϴ�,��������:' + #13#10#13#10 +
                  '��.ʵʱƤ��: %.2f��' + #13#10 +
                  '��.��ʷƤ��: %.2f��' + #13#10 +
                  '��.�����: %.2f����' + #13#10#13#10 +
                  '�Ƿ��������?';
          nStr := Format(nStr, [FUIData.FTruck, FUIData.FPData.FValue,
                  nNet, nVal]);
          if not QueryDlg(nStr, sAsk) then
          begin
            FIsSaveing := True;
            Result:=True;
            Exit;
          end;
        end;
        {$ELSE}
        if FBillItems[0].FType = sFlag_San then
        begin
          nNet := GetTruckEmptyValue(FUIData.FTruck, nPrePUse);
          if (FloatRelation(FUIData.FPData.FValue,nNet,rtGreater,100)) and (nNet>0) then
          begin
            nStr := '����[%s]ʵʱƤ�����ϴ�,����'+FormatFloat('0.00',FUIData.FPData.FValue-nNet)+'��,����ϵ��������Ա';
            nStr := Format(nStr, [FUIData.FTruck]);
            nDaiWc:=nStr;

            FIsSaveing := True;
            Result := True;
            Exit;
          end;
        end else
        begin
          nNet := FUIData.FMData.FValue;
          nVal := nNet * 1000 - FUIData.FPData.FValue * 1000;

          if (nNet > 0) and (Abs(nVal) > gSysParam.FPoundSanF) then
          begin
            nStr := '����[%s]ʵʱƤ�����ϴ�,��˾����鳵��';
            nStr := Format(nStr, [FUIData.FTruck]);
            {$IFNDEF DEBUG}
            PlayVoice(nStr);
            {$ENDIF}

            nStr := '����[ %s ]ʵʱƤ�����ϴ�,��������:' + #13#10#13#10 +
                    '��.ʵʱƤ��: %.2f��' + #13#10 +
                    '��.��ʷƤ��: %.2f��' + #13#10 +
                    '��.�����: %.2f����' + #13#10#13#10 +
                    '�Ƿ��������?';
            nStr := Format(nStr, [FUIData.FTruck, nNet,
                           FUIData.FPData.FValue, nVal]);
            if not QueryDlg(nStr, sAsk) then
            begin
              FIsSaveing := True;
              Result:=True;
              Exit;
            end;
          end;
        end;
        {$ENDIF}
      {$ELSE}
      nNet := FUIData.FMData.FValue;
      nVal := nNet * 1000 - FUIData.FPData.FValue * 1000;

      if (nNet > 0) and (Abs(nVal) > gSysParam.FEmpTruckWc) then
      begin
        nStr := '����[%s]ʵʱƤ�����ϴ�,��˾����ϵ˾������Ա��鳵��';
        nStr := Format(nStr, [FUIData.FTruck]);
        nDaiWc:=nStr;

        begin
          FIsSaveing := True;
          Result:=True;
          Exit;
        end;
      end;
      {$ENDIF}
    end;
  end;
  //WriteLog('null');

  with FBillItems[0] do
  begin
    FPModel := FUIData.FPModel;
    FFactory := gSysParam.FFactNum;

    with FPData do
    begin
      FStation := FPoundTunnel.FID;
      FValue := FUIData.FPData.FValue;
      FOperator := gSysParam.FUserID;
    end;

    with FMData do
    begin
      FStation := FPoundTunnel.FID;
      FValue := FUIData.FMData.FValue;
      FOperator := gSysParam.FUserID;
    end;

    FPoundID := sFlag_Yes;
    //��Ǹ����г�������
    Result := SaveLadingBills(nFoutData,FNextStatus, FBillItems, FPoundTunnel);
    //�������
    WriteLog('save result: '+nFoutData);
    if Pos('����',nFoutData)>0 then
    begin
      nDaiWc:=nFoutData;
      FIsSaveing := True;
      Result:=True;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ԭ���ϻ���ʱ
function TfFrameAutoPoundItem.SavePoundData(var nHint:string): Boolean;
var
  nStr,nNextStatus: string;
  nRestValue, nNetValue: Double;
  nIfCheck:Boolean;
begin
  Result := False;
  //init

  if (FUIData.FPData.FValue <= 0) and (FUIData.FMData.FValue <= 0) then
  begin
    WriteLog('���ȳ���');
    Exit;
  end;

  if (FUIData.FPData.FValue > 0) and (FUIData.FMData.FValue > 0) then
  begin
    if FUIData.FPData.FValue > FUIData.FMData.FValue then
    begin
      WriteLog('Ƥ��ӦС��ë��');
      Exit;
    end;
  end;

  SetLength(FBillItems, 1);
  FBillItems[0] := FUIData;
  //�����û���������

  with FBillItems[0] do
  begin
    FFactory := gSysParam.FFactNum;
    //xxxxx
    
    if FNextStatus = sFlag_TruckBFP then
         FPData.FStation := FPoundTunnel.FID
    else FMData.FStation := FPoundTunnel.FID;

  end;

  if (FCardUsed = sFlag_other) then
  begin
    if FBillItems[0].FStatus = sFlag_TruckIn then
      nNextStatus := sFlag_TruckBFP
    else nNextStatus := sFlag_TruckBFM;

    if FBillItems[0].FPData.FStation='' then FBillItems[0].FPData.FStation := FPoundTunnel.FID;
    if FBillItems[0].FMData.FStation='' then FBillItems[0].FMData.FStation := FPoundTunnel.FID;

    if FBillItems[0].FPData.FOperator='' then FBillItems[0].FPData.FOperator := gSysParam.FUserID;
    if FBillItems[0].FMData.FOperator='' then FBillItems[0].FMData.FOperator := gSysParam.FUserID;

    Result := SaveTruckPoundItem(FPoundTunnel, FBillItems);

    if Result  then
    begin
      Result := SavePurchaseOrders(nNextStatus, FBillItems,FPoundTunnel);
    end;

    Exit;
  end
  else if FCardUsed = sFlag_Provide then
  begin
    with FBillItems[0] do
    begin
      nRestValue := GetPurchRestValue(FRecID,nIfCheck);
      if nIfCheck then
      begin
        nNetValue := Abs(FUIData.FPData.FValue-FUIData.FMData.FValue);
        if nRestValue-nNetValue < 0 then
        begin
          nStr := '����[ %s ]����������,��������:' + #13#10#13#10 +
                  '������: %.2f��,' + #13#10 +
                  'װ����: %.2f��,' + #13#10 +
                  '�貹����: %.2f��';
          nStr := Format(nStr, [FTruck, nRestValue, nNetValue, Abs(nRestValue-nNetValue)]);
          nHint := nStr;
          Result := True;
          Exit;
        end;
      end;
    end;
    //xxxxx
    {$IFDEF GLPURCH}
    if FBillItems[0].FStatus = sFlag_TruckIn then
         nNextStatus := sFlag_TruckBFP
    else nNextStatus := sFlag_TruckBFM;
    {$ELSE}
    if (FBillItems[0].FStatus = sFlag_TruckXH) or (FBillItems[0].FStatus = sFlag_TruckBFP) then
         nNextStatus := sFlag_TruckBFM
    else nNextStatus := sFlag_TruckBFP;
    {$ENDIF}
    Result := SavePurchaseOrders(nNextStatus, FBillItems,FPoundTunnel);
  end else Result := SaveTruckPoundItem(FPoundTunnel, FBillItems);
  //�������
end;

//Desc: ��ȡ��ͷ����
procedure TfFrameAutoPoundItem.OnPoundDataEvent(const nValue: Double);
begin
  try
    OnPoundData(nValue);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('��վ[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      SetUIData(True);
      Timer_ReadCard.Enabled:=True;
    end;
  end;
end;

//Desc: �����ͷ����
procedure TfFrameAutoPoundItem.OnPoundData(const nValue: Double);
var nVal: Int64;
    nRet: Boolean;
    nStr: string;
    nResValue: Double;
begin
  FLastBT := GetTickCount;
  EditValue.Text := Format('%.2f', [nValue]);
  nResValue := StrToFloat(EditValue.Text);
  if nResValue < FEmptyPoundWeight then //�հ�
  begin
    //WriteLog(FloatToStr(nValue)+'  EmptyPoundWeight: '+Floattostr(FEmptyPoundWeight));
    if FEmptyPoundInit = 0 then
      FEmptyPoundInit := GetTickCount;
    nVal := GetTickCount - FEmptyPoundInit;

    if nVal > FEmptyPoundIdleLong then
    begin
      FEmptyPoundInit := 0;
      Timer_SaveFail.Enabled := True;

      WriteSysLog('ˢ����˾������Ӧ,�˳�����.');
      Exit;
    end;

    if (nVal > FEmptyPoundIdleShort) and (FLastCardDone > 0) and
       (GetTickCount - FLastCardDone > nVal) then
    begin
      FEmptyPoundInit := 0;
      Timer_SaveDone.Enabled := True;

      WriteSysLog('˾�����°�,�˳�����.');
      Exit;
    end; //�ϴα���ɹ��󣬿հ���ʱ����Ϊ�����°�
    Exit;
  end else
  begin
    FEmptyPoundInit := 0;
    if FLastCardDone > 0 then
      FLastCardDone := GetTickCount;
    //����������Ϻ�δ�°�
  end;
  //WriteLog(FloatToStr(nValue)+'  �հ�У����ϣ���ʼִ��ҵ��');
  
  if FIsSaveing then Exit;
  //���ڱ�������
  if not FIsWeighting then Exit;
  //���ڳ�����
  if gSysParam.FIsManual then Exit;
  //�ֶ�ʱ��Ч

  if FPoundTunnel.FPort.FMaxValue>0 then
  begin
    if nResValue>FPoundTunnel.FPort.FMaxValue then
    begin
      WriteLog(FUIData.FTruck+'����ֵ: '+FormatFloat('0.00',nResValue));
      {$IFNDEF DEBUG}
      PlayVoice(FUIData.FTruck+'�ѳ���,�뵽���߶�λ������.');
      {$ENDIF}
      FIsWeighting:= False;

      FLastCardDone := GetTickCount;
      nStr:=OpenDoor(FCardTmp,'1');
      WritesysLog(FCardTmp+'��������բ');
      Exit;
    end;
  end;

  if (FCardUsed = sFlag_Provide) or (FCardUsed = sFlag_other) then
  begin
    if FInnerData.FPData.FValue > 0 then
    begin
      if nResValue <= FInnerData.FPData.FValue then
      begin
        FUIData.FPData := FInnerData.FMData;
        FUIData.FMData := FInnerData.FPData;

        FUIData.FPData.FValue := nResValue;
        FUIData.FNextStatus := sFlag_TruckBFP;
        //�л�Ϊ��Ƥ��
      end else
      begin
        FUIData.FPData := FInnerData.FPData;
        FUIData.FMData := FInnerData.FMData;

        FUIData.FMData.FValue := nResValue;
        FUIData.FNextStatus := sFlag_TruckBFM;
        //�л�Ϊ��ë��
      end;
    end else FUIData.FPData.FValue := nResValue;
  end else
  if FBillItems[0].FNextStatus = sFlag_TruckBFP then
       FUIData.FPData.FValue := nResValue
  else FUIData.FMData.FValue := nResValue;

  SetUIData(False);
  AddSample(nResValue);
  if not IsValidSamaple then Exit;
  //������֤��ͨ��
  {$IFNDEF DEBUG}
  if IsTunnelOK(FPoundTunnel.FID)=sFlag_No then
  begin
    InitSamples;//��ղ�������
    PlayVoice('����δͣ��λ,���ƶ�����.');
    Exit;
  end;
  {$ENDIF}

  FIsSaveing := True;
  FPoundVoice:='';
  if (FCardUsed = sFlag_Provide) or (FCardUsed = sFlag_other) then
       nRet := SavePoundData(FPoundVoice)
  else nRet := SavePoundSale(FPoundVoice);

  if nRet then
  begin
    TimerDelay.Enabled := True;
  end;// else Timer_SaveFail.Enabled := True;
end;

procedure TfFrameAutoPoundItem.TimerDelayTimer(Sender: TObject);
var
  nStr:string;
  nRet:Boolean;
begin
  try
    TimerDelay.Enabled := False;
    FLastCardDone := GetTickCount;
    FLastCard     := FCardTmp;
    if FPoundVoice<>'' then
    begin
      {$IFDEF GGJC}
      FPoundVoice:=FPoundVoice+',��˾�������°�';
      {$ENDIF}
      {$IFNDEF debug}
      PlayVoice(FPoundVoice);
      //��������
      nStr:=TunnelOC(FPoundTunnel.FID,sFlag_Yes);
      {$ENDIF}
      //�����̵�
      {$IFDEF GGJC}
      nStr:=OpenDoor(FCardTmp,'0');
      WritesysLog(FCardTmp+'�������բ');
      Exit;
      {$ENDIF}

      {$IFDEF ZXKP}
      if GetDaoChe(FUIData.FStockNo) then
      begin
        nStr:=OpenDoor(FCardTmp,'0');
        WritesysLog(FCardTmp+'�������բ');
      end else
      begin
        nStr:=OpenDoor(FCardTmp,'1');
        WritesysLog(FCardTmp+'��������բ');
      end;
      Exit;
      {$ENDIF}

      {$IFDEF QHSN}
      if (FUIData.FNeiDao=sFlag_Yes) then
      begin
        nStr:=OpenDoor(FCardTmp,'0');
        WritesysLog(FCardTmp+'�������բ');
      end else
      begin
        nStr:=OpenDoor(FCardTmp,'1');
        WritesysLog(FCardTmp+'��������բ');
      end;
      Exit;
      {$ENDIF}
      
      if GetAutoInFactory(FUIData.FStockNo) then
      begin
        nStr:=OpenDoor(FCardTmp,'0');
        WritesysLog(FCardTmp+'�������բ');
      end else
      begin
        nStr:=OpenDoor(FCardTmp,'1');
        WritesysLog(FCardTmp+'��������բ');
      end;
      //�������ڵ�բ
    end else
    begin
      WriteSysLog(Format('�Գ���[ %s ]�������.', [FUIData.FTruck]));
      {$IFNDEF DEBUG}
      PlayVoice(#9 + FUIData.FTruck);
      //��������
      nStr:=TunnelOC(FPoundTunnel.FID,sFlag_Yes);
      {$ENDIF}
      //�����̵�
      {$IFDEF LZST}
      if (FCardUsed = sFlag_Provide) and (GetNeiDao(FUIData.FStockNo)) then
      begin
        nStr:=OpenDoor(FCardTmp,'0');
        WritesysLog(FCardTmp+'�������բ');
      end else
      begin
        nStr:=OpenDoor(FCardTmp,'1');
        WritesysLog(FCardTmp+'��������բ');
      end;
      Exit;
      {$ENDIF}
      
      {$IFDEF ZXKP}
      if GetDaoChe(FUIData.FStockNo) then
      begin
        nStr:=OpenDoor(FCardTmp,'0');
        WritesysLog(FCardTmp+'�������բ');
      end else
      begin
        nStr:=OpenDoor(FCardTmp,'1');
        WritesysLog(FCardTmp+'��������բ');
      end;
      Exit;
      {$ENDIF}

      {$IFDEF QHSN}
      if (FUIData.FNeiDao=sFlag_Yes) then
      begin
        nStr:=OpenDoor(FCardTmp,'0');
        WritesysLog(FCardTmp+'�������բ');
      end else
      begin
        nStr:=OpenDoor(FCardTmp,'1');
        WritesysLog(FCardTmp+'��������բ');
      end;
      Exit;
      {$ENDIF}

      if GetAutoInFactory(FUIData.FStockNo) then
      begin
        nStr:=OpenDoor(FCardTmp,'0');
        WritesysLog(FCardTmp+'�������բ');
      end else
      begin
        nStr:=OpenDoor(FCardTmp,'1');
        WritesysLog(FCardTmp+'��������բ');
      end;
      //�������ڵ�բ
    end;
  except
    on E: Exception do
    begin
      WriteSysLog(Format('��վ[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      //loged
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ʼ������
procedure TfFrameAutoPoundItem.InitSamples;
var nIdx: Integer;
begin
  SetLength(FValueSamples, FPoundTunnel.FSampleNum);
  FSampleIndex := Low(FValueSamples);

  for nIdx:=High(FValueSamples) downto FSampleIndex do
    FValueSamples[nIdx] := 0;
  //xxxxx
end;

//Desc: ��Ӳ���
procedure TfFrameAutoPoundItem.AddSample(const nValue: Double);
begin
  FValueSamples[FSampleIndex] := nValue;
  Inc(FSampleIndex);

  if FSampleIndex >= FPoundTunnel.FSampleNum then
    FSampleIndex := Low(FValueSamples);
  //ѭ������
end;

//Desc: ��֤�����Ƿ��ȶ�
function TfFrameAutoPoundItem.IsValidSamaple: Boolean;
var nIdx: Integer;
    nVal: Integer;
begin
  Result := False;

  for nIdx:=FPoundTunnel.FSampleNum-1 downto 1 do
  begin
    if FValueSamples[nIdx] < 0.02 then Exit;
    //����������

    nVal := Trunc(FValueSamples[nIdx] * 1000 - FValueSamples[nIdx-1] * 1000);
    if Abs(nVal) >= FPoundTunnel.FSampleFloat then Exit;
    //����ֵ����
  end;

  Result := True;
end;

procedure TfFrameAutoPoundItem.PlayVoice(const nStrtext: string);
begin
  if UpperCase(FPoundTunnel.FOptions.Values['Voice'])='NET' then
       gNetVoiceHelper.PlayVoice(nStrtext, FPoundTunnel.FID, 'pound')
  else gVoiceHelper.PlayVoice(nStrtext);
end;

procedure TfFrameAutoPoundItem.Timer_SaveFailTimer(Sender: TObject);
begin
  inherited;
  try
    Timer_SaveFail.Enabled := False;
    FLastCardDone := GetTickCount;

    Timer_ReadCard.Enabled:=True;

    gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
    //�رձ�ͷ
    SetUIData(True);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('��վ[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      //loged
    end;
  end;
end;

procedure TfFrameAutoPoundItem.Timer_SaveDoneTimer(Sender: TObject);
begin
  try
    Timer_SaveDone.Enabled := False;
    gPoundTunnelManager.ClosePort(FPoundTunnel.FID);
    //�رձ�ͷ

    Timer_ReadCard.Enabled := True;
    Timer_ReadCard.Tag := 10; //��������
    SetUIData(True);
  except
    on E: Exception do
    begin
      WriteSysLog(Format('��վ[ %s.%s ]: %s', [FPoundTunnel.FID,
                                               FPoundTunnel.FName, E.Message]));
      //loged
    end;
  end;
end;

procedure TfFrameAutoPoundItem.N1Click(Sender: TObject);
var nP: TWinControl;
begin
  nP := Parent;
  while Assigned(nP) do
  begin
    if (nP is TBaseFrame) and
       (TBaseFrame(nP).FrameID = cFI_FramePoundAuto) then
    begin
      TBaseFrame(nP).Close();
      Exit;
    end;

    nP := nP.Parent;
  end;
end;

function TfFrameAutoPoundItem.getBrickItem(
  const stockno: string): PBrickItem;
var
  i:integer;
  nItem:PBrickItem;
begin
  Result := nil;
  if Trim(stockno)='' then Exit;
  for i := 0 to FBrickItemList.Count-1 do
  begin
    nItem := PBrickItem(FBrickItemList.Items[i]);
    if nitem.Fcode=stockno then
    begin
      Result := FBrickItemList.Items[i];
      Break;
    end;
  end;
end;

procedure TfFrameAutoPoundItem.initBrickItems;
var
  nStr:string;
  nItem : PBrickItem;
  nparam:Double;
begin
  nstr := 'select * from %s where d_name=''%s''';
  nStr := Format(nStr,[sTable_SysDict,sFlag_BrickItem]);
  with FDM.QuerySQL(nStr) do
  begin
    while not Eof do
    begin
      New(nItem);
      nItem.Fcode := FieldByName('d_desc').AsString;
      nparam := FieldByName('d_ParamA').AsFloat;
      nItem.FTonOfPerSquare := nparam;
      nItem.FSquareOfPerTon := 1 / nparam;
      FBrickItemList.Add(nItem);
      Next;
    end;
  end;
end;

function TfFrameAutoPoundItem.getPrePInfo(const nTruck: string;
  var nPrePValue: Double; var nPrePMan: string;
  var nPrePTime: TDateTime): Boolean;
var
  nStr:string;
begin
  Result := False;
  nPrePValue := 0;
  nPrePMan := '';
  nPrePTime := now;
  nStr := 'select T_PrePValue,T_PrePMan,T_PrePTime from %s where t_truck=''%s'' and T_PrePUse=''%s''';
  nStr := format(nStr,[sTable_Truck,nTruck,sflag_yes]);
  writelog('getPrePInfo.sql='+nStr);
  with FDM.QuerySQL(nStr) do
  begin
    if RecordCount>0 then
    begin
      nPrePValue := FieldByName('T_PrePValue').asFloat;;
      nPrePMan := FieldByName('T_PrePMan').asString;
      nPrePTime := FieldByName('T_PrePTime').asDateTime;
      if nPrePValue>0.00001 then
      begin
        Result := True;
      end;
    end;
  end; 
end;

end.
