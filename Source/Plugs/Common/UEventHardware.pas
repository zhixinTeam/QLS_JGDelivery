{*******************************************************************************
  作者: dmzn@163.com 2013-11-23
  描述: 模块工作对象,用于响应框架事件
*******************************************************************************}
unit UEventHardware;

{$I Link.Inc}
interface

uses
  Windows, Classes, UMgrPlug, UBusinessConst, ULibFun, UMITConst, UPlugConst;

type
  THardwareWorker = class(TPlugEventWorker)
  public
    class function ModuleInfo: TPlugModuleInfo; override;
    procedure RunSystemObject(const nParam: PPlugRunParameter); override;
    procedure InitSystemObject; override;
    //主程序启动时初始化
    procedure BeforeStartServer; override;
    //服务启动之前调用
    procedure AfterStopServer; override;
    //服务关闭之后调用
    {$IFDEF DEBUG}
    procedure GetExtendMenu(const nList: TList); override;
    {$ENDIF}
  end;

var
  gPlugRunParam: TPlugRunParameter;
  //运行参数

implementation

uses
  SysUtils, USysLoger, UHardBusiness, UMgrTruckProbe, UMgrParam,
  UMgrQueue, UMgrLEDCard, UMgrHardHelper, UMgrRemotePrint, U02NReader,
  UMgrERelay, {$IFDEF QHSN} UMultiJS_Reply, {$ELSE}UMultiJS,{$ENDIF}
  UMgrRemoteVoice, UMgrCodePrinter, UMgrLEDDisp, UMgrRFID102,
  UMgrVoiceNet, UMgrRemoteSnap;

class function THardwareWorker.ModuleInfo: TPlugModuleInfo;
begin
  Result := inherited ModuleInfo;
  with Result do
  begin
    FModuleID := sPlug_ModuleHD;
    FModuleName := '硬件守护';
    FModuleVersion := '2014-09-30';
    FModuleDesc := '提供水泥一卡通发货的硬件处理对象';
    FModuleBuildTime:= Str2DateTime('2014-09-30 15:01:01');
  end;
end;

procedure THardwareWorker.RunSystemObject(const nParam: PPlugRunParameter);
var nStr,nCfg: string;
begin
  gPlugRunParam := nParam^;
  nCfg := gPlugRunParam.FAppPath + 'Hardware\';

  try
    nStr := 'LED';
    gCardManager.TempDir := nCfg + 'Temp\';
    gCardManager.FileName := nCfg + 'LED.xml';

    nStr := '远距读头';
    gHardwareHelper.LoadConfig(nCfg + '900MK.xml');

    nStr := '近距读头';
    if not Assigned(g02NReader) then
    begin
      g02NReader := T02NReader.Create;
      g02NReader.LoadConfig(nCfg + 'Readers.xml');
    end;

    nStr := '计数器';
    if not Assigned(gMultiJSManager) then
    begin
      gMultiJSManager := TMultiJSManager.Create;
      gMultiJSManager.LoadFile(nCfg + 'JSQ.xml');
    end;

    nStr := '继电器';
    gERelayManager.LoadConfig(nCfg + 'ERelay.xml');

    nStr := '远程打印';
    gRemotePrinter.LoadConfig(nCfg + 'Printer.xml');

    nStr := '语音服务';
    gVoiceHelper.LoadConfig(nCfg + 'Voice.xml');

    nStr := '网络语音服务';
    if FileExists(nCfg + 'NetVoice.xml') then
    begin
      if not Assigned(gNetVoiceHelper) then
        gNetVoiceHelper := TNetVoiceManager.Create;
      gNetVoiceHelper.LoadConfig(nCfg + 'NetVoice.xml');
    end;     

    nStr := '喷码机';
    gCodePrinterManager.LoadConfig(nCfg + 'CodePrinter.xml');

    nStr := '小屏显示';
    gDisplayManager.LoadConfig(nCfg + 'LEDDisp.xml');
    gDisplayManager.StartDisplay;

    {$IFDEF HYRFID201}
    nStr := '华益RFID102';
    if not Assigned(gHYReaderManager) then
    begin
      gHYReaderManager := THYReaderManager.Create;
      gHYReaderManager.LoadConfig(nCfg + 'RFID102.xml');
    end;
    {$ENDIF}

    nStr := '车辆检测器';    
    if FileExists(nCfg + 'TruckProber.xml') then
    begin
      gProberManager := TProberManager.Create;
      gProberManager.LoadConfig(nCfg + 'TruckProber.xml');
    end;

    {$IFDEF RemoteSnap}
    nStr := '海康威视远程抓拍';
    if FileExists(nCfg + 'RemoteSnap.xml') then
    begin
      //gHKSnapHelper := THKSnapHelper.Create;
      gHKSnapHelper.LoadConfig(nCfg + 'RemoteSnap.xml');
    end;
    {$ENDIF}
  except
    on E:Exception do
    begin
      nStr := Format('加载[ %s ]配置文件失败: %s', [nStr, E.Message]);
      gSysLoger.AddLog(nStr);
    end;
  end;
end;

{$IFDEF DEBUG}
procedure THardwareWorker.GetExtendMenu(const nList: TList);
var nItem: PPlugMenuItem;
begin
  New(nItem);
  nList.Add(nItem);
  nItem.FName := 'Menu_Param_2';

  nItem.FModule := ModuleInfo.FModuleID;
  nItem.FCaption := '硬件测试';
  nItem.FFormID := cFI_FormTest2;
  nItem.FDefault := False;
end;
{$ENDIF}

procedure THardwareWorker.InitSystemObject;
begin
  gHardwareHelper := THardwareHelper.Create;
  //远距读头

  gHardShareData := WhenBusinessMITSharedDataIn;
  //hard monitor share
end;

procedure THardwareWorker.BeforeStartServer;
begin
  {$IFDEF QHSN}
  gTruckQueueManager.StartQueue(gParamManager.ActiveParam.FDB.FID);
  {$ENDIF}
  //truck queue

  gHardwareHelper.OnProce := WhenReaderCardArrived;
  gHardwareHelper.StartRead;
  //long reader

  {$IFDEF HYRFID201}
  if Assigned(gHYReaderManager) then
  begin
    gHYReaderManager.OnCardProc := WhenHYReaderCardArrived;
    gHYReaderManager.StartReader;
  end;
  {$ENDIF}

  g02NReader.OnCardIn := WhenReaderCardIn;
  g02NReader.OnCardOut := WhenReaderCardOut;
  g02NReader.StartReader;
  //near reader
  {$IFDEF QHSN}
  gMultiJSManager.SaveDataProc := WhenSaveJS;
  gMultiJSManager.StartJS;
  //counter
  
  gERelayManager.ControlStart;
  {$ENDIF}
  //erelay

  gRemotePrinter.StartPrinter;
  //printer
  gVoiceHelper.StartVoice;
  //voice

  if Assigned(gNetVoiceHelper) then
    gNetVoiceHelper.StartVoice;
  //NetVoice
  {$IFDEF QHSN}
  gCardManager.StartSender;
  {$ENDIF}
  //led display
//  gDisplayManager.StartDisplay;
  //small led
  gProberManager.StartProber;
  //TruckProbe

  {$IFDEF RemoteSnap}
  gHKSnapHelper.StartSnap;
  //remote snap
  {$ENDIF}
end;

procedure THardwareWorker.AfterStopServer;
begin
  gVoiceHelper.StopVoice;
  //voice
  gRemotePrinter.StopPrinter;
  //printer
  if Assigned(gNetVoiceHelper) then
    gNetVoiceHelper.StopVoice;
  //NetVoice  
  {$IFDEF QHSN}
  gERelayManager.ControlStop;
  {$ENDIF}
  //erelay
  gMultiJSManager.StopJS;
  //counter

  g02NReader.StopReader;
  g02NReader.OnCardIn := nil;
  g02NReader.OnCardOut := nil;

  gHardwareHelper.StopRead;
  gHardwareHelper.OnProce := nil;
  //reader

  {$IFDEF HYRFID201}
  if Assigned(gHYReaderManager) then
  begin
    gHYReaderManager.StopReader;
    gHYReaderManager.OnCardProc := nil;
  end;
  {$ENDIF}

  gDisplayManager.StopDisplay;
  //small led
  {$IFDEF QHSN}
  gCardManager.StopSender;
  {$ENDIF}
  //led
  gProberManager.StopProber;
  //TruckProbe
  gTruckQueueManager.StopQueue;
  //queue
  {$IFDEF RemoteSnap}
  gHKSnapHelper.StopSnap;
  //remote snap
  {$ENDIF}
end;

end.
