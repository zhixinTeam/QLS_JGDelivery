{*******************************************************************************
  ����: dmzn@163.com 2012-4-22
  ����: Ӳ������ҵ��
*******************************************************************************}
unit UHardBusiness;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, SysUtils, UMgrDBConn, UMgrParam, DB,
  UBusinessWorker, UBusinessConst, UBusinessPacker, UMgrQueue,
  UMgrHardHelper, U02NReader, UMgrERelay, UMgrRemotePrint,
  UMultiJS_Reply, UMgrLEDDisp, UMgrRFID102, UMITConst, Graphics,
  UMgrremoteSnap, UMgrVoiceNet;

procedure WhenReaderCardArrived(const nReader: THHReaderItem);
procedure WhenHYReaderCardArrived(const nReader: PHYReaderItem);
//���¿��ŵ����ͷ
procedure WhenReaderCardIn(const nCard: string; const nHost: PReaderHost);
//�ֳ���ͷ���¿���
procedure WhenReaderCardOut(const nCard: string; const nHost: PReaderHost);
//�ֳ���ͷ���ų�ʱ
procedure WhenBusinessMITSharedDataIn(const nData: string);
//ҵ���м����������
procedure WhenSaveJS(const nTunnel: PMultiJSTunnel);
//����������

procedure SendMsgToWebMall(const nLid:string;const MsgType:Integer;const nBillType:string);
//������Ϣ��΢��ƽ̨
function Do_send_event_msg(const nXmlStr: string): string;
//������Ϣ
procedure ModifyWebOrderStatus(const nLId:string;nStatus:Integer=c_WeChatStatusFinished;
                               const AWebOrderID:string='';const nNetWeight:string='0');
//�޸����϶���״̬  nStatus 0:�ѿ�����1:�ѳ���
function Do_ModifyWebOrderStatus(const nXmlStr: string): string;
//�޸����϶���״̬

function SaveDBImage(const nDS: TDataSet; const nFieldName: string;
      const nImage: string): Boolean; overload;
function SaveDBImage(const nDS: TDataSet; const nFieldName: string;
  const nImage: TGraphic): Boolean; overload;

function IsBrickProduct(const nlid:string):Boolean;
procedure WriteHardHelperLog(const nEvent: string; nPost: string = '');
function VerifySnapTruck(const nTruck,nBill,nPos,nDept: string;var nResult: string): Boolean;
//����ʶ��
implementation

uses
  ULibFun, USysDB, USysLoger, UTaskMonitor,HKVNetSDK, UFormCtrl;

const
  sPost_In   = 'in';
  sPost_Out  = 'out';

  sPost_SIn   = 'Sin';
  sPost_SOut  = 'Sout';
  sPost_PIn   = 'Pin';
  sPost_POut  = 'Pout';

function SaveDBImage(const nDS: TDataSet; const nFieldName: string;
      const nImage: string): Boolean;
var nPic: TPicture;
begin
  Result := False;
  if not FileExists(nImage) then Exit;

  nPic := nil;
  try
    nPic := TPicture.Create;
    nPic.LoadFromFile(nImage);

    SaveDBImage(nDS, nFieldName, nPic.Graphic);
    FreeAndNil(nPic);
  except
    if Assigned(nPic) then nPic.Free;
  end;
end;

function SaveDBImage(const nDS: TDataSet; const nFieldName: string;
  const nImage: TGraphic): Boolean;
var nField: TField;
    nStream: TMemoryStream;
    nBuf: array[1..MAX_PATH] of Char;
begin
  Result := False;
  nField := nDS.FindField(nFieldName);
  if not (Assigned(nField) and (nField is TBlobField)) then Exit;

  nStream := nil;
  try
    if not Assigned(nImage) then
    begin
      nDS.Edit;
      TBlobField(nField).Clear;
      nDS.Post; Result := True; Exit;
    end;
    
    nStream := TMemoryStream.Create;
    nImage.SaveToStream(nStream);
    nStream.Seek(0, soFromEnd);

    FillChar(nBuf, MAX_PATH, #0);
    StrPCopy(@nBuf[1], nImage.ClassName);
    nStream.WriteBuffer(nBuf, MAX_PATH);

    nDS.Edit;
    nStream.Position := 0;
    TBlobField(nField).LoadFromStream(nStream);

    nDS.Post;
    FreeAndNil(nStream);
    Result := True;
  except
    if Assigned(nStream) then nStream.Free;
    if nDS.State = dsEdit then nDS.Cancel;
  end;
end;

function IsBrickProduct(const nlid:string):Boolean;
var
  nDBConn: PDBWorker;
  nstr:string;
  nIdx:Integer;
begin
  Result := False;
  nStr := 'select * from %s where d_name=''%s'' and'
    +' d_desc in(select l_stockno from s_bill where l_id=''%s'')';
  nStr := Format(nStr,[sTable_SysDict,sFlag_BrickItem,nlid]);
  nDBConn := nil;
  with gParamManager.ActiveParam^ do
  begin
    nDBConn := gDBConnManager.GetConnection(FDB.FID, nIdx);
    if not Assigned(nDBConn) then
    begin
      WriteHardHelperLog('IsBrickProduct:����HM���ݿ�ʧ��(DBConn Is Null).');
      Exit;
    end;
    if not nDBConn.FConn.Connected then
    nDBConn.FConn.Connected := True;
    
    try
      with gDBConnManager.WorkerQuery(nDBConn, nStr) do
      begin
        Result := RecordCount>0;
      end;
    finally
      gDBConnManager.ReleaseConnection(nDBConn);
    end;
  end;
end;

//Date: 2014-09-15
//Parm: ����;����;����;���
//Desc: ���ص���ҵ�����
function CallBusinessCommand(const nCmd: Integer;
  const nData, nExt: string; const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerBusinessCommand;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessCommand);
    //get worker

    Result := nWorker.WorkActive(nStr);
    if Result then
         nPacker.UnPackOut(nStr, nOut)
    else nOut.FData := nStr;
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-09-05
//Parm: ����;����;����;���
//Desc: �����м���ϵ����۵��ݶ���
function CallBusinessSaleBill(const nCmd: Integer;
  const nData, nExt: string; const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerBusinessCommand;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessSaleBill);
    //get worker

    Result := nWorker.WorkActive(nStr);
    if Result then
         nPacker.UnPackOut(nStr, nOut)
    else nOut.FData := nStr;
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2015-08-06
//Parm: ����;����;����;���
//Desc: �����м���ϵ����۵��ݶ���
function CallBusinessPurchaseOrder(const nCmd: Integer;
  const nData, nExt: string; const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerBusinessCommand;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_BusinessPurchaseOrder);
    //get worker

    Result := nWorker.WorkActive(nStr);
    if Result then
         nPacker.UnPackOut(nStr, nOut)
    else nOut.FData := nStr;
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-10-16
//Parm: ����;����;����;���
//Desc: ����Ӳ���ػ��ϵ�ҵ�����
function CallHardwareCommand(const nCmd: Integer;
  const nData, nExt: string; const nOut: PWorkerBusinessCommand): Boolean;
var nStr: string;
    nIn: TWorkerBusinessCommand;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
  nPacker := nil;
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    nPacker := gBusinessPackerManager.LockPacker(sBus_BusinessCommand);
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(sBus_HardwareCommand);
    //get worker

    Result := nWorker.WorkActive(nStr);
    if Result then
         nPacker.UnPackOut(nStr, nOut)
    else nOut.FData := nStr;
  finally
    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2012-3-23
//Parm: �ſ���;��λ;�������б�
//Desc: ��ȡnPost��λ�ϴſ�ΪnCard�Ľ������б�
function GetLadingBills(const nCard,nPost: string;
 var nData: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_GetPostBills, nCard, nPost, @nOut);
  if Result then
       AnalyseBillItems(nOut.FData, nData)
  else gSysLoger.AddLog(TBusinessWorkerManager, 'ҵ�����', nOut.FData);
end;

//Date: 2014-09-18
//Parm: ��λ;�������б�
//Desc: ����nPost��λ�ϵĽ���������
function SaveLadingBills(const nPost: string; nData: TLadingBillItems): Boolean;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessSaleBill(cBC_SavePostBills, nStr, nPost, @nOut);

  if not Result then
    gSysLoger.AddLog(TBusinessWorkerManager, 'ҵ�����', nOut.FData);
  //xxxxx
end;

//Date: 2015-08-06
//Parm: �ſ���
//Desc: ��ȡ�ſ�ʹ������
function GetCardUsed(const nCard: string; var nCardType: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetCardUsed, nCard, '', @nOut);

  if Result then
       nCardType := nOut.FData
  else gSysLoger.AddLog(TBusinessWorkerManager, 'ҵ�����', nOut.FData);
  //xxxxx
end;

//Date: 2015-08-06
//Parm: �ſ���;��λ;�ɹ����б�
//Desc: ��ȡnPost��λ�ϴſ�ΪnCard�Ľ������б�
function GetLadingOrders(const nCard,nPost: string;
 var nData: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_GetPostOrders, nCard, nPost, @nOut);
  if Result then
       AnalyseBillItems(nOut.FData, nData)
  else gSysLoger.AddLog(TBusinessWorkerManager, 'ҵ�����', nOut.FData);
end;

//Date: 2015-08-06
//Parm: ��λ;�ɹ����б�
//Desc: ����nPost��λ�ϵĲɹ�������
function SaveLadingOrders(const nPost: string; nData: TLadingBillItems): Boolean;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessPurchaseOrder(cBC_SavePostOrders, nStr, nPost, @nOut);

  if not Result then
    gSysLoger.AddLog(TBusinessWorkerManager, 'ҵ�����', nOut.FData);
  //xxxxx
end;
                                                             
//------------------------------------------------------------------------------
//Date: 2013-07-21
//Parm: �¼�����;��λ��ʶ
//Desc:
procedure WriteHardHelperLog(const nEvent: string; nPost: string = '');
begin
  gDisplayManager.Display(nPost, nEvent);
  gSysLoger.AddLog(THardwareHelper, 'Ӳ���ػ�����', nEvent);
end;

{procedure BlueOpenDoor(const nReader: string);
begin
  if gHardwareHelper.ConnHelper then
       gHardwareHelper.OpenDoor(nReader)
  else gBlueReader.OpenDoor(nReader);
end;}


procedure SendMsgToWebMall(const nLid:string;const MsgType:Integer;const nBillType:string);
var
  nSql:string;
  nDs:TDataSet;

  nBills: TLadingBillItems;
  nXmlStr,nData:string;
    nIdx:Integer;
begin
  if nBillType=sFlag_Sale then
  begin
    //�����������Ϣ
    if not GetLadingBills(nLid, sFlag_BillDone, nBills) then
    begin
      Exit;
    end;
  end
  else if nBillType=sFlag_Provide then
  begin
    //���زɹ�������Ϣ
    if not GetLadingOrders(nLid, sFlag_BillDone, nBills) then
    begin
      Exit;
    end;  
  end
  else begin
    Exit;
  end;

  for nIdx := Low(nBills) to High(nBills) do
  with nBills[nIdx] do
  begin
    nXmlStr := '<?xml version="1.0" encoding="UTF-8"?>'
        +'<DATA>'
        +'<head>'
        +'<Factory>%s</Factory>'
        +'<ToUser>%s</ToUser>'
        +'<MsgType>%d</MsgType>'
        +'</head>'
        +'<Items>'
        +'	  <Item>'
        +'	      <BillID>%s</BillID>'
        +'	      <Card>%s</Card>'
        +'	      <Truck>%s</Truck>'
        +'	      <StockNo>%s</StockNo>'
        +'	      <StockName>%s</StockName>'
        +'	      <CusID>%s</CusID>'
        +'	      <CusName>%s</CusName>'
        +'	      <CusAccount>0</CusAccount>'
        +'	      <MakeDate></MakeDate>'
        +'	      <MakeMan></MakeMan>'
        +'	      <TransID></TransID>'
        +'	      <TransName></TransName>'
        +'	      <Searial></Searial>'
        +'	      <OutFact></OutFact>'
        +'	      <OutMan></OutMan>'
        +'        <NetWeight>%s</NetWeight>'
        +'	  </Item>	'
        +'</Items>'
        +'   <remark/>'
        +'</DATA>';
    nXmlStr := Format(nXmlStr,[gSysParam.FFactory, FCusID, MsgType,//cSendWeChatMsgType_DelBill,
               FID, FCard, FTruck, FStockNo, FStockName, FCusID, FCusName,FloatToStr(FValue)]);
    nXmlStr := PackerEncodeStr(nXmlStr);
    nData := Do_send_event_msg(nXmlStr);
    gSysLoger.AddLog(nData);

    if ndata<>'' then
    begin
      WriteHardHelperLog(nData, sPost_Out);
    end;
  end;
end;

//������Ϣ
function Do_send_event_msg(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_WeChat_send_event_msg, nXmlStr, '', @nOut) then
    Result := nOut.FData;
end;

//�޸����϶���״̬
procedure ModifyWebOrderStatus(const nLId:string;nStatus:Integer;const AWebOrderID:string;const nNetWeight:string);
var
  nXmlStr,nData,nSql:string;
  nDBConn: PDBWorker;
  nWebOrderId:string;
  nIdx:Integer;
begin
  nWebOrderId := AWebOrderID;
  nDBConn := nil;

  if nWebOrderId='' then
  begin
    with gParamManager.ActiveParam^ do
    begin
      try
        nDBConn := gDBConnManager.GetConnection(FDB.FID, nIdx);
        if not Assigned(nDBConn) then
        begin
  //        WriteNearReaderLog('����HM���ݿ�ʧ��(DBConn Is Null).');
          Exit;
        end;
        if not nDBConn.FConn.Connected then
        nDBConn.FConn.Connected := True;

        //��ѯ�����̳Ƕ���
        nSql := 'select WOM_WebOrderID from %s where WOM_LID=''%s''';
        nSql := Format(nSql,[sTable_WebOrderMatch,nLId]);

        with gDBConnManager.WorkerQuery(nDBConn, nSql) do
        begin
          if recordcount>0 then
          begin
            nWebOrderId := FieldByName('WOM_WebOrderID').asstring;
          end;
        end;

      finally
        gDBConnManager.ReleaseConnection(nDBConn);
      end;
    end;
  end;

  if nWebOrderId='' then Exit;
  
  nXmlStr := '<?xml version="1.0" encoding="UTF-8"?>'
            +'<DATA>'
            +'<head><ordernumber>%s</ordernumber>'
            +'<status>%d</status>'
            +'<NetWeight>%s</NetWeight>'
            +'</head>'
            +'</DATA>';
  nXmlStr := Format(nXmlStr,[nWebOrderId,nStatus,nNetWeight]);
  nXmlStr := PackerEncodeStr(nXmlStr);

  nData := Do_ModifyWebOrderStatus(nXmlStr);
  gSysLoger.AddLog(nData);

  if ndata<>'' then
  begin
    WriteHardHelperLog(nData, sPost_Out);
  end;
end;

//�޸����϶���״̬
function Do_ModifyWebOrderStatus(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_WeChat_complete_shoporders, nXmlStr, '', @nOut) then
    Result := nOut.FData;
end;

//Date: 2017-10-16
//Parm: ����;��λ;ҵ��ɹ�
//Desc: �����Ÿ�����
procedure MakeGateSound(const nText,nPost: string; const nSucc: Boolean);
var nStr: string;
    nInt: Integer;
begin
  try
    if nSucc then
         nInt := 2
    else nInt := 3;

    gHKSnapHelper.Display(nPost, nText, nInt);
    //С����ʾ

    gNetVoiceHelper.PlayVoice(nText, nPost);
    //��������
    WriteHardHelperLog(nText+'��λ:'+nPost);
  except
    on nErr: Exception do
    begin
      nStr := '����[ %s ]����ʧ��,����: %s';
      nStr := Format(nStr, [nPost, nErr.Message]);
      WriteHardHelperLog(nStr);
    end;
  end;
end;

//Date: 2012-4-22
//Parm: ����
//Desc: ��nCard���н���
procedure MakeTruckIn(const nCard,nReader,nPost,nDept: string);
var nStr,nTruck,nCardType,nSnapStr,nPos: string;
    nIdx,nInt: Integer;
    nPLine: PLineItem;
    nPTruck: PTruckItem;
    nTrucks: TLadingBillItems;
    nRet: Boolean;
    nErrNum: Integer;
    nDB: PDBWorker;
begin
  if gTruckQueueManager.IsTruckAutoIn and (GetTickCount -
     gHardwareHelper.GetCardLastDone(nCard, nReader) < 2 * 60 * 1000) then
  begin
    gHardwareHelper.SetReaderCard(nReader, nCard);
    Exit;
  end; //ͬ��ͷͬ��,��2�����ڲ������ν���ҵ��.

  nCardType := '';
  if not GetCardUsed(nCard, nCardType) then Exit;

  if nPost = '' then
    nPos := sPost_SIn
  else
    nPos := nPost;

  if nCardType = sFlag_Other then   //��ʱ������
  begin
    nDB := nil;
    with gParamManager.ActiveParam^ do
    Try
      nDB := gDBConnManager.GetConnection(FDB.FID, nErrNum);
      if not Assigned(nDB) then
      begin
        WriteHardHelperLog('����HM���ݿ�ʧ��(DBConn Is Null).');
        Exit;
      end;

      nStr := 'select * from %s where o_card=''%s''';
      nStr := Format(nStr, [sTable_cardother, nCard]);
      with gDBConnManager.WorkerQuery(nDB,nStr) do
      begin
        if RecordCount < 1 then
        begin
          nStr := '��ȡ�ſ�[ %s ]������Ϣʧ��.';
          nStr := Format(nStr, [nCard]);

          WriteHardHelperLog(nStr, sPost_In);
          {$IFDEF RemoteSnap}
          nStr := '��ȡ�ſ���Ϣʧ��';
          MakeGateSound(nStr, nPos, False);
          {$ENDIF}
          Exit;
        end;
        if FieldByName('O_InTime').IsNull then
        begin
          {$IFDEF RemoteSnap}
          if not VerifySnapTruck(FieldByName('I_Truck').AsString,'',
                                 nPos,nDept,nSnapStr) then
          begin
            MakeGateSound(nSnapStr, nPos, False);
            Exit;
          end;
          nStr := nSnapStr + ',�����';
          MakeGateSound(nStr, nPos, True);
          {$ENDIF}

          gHYReaderManager.OpenDoor(nReader);//̧��
          nStr := '��ʱ��[ %s ]����.';
          nStr := Format(nStr, [nCard]);

          WriteHardHelperLog(nStr, sPost_In);
          nStr := 'Update %s Set O_InTime=getdate(),o_status=''%s'',o_nextstatus=''%s'' Where o_card=''%s''';
          nStr := Format(nStr, [sTable_cardother, sFlag_TruckIn,sFlag_TruckBFP,nCard]);
          //xxxxx

          gDBConnManager.WorkerExec(nDB, nStr);
        end;
      end;
//      nStr := 'select * from %s Where (o_card=''%s'') and '+
//              '(I_InDate is not null) and (I_OutDate is not null) ';
//      nStr := Format(nStr, [sTable_cardother, nCard]);
//      with gDBConnManager.WorkerQuery(nDB,nStr) do
//      if RecordCount > 0 then
//      begin
//        nStr := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
//        nStr := Format(nStr, [sTable_Card, sFlag_CardIdle, nCard]);
//        gDBConnManager.WorkerExec(nDB, nStr);
//
//        nStr := 'Update %s Set I_Card=''ע''+I_Card Where I_Card=''%s''';
//        nStr := Format(nStr, [sTable_cardother, nCard]);
//        gDBConnManager.WorkerExec(nDB, nStr);
//      end;
    finally
      gDBConnManager.ReleaseConnection(nDB);
    end;
//    Exit;
  end;

  if nCardType = sFlag_ST then    //���ſ�����
  begin
    nDB := nil;
    with gParamManager.ActiveParam^ do
    Try
      nDB := gDBConnManager.GetConnection(FDB.FID, nErrNum);
      if not Assigned(nDB) then
      begin
        WriteHardHelperLog('����HM���ݿ�ʧ��(DBConn Is Null).');
        Exit;
      end;
      nStr := 'select * from %s Where I_Card=''%s'' ';
      nStr := Format(nStr, [sTable_STInOutFact, nCard]);
      with gDBConnManager.WorkerQuery(nDB,nStr) do
      begin
        if RecordCount < 1 then
        begin
          nStr := '��ȡ�ſ�[ %s ]������Ϣʧ��.';
          nStr := Format(nStr, [nCard]);

          WriteHardHelperLog(nStr, sPost_In);
          {$IFDEF RemoteSnap}
          nStr := '��ȡ�ſ���Ϣʧ��';
          MakeGateSound(nStr, nPos, False);
          {$ENDIF}
          Exit;
        end;
        {$IFDEF RemoteSnap}
        if not VerifySnapTruck(FieldByName('I_Truck').AsString,'',
                               nPos,nDept,nSnapStr) then
        begin
          MakeGateSound(nSnapStr, nPos, False);
          Exit;
        end;
        nStr := nSnapStr + ',�����';
        MakeGateSound(nStr, nPos, True);
        {$ENDIF}

        nTruck:=FieldByName('I_truck').AsString;
        gHYReaderManager.OpenDoor(nReader);//̧��
        nStr := '%s���ſ�[ %s ]����.';
        nStr := Format(nStr, [nTruck,nCard]);

        WriteHardHelperLog(nStr, sPost_In);
        nStr := 'Insert into %s (I_Card,I_truck,I_Date,I_InDate) Values (''%s'',''%s'',getdate(),getdate()) ';
        nStr := Format(nStr, [sTable_STInOutFact, nCard,nTruck]);
        //xxxxx
        gDBConnManager.WorkerExec(nDB, nStr);
      end;
    finally
      gDBConnManager.ReleaseConnection(nDB);
    end;
    Exit;
  end;

  if (nCardType = sFlag_Provide) then
    nRet := GetLadingOrders(nCard, sFlag_TruckIn, nTrucks)
  else if nCardType=sflag_sale then
    nRet := GetLadingBills(nCard, sFlag_TruckIn, nTrucks)
  else if (nCardType=sflag_other) then
  begin
    nRet := GetLadingOrders(nCard, sFlag_TruckIn, nTrucks);
    for nIdx := Low(nTrucks) to High(nTrucks) do
    begin
      nTrucks[nIdx].FSelected := True;
    end;
  end;

  if not nRet then
  begin
    nStr := '��ȡ�ſ�[ %s ]������Ϣʧ��.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr, sPost_In);
    {$IFDEF RemoteSnap}
    nStr := '��ȡ�ſ���Ϣʧ��';
    MakeGateSound(nStr, nPos, False);
    {$ENDIF}
    Exit;
  end;
  
  if Length(nTrucks) < 1 then
  begin
    nStr := '�ſ�[ %s ]û����Ҫ��������.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr, sPost_In);
    {$IFDEF RemoteSnap}
    nStr := '���ȵ���Ʊ�Ұ���ҵ��';
    MakeGateSound(nStr, nPos, False);
    {$ENDIF}
    Exit;
  end;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    //δ����,���ѽ���
    {$IFDEF YDKP}
      {$IFDEF XHPZ}
      if (FStatus = sFlag_TruckNone) or (FStatus = sFlag_TruckIn) then Continue;
      {$ELSE}
      if (FStatus = sFlag_TruckNone) then Continue;
      {$ENDIF}
    {$ELSE}
    if (FStatus = sFlag_TruckNone) or (FStatus = sFlag_TruckIn) then Continue;
    {$ENDIF}
    nStr := '����[ %s ]��һ״̬Ϊ:[ %s ],����ˢ����Ч.';
    nStr := Format(nStr, [FTruck, TruckStatusToStr(FNextStatus)]);

    WriteHardHelperLog(nStr, sPost_In);
    {$IFDEF RemoteSnap}
    nStr := '����[ %s ]���ܽ���,Ӧ��ȥ[ %s ]';
    nStr := Format(nStr, [FTruck, TruckStatusToStr(FNextStatus)]);
    MakeGateSound(nStr, nPos, False);
    {$ENDIF}
    Exit;
  end;

  if nTrucks[0].FStatus = sFlag_TruckIn then
  begin
    {$IFDEF GGJC}
    gHardwareHelper.SetCardLastDone(nCard, nReader);
    gHardwareHelper.SetReaderCard(nReader, nCard);
    {$ELSE}
    if gTruckQueueManager.IsTruckAutoIn then
    begin
      gHardwareHelper.SetCardLastDone(nCard, nReader);
      gHardwareHelper.SetReaderCard(nReader, nCard);
    end else
    begin
      gHYReaderManager.OpenDoor(nReader);
      //̧��

      nStr := '����[ %s ]�ٴ�̧�˲���.';
      nStr := Format(nStr, [nTrucks[0].FTruck]);
      WriteHardHelperLog(nStr, sPost_In);
    end;
    {$ENDIF}
    Exit;
  end;

  if nCardType = sFlag_Provide then
  begin
    {$IFDEF RemoteSnap}
    if (not (nTrucks[0].FNeiDao=sFlag_Yes)) then//�ڵ����ж�
    if (nTrucks[0].FStatus = sFlag_TruckNone) then//�ѽ������ж�
    if not VerifySnapTruck(nTrucks[0].FTruck,nTrucks[0].FID,nPos,nDept,nSnapStr) then
    begin
      MakeGateSound(nSnapStr, nPos, False);
      Exit;
    end;
    nStr := nSnapStr + ',�����';
    MakeGateSound(nStr, nPos, True);
    {$ENDIF}
    if not SaveLadingOrders(sFlag_TruckIn, nTrucks) then
    begin
      nStr := '����[ %s ]��������ʧ��.';
      nStr := Format(nStr, [nTrucks[0].FTruck]);

      WriteHardHelperLog(nStr, sPost_In);
      Exit;
    end;
    {$IFDEF GGJC}
    gHardwareHelper.SetCardLastDone(nCard, nReader);
    gHardwareHelper.SetReaderCard(nReader, nCard);
    {$ELSE}
    if gTruckQueueManager.IsTruckAutoIn then
    begin
      gHardwareHelper.SetCardLastDone(nCard, nReader);
      gHardwareHelper.SetReaderCard(nReader, nCard);
    end else
    begin
      //BlueOpenDoor(nReader);
      gHYReaderManager.OpenDoor(nReader);
      //̧��
    end;
    {$ENDIF}
    nStr := 'ԭ���Ͽ�[%s]����̧�˳ɹ�';
    nStr := Format(nStr, [nCard]);
    WriteHardHelperLog(nStr, sPost_In);
    Exit;
  end;
  //�ɹ��ſ�ֱ��̧��

  {$IFDEF QHSN}

  if (nCardType = sFlag_sale) then
  begin
    nPLine := nil;
    //nPTruck := nil;

    with gTruckQueueManager do
    if not IsDelayQueue then //����ʱ����(����ģʽ)
    try
      SyncLock.Enter;
      nStr := nTrucks[0].FTruck;

      for nIdx:=Lines.Count - 1 downto 0 do
      begin
        nInt := TruckInLine(nStr, PLineItem(Lines[nIdx]).FTrucks);
        if nInt >= 0 then
        begin
          nPLine := Lines[nIdx];
          //nPTruck := nPLine.FTrucks[nInt];
          Break;
        end;
      end;

      if not Assigned(nPLine) then
      begin
        nStr := '����[ %s ]û���ڵ��ȶ�����.';
        nStr := Format(nStr, [nTrucks[0].FTruck]);

        WriteHardHelperLog(nStr, sPost_In);
        Exit;
      end;
    finally
      SyncLock.Leave;
    end;  
  end;
  {$ENDIF}

  {$IFDEF RemoteSnap}
  if (not (nTrucks[0].FNeiDao=sFlag_Yes)) then//�ڵ����ж�
  if (nTrucks[0].FStatus = sFlag_TruckNone) then//�ѽ������ж�
  if not VerifySnapTruck(nTrucks[0].FTruck,nTrucks[0].FID,nPos,nDept,nSnapStr) then
  begin
    MakeGateSound(nSnapStr, nPos, False);
    Exit;
  end;
  nStr := nSnapStr + ',�����';
  MakeGateSound(nStr, nPos, True);
  {$ENDIF}

  if not SaveLadingBills(sFlag_TruckIn, nTrucks) then
  begin
    nStr := '����[ %s ]��������ʧ��.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteHardHelperLog(nStr, sPost_In);
    Exit;
  end;
  {$IFDEF GGJC}
  gHardwareHelper.SetCardLastDone(nCard, nReader);
  gHardwareHelper.SetReaderCard(nReader, nCard);
  {$ELSE}
  if gTruckQueueManager.IsTruckAutoIn then
  begin
    gHardwareHelper.SetCardLastDone(nCard, nReader);
    gHardwareHelper.SetReaderCard(nReader, nCard);
  end else
  begin
    //BlueOpenDoor(nReader);
    gHYReaderManager.OpenDoor(nReader);
    //̧��
  end;
  {$ENDIF}

  {$IFDEF QHSN}
  if (nCardType = sFlag_sale) then
  begin
    nDB := nil;
    with gParamManager.ActiveParam^ do
    Try
      nDB := gDBConnManager.GetConnection(FDB.FID, nErrNum);
      if not Assigned(nDB) then
      begin
        WriteHardHelperLog('����HM���ݿ�ʧ��(DBConn Is Null).');
        Exit;
      end;
      with gTruckQueueManager do
      if not IsDelayQueue then //����ģʽ,����ʱ�󶨵���(һ���൥)
      try
        SyncLock.Enter;
        nTruck := nTrucks[0].FTruck;

        for nIdx:=Lines.Count - 1 downto 0 do
        begin
          nPLine := Lines[nIdx];
          nInt := TruckInLine(nTruck, PLineItem(Lines[nIdx]).FTrucks);

          WriteHardHelperLog('lixw-debug:MakeTruckIn:nTruck='+nTruck+',nPLine.FLineID='+nPLine.FLineID);

          if nInt < 0 then Continue;
          nPTruck := nPLine.FTrucks[nInt];

          WriteHardHelperLog('lixw-debug:MakeTruckIn:nPTruck.FBill='+nPTruck.FBill);

          nStr := 'Update %s Set T_Line=''%s'',T_PeerWeight=%d Where T_Bill=''%s''';
          nStr := Format(nStr, [sTable_ZTTrucks, nPLine.FLineID, nPLine.FPeerWeight,
                  nPTruck.FBill]);
          //xxxxx
          WriteHardHelperLog('lixw-debug:MakeTruckIn:nsql=[ '+nStr+' ]');

          gDBConnManager.WorkerExec(nDB, nStr);
          //��ͨ��
        end;
      finally
        SyncLock.Leave;
      end;
    finally
      gDBConnManager.ReleaseConnection(nDB);
    end;  
  end;
  {$ENDIF}
end;

//Date: 2012-4-22
//Parm: ����;��ͷ;��ӡ��
//Desc: ��nCard���г���
procedure MakeTruckOut(const nCard,nReader,nPrinter,nHyprinter: string);
var nStr,nCardType,nTruck: string;
    nIdx: Integer;
    nRet: Boolean;
    nTrucks: TLadingBillItems;
    {$IFDEF PrintBillMoney}
    nOut: TWorkerBusinessCommand;
    {$ENDIF}
    nErrNum: Integer;
    nDBConn: PDBWorker;
    nCardKeep:Boolean;
begin
  nCardType := '';
  if not GetCardUsed(nCard, nCardType) then
  begin
    WriteHardHelperLog('��ȡ�ſ�['+nCard+']ʹ������ʧ��');
    Exit;
  end;
  if nCardType = sFlag_Other then
  begin
    nDBConn := nil;
    with gParamManager.ActiveParam^ do
    Try
      nDBConn := gDBConnManager.GetConnection(FDB.FID, nErrNum);
      if not Assigned(nDBConn) then
      begin
        WriteHardHelperLog('����HM���ݿ�ʧ��(DBConn Is Null).');
        Exit;
      end;

      if not nDBConn.FConn.Connected then
        nDBConn.FConn.Connected := True;  
      //conn db
      nStr := 'select * from %s Where O_Card=''%s'' ';
      nStr := Format(nStr, [sTable_CardOther, nCard]);
      with gDBConnManager.WorkerQuery(nDBConn,nStr) do
      begin
        if RecordCount < 1 then
        begin
          nStr := '��ȡ�ſ�[ %s ]������Ϣʧ��.';
          nStr := Format(nStr, [nCard]);

          WriteHardHelperLog(nStr, sPost_In);
          Exit;
        end;
        {$IFDEF QHSN}
        nCardKeep := FieldByName('o_keepcard').AsString=sFlag_Yes;
        nTruck:=FieldByName('O_Truck').AsString;
        try
          gHYReaderManager.OpenDoor(nReader);//̧��
        except
          on E:Exception do
          begin
            nStr := 'MakeTruckOut,nCardType='+nCardType+',OpenDoor(nReader) error='+e.Message;
            WriteHardHelperLog(nStr, sPost_In);
          end;
        end;
        nStr := '��ʱ��[ %s ]����.';
        nStr := Format(nStr, [nCard]);

        WriteHardHelperLog(nStr, sPost_In);
//        nStr := 'Insert into %s (I_Card,I_truck,I_InDate) Values (''%s'',''%s'',getdate()) ';
//        nStr := Format(nStr, [sTable_InOutFatory, nCard,nTruck]);
        //xxxxx

//        gDBConnManager.WorkerExec(nDBConn, nStr);

        nStr := 'update %s set O_OutTime=getdate() where o_card=''%s''';
        nStr := Format(nStr, [sTable_CardOther, nCard]);
        gDBConnManager.WorkerExec(nDBConn, nStr);
        {$ELSE}
        if FieldByName('I_OutDate').IsNull then
        begin
          gHYReaderManager.OpenDoor(nReader);//̧��
          nStr := '��ʱ��[ %s ]����.';
          nStr := Format(nStr, [nCard]);

          WriteHardHelperLog(nStr, sPost_In);
          nStr := 'Update %s Set I_OutDate=getdate() Where I_Card=''%s''';
          nStr := Format(nStr, [sTable_InOutFatory, nCard]);
          //xxxxx

          gDBConnManager.WorkerExec(nDBConn, nStr);
        end;
        {$ENDIF}
      end;
      {$IFDEF QHSN}

      {$ELSE}
      nStr := 'select * from %s Where (I_Card=''%s'') and '+
              '(I_InDate is not null) and (I_OutDate is not null) ';
      nStr := Format(nStr, [sTable_InOutFatory, nCard]);
      with gDBConnManager.WorkerQuery(nDBConn,nStr) do
      if RecordCount > 0 then
      begin
        nStr := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
        nStr := Format(nStr, [sTable_Card, sFlag_CardIdle, nCard]);
        gDBConnManager.WorkerExec(nDBConn, nStr);

        nStr := 'Update %s Set I_Card=''ע''+I_Card Where I_Card=''%s''';
        nStr := Format(nStr, [sTable_InOutFatory, nCard]);
        gDBConnManager.WorkerExec(nDBConn, nStr);
      end;
      {$ENDIF}
    finally
      gDBConnManager.ReleaseConnection(nDBConn);
    end;
    nStr := '';
//    Exit;
  end;

  if nCardType = sFlag_ST then
  begin
    nDBConn := nil;
    with gParamManager.ActiveParam^ do
    Try
      nDBConn := gDBConnManager.GetConnection(FDB.FID, nErrNum);
      if not Assigned(nDBConn) then
      begin
        WriteHardHelperLog('����HM���ݿ�ʧ��(DBConn Is Null).');
        Exit;
      end;

      if not nDBConn.FConn.Connected then
        nDBConn.FConn.Connected := True;
      //conn db
      nStr := 'select * from %s Where I_Card=''%s'' ';
      nStr := Format(nStr, [sTable_STInOutFact, nCard]);
      with gDBConnManager.WorkerQuery(nDBConn,nStr) do
      begin
        if RecordCount < 1 then
        begin
          nStr := '��ȡ�ſ�[ %s ]������Ϣʧ��.';
          nStr := Format(nStr, [nCard]);

          WriteHardHelperLog(nStr, sPost_In);
          Exit;
        end;
        nTruck:=FieldByName('I_truck').AsString;
        gHYReaderManager.OpenDoor(nReader);//̧��
        nStr := '%s���ſ�[ %s ]����.';
        nStr := Format(nStr, [nTruck,nCard]);

        WriteHardHelperLog(nStr, sPost_In);
        nStr := 'Insert into %s (I_Card,I_truck,I_Date,I_OutDate) Values (''%s'',''%s'',getdate(),getdate()) ';
        nStr := Format(nStr, [sTable_STInOutFact, nCard,nTruck]);
        //xxxxx
        gDBConnManager.WorkerExec(nDBConn, nStr);
      end;
    finally
      gDBConnManager.ReleaseConnection(nDBConn);
    end;
    Exit;
  end;

  if (nCardType = sFlag_Provide) then
    nRet := GetLadingOrders(nCard, sFlag_TruckOut, nTrucks)
  else if (nCardType = sFlag_sale) then
   nRet := GetLadingBills(nCard, sFlag_TruckOut, nTrucks)
  else if (ncardtype=sflag_other) then
  begin
    nRet := GetLadingOrders(nCard, sFlag_TruckOut, nTrucks);
    for nidx := Low(ntrucks) to High(ntrucks) do
    begin
      nTrucks[nIdx].FSelected := True;
    end;
  end;

  if not nRet then
  begin
    nStr := '��ȡ�ſ�[ %s ]������Ϣʧ��.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr, sPost_Out);
    Exit;
  end;
  WriteHardHelperLog('MakeTruckOut,GetLadingOrders or GetLadingBills success');

  if Length(nTrucks) < 1 then
  begin
    nStr := '�ſ�[ %s ]û����Ҫ��������.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr, sPost_Out);
    Exit;
  end;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    if FNextStatus = sFlag_TruckOut then Continue;
    nStr := '����[ %s ]��һ״̬Ϊ:[ %s ],�޷�����.';
    nStr := Format(nStr, [FTruck, TruckStatusToStr(FNextStatus)]);
    
    WriteHardHelperLog(nStr, sPost_Out);
    Exit;
  end;

  if (nCardType = sFlag_Provide) or (nCardType = sFlag_other) then
        nRet := SaveLadingOrders(sFlag_TruckOut, nTrucks)
  else  nRet := SaveLadingBills(sFlag_TruckOut, nTrucks);

  if not nRet then
  begin
    nStr := '����[ %s ]��������ʧ��.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteHardHelperLog(nStr, sPost_Out);
    Exit;
  end;

  WriteHardHelperLog('MakeTruckOut,SaveLadingOrders or SaveLadingBills success');
  
  if (nReader <> '') and (Pos('V',nReader)<=0) then gHYReaderManager.OpenDoor(nReader);
  //̧��
  if gSysParam.FGPWSURL <> '' then
  begin
    //����΢�Ŷ���״̬
    ModifyWebOrderStatus(nTrucks[0].FID,c_WeChatStatusFinished,'',FloatToStr(nTrucks[0].FValue));
    //����΢����Ϣ
    SendMsgToWebMall(nTrucks[0].FID,cSendWeChatMsgType_OutFactory,nCardType);
  end;
  
  for nIdx:=Low(nTrucks) to High(nTrucks) do
  begin
    {$IFDEF ZXKP}
    if (nCardType = sFlag_Provide) and (nTrucks[nIdx].FNeiDao = sFlag_Yes) then
    begin
      nStr := '����[ %s ]�ڵ���������ӡ.';
      nStr := Format(nStr, [nTrucks[nIdx].FTruck]);

      WriteHardHelperLog(nStr, sPost_Out);
      Exit;
    end;
    {$ENDIF}
    {$IFDEF QHSN}
    {$IFNDEF GGJC}
    if (nCardType = sFlag_Provide) and (nTrucks[nIdx].FNeiDao = sFlag_Yes) then
    begin
      nStr := '����[ %s ]�ڵ���������ӡ.';
      nStr := Format(nStr, [nTrucks[nIdx].FTruck]);

      WriteHardHelperLog(nStr, sPost_Out);
      Exit;
    end;
    {$ENDIF}
    {$ENDIF}

    nStr := nStr + #7 + nCardType;
    //�ſ�����
    
    if (nPrinter = '') and (nHyprinter = '') then
    begin
      gRemotePrinter.PrintBill(nTrucks[nIdx].FID + nStr);
      WriteHardHelperLog(nTrucks[nIdx].FID + nStr);
    end else
    if (nPrinter <> '') and (nHyprinter <> '') then
    begin
      gRemotePrinter.PrintBill(nTrucks[nIdx].FID + #11 + nHyprinter + #9 + nPrinter + nStr);
      WriteHardHelperLog(nTrucks[nIdx].FID + #9 + nPrinter + nHyprinter + nStr);
    end else
    if (nPrinter = '') then
    begin
      gRemotePrinter.PrintBill(nTrucks[nIdx].FID + #11 + nHyprinter + nStr);
      WriteHardHelperLog(nTrucks[nIdx].FID + #9 + nHyprinter + nStr);
    end else
    if (nHyprinter = '') then
    begin
      gRemotePrinter.PrintBill(nTrucks[nIdx].FID + #9 + nPrinter + nStr);
      WriteHardHelperLog(nTrucks[nIdx].FID + #9 + nPrinter + nStr);
    end;
  end; //��ӡ����
end;

//Date: 2012-10-19
//Parm: ����;��ͷ
//Desc: ��⳵���Ƿ��ڶ�����,�����Ƿ�̧��
procedure MakeTruckPassGate(const nCard,nReader: string);
var nStr: string;
    nIdx: Integer;
    nTrucks: TLadingBillItems;
    nDBConn: PDBWorker;
    nErrNum: Integer;
begin
  if not GetLadingBills(nCard, sFlag_TruckOut, nTrucks) then
  begin
    nStr := '��ȡ�ſ�[ %s ]��������Ϣʧ��.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr);
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '�ſ�[ %s ]û����Ҫͨ����բ�ĳ���.';
    nStr := Format(nStr, [nCard]);

    WriteHardHelperLog(nStr);
    Exit;
  end;

  if gTruckQueueManager.TruckInQueue(nTrucks[0].FTruck) < 0 then
  begin
    nStr := '����[ %s ]���ڶ���,��ֹͨ����բ.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteHardHelperLog(nStr);
    Exit;
  end;

  //BlueOpenDoor(nReader);
  //̧��
  nDBConn := nil;
  with gParamManager.ActiveParam^ do
  Try
    nDBConn := gDBConnManager.GetConnection(FDB.FID, nErrNum);
    if not Assigned(nDBConn) then
    begin
      WriteHardHelperLog('����HM���ݿ�ʧ��(DBConn Is Null).');
      Exit;
    end;
    for nIdx:=Low(nTrucks) to High(nTrucks) do
    begin
      nStr := 'Update %s Set T_InLade=%s Where T_Bill=''%s'' And T_InLade Is Null';
      nStr := Format(nStr, [sTable_ZTTrucks, sField_SQLServer_Now, nTrucks[nIdx].FID]);

      gDBConnManager.WorkerExec(nDBConn, nStr);
      //�������ʱ��,�������򽫲��ٽк�.
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBConn);
  end;
end;

//Date: 2012-4-22
//Parm: ��ͷ����
//Desc: ��nReader�����Ŀ��������嶯��
procedure WhenReaderCardArrived(const nReader: THHReaderItem);
var nStr: string;
    nErrNum: Integer;
    nDBConn: PDBWorker;
begin
  nDBConn := nil;
  {$IFDEF DEBUG}
//  WriteHardHelperLog('WhenReaderCardArrived����.'+nReader.FID+' ��ͷ���ͣ�'+nReader.FType);
  {$ENDIF}

  with gParamManager.ActiveParam^ do
  try
    nDBConn := gDBConnManager.GetConnection(FDB.FID, nErrNum);
    if not Assigned(nDBConn) then
    begin
      WriteHardHelperLog('����HM���ݿ�ʧ��(DBConn Is Null).');
      Exit;
    end;

    if not nDBConn.FConn.Connected then
      nDBConn.FConn.Connected := True;
    //conn db

    nStr := 'Select C_Card From $TB Where C_Card=''$CD'' or ' +
            'C_Card2=''$CD'' or C_Card3=''$CD''';
    nStr := MacroValue(nStr, [MI('$TB', sTable_Card), MI('$CD', nReader.FCard)]);

    with gDBConnManager.WorkerQuery(nDBConn, nStr) do
    if RecordCount > 0 then
    begin
      nStr := Fields[0].AsString;
    end else
    begin
      nStr := Format('�ſ���[ %s ]ƥ��ʧ��.', [nReader.FCard]);
      WriteHardHelperLog(nStr);
      Exit;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBConn);
  end;
  
  try
    if nReader.FType = rtIn then
    begin
      MakeTruckIn(nStr, nReader.FID, nReader.FPost, nReader.FDept);
    end else
    if nReader.FType = rtOut then
    begin
      MakeTruckOut(nStr, nReader.FID, nReader.FPrinter, nReader.FHyprinter);
    end else

    if nReader.FType = rtGate then
    begin
      //if nReader.FID <> '' then
      //  BlueOpenDoor(nReader.FID);
      //̧��
    end else

    if nReader.FType = rtQueueGate then
    begin
      if nReader.FID <> '' then
        MakeTruckPassGate(nStr, nReader.FID);
      //̧��
    end;
  except
    On E:Exception do
    begin
      WriteHardHelperLog(E.Message);
    end;
  end;

end;

procedure WhenHYReaderCardArrived(const nReader: PHYReaderItem);   //2016-06-24 lih
begin
  {$IFDEF DEBUG}
  WriteHardHelperLog(Format('�����ǩ %s:%s', [nReader.FTunnel, nReader.FCard]));
  {$ENDIF}

  if nReader.FVirtual then
  begin
    case nReader.FVType of
      rt900 :gHardwareHelper.SetReaderCard(nReader.FVReader, 'H' + nReader.FCard, False);
      rt02n :g02NReader.SetReaderCard(nReader.FVReader, 'H' + nReader.FCard);
    end;
  end else
  begin
    g02NReader.ActiveELabel(nReader.FTunnel, nReader.FCard);
    WriteHardHelperLog('WhenHYReaderCardArrived.g02NReader.ActiveELabel('+nReader.FTunnel+', '+nReader.FCard+')');
  end;
end;

//------------------------------------------------------------------------------
procedure WriteNearReaderLog(const nEvent: string);
begin
  gSysLoger.AddLog(T02NReader, '�ֳ����������', nEvent);
end;

//Date: 2012-4-24
//Parm: ����;ͨ��;�Ƿ����Ⱥ�˳��;��ʾ��Ϣ
//Desc: ���nTuck�Ƿ������nTunnelװ��
function IsTruckInQueue(const nTruck,nTunnel: string; const nQueued: Boolean;
 var nHint: string; var nPTruck: PTruckItem; var nPLine: PLineItem;
 const nStockType: string = ''): Boolean;
var i,nIdx,nInt: Integer;
    nLineItem: PLineItem;
    nStr: string;
begin
  with gTruckQueueManager do
  try
    Result := False;
    SyncLock.Enter;
    nIdx := GetLine(nTunnel);

    if nIdx < 0 then
    begin
      nHint := Format('ͨ��[ %s ]��Ч.', [nTunnel]);
      Exit;
    end;

    nPLine := Lines[nIdx];
    nIdx := TruckInLine(nTruck, nPLine.FTrucks);

    if (nIdx < 0) and (nStockType <> '') and (
       ((nStockType = sFlag_Dai) and IsDaiQueueClosed) or
       ((nStockType = sFlag_San) and IsSanQueueClosed)) then
    begin
      for i:=Lines.Count - 1 downto 0 do
      begin
        if Lines[i] = nPLine then Continue;
        nLineItem := Lines[i];
        nInt := TruckInLine(nTruck, nLineItem.FTrucks);

        if nInt < 0 then Continue;
        //���ڵ�ǰ����
        if not StockMatch(nPLine.FStockNo, nLineItem) then Continue;
        //ˢ��������е�Ʒ�ֲ�ƥ��

        nIdx := nPLine.FTrucks.Add(nLineItem.FTrucks[nInt]);
        nLineItem.FTrucks.Delete(nInt);
        //Ų���������µ�

        nHint := 'Update %s Set T_Line=''%s'' ' +
                 'Where T_Truck=''%s'' And T_Line=''%s''';
        nHint := Format(nHint, [sTable_ZTTrucks, nPLine.FLineID, nTruck,
                nLineItem.FLineID]);
        gTruckQueueManager.AddExecuteSQL(nHint);

        nHint := '����[ %s ]��������[ %s->%s ]';
        nHint := Format(nHint, [nTruck, nLineItem.FName, nPLine.FName]);
        WriteNearReaderLog(nHint);
        Break;
      end;
    end;
    //��װ�ص�����

    if nIdx < 0 then
    begin
      nHint := Format('����[ %s ]����[ %s ]������.', [nTruck, nPLine.FName]);
      Exit;
    end;

    nPTruck := nPLine.FTrucks[nIdx];
    nPTruck.FStockName := nPLine.FName;
    //ͬ��������

    Result := True;
  finally
    SyncLock.Leave;
  end;
end;

//Date: 2013-1-21
//Parm: ͨ����;������;
//Desc: ��nTunnel�ϴ�ӡnBill��α��
function PrintBillCode(const nTunnel,nBill: string; var nHint: string): Boolean;
var nStr: string;
    nTask: Int64;
    nOut: TWorkerBusinessCommand;
begin
  Result := True;
  if not gMultiJSManager.CountEnable then Exit;

  nTask := gTaskMonitor.AddTask('UHardBusiness.PrintBillCode', cTaskTimeoutLong);
  //to mon
  
  if not CallHardwareCommand(cBC_PrintCode, nBill, nTunnel, @nOut) then
  begin
    nStr := '��ͨ��[ %s ]���ͷ�Υ����ʧ��,����: %s';
    nStr := Format(nStr, [nTunnel, nOut.FData]);  
    WriteNearReaderLog(nStr);
  end;

  gTaskMonitor.DelTask(nTask, True);
  //task done
end;

//Date: 2012-4-24
//Parm: ����;ͨ��;������;��������
//Desc: ����nTunnel�ĳ�������������
function TruckStartJS(const nTruck,nTunnel,nBill: string;
  var nHint: string; const nAddJS: Boolean = True): Boolean;
var nIdx: Integer;
    nTask: Int64;
    nPLine: PLineItem;
    nPTruck: PTruckItem;
begin
  with gTruckQueueManager do
  try
    Result := False;
    SyncLock.Enter;
    nIdx := GetLine(nTunnel);

    if nIdx < 0 then
    begin
      nHint := Format('ͨ��[ %s ]��Ч.', [nTunnel]);
      Exit;
    end;

    nPLine := Lines[nIdx];
    nIdx := TruckInLine(nTruck, nPLine.FTrucks);

    if nIdx < 0 then
    begin
      nHint := Format('����[ %s ]�Ѳ��ٶ���.', [nTruck]);
      Exit;
    end;

    Result := True;
    nPTruck := nPLine.FTrucks[nIdx];

    for nIdx:=nPLine.FTrucks.Count - 1 downto 0 do
      PTruckItem(nPLine.FTrucks[nIdx]).FStarted := False;
    nPTruck.FStarted := True;

    if PrintBillCode(nTunnel, nBill, nHint) and nAddJS then
    begin
      nTask := gTaskMonitor.AddTask('UHardBusiness.AddJS', cTaskTimeoutLong);
      //to mon
      
      gMultiJSManager.AddJS(nTunnel, nTruck, nBill, nPTruck.FDai, True);
      gTaskMonitor.DelTask(nTask);
      
    end;
  finally
    SyncLock.Leave;
  end;
end;

//Date: 2013-07-17
//Parm: ��������
//Desc: ��ѯnBill�ϵ���װ��
function GetHasDai(const nBill: string): Integer;
var nStr: string;
    nIdx: Integer;
    nDBConn: PDBWorker;
begin
  if not gMultiJSManager.ChainEnable then
  begin
    Result := 0;
    Exit;
  end;

  Result := gMultiJSManager.GetJSDai(nBill);
  if Result > 0 then Exit;

  nDBConn := nil;
  with gParamManager.ActiveParam^ do
  try
    nDBConn := gDBConnManager.GetConnection(FDB.FID, nIdx);
    if not Assigned(nDBConn) then
    begin
      WriteNearReaderLog('����HM���ݿ�ʧ��(DBConn Is Null).');
      Exit;
    end;

    if not nDBConn.FConn.Connected then
      nDBConn.FConn.Connected := True;
    //conn db

    nStr := 'Select T_Total From %s Where T_Bill=''%s''';
    nStr := Format(nStr, [sTable_ZTTrucks, nBill]);

    with gDBConnManager.WorkerQuery(nDBConn, nStr) do
    if RecordCount > 0 then
    begin
      Result := Fields[0].AsInteger;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBConn);
  end;
end;

procedure SavePicture(const nID, nTruck, nMate, nFile: string);
var nStr: string;
    nRID: Integer;
    nDBConn: PDBWorker;
    nIdx:Integer;
begin
  nDBConn := nil;
  with gParamManager.ActiveParam^ do
  begin
    try
      nDBConn := gDBConnManager.GetConnection(FDB.FID, nIdx);
      if not Assigned(nDBConn) then
      begin
        WriteNearReaderLog('����HM���ݿ�ʧ��(DBConn Is Null).');
        Exit;
      end;

      if not nDBConn.FConn.Connected then
        nDBConn.FConn.Connected := True;

      nDBConn.FConn.BeginTrans;
      try
        nStr := MakeSQLByStr([
            SF('P_ID', nID),
            SF('P_Name', nTruck),
            SF('P_Mate', nMate),
            SF('P_Date', sField_SQLServer_Now, sfVal)
            ], sTable_Picture, '', True);
        gDBConnManager.WorkerExec(nDBConn, nStr);

        nStr := 'Select Max(%s) From %s';
        nStr := Format(nStr, ['R_ID', sTable_Picture]);

        with gDBConnManager.WorkerQuery(nDBConn, nStr) do
        if RecordCount > 0 then
        begin
          nRID := Fields[0].AsInteger;
        end;

        nStr := 'Select P_Picture From %s Where R_ID=%d';
        nStr := Format(nStr, [sTable_Picture, nRID]);
        SaveDBImage(gDBConnManager.WorkerQuery(nDBConn, nStr), 'P_Picture', nFile);

        nDBConn.FConn.CommitTrans;
      except
        nDBConn.FConn.RollbackTrans;
      end;
    finally
      gDBConnManager.ReleaseConnection(nDBConn);
    end;
  end;
end;
//Desc: ����ͼƬ·��
function MakePicName: string;
begin
  while True do
  begin
    Result := gSysParam.FPicPath + IntToStr(gSysParam.FPicBase) + '.jpg';
    if not FileExists(Result) then
    begin
      Inc(gSysParam.FPicBase);
      Exit;
    end;

    DeleteFile(Result);
    if FileExists(Result) then Inc(gSysParam.FPicBase)
  end;
end;

procedure CapturePicture(const nTunnel: PReaderHost; const nList: TStrings);
const
  cRetry = 2;
  //���Դ���
var nStr,nTmp: string;
    nIdx,nInt: Integer;
    nLogin,nErr: Integer;
    nPic: NET_DVR_JPEGPARA;
    nInfo: TNET_DVR_DEVICEINFO;
begin
  nList.Clear;

  if not Assigned(nTunnel.FCamera) then Exit;

  if not DirectoryExists(gSysParam.FPicPath) then
    ForceDirectories(gSysParam.FPicPath);

  if gSysParam.FPicBase >= 100 then
    gSysParam.FPicBase := 0;

  nLogin := -1;

  NET_DVR_Init();

  try
    for nIdx:=1 to cRetry do
    begin
      nStr := 'NET_DVR_Login(IPAddr=%s,wDVRPort=%d,UserName=%s,PassWord=%s)';
      nStr := Format(nStr,[nTunnel.FCamera.FHost,nTunnel.FCamera.FPort,nTunnel.FCamera.FUser,nTunnel.FCamera.FPwd]);

      nLogin := NET_DVR_Login(PChar(nTunnel.FCamera.FHost),
                   nTunnel.FCamera.FPort,
                   PChar(nTunnel.FCamera.FUser),
                   PChar(nTunnel.FCamera.FPwd), @nInfo);

      nErr := NET_DVR_GetLastError;
      if nErr = 0 then break;

      if nIdx = cRetry then
      begin
        nStr := '��¼�����[ %s.%d ]ʧ��,������: %d';
        nStr := Format(nStr, [nTunnel.FCamera.FHost, nTunnel.FCamera.FPort, nErr]);
        WriteNearReaderLog(nStr);
        Exit;
      end;
    end;

    nPic.wPicSize := nTunnel.FCamera.FPicSize;
    nPic.wPicQuality := nTunnel.FCamera.FPicQuality;
    nStr := 'nPic.wPicSize=%d,nPic.wPicQuality=%d';
    nStr := Format(nStr,[nPic.wPicSize,nPic.wPicQuality]);

    for nIdx:=Low(nTunnel.FCameraTunnels) to High(nTunnel.FCameraTunnels) do
    begin
      if nTunnel.FCameraTunnels[nIdx] = MaxByte then continue;

      for nInt:=1 to cRetry do
      begin
        nStr := MakePicName();
        nTmp := 'NET_DVR_CaptureJPEGPicture(LoginID=%d,lChannel=%d,sPicFileName=%s)';
        nTmp := Format(nTmp,[nLogin,nTunnel.FCameraTunnels[nIdx],nStr]);

        NET_DVR_CaptureJPEGPicture(nLogin, nTunnel.FCameraTunnels[nIdx],
                                   @nPic, PChar(nStr));

        nErr := NET_DVR_GetLastError;

        if nErr = 0 then
        begin
          nList.Add(nStr);
          Break;
        end;

        if nIdx = cRetry then
        begin
          nStr := 'ץ��ͼ��[ %s.%d ]ʧ��,������: %d';
          nStr := Format(nStr, [nTunnel.FCamera.FHost,
                   nTunnel.FCameraTunnels[nIdx], nErr]);
          WriteNearReaderLog(nStr);
        end;
      end;
    end;
  finally
    if nLogin > -1 then
      NET_DVR_Logout(nLogin);
    NET_DVR_Cleanup();
  end;
end;

//Date: 2017-6-2
//Parm: �ſ���;ͨ����
//Desc: ��nCardִ�����ղ���
procedure MakeTruckAcceptance(const nCard: string; nTunnel: string;const nHost: PReaderHost);
var
  nStr:string;
  nDBConn: PDBWorker;
  nIdx,nInt,nTmp:Integer;
  nY_valid,nY_stockno:string;
  nBills: TLadingBillItems;
  nList: TStrings;
  nCardType:string;
  function SimpleTruckno(const nTruckno:WideString):string;
  var
    i:Integer;
  begin
    Result := '';
    for i := 1 to Length(nTruckno) do
    begin
      if Ord(nTruckno[i])>127 then Continue;
      Result := Result+nTruckno[i];
    end;
  end;
begin
  nDBConn := nil;
  if not GetCardUsed(nCard, nCardType) then Exit;

  with gParamManager.ActiveParam^ do
  begin
    try
      nDBConn := gDBConnManager.GetConnection(FDB.FID, nIdx);
      if not Assigned(nDBConn) then
        begin
          WriteNearReaderLog('����'+FDB.FID+'���ݿ�ʧ��(DBConn Is Null).');
          Exit;
        end;
        if not nDBConn.FConn.Connected then
        nDBConn.FConn.Connected := True;

        nStr := 'select * from %s where y_id=''%s''';
        nStr := Format(nStr,[sTable_YSLines,nTunnel]);

        with gDBConnManager.WorkerQuery(nDBConn, nStr) do
        begin
          if recordcount=0 then
          begin
            WriteNearReaderLog('����ͨ��'+nTunnel+'������');
            Exit;
          end;
          nY_valid := FieldByName('Y_Valid').asstring;
          if nY_valid=sflag_no then
          begin
            WriteNearReaderLog('����ͨ��'+nTunnel+'�ѹر�');
            Exit;
          end;
          nY_stockno := FieldByName('Y_StockNo').asstring;
        end;
    finally
      gDBConnManager.ReleaseConnection(nDBConn);
    end;
  end;

  if not GetLadingOrders(nCard, sFlag_TruckBFM, nBills) then
  begin
    nStr := '��ȡ�ſ�[ %s ]������Ϣʧ��.';
    nStr := Format(nStr, [nCard]);
    WriteNearReaderLog(nStr);
    Exit;
  end;
  if Length(nBills) < 1 then
  begin
    nStr := '�ſ�[ %s ]û����Ҫ�ֳ����ճ���.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  nStr := '';
  nInt := 0;
  for nIdx:=Low(nBills) to High(nBills) do
  begin
    with nBills[nIdx] do
    begin
      if nCardType=sFlag_Provide then
      begin
        if Pos(FStockNo,nY_stockno)=0 then
        begin
          nTmp := Length(nBills[0].FTruck);
//          nStr := SimpleTruckno(nBills[0].FTruck) + '���������ͨ��';
          nStr := '���������ͨ��';
          gDisplayManager.Display(nTunnel, nStr);
          nStr := SimpleTruckno(nBills[0].FTruck) + '���������ͨ��';
          WriteHardHelperLog('��['+nTunnel+']ͨ��ˢ����Ч��'+nStr+',��������['+FStockNo+']ͨ������['+nY_stockno+']');
          Exit;
        end;
      end;
      FSelected := (FStatus = sFlag_TruckXH) or (FNextStatus = sFlag_TruckXH);
      if FSelected then
      begin
        Inc(nInt);
        Continue;
      end;

//      nStr := '%s    �޷�����.';
//      nStr := Format(nStr, [SimpleTruckno(FTruck), TruckStatusToStr(FNextStatus)]);
      nStr := '�����ë��';
      gDisplayManager.Display(nTunnel, nStr);
      nStr := '%s    �޷�����.';
      nStr := Format(nStr, [SimpleTruckno(FTruck), TruckStatusToStr(FNextStatus)]);
      WriteNearReaderLog('��['+nTunnel+']ͨ��ˢ����Ч��'+nStr+',��������['+FStockNo+']ͨ������['+nY_stockno+']');
    end;
  end;

  if nInt < 1 then
  begin
    WriteHardHelperLog(nStr);
    Exit;
  end;

//  nStr := SimpleTruckno(nBills[0].FTruck) + '    ˢ�����';
  nStr := 'ˢ���������';
  gDisplayManager.Display(nTunnel, nStr);
  nStr := SimpleTruckno(nBills[0].FTruck) + '    ˢ�����';
  WriteNearReaderLog('lixw-debug gDisplayManager.Display(nTunnel='+nTunnel+',nStr='+nStr+')');
  if not SaveLadingOrders(sFlag_TruckXH, nBills) then
  begin
    nStr := '����[ %s ]����ʧ��.';
    nStr := Format(nStr, [nBills[0].FTruck]);

    WriteNearReaderLog(nStr);
    Exit;
  end;
  nList := TStringList.Create;
  try
    CapturePicture(nHost, nList);

    for nIdx:=0 to nList.Count - 1 do
      SavePicture(nTunnel+FormatDateTime('yyyymmdd',date), nBills[0].FTruck,
                              nBills[0].FStockName, nList[nIdx]);
  finally
    nList.Free;
  end;      
end;

//Date: 2012-4-24
//Parm: �ſ���;ͨ����
//Desc: ��nCardִ�д�װװ������

procedure MakeTruckLadingDai(const nCard: string; nTunnel: string);
var nStr: string;
    nIdx,nInt: Integer;
    nPLine: PLineItem;
    nPTruck: PTruckItem;
    nTrucks: TLadingBillItems;

    function IsJSRun: Boolean;
    begin
      Result := False;
      if nTunnel = '' then Exit;
      Result := gMultiJSManager.IsJSRun(nTunnel);

      if Result then
      begin
        nStr := 'ͨ��[ %s ]װ����,ҵ����Ч.';
        nStr := Format(nStr, [nTunnel]);
        WriteNearReaderLog(nStr);
      end;
    end;
begin
  WriteNearReaderLog('ͨ��[ ' + nTunnel + ' ]: MakeTruckLadingDai����.');

  if IsJSRun then Exit;
  //tunnel is busy

  if not GetLadingBills(nCard, sFlag_TruckZT, nTrucks) then
  begin
    nStr := '��ȡ�ſ�[ %s ]��������Ϣʧ��.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '�ſ�[ %s ]û����Ҫջ̨�������.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  if nTrucks[0].FYSValid = sFlag_Yes then
  begin
    nStr := '����[ %s ]�Ѱ���ճ�����.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteNearReaderLog(nStr);
    Exit;
  end;
  if nTunnel = '' then
  begin
    nTunnel := gTruckQueueManager.GetTruckTunnel(nTrucks[0].FTruck);
    //���¶�λ�������ڳ���
    if IsJSRun then Exit;
  end;
  
  if not IsTruckInQueue(nTrucks[0].FTruck, nTunnel, False, nStr,
         nPTruck, nPLine, sFlag_Dai) then
  begin
    WriteNearReaderLog(nStr);
    Exit;
  end; //���ͨ��

  nStr := '';
  nInt := 0;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    if (FStatus = sFlag_TruckZT) or (FNextStatus = sFlag_TruckZT) then
    begin
      FSelected := Pos(FID, nPTruck.FHKBills) > 0;
      if FSelected then Inc(nInt); //ˢ��ͨ����Ӧ�Ľ�����
      Continue;
    end;

    FSelected := False;
    nStr := '����[ %s ]��һ״̬Ϊ:[ %s ],�޷�ջ̨���.';
    nStr := Format(nStr, [FTruck, TruckStatusToStr(FNextStatus)]);
  end;

  if nInt < 1 then
  begin
    WriteHardHelperLog(nStr);
    Exit;
  end;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    if not FSelected then Continue;
    if FStatus <> sFlag_TruckZT then Continue;

    nStr := '��װ����[ %s ]�ٴ�ˢ��װ��.';
    nStr := Format(nStr, [nPTruck.FTruck]);
    WriteNearReaderLog(nStr);

    if not TruckStartJS(nPTruck.FTruck, nTunnel, nPTruck.FBill, nStr,
       GetHasDai(nPTruck.FBill) < 1) then
      WriteNearReaderLog(nStr);
    Exit;
  end;

  if not SaveLadingBills(sFlag_TruckZT, nTrucks) then
  begin
    nStr := '����[ %s ]ջ̨���ʧ��.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  if not TruckStartJS(nPTruck.FTruck, nTunnel, nPTruck.FBill, nStr) then
    WriteNearReaderLog(nStr);
  Exit;
end;

//Date: 2012-4-25
//Parm: ����;ͨ��
//Desc: ��ȨnTruck��nTunnel�����Ż�
procedure TruckStartFH(const nTruck: PTruckItem; const nTunnel: string);
var nStr,nTmp,nCardUse: string;
   nField: TField;
   nWorker: PDBWorker;
begin
  nWorker := nil;
  try
    nTmp := '';
    nStr := 'Select * From %s Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, nTruck.FTruck]);

    with gDBConnManager.SQLQuery(nStr, nWorker) do
    if RecordCount > 0 then
    begin
      nField := FindField('T_Card');
      if Assigned(nField) then nTmp := nField.AsString;

      nField := FindField('T_Card2');
      if (Assigned(nField)) and (Length(nField.AsString)>0) then
      begin
        if Length(nTmp)>0 then
          nTmp := nTmp+';'+nField.AsString
        else
          nTmp := nField.AsString;
      end;

      nField := FindField('T_CardUse');
      if Assigned(nField) then nCardUse := nField.AsString;

      if nCardUse = sFlag_No then
        nTmp := '';
      //xxxxx
    end;

    g02NReader.SetRealELabel(nTunnel, nTmp);
    WriteNearReaderLog('TruckStartFH.g02NReader.SetRealELabel('+nTunnel+', '+nTmp+')');
  finally
    gDBConnManager.ReleaseConnection(nWorker);
  end;


  gERelayManager.LineOpen(nTunnel);
  //�򿪷Ż�

  nStr := nTruck.FTruck + StringOfChar(' ', 12 - Length(nTruck.FTruck));
  nTmp := nTruck.FStockName + FloatToStr(nTruck.FValue);
  nStr := nStr + nTruck.FStockName + StringOfChar(' ', 12 - Length(nTmp)) +
          FloatToStr(nTruck.FValue);
  //xxxxx  

  WriteNearReaderLog('TruckStartFH.gERelayManager.ShowTxt('+nTunnel+', '+nStr+')');
  gERelayManager.ShowTxt(nTunnel, nStr);
  //��ʾ����
end;

//Date: 2012-4-24
//Parm: �ſ���;ͨ����
//Desc: ��nCardִ�д�װװ������
procedure MakeTruckLadingSan(const nCard,nTunnel: string);
var nStr: string;
    nIdx: Integer;
    nPLine: PLineItem;
    nPTruck: PTruckItem;
    nTrucks: TLadingBillItems;
begin
  {$IFDEF DEBUG}
  WriteNearReaderLog('MakeTruckLadingSan����.');
  {$ENDIF}

  if not GetLadingBills(nCard, sFlag_TruckFH, nTrucks) then
  begin
    nStr := '��ȡ�ſ�[ %s ]��������Ϣʧ��.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  if Length(nTrucks) < 1 then
  begin
    nStr := '�ſ�[ %s ]û����Ҫ�Żҳ���.';
    nStr := Format(nStr, [nCard]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  for nIdx:=Low(nTrucks) to High(nTrucks) do
  with nTrucks[nIdx] do
  begin
    if (FStatus = sFlag_TruckFH) or (FNextStatus = sFlag_TruckFH) then Continue;
    //δװ����װ

    nStr := '����[ %s ]��һ״̬Ϊ:[ %s ],�޷��Ż�.';
    nStr := Format(nStr, [FTruck, TruckStatusToStr(FNextStatus)]);
    
    WriteHardHelperLog(nStr);
    Exit;
  end;

  if not IsTruckInQueue(nTrucks[0].FTruck, nTunnel, False, nStr,
         nPTruck, nPLine, sFlag_San) then
  begin 
    WriteNearReaderLog(nStr);
    //loged

    nIdx := Length(nTrucks[0].FTruck);
    nStr := nTrucks[0].FTruck + StringOfChar(' ',12 - nIdx) + '�뻻��װ��';
    gERelayManager.ShowTxt(nTunnel, nStr);
    Exit;
  end; //���ͨ��

  if nTrucks[0].FYSValid = sFlag_Yes then
  begin
    nStr := '����[ %s ]�Ѱ���ճ�����.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  if nTrucks[0].FStatus = sFlag_TruckFH then
  begin
    nStr := 'ɢװ����[ %s ]�ٴ�ˢ��װ��.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);
    WriteNearReaderLog(nStr);
    
    TruckStartFH(nPTruck, nTunnel);
    Exit;
  end;

  if not SaveLadingBills(sFlag_TruckFH, nTrucks) then
  begin
    nStr := '����[ %s ]�ŻҴ����ʧ��.';
    nStr := Format(nStr, [nTrucks[0].FTruck]);

    WriteNearReaderLog(nStr);
    Exit;
  end;

  TruckStartFH(nPTruck, nTunnel);
  //ִ�зŻ�
end;

//Date: 2012-4-24
//Parm: ����;����
//Desc: ��nHost.nCard�µ�������������
procedure WhenReaderCardIn(const nCard: string; const nHost: PReaderHost);
var
  nCardType: string;
begin
  if not GetCardUsed(nCard, nCardType) then Exit;
  if nHost.FType = rtOnce then
  begin
    if nHost.FFun = rfIn then
    begin
      MakeTruckIn(nCard, '', '', '');
    end else
    if nHost.FFun = rfOut then
    begin
      if Assigned(nHost.FOptions) then
        MakeTruckOut(nCard, '', nHost.FPrinter, nHost.FOptions.Values['HYprinter'])
      else
        MakeTruckOut(nCard, '', nHost.FPrinter, '');
    end else
    begin
      if nCardType = sFlag_Sale then
      begin
        MakeTruckLadingDai(nCard, nHost.FTunnel);
      end
      else if (nCardType = sFlag_Provide) or (nCardType = sFlag_other) then
      begin
        MakeTruckAcceptance(nCard,nhost.FTunnel,nHost);
      end;
    end;
  end
  else if nHost.FType = rtKeep then
  begin
    if nCardType = sFlag_Sale then
    begin
      MakeTruckLadingSan(nCard, nHost.FTunnel);
    end
    else if (nCardType = sFlag_Provide) or (nCardType = sFlag_other) then
    begin
      MakeTruckAcceptance(nCard,nhost.FTunnel,nHost);
    end;
  end;
end;

//Date: 2012-4-24
//Parm: ����;����
//Desc: ��nHost.nCard��ʱ����������
procedure WhenReaderCardOut(const nCard: string; const nHost: PReaderHost);
begin
  {$IFDEF DEBUG}
  WriteHardHelperLog('WhenReaderCardOut�˳�.');
  {$ENDIF}

  gERelayManager.LineClose(nHost.FTunnel);
  Sleep(100);

  if nHost.FETimeOut then
       gERelayManager.ShowTxt(nHost.FTunnel, '���ӱ�ǩ������Χ')
  else gERelayManager.ShowTxt(nHost.FTunnel, nHost.FLEDText);
  Sleep(100);
end;

//------------------------------------------------------------------------------
//Date: 2012-12-16
//Parm: �ſ���
//Desc: ��nCardNo���Զ�����(ģ���ͷˢ��)
procedure MakeTruckAutoOut(const nCardNo: string);
var nReader,nExtReader: string;
begin
  //if gTruckQueueManager.IsTruckAutoOut then
  begin
    nReader := gHardwareHelper.GetReaderLastOn(nCardNo,nExtReader);
    WriteHardHelperLog('MakeTruckAutoOut:nReader='+nReader);
    if nReader <> '' then
      gHardwareHelper.SetReaderCard(nReader, nCardNo);
    //ģ��ˢ��
  end;
end;

//Date: 2012-12-16
//Parm: ��������
//Desc: ����ҵ���м����Ӳ���ػ��Ľ�������
procedure WhenBusinessMITSharedDataIn(const nData: string);
begin
  WriteHardHelperLog('�յ�Bus_MITҵ������:::' + nData);
  //log data

  if Pos('TruckOut', nData) = 1 then
    MakeTruckAutoOut(Copy(nData, Pos(':', nData) + 1, MaxInt));
  //auto out
end;

//Date: 2013-07-17
//Parm: ������ͨ��
//Desc: ����nTunnel�������
procedure WhenSaveJS(const nTunnel: PMultiJSTunnel);
var nStr: string;
    nDai: Word;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nDai := nTunnel.FHasDone - nTunnel.FLastSaveDai;
  if nDai <= 0 then Exit;
  //invalid dai num

  if nTunnel.FLastBill = '' then Exit;
  //invalid bill

  nList := nil;
  try
    nList := TStringList.Create;
    nList.Values['Bill'] := nTunnel.FLastBill;
    nList.Values['Dai'] := IntToStr(nDai);

    nStr := PackerEncodeStr(nList.Text);
    CallHardwareCommand(cBC_SaveCountData, nStr, '', @nOut)
  finally
    nList.Free;
  end;
end;

function VerifySnapTruck(const nTruck,nBill,nPos,nDept: string; var nResult: string): Boolean;
var nList: TStrings;
    nOut: TWorkerBusinessCommand;
    nID,nDefDept: string;
begin
  {$IFDEF QHSN}
  nDefDept := 'cmmg';
  {$ELSE}
  nDefDept := '�Ÿ�';
  {$ENDIF}
  if nBill = '' then
    nID := nTruck + FormatDateTime('YYMMDD',Now)
  else
    nID := nBill;
  nList := nil;
  try
    nList := TStringList.Create;
    nList.Values['Truck'] := nTruck;
    nList.Values['Bill'] := nID;
    nList.Values['Pos'] := nPos;
    if nDept = '' then
      nList.Values['Dept'] := nDefDept
    else
      nList.Values['Dept'] := nDept;

    Result := CallBusinessCommand(cBC_VerifySnapTruck, nList.Text, '', @nOut);
    nResult := nOut.FData;
  finally
    nList.Free;
  end;
end;

end.
