{*******************************************************************************
  ����: dmzn@163.com 2010-3-8
  ����: ϵͳҵ����
*******************************************************************************}
unit USysBusiness;

interface
{$I Link.inc}
uses
  Windows, DB, Classes, Controls, SysUtils, UBusinessPacker, UBusinessWorker,
  UBusinessConst, ULibFun, UAdjustForm, UFormCtrl, UDataModule, UDataReport,
  UFormBase, cxMCListBox, cxDropDownEdit, UMgrPoundTunnels, USysConst,
  USysDB, USysLoger, HKVNetSDK, DateUtils, StdCtrls;

const
  sFlag_Departmen_DT = '����';
  sFlag_Departmen_BF = '����';
  sFlag_Departmen_JZ = '��װ';

  sFlag_Solution_YN  = 'Y=ͨ��;N=��ֹ';
  sFlag_Solution_YNI = 'Y=ͨ��;N=��ֹ;I=����';  
type
  TLadingStockItem = record
    FID: string;         //���
    FType: string;       //����
    FName: string;       //����
    FParam: string;      //��չ
  end;

  TDynamicStockItemArray = array of TLadingStockItem;
  //ϵͳ���õ�Ʒ���б�

  PZTLineItem = ^TZTLineItem;
  TZTLineItem = record
    FID       : string;      //���
    FName     : string;      //����
    FStock    : string;      //Ʒ��
    FWeight   : Integer;     //����
    FValid    : Boolean;     //�Ƿ���Ч
    FPrinterOK: Boolean;     //�����
  end;

  PZTTruckItem = ^TZTTruckItem;
  TZTTruckItem = record
    FTruck    : string;      //���ƺ�
    FLine     : string;      //ͨ��
    FBill     : string;      //�����
    FValue    : Double;      //�����
    FDai      : Integer;     //����
    FTotal    : Integer;     //����
    FInFact   : Boolean;     //�Ƿ����
    FIsRun    : Boolean;     //�Ƿ�����    
  end;

  TZTLineItems = array of TZTLineItem;
  TZTTruckItems = array of TZTTruckItem;
  
//------------------------------------------------------------------------------
function AdjustHintToRead(const nHint: string): string;
//������ʾ����
function WorkPCHasPopedom: Boolean;
//��֤�����Ƿ�����Ȩ
function GetSysValidDate: Integer;
//��ȡϵͳ��Ч��
function GetTruckEmptyValue(nTruck: string; var nPrePUse:string): Double;
function GetSerialNo(const nGroup,nObject: string; nUseDate: Boolean = True): string;
//��ȡ���б��
function GetLadingStockItems(var nItems: TDynamicStockItemArray): Boolean;
//����Ʒ���б�
function GetCardUsed(const nCard: string): string;
//��ȡ��Ƭ����

function LoadSysDictItem(const nItem: string; const nList: TStrings): TDataSet;
//��ȡϵͳ�ֵ���
function LoadSaleMan(const nList: TStrings; const nWhere: string = ''): Boolean;
//��ȡҵ��Ա�б�
function LoadCustomer(const nList: TStrings; const nWhere: string = ''): Boolean;
//��ȡ�ͻ��б�
function LoadCustomerInfo(const nCID: string; const nList: TcxMCListBox;
 var nHint: string): TDataSet;
//����ͻ���Ϣ

function IsZhiKaNeedVerify: Boolean;
//ֽ���Ƿ���Ҫ���
function IsPrintZK: Boolean;
//�Ƿ��ӡֽ��
function DeleteZhiKa(const nZID: string): Boolean;
//ɾ��ָ��ֽ��
function LoadZhiKaInfo(const nZID: string; const nList: TcxMCListBox;
 var nHint: string): TDataset;
//����ֽ��
function GetZhikaValidMoney(nZhiKa: string; var nFixMoney: Boolean): Double;
//ֽ�����ý�
function GetCustomerValidMoney(nCID: string; const nLimit: Boolean = True;
 const nCredit: PDouble = nil): Double;
//�ͻ����ý��

function SyncRemoteCustomer(nCustID:string=''; nDataAreaID:string=''): Boolean;
//ͬ��Զ���û�
function SyncRemoteSaleMan: Boolean;
//ͬ��Զ��ҵ��Ա
function SyncRemoteProviders: Boolean;
//ͬ��Զ���û�
function SyncRemoteMeterails: Boolean;
//ͬ��Զ��ҵ��Ա
function SaveXuNiCustomer(const nName,nSaleMan: string): string;
//����ʱ�ͻ�
function IsAutoPayCredit: Boolean;
//�ؿ�ʱ������
function SaveCustomerPayment(const nCusID,nCusName,nSaleMan: string;
 const nType,nPayment,nMemo: string; const nMoney: Double;
 const nCredit: Boolean = True): Boolean;
//����ؿ��¼
function SaveCustomerCredit(const nCusID,nMemo: string; const nCredit: Double;
 const nEndTime: TDateTime): Boolean;
//�������ü�¼
function IsCustomerCreditValid(const nCusID: string): Boolean;
//�ͻ������Ƿ���Ч

function IsStockValid(const nStocks: string): Boolean;
//Ʒ���Ƿ���Է���
function SaveBill(const nBillData: string): string;
//���潻����
function DeleteBill(const nBill: string): Boolean;
//ɾ��������
function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;
//�����������
function BillSaleAdjust(const nBill, nNewZK: string): Boolean;
//����������
function SetBillCard(const nBill,nTruck: string; nVerify: Boolean): Boolean;
//Ϊ����������ſ�
function SaveBillCard(const nBill, nCard: string): Boolean;
//���潻�����ſ�
function LogoutBillCard(const nCard: string;const nNeidao:string=''): Boolean;
//ע��ָ���ſ�
function SetTruckRFIDCard(nTruck: string; var nRFIDCard, nRFIDCard2: string;
  var nIsUse: string; nOldCard: string=''; nOldCard2: string=''): Boolean;

function GetLadingBills(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
//��ȡָ����λ�Ľ������б�
procedure LoadBillItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);
//���뵥����Ϣ���б�
function SaveLadingBills(var nFoutData:string; const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem = nil): Boolean;
//����ָ����λ�Ľ�����

function GetTruckPoundItem(const nTruck: string;
 var nPoundData: TLadingBillItems): Boolean;
//��ȡָ���������ѳ�Ƥ����Ϣ
function SaveTruckPoundItem(const nTunnel: PPTTunnelItem;
 const nData: TLadingBillItems): Boolean;
//���泵��������¼
function ReadPoundCard(var nReader: string;const nTunnel: string): string;
//��ȡָ����վ��ͷ�ϵĿ���
function OpenDoor(const nCardNo,nPos: string): string;  //nPos: 0:��ڵ�բ 1�����ڵ�բ
//������բ
function IsTunnelOK(const nPoundTunnelFID: string): string;
//��ѯ�����դͨ��״̬
function TunnelOC(const nPoundTunnelFID,nIsOK:string): string;
//�����رպ��̵�
procedure CapturePicture(const nTunnel: PPTTunnelItem; const nList: TStrings);
//ץ��ָ��ͨ��

function SaveOrderBase(const nOrderData: string): string;
//����ɹ����뵥
function DeleteOrderBase(const nOrder: string): Boolean;
//ɾ���ɹ����뵥
function SaveOrder(const nOrderData: string): string;
//����ɹ���
function DeleteOrder(const nOrder: string): Boolean;
//ɾ���ɹ���
//function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;
////�����������
function SetOrderCard(const nOrder,nTruck: string; nVerify: Boolean): Boolean;
//Ϊ�ɹ�������ſ�
function SaveOrderCard(const nOrder, nCard: string): Boolean;
//����ɹ����ſ�
function LogoutOrderCard(const nCard: string;const nNeiDao:string=''): Boolean;
//ע��ָ���ſ�
function ChangeOrderTruckNo(const nOrder,nTruck: string): Boolean;
//�޸ĳ��ƺ�

function GetPurchaseOrders(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
//��ȡָ����λ�Ĳɹ����б�
function SavePurchaseOrders(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem = nil): Boolean;
//����ָ����λ�Ĳɹ���
function GetDuanDaoOrders(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
//��ȡָ����λ�Ķ̵���
function SaveDuanDaoOrders(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem = nil): Boolean;
//����ָ����λ�Ĳɹ���

procedure LoadOrderItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);

function LoadTruckQueue(var nLines: TZTLineItems; var nTrucks: TZTTruckItems;
 const nRefreshLine: Boolean = False): Boolean;
//��ȡ��������
procedure PrinterEnable(const nTunnel: string; const nEnable: Boolean);
//��ͣ�����
function ChangeDispatchMode(const nMode: Byte): Boolean;
//�л�����ģʽ

function GetHYMaxValue: Double;
function GetHYValueByStockNo(const nNo: string): Double;
//��ȡ���鵥�ѿ���
function GetOrderRestValue(nTotalValue: Double; nRecId: string): string;
//��ȡ����ʣ����
function GetOrderLimValue: Double;
//��ȡ������������ֵ
function IsDealerLadingIDExit(const nDealerID: string): Boolean;
//��龭���̵����Ƿ��Ѵ���
function IsEleCardVaid(const nStockType,nTruckNo,nStockNo: string): Boolean;
//���ɢװ�����Ƿ��������õ��ӱ�ǩ
function IsWeekValid(const nWeek: string; var nHint: string): Boolean;
//�����Ƿ���Ч
function IsWeekHasEnable(const nWeek: string): Boolean;
//�����Ƿ�����
function IsNextWeekEnable(const nWeek: string): Boolean;
//��һ�����Ƿ�����
function IsPreWeekOver(const nWeek: string): Integer;
//��һ�����Ƿ����
function SaveCompensation(const nSaleMan,nCusID,nCusName,nPayment,nMemo: string;
 const nMoney: Double): Boolean;
//�����û�������

//------------------------------------------------------------------------------
procedure PrintSaleContractReport(const nID: string; const nAsk: Boolean);
//��ӡ��ͬ
function PrintZhiKaReport(const nZID: string; const nAsk: Boolean): Boolean;
//��ӡֽ��
function PrintShouJuReport(const nSID: string; const nAsk: Boolean): Boolean;
//��ӡ�վ�
function PrintBillReport(nBill: string; const nAsk: Boolean): Boolean;
//��ӡ�����
function PrintBill4(nBill: string; const nAsk: Boolean): Boolean;
//�ֳ���ӡ�����4
function PrintBill6(nBill: string; const nAsk: Boolean): Boolean;
//�ֳ���ӡ�����6
function PrintOrderReport(const nOrder: string;  const nAsk: Boolean): Boolean;
//��ӡ�ɹ���
function PrintPoundReport(const nPound: string; nAsk: Boolean): Boolean;
//��ӡ��
function PrintHuaYanReport(const nHID: string; const nAsk: Boolean;const nHydan:string=''): Boolean;
function PrintHeGeReport(const nHID: string; const nAsk: Boolean;const nHydan:string=''): Boolean;
//���鵥,�ϸ�֤
function SyncTPRESTIGEMANAGE(nCusID:string=''; nDataArea :string=''): Boolean;
//ͬ��AX���ö�ȣ��ͻ�����DLϵͳ by lih 2016-07-19
function SyncTPRESTIGEMBYCONT(nCusID:string=''; nDataArea :string=''): Boolean;
//ͬ��AX���ö�ȣ��ͻ�-�ͻ�����DLϵͳ by lih 2016-07-19
function SyncINVENTDIM: Boolean;
//ͬ��AXά����Ϣ��DLϵͳ by lih 2016-07-19
function SyncINVENTCENTER: Boolean;
//ͬ��AX��������Ϣ��DLϵͳ by lih 2016-07-19
function SyncINVENTLOCATION: Boolean;
//ͬ��AX�ֿ���Ϣ��DLϵͳ by lih 2016-07-19
function SyncInvCenGroup: Boolean;
//ͬ��AX��������������Ϣ��DLϵͳ by lih 2016-07-19
function SyncEmpTable: Boolean;
//ͬ��AXԱ����Ϣ��DLϵͳ by lih 2016-07-19
function SyncCement: Boolean;
//ͬ��AXˮ�����͵�DLϵͳ
function SyncWmsLocation: Boolean;
//ͬ��AX��λ��Ϣ��DL
function GetSampleID(nStockName:string; var nSampleDate:string):string;
//��ȡ�������
function GetCenterID(nStockNo:string; var nLocationID:string):string;
//��ȡ������ID
function PrintHYReport(const nBill: string; const nAsk: Boolean): Boolean;
//��ӡ�泵���鵥
function PrintDaiBill(nBill: string; const nAsk: Boolean): Boolean;
//��ӡ��װ��Ʊ��
function GetAXSalesOrder(nSaleID:string=''; nDataArea :string=''): Boolean;
//��ȡ���۶���
function GetAXSalesOrdLine(nSaleID:string=''; nDataArea :string=''): Boolean;
//��ȡ���۶�����
function GetAXSupAgreement(nBillID:string=''; nDataArea :string=''): Boolean;
//��ȡ����Э��
function GetAXSalesContract(nContID:string=''; nDataArea :string=''): Boolean;
//��ȡ���ۺ�ͬ
function GetAXSalesContLine(nContID:string=''; nDataArea :string=''): Boolean;
//��ȡ���ۺ�ͬ��
function GetAXVehicleNo(nVehID:string=''; nDataArea :string=''): Boolean;
//��ȡ����
function GetAXPurOrder(nPurID:string=''; nDataArea :string=''): Boolean;
//��ȡ�ɹ�����
function GetAXPurOrdLine(nPurID:string=''; nDataArea :string=''): Boolean;
//��ȡ�ɹ�������
function LoadAddTreaty(RecID:string; var nNewPrice:Double):Boolean;
//��ȡ����Э��۸�

function AddManualEventRecord(nEID, nKey, nEvent:string;
    nFrom: string = '����'; nSolution: string=sFlag_Solution_YN;
    nDepartmen: string=sFlag_DepartMen_DT): Boolean;
//��Ӵ����������¼
function VerifyManualEventRecord(const nEID: string; var nHint: string;
    const nWant: string = 'Y'): Boolean;
//����¼��Ƿ�ͨ������

function GetPoundWc(nNet:Double; var nDaiZ,nDaiF:Double;const nw_type:string='1'):Boolean;
//��ȡ��װ���
procedure InitCenter(const nStockNo,nType: string; const nCbx:TcxComboBox);
//��ʼ��������ID
function CheckTruckOK(const nTruck:string):Boolean;
//��鳵���ϴγ����Ƿ񳬹�һ��Сʱ
function CheckTruckBilling(const nTruck:string):Boolean;     
//��鳵���Ƿ����п���
function CheckTruckCount(const nStockName: string):Boolean;
//��鳧�ڳ������Ƿ�ﵽ����
procedure InitSampleID(const nStockName,nType,nCenterID: string; const nCbx:TcxComboBox);
//��ʼ���������
function GetSumTonnage(const nSampleID: string):Double;
//��ȡ�����������װ����
function GetSampleTonnage(const nSampleID: string; var nBatQuaS,nBatQuaE:Double):Boolean;
//��ȡ������
function UpdateSampleValid(const nSampleID: string):Boolean;
//�������������Ч��
function LoadNoSampleID(const nStockNo: string):Boolean;
//�Ƿ������������
procedure InitKuWei(const nType: string; const nCbx:TcxComboBox;const nIdlist:TStrings=nil);
//��ʼ����λ��
function GetCompanyArea(const nSaleID,nCompanyID:string):string;
//���߻�ȡ��������
procedure SaveCompanyArea(const nXSQYMC,nSaleID:string);
//����������������
function PrintDuanDaoReport(nID: string; const nAsk: Boolean): Boolean;
//��ӡ�̵�����
function PrintYesNo:Boolean;
//�Ƿ��ӡ
function SaveTransferInfo(nTruck, nMateID, nMate, nSrcAddr, nDstAddr:string):Boolean;
//�̵��ſ�����

function GetAutoInFactory(const nStockNo:string):Boolean;
//��ȡ�Ƿ��Զ�����
function GetCenterSUM(nStockNo,nStockType,nCenterID:string):string;
//��ȡ����������
function GetZhikaYL(nRECID:string):Double;
//��ȡֽ������
function GetNeiDao(const nStockNo:string):Boolean;
//��ȡ�ڵ�����
procedure GetCustomerExt(const nCusID:string; const nCbx:TComboBox);
//��ȡ�ͻ���չ��Ϣ
procedure SaveCustomerExt(const nCusID,nCusExtName:string);
//����ͻ���չ��Ϣ
function getCustomerInfo(const nXmlStr: string): string;
//��ȡ�ͻ�ע����Ϣ
function get_Bindfunc(const nXmlStr: string): string;
//�ͻ���΢���˺Ű�
function send_event_msg(const nXmlStr: string): string;
//������Ϣ
function edit_shopclients(const nXmlStr: string): string;
//�����̳��û�
function edit_shopgoods(const nXmlStr: string): string;
//�����Ʒ
function get_shoporders(const nXmlStr: string): string;
//��ȡ������Ϣ
function GetDaoChe(const nStockNo:string):Boolean;
//��ȡ�����°�����
function GetPurchRestValue(const nRecID:string; var nIfCheck:Boolean):Double;
//��ȡ�ɹ���������
function LoadSalesInfo(const nZID: string; var nHint: string): TDataset;
//���붩����Ϣ
function LoadSaleLineInfo(const nRecID: string; var nHint: string): TDataset;
//���붩����
function LoadAXPlanInfo(const nID: string; var nHint: string): TDataset;
//���������Ϣ
function IsBrick(const nStockno:string):Boolean;

function VerifyZTlineChange(const nLineID: string): Boolean;
//У��װ����nLineIDˮ��Ʒ�ֱ��ʱ��������Ŷӳ������޷��޸�
function VeriFySnapTruck(const nReader: string; nBill: TLadingBillItem;
                         var nMsg, nPos: string): Boolean;
function ReadPoundReaderInfo(const nReader: string; var nDept: string): string;
//��ȡnReader��λ������
procedure RemoteSnapDisPlay(const nPost, nText, nSucc: string);

implementation

//Desc: ��¼��־
procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(nEvent);
end;

//------------------------------------------------------------------------------
//Desc: ����nHintΪ�׶��ĸ�ʽ
function AdjustHintToRead(const nHint: string): string;
var nIdx: Integer;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    nList.Text := nHint;
    for nIdx:=0 to nList.Count - 1 do
      nList[nIdx] := '��.' + nList[nIdx];
    Result := nList.Text;
  finally
    nList.Free;
  end;
end;

//Desc: ��֤�����Ƿ�����Ȩ����ϵͳ
function WorkPCHasPopedom: Boolean;
begin
  Result := gSysParam.FSerialID <> '';
  if not Result then
  begin
    ShowDlg('�ù�����Ҫ����Ȩ��,�������Ա����.', sHint);
  end;
end;

//------------------------------------------------------------------------------
//Desc: ������ЧƤ��
function GetTruckEmptyValue(nTruck: string; var nPrePUse:string): Double;
var nStr: string;
begin
  nStr := 'Select T_PValue,T_PrePValue,T_PrePUse From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, nTruck]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nPrePUse:= Fields[2].AsString;
    {$IFDEF YDKP}
    if Fields[2].AsString='Y' then
      Result := Fields[1].AsFloat
    else
      Result := Fields[0].AsFloat;
    {$ELSE}
    Result := Fields[0].AsFloat;
    {$ENDIF}
  end else Result := 0;
end;

//Date: 2014-09-05
//Parm: ����;����;����;���
//Desc: �����м���ϵ�ҵ���������
function CallBusinessCommand(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //�Զ�����ʱ����ʾ

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessCommand);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-09-05
//Parm: ����;����;����;���
//Desc: �����м���ϵ����۵��ݶ���
function CallBusinessSaleBill(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //�Զ�����ʱ����ʾ

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessSaleBill);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-09-05
//Parm: ����;����;����;���
//Desc: �����м���ϵ����۵��ݶ���
function CallBusinessPurchaseOrder(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //�Զ�����ʱ����ʾ

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessPurchaseOrder);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-10-01
//Parm: ����;����;����;���
//Desc: �����м���ϵ����۵��ݶ���
function CallBusinessHardware(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //�Զ�����ʱ����ʾ
    
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_HardwareCommand);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-09-05
//Parm: ����;����;����;���
//Desc: �����м���ϵĶ̵����ݶ���
function CallBusinessDuanDao(const nCmd: Integer; const nData,nExt: string;
  const nOut: PWorkerBusinessCommand; const nWarn: Boolean = True): Boolean;
var nIn: TWorkerBusinessCommand;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;
  try
    nIn.FCommand := nCmd;
    nIn.FData := nData;
    nIn.FExtParam := nExt;

    if nWarn then
         nIn.FBase.FParam := ''
    else nIn.FBase.FParam := sParam_NoHintOnError;

    if gSysParam.FAutoPound and (not gSysParam.FIsManual) then
      nIn.FBase.FParam := sParam_NoHintOnError;
    //�Զ�����ʱ����ʾ

    nWorker := gBusinessWorkerManager.LockWorker(sCLI_BusinessDuanDao);
    //get worker
    Result := nWorker.WorkActive(@nIn, nOut);

    if not Result then
      WriteLog(nOut.FBase.FErrDesc);
    //xxxxx
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2014-09-04
//Parm: ����;����;ʹ�����ڱ���ģʽ
//Desc: ����nGroup.nObject���ɴ��б��
function GetSerialNo(const nGroup,nObject: string; nUseDate: Boolean): string;
var nStr: string;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  Result := '';
  nList := nil;
  try
    nList := TStringList.Create;
    nList.Values['Group'] := nGroup;
    nList.Values['Object'] := nObject;

    if nUseDate then
         nStr := sFlag_Yes
    else nStr := sFlag_No;

    if CallBusinessCommand(cBC_GetSerialNO, nList.Text, nStr, @nOut) then
      Result := nOut.FData;
    //xxxxx
  finally
    nList.Free;
  end;   
end;

//Desc: ��ȡϵͳ��Ч��
function GetSysValidDate: Integer;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_IsSystemExpired, '', '', @nOut) then
       Result := StrToInt(nOut.FData)
  else Result := 0;
end;

function GetCardUsed(const nCard: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_GetCardUsed, nCard, '', @nOut) then
    Result := nOut.FData;
  //xxxxx
end;

//Desc: ��ȡ��ǰϵͳ���õ�ˮ��Ʒ���б�
function GetLadingStockItems(var nItems: TDynamicStockItemArray): Boolean;
var nStr: string;
    nIdx: Integer;
begin
  nStr := 'Select D_Value,D_Memo,D_ParamB From $Table ' +
          'Where D_Name=''$Name'' Order By D_Index ASC';
  nStr := MacroValue(nStr, [MI('$Table', sTable_SysDict),
                            MI('$Name', sFlag_StockItem)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    SetLength(nItems, RecordCount);
    if RecordCount > 0 then
    begin
      nIdx := 0;
      First;

      while not Eof do
      begin
        nItems[nIdx].FType := FieldByName('D_Memo').AsString;
        nItems[nIdx].FName := FieldByName('D_Value').AsString;
        nItems[nIdx].FID := FieldByName('D_ParamB').AsString;

        Next;
        Inc(nIdx);
      end;
    end;
  end;

  Result := Length(nItems) > 0;
end;

//------------------------------------------------------------------------------
//Date: 2014-06-19
//Parm: ��¼��ʶ;���ƺ�;ͼƬ�ļ�
//Desc: ��nFile�������ݿ�
procedure SavePicture(const nID, nTruck, nMate, nFile: string);
var nStr: string;
    nRID: Integer;
begin
  FDM.ADOConn.BeginTrans;
  try
    nStr := MakeSQLByStr([
            SF('P_ID', nID),
            SF('P_Name', nTruck),
            SF('P_Mate', nMate),
            SF('P_Date', sField_SQLServer_Now, sfVal)
            ], sTable_Picture, '', True);
    //xxxxx

    if FDM.ExecuteSQL(nStr) < 1 then Exit;
    nRID := FDM.GetFieldMax(sTable_Picture, 'R_ID');

    nStr := 'Select P_Picture From %s Where R_ID=%d';
    nStr := Format(nStr, [sTable_Picture, nRID]);
    FDM.SaveDBImage(FDM.QueryTemp(nStr), 'P_Picture', nFile);

    FDM.ADOConn.CommitTrans;
  except
    FDM.ADOConn.RollbackTrans;
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

//Date: 2014-06-19
//Parm: ͨ��;�б�
//Desc: ץ��nTunnel��ͼ��
procedure CapturePicture(const nTunnel: PPTTunnelItem; const nList: TStrings);
const
  cRetry = 2;
  //���Դ���
var nStr: string;
    nIdx,nInt: Integer;
    nLogin,nErr: Integer;
    nPic: NET_DVR_JPEGPARA;
    nInfo: TNET_DVR_DEVICEINFO;
begin
  nList.Clear;
  if not Assigned(nTunnel.FCamera) then Exit;
  //not camera

  if not DirectoryExists(gSysParam.FPicPath) then
    ForceDirectories(gSysParam.FPicPath);
  //new dir

  if gSysParam.FPicBase >= 100 then
    gSysParam.FPicBase := 0;
  //clear buffer

  nLogin := -1;
  //gCameraNetSDKMgr.NET_DVR_SetDevType(nTunnel.FCamera.FType);
  //xxxxx

  //gCameraNetSDKMgr.NET_DVR_Init;
  //xxxxx
  NET_DVR_Init();
  try
    for nIdx:=1 to cRetry do
    begin
      {nLogin := gCameraNetSDKMgr.NET_DVR_Login(nTunnel.FCamera.FHost,
                   nTunnel.FCamera.FPort,
                   nTunnel.FCamera.FUser,
                   nTunnel.FCamera.FPwd, nInfo); }
      nLogin := NET_DVR_Login(PChar(nTunnel.FCamera.FHost),
                   nTunnel.FCamera.FPort,
                   PChar(nTunnel.FCamera.FUser),
                   PChar(nTunnel.FCamera.FPwd), @nInfo);
      //to login

      nErr := NET_DVR_GetLastError;
      if nErr = 0 then break;

      if nIdx = cRetry then
      begin
        nStr := '��¼�����[ %s.%d ]ʧ��,������: %d';
        nStr := Format(nStr, [nTunnel.FCamera.FHost, nTunnel.FCamera.FPort, nErr]);
        WriteLog(nStr);
        Exit;
      end;
    end;

    nPic.wPicSize := nTunnel.FCamera.FPicSize;
    nPic.wPicQuality := nTunnel.FCamera.FPicQuality;

    for nIdx:=Low(nTunnel.FCameraTunnels) to High(nTunnel.FCameraTunnels) do
    begin
      if nTunnel.FCameraTunnels[nIdx] = MaxByte then continue;
      //invalid

      for nInt:=1 to cRetry do
      begin
        nStr := MakePicName();
        //file path

        {gCameraNetSDKMgr.NET_DVR_CaptureJPEGPicture(nLogin,
                                   nTunnel.FCameraTunnels[nIdx],
                                   nPic, nStr); }
         NET_DVR_CaptureJPEGPicture(nLogin, nTunnel.FCameraTunnels[nIdx],
                                   @nPic, PChar(nStr));
        //capture pic

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
          WriteLog(nStr);
        end;
      end;
    end;
  finally
    if nLogin > -1 then
      NET_DVR_Logout(nLogin);
    NET_DVR_Cleanup();
  end;
end;

//------------------------------------------------------------------------------
//Date: 2010-4-13
//Parm: �ֵ���;�б�
//Desc: ��SysDict�ж�ȡnItem�������,����nList��
function LoadSysDictItem(const nItem: string; const nList: TStrings): TDataSet;
var nStr: string;
begin
  nList.Clear;
  nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                      MI('$Name', nItem)]);
  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount > 0 then
  with Result do
  begin
    First;

    while not Eof do
    begin
      nList.Add(FieldByName('D_Value').AsString);
      Next;
    end;
  end else Result := nil;
end;

//Desc: ��ȡҵ��Ա�б�nList��,������������
function LoadSaleMan(const nList: TStrings; const nWhere: string = ''): Boolean;
var nStr,nW: string;
begin
  if nWhere = '' then
       nW := ''
  else nW := Format(' And (%s)', [nWhere]);

  nStr := 'S_ID=Select S_ID,S_PY,S_Name From %s ' +
          'Where IsNull(S_InValid, '''')<>''%s'' %s Order By S_PY';
  nStr := Format(nStr, [sTable_Salesman, sFlag_Yes, nW]);

  AdjustStringsItem(nList, True);
  FDM.FillStringsData(nList, nStr, -1, '.', DSA(['S_ID']));
  
  AdjustStringsItem(nList, False);
  Result := nList.Count > 0;
end;

//Desc: ��ȡ�ͻ��б�nList��,������������
function LoadCustomer(const nList: TStrings; const nWhere: string = ''): Boolean;
var nStr,nW: string;
begin
  if nWhere = '' then
       nW := ''
  else nW := Format(' And (%s)', [nWhere]);

  nStr := 'C_ID=Select C_ID,C_Name From %s ' +
          'Where IsNull(C_XuNi, '''')<>''%s'' %s Order By C_PY';
  nStr := Format(nStr, [sTable_Customer, sFlag_Yes, nW]);

  AdjustStringsItem(nList, True);
  FDM.FillStringsData(nList, nStr, -1, '.');

  AdjustStringsItem(nList, False);
  Result := nList.Count > 0;
end;

//Desc: ����nCID�ͻ�����Ϣ��nList��,���������ݼ�
function LoadCustomerInfo(const nCID: string; const nList: TcxMCListBox;
 var nHint: string): TDataSet;
var nStr: string;
begin
  nStr := 'Select * From $ZK Where Z_OrgAccountNum=''$ID''';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$ID', nCID)]);
  //xxxxx

  nList.Clear;
  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount > 0 then
  with nList.Items,Result do
  begin
    Add('�ͻ����:' + nList.Delimiter + FieldByName('Z_OrgAccountNum').AsString);
    Add('�ͻ�����:' + nList.Delimiter + FieldByName('Z_OrgAccountName').AsString + ' ');
  end else
  begin
    Result := nil;
    nHint := '������Ϣ�Ѷ�ʧ';
  end;
end;

//Desc: ����nSaleMan���µ�nNameΪ��ʱ�ͻ�,���ؿͻ���
function SaveXuNiCustomer(const nName,nSaleMan: string): string;
var nID: Integer;
    nStr: string;
    nBool: Boolean;
begin
  nStr := 'Select C_ID From %s ' +
          'Where C_XuNi=''%s'' And C_SaleMan=''%s'' And C_Name=''%s''';
  nStr := Format(nStr, [sTable_Customer, sFlag_Yes, nSaleMan, nName]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString;
    Exit;
  end;

  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Insert Into %s(C_Name,C_PY,C_SaleMan,C_XuNi) ' +
            'Values(''%s'',''%s'',''%s'', ''%s'')';
    nStr := Format(nStr, [sTable_Customer, nName, GetPinYinOfStr(nName),
            nSaleMan, sFlag_Yes]);
    FDM.ExecuteSQL(nStr);

    nID := FDM.GetFieldMax(sTable_Customer, 'R_ID');
    Result := FDM.GetSerialID2('KH', sTable_Customer, 'R_ID', 'C_ID', nID);

    nStr := 'Update %s Set C_ID=''%s'' Where R_ID=%d';
    nStr := Format(nStr, [sTable_Customer, Result, nID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Insert Into %s(A_CID,A_Date) Values(''%s'', %s)';
    nStr := Format(nStr, [sTable_CusAccount, Result, FDM.SQLServerNow]);
    FDM.ExecuteSQL(nStr);

    if not nBool then
      FDM.ADOConn.CommitTrans;
    //commit if need
  except
    Result := '';
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: ���ʱ�����ö��
function IsAutoPayCredit: Boolean;
var nStr: string;
begin
  nStr := 'Select D_Value From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_PayCredit)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsString = sFlag_Yes
  else Result := False;
end;

//Desc: ����nCusID��һ�λؿ��¼
function SaveCustomerPayment(const nCusID,nCusName,nSaleMan: string;
 const nType,nPayment,nMemo: string; const nMoney: Double;
 const nCredit: Boolean): Boolean;
var nStr: string;
    nBool: Boolean;
    nVal,nLimit: Double;
begin
  Result := False;
  nVal := Float2Float(nMoney, cPrecision, False);
  //adjust float value

  if nVal < 0 then
  begin
    nLimit := GetCustomerValidMoney(nCusID, False);
    //get money value
    
    if (nLimit <= 0) or (nLimit < -nVal) then
    begin
      nStr := '�ͻ�: %s ' + #13#10#13#10 +
              '��ǰ���Ϊ[ %.2f ]Ԫ,�޷�֧��[ %.2f ]Ԫ.';
      nStr := Format(nStr, [nCusName, nLimit, -nVal]);
      
      ShowDlg(nStr, sHint);
      Exit;
    end;
  end;

  nLimit := 0;
  //no limit

  if nCredit and (nVal > 0) and IsAutoPayCredit then
  begin
    nStr := 'Select A_CreditLimit From %s Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nCusID]);

    with FDM.QueryTemp(nStr) do
    if (RecordCount > 0) and (Fields[0].AsFloat > 0) then
    begin
      if FloatRelation(nVal, Fields[0].AsFloat, rtGreater) then
           nLimit := Float2Float(Fields[0].AsFloat, cPrecision, False)
      else nLimit := nVal;

      nStr := '�ͻ�[ %s ]��ǰ���ö��Ϊ[ %.2f ]Ԫ,�Ƿ���?' +
              #32#32#13#10#13#10 + '���"��"������[ %.2f ]Ԫ�Ķ��.';
      nStr := Format(nStr, [nCusName, Fields[0].AsFloat, nLimit]);

      if not QueryDlg(nStr, sAsk) then
        nLimit := 0;
      //xxxxx
    end;
  end;

  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Update %s Set A_InMoney=A_InMoney+%.2f Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nVal, nCusID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Insert Into %s(M_SaleMan,M_CusID,M_CusName,' +
            'M_Type,M_Payment,M_Money,M_Date,M_Man,M_Memo) ' +
            'Values(''%s'',''%s'',''%s'',''%s'',''%s'',%.2f,%s,''%s'',''%s'')';
    nStr := Format(nStr, [sTable_InOutMoney, nSaleMan, nCusID, nCusName, nType,
            nPayment, nVal, FDM.SQLServerNow, gSysParam.FUserID, nMemo]);
    FDM.ExecuteSQL(nStr);

    if (nLimit > 0) and (
       not SaveCustomerCredit(nCusID, '�ؿ�ʱ���', -nLimit, Now)) then
    begin
      nStr := '����δ֪����,���³���ͻ�[ %s ]���ò���ʧ��.' + #13#10 +
              '���ֶ������ÿͻ����ö��.';
      nStr := Format(nStr, [nCusName]);
      ShowDlg(nStr, sHint);
    end;

    if not nBool then
      FDM.ADOConn.CommitTrans;
    Result := True;
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: ����nCusID��һ�����ż�¼
function SaveCustomerCredit(const nCusID,nMemo: string; const nCredit: Double;
 const nEndTime: TDateTime): Boolean;
var nStr: string;
    nVal: Double;
    nBool: Boolean;
begin
  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nVal := Float2Float(nCredit, cPrecision, False);
    //adjust float value

    nStr := 'Insert Into %s(C_CusID,C_Money,C_Man,C_Date,C_End,C_Memo) ' +
            'Values(''%s'', %.2f, ''%s'', %s, ''%s'', ''%s'')';
    nStr := Format(nStr, [sTable_CusCredit, nCusID, nVal, gSysParam.FUserID,
            FDM.SQLServerNow, DateTime2Str(nEndTime), nMemo]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set A_CreditLimit=A_CreditLimit+%.2f Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nVal, nCusID]);
    FDM.ExecuteSQL(nStr);

    if not nBool then
      FDM.ADOConn.CommitTrans;
    Result := True;
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Date: 2014-09-14
//Parm: �ͻ����
//Desc: ��֤nCusID�Ƿ����㹻��Ǯ,������û�й���
function IsCustomerCreditValid(const nCusID: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_CustomerHasMoney, nCusID, '', @nOut) then
       Result := nOut.FData = sFlag_Yes
  else Result := False;
end;

//Date: 2014-10-13
//Desc: ͬ��ҵ��Ա��DLϵͳ
function SyncRemoteSaleMan: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncSaleMan, '', '', @nOut);
end;

//Date: 2014-10-13
//Desc: ͬ���ͻ���DLϵͳ
function SyncRemoteCustomer(nCustID:string=''; nDataAreaID:string=''): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncCustomer, nCustID, nDataAreaID, @nOut);
end;

//Desc: ͬ����Ӧ�̵�DLϵͳ
function SyncRemoteProviders: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncProvider, '', '', @nOut);
end;

//Date: 2014-10-13
//Desc: ͬ�����ϵ�DLϵͳ
function SyncRemoteMeterails: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncMaterails, '', '', @nOut);
end;

//Date: 2016-07-31
//lih: ͬ��AXˮ�����͵�DLϵͳ
function SyncCement: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncAXCement, '', '', @nOut);
end;

//Date: 2016-10-14
//ͬ��AX��λ��Ϣ��DL
function SyncWmsLocation: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncAXwmsLocation, '', '', @nOut);
end;

//Date: 2016-07-19
//lih: ͬ��AX���ö�ȣ��ͻ�����DLϵͳ
function SyncTPRESTIGEMANAGE(nCusID:string=''; nDataArea :string=''): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_SyncTprGem, nCusID, nDataArea, @nOut) then
       Result := nOut.FData = sFlag_Yes
  else Result := False;
end;

//Date: 2016-07-19
//lih: ͬ��AX���ö�ȣ��ͻ�-��ͬ����DLϵͳ
function SyncTPRESTIGEMBYCONT(nCusID:string=''; nDataArea :string=''): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_SyncTprGemCont, nCusID, nDataArea, @nOut) then
       Result := nOut.FData = sFlag_Yes
  else Result := False;
end;

//Date: 2016-07-19
//lih: ͬ��AXά����Ϣ��DLϵͳ
function SyncINVENTDIM: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncInvDim, '', '', @nOut);
end;

//Date: 2016-07-19
//lih: ͬ��AX��������Ϣ��DLϵͳ
function SyncINVENTCENTER: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncInvCenter, '', '', @nOut);
end;

//Date: 2016-07-19
//lih: ͬ��AX�ֿ���Ϣ��DLϵͳ
function SyncINVENTLOCATION: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncInvLocation, '', '', @nOut);
end;

//Date: 2016-07-19
//lih: ͬ��AX��������������Ϣ��DLϵͳ
function SyncInvCenGroup: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncInvCenGroup, '', '', @nOut);
end;

//Date: 2016-07-19
//lih: ͬ��AXԱ����Ϣ��DLϵͳ
function SyncEmpTable: Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_SyncEmpTable, '', '', @nOut);
end;

//Date: 2014-09-25
//Parm: ���ƺ�
//Desc: ��ȡnTruck�ĳ�Ƥ��¼
function GetTruckPoundItem(const nTruck: string;
 var nPoundData: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetTruckPoundData, nTruck, '', @nOut);
  if Result then
    AnalyseBillItems(nOut.FData, nPoundData);
  //xxxxx
end;

//Date: 2014-09-25
//Parm: ��������
//Desc: ����nData��������
function SaveTruckPoundItem(const nTunnel: PPTTunnelItem;
 const nData: TLadingBillItems): Boolean;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessCommand(cBC_SaveTruckPoundData, nStr, '', @nOut);
  if (not Result) or (nOut.FData = '') then Exit;

  nList := TStringList.Create;
  try
    CapturePicture(nTunnel, nList);
    //capture file

    for nIdx:=0 to nList.Count - 1 do
    begin
      SavePicture(nOut.FData, nData[0].FTruck,
                              nData[0].FStockName, nList[nIdx]);
    end;
    //save file
  finally
    nList.Free;
  end;
end;

//Date: 2014-10-02
//Parm: ͨ����
//Desc: ��ȡnTunnel��ͷ�ϵĿ���
function ReadPoundCard(var nReader: string;const nTunnel: string): string;
var nOut: TWorkerBusinessCommand;
begin
  nReader:= '';
  if CallBusinessHardware(cBC_GetPoundCard, nTunnel, '', @nOut) then
  begin
    Result := Trim(nOut.FData);
    nReader:= Trim(nOut.FExtParam);
  end
  else Result := '';
end;

//������բ  lih 2016-07-26
function OpenDoor(const nCardNo,nPos: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessHardware(cBC_OPenPoundDoor, nCardNo, nPos, @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//��ѯ�����դͨ��״̬  lih 2016-08-21
function IsTunnelOK(const nPoundTunnelFID: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessHardware(cBC_IsTunnelOK, nPoundTunnelFID, '', @nOut) then
       Result := nOut.FData
  else Result := sFlag_No;
end;

//�����رպ��̵�  lih 2016-08-21
function TunnelOC(const nPoundTunnelFID,nIsOK:string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessHardware(cBC_TunnelOC, nPoundTunnelFID, nIsOK, @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//------------------------------------------------------------------------------
//Date: 2014-10-01
//Parm: ͨ��;����
//Desc: ��ȡ������������
function LoadTruckQueue(var nLines: TZTLineItems; var nTrucks: TZTTruckItems;
 const nRefreshLine: Boolean): Boolean;
var nIdx: Integer;
    nSLine,nSTruck: string;
    nListA,nListB: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    if nRefreshLine then
         nSLine := sFlag_Yes
    else nSLine := sFlag_No;

    Result := CallBusinessHardware(cBC_GetQueueData, nSLine, '', @nOut);
    if not Result then Exit;

    nListA.Text := PackerDecodeStr(nOut.FData);
    nSLine := nListA.Values['Lines'];
    nSTruck := nListA.Values['Trucks'];

    nListA.Text := PackerDecodeStr(nSLine);
    SetLength(nLines, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    with nLines[nIdx],nListB do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      FID       := Values['ID'];
      FName     := Values['Name'];
      FStock    := Values['Stock'];
      FValid    := Values['Valid'] <> sFlag_No;
      FPrinterOK:= Values['Printer'] <> sFlag_No;

      if IsNumber(Values['Weight'], False) then
           FWeight := StrToInt(Values['Weight'])
      else FWeight := 1;
    end;

    nListA.Text := PackerDecodeStr(nSTruck);
    SetLength(nTrucks, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    with nTrucks[nIdx],nListB do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      FTruck    := Values['Truck'];
      FLine     := Values['Line'];
      FBill     := Values['Bill'];

      if IsNumber(Values['Value'], True) then
           FValue := StrToFloat(Values['Value'])
      else FValue := 0;

      FInFact   := Values['InFact'] = sFlag_Yes;
      FIsRun    := Values['IsRun'] = sFlag_Yes;
           
      if IsNumber(Values['Dai'], False) then
           FDai := StrToInt(Values['Dai'])
      else FDai := 0;

      if IsNumber(Values['Total'], False) then
           FTotal := StrToInt(Values['Total'])
      else FTotal := 0;
    end;
  finally
    nListA.Free;
    nListB.Free;
  end;
end;

//Date: 2014-10-01
//Parm: ͨ����;��ͣ��ʶ
//Desc: ��ͣnTunnelͨ���������
procedure PrinterEnable(const nTunnel: string; const nEnable: Boolean);
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  if nEnable then
       nStr := sFlag_Yes
  else nStr := sFlag_No;

  CallBusinessHardware(cBC_PrinterEnable, nTunnel, nStr, @nOut);
end;

//Date: 2014-10-07
//Parm: ����ģʽ
//Desc: �л�ϵͳ����ģʽΪnMode
function ChangeDispatchMode(const nMode: Byte): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessHardware(cBC_ChangeDispatchMode, IntToStr(nMode), '',
            @nOut);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Desc: ֽ���Ƿ���Ҫ���
function IsZhiKaNeedVerify: Boolean;
var nStr: string;
begin
  nStr := 'Select D_Value From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_ZhiKaVerify)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsString = sFlag_Yes
  else Result := False;
end;

//Desc: �Ƿ��ӡֽ��
function IsPrintZK: Boolean;
var nStr: string;
begin
  nStr := 'Select D_Value From $T Where D_Name=''$N'' and D_Memo=''$M''';
  nStr := MacroValue(nStr, [MI('$T', sTable_SysDict), MI('$N', sFlag_SysParam),
                           MI('$M', sFlag_PrintZK)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsString = sFlag_Yes
  else Result := False;
end;

//Desc: ɾ�����ΪnZID��ֽ��
function DeleteZhiKa(const nZID: string): Boolean;
var nStr: string;
    nBool: Boolean;
begin
  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Delete From %s Where Z_ID=''%s''';
    nStr := Format(nStr, [sTable_ZhiKa, nZID]);
    Result := FDM.ExecuteSQL(nStr) > 0;

    nStr := 'Delete From %s Where D_ZID=''%s''';
    nStr := Format(nStr, [sTable_ZhiKaDtl, nZID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set M_ZID=M_ZID+''_d'' Where M_ZID=''%s''';
    nStr := Format(nStr, [sTable_InOutMoney, nZID]);
    FDM.ExecuteSQL(nStr);

    if not nBool then
      FDM.ADOConn.CommitTrans;
    //commit if need
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//Desc: ����nZID����Ϣ��nList��,�����ز�ѯ���ݼ�
function LoadZhiKaInfo(const nZID: string; const nList: TcxMCListBox;
 var nHint: string): TDataset;
var nStr: string;
begin
  nStr := 'Select zk.*,con.C_ContQuota,cus.C_ID,cus.C_Name From $ZK zk ' +
          ' Left Join $Con con On con.C_ID=zk.Z_CID ' +
          ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
          'Where Z_ID=''$ID''';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
             MI('$Con', sTable_SaleContract),
             MI('$Cus', sTable_Customer), MI('$ID', nZID)]);
  //xxxxx

  nList.Clear;
  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount = 1 then
  with nList.Items,Result do
  begin
    Add('ֽ�����:' + nList.Delimiter + FieldByName('Z_ID').AsString);
    if FieldByName('Z_TriangleTrade').AsString = '1' then
      Add('�ͻ�����:' + nList.Delimiter + FieldByName('Z_OrgAccountName').AsString + ' ')
    else
      Add('�ͻ�����:' + nList.Delimiter + FieldByName('C_Name').AsString + ' ');
    Add('��Ŀ����:' + nList.Delimiter + FieldByName('Z_Project').AsString + ' ');

    nStr := DateTime2Str(FieldByName('Z_Date').AsDateTime);
    Add('�쿨ʱ��:' + nList.Delimiter + nStr);
  end else
  begin
    Result := nil;
    nHint := 'ֽ������Ч';
  end;
end;

//���붩����Ϣ
function LoadSalesInfo(const nZID: string; var nHint: string): TDataset;
var nStr: string;
begin
  nStr := 'Select zk.*,con.C_ContQuota,cus.C_ID,cus.C_Name From $ZK zk ' +
          ' Left Join $Con con On con.C_ID=zk.Z_CID ' +
          ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
          'Where Z_ID=''$ID''';

  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
             MI('$Con', sTable_SaleContract),
             MI('$Cus', sTable_Customer), MI('$ID', nZID)]);

  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount < 1 then
  begin
    Result := nil;
    nHint := '������Ϣ����Ч';
  end;
end;

//���붩����
function LoadSaleLineInfo(const nRecID: string; var nHint: string): TDataset;
var nStr: string;
begin
  nStr := 'Select zk.* From $ZK zk Where D_RECID=''$ID''';

  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKaDtl), MI('$ID', nRecID)]);

  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount < 1 then
  begin
    Result := nil;
    nHint := '������Ϣ����Ч';
  end;
end;

//���������Ϣ
function LoadAXPlanInfo(const nID: string; var nHint: string): TDataset;
var nStr: string;
begin
  nStr := 'Select ap.* From $AP ap Where AX_TRANSPLANID=''$ID''';
  nStr := MacroValue(nStr, [MI('$AP', sTable_AxPlanInfo), MI('$ID', nID)]);
  Result := FDM.QueryTemp(nStr);

  if Result.RecordCount < 1 then
  begin
    Result := nil;
    nHint := '��ȡ�����Ϣʧ��';
  end;
end;

function IsBrick(const nStockno:string):Boolean;
var nStr: string;
begin
  nStr := 'select * from %s where d_name=''%s'' and d_desc=''%s''';
  nStr := Format(nStr,[sTable_SysDict,sFlag_BrickItem,nStockno]);
  Result := FDM.QuerySQL(nStr).RecordCount>0;
end;

//Date: 2014-09-14
//Parm: ֽ����;�Ƿ�����
//Desc: ��ȡnZhiKa�Ŀ��ý�Ŷ
function GetZhikaValidMoney(nZhiKa: string; var nFixMoney: Boolean): Double;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_GetZhiKaMoney, nZhiKa, '', @nOut) then
  begin
    Result := StrToFloat(nOut.FData);
    nFixMoney := nOut.FExtParam = sFlag_Yes;
  end else Result := 0;
end;

//Desc: ��ȡnCID�û��Ŀ��ý��,�������ö�򾻶�
function GetCustomerValidMoney(nCID: string; const nLimit: Boolean;
 const nCredit: PDouble): Double;
var nStr: string;
    nOut: TWorkerBusinessCommand;
begin
  if nLimit then
       nStr := sFlag_Yes
  else nStr := sFlag_No;

  if CallBusinessCommand(cBC_GetCustomerMoney, nCID, nStr, @nOut) then
  begin
    Result := StrToFloat(nOut.FData);
    if Assigned(nCredit) then
      nCredit^ := StrToFloat(nOut.FExtParam);
    //xxxxx
  end else
  begin
    Result := 0;
    if Assigned(nCredit) then
      nCredit^ := 0;
    //xxxxx
  end;
end;

//Date: 2014-10-16
//Parm: Ʒ���б�(s1,s2..)
//Desc: ��֤nStocks�Ƿ���Է���
function IsStockValid(const nStocks: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_CheckStockValid, nStocks, '', @nOut);
end;

//Date: 2014-09-15
//Parm: ��������
//Desc: ���潻����,���ؽ��������б�
function SaveBill(const nBillData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessSaleBill(cBC_SaveBills, nBillData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//Date: 2014-09-15
//Parm: ��������
//Desc: ɾ��nBillID����
function DeleteBill(const nBill: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_DeleteBill, nBill, '', @nOut);
end;

//Date: 2014-09-15
//Parm: ������;�³���
//Desc: �޸�nBill�ĳ���ΪnTruck.
function ChangeLadingTruckNo(const nBill,nTruck: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_ModifyBillTruck, nBill, nTruck, @nOut);
end;

//Date: 2014-09-30
//Parm: ������;ֽ��
//Desc: ��nBill������nNewZK�Ŀͻ�
function BillSaleAdjust(const nBill, nNewZK: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_SaleAdjust, nBill, nNewZK, @nOut);
end;

//Date: 2014-09-17
//Parm: ������;���ƺ�;У���ƿ�����
//Desc: ΪnBill�������ƿ�
function SetBillCard(const nBill,nTruck: string; nVerify: Boolean): Boolean;
var nStr: string;
    nP: TFormCommandParam;
begin
  Result := True;
  if nVerify then
  begin
    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ViaBillCard]);

    with FDM.QueryTemp(nStr) do
     if (RecordCount < 1) or (Fields[0].AsString <> sFlag_Yes) then Exit;
    //no need do card
  end;
  nP.FParamA := nBill;
  nP.FParamB := nTruck;
  nP.FParamC := sFlag_Sale;
  CreateBaseFormItem(cFI_FormMakeCard, '', @nP);
  Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

//Date: 2014-09-17
//Parm: ��������;�ſ�
//Desc: ��nBill.nCard
function SaveBillCard(const nBill, nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_SaveBillCard, nBill, nCard, @nOut);
end;

//Date: 2014-09-17
//Parm: �ſ���
//Desc: ע��nCard
function LogoutBillCard(const nCard: string;const nNeidao:string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_LogoffCard, nCard, nNeidao, @nOut);
end;

//Date: 2014-09-17
//Parm: �ſ���;��λ;�������б�
//Desc: ��ȡnPost��λ�ϴſ�ΪnCard�Ľ������б�
function GetLadingBills(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessSaleBill(cBC_GetPostBills, nCard, nPost, @nOut);
  if Result then
    AnalyseBillItems(nOut.FData, nBills);
  //xxxxx
end;

//Date: 2014-09-18
//Parm: ��λ;�������б�;��վͨ��
//Desc: ����nPost��λ�ϵĽ���������
function SaveLadingBills(var nFoutData:string; const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem): Boolean;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessSaleBill(cBC_SavePostBills, nStr, nPost, @nOut);
  nFoutData:=nOut.FData;
  WriteLog('SaveLadingBills: '+nFoutData);
  if (not Result) or (nOut.FData = '') or (Pos('����',nOut.FData)>0) then Exit;
  if (Pos('P',nOut.FData)>0) and (Length(nOut.FData)<=11) then
  begin
    if Assigned(nTunnel) then //��������
    begin
      nList := TStringList.Create;
      try
        CapturePicture(nTunnel, nList);
        //capture file

        for nIdx:=0 to nList.Count - 1 do
          SavePicture(nOut.FData, nData[0].FTruck,
                                  nData[0].FStockName, nList[nIdx]);
        //save file
      finally
        nList.Free;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2015/9/19
//Parm: 
//Desc: ����ɹ����뵥
function SaveOrderBase(const nOrderData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessPurchaseOrder(cBC_SaveOrderBase, nOrderData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

function DeleteOrderBase(const nOrder: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_DeleteOrderBase, nOrder, '', @nOut);
end;

//Date: 2014-09-15
//Parm: ��������
//Desc: ����ɹ���,���زɹ������б�
function SaveOrder(const nOrderData: string): string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessPurchaseOrder(cBC_SaveOrder, nOrderData, '', @nOut) then
       Result := nOut.FData
  else Result := '';
end;

//Date: 2014-09-15
//Parm: ��������
//Desc: ɾ��nBillID����
function DeleteOrder(const nOrder: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_DeleteOrder, nOrder, '', @nOut);
end;

//Date: 2014-09-17
//Parm: ������;���ƺ�;У���ƿ�����
//Desc: ΪnBill�������ƿ�
function SetOrderCard(const nOrder,nTruck: string; nVerify: Boolean): Boolean;
var nStr: string;
    nP: TFormCommandParam;
begin
  Result := True;
  if nVerify then
  begin
    nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ViaBillCard]);

    with FDM.QueryTemp(nStr) do
     if (RecordCount < 1) or (Fields[0].AsString <> sFlag_Yes) then Exit;
    //no need do card
  end;

  nP.FParamA := nOrder;
  nP.FParamB := nTruck;
  nP.FParamC := sFlag_Provide;
  CreateBaseFormItem(cFI_FormMakeCard, '', @nP);
  Result := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;

//Date: 2014-09-17
//Parm: ��������;�ſ�
//Desc: ��nBill.nCard
function SaveOrderCard(const nOrder, nCard: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_SaveOrderCard, nOrder, nCard, @nOut);
end;

//Date: 2014-09-17
//Parm: �ſ���
//Desc: ע��nCard
function LogoutOrderCard(const nCard: string;const nNeiDao:string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_LogOffOrderCard, nCard, nNeiDao, @nOut);
end;

//Date: 2014-09-15
//Parm: ������;�³���
//Desc: �޸�nOrder�ĳ���ΪnTruck.
function ChangeOrderTruckNo(const nOrder,nTruck: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_ModifyBillTruck, nOrder, nTruck, @nOut);
end;

//Date: 2014-09-17
//Parm: �ſ���;��λ;�������б�
//Desc: ��ȡnPost��λ�ϴſ�ΪnCard�Ľ������б�
function GetPurchaseOrders(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessPurchaseOrder(cBC_GetPostOrders, nCard, nPost, @nOut);
  if Result then
    AnalyseBillItems(nOut.FData, nBills);
  //xxxxx
end;

//Date: 2014-09-18
//Parm: ��λ;�������б�;��վͨ��
//Desc: ����nPost��λ�ϵĽ���������
function SavePurchaseOrders(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem): Boolean;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
  Result := CallBusinessPurchaseOrder(cBC_SavePostOrders, nStr, nPost, @nOut);
  if (not Result) or (nOut.FData = '') then Exit;

  if Assigned(nTunnel) then //��������
  begin
    nList := TStringList.Create;
    try
      CapturePicture(nTunnel, nList);
      //capture file

      for nIdx:=0 to nList.Count - 1 do
      begin
        SavePicture(nOut.FData, nData[0].FTruck,
                                nData[0].FStockName, nList[nIdx]);
      end;
      //save file
    finally
      nList.Free;
    end;
  end;
end;

//��ȡָ����λ�Ķ̵���
function GetDuanDaoOrders(const nCard,nPost: string;
 var nBills: TLadingBillItems): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessDuanDao(cBC_GetPostDDs, nCard, nPost, @nOut);
  if Result then
    AnalyseBillItems(nOut.FData, nBills);
  //xxxxx
end;

//����ָ����λ�Ĳɹ���
function SaveDuanDaoOrders(const nPost: string; const nData: TLadingBillItems;
 const nTunnel: PPTTunnelItem = nil): Boolean;
var nStr: string;
    nIdx: Integer;
    nList: TStrings;
    nOut: TWorkerBusinessCommand;
begin
  nStr := CombineBillItmes(nData);
    Result := CallBusinessDuanDao(cBC_SavePostDDs, nStr, nPost, @nOut); 
	  if (not Result) or (nOut.FData = '') then Exit;

  if Assigned(nTunnel) then //��������
  begin
    nList := TStringList.Create;
    try
      CapturePicture(nTunnel, nList);
      //capture file

      for nIdx:=0 to nList.Count - 1 do
        SavePicture(nOut.FData, nData[0].FTruck,
                                nData[0].FStockName, nList[nIdx]);
      //save file
    finally
      nList.Free;
    end;
  end;
end;


//Date: 2014-09-17
//Parm: ��������; MCListBox;�ָ���
//Desc: ��nItem����nMC
procedure LoadBillItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);
var nStr: string;
begin
  with nItem,nMC do
  begin
    Clear;
    Add(Format('���ƺ���:%s %s', [nDelimiter, FTruck]));
    Add(Format('��ǰ״̬:%s %s', [nDelimiter, TruckStatusToStr(FStatus)]));

    Add(Format('%s ', [nDelimiter]));
    Add(Format('��������:%s %s', [nDelimiter, FId]));
    Add(Format('��������:%s %.3f ��', [nDelimiter, FValue]));
    if FType = sFlag_Dai then nStr := '��װ' else nStr := 'ɢװ';

    Add(Format('Ʒ������:%s %s', [nDelimiter, nStr]));
    Add(Format('Ʒ������:%s %s', [nDelimiter, FStockName]));
    
    Add(Format('%s ', [nDelimiter]));
    Add(Format('����ſ�:%s %s', [nDelimiter, FCard]));
    Add(Format('��������:%s %s', [nDelimiter, BillTypeToStr(FIsVIP)]));
    Add(Format('�ͻ�����:%s %s', [nDelimiter, FCusName]));
  end;
end;

//Date: 2014-09-17
//Parm: ��������; MCListBox;�ָ���
//Desc: ��nItem����nMC
procedure LoadOrderItemToMC(const nItem: TLadingBillItem; const nMC: TStrings;
 const nDelimiter: string);
var nStr: string;
begin
  with nItem,nMC do
  begin
    Clear;
    Add(Format('���ƺ���:%s %s', [nDelimiter, FTruck]));
    Add(Format('��ǰ״̬:%s %s', [nDelimiter, TruckStatusToStr(FStatus)]));

    Add(Format('%s ', [nDelimiter]));
    Add(Format('�ɹ�����:%s %s', [nDelimiter, FZhiKa]));
//    Add(Format('��������:%s %.3f ��', [nDelimiter, FValue]));
    if FType = sFlag_Dai then nStr := '��װ' else nStr := 'ɢװ';

    Add(Format('Ʒ������:%s %s', [nDelimiter, nStr]));
    Add(Format('Ʒ������:%s %s', [nDelimiter, FStockName]));
    
    Add(Format('%s ', [nDelimiter]));
    Add(Format('�ͻ��ſ�:%s %s', [nDelimiter, FCard]));
    Add(Format('��������:%s %s', [nDelimiter, BillTypeToStr(FIsVIP)]));
    Add(Format('�� Ӧ ��:%s %s', [nDelimiter, FCusName]));
  end;
end;

//------------------------------------------------------------------------------
//Desc: ÿ���������
function GetHYMaxValue: Double;
var nStr: string;
begin
  nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_HYValue]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsFloat
  else Result := 0;
end;

//Desc: ��ȡnNoˮ���ŵ��ѿ���
function GetHYValueByStockNo(const nNo: string): Double;
var nStr: string;
begin
  nStr := 'Select R_SerialNo,Sum(H_Value) From %s ' +
          ' Left Join %s on H_SerialNo= R_SerialNo ' +
          'Where R_SerialNo=''%s'' Group By R_SerialNo';
  nStr := Format(nStr, [sTable_StockRecord, sTable_StockHuaYan, nNo]);
  {$IFDEF QHSN}
  {$IFDEF GGJC}
  nStr := ' Select R_SerialNo,Sum(H_Value) From %s ' +
          ' Left Join %s on H_SerialNo= R_SerialNo ' +
          ' Where R_SerialNo=''%s'' Group By R_SerialNo '+
	  ' union '+
	  ' Select R_SerialNo,Sum(H_Value) From %s '+
	  ' Left Join %s on H_SerialNo= R_SerialNo '+
	  ' Where R_SerialNo=''%s'' Group By R_SerialNo '+
	  ' union '+
	  ' Select R_SerialNo,Sum(H_Value) From %s '+
	  ' Left Join %s on H_SerialNo= R_SerialNo '+
	  ' Where R_SerialNo=''%s'' Group By R_SerialNo '+
	  ' union '+
	  ' Select R_SerialNo,Sum(H_Value) From %s '+
	  ' Left Join %s on H_SerialNo= R_SerialNo '+
	  ' Where R_SerialNo=''%s'' Group By R_SerialNo';
  nStr := Format(nStr, [sTable_StockRecord, sTable_StockHuaYan, nNo,
			sTable_StockRecord_slag, sTable_StockHuaYan, nNo,
			sTable_StockRecord_Concrete, sTable_StockHuaYan, nNo,
			sTable_StockRecord_clinker, sTable_StockHuaYan, nNo]);
  {$ENDIF}
  {$ENDIF}
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[1].AsFloat
  else Result := -1;
end;
//Desc: ��ȡ����������ֵ
function GetOrderLimValue: Double;
var nStr: string;
begin
  nStr := 'Select D_Value From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_OrderLimValue]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsFloat
  else Result := 100;
end;

//Desc: ��ȡ����ʣ����
function GetOrderRestValue(nTotalValue: Double; nRecId: string): string;
var nStr: string;
begin
  nStr := 'Select SUM(D_Value) as D_Value From %s Where D_RecID=''%s''';
  nStr := Format(nStr, [sTable_OrderDtl, nRecId]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
    Result := Format('%.2f', [nTotalValue - Fields[0].AsFloat])
  else Result := '0.00';
end;

function IsDealerLadingIDExit(const nDealerID: string): Boolean;
var nStr: string;
begin
  Result := True;
  if nDealerID = '' then
    Exit;

  nStr := 'Select L_JXSTHD From %s Where L_JXSTHD=''%s''';
  nStr := Format(nStr, [sTable_Bill, nDealerID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
    Result := False;
end;

function IsEleCardVaid(const nStockType,nTruckNo,nStockNo: string): Boolean;
var
  nStr,nSql:string;
begin
  Result := False;
  if nStockType <> sFlag_San then
  begin
    Result := True;
    Exit;
  end;

  nStr := 'Select D_Value,D_Memo,D_ParamB From $Table ' +
          'Where D_Name=''$Name'' And D_Value=''$Value'' ' +
          'And D_Memo=''$Memo'' Order By D_Index ASC';
  nStr := MacroValue(nStr, [MI('$Table', sTable_SysDict),
                            MI('$Name', sFlag_NoEleCard),
                            MI('$Value', nStockNo),
                            MI('$Memo', nStockType)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      Result := True;
      Exit;
    end;
  end;

  nSql := 'select * from %s where T_Truck = ''%s'' ';
  nSql := Format(nSql,[sTable_Truck,nTruckNo]);

  with FDM.QueryTemp(nSql) do
  begin
    if recordcount>0 then
    begin
      if (FieldByName('T_Card').AsString = '') and (FieldByName('T_Card2').AsString = '') then
        Exit;
      Result := FieldByName('T_CardUse').AsString = sFlag_Yes;
    end;
  end;
end;

//Desc: ���nWeek�Ƿ���ڻ����
function IsWeekValid(const nWeek: string; var nHint: string): Boolean;
var nStr: string;
begin
  nStr := 'Select W_End,$Now From $W Where W_NO=''$NO''';
  nStr := MacroValue(nStr, [MI('$W', sTable_InvoiceWeek),
          MI('$Now', FDM.SQLServerNow), MI('$NO', nWeek)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsDateTime + 1 > Fields[1].AsDateTime;
    if not Result then
      nHint := '�ý��������ѽ���';
    //xxxxx
  end else
  begin
    Result := False;
    nHint := '�ý�����������Ч';
  end;
end;

//Desc: ���nWeek�Ƿ�������
function IsWeekHasEnable(const nWeek: string): Boolean;
var nStr: string;
begin
  nStr := 'Select Top 1 * From $Req Where R_Week=''$NO''';
  nStr := MacroValue(nStr, [MI('$Req', sTable_InvoiceReq), MI('$NO', nWeek)]);
  Result := FDM.QueryTemp(nStr).RecordCount > 0;
end;

//Desc: ���nWeek����������Ƿ�������
function IsNextWeekEnable(const nWeek: string): Boolean;
var nStr: string;
begin
  nStr := 'Select Top 1 * From $Req Where R_Week In ' +
          '( Select W_NO From $W Where W_Begin > (' +
          '  Select Top 1 W_Begin From $W Where W_NO=''$NO''))';
  nStr := MacroValue(nStr, [MI('$Req', sTable_InvoiceReq),
          MI('$W', sTable_InvoiceWeek), MI('$NO', nWeek)]);
  Result := FDM.QueryTemp(nStr).RecordCount > 0;
end;

//Desc: ���nWeeǰ��������Ƿ��ѽ������
function IsPreWeekOver(const nWeek: string): Integer;
var nStr: string;
begin
  nStr := 'Select Count(*) From $Req Where (R_ReqValue<>R_KValue) And ' +
          '(R_Week In ( Select W_NO From $W Where W_Begin < (' +
          '  Select Top 1 W_Begin From $W Where W_NO=''$NO'')))';
  nStr := MacroValue(nStr, [MI('$Req', sTable_InvoiceReq),
          MI('$W', sTable_InvoiceWeek), MI('$NO', nWeek)]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
       Result := Fields[0].AsInteger
  else Result := 0;
end;

//Desc: �����û�������
function SaveCompensation(const nSaleMan,nCusID,nCusName,nPayment,nMemo: string;
 const nMoney: Double): Boolean;
var nStr: string;
    nBool: Boolean;
begin
  nBool := FDM.ADOConn.InTransaction;
  if not nBool then FDM.ADOConn.BeginTrans;
  try
    nStr := 'Update %s Set A_Compensation=A_Compensation+%s Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, FloatToStr(nMoney), nCusID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Insert Into %s(M_SaleMan,M_CusID,M_CusName,M_Type,M_Payment,' +
            'M_Money,M_Date,M_Man,M_Memo) Values(''%s'',''%s'',''%s'',' +
            '''%s'',''%s'',%s,%s,''%s'',''%s'')';
    nStr := Format(nStr, [sTable_InOutMoney, nSaleMan, nCusID, nCusName,
            sFlag_MoneyFanHuan, nPayment, FloatToStr(nMoney),
            FDM.SQLServerNow, gSysParam.FUserID, nMemo]);
    FDM.ExecuteSQL(nStr);

    if not nBool then
      FDM.ADOConn.CommitTrans;
    Result := True;
  except
    Result := False;
    if not nBool then FDM.ADOConn.RollbackTrans;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ӡ��ʶΪnID�����ۺ�ͬ
procedure PrintSaleContractReport(const nID: string; const nAsk: Boolean);
var nStr: string;
    nParam: TReportParamItem;
begin
  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ���ۺ�ͬ?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select sc.*,S_Name,C_Name From $SC sc ' +
          '  Left Join $SM sm On sm.S_ID=sc.C_SaleMan ' +
          '  Left Join $Cus cus On cus.C_ID=sc.C_Customer ' +
          'Where sc.C_ID=''$ID''';

  nStr := MacroValue(nStr, [MI('$SC', sTable_SaleContract),
          MI('$SM', sTable_Salesman), MI('$Cus', sTable_Customer),
          MI('$ID', nID)]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s] �����ۺ�ͬ����Ч!!';
    nStr := Format(nStr, [nID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := 'Select * From %s Where E_CID=''%s''';
  nStr := Format(nStr, [sTable_SContractExt, nID]);
  FDM.QuerySQL(nStr);

  nStr := gPath + sReportDir + 'SaleContract.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.Dataset2.DataSet := FDM.SqlQuery;
  FDR.ShowReport;
end;

//Desc: ��ӡֽ��
function PrintZhiKaReport(const nZID: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡֽ��?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select zk.*,C_Name,S_Name From %s zk ' +
          ' Left Join %s cus on cus.C_ID=zk.Z_Customer' +
          ' Left Join %s sm on sm.S_ID=zk.Z_SaleMan ' +
          'Where Z_ID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKa, sTable_Customer, sTable_Salesman, nZID]);
  
  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := 'ֽ����Ϊ[ %s ] �ļ�¼����Ч';
    nStr := Format(nStr, [nZID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := 'Select * From %s Where D_ZID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaDtl, nZID]);
  if FDM.QuerySQL(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] ��ֽ������ϸ';
    nStr := Format(nStr, [nZID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'ZhiKa.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.Dataset2.DataSet := FDM.SqlQuery;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: ��ӡ�վ�
function PrintShouJuReport(const nSID: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�վ�?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Where R_ID=%s';
  nStr := Format(nStr, [sTable_SysShouJu, nSID]);
  
  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := 'ƾ����Ϊ[ %s ] ���վ�����Ч!!';
    nStr := Format(nStr, [nSID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'ShouJu.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: ��ӡ�����
function PrintBillReport(nBill: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
    nStockno:string;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�����?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nBill := AdjustListStrFormat(nBill, '''', True, ',', False);
  //�������

  nStr := 'Select * From %s b Where L_ID In(%s)';
  nStr := Format(nStr, [sTable_Bill, nBill]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �ļ�¼����Ч!!';
    nStr := Format(nStr, [nBill]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStockno := FDM.SqlTemp.FieldByName('L_Stockno').AsString;

  nStr := gPath + sReportDir + 'LadingBill.fr3';

  if IsBrick(nStockno) then
  begin
    nStr := gPath + sReportDir + 'LadingBill_brick.fr3';
  end;

  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
  if Result then
  begin
    nStr := 'update %s set L_BDPrint=L_BDPrint+1 Where L_ID=%s';
    nStr := Format(nStr, [sTable_Bill, nBill]);
    FDM.ExecuteSQL(nStr);
  end;
end;

//lih 2016-10-28 �ֳ���ӡ�����4
function PrintBill4(nBill: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�����?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nBill := AdjustListStrFormat(nBill, '''', True, ',', False);
  //�������

  nStr := 'Select *,substring(L_ID,3,LEN(L_ID)-2) as L_CID From %s b Where L_ID In(%s)';
  nStr := Format(nStr, [sTable_Bill, nBill]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �ļ�¼����Ч!!';
    nStr := Format(nStr, [nBill]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'LadingBill4.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
  if Result then
  begin
    nStr := 'update %s set L_BDPrint=L_BDPrint+1 Where L_ID=%s';
    nStr := Format(nStr, [sTable_Bill, nBill]);
    FDM.ExecuteSQL(nStr);
  end;
end;

//lih 2016-10-28 �ֳ���ӡ�����6
function PrintBill6(nBill: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�����?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nBill := AdjustListStrFormat(nBill, '''', True, ',', False);
  //�������

  nStr := 'Select *,substring(L_ID,3,LEN(L_ID)-2) as L_CID From %s b Where L_ID In(%s)';
  nStr := Format(nStr, [sTable_Bill, nBill]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �ļ�¼����Ч!!';
    nStr := Format(nStr, [nBill]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'LadingBill6.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
  if Result then
  begin
    nStr := 'update %s set L_BDPrint=L_BDPrint+1 Where L_ID=%s';
    nStr := Format(nStr, [sTable_Bill, nBill]);
    FDM.ExecuteSQL(nStr);
  end;
end;

//Desc: ��ӡ��װ��Ʊ��
function PrintDaiBill(nBill: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
    nBrick:Boolean;
begin
  Result := False;
  nBrick := False;
  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡװ����?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nBill := AdjustListStrFormat(nBill, '''', True, ',', False);
  //�������
  
  nStr := 'Select * From %s b Where L_ID In(%s)';
  nStr := Format(nStr, [sTable_Bill, nBill]);
  //xxxxx
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount<1 then
    begin
      nStr := '���Ϊ[ %s ] �ļ�¼����Ч!!';
      nStr := Format(nStr, [nBill]);
      ShowMsg(nStr, sHint); Exit;
    end;
    nBrick := IsBrick(FieldByName('l_stockno').AsString);
  end;

//  if FDM.QueryTemp(nStr).RecordCount < 1 then
//  begin
//    nStr := '���Ϊ[ %s ] �ļ�¼����Ч!!';
//    nStr := Format(nStr, [nBill]);
//    ShowMsg(nStr, sHint); Exit;
//  end;

  nStr := gPath + sReportDir + 'DaiBill.fr3';
  if nBrick then
  begin
    nStr := gPath + sReportDir + 'DaiBill_brick.fr3';
  end;
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2012-4-1
//Parm: �ɹ�����;��ʾ;���ݶ���;��ӡ��
//Desc: ��ӡnOrder�ɹ�����
function PrintOrderReport(const nOrder: string;  const nAsk: Boolean): Boolean;
var nStr: string;
    nDS: TDataSet;
    nParam: TReportParamItem;
    nPath:string;
begin
  Result := False;
  nPath := '';
  
  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�ɹ���?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s oo Inner Join %s od on oo.O_ID=od.D_OID Where D_ID=''%s''';
  nStr := Format(nStr, [sTable_Order, sTable_OrderDtl, nOrder]);

  nDS := FDM.QueryTemp(nStr);
  if not Assigned(nDS) then Exit;

  if nDS.RecordCount>0 then
  begin
    nPath := gPath + 'Report\PurchaseOrder.fr3';
  end
  else begin
    nStr := 'Select * From %s oo where R_id=''%s''';
    nStr := Format(nStr, [sTable_CardOther, nOrder]);

    nDS := FDM.QueryTemp(nStr);
    if not Assigned(nDS) then Exit;
    if nDS.RecordCount>0 then
    begin
      nPath := gPath + 'Report\TempOrder.fr3';
    end;    
  end;

  if nPath='' then
  begin
    nStr := '�ɹ�������ʱ��[ %s ] ����Ч!!';
    ShowMsg(nStr, sHint);
    Exit;
  end;

  if not FDR.LoadReportFile(nPath) then
  begin
    nStr := '�޷���ȷ���ر����ļ�['+nPath+']';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Date: 2012-4-15
//Parm: ��������;�Ƿ�ѯ��
//Desc: ��ӡnPound������¼
function PrintPoundReport(const nPound: string; nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ������?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, nPound]);

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���ؼ�¼[ %s ] ����Ч!!';
    nStr := Format(nStr, [nPound]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'Pound.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;

  if Result  then
  begin
    nStr := 'Update %s Set P_PrintNum=P_PrintNum+1 Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_PoundLog, nPound]);
    FDM.ExecuteSQL(nStr);
  end;
end;

//Desc: ��ȡnStockƷ�ֵı����ļ�
function GetReportFileByStock(const nStock: string): string;
begin
  if Pos('����',nStock)>0 then
    Result := gPath + sReportDir + 'HuanYan28ShuLiao.fr3'
  else
    Result := gPath + sReportDir + 'HuanYan28.fr3';
end;

//Desc: ��ӡ��ʶΪnHID�Ļ��鵥
function PrintHuaYanReport(const nHID: string; const nAsk: Boolean;const nHydan:string): Boolean;
var nStr,nSR: string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '�Ƿ�Ҫ��ӡ���鵥?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;
  if nHydan='' then
  begin
    nSR := 'Select * From %s sr ' +
           ' Left Join %s sp on sp.P_ID=sr.R_PID';
    nSR := Format(nSR, [sTable_StockRecord, sTable_StockParam]);
  end
  else begin
    nstr := 'select * from %s where r_serialno=''%s''';
    nStr := Format(nStr,[sTable_StockRecord,nHydan]);
    if fdm.QuerySQL(nStr).RecordCount>0 then
    begin
      nSR := 'Select * From %s sr ' +
             ' Left Join %s sp on sp.P_ID=sr.R_PID';
      nSR := Format(nSR, [sTable_StockRecord, sTable_StockParam]);
    end
    else begin
      nstr := 'select * from %s where r_serialno=''%s''';
      nStr := Format(nStr,[sTable_StockRecord_Slag,nHydan]);
      if fdm.QuerySQL(nStr).RecordCount>0 then
      begin
        nSR := 'Select * From %s sr ' +
               ' Left Join %s sp on sp.P_ID=sr.R_PID';
        nSR := Format(nSR, [sTable_StockRecord_Slag, sTable_StockParam]);
      end
      else begin
        nstr := 'select * from %s where r_serialno=''%s''';
        nStr := Format(nStr,[sTable_StockRecord_Concrete,nHydan]);
        if fdm.QuerySQL(nStr).RecordCount>0 then
        begin
          nSR := 'Select * From %s sr ' +
                 ' Left Join %s sp on sp.P_ID=sr.R_PID';
          nSR := Format(nSR, [sTable_StockRecord_Concrete, sTable_StockParam]);
        end
        else begin
          nstr := 'select * from %s where r_serialno=''%s''';
          nStr := Format(nStr,[sTable_StockRecord_clinker,nHydan]);
          if fdm.QuerySQL(nStr).RecordCount>0 then
          begin
            nSR := 'Select * From %s sr ' +
                   ' Left Join %s sp on sp.P_ID=sr.R_PID';
            nSR := Format(nSR, [sTable_StockRecord_clinker, sTable_StockParam]);
          end
          else begin
            nStr := '���Ϊ[ %s ] �Ļ����¼�����ڣ�����!!';
            nStr := Format(nStr, [nHydan]);
            ShowMsg(nStr, sHint);
            Exit;
          end;
        end;
      end;
    end;
  end;


  nStr := 'Select hy.*,sr.*,C_Name From $HY hy ' +
          ' Left Join $Cus cus on cus.C_ID=hy.H_Custom' +
          ' Left Join ($SR) sr on sr.R_SerialNo=H_SerialNo ' +
          'Where H_ID in ($ID)';
  //xxxxx

  nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
          MI('$Cus', sTable_Customer), MI('$SR', nSR), MI('$ID', nHID)]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �Ļ��鵥��¼����Ч!!';
    nStr := Format(nStr, [nHID]);
    ShowMsg(nStr, sHint); Exit;
  end;
  with FDM.SqlTemp do
  begin
    if (FieldByName('R_28Zhe1').AsString='') or
      (FieldByName('R_28Zhe2').AsString='') or
      (FieldByName('R_28Zhe3').AsString='') or
      (FieldByName('R_28Ya1').AsString='') or
      (FieldByName('R_28Ya2').AsString='') or
      (FieldByName('R_28Ya3').AsString='') or
      (FieldByName('R_28Ya4').AsString='') or
      (FieldByName('R_28Ya5').AsString='') or
      (FieldByName('R_28Ya6').AsString='') then
    begin
      nStr := '[ %s ] 28�컯���¼��ȫ!!';
      nStr := Format(nStr, [FieldByName('H_SerialNo').AsString]);
      ShowMsg(nStr, sHint); Exit;
    end;
  end;

  nStr := FDM.SqlTemp.FieldByName('P_Stock').AsString;
  nStr := GetReportFileByStock(nStr);

  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//Desc: ��ӡ��ʶΪnID�ĺϸ�֤
function PrintHeGeReport(const nHID: string; const nAsk: Boolean;const nHydan:string): Boolean;
var nStr,nSR: string;
  nPath:string;
begin
  if nAsk then
  begin
    Result := True;
    nStr := '�Ƿ�Ҫ��ӡ�ϸ�֤?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;

  nPath := '';

  if nHydan='' then
  begin
    nPath := gPath + sReportDir + 'HuanYan3HeGeMax.fr3';

    nStr := 'Select hy.*,sr.*,C_Name,sp.* From $HY hy ' +
            ' Left Join $Cus cus on cus.C_ID=hy.H_Custom' +
            ' Left Join $SR sr on sr.R_SerialNo=hy.H_SerialNo ' +
            ' Left Join $SP sp on sp.P_ID=sr.R_PID ' +
            ' Where H_ID in ($ID)';
    nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
            MI('$Cus', sTable_Customer), MI('$SR', sTable_StockRecord),
            MI('$SP', sTable_StockParam), MI('$ID', nHID)]);
  end
  else begin
    nStr := 'select * from %s where r_serialno=''%s''';
    nstr := Format(nstr,[sTable_StockRecord,nHydan]);
    if fdm.QuerySQL(nStr).RecordCount>0 then
    begin
      nPath := gPath + sReportDir + 'HuanYan3HeGeMax.fr3';
      nStr := 'Select hy.*,sr.*,C_Name,sp.* From $HY hy ' +
              ' Left Join $Cus cus on cus.C_ID=hy.H_Custom' +
              ' Left Join $SR sr on sr.R_SerialNo=hy.H_SerialNo ' +
              ' Left Join $SP sp on sp.P_ID=sr.R_PID ' +
              ' Where H_ID in ($ID)';
      nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
              MI('$Cus', sTable_Customer), MI('$SR', sTable_StockRecord),
              MI('$SP', sTable_StockParam), MI('$ID', nHID)]);
    end
    else begin
      nStr := 'select * from %s where r_serialno=''%s''';
      nstr := Format(nstr,[sTable_StockRecord_Slag,nHydan]);
      if fdm.QuerySQL(nStr).RecordCount>0 then
      begin
        nPath := gPath + sReportDir + 'HuanYan3HeGe_slagMax.fr3';
        nStr := 'Select hy.*,sr.*,C_Name,sp.* From $HY hy ' +
                ' Left Join $Cus cus on cus.C_ID=hy.H_Custom' +
                ' Left Join $SR sr on sr.R_SerialNo=hy.H_SerialNo ' +
                ' Left Join $SP sp on sp.P_ID=sr.R_PID ' +
                ' Where H_ID in ($ID)';
        nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
                MI('$Cus', sTable_Customer), MI('$SR', sTable_StockRecord_Slag),
                MI('$SP', sTable_StockParam), MI('$ID', nHID)]);
      end
      else begin
        nStr := 'select * from %s where r_serialno=''%s''';
        nstr := Format(nstr,[sTable_StockRecord_Concrete,nHydan]);
        if fdm.QuerySQL(nStr).RecordCount>0 then
        begin
          nPath := gPath + sReportDir + 'HuanYan3HeGe_ConcreteMax.fr3';
          nStr := 'Select hy.*,sr.*,C_Name,sp.* From $HY hy ' +
                  ' Left Join $Cus cus on cus.C_ID=hy.H_Custom' +
                  ' Left Join $SR sr on sr.R_SerialNo=hy.H_SerialNo ' +
                  ' Left Join $SP sp on sp.P_ID=sr.R_PID ' +
                  ' Where H_ID in ($ID)';
          nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
                  MI('$Cus', sTable_Customer), MI('$SR', sTable_StockRecord_Concrete),
                  MI('$SP', sTable_StockParam), MI('$ID', nHID)]);
        end
        else begin
          nStr := 'select * from %s where r_serialno=''%s''';
          nstr := Format(nstr,[sTable_StockRecord_clinker,nHydan]);
          if fdm.QuerySQL(nStr).RecordCount>0 then
          begin
            nPath := gPath + sReportDir + 'HuanYan3ShuLiaoMax.fr3';
            nStr := 'Select hy.*,sr.*,C_Name,sp.* From $HY hy ' +
                    ' Left Join $Cus cus on cus.C_ID=hy.H_Custom' +
                    ' Left Join $SR sr on sr.R_SerialNo=hy.H_SerialNo ' +
                    ' Left Join $SP sp on sp.P_ID=sr.R_PID ' +
                    ' Where H_ID in ($ID)';
            nStr := MacroValue(nStr, [MI('$HY', sTable_StockHuaYan),
                    MI('$Cus', sTable_Customer), MI('$SR', sTable_StockRecord_clinker),
                    MI('$SP', sTable_StockParam), MI('$ID', nHID)]);
          end
          else begin
            nStr := '���Ϊ[ %s ] �Ļ����¼������!!';
            nStr := Format(nStr, [nHydan]);
            ShowMsg(nStr, sHint);
            Exit;
          end;
        end;
      end;
    end;
  end;
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �Ļ��鵥��¼����Ч!!';
    nStr := Format(nStr, [nHID]);
    ShowMsg(nStr, sHint); Exit;
  end;

//  nStr := gPath + sReportDir + 'HeGeZheng.fr3';
//  nStr := FDM.SqlTemp.FieldByName('P_Stock').AsString;
//  nStr := subGetReportFileByStock(nStr);
  if nPath='' then
  begin
    nStr := '���Ϊ[ %s ] �Ļ��鵥��¼����Ч!!';
    nStr := Format(nStr, [nHID]);
    ShowMsg(nStr, sHint); Exit;
  end;
  
  if not FDR.LoadReportFile(nPath) then
  begin
    nStr := '�޷���ȷ���ر����ļ�['+nPath+']';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//lih: ��ӡ��ʶΪnBill���泵���鵥
function PrintHYReport(const nBill: string; const nAsk: Boolean): Boolean;
var nStr,nSR: string;
  npath:string;
begin
  npath := '';
  if nAsk then
  begin
    Result := True;
    nStr := '�Ƿ�Ҫ��ӡ���鵥?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end else Result := False;

  nStr := 'select a.*,b.*,c.* from %s a,%s b,%s c '+
          'where a.P_ID=b.R_PID and b.R_SerialNo=c.L_HYDan and c.L_ID= ''%s'' ';
  nStr := Format(nStr,[sTable_StockParam, sTable_StockRecord, sTable_Bill, nBill]);
  //xxxxx
  if FDM.QueryTemp(nStr).RecordCount>0 then
  begin
    npath := gPath + sReportDir + 'HuanYan3HeGe.fr3';
    if Pos('����',FDM.QueryTemp(nStr).FieldByName('L_StockName').AsString)>0 then
    begin
    	npath := gPath + sReportDir + 'HuanYan3ShuLiao.fr3';    
    end;
  end
  else begin
    nStr := 'select a.*,b.*,c.* from %s a,%s b,%s c '+
          'where a.P_ID=b.R_PID and b.R_SerialNo=c.L_HYDan and c.L_ID= ''%s'' ';
    nStr := Format(nStr,[sTable_StockParam, sTable_StockRecord_Slag, sTable_Bill, nBill]);
    if FDM.QueryTemp(nStr).RecordCount>0 then
    begin
      npath := gPath + sReportDir + 'HuanYan3HeGe_Slag.fr3';
    end
    else begin
      nStr := 'select a.*,b.*,c.* from %s a,%s b,%s c '+
            'where a.P_ID=b.R_PID and b.R_SerialNo=c.L_HYDan and c.L_ID= ''%s'' ';
      nStr := Format(nStr,[sTable_StockParam, sTable_StockRecord_Concrete, sTable_Bill, nBill]);
      if FDM.QueryTemp(nStr).RecordCount>0 then
      begin
        npath := gPath + sReportDir + 'HuanYan3HeGe_Concrete.fr3';
      end
      else begin
        nStr := 'select a.*,b.*,c.* from %s a,%s b,%s c '+
            'where a.P_ID=b.R_PID and b.R_SerialNo=c.L_HYDan and c.L_ID= ''%s'' ';
        nStr := Format(nStr,[sTable_StockParam, sTable_StockRecord_clinker, sTable_Bill, nBill]);
        if FDM.QueryTemp(nStr).RecordCount>0 then
        begin
          npath := gPath + sReportDir + 'HuanYan3ShuLiao.fr3';
        end;
      end;
    end;
  end;

  if npath='' then
  begin
    nStr := '���Ϊ[ %s ] �Ļ��鵥��¼����Ч!!';
    nStr := Format(nStr, [nBill]);
    ShowMsg(nStr, sHint); Exit;  
  end;

  if not FDR.LoadReportFile(npath) then
  begin
    nStr := '�޷���ȷ���ر����ļ�[+npath+]';
    ShowMsg(nStr, sHint); Exit;
  end;

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
  if Result then
  begin
    nStr := 'update %s set L_HYPrint=L_HYPrint+1 Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, nBill]);
    with FDM.SQLTemp do
    begin
      Close;
      SQL.Text:=nStr;
      ExecSQL;
    end;
  end;
end;

//Date: 2015/1/18
//Parm: ���ƺţ����ӱ�ǩ���Ƿ����ã��ɵ��ӱ�ǩ
//Desc: ����ǩ�Ƿ�ɹ����µĵ��ӱ�ǩ
function SetTruckRFIDCard(nTruck: string; var nRFIDCard,nRFIDCard2: string;
  var nIsUse: string; nOldCard: string=''; nOldCard2: string=''): Boolean;
var nP: TFormCommandParam;
begin
  nP.FParamA := nTruck;
  nP.FParamB := nOldCard;
  nP.FParamC := nIsUse;
  nP.FParamD := nOldCard2;
  CreateBaseFormItem(cFI_FormMakeRFIDCard, '', @nP);

  nRFIDCard := nP.FParamB;
  nIsUse    := nP.FParamC;
  nRFIDCard2 := nP.FParamD;
  Result    := (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK);
end;


//Date:2016-08-04
//��ȡ�������
function GetSampleID(nStockName:string; var nSampleDate:string):string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_GetSampleID, nStockName, '', @nOut) then
  begin
    Result := nOut.FData;
    nSampleDate := nOut.FExtParam;
  end else Result := '';
end;
//Date:2016-08-04
//��ȡ������ID
function GetCenterID(nStockNo:string; var nLocationID:string):string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_GetCenterID, nStockNo, '', @nOut) then
  begin
    Result := nOut.FData;
    nLocationID := nOut.FExtParam;
  end else Result := '';
end;

//��ȡ���۶���
function GetAXSalesOrder(nSaleID:string=''; nDataArea :string=''): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetSalesOrder, nSaleID, nDataArea, @nOut);
end;
//��ȡ���۶�����
function GetAXSalesOrdLine(nSaleID:string=''; nDataArea :string=''): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetSalesOrdLine, nSaleID, nDataArea, @nOut);
end;
//��ȡ����Э��
function GetAXSupAgreement(nBillID:string=''; nDataArea :string=''): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetSupAgreement, nBillID, nDataArea, @nOut);
end;
//��ȡ���ۺ�ͬ
function GetAXSalesContract(nContID:string=''; nDataArea :string=''): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetSalesCont, nContID, nDataArea, @nOut);
end;
//��ȡ���ۺ�ͬ��
function GetAXSalesContLine(nContID:string=''; nDataArea :string=''): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetSalesContLine, nContID, nDataArea, @nOut);
end;
//��ȡ����
function GetAXVehicleNo(nVehID:string=''; nDataArea :string=''): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetVehicleNo, nVehID, nDataArea, @nOut);
end;
//��ȡ�ɹ�����
function GetAXPurOrder(nPurID:string=''; nDataArea :string=''): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetPurOrder, nPurID, nDataArea, @nOut);
end;
//��ȡ�ɹ�������
function GetAXPurOrdLine(nPurID:string=''; nDataArea :string=''): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallBusinessCommand(cBC_GetPurOrdLine, nPurID, nDataArea, @nOut);
end;


//��ȡ����Э��۸�
function LoadAddTreaty(RecID:string; var nNewPrice:Double):Boolean;
var
  nStr:string;
begin
  Result:=False;
  nNewPrice:=0.00;
  nStr := 'Select top 1 A_SalesNewAmount From '+sTable_AddTreaty+
          ' Where RefRecid='''+RecID+
          ''' and convert(varchar(10),A_TakeEffectDate,23)+'' ''+'+
          'CONVERT(varchar(2),A_TakeEffectTime/(60*60*1000))+'':''+'+
          'CONVERT(varchar(2),(A_TakeEffectTime%(60*60*1000))/(60*1000))+'':''+'+
          'CONVERT(varchar(2),((A_TakeEffectTime%(60*60*1000))%(60*1000))/1000)+''.''+'+
          'CONVERT(varchar(3),A_TakeEffectTime%1000)<= convert(varchar(23),GETDATE(),21) order by Recid desc';
  //WriteLog(nStr);
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nNewPrice:=Fields[0].AsFloat;
    Result:=True;
  end;
end;

//Date: 2016/11/27
//Parm: ��������
//Desc: ����쳣�¼�����
function AddManualEventRecord(nEID, nKey, nEvent:string;
    nFrom: string = '����'; nSolution: string=sFlag_Solution_YN;
    nDepartmen: string=sFlag_DepartMen_DT): Boolean;
var nSQL, nStr: string;
begin
  Result := False;
  //init

  if Trim(nSolution) = '' then
  begin
    WriteLog('��ѡ������.');
    Exit;
  end;

  nSQL := 'Select * From %s Where E_ID=''%s''';
  nSQL := Format(nSQL, [sTable_ManualEvent, nEID]);
  with FDM.QuerySQL(nSQL) do
  if RecordCount > 0 then
  begin
    nStr := '�¼���¼:[ %s ]�Ѵ���';
    nStr := Format(nStr, [nEID]);
    WriteLog(nStr);
    Exit;
  end;

  nSQL := MakeSQLByStr([
          SF('E_ID', nEID),
          SF('E_Key', nKey),
          SF('E_From', nFrom),
          SF('E_Event', nEvent),
          SF('E_Solution', nSolution),
          SF('E_Departmen', nDepartmen),
          SF('E_Date', sField_SQLServer_Now, sfVal)
          ], sTable_ManualEvent, '', True);
  FDM.ExecuteSQL(nSQL);
end;

//Date: 2016/11/27
//Parm: �¼�ID;Ԥ�ڽ��;���󷵻�
//Desc: �ж��¼��Ƿ���
function VerifyManualEventRecord(const nEID: string; var nHint: string;
    const nWant: string): Boolean;
var nSQL, nStr: string;
begin
  Result := False;
  //init

  nSQL := 'Select E_Result, E_Event From %s Where E_ID=''%s''';
  nSQL := Format(nSQL, [sTable_ManualEvent, nEID]);

  with FDM.QuerySQL(nSQL) do
  if RecordCount > 0 then
  begin
    nStr := Trim(FieldByName('E_Result').AsString);
    if nStr = '' then
    begin
      nHint := FieldByName('E_Event').AsString;
      Exit;
    end;

    if nStr <> nWant then
    begin
      nHint := '����ϵ����Ա������Ʊ����';
      Exit;
    end;

    Result := True;
  end;
end;

//��ȡ��װ���
function GetPoundWc(nNet:Double; var nDaiZ,nDaiF:Double;const nw_type:string):Boolean;
var
  nStr:string;
  ntypecondition:string;
begin
  Result:=False;
  if nw_type=sFlag_wuchaType_D then
  begin
    ntypecondition := 'w_type is null or w_type=''%s''';
    ntypecondition := Format(ntypecondition,[sFlag_wuchaType_D]);
  end
  else if nw_type=sFlag_wuchaType_S then
  begin
    ntypecondition := 'w_type=''%s''';
    ntypecondition := Format(ntypecondition,[sFlag_wuchaType_S]);
  end
  else if nw_type=sFlag_wuchaType_Z then
  begin
    ntypecondition := 'w_type=''%s''';
    ntypecondition := Format(ntypecondition,[sFlag_wuchaType_Z]);
  end;
  nDaiZ:=0.00;
  nDaiF:=0.00;
  nStr := 'Select * From %s Where (%s) and ((W_StartValue<=%s) and (W_EndValue>%s)) ';
  nStr := Format(nStr, [sTable_PoundWucha, ntypecondition, FloatToStr(nNet), FloatToStr(nNet)]);
//  WriteLog('GetPoundWc.sql:['+nStr+']');
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    nDaiZ:=FieldByName('W_ZValue').AsFloat;
    nDaiF:=FieldByName('W_FValue').AsFloat;
    Result:=True;
  end;
end;

//��ʼ��������
procedure InitCenter(const nStockNo,nType: string; const nCbx:TcxComboBox);
var
  nStr,nItemGID:string;
begin
  nCbx.Properties.Items.Clear;
  nStr := 'Select D_Desc From %s Where D_Name=''%s'' and D_ParamB=''%s'' and D_Memo=''%s'' ';
  nStr := Format(nStr, [sTable_SysDict, sFlag_StockItem, nStockNo, nType]);
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then Exit;
    nItemGID:= Fields[0].AsString;
  end;

  nStr := 'select a.G_ItemGroupID,a.G_InventCenterID,b.I_Name from %s a,%s b '+  //�������б�
          'where a.G_InventCenterID=b.I_CenterID and a.G_ItemGroupID=''%s'' ';
  nStr := Format(nStr, [sTable_InvCenGroup,sTable_InventCenter,nItemGID]);
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        nCbx.Properties.Items.Add(Fields[1].AsString+'.'+Fields[2].AsString);
        Next;
      end;
    end;
  end;
end;

//��鳵���ϴγ����Ƿ񳬹�һ��Сʱ
function CheckTruckOK(const nTruck:string):Boolean;
var
  nStr,nJGSJ:string;
begin
  Result:=True;
  nStr := 'Select D_Value From %s Where D_Name = ''%s'' and D_Memo=''InFactAndBill'' ';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam]);
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      nJGSJ := FieldByName('D_Value').AsString;
    end else
    begin
      nJGSJ := '0';
    end;
  end;
  if not IsNumber(nJGSJ,False) then nJGSJ:='0';

  nStr := 'Select top 1 L_OutFact,DATEADD(MINUTE,'+nJGSJ+',L_OutFact) as L_OutFactAdd From %s '+
          'Where (L_OutFact is not null) and L_EmptyOut<>''%s'' and L_Truck=''%s'' order by R_ID desc ';
  nStr := Format(nStr, [sTable_Bill, sFlag_Yes, nTruck]);
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      if CompareDateTime(Now,FieldByName('L_OutFactAdd').AsDateTime) < 1 then Result:=False;
    end;
  end;
end;

//��鳵���Ƿ����п���
function CheckTruckBilling(const nTruck:string):Boolean;
var
  nStr:string;
begin
  Result:=True;
  nStr := 'Select T_Billing From %s Where T_Truck = ''%s'' ';
  nStr := Format(nStr, [sTable_Truck, nTruck]);
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    if FieldByName('T_Billing').AsString = sFlag_No then Result := False;
  end;
end;

//��鳧�ڳ������Ƿ�ﵽ����
function CheckTruckCount(const nStockName: string):Boolean;
var
  nStr,nSTD:string;
begin
  Result:=True;
  if Pos('����', nStockName) < 1 then Exit;

  nStr := 'Select D_Value From %s Where D_Name = ''%s'' and D_Memo=''InFactCountSTD'' ';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam]);
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      nSTD := FieldByName('D_Value').AsString;
    end else
    begin
      nSTD := '0';
    end;
  end;
  if not IsNumber(nSTD,False) then nSTD:='0';
  if nSTD = '0' then Exit;
  
  nStr := 'Select Count(*) as ZL From %s  where T_Stock = ''%s'' ';
  nStr := Format(nStr, [sTable_ZTTrucks, nStockName]);
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    if FieldByName('ZL').AsInteger >= StrToInt(nSTD) then Result:=False;
  end;
end;

procedure InitSampleID(const nStockName,nType,nCenterID: string; const nCbx:TcxComboBox);
var nSQL:string;
    nIdx:Integer;
begin
  nCbx.Properties.Items.Clear;
  nSQL := 'select IsNull(R_SerialNo,'''') as R_SerialNo,R_BatQuaStart,R_Date from %s a,%s b '+
          'where a.R_PID = b.P_ID and b.P_Stock= ''%s'' and b.P_Type=''%s'' '+
          'and ((R_CenterID=''%s'') or (R_CenterID='''') or (R_CenterID is null)) and R_BatValid=''%s'' ';
  nSQL := Format(nSQL,[sTable_StockRecord, sTable_StockParam, nStockName, nType, nCenterID, sFlag_Yes]);
  {$IFDEF QHSN}
  {$IFDEF GGJC}
  nSQL := ' select IsNull(R_SerialNo,'''') as R_SerialNo,R_BatQuaStart,R_Date from %s a,%s b '
        +' where a.R_PID = b.P_ID and b.P_Stock= ''%s'' and b.P_Type=''%s'' '
        +' and ((R_CenterID=''%s'') or (R_CenterID='''') or (R_CenterID is null)) and R_BatValid=''%s'''
        +' union '
        +' select IsNull(R_SerialNo,'''') as R_SerialNo,R_BatQuaStart,R_Date from %s a,%s b '
        +' where a.R_PID = b.P_ID and b.P_Stock= ''%s'' and b.P_Type=''%s'''
        +' and ((R_CenterID=''%s'') or (R_CenterID='''') or (R_CenterID is null)) and R_BatValid=''%s'''
        +' union '
        +' select IsNull(R_SerialNo,'''') as R_SerialNo,R_BatQuaStart,R_Date from %s a,%s b '
        +' where a.R_PID = b.P_ID and b.P_Stock= ''%s'' and b.P_Type=''%s'' '
        +' and ((R_CenterID=''%s'') or (R_CenterID='''') or (R_CenterID is null)) and R_BatValid=''%s'' '
        +' union '
        +' select IsNull(R_SerialNo,'''') as R_SerialNo,R_BatQuaStart,R_Date from %s a,%s b '
        +' where a.R_PID = b.P_ID and b.P_Stock= ''%s'' and b.P_Type=''%s'' '
        +' and ((R_CenterID=''%s'') or (R_CenterID='''') or (R_CenterID is null)) and R_BatValid=''%s''';
    nSQL := Format(nSQL,[sTable_StockRecord, sTable_StockParam, nStockName, nType, nCenterID, sFlag_Yes,
                        sTable_StockRecord_Slag, sTable_StockParam, nStockName, nType, nCenterID, sFlag_Yes,
                        sTable_StockRecord_Concrete, sTable_StockParam, nStockName, nType, nCenterID, sFlag_Yes,
                        sTable_StockRecord_clinker, sTable_StockParam, nStockName, nType, nCenterID, sFlag_Yes]);
  {$ENDIF}
  {$ENDIF}
  WriteLog('InitSampleID:sql=['+nSQL+']');
  with FDM.QueryTemp(nSQL) do
  if RecordCount > 0 then
  begin
    First;
    while not Eof do
    begin
      nCbx.Properties.Items.Add(Fields[0].AsString);
      Next;
    end;
    //nCbx.ItemIndex:=0;
  end else
  begin
    ShowMsg('�������ʹ����ϣ�',sHint);
  end;
end;

//��ȡ�����������װ����
function GetSumTonnage(const nSampleID: string):Double;
var nStr:string;
begin
  nStr := 'Select sum(L_Value) From %s Where L_HYDan=''%s''';
  nStr := Format(nStr, [sTable_Bill, nSampleID]);
  with FDM.QueryTemp(nStr) do
  begin
    Result:=Fields[0].AsFloat;
  end;
end;

//��ȡ������
function GetSampleTonnage(const nSampleID: string; var nBatQuaS,nBatQuaE:Double):Boolean;
var nSQL: string;
begin
  Result:=False;  
  nSQL := 'select R_BatQuaStart,R_BatQuaEnd,R_Date from %s where R_SerialNo= ''%s'' ';
  nSQL := Format(nSQL,[sTable_StockRecord, nSampleID]);
  {$IFDEF QHSN}
  {$IFDEF GGJC}
  nSQL := 'select R_BatQuaStart,R_BatQuaEnd,R_Date from %s where R_SerialNo= ''%s'''+
          ' union select R_BatQuaStart,R_BatQuaEnd,R_Date from %s where R_SerialNo= ''%s'''+
          ' union select R_BatQuaStart,R_BatQuaEnd,R_Date from %s where R_SerialNo= ''%s'''+
          ' union select R_BatQuaStart,R_BatQuaEnd,R_Date from %s where R_SerialNo= ''%s''';
  nSQL := Format(nSQL,[sTable_StockRecord, nSampleID,
                      sTable_StockRecord_Slag, nSampleID,
                      sTable_StockRecord_Concrete, nSampleID,
                      sTable_StockRecord_clinker, nSampleID]);  
  {$ENDIF}
  {$ENDIF}  
  with FDM.QueryTemp(nSQL) do
  begin
    if RecordCount > 0 then
    begin
      nBatQuaS:=Fields[0].AsFloat;
      nBatQuaE:=Fields[1].AsFloat;
      Result:=True;
    end;
  end;
end;

//�������������Ч��
function UpdateSampleValid(const nSampleID: string):Boolean;
var nSQL1: string;
  nSQL2,nSQL3,nSQL4:string;
begin
  Result:=False;
  nSQL1 := 'Update %s set R_BatValid=''%s'' where R_SerialNo= ''%s'' ';
  nSQL1 := Format(nSQL1,[sTable_StockRecord, sFlag_No, nSampleID]);
  {$IFDEF QHSN}
  {$IFDEF GGJC}
  nSQL2 := 'Update %s set R_BatValid=''%s'' where R_SerialNo= ''%s'' ';
  nSQL2 := Format(nSQL2,[sTable_StockRecord_Slag, sFlag_No, nSampleID]);

  nSQL3 := 'Update %s set R_BatValid=''%s'' where R_SerialNo= ''%s'' ';
  nSQL3 := Format(nSQL3,[sTable_StockRecord_Concrete, sFlag_No, nSampleID]);

  nSQL4 := 'Update %s set R_BatValid=''%s'' where R_SerialNo= ''%s'' ';
  nSQL4 := Format(nSQL4,[sTable_StockRecord_clinker, sFlag_No, nSampleID]);
  {$ENDIF}
  {$ENDIF}
  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nSQL1);
    {$IFDEF QHSN}
    {$IFDEF GGJC}
    FDM.ExecuteSQL(nSQL2);
    FDM.ExecuteSQL(nSQL3);
    FDM.ExecuteSQL(nSQL4);
    {$ENDIF}
    {$ENDIF}    
    FDM.ADOConn.CommitTrans;
    Result:=True;
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('����'+nSampleID+'��Ч��ʧ��', '��ʾ');
  end;
end;

//�Ƿ������������
function LoadNoSampleID(const nStockNo: string):Boolean;
var nStr:string;
begin
  Result:= False;
  nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Value=''%s'' ';
  nStr := Format(nStr, [sTable_SysDict, sFlag_NoSampleID, nStockNo]);
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then Result:= True;
  end;
end;

procedure InitKuWei(const nType: string; const nCbx:TcxComboBox;const nIdlist:TStrings);
var nSQL:string;
    nIdx:Integer;
begin
  nCbx.Properties.Items.Clear;
  if Assigned(nIdlist) then nIdlist.Clear;
  nSQL := 'select K_KuWeiNo,K_LocationID from %s a where K_Type = ''%s'' ';
  nSQL := Format(nSQL,[sTable_KuWei, nType]);
  with FDM.QueryTemp(nSQL) do
  begin
    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        if Assigned(nIdlist) then nIdlist.Add(FieldByName('K_LocationID').AsString);
        nCbx.Properties.Items.Add(Fields[0].AsString+'.'+Fields[1].AsString);
        Next;
      end;
    end;
  end;
end;

//���߻�ȡ��������
function GetCompanyArea(const nSaleID,nCompanyID:string):string;
var nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_GetAXCompanyArea, nSaleID, nCompanyID, @nOut) then
    Result:= nOut.FData
  else
    Result:='Fail';
end;

//����������������
procedure SaveCompanyArea(const nXSQYMC,nSaleID:string);
var
  nSQL:string;
begin
  nSQL := 'update %s set Z_OrgXSQYMC=''%s'' where Z_ID = ''%s'' ';
  nSQL := Format(nSQL,[sTable_ZhiKa, nXSQYMC, nSaleID]);
  FDM.ExecuteSQL(nSQL);
end;

//��ȡ�ͻ���չ��Ϣ
procedure GetCustomerExt(const nCusID:string; const nCbx:TComboBox);
var nSQL:string;
    nIdx:Integer;
begin
  nCbx.Items.Clear;
  nSQL := 'select E_CustExtName from %s a where E_CusID = ''%s'' order by R_ID DESC ';
  nSQL := Format(nSQL,[sTable_CustomerExt, nCusID]);
  with FDM.QueryTemp(nSQL) do
  begin
    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        nCbx.Items.Add(Fields[0].AsString);
        Next;
      end;
    end;
  end;
end;

//����ͻ���չ��Ϣ
procedure SaveCustomerExt(const nCusID,nCusExtName:string);
var
  nSQL:string;
begin
  nSQL := 'select * from %s where E_CusID = ''%s'' and E_CustExtName=''%s'' ';
  nSQL := Format(nSQL,[sTable_CustomerExt, nCusID, nCusExtName]);
  if FDM.QueryTemp(nSQL).RecordCount < 1 then
  begin
    nSQL := 'Insert into %s (E_CusID, E_CustExtName) values (''%s'', ''%s'') ';
    nSQL := Format(nSQL,[sTable_CustomerExt, nCusID, nCusExtName]);
    FDM.ExecuteSQL(nSQL);
  end;
end;

//��ӡnID��Ӧ�Ķ̵�����
function PrintDuanDaoReport(nID: string; const nAsk: Boolean): Boolean;
var nStr: string;
    nParam: TReportParamItem;
begin
  Result := False;

  if nAsk then
  begin
    nStr := '�Ƿ�Ҫ��ӡ�̵�ҵ����ذ���?';
    if not QueryDlg(nStr, sAsk) then Exit;
  end;

  nStr := 'Select * From %s b Where T_ID=''%s''';
  nStr := Format(nStr, [sTable_Transfer, nID]);
  //xxxxx

  if FDM.QueryTemp(nStr).RecordCount < 1 then
  begin
    nStr := '���Ϊ[ %s ] �ļ�¼����Ч!!';
    nStr := Format(nStr, [nID]);
    ShowMsg(nStr, sHint); Exit;
  end;

  nStr := gPath + sReportDir + 'DuanDao.fr3';
  if not FDR.LoadReportFile(nStr) then
  begin
    nStr := '�޷���ȷ���ر����ļ�';
    ShowMsg(nStr, sHint); Exit;
  end;

  nParam.FName := 'UserName';
  nParam.FValue := gSysParam.FUserID;
  FDR.AddParamItem(nParam);

  nParam.FName := 'Company';
  nParam.FValue := gSysParam.FHintText;
  FDR.AddParamItem(nParam);

  FDR.Dataset1.DataSet := FDM.SqlTemp;
  FDR.ShowReport;
  Result := FDR.PrintSuccess;
end;

//�Ƿ��ӡ
function PrintYesNo:Boolean;
var nStr:string;
begin
  Result:= False;
  nStr := 'Select D_Value From %s Where D_Name=''%s'' ';
  nStr := Format(nStr, [sTable_SysDict, sFlag_PrintBill]);
  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      Last;
      if Fields[0].AsString='Y' then Result:= True;
    end;
  end;
end;

function SaveTransferInfo(nTruck, nMateID, nMate, nSrcAddr, nDstAddr:string):Boolean;
var nP: TFormCommandParam;
begin
  with nP do
  begin
    FParamA := nTruck;
    FParamB := nMateID;
    FParamC := nMate;
    FParamD := nSrcAddr;
    FParamE := nDstAddr;

    CreateBaseFormItem(cFI_FormTransfer, '', @nP);
    Result  := (FCommand = cCmd_ModalResult) and (FParamA = mrOK);
  end;
end;


//��ȡ�Ƿ��Զ�����
function GetAutoInFactory(const nStockNo:string):Boolean;
var
  nSQL:string;
begin
  Result:= False;
  nSQL := 'Select D_Value From %s Where D_Name=''AutoOutStock'' and D_Value=''%s''';
  nSQL := Format(nSQL, [sTable_SysDict, nStockNo]);

  with FDM.QueryTemp(nSQL) do
  if RecordCount > 0 then
  begin
    Result:=True;
  end;
end;

//��ȡ�ڵ�����
function GetNeiDao(const nStockNo:string):Boolean;
var
  nSQL:string;
begin
  Result:= False;
  nSQL := 'Select D_Value From %s Where D_Name=''NeiDaoPurch'' and D_Value=''%s''';
  nSQL := Format(nSQL, [sTable_SysDict, nStockNo]);

  with FDM.QueryTemp(nSQL) do
  if RecordCount > 0 then
  begin
    Result:=True;
  end;
end;

//��ȡ�����°�����
function GetDaoChe(const nStockNo:string):Boolean;
var
  nSQL:string;
begin
  Result:= False;
  nSQL := 'Select D_Value From %s Where D_Name=''DaoChePurch'' and D_Value=''%s''';
  nSQL := Format(nSQL, [sTable_SysDict, nStockNo]);

  with FDM.QueryTemp(nSQL) do
  if RecordCount > 0 then
  begin
    Result:=True;
  end;
end;

//Date:2016-10-09
//��ȡ����������
function GetCenterSUM(nStockNo,nStockType,nCenterID:string):string;
var nOut: TWorkerBusinessCommand;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    nList.Values['StockType'] := nStockType;
    nList.Values['CenterID']  := nCenterID;
    if CallBusinessCommand(cBC_GetAXInVentSum, nStockNo, nList.Text, @nOut) then
    begin
      Result := nOut.FData;
    end else Result := '';
    WriteLog(nStockNo+'  '+nStockType+'  '+nCenterID+'  '+Result);
  finally
    nList.Free;
  end;
end;

//��ȡֽ������
function GetZhikaYL(nRECID:string):Double;
var
  nOut: TWorkerBusinessCommand;
begin
  if CallBusinessCommand(cBC_GetSalesOrdValue, nRECID, '', @nOut) then
  begin
    Result := StrToFloat(nOut.FData);
  end else Result := 0;

end;

//��ȡ�ɹ���������
function GetPurchRestValue(const nRecID:string; var nIfCheck:Boolean):Double;
var
  nSQL:string;
begin
  Result:= 0.0;
  nIfCheck:= True;
  nSQL := 'Select a.*,b.* From %s a, %s b ' +
          'Where a.B_ID=b.M_ID ' +
          'And ((B_BStatus=''Y'') or (B_BStatus=''1'') or ((M_PurchType=''0'') and (B_BStatus=''0''))) '+
          'and B_Blocked=''0'' and B_RecID=''%s'' ';

  nSQL := Format(nSQL , [sTable_OrderBase,sTable_OrderBaseMain,nRecID]);

  //nSQL := 'Select (B_Value-IsNull(B_SentValue,0)-IsNull(B_FreezeValue,0)) As B_RestValue From %s Where B_RecID=''%s'' ';
  {nSQL := 'Select B_RestValue From %s Where B_RecID=''%s'' ';
  nSQL := Format(nSQL, [sTable_OrderBase, nRecID]); }
  WriteLog(nSQL);
  with FDM.QueryTemp(nSQL) do
  if RecordCount > 0 then
  begin
    Result:=FieldByName('B_RestValue').AsFloat;
    nIfCheck:=FieldByName('M_PurchType').AsString <> '0';
  end;
end;

//��ȡ�ͻ�ע����Ϣ
function getCustomerInfo(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_WeChat_getCustomerInfo, nXmlStr, '', @nOut) then
    Result := nOut.FData;
end;

//�ͻ���΢���˺Ű�
function get_Bindfunc(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_WeChat_get_Bindfunc, nXmlStr, '', @nOut) then
    Result := nOut.FData;
end;

//������Ϣ
function send_event_msg(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_WeChat_send_event_msg, nXmlStr, '', @nOut) then
    Result := nOut.FData;
end;

//�����̳��û�
function edit_shopclients(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_WeChat_edit_shopclients, nXmlStr, '', @nOut) then
    Result := nOut.FData;
end;

//�����Ʒ
function edit_shopgoods(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_WeChat_edit_shopgoods, nXmlStr, '', @nOut) then
    Result := nOut.FData;
end;

//��ȡ������Ϣ
function get_shoporders(const nXmlStr: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  if CallBusinessCommand(cBC_WeChat_get_shoporders, nXmlStr, '', @nOut) then
    Result := nOut.FData;
end;

//Desc: У��װ����nLineIDˮ��Ʒ�ֱ��ʱ��������Ŷӳ������޷��޸�
function VerifyZTlineChange(const nLineID: string): Boolean;
var
  nStr,nSql:string;
begin
  Result := True;

  nSql := 'select * from %s where T_Line = ''%s'' ';
  nSql := Format(nSql,[sTable_ZTTrucks,nLineID]);

  with FDM.QueryTemp(nSql) do
  begin
    if recordcount>0 then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

function VerifySnapTruck(const nReader: string; nBill: TLadingBillItem;
                         var nMsg, nPos: string): Boolean;
var nStr, nDept: string;
    nNeedManu, nUpdate: Boolean;
    nSnapTruck, nTruck, nEvent, nPicName: string;
begin
  Result := False;
  nPos := '';
  nNeedManu := False;
  nSnapTruck := '';
  nDept := '';
  nTruck := nBill.Ftruck;

  nPos := ReadPoundReaderInfo(nReader,nDept);

  if nPos = '' then
  begin
    Result := True;
    nMsg := '������[ %s ]�󶨸�λΪ��,�޷�����ץ��ʶ��.';
    nMsg := Format(nMsg, [nReader]);
    Exit;
  end;

  nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_TruckInNeedManu,nPos]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      nNeedManu := FieldByName('D_Value').AsString = sFlag_Yes;

      if nNeedManu then
      begin
        nMsg := '������[ %s ]�󶨸�λ[ %s ]��Ԥ����:�˹���Ԥ������.';
        nMsg := Format(nMsg, [nReader, nPos]);
      end
      else
      begin
        nMsg := '������[ %s ]�󶨸�λ[ %s ]��Ԥ����:�˹���Ԥ�ѹر�.';
        nMsg := Format(nMsg, [nReader, nPos]);
        Result := True;
        Exit;
      end;
    end
    else
    begin
      Result := True;
      nMsg := '������[ %s ]�󶨸�λ[ %s ]δ���ø�Ԥ����,�޷�����ץ��ʶ��.';
      nMsg := Format(nMsg, [nReader, nPos]);
      Exit;
    end;
  end;

  nStr := 'Select * From %s Where S_ID=''%s'' order by R_ID desc ';
  nStr := Format(nStr, [sTable_SnapTruck, nPos]);
  //xxxxx

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount < 1 then
    begin
      if not nNeedManu then
        Result := True;
      Exit;
    end;

    nPicName := '';

    First;

    while not Eof do
    begin
      nSnapTruck := FieldByName('S_Truck').AsString;
      if nPicName = '' then//Ĭ��ȡ����һ��ץ��
        nPicName := FieldByName('S_PicName').AsString;
      if Pos(nTruck,nSnapTruck) > 0 then
      begin
        Result := True;
        nPicName := FieldByName('S_PicName').AsString;
        //ȡ��ƥ��ɹ���ͼƬ·��
        nMsg := '����[ %s ]����ʶ��ɹ�,ץ�ĳ��ƺ�:[ %s ]';
        nMsg := Format(nMsg, [nTruck,nSnapTruck]);
        Exit;
      end;
      //����ʶ��ɹ�
      Next;
    end;
  end;

  nStr := 'Select * From %s Where E_ID=''%s''';
  nStr := Format(nStr, [sTable_ManualEvent, nBill.FID+sFlag_ManualE]);

  with FDM.QueryTemp(nStr) do
  begin
    if RecordCount > 0 then
    begin
      if FieldByName('E_Result').AsString = 'N' then
      begin
        nMsg := '����[ %s ]����ʶ��ʧ��,ץ�ĳ��ƺ�:[ %s ],����Ա��ֹ';
        nMsg := Format(nMsg, [nTruck,nSnapTruck]);
        Exit;
      end;
      if FieldByName('E_Result').AsString = 'Y' then
      begin
        Result := True;
        nMsg := '����[ %s ]����ʶ��ʧ��,ץ�ĳ��ƺ�:[ %s ],����Ա����';
        nMsg := Format(nMsg, [nTruck,nSnapTruck]);
        Exit;
      end;
      nUpdate := True;
    end
    else
    begin
      nMsg := '����[ %s ]����ʶ��ʧ��,ץ�ĳ��ƺ�:[ %s ]';
      nMsg := Format(nMsg, [nTruck,nSnapTruck]);
      nUpdate := False;
      if not nNeedManu then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

  nEvent := '����[ %s ]����ʶ��ʧ��,ץ�ĳ��ƺ�:[ %s ]';
  nEvent := Format(nEvent, [nTruck,nSnapTruck]);

  nStr := SF('E_ID', nBill.FID+sFlag_ManualE);
  nStr := MakeSQLByStr([
          SF('E_ID', nBill.FID+sFlag_ManualE),
          SF('E_Key', nPicName),
          SF('E_From', nPos),
          SF('E_Result', 'Null', sfVal),

          SF('E_Event', nEvent),
          SF('E_Solution', sFlag_Solution_YN),
          SF('E_Departmen', nDept),
          SF('E_Date', sField_SQLServer_Now, sfVal)
          ], sTable_ManualEvent, nStr, (not nUpdate));
  //xxxxx
  FDM.ExecuteSQL(nStr);
end;

//Date: 2018-08-03
//Parm: ������ID
//Desc: ��ȡnReader��λ������
function ReadPoundReaderInfo(const nReader: string; var nDept: string): string;
var nOut: TWorkerBusinessCommand;
begin
  Result := '';
  nDept:= '';
  //����

  if CallBusinessHardware(cBC_GetPoundReaderInfo, nReader, '', @nOut)  then
  begin
    Result := Trim(nOut.FData);
    nDept:= Trim(nOut.FExtParam);
  end;
end;

procedure RemoteSnapDisPlay(const nPost, nText, nSucc: string);
var nOut: TWorkerBusinessCommand;
    nList: TStrings;
begin
  nList := TStringList.Create;
  try
    nList.Values['text'] := nText;
    nList.Values['succ'] := nSucc;

    CallBusinessHardware(cBC_RemoteSnapDisPlay, nPost, PackerEncodeStr(nList.Text), @nOut);
  finally
    nList.Free;
  end;
end;


end.
