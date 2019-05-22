{*******************************************************************************
  ����: dmzn@163.com 2013-12-04
  ����: ģ��ҵ�����
*******************************************************************************}
unit UWorkerBusiness;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, DB, SysUtils, UBusinessWorker, UBusinessPacker,
  UBusinessConst, UMgrDBConn, UMgrParam, ZnMD5, ULibFun, UFormCtrl, USysLoger,
  USysDB, UMITConst, NativeXml, revicewstest, BPM2ERPService, HTTPApp;

type
  TBusWorkerQueryField = class(TBusinessWorkerBase)
  private
    FIn: TWorkerQueryFieldData;
    FOut: TWorkerQueryFieldData;
  public
    class function FunctionName: string; override;
    function GetFlagStr(const nFlag: Integer): string; override;
    function DoWork(var nData: string): Boolean; override;
    //ִ��ҵ��
  end;

  TMITDBWorker = class(TBusinessWorkerBase)
  protected
    FErrNum: Integer;
    //������
    FDBConn: PDBWorker;
    //����ͨ��
    FDataIn,FDataOut: PBWDataBase;
    //��γ���
    FDataOutNeedUnPack: Boolean;
    //��Ҫ���
    procedure GetInOutData(var nIn,nOut: PBWDataBase); virtual; abstract;
    //�������
    function VerifyParamIn(var nData: string): Boolean; virtual;
    //��֤���
    function DoDBWork(var nData: string): Boolean; virtual; abstract;
    function DoAfterDBWork(var nData: string; nResult: Boolean): Boolean; virtual;
    //����ҵ��
  public
    function DoWork(var nData: string): Boolean; override;
    //ִ��ҵ��
    procedure WriteLog(const nEvent: string);
    //��¼��־
  end;

  THuaYan = record
    FReriNo:string;
    FValue:Double;
    FZLVal:Double;
  end;

  TWorkerBusinessCommander = class(TMITDBWorker)
  private
    FListA,FListB,FListC,FListD,FListE: TStrings;
    //list
    FIn: TWorkerBusinessCommand;
    FOut: TWorkerBusinessCommand;
    FHuaYan: array of THuaYan;
  protected
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton
    function GetCardUsed(var nData: string): Boolean;
    //��ȡ��Ƭ����
    function Login(var nData: string):Boolean;
    function LogOut(var nData: string): Boolean;
    //��¼ע���������ƶ��ն�
    function GetServerNow(var nData: string): Boolean;
    //��ȡ������ʱ��
    function GetSerailID(var nData: string): Boolean;
    //��ȡ����
    function IsSystemExpired(var nData: string): Boolean;
    //ϵͳ�Ƿ��ѹ���
    function CustomerMaCredLmt(var nData: string): Boolean;
    //��֤�ͻ��Ƿ�ǿ�����ö��
    function GetCustomerValidMoney(var nData: string): Boolean;
    //��ȡ�ͻ����ý�
    function GetZhiKaValidMoney(var nData: string): Boolean;
    //��ȡֽ�����ý�
    function CustomerHasMoney(var nData: string): Boolean;
    //��֤�ͻ��Ƿ���Ǯ
    function SaveTruck(var nData: string): Boolean;
    function UpdateTruck(var nData: string): Boolean;
    //���泵����Truck��
    function GetTruckPoundData(var nData: string): Boolean;
    function SaveTruckPoundData(var nData: string): Boolean;
    //��ȡ������������
    function VerifySnapTruck(var nData: string): Boolean;
    //���Ʊȶ�
    {$IFDEF QLS}
    function SyncAXCustomer(var nData: string): Boolean;//ͬ��AX�ͻ���Ϣ��DL
    function SyncAXProviders(var nData: string): Boolean;//ͬ��AX��Ӧ����Ϣ��DL
    function SyncAXINVENT(var nData: string): Boolean;//ͬ��AX������Ϣ��DL
    function SyncAXCement(var nData: string): Boolean;//ͬ��AXˮ�����͵�DL
    function SyncAXINVENTDIM(var nData: string): Boolean;//ͬ��AXά����Ϣ��DL
    function SyncAXTINVENTCENTER(var nData: string): Boolean;//ͬ��AX�����߻�����Ϣ��DL
    function SyncAXINVENTLOCATION(var nData: string): Boolean;//ͬ��AX�ֿ������Ϣ��DL
    function SyncAXTPRESTIGEMANAGE(var nData: string): Boolean;//ͬ��AX���ö�ȣ��ͻ�����Ϣ��DL
    function SyncAXTPRESTIGEMBYCONT(var nData: string): Boolean;//ͬ��AX���ö�ȣ��ͻ�-��ͬ����Ϣ��DL
    function SyncAXEmpTable(var nData: string): Boolean;//ͬ��AXԱ����Ϣ��DL
    function SyncAXInvCenGroup(var nData :string): Boolean;//ͬ��AX�����������ߵ�DL
    function SyncAXwmsLocation(var nData :string): Boolean;//ͬ��AX��λ��Ϣ��DL
    //--------------------------------------------------------------------------
    function GetAXSalesOrder(var nData: string): Boolean;//��ȡ���۶���
    function GetAXSalesOrdLine(var nData: string): Boolean;//��ȡ���۶�����
    function GetAXSupAgreement(var nData: string): Boolean;//��ȡ����Э��
    function GetAXCreLimCust(var nData: string): Boolean;//��ȡ���ö���������ͻ���
    function GetAXCreLimCusCont(var nData: string): Boolean;//��ȡ���ö���������ͻ�-��ͬ��
    function GetAXSalesContract(var nData: string): Boolean;//��ȡ���ۺ�ͬ
    function GetAXSalesContLine(var nData: string): Boolean;//��ȡ���ۺ�ͬ��
    function GetAXVehicleNo(var nData: string): Boolean;//��ȡ����
    function GetAXPurOrder(var nData: string): Boolean;//��ȡ�ɹ�����
    function GetAXPurOrdLine(var nData: string): Boolean;//��ȡ�ɹ�������
    //--------------------------------------------------------------------------
    function SyncStockBillAX(var nData: string):Boolean;//ͬ�������������˼ƻ�����AX
    function SyncDelSBillAX(var nData: string):Boolean;//ͬ��ɾ����������AX
    function SyncPoundBillAX(var nData: string):Boolean;//ͬ��������AX
    function SyncPurPoundBillAX(var nData: string):Boolean;//ͬ���������ɹ�����AX
    function SyncVehicleNoAX(var nData: string):Boolean;//ͬ�����ŵ�AX
    function SyncEmptyOutBillAX(var nData: string):Boolean;//ͬ���ճ�����������
    function GetSampleID(var nData: string):Boolean;//��ȡ�������
    function GetCenterID(var nData: string):Boolean;//��ȡ������ID
    function GetTriangleTrade(var nData: string):Boolean;//���ض������л�ȡ�Ƿ�����ó��
    function GetCustNo(var nData: string):Boolean;//��ȡ���տͻ�ID�͹�˾ID
    function GetAXMaCredLmt(var nData: string): Boolean;//���߻�ȡ�ͻ��Ƿ�ǿ�����ö��
    function GetAXContQuota(var nData: string): Boolean;//���߻�ȡ�Ƿ�ר��ר��
    function GetAXTPRESTIGEMANAGE(var nData: string): Boolean;//���߻�ȡAX���ö�ȣ��ͻ�����Ϣ��DL
    function GetAXTPRESTIGEMBYCONT(var nData: string): Boolean;//���߻�ȡAX���ö�ȣ��ͻ�-��ͬ����Ϣ��DL
    function GetAXCompanyArea(var nData: string): Boolean;//���߻�ȡ����ó�׶�������������
    function GetInVentSum(var nData: string): Boolean;//���߻�ȡ����������
    function GetSalesOrdValue(var nData: string): Boolean;//��ȡ����������
    function ReadZhikaInfo(var nData: string): Boolean;
    //��ȡ���۶�����Ϣ
    function ReadStockPrice(var nData: string): Boolean;
    //��ȡ�������ϼ۸�
    function CheckSecurityCodeValid(var nData: string): Boolean;
    //��α��У��
    function GetWaitingForloading(var nData: string):Boolean;
    //������װ��ѯ
    function GetInOutFactoryTatol(var nData:string):Boolean;
    //����������ѯ���ɹ������������۳�������
    function GetBillSurplusTonnage(var nData:string):boolean;
    //���϶������µ�������ѯ
    function GetOrderInfo(var nData:string):Boolean;
    //��ȡ������Ϣ�����������µ�
    function GetOrderList(var nData:string):Boolean;
    //��ȡ������Ϣ�����������µ�
    function GetPurchaseContractList(var nData:string):Boolean;
    //��ȡ�ɹ������б����������µ�
    function getCustomerInfo(var nData:string):Boolean;
    //��ȡ�ͻ�ע����Ϣ
    function get_Bindfunc(var nData:string):Boolean;
    //�ͻ���΢���˺Ű�
    function send_event_msg(var nData:string):Boolean;
    //������Ϣ
    function edit_shopclients(var nData:string):Boolean;
    //�����̳��û�
    function edit_shopgoods(var nData:string):Boolean;
    //�����Ʒ
    function get_shoporders(var nData:string):Boolean;
    //��ȡ������Ϣ
    function get_shoporderbyno(var nData:string):Boolean;
    //���ݶ����Ż�ȡ������Ϣ-����
    function get_shopPurchasebyNO(var nData:string):Boolean;
    //���ݻ����Ż�ȡ������Ϣ-ԭ����
    function complete_shoporders(var nData:string):Boolean;
    //�޸Ķ���״̬
    {$ENDIF}
  public
    constructor Create; override;
    destructor destroy; override;
    //new free
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
    //base function
    class function CallMe(const nCmd: Integer; const nData,nExt: string;
      const nOut: PWorkerBusinessCommand): Boolean;
    //local call
  end;

  TStockMatchItem = record
    FStock: string;         //Ʒ��
    FGroup: string;         //����
    FRecord: string;        //��¼
  end;

  TBillLadingLine = record
    FBill: string;          //������
    FLine: string;          //װ����
    FName: string;          //������
    FPerW: Integer;         //����
    FTotal: Integer;        //�ܴ���
    FNormal: Integer;       //����
    FBuCha: Integer;        //����
    FHKBills: string;       //�Ͽ���
  end;

  PYSLine = ^TYSLine;
  TYSLine = record
    FY_ID: string;//���
    FY_Name: string;//����
    FY_StockNo: string;//Ʒ�ֱ��
    FY_Stock: string;//Ʒ��
    FY_StockType: string;//����(��,ɢ)
    FY_PeerWeight: Integer;//����
    FY_QueueMax: Integer;//���д�С
    FY_VIPLine: string;//VIPͨ��
    FY_Valid: string;//�Ƿ���Ч
    FY_Index: Integer;//˳������
    FYS_Valid:string;//�����Ƿ���Ч
  end;

  TWorkerBusinessBills = class(TMITDBWorker)
  private
    FListA,FListB,FListC: TStrings;
    //list
    FIn: TWorkerBusinessCommand;
    FOut: TWorkerBusinessCommand;
    //io
    FSanMultiBill: Boolean;
    //ɢװ�൥
    FStockItems: array of TStockMatchItem;
    FMatchItems: array of TStockMatchItem;
    //����ƥ��
    FBillLines: array of TBillLadingLine;
    //װ����
  protected
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton
    function GetStockGroup(const nStock: string): string;
    function GetMatchRecord(const nStock: string): string;
    //���Ϸ���
    function AllowedSanMultiBill: Boolean;
    function VerifyBeforSave(var nData: string): Boolean;
    //
    function GetOnLineModel: string;
    //��ȡ����ģʽ
    function LoadZhiKaInfo(const nZID: string; var nHint: string): TDataset;
    //����ֽ��
    function GetRemCustomerMoney(const nZID:string; var nRemMoney:Double; var nMsg:string): Boolean;
    //����Զ�̻�ȡ�ͻ����ú��ʽ�
    function GetRemTriCustomerMoney(const nZID:string; var nRemMoney:Double; var nMsg:string): Boolean;
    //����Զ�̻�ȡ����ó�׿ͻ����ú��ʽ�
    function SaveBills(var nData: string): Boolean;
    //���潻����
    function DeleteBill(var nData: string): Boolean;
    //ɾ��������
    function ChangeBillTruck(var nData: string): Boolean;
    //�޸ĳ��ƺ�
    function BillSaleAdjust(var nData: string): Boolean;
    //���۵���
    function SaveBillCard(var nData: string): Boolean;
    //�󶨴ſ�
    function LogoffCard(var nData: string): Boolean;
    //ע���ſ�
    function GetPostBillItems(var nData: string): Boolean;
    //��ȡ��λ������
    function SavePostBillItems(var nData: string): Boolean;
    //�����λ������
    function DelBillSendMsgWx(LID:string):Boolean;
    //ɾ������΢����Ϣ
    function IsBrick(const nStockno:string):Boolean;
    procedure SaveHyDan(const nEID,nHydan,nStockno,nStockname,nFrom,nSolution,nDepartment: string);
  public
    constructor Create; override;
    destructor destroy; override;
    //new free
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
    //base function
    class function VerifyTruckNO(nTruck: string; var nData: string): Boolean;
    //��֤�����Ƿ���Ч
  end;

  TWorkerBusinessOrders = class(TMITDBWorker)
  private
    FListA,FListB,FListC: TStrings;
    //list
    FIn: TWorkerBusinessCommand;
    FOut: TWorkerBusinessCommand;
  protected
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoDBWork(var nData: string): Boolean; override;
    //base funciton

    function SaveOrderBase(var nData: string):Boolean;
    function DeleteOrderBase(var nData: string):Boolean;
    function SaveOrder(var nData: string):Boolean;
    function DeleteOrder(var nData: string): Boolean;
    function SaveOrderCard(var nData: string): Boolean;
    function LogoffOrderCard(var nData: string): Boolean;
    function ChangeOrderTruck(var nData: string): Boolean;
    //�޸ĳ��ƺ�
    function GetGYOrderValue(var nData: string): Boolean;
    //��ȡ��Ӧ���ջ���

    function GetPostOrderItems(var nData: string): Boolean;
    //��ȡ��λ�ɹ���
    function SavePostOrderItems(var nData: string): Boolean;
    //�����λ�ɹ���
    function SavePostOther(const nCard,nPost: string; var nData: string;
     nPound:TLadingBillItem; const nExtData: TStrings = nil): Boolean;
    //���湩Ӧ,��ʱҵ���λ����
    function GetOnLineModel: string;
    //��ȡ����ģʽ
    function LoadOtherByCard(const nItems: TLadingBillItems;const nCard: string; var nData: string): Boolean;
    //��ȡ�ſ���Ϣ

    function GetCardUsed(const nCard: string;var nCardType: string): Boolean;
    //��ȡ��Ƭ����

    function GetYsLine(const nYSno:string):PYSLine;
    function getPrePInfo(const nTruck:string;var nPrePValue:Double;var nPrePMan:string;var nPrePTime:TDateTime):Boolean;
  public
    constructor Create; override;
    destructor destroy; override;
    //new free
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
    //base function
    class function CallMe(const nCmd: Integer; const nData,nExt: string;
      const nOut: PWorkerBusinessCommand): Boolean;
    //local call
  end;

implementation
uses
  UWorkerClientWebChat,UMgrQueue,UDataModule,UHardBusiness,IniFiles;

class function TBusWorkerQueryField.FunctionName: string;
begin
  Result := sBus_GetQueryField;
end;

function TBusWorkerQueryField.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_GetQueryField;
  end;
end;

function TBusWorkerQueryField.DoWork(var nData: string): Boolean;
begin
  FOut.FData := '*';
  FPacker.UnPackIn(nData, @FIn);

  case FIn.FType of
   cQF_Bill: 
    FOut.FData := '*';
  end;

  Result := True;
  FOut.FBase.FResult := True;
  nData := FPacker.PackOut(@FOut);
end;

//------------------------------------------------------------------------------
//Date: 2012-3-13
//Parm: ���������
//Desc: ��ȡ�������ݿ��������Դ
function TMITDBWorker.DoWork(var nData: string): Boolean;
begin
  Result := False;
  FDBConn := nil;

  with gParamManager.ActiveParam^ do
  try
    FDBConn := gDBConnManager.GetConnection(FDB.FID, FErrNum);
    if not Assigned(FDBConn) then
    begin
      nData := '�������ݿ�ʧ��(DBConn Is Null).';
      Exit;
    end;

    if not FDBConn.FConn.Connected then
      FDBConn.FConn.Connected := True;
    //conn db

    FDataOutNeedUnPack := True;
    GetInOutData(FDataIn, FDataOut);
    FPacker.UnPackIn(nData, FDataIn);

    with FDataIn.FVia do
    begin
      FUser   := gSysParam.FAppFlag;
      FIP     := gSysParam.FLocalIP;
      FMAC    := gSysParam.FLocalMAC;
      FTime   := FWorkTime;
      FKpLong := FWorkTimeInit;
    end;

    {$IFDEF DEBUG}
    WriteLog('Fun: '+FunctionName+' InData:'+ FPacker.PackIn(FDataIn, False));
    {$ENDIF}
    if not VerifyParamIn(nData) then Exit;
    //invalid input parameter

    FPacker.InitData(FDataOut, False, True, False);
    //init exclude base
    FDataOut^ := FDataIn^;

    Result := DoDBWork(nData);
    //execute worker

    if Result then
    begin
      if FDataOutNeedUnPack then
        FPacker.UnPackOut(nData, FDataOut);
      //xxxxx

      Result := DoAfterDBWork(nData, True);
      if not Result then Exit;

      with FDataOut.FVia do
        FKpLong := GetTickCount - FWorkTimeInit;
      nData := FPacker.PackOut(FDataOut);

      {$IFDEF DEBUG}
      WriteLog('Fun: '+FunctionName+' OutData:'+ FPacker.PackOut(FDataOut, False));
      {$ENDIF}
    end else DoAfterDBWork(nData, False);
  finally
    gDBConnManager.ReleaseConnection(FDBConn);
  end;
end;

//Date: 2012-3-22
//Parm: �������;���
//Desc: ����ҵ��ִ����Ϻ����β����
function TMITDBWorker.DoAfterDBWork(var nData: string; nResult: Boolean): Boolean;
begin
  Result := True;
end;

//Date: 2012-3-18
//Parm: �������
//Desc: ��֤��������Ƿ���Ч
function TMITDBWorker.VerifyParamIn(var nData: string): Boolean;
begin
  Result := True;
end;

//Desc: ��¼nEvent��־
procedure TMITDBWorker.WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TMITDBWorker, FunctionName, nEvent);
end;

//------------------------------------------------------------------------------
class function TWorkerBusinessCommander.FunctionName: string;
begin
  Result := sBus_BusinessCommand;
end;

constructor TWorkerBusinessCommander.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  FListD := TStringList.Create;
  FListE := TStringList.Create;
  inherited;
end;

destructor TWorkerBusinessCommander.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  FreeAndNil(FListD);
  FreeAndNil(FListE);
  inherited;
end;

function TWorkerBusinessCommander.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
  end;
end;

procedure TWorkerBusinessCommander.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2014-09-15
//Parm: ����;����;����;���
//Desc: ���ص���ҵ�����
class function TWorkerBusinessCommander.CallMe(const nCmd: Integer;
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
    nPacker.InitData(@nIn, True, False);
    //init
    
    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(FunctionName);
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

//Date: 2012-3-22
//Parm: ��������
//Desc: ִ��nDataҵ��ָ��
function TWorkerBusinessCommander.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := 'ҵ��ִ�гɹ�.';
  end;

  case FIn.FCommand of
   cBC_GetCardUsed         : Result := GetCardUsed(nData);
   cBC_ServerNow           : Result := GetServerNow(nData);
   cBC_GetSerialNO         : Result := GetSerailID(nData);
   cBC_IsSystemExpired     : Result := IsSystemExpired(nData);
   cBC_CustomerMaCredLmt   : Result := CustomerMaCredLmt(nData);
   cBC_GetCustomerMoney    : Result := GetCustomerValidMoney(nData);
   cBC_GetZhiKaMoney       : Result := GetZhiKaValidMoney(nData);
   cBC_CustomerHasMoney    : Result := CustomerHasMoney(nData);
   cBC_SaveTruckInfo       : Result := SaveTruck(nData);
   cBC_UpdateTruckInfo     : Result := UpdateTruck(nData);
   cBC_GetTruckPoundData   : Result := GetTruckPoundData(nData);
   cBC_SaveTruckPoundData  : Result := SaveTruckPoundData(nData);
   cBC_UserLogin           : Result := Login(nData);
   cBC_UserLogOut          : Result := LogOut(nData);
   {$IFDEF QLS}
   cBC_SyncCustomer        : Result := SyncAXCustomer(nData);
   cBC_SyncProvider        : Result := SyncAXProviders(nData);
   cBC_SyncMaterails       : Result := SyncAXINVENT(nData);
   cBC_SyncAXCement        : Result := SyncAXCement(nData);
   cBC_SyncInvDim          : Result := SyncAXINVENTDIM(nData);
   cBC_SyncInvCenter       : Result := SyncAXTINVENTCENTER(nData);
   cBC_SyncInvLocation     : Result := SyncAXINVENTLOCATION(nData);
   cBC_SyncTprGem          : Result := SyncAXTPRESTIGEMANAGE(nData);
   cBC_SyncTprGemCont      : Result := SyncAXTPRESTIGEMBYCONT(nData);
   cBC_SyncEmpTable        : Result := SyncAXEmpTable(nData);
   cBC_SyncInvCenGroup     : Result := SyncAXInvCenGroup(nData);
   cBC_SyncFYBillAX        : Result := SyncStockBillAX(nData);
   cBC_SyncStockBill       : Result := SyncPoundBillAX(nData);
   cBC_SyncStockOrder      : Result := SyncPurPoundBillAX(nData);
   cBC_GetSalesOrder       : Result := GetAXSalesOrder(nData);
   cBC_GetSalesOrdLine     : Result := GetAXSalesOrdLine(nData);
   cBC_GetSupAgreement     : Result := GetAXSupAgreement(nData);
   cBC_GetCreLimCust       : Result := GetAXCreLimCust(nData);
   cBC_GetCreLimCusCont    : Result := GetAXCreLimCusCont(nData);
   cBC_GetSalesCont        : Result := GetAXSalesContract(nData);
   cBC_GetSalesContLine    : Result := GetAXSalesContLine(nData);
   cBC_GetVehicleNo        : Result := GetAXVehicleNo(nData);
   cBC_GetPurOrder         : Result := GetAXPurOrder(nData);
   cBC_GetPurOrdLine       : Result := GetAXPurOrdLine(nData);
   cBC_GetSampleID         : Result := GetSampleID(nData);
   cBC_GetCenterID         : Result := GetCenterID(nData);
   cBC_GetTprGem           : Result := GetAXTPRESTIGEMANAGE(nData);
   cBC_GetTprGemCont       : Result := GetAXTPRESTIGEMBYCONT(nData);
   cBC_SyncDelSBillAX      : Result := SyncDelSBillAX(nData);
   cBC_SyncEmpOutBillAX    : Result := SyncEmptyOutBillAX(nData);
   cBC_GetTriangleTrade    : Result := GetTriangleTrade(nData);
   cBC_GetAXMaCredLmt      : Result := GetAXMaCredLmt(nData);
   cBC_GetAXContQuota      : Result := GetAXContQuota(nData);
   cBC_GetCustNo           : Result := GetCustNo(nData);
   cBC_GetAXCompanyArea    : Result := GetAXCompanyArea(nData);
   cBC_GetAXInVentSum      : Result := GetInVentSum(nData);
   cBC_SyncAXwmsLocation   : Result := SyncAXwmsLocation(nData);
   cBC_GetSalesOrdValue    : Result := GetSalesOrdValue(nData);
   cBC_VerifySnapTruck     : Result := VerifySnapTruck(nData);

   cBC_ReadZhiKaInfo       : Result := ReadZhikaInfo(nData);//��ȡ���۶�����Ϣ
   cBC_ReadStockPrice      : Result := ReadStockPrice(nData);//��ȡ�������ϼ۸�
   cBC_VerifPrintCode      : Result := CheckSecurityCodeValid(nData); //��֤���ѯ
   cBC_WaitingForloading   : Result := GetWaitingForloading(nData); //��װ������ѯ

   cBC_BillSurplusTonnage  : Result := GetBillSurplusTonnage(nData); //��ѯ�̳Ƕ���������
   cBC_GetOrderInfo        : Result := GetOrderInfo(nData); //��ѯ������Ϣ
   cBC_GetOrderList        : Result := GetOrderList(nData); //��ѯ�����б�
   cBC_GetPurchaseContractList : Result := GetPurchaseContractList(nData); //��ѯ�ɹ���ͬ�б�
   
   cBC_WeChat_getCustomerInfo : Result := getCustomerInfo(nData);   //΢��ƽ̨�ӿڣ���ȡ�ͻ�ע����Ϣ
   cBC_WeChat_get_Bindfunc    : Result := get_Bindfunc(nData);   //΢��ƽ̨�ӿڣ��ͻ���΢���˺Ű�
   cBC_WeChat_send_event_msg  : Result := send_event_msg(nData);   //΢��ƽ̨�ӿڣ�������Ϣ
   cBC_WeChat_edit_shopclients : Result := edit_shopclients(nData);   //΢��ƽ̨�ӿڣ������̳��û�
   cBC_WeChat_edit_shopgoods  : Result := edit_shopgoods(nData);   //΢��ƽ̨�ӿڣ������Ʒ

   cBC_WeChat_get_shoporders  : Result := get_shoporders(nData);   //΢��ƽ̨�ӿڣ���ȡ������Ϣ
   cBC_WeChat_complete_shoporders  : Result := complete_shoporders(nData);   //΢��ƽ̨�ӿڣ��޸Ķ���״̬
   cBC_WeChat_get_shoporderbyno : Result := get_shoporderbyno(nData);   //΢��ƽ̨�ӿڣ����ݶ����Ż�ȡ������Ϣ(����)
   cBC_WeChat_get_shopPurchasebyNO : Result := get_shopPurchasebyNO(nData);//΢��ƽ̨�ӿڣ����ݶ����Ż�ȡ������Ϣ(�ɹ�)

   cBC_WeChat_InOutFactoryTotal : Result := GetInOutFactoryTatol(nData);//����������ѯ���ɹ������������۳�������
   {$ENDIF}
   else
    begin
      Result := False;
      nData := '��Ч��ҵ�����(Invalid Command).';
    end;
  end;
end;

//Date: 2014-09-05
//Desc: ��ȡ��Ƭ���ͣ�����S;�ɹ�P;����O
function TWorkerBusinessCommander.GetCardUsed(var nData: string): Boolean;
var nStr: string;
begin
  Result := False;

  nStr := 'Select C_Used From %s Where C_Card=''%s'' ' +
          'or C_Card3=''%s'' or C_Card2=''%s''';
  nStr := Format(nStr, [sTable_Card, FIn.FData, FIn.FData, FIn.FData]);
  //card status

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount<1 then Exit;

    FOut.FData := Fields[0].AsString;
    Result := True;
  end;
end;

function TWorkerBusinessOrders.GetCardUsed(const nCard: string;var nCardType: string): Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := TWorkerBusinessCommander.Callme(cBC_GetCardUsed, nCard, '', @nOut);

  if Result then
       nCardType := nOut.FData
  else gSysLoger.AddLog(TBusinessWorkerManager, 'ҵ�����', nOut.FData);
  //xxxxx
end;

//------------------------------------------------------------------------------
//Date: 2015/9/9
//Parm: �û��������룻�����û�����
//Desc: �û���¼
function TWorkerBusinessCommander.Login(var nData: string): Boolean;
var nStr: string;
begin
  Result := False;

  FListA.Clear;
  FListA.Text := PackerDecodeStr(FIn.FData);
  if FListA.Values['User']='' then Exit;
  //δ�����û���

  nStr := 'Select U_Password From %s Where U_Name=''%s''';
  nStr := Format(nStr, [sTable_User, FListA.Values['User']]);
  //card status

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount<1 then Exit;

    nStr := Fields[0].AsString;
    if nStr<>FListA.Values['Password'] then Exit;
    {
    if CallMe(cBC_ServerNow, '', '', @nOut) then
         nStr := PackerEncodeStr(nOut.FData)
    else nStr := IntToStr(Random(999999));

    nInfo := FListA.Values['User'] + nStr;
    //xxxxx

    nStr := 'Insert into $EI(I_Group, I_ItemID, I_Item, I_Info) ' +
            'Values(''$Group'', ''$ItemID'', ''$Item'', ''$Info'')';
    nStr := MacroValue(nStr, [MI('$EI', sTable_ExtInfo),
            MI('$Group', sFlag_UserLogItem), MI('$ItemID', FListA.Values['User']),
            MI('$Item', PackerEncodeStr(FListA.Values['Password'])),
            MI('$Info', nInfo)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);  }

    Result := True;
  end;
end;
//------------------------------------------------------------------------------
//Date: 2015/9/9
//Parm: �û�������֤����
//Desc: �û�ע��
function TWorkerBusinessCommander.LogOut(var nData: string): Boolean;
//var nStr: string;
begin
  {nStr := 'delete From %s Where I_ItemID=''%s''';
  nStr := Format(nStr, [sTable_ExtInfo, PackerDecodeStr(FIn.FData)]);
  //card status

  
  if gDBConnManager.WorkerExec(FDBConn, nStr)<1 then
       Result := False
  else Result := True;     }

  Result := True;
end;

//Date: 2014-09-05
//Desc: ��ȡ��������ǰʱ��
function TWorkerBusinessCommander.GetServerNow(var nData: string): Boolean;
var nStr: string;
begin
  nStr := 'Select ' + sField_SQLServer_Now;
  //sql

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    FOut.FData := DateTime2Str(Fields[0].AsDateTime);
    Result := True;
  end;
end;

//Date: 2012-3-25
//Desc: �������������б��
function TWorkerBusinessCommander.GetSerailID(var nData: string): Boolean;
var nInt: Integer;
    nStr,nP,nB: string;
begin
  FDBConn.FConn.BeginTrans;
  try
    Result := False;
    FListA.Text := FIn.FData;
    //param list

    nStr := 'Update %s Set B_Base=B_Base+1 ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sTable_SerialBase, FListA.Values['Group'],
            FListA.Values['Object']]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Select B_Prefix,B_IDLen,B_Base,B_Date,%s as B_Now From %s ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sField_SQLServer_Now, sTable_SerialBase,
            FListA.Values['Group'], FListA.Values['Object']]);
    //xxxxx

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := 'û��[ %s.%s ]�ı�������.';
        nData := Format(nData, [FListA.Values['Group'], FListA.Values['Object']]);

        FDBConn.FConn.RollbackTrans;
        Exit;
      end;

      nP := FieldByName('B_Prefix').AsString;
      nB := FieldByName('B_Base').AsString;
      nInt := FieldByName('B_IDLen').AsInteger;

      if FIn.FExtParam = sFlag_Yes then //�����ڱ���
      begin
        nStr := Date2Str(FieldByName('B_Date').AsDateTime, False);
        //old date

        if (nStr <> Date2Str(FieldByName('B_Now').AsDateTime, False)) and
           (FieldByName('B_Now').AsDateTime > FieldByName('B_Date').AsDateTime) then
        begin
          nStr := 'Update %s Set B_Base=1,B_Date=%s ' +
                  'Where B_Group=''%s'' And B_Object=''%s''';
          nStr := Format(nStr, [sTable_SerialBase, sField_SQLServer_Now,
                  FListA.Values['Group'], FListA.Values['Object']]);
          gDBConnManager.WorkerExec(FDBConn, nStr);

          nB := '1';
          nStr := Date2Str(FieldByName('B_Now').AsDateTime, False);
          //now date
        end;

        System.Delete(nStr, 1, 2);
        //yymmdd
        nInt := nInt - Length(nP) - Length(nStr) - Length(nB);
        FOut.FData := nP + nStr + StringOfChar('0', nInt) + nB;
      end else
      begin
        nInt := nInt - Length(nP) - Length(nB);
        nStr := StringOfChar('0', nInt);
        FOut.FData := nP + nStr + nB;
      end;
    end;

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-05
//Desc: ��֤ϵͳ�Ƿ��ѹ���
function TWorkerBusinessCommander.IsSystemExpired(var nData: string): Boolean;
var nStr: string;
    nDate: TDate;
    nInt: Integer;
begin
  nDate := Date();
  //server now

  nStr := 'Select D_Value,D_ParamB From %s ' +
          'Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_ValidDate]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nStr := 'dmzn_stock_' + Fields[0].AsString;
    nStr := MD5Print(MD5String(nStr));

    if nStr = Fields[1].AsString then
      nDate := Str2Date(Fields[0].AsString);
    //xxxxx
  end;

  nInt := Trunc(nDate - Date());
  Result := nInt > 0;

  if nInt <= 0 then
  begin
    nStr := 'ϵͳ�ѹ��� %d ��,����ϵ����Ա!!';
    nData := Format(nStr, [-nInt]);
    Exit;
  end;

  FOut.FData := IntToStr(nInt);
  //last days

  if nInt <= 7 then
  begin
    nStr := Format('ϵͳ�� %d ������', [nInt]);
    FOut.FBase.FErrDesc := nStr;
    FOut.FBase.FErrCode := sFlag_ForceHint;
  end;
end;

{$IFDEF COMMON}
//2016-08-27
//��֤�ͻ��Ƿ�ǿ�����ö��
function TWorkerBusinessCommander.CustomerMaCredLmt(var nData: string): Boolean;
var
  nStr:string;
begin
  nStr := 'Select C_Name,C_MaCredLmt From %s Where C_ID=''%s''';
  nStr := Format(nStr, [sTable_Customer, FIn.FData]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
    begin
      if Fields[1].AsString='0' then //���������ö��
      begin
        FOut.FData := sFlag_No;
      end else
      begin
        FOut.FData := sFlag_Yes;
      end;
    end else
    begin
      FOut.FExtParam := '��ɾ��';
    end;
  end;
  Result:=True;
end;

//Date: 2014-09-05
//Desc: ��ȡָ���ͻ��Ŀ��ý��
function TWorkerBusinessCommander.GetCustomerValidMoney(var nData: string): Boolean;
var nStr: string;
    nVal,nCredit: Double;
    nContractId: string;
    nAXMoney: Double;
    nContQuota: string;//1 ר��ר��
    nCusID:string;
    nFailureDate: TDateTime;
begin
  nStr := 'Select zk.Z_Customer,sc.C_ID,sc.C_ContQuota From $ZK zk,$SC sc ' +
          'Where zk.Z_ID=''$CID'' and zk.Z_CID=sc.C_ID';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$CID', FIn.FData),
          MI('$SC', sTable_SaleContract)]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    nCusID:=FieldByName('Z_Customer').AsString;
    nContQuota:= FieldByName('C_ContQuota').AsString;
    if nContQuota ='1' then
    begin
      nContractId:=FieldByName('C_ID').AsString;
      nStr := 'Select cc.* From $ZK,$CC cc ' +
              'Where Z_ID=''$CID'' and Z_Customer=C_CusID and C_ContractId=''$TID'' ';
      nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$CID', FIn.FData),
              MI('$CC', sTable_CusContCredit), MI('$TID', nContractId)]);
    end else
    begin
      nStr := 'Select cc.* From $ZK,$CC cc ' +
              'Where Z_ID=''$CID'' and Z_Customer=C_CusID';
      nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$CID', FIn.FData),
              MI('$CC', sTable_CusCredit)]);
    end;
  end;
  
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount <1 then
    begin
      nAXMoney:=0;
    end else
    begin
      nFailureDate := FieldByName('C_FailureDate').AsDateTime;
      if (FieldByName('C_FailureDate').IsNull) or
        (FieldByName('C_FailureDate').AsString='') or
        (formatdatetime('yyyy-mm-dd',nFailureDate)='1900-01-01') then
      begin
        nAXMoney:= FieldByName('C_CashBalance').AsFloat+
                     FieldByName('C_BillBalance3M').AsFloat+
                     FieldByName('C_BillBalance6M').AsFloat-
                     FieldByName('C_PrestigeQuota').AsFloat;
      end else
      begin
        nFailureDate := StrToDateTime(formatdatetime('yyyy-mm-dd',nFailureDate)+' 23:59:59');
        if nFailureDate >= Now then
        begin
          nAXMoney:= FieldByName('C_CashBalance').AsFloat+
                     FieldByName('C_BillBalance3M').AsFloat+
                     FieldByName('C_BillBalance6M').AsFloat+
                     FieldByName('C_TemporBalance').AsFloat-
                     FieldByName('C_PrestigeQuota').AsFloat;
        end else
        begin
          nAXMoney:= FieldByName('C_CashBalance').AsFloat+
                     FieldByName('C_BillBalance3M').AsFloat+
                     FieldByName('C_BillBalance6M').AsFloat-
                     FieldByName('C_PrestigeQuota').AsFloat;
        end;
      end;
    end;
  end;


  nStr := 'Select * From %s Where A_CID=''%s''';
  nStr := Format(nStr, [sTable_CusAccount, nCusID]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '���Ϊ[ %s ]�Ŀͻ��˻�������.';
      nData := Format(nData, [FIn.FData]);

      Result := False;
      Exit;
    end;
    if nContQuota ='1' then
    begin
      nVal := nAXMoney-FieldByName('A_ConFreezeMoney').AsFloat
    end else
    begin
      nVal := nAXMoney-FieldByName('A_FreezeMoney').AsFloat;
    end;
    //xxxxx

    nCredit := FieldByName('A_CreditLimit').AsFloat;
    nCredit := Float2PInt(nCredit, cPrecision, False) / cPrecision;

    if FIn.FExtParam = sFlag_Yes then
      nVal := nVal + nCredit;
    nVal := Float2PInt(nVal, cPrecision, False) / cPrecision;

    FOut.FData := FloatToStr(nVal);
    FOut.FExtParam := FloatToStr(nCredit);
    Result := True;
  end;
end;
{$ENDIF}

{$IFDEF COMMON}
//Date: 2014-09-05
//Desc: ��ȡָ��ֽ���Ŀ��ý��
function TWorkerBusinessCommander.GetZhiKaValidMoney(var nData: string): Boolean;
var nStr: string;
    nVal,nMoney: Double;
begin
  nStr := 'Select ca.*,Z_OnlyMoney,Z_FixedMoney From $ZK,$CA ca ' +
          'Where Z_ID=''$ZID'' and A_CID=Z_Customer';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$ZID', FIn.FData),
          MI('$CA', sTable_CusAccount)]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '���Ϊ[ %s ]��ֽ��������,��ͻ��˻���Ч.';
      nData := Format(nData, [FIn.FData]);

      Result := False;
      Exit;
    end;

    FOut.FExtParam := FieldByName('Z_OnlyMoney').AsString;
    nMoney := FieldByName('Z_FixedMoney').AsFloat;

    nVal := FieldByName('A_InMoney').AsFloat -
            FieldByName('A_OutMoney').AsFloat -
            FieldByName('A_Compensation').AsFloat -
            FieldByName('A_FreezeMoney').AsFloat +
            FieldByName('A_CreditLimit').AsFloat;
    nVal := Float2PInt(nVal, cPrecision, False) / cPrecision;

    if FOut.FExtParam = sFlag_Yes then
    begin
      if nMoney > nVal then
        nMoney := nVal;
      //enough money
    end else nMoney := nVal;

    FOut.FData := FloatToStr(nMoney);
    Result := True;
  end;
end;
{$ENDIF}

//Date: 2014-09-05
//Desc: ��֤�ͻ��Ƿ���Ǯ,�Լ������Ƿ����
function TWorkerBusinessCommander.CustomerHasMoney(var nData: string): Boolean;
var nStr,nName: string;
    nM,nC: Double;
begin
  Result:=CustomerMaCredLmt(nData);
  if not Result then Exit;
  if FOut.FData = sFlag_No then
  begin
    FOut.FData := sFlag_Yes;
    Exit;
  end;
  FIn.FExtParam := sFlag_No;
  Result := GetCustomerValidMoney(nData);
  if not Result then Exit;

  nM := StrToFloat(FOut.FData);
  FOut.FData := sFlag_Yes;
  if nM > 0 then Exit;

  nC := StrToFloat(FOut.FExtParam);
  if (nC <= 0) or (nC + nM <= 0) then
  begin
    nData := Format('�ͻ�[ %s ]���ʽ�����.', [nName]);
    Result := False;
    Exit;
  end;

  nStr := 'Select MAX(C_End) From %s Where C_CusID=''%s'' and C_Money>=0';
  nStr := Format(nStr, [sTable_CusCredit, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if (Fields[0].AsDateTime > Str2Date('2000-01-01')) and
     (Fields[0].AsDateTime < Date()) then
  begin
    nData := Format('�ͻ�[ %s ]�������ѹ���.', [nName]);
    Result := False;
  end;
end;

//Date: 2014-10-02
//Parm: ���ƺ�[FIn.FData];
//Desc: ���泵����sTable_Truck��
function TWorkerBusinessCommander.SaveTruck(var nData: string): Boolean;
var nStr: string;
begin
  Result := True;
  FIn.FData := UpperCase(FIn.FData);
  
  nStr := 'Select Count(*) From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, FIn.FData]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if Fields[0].AsInteger < 1 then
  begin
    nStr := 'Insert Into %s(T_Truck, T_PY) Values(''%s'', ''%s'')';
    nStr := Format(nStr, [sTable_Truck, FIn.FData, GetPinYinOfStr(FIn.FData)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
  end;
end;

//Date: 2016-02-16
//Parm: ���ƺ�(Truck); ���ֶ���(Field);����ֵ(Value)
//Desc: ���³�����Ϣ��sTable_Truck��
function TWorkerBusinessCommander.UpdateTruck(var nData: string): Boolean;
var nStr: string;
    nValInt: Integer;
    nValFloat: Double;
begin
  Result := True;
  FListA.Text := FIn.FData;

  if FListA.Values['Field'] = 'T_PValue' then
  begin
    nStr := 'Select T_PValue, T_PTime From %s Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, FListA.Values['Truck']]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      nValInt := Fields[1].AsInteger;
      nValFloat := Fields[0].AsFloat;
    end else Exit;

    nValFloat := nValFloat * nValInt + StrToFloatDef(FListA.Values['Value'], 0);
    nValFloat := nValFloat / (nValInt + 1);
    nValFloat := Float2Float(nValFloat, cPrecision);

    nStr := 'Update %s Set T_PValue=%.2f, T_PTime=T_PTime+1 Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_Truck, nValFloat, FListA.Values['Truck']]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
  end;
end;

//Date: 2014-09-25
//Parm: ���ƺ�[FIn.FData]
//Desc: ��ȡָ�����ƺŵĳ�Ƥ����(ʹ�����ģʽ,δ����)
function TWorkerBusinessCommander.GetTruckPoundData(var nData: string): Boolean;
var nStr: string;
    nPound: TLadingBillItems;
begin
  SetLength(nPound, 1);
  FillChar(nPound[0], SizeOf(TLadingBillItem), #0);

  nStr := 'Select * From %s Where P_Truck=''%s'' And ' +
          'P_MValue Is Null And P_PModel=''%s''';
  nStr := Format(nStr, [sTable_PoundLog, FIn.FData, sFlag_PoundPD]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr),nPound[0] do
  begin
    if RecordCount > 0 then
    begin
      FCusID      := FieldByName('P_CusID').AsString;
      FCusName    := FieldByName('P_CusName').AsString;
      FTruck      := FieldByName('P_Truck').AsString;

      FType       := FieldByName('P_MType').AsString;
      FStockNo    := FieldByName('P_MID').AsString;
      FStockName  := FieldByName('P_MName').AsString;

      with FPData do
      begin
        FStation  := FieldByName('P_PStation').AsString;
        FValue    := FieldByName('P_PValue').AsFloat;
        FDate     := FieldByName('P_PDate').AsDateTime;
        FOperator := FieldByName('P_PMan').AsString;
      end;  

      FFactory    := FieldByName('P_FactID').AsString;
      FPModel     := FieldByName('P_PModel').AsString;
      FPType      := FieldByName('P_Type').AsString;
      FPoundID    := FieldByName('P_ID').AsString;

      FStatus     := sFlag_TruckBFP;
      FNextStatus := sFlag_TruckBFM;
      FSelected   := True;
    end else
    begin
      FTruck      := FIn.FData;
      FPModel     := sFlag_PoundPD;

      FStatus     := '';
      FNextStatus := sFlag_TruckBFP;
      FSelected   := True;
    end;
  end;

  FOut.FData := CombineBillItmes(nPound);
  Result := True;
end;

//Date: 2014-09-25
//Parm: ��������[FIn.FData]
//Desc: ��ȡָ�����ƺŵĳ�Ƥ����(ʹ�����ģʽ,δ����)
function TWorkerBusinessCommander.SaveTruckPoundData(var nData: string): Boolean;
var nStr,nSQL: string;
    nPound: TLadingBillItems;
    nOut: TWorkerBusinessCommand;
begin
  AnalyseBillItems(FIn.FData, nPound);
  //��������

  with nPound[0] do
  begin
    if FPoundID = '' then
    begin
      TWorkerBusinessCommander.CallMe(cBC_SaveTruckInfo, FTruck, '', @nOut);
      //���泵�ƺ�

      FListC.Clear;
      FListC.Values['Group'] := sFlag_BusGroup;
      FListC.Values['Object'] := sFlag_PoundID;

      if not CallMe(cBC_GetSerialNO,
            FListC.Text, sFlag_Yes, @nOut) then
        raise Exception.Create(nOut.FData);
      //xxxxx
      FPoundID := nOut.FData;
      //new id

      if FPModel = sFlag_PoundLS then
           nStr := sFlag_Other
      else nStr := sFlag_Provide;

      nSQL := MakeSQLByStr([
              SF('P_ID', FPoundID),
              SF('P_Type', nStr),
              SF('P_Truck', FTruck),
              SF('P_CusID', FCusID),
              SF('P_CusName', FCusName),
              SF('P_MID', FStockNo),
              SF('P_MName', FStockName),
              SF('P_MType', sFlag_San),
              SF('P_PValue', FPData.FValue, sfVal),
              SF('P_PDate', sField_SQLServer_Now, sfVal),
              SF('P_PMan', FIn.FBase.FFrom.FUser),
              SF('P_FactID', FFactory),
              SF('P_PStation', FPData.FStation),
              SF('P_Direction', '����'),
              SF('P_PModel', FPModel),
              SF('P_Status', sFlag_TruckBFP),
              SF('P_Valid', sFlag_Yes),
              SF('P_PrintNum', 1, sfVal)
              ], sTable_PoundLog, '', True);
      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end else
    begin
      nStr := SF('P_ID', FPoundID);
      //where

      if FNextStatus = sFlag_TruckBFP then
      begin
        nSQL := MakeSQLByStr([
                SF('P_PValue', FPData.FValue, sfVal),
                SF('P_PDate', sField_SQLServer_Now, sfVal),
                SF('P_PMan', FIn.FBase.FFrom.FUser),
                SF('P_PStation', FPData.FStation),
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', DateTime2Str(FMData.FDate)),
                SF('P_MMan', FMData.FOperator),
                SF('P_MStation', FMData.FStation)
                ], sTable_PoundLog, nStr, False);
        //����ʱ,����Ƥ�ش�,����Ƥë������
      end
      else if FNextStatus = sFlag_TruckBFM then begin
         nSQL := MakeSQLByStr([
          SF('P_PValue', FPData.FValue, sfVal),
          SF('P_PDate', DateTime2Str(FPData.Fdate)),
          SF('P_PMan', FPData.FOperator),
          SF('P_PStation', FPData.FStation),
          SF('P_MValue', FMData.FValue, sfVal),
          SF('P_MDate', sField_SQLServer_Now, sfVal),
          SF('P_MMan', FMData.FOperator),
          SF('P_MStation', FMData.FStation)
          ], sTable_PoundLog, nStr, False);
         //xxxxx
      end;

      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end;

    FOut.FData := FPoundID;
    Result := True;
  end;
end;

{$IFDEF XAZL}
//Date: 2014-10-14
//Desc: ͬ���°�����ԭ�������ݵ�DLϵͳ
function TWorkerBusinessCommander.SyncRemoteMaterails(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nStr := 'Select FItemID,FName,FNumber From t_ICItem ';// +
            //'Where (FFullName like ''%%ԭ����_��Ҫ����%%'') or ' +
            //'(FFullName like ''%%ԭ����_ȼ��%%'')';
    //xxxxx

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_K3) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := MakeSQLByStr([SF('M_ID', Fields[0].AsString),
                SF('M_Name', Fields[1].AsString),
                SF('M_PY', GetPinYinOfStr(Fields[1].AsString)),
                SF('M_Memo', GetPinYinOfStr(Fields[2].AsString))
                ], sTable_Materails, '', True);
        //xxxxx

        FListA.Add(nStr);
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    nStr := 'Delete From ' + sTable_Materails;
    gDBConnManager.WorkerExec(FDBConn, nStr);

    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;
{$ENDIF}
{$IFDEF QLS}
//Date:2016-06-26
//ͬ��AX�ͻ���Ϣ��DL
function TWorkerBusinessCommander.SyncAXCustomer(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  FListB.Clear;
  FListC.Clear;
  FListD.Clear;
  FListE.Clear;
  Result := True;

  nDBWorker := nil;
  try
    if FIn.FData='' then
    begin
      nStr := 'Select AccountNum,Name,CreditMax,MandatoryCreditLimit,' +
              'CMT_KHYH,CMT_KHZH '+
              'From %s where DataAreaID=''%s'' ';
      nStr := Format(nStr, [sTable_AX_Cust, gCompanyAct]);
    end else
    begin
      nStr := 'Select AccountNum,Name,CreditMax,MandatoryCreditLimit,' +
              'CMT_KHYH,CMT_KHZH '+
              'From %s where AccountNum=''%s'' and DataAreaID=''%s'' ';
      nStr := Format(nStr, [sTable_AX_Cust, FIn.FData, FIn.FExtParam]);
    end;
    //xxxxx

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      try
        nStr := MakeSQLByStr([SF('C_ID', FieldByName('AccountNum').AsString),
                SF('C_Name', FieldByName('Name').AsString),
                SF('C_PY', GetPinYinOfStr(FieldByName('Name').AsString)),
                SF('C_CredMax', FieldByName('CreditMax').AsString),
                SF('C_MaCredLmt', FieldByName('MandatoryCreditLimit').AsString),
                SF('C_Bank', FieldByName('CMT_KHYH').AsString),
                SF('C_Account', FieldByName('CMT_KHZH').AsString),
                SF('C_XuNi', sFlag_No)
                ], sTable_Customer, '', True);
        FListA.Add(nStr);
        nStr := MakeSQLByStr([SF('A_CID', FieldByName('AccountNum').AsString),
                SF('A_Date', sField_SQLServer_Now, sfVal)
                ], sTable_CusAccount, '', True);
        FListB.Add(nStr);

        nStr := SF('C_ID', FieldByName('AccountNum').AsString);
        nStr := MakeSQLByStr([
                SF('C_Name', FieldByName('Name').AsString),
                SF('C_PY', GetPinYinOfStr(FieldByName('Name').AsString)),
                SF('C_CredMax', FieldByName('CreditMax').AsString),
                SF('C_MaCredLmt', FieldByName('MandatoryCreditLimit').AsString),
                SF('C_Bank', FieldByName('CMT_KHYH').AsString),
                SF('C_Account', FieldByName('CMT_KHZH').AsString)
                ], sTable_Customer, nStr, False);
        FListC.Add(nStr);

        nStr:='select * from %s where C_ID=''%s'' ';
        nStr := Format(nStr, [sTable_Customer, FieldByName('AccountNum').AsString]);
        FListD.Add(nStr);
        nStr:='select * from %s where A_CID=''%s'' ';
        nStr := Format(nStr, [sTable_CusAccount, FieldByName('AccountNum').AsString]);
        FListE.Add(nStr);
      finally
        Next;
      end;
    end else
    begin
      Result:=False;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if (FListD.Count > 0) then
  try
    FDBConn.FConn.BeginTrans;
    //��������
    for nIdx:=0 to FListD.Count - 1 do
    begin
      with gDBConnManager.WorkerQuery(FDBConn,FListD[nIdx]) do
      begin
        if RecordCount>0 then
        begin
          gDBConnManager.WorkerExec(FDBConn,FListC[nIdx]);
        end else
        begin
          gDBConnManager.WorkerExec(FDBConn,FListA[nIdx]);
        end;
      end;
    end;
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
  if (FListE.Count > 0) then
  try
    FDBConn.FConn.BeginTrans;
    //��������
    for nIdx:=0 to FListE.Count - 1 do
    begin
      with gDBConnManager.WorkerQuery(FDBConn,FListE[nIdx]) do
      begin
        if RecordCount<1 then
        begin
          gDBConnManager.WorkerExec(FDBConn,FListB[nIdx]);
        end;
      end;
    end;
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date:2016-6-26
//ͬ��AX��Ӧ����Ϣ��DL
function TWorkerBusinessCommander.SyncAXProviders(var nData: string): Boolean;
var nStr,nSaler: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nSaler := '������ҵ��Ա';
    nStr := 'Select AccountNum,Name From %s where DataAreaID=''%s'' ';
    nStr := Format(nStr, [sTable_AX_VEND, gCompanyAct]);
    //δɾ����Ӧ��

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := MakeSQLByStr([SF('P_ID', Fields[0].AsString),
                SF('P_Name', Fields[1].AsString),
                SF('P_PY', GetPinYinOfStr(Fields[1].AsString)),
                SF('P_Saler', nSaler)
                ], sTable_Provider, '', True);
        //xxxxx

        FListA.Add(nStr);
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    //��������

    nStr := 'truncate table ' + sTable_Provider;
    gDBConnManager.WorkerExec(FDBConn, nStr);

    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date:2016-06-26
//ͬ��AXԭ������Ϣ��DL
function TWorkerBusinessCommander.SyncAXINVENT(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  FListB.Clear;
  FListC.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nStr := 'Select ItemId,ItemName,ItemGroupId,Weighning From %s '+
            'where DataAreaID=''%s'' and Weighning=''1'' ';
    nStr := Format(nStr, [sTable_AX_INVENT, gCompanyAct]);
    //xxxxx

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := MakeSQLByStr([SF('M_ID', Fields[0].AsString),
                SF('M_Name', Fields[1].AsString),
                SF('M_PY', GetPinYinOfStr(Fields[1].AsString)),
                SF('M_GroupID', Fields[2].AsString),
                SF('M_Weighning', Fields[3].AsString)
                ], sTable_Materails, '', True);
        //xxxxx
        FListA.Add(nStr);
        
        nStr:='select * from %s where M_ID=''%s'' ';
        nStr := Format(nStr, [sTable_Materails, Fields[0].AsString]);
        FListB.Add(nStr);

        nStr := SF('M_ID', Fields[0].AsString);
        nStr := MakeSQLByStr([SF('M_Name', Fields[1].AsString),
                SF('M_PY', GetPinYinOfStr(Fields[1].AsString)),
                SF('M_GroupID', Fields[2].AsString),
                SF('M_Weighning', Fields[3].AsString)
                ], sTable_Materails, nStr, False);
        //xxxxx
        FListC.Add(nStr);
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  try
    FDBConn.FConn.BeginTrans;

    for nIdx:=0 to FListB.Count - 1 do
    begin
      with gDBConnManager.WorkerQuery(FDBConn,FListB[nIdx]) do
      begin
        if RecordCount>0 then
        begin
          gDBConnManager.WorkerExec(FDBConn, FListC[nIdx]);
        end else
        begin
          gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
        end;
      end;
    end;
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;
//Date:2016-06-26
//ͬ��AXˮ����Ϣ��DL
function TWorkerBusinessCommander.SyncAXCement(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  FListB.Clear;
  FListC.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nStr := 'Select ItemId,ItemName,ItemGroupId From %s where DataAreaID=''%s'' and ((ITEMGROUPID = ''C01'') or (ITEMGROUPID = ''C02'')) ';
    nStr := Format(nStr, [sTable_AX_INVENT, gCompanyAct]);
    //xxxxx

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := MakeSQLByStr([SF('D_Name', 'StockItem'),
                SF('D_ParamB', Fields[0].AsString),
                SF('D_Value', Fields[1].AsString+'��װ'),
                SF('D_Desc', Fields[2].AsString),
                SF('D_Memo', 'D')
                ], sTable_SysDict, '', True);
        //xxxxx
        FListA.Add(nStr);

        nStr := MakeSQLByStr([SF('D_Name', 'StockItem'),
                SF('D_ParamB', Fields[0].AsString),
                SF('D_Value', Fields[1].AsString+'ɢװ'),
                SF('D_Desc', Fields[2].AsString),
                SF('D_Memo', 'S')
                ], sTable_SysDict, '', True);
        //xxxxx
        FListA.Add(nStr);

        nStr:='select * from %s where D_Name=''StockItem'' and D_Memo=''D'' and D_ParamB=''%s'' ';
        nStr := Format(nStr, [sTable_SysDict, Fields[0].AsString]);
        FListB.Add(nStr);

        nStr:='select * from %s where D_Name=''StockItem'' and D_Memo=''S'' and D_ParamB=''%s'' ';
        nStr := Format(nStr, [sTable_SysDict, Fields[0].AsString]);
        FListB.Add(nStr);

        nStr := SF('D_Name', 'StockItem')+' and '+SF('D_Memo', 'D')+' and '+SF('D_ParamB', Fields[0].AsString);
        nStr := MakeSQLByStr([SF('D_Value', Fields[1].AsString+'��װ'),
                SF('D_Desc', Fields[2].AsString)
                ], sTable_SysDict, nStr, False);
        //xxxxx
        FListC.Add(nStr);

        nStr := SF('D_Name', 'StockItem')+' and '+SF('D_Memo', 'S')+' and '+SF('D_ParamB', Fields[0].AsString);
        nStr := MakeSQLByStr([SF('D_Value', Fields[1].AsString+'ɢװ'),
                SF('D_Desc', Fields[2].AsString)
                ], sTable_SysDict, nStr, False);
        //xxxxx
        FListC.Add(nStr);

        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListB.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;

    for nIdx:=0 to FListB.Count - 1 do
    begin
      with gDBConnManager.WorkerQuery(FDBConn,FListB[nIdx]) do
      begin
        if RecordCount>0 then
        begin
          gDBConnManager.WorkerExec(FDBConn, FListC[nIdx]);
        end else
        begin
          gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
        end;
      end;
    end;
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date:2016-06-26
//ͬ��AXά����Ϣ��DL
function TWorkerBusinessCommander.SyncAXINVENTDIM(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nStr := 'Select INVENTDIMID,INVENTBATCHID,WMSLOCATIONID,INVENTSERIALID,'+
            'INVENTLOCATIONID,DATAAREAID,RECVERSION,RECID,XTINVENTCENTERID '+
            'From %s where DataAreaID=''%s'' ';
    nStr := Format(nStr, [sTable_AX_INVENTDIM, gCompanyAct]);
    //xxxxx

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := MakeSQLByStr([SF('I_DimID', Fields[0].AsString),
                SF('I_BatchID', Fields[1].AsString),
                SF('I_WMSLocationID', Fields[2].AsString),
                SF('I_SerialID', Fields[3].AsString),
                SF('I_LocationID', Fields[4].AsString),
                SF('I_DatareaID', Fields[5].AsString),
                SF('I_RecVersion', Fields[6].AsString),
                SF('I_RECID', Fields[7].AsString),
                SF('I_CenterID', Fields[8].AsString)
                ], sTable_InventDim, '', True);
        //xxxxx

        FListA.Add(nStr);
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    nStr := 'truncate table ' + sTable_InventDim;
    gDBConnManager.WorkerExec(FDBConn, nStr);

    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date:2016-06-26
//ͬ��AX�����߻�����Ϣ��DL
function TWorkerBusinessCommander.SyncAXTINVENTCENTER(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nStr := 'Select InventCenterId,Name From %s where DataAreaID=''%s'' ';
    nStr := Format(nStr, [sTable_AX_INVENTCENTER, gCompanyAct]);
    //xxxxx

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := MakeSQLByStr([SF('I_CenterID', Fields[0].AsString),
                SF('I_Name', Fields[1].AsString),
                SF('I_DataReaID', gCompanyAct)
                ], sTable_InventCenter, '', True);
        //xxxxx

        FListA.Add(nStr);
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    nStr := 'truncate table ' + sTable_InventCenter;
    gDBConnManager.WorkerExec(FDBConn, nStr);

    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date:2016-06-26
//ͬ��AX�ֿ������Ϣ��DL
function TWorkerBusinessCommander.SyncAXINVENTLOCATION(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nStr := 'Select INVENTLOCATIONID,Name,DataAreaID From %s where DataAreaID=''%s'' ';
    nStr := Format(nStr, [sTable_AX_INVENTLOCATION, gCompanyAct]);
    //xxxxx

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := MakeSQLByStr([SF('I_LocationID', Fields[0].AsString),
                SF('I_Name', Fields[1].AsString),
                SF('I_DataReaID', Fields[2].AsString)
                ], sTable_InventLocation, '', True);
        //xxxxx

        FListA.Add(nStr);
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    nStr := 'truncate table ' + sTable_InventLocation;
    gDBConnManager.WorkerExec(FDBConn, nStr);

    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date:2016-06-26
//ͬ��AX���ö�ȣ��ͻ�����Ϣ��DL
function TWorkerBusinessCommander.SyncAXTPRESTIGEMANAGE(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  Result := True;
  FListA.Clear;
  nDBWorker := nil;
  try
    nStr := 'Select CustAccount,CustName,CashBalance,BillBalanceThreeMonths,'+
            'BillBalancesixMonths,PrestigeQuota,TemporaryBalance,TemporaryAmount,'+
            'WarningAmount,TemporaryTakeEffect,FailureDate,XTETempCreditNum,'+
            'XTFixedPrestigeStatus,YKAMOUNT From %s '+
            'where DataAreaID=''%s'' ';
    nStr := Format(nStr, [sTable_AX_TPRESTIGEMANAGE, gCompanyAct]);
    //xxxxx
    //WriteLog(nStr);
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := MakeSQLByStr([SF('C_CusID', Fields[0].AsString),
                SF('C_Date', sField_SQLServer_Now, sfVal),
                SF('C_CustName', Fields[1].AsString),
                SF('C_CashBalance', Fields[2].AsString),
                SF('C_BillBalance3M', Fields[3].AsString),
                SF('C_BillBalance6M', Fields[4].AsString),
                SF('C_PrestigeQuota', Fields[5].AsString),
                SF('C_TemporBalance', Fields[6].AsString),
                SF('C_TemporAmount', Fields[7].AsString),
                SF('C_WarningAmount', Fields[8].AsString),
                SF('C_TemporTakeEffect', Fields[9].AsString),
                SF('C_FailureDate', Fields[10].AsString),
                SF('C_LSCreditNum', Fields[11].AsString),
                SF('C_PrestigeStatus', Fields[12].AsString),
                SF('DataAreaID', gCompanyAct)
                ], sTable_CusCredit, '', True);
        //xxxxx

        FListA.Add(nStr);
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    nStr := 'truncate table ' + sTable_CusCredit;
    gDBConnManager.WorkerExec(FDBConn, nStr);
    
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
    //Result:=False;
  end;
  FOut.FData:=sFlag_Yes;
end;

//lih 2016-09-23
//���ض������л�ȡ�Ƿ�����ó��
function TWorkerBusinessCommander.GetTriangleTrade(var nData: string):Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select Z_TriangleTrade From $ZK Where Z_ID=''$ZID''';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$ZID', FIn.FData)]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '���Ϊ[ %s ]�����۶���������.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
    if FieldByName('Z_TriangleTrade').AsString='1' then
      FOut.FData := sFlag_Yes
    else
      FOut.FData := sFlag_No;
    Result:=True;
  end;
end;

//lih 2016-09-23
//��ȡ���տͻ�ID�͹�˾ID
function TWorkerBusinessCommander.GetCustNo(var nData: string):Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select Z_OrgAccountNum,Z_CompanyId,DataAreaID From $ZK Where Z_ID=''$ZID''';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$ZID', FIn.FData)]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '���Ϊ[ %s ]�����۶���������.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
    FOut.FData := FieldByName('Z_OrgAccountNum').AsString;
    if FieldByName('Z_CompanyId').AsString <> '' then
      FOut.FExtParam := FieldByName('Z_CompanyId').AsString
    else
      FOut.FExtParam := FieldByName('DataAreaID').AsString;
    Result:=True;
  end;
end;

//lih 2016-09-23
//���߻�ȡ�ͻ��Ƿ�ǿ�����ö��
function TWorkerBusinessCommander.GetAXMaCredLmt(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  Result := False;
  nDBWorker := nil;
  try
    nStr := 'Select MandatoryCreditLimit From %s '+
            'where AccountNum=''%s'' and DataAreaID=''%s'' ';
    nStr := Format(nStr, [sTable_AX_Cust, FIn.FData, FIn.FExtParam]);
    //xxxxx
    //WriteLog(nStr);
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    begin
      if RecordCount < 1 then
      begin
        nData := '���Ϊ[ %s ]�Ŀͻ�������.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;
      if FieldByName('MandatoryCreditLimit').AsString='1' then
        FOut.FData := sFlag_Yes
      else
        FOut.FData := sFlag_No;
      Result:=True;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//lih 2016-09-23
//���߻�ȡ�Ƿ�ר��ר��
function TWorkerBusinessCommander.GetAXContQuota(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  Result := False;
  nDBWorker := nil;
  try
    nStr := 'Select XTContactQuota,ContactId From %s a left join %s b on a.ContactId=b.CMT_ContractNo '+
            'where SalesId=''%s'' and b.DataAreaID=''%s'' ';
    nStr := Format(nStr, [sTable_AX_SalesCont, sTable_AX_Sales, FIn.FData, FIn.FExtParam]);
    //xxxxx
    //WriteLog(nStr);
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    begin
      if RecordCount < 1 then
      begin
        nData := '���Ϊ[ %s ]�Ķ��������ۺ�ͬ.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;
      if FieldByName('XTContactQuota').AsString='1' then
        FOut.FData := sFlag_Yes
      else
        FOut.FData := sFlag_No;
      FOut.FExtParam := FieldByName('ContactId').AsString;
      Result:=True;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//lih 2016-09-02
//���߻�ȡAX���ö�ȣ��ͻ�����Ϣ��DL
function TWorkerBusinessCommander.GetAXTPRESTIGEMANAGE(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
    nBalance:Double;
    nFailureDate:TDateTime;
begin
  Result := False;
  nBalance:=0.00;
  nDBWorker := nil;
  try
    nStr := 'Select CustAccount,CustName,CashBalance,BillBalanceThreeMonths,'+
            'BillBalancesixMonths,PrestigeQuota,TemporaryBalance,TemporaryAmount,'+
            'WarningAmount,TemporaryTakeEffect,FailureDate,XTETempCreditNum,'+
            'XTFixedPrestigeStatus,YKAMOUNT From %s '+
            'where CustAccount=''%s'' and DataAreaID=''%s'' ';
    nStr := Format(nStr, [sTable_AX_TPRESTIGEMANAGE, FIn.FData, FIn.FExtParam]);
    //xxxxx
    //WriteLog(nStr);
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin
      WriteLog('�ͻ�ID:'+Fields[0].AsString);
      nFailureDate := FieldByName('FailureDate').AsDateTime;
      if (FieldByName('FailureDate').IsNull) or
        (FieldByName('FailureDate').AsString='') or
        (formatdatetime('yyyy-mm-dd',nFailureDate)='1900-01-01') or
        (formatdatetime('yyyy-mm-dd',nFailureDate)='1899-01-01') then
      begin
        nBalance:=FieldByName('CashBalance').AsFloat+
                  FieldByName('BillBalanceThreeMonths').AsFloat+
                  FieldByName('BillBalancesixMonths').AsFloat-
                  FieldByName('PrestigeQuota').AsFloat;
      end else
      begin
        nFailureDate := StrToDateTime(formatdatetime('yyyy-mm-dd',nFailureDate)+' 23:59:59');
        if nFailureDate >= Now then
        begin
          nBalance:=FieldByName('CashBalance').AsFloat+
                    FieldByName('BillBalanceThreeMonths').AsFloat+
                    FieldByName('BillBalancesixMonths').AsFloat+
                    FieldByName('TemporaryBalance').AsFloat-
                    FieldByName('PrestigeQuota').AsFloat;
        end else
        begin
          nBalance:=FieldByName('CashBalance').AsFloat+
                  FieldByName('BillBalanceThreeMonths').AsFloat+
                  FieldByName('BillBalancesixMonths').AsFloat-
                  FieldByName('PrestigeQuota').AsFloat;
        end;
      end;
      if nBalance>0 then
        FOut.FData:=sFlag_Yes
      else
        FOut.FData:=sFlag_No;
      FOut.FExtParam:=FloatToStr(nBalance);
      Result:=True;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//Date:2016-06-26
//ͬ��AX���ö�ȣ��ͻ�-��ͬ����Ϣ��DL
function TWorkerBusinessCommander.SyncAXTPRESTIGEMBYCONT(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
    nBalance:Double;
begin
  Result := True;
  FListA.Clear;
  nDBWorker := nil;
  try
    nStr := 'Select CustAccount,CustName,CMT_ContractId,CashBalance,'+
            'BillBalanceThreeMonths,BillBalancesixMonths,PrestigeQuota,'+
            'TemporaryBalance,TemporaryAmount,WarningAmount,TemporaryTakeEffect,'+
            'FailureDate,XTETempCreditNum,YKAMOUNT From %s where DataAreaID=''%s''';
    nStr := Format(nStr, [sTable_AX_TPRESTIGEMBYCONT, gCompanyAct]);
    //xxxxx

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        nStr := MakeSQLByStr([SF('C_CusID', Fields[0].AsString),
                SF('C_Date', sField_SQLServer_Now, sfVal),
                SF('C_CustName', Fields[1].AsString),
                SF('C_ContractId', Fields[2].AsString),
                SF('C_CashBalance', Fields[3].AsString),
                SF('C_BillBalance3M', Fields[4].AsString),
                SF('C_BillBalance6M', Fields[5].AsString),
                SF('C_PrestigeQuota', Fields[6].AsString),
                SF('C_TemporBalance', Fields[7].AsString),
                SF('C_TemporAmount', Fields[8].AsString),
                SF('C_WarningAmount', Fields[9].AsString),
                SF('C_TemporTakeEffect', Fields[10].AsString),
                SF('C_FailureDate', Fields[11].AsString),
                SF('C_LSCreditNum', Fields[12].AsString),
                SF('DataAreaID', gCompanyAct)
                ], sTable_CusContCredit, '', True);
        //xxxxx

        FListA.Add(nStr);
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    nStr := 'truncate table ' + sTable_CusContCredit;
    gDBConnManager.WorkerExec(FDBConn, nStr);

    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);

    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
    //Result:=False;
  end;
  FOut.FData:=sFlag_Yes;
end;

//lih 2016-09-02
//���߻�ȡAX���ö�ȣ��ͻ�-��ͬ����Ϣ��DL
function TWorkerBusinessCommander.GetAXTPRESTIGEMBYCONT(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
    nPos: Integer;
    nCusID,nConID:string;
    nBalance: Double;
    nFailureDate: TDateTime;
begin
  Result := False;
  nDBWorker := nil;
  nBalance:=0.00;
  try
    nPos:=Pos(',', FIn.FData);
    if nPos >0 then
    begin
      nCusID:=Copy(FIn.FData,1,nPos-1);
      nConID:=Copy(FIn.FData,nPos+1,Length(FIn.FData)-nPos);
    end;
    if (nCusID='') or (nConID='') then
    begin
      Result:=False;
      WriteLog('��Ϣ��ȫ');
      Exit;
    end;
    nStr := 'Select CustAccount,CustName,CMT_ContractId,CashBalance,'+
            'BillBalanceThreeMonths,BillBalancesixMonths,PrestigeQuota,'+
            'TemporaryBalance,TemporaryAmount,WarningAmount,TemporaryTakeEffect,'+
            'FailureDate,XTETempCreditNum,YKAMOUNT From %s '+
            'where CustAccount=''%s'' and CMT_ContractId=''%s'' and DataAreaID=''%s''';
    nStr := Format(nStr, [sTable_AX_TPRESTIGEMBYCONT, nCusID, nConID, FIn.FExtParam]);
    //WriteLog(nStr);
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin
      WriteLog('�ͻ�ID��'+Fields[0].AsString+'  ��ͬID��'+Fields[2].AsString);
      nFailureDate := FieldByName('FailureDate').AsDateTime;
      if (FieldByName('FailureDate').IsNull) or
        (FieldByName('FailureDate').AsString='') or
        (formatdatetime('yyyy-mm-dd',nFailureDate)='1900-01-01') or
        (formatdatetime('yyyy-mm-dd',nFailureDate)='1899-01-01') then
      begin
        nBalance:=FieldByName('CashBalance').AsFloat+
                  FieldByName('BillBalanceThreeMonths').AsFloat+
                  FieldByName('BillBalancesixMonths').AsFloat-
                  FieldByName('PrestigeQuota').AsFloat;
      end else
      begin
        nFailureDate := StrToDateTime(formatdatetime('yyyy-mm-dd',nFailureDate)+' 23:59:59');
        if nFailureDate >= Now then
        begin
          nBalance:=FieldByName('CashBalance').AsFloat+
                    FieldByName('BillBalanceThreeMonths').AsFloat+
                    FieldByName('BillBalancesixMonths').AsFloat+
                    FieldByName('TemporaryBalance').AsFloat-
                    FieldByName('PrestigeQuota').AsFloat;
        end else
        begin
          nBalance:=FieldByName('CashBalance').AsFloat+
                  FieldByName('BillBalanceThreeMonths').AsFloat+
                  FieldByName('BillBalancesixMonths').AsFloat-
                  FieldByName('PrestigeQuota').AsFloat;
        end;
      end;
      if nBalance>0 then
        FOut.FData:=sFlag_Yes
      else
        FOut.FData:=sFlag_No;
      FOut.FExtParam:=FloatToStr(nBalance);
      Result:=True;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//���߻�ȡ����ó�׶����ͻ�����������
function TWorkerBusinessCommander.GetAXCompanyArea(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
    nXSQYMC: string;
begin
  Result := False;
  nDBWorker := nil;
  try
    nStr := 'select XSQYMC from %s a '+
            'left join %s b on a.XSQYBM=b.XSQYBM '+
            'where salesid=''%s'' and dataareaid=''%s'' ';
    nStr := Format(nStr, [sTable_AX_Sales,sTable_AX_CompArea, FIn.FData, FIn.FExtParam]);
    //xxxxx
    //WriteLog(nStr);
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin
      nXSQYMC:= FieldByName('XSQYMC').AsString;
      FOut.FData:=nXSQYMC;
    end else
    begin
      FOut.FData:='';
    end;
    Result:=True;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//���߻�ȡ����������
function TWorkerBusinessCommander.GetInVentSum(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
    nFValue, nAXValue: Double;
    nStockType, nCenterID, nKw: string;
    nOnLineModel: string;
begin
  Result := False;

  nStr := 'select D_Value from %s where D_Name=''%s'' ';
  nStr := Format(nStr, [sTable_SysDict, sFlag_OnLineModel]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nOnLineModel := Fields[0].AsString;
  end
  else
    nOnLineModel := sFlag_Yes;

  if nOnLineModel <> sFlag_Yes then
  begin
    FOut.FData:='10000';
    Result := True;

    nStr := '����ģʽ,�����жϸ����';
    WriteLog(nStr);

    Exit;
  end;

  nStr := 'select D_Value from %s '+
          'where D_Value = ''%s'' and D_Name = ''%s'' ';
  nStr := Format(nStr, [sTable_SysDict, FIn.FData, sFlag_NoKcStock]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    FOut.FData:='10000';
    Result := True;

    nStr := '������[%s]���ϱ��[%s]�����жϸ����';
    nStr := Format(nStr, [FIn.FExtParam, FIn.FData]);
    WriteLog(nStr);

    Exit;
  end;

  FListA.Clear;
  FListA.Text := FIn.FExtParam;
  nCenterID := FListA.Values['CenterID'];
  if nCenterID = '' then
  begin
    WriteLog('������Ϊ��');
    Exit;
  end;

  if FListA.Values['StockType'] = sFlag_Dai then
  begin
    nStockType := sFlag_Dai;
    nKw := 'A04';
  end
  else
  begin
    nStockType := sFlag_San;
    nKw := 'A05';
  end;

  nStr := 'select D_Value from %s '+
          'where D_ParamB = ''%s'' and D_Name = ''%s'' and D_Memo = ''%s'' ';
  nStr := Format(nStr, [sTable_SysDict, FIn.FData, sFlag_StockItem, nStockType]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    if Pos('����',Fields[0].AsString) > 0 then
    begin
      nKw := 'A03';
    end;
  end;

  nFValue := 0;
  nAXValue := 0;

  nStr := 'select Sum(L_Value) as L_TotalValue from %s where L_StockNo = ''%s'' '+
          'and L_InvCenterId = ''%s'' and L_Type = ''%s'' and (L_OutFact is null) ';
  nStr := Format(nStr, [sTable_Bill, FIn.FData, nCenterID, nStockType]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nFValue := Fields[0].AsFloat;

    nStr := '������[%s]���ϱ��[%s]���ڶ�����:[%s]';
    nStr := Format(nStr, [nCenterID, FIn.FData + nStockType, FloatToStr(nFValue)]);
    WriteLog(nStr);
  end;

  nDBWorker := nil;
  try
    //nStr := 'select sum(PostedQty+Received-Deducted+Registered-Picked-ReservPhysical) as Yuliang from %s '+
    nStr := 'select sum(PostedQty+Received-Deducted+Registered-Picked) as Yuliang from %s '+
            'where itemid=''%s'' and xtInventCenterId=''%s'' and dataareaid=''%s'' ' +
            'and INVENTLOCATIONID=''%s''';
    nStr := Format(nStr, [sTable_AX_InventSum, FIn.FData, nCenterID, gCompanyAct, nKw]);
    //xxxxx
    WriteLog('��ѯERP����������Sql:'+ nStr);
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin

      nAXValue := Fields[0].AsFloat;
      nStr := '������[%s]���ϱ��[%s]ERP����:[%s]';
      nStr := Format(nStr, [nCenterID, FIn.FData + nStockType, FloatToStr(nAXValue)]);

      nFValue := nAXValue - nFValue;
      nFValue := Float2PInt(nFValue, cPrecision, False) / cPrecision;

      nStr := '������[%s]���ϱ��[%s]��ǰ��������:[%s]';
      nStr := Format(nStr, [nCenterID, FIn.FData + nStockType, FloatToStr(nFValue)]);

      FOut.FData:= FloatToStr(nFValue);
    end else
    begin
      FOut.FData:='0';
    end;
    Result:=True;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
end;

//��ȡ����������
function TWorkerBusinessCommander.GetSalesOrdValue(var nData: string): Boolean;
var nStr: string;
    nSendValue,nTotalValue,nValue :Double;
    nZhikaValue:Double;
begin
  Result := False;
  nSendValue := 0;
  nZhikaValue := 0;

  nStr := 'select IsNull(SUM(L_Value),''0'') as SendValue from %s where L_LineRecID=''%s'' ';
  nStr := Format(nStr,[sTable_Bill, Fin.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nSendValue := Fields[0].AsFloat;
  end;

  nStr := 'select D_TotalValue,D_value from %s Where D_RECID=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaDtl, Fin.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nTotalValue := Fields[0].AsFloat;
    nZhikaValue := FieldByName('D_value').AsFloat;
    if (nTotalValue > 0) and (nTotalValue > nSendValue) then
      nValue := nTotalValue-nSendValue
    else
      nValue := 0;

    if nValue-nZhikaValue>0.00001 then
    begin
      nValue := nZhikaValue;
    end;
    
    FOut.FData := FloatToStr(nValue);
    Result := True;
  end else
  begin
    FOut.FData := '0';
    Result := True;
  end;
end;

function TWorkerBusinessCommander.SyncAXEmpTable(var nData: string): Boolean;//ͬ��AXԱ����Ϣ��DL
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nStr := 'Select EmplId,Name From %s where DataAreaID=''%s''';
    nStr := Format(nStr, [STable_AX_EMPL, gCompanyAct]);
    //xxxxx

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := MakeSQLByStr([SF('EmplId', Fields[0].AsString),
                SF('EmplName', Fields[1].AsString),
                SF('DataAreaID', gCompanyAct)
                ], sTable_EMPL, '', True);
        //xxxxx

        FListA.Add(nStr);
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    nStr := 'truncate table ' + sTable_EMPL;
    gDBConnManager.WorkerExec(FDBConn, nStr);

    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessCommander.SyncAXInvCenGroup(var nData :string): Boolean;//ͬ��AX�����������ߵ�DL
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nStr := 'Select ItemGroupId,InventCenterId From %s where DataAreaID=''%s''';
    nStr := Format(nStr, [sTable_AX_InvCenGroup, gCompanyAct]);
    //xxxxx

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := MakeSQLByStr([SF('G_ItemGroupID', Fields[0].AsString),
                SF('G_InventCenterID', Fields[1].AsString),
                SF('DataAreaID', gCompanyAct)
                ], sTable_InvCenGroup, '', True);
        //xxxxx

        FListA.Add(nStr);
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    nStr := 'truncate table ' + sTable_InvCenGroup;
    gDBConnManager.WorkerExec(FDBConn, nStr);

    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//ͬ��AX��λ��Ϣ��DL
function TWorkerBusinessCommander.SyncAXwmsLocation(var nData :string): Boolean;
var nStr,nType: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result := True;

  nDBWorker := nil;
  try
    nStr := 'Select InventLocationID,WMSLocationID From %s where DataAreaID=''%s''';
    nStr := Format(nStr, [sTable_AX_WMSLocation, gCompanyAct]);
    //xxxxx

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        if (Pos('���Ͽ�',Fields[1].AsString)>0) then
          nType:= '����'
        else if (Pos('վ',Fields[1].AsString)>0) then
          nType:= '��װ'
        else if (Pos('ˮ��',Fields[1].AsString)>0) then
          nType:= 'ɢװ'
        else nType:= '';

        nStr := MakeSQLByStr([SF('K_Type', nType),
                SF('K_LocationID', Fields[0].AsString),
                SF('K_KuWeiNo', Fields[1].AsString)
                ], sTable_KuWei, '', True);
        //xxxxx

        FListA.Add(nStr);
        Next;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    nStr := 'truncate table ' + sTable_KuWei;
    gDBConnManager.WorkerExec(FDBConn, nStr);

    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;
//------------------------------------------------------------------------------

//Date: 2016-06-29
//��ȡAX���۶���
function TWorkerBusinessCommander.GetAXSalesOrder(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result:=True;
  nDBWorker := nil;
  try
    if FIn.FData='' then
    begin
      nStr := 'Select * From %s Where DataAreaID=''%s'' ';
      nStr := Format(nStr, [sTable_AX_Sales, gCompanyAct]);
    end else
    begin
      nStr := 'Select * From %s Where SalesId=''%s'' and DataAreaID=''%s'' ';
      nStr := Format(nStr, [sTable_AX_Sales, FIn.FData, gCompanyAct]);
    end;

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    begin
      if RecordCount > 0  then
      begin
        First;
        while not Eof do
        begin
          nStr := MakeSQLByStr([SF('Z_ID', FieldByName('SalesId').AsString),
                  SF('Z_Name', FieldByName('SalesName').AsString),
                  SF('Z_CID', FieldByName('CMT_ContractNo').AsString),
                  SF('Z_Customer', FieldByName('CustAccount').AsString),
                  SF('Z_ValidDays', FieldByName('FixedDueDate').AsString),
                  SF('Z_SalesStatus', FieldByName('salesstatus').AsString),
                  SF('Z_SalesType', FieldByName('SalesType').AsString),
                  SF('Z_TriangleTrade', FieldByName('CMT_TriangleTrade').AsString),
                  SF('Z_OrgAccountNum', FieldByName('CMT_OrgAccountNum').AsString),
                  SF('Z_OrgAccountName', FieldByName('CMT_OrgAccountName').AsString),
                  SF('Z_IntComOriSalesId', FieldByName('InterCompanyOriginalSalesId').AsString),
                  SF('Z_XSQYBM', FieldByName('XSQYBM').AsString),
                  SF('Z_KHSBM', FieldByName('CMT_KHSBM').AsString),
                  SF('Z_Date', FormatDateTime('yyyy-mm-dd hh:mm:ss',Now)),
                  SF('Z_Lading', FieldByName('XTFreightNew').AsString),
                  SF('Z_CompanyId', FieldByName('InterCompanyCompanyId').AsString),
                  SF('DataAreaID', gCompanyAct),
                  SF('Z_inventlocationid',FieldByName('inventlocationid').AsString)
                  ], sTable_ZhiKa, '', True);
          FListA.Add(nStr);
          Next;
        end;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;

  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    if FIn.FData='' then
      nStr := 'delete from ' + sTable_ZhiKa
    else
      nStr := 'delete from ' + sTable_ZhiKa + 'where Z_ID='''+FIn.FData+'''';
    gDBConnManager.WorkerExec(FDBConn, nStr);

    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
    Result:=True;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessCommander.GetAXSalesOrdLine(var nData: string): Boolean;//��ȡ���۶�����
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
    nPos:Integer;
    sId,LNum:string;
    nType,nStockName: string;
begin
  FListA.Clear;
  Result:=True;
  nDBWorker := nil;
  try
    nStr:= FIn.FData;
    if nStr='' then
    begin
      nStr := 'Select * From %s Where DataAreaID=''%s'' ';
      nStr := Format(nStr, [sTable_AX_SalLine, gCompanyAct]);
    end else
    begin
      nPos:=Pos(',',nStr);
      sId:=Copy(nStr,1,nPos-1);
      LNum:=Copy(nStr,nPos+1,Length(nStr)-nPos);

      nStr := 'Select * From %s Where SalesId=''%s'' and Recid=''%s'' and DataAreaID=''%s'' ';
      nStr := Format(nStr, [sTable_AX_SalLine, sId, LNum, gCompanyAct]);
    end;
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    begin
      if RecordCount >0 then
      begin
        First;
        while not Eof do
        begin
          if FieldByName('CMT_PACKTYPE').AsString='1' then
            nType:='D'
          else if FieldByName('CMT_PACKTYPE').AsString='2' then
            nType:='S'
          else
            nType:=FieldByName('CMT_PACKTYPE').AsString;
          nStockName:= FieldByName('Name').AsString;
          nStockName:= StringReplace(nStockName,'"','',[rfReplaceAll]);
          nStr := MakeSQLByStr([SF('D_ZID', FieldByName('SalesId').AsString),
                    SF('D_RECID', FieldByName('Recid').AsString),
                    SF('D_Type', nType),
                    SF('D_StockNo', FieldByName('ItemId').AsString),
                    SF('D_StockName', nStockName),
                    SF('D_SalesStatus', FieldByName('SalesStatus').AsString),
                    SF('D_Price', FieldByName('SalesPrice').AsString),
                    SF('D_Value', FieldByName('RemainSalesPhysical').AsString),
                    SF('D_TotalValue', FieldByName('SalesQty').AsString),
                    SF('D_Blocked', FieldByName('Blocked').AsString),
                    SF('D_Memo', FieldByName('CMT_Notes').AsString),
                    SF('DataAreaID', gCompanyAct)
                    ], sTable_ZhiKaDtl, '', True);
          FListA.Add(nStr);
          Next;
        end;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
  
  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    if FIn.FData='' then
      nStr := 'delete from ' + sTable_ZhiKaDtl
    else
      nStr := 'delete from ' + sTable_ZhiKaDtl + 'where D_ZID='''+sId+''' and D_RECID=''%s'' ';
    gDBConnManager.WorkerExec(FDBConn, nStr);
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
    Result:=True;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessCommander.GetAXSupAgreement(var nData: string): Boolean;//��ȡ����Э��
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result:=True;
  nDBWorker := nil;
  try
    if FIn.FData='' then
    begin
      nStr := 'Select * From %s Where DataAreaID=''%s'' ';
      nStr := Format(nStr, [sTable_AX_SupAgre, gCompanyAct]);
    end else
    begin
      nStr := 'Select * From %s Where XTEadjustBillNum=''%s'' and DataAreaID=''%s'' ';
      nStr := Format(nStr, [sTable_AX_SupAgre, FIn.FData, gCompanyAct]);
    end;
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    begin
      if RecordCount > 0 then
      begin
        First;
        while not Eof do
        begin
          nStr := MakeSQLByStr([SF('A_XTEadjustBillNum', FieldByName('XTEadjustBillNum').AsString),
                    SF('A_SalesId', FieldByName('SalesId').AsString),
                    SF('A_ItemId', FieldByName('itemid').AsString),
                    SF('A_SalesNewAmount', FieldByName('SalesNewAmount').AsString),
                    SF('A_TakeEffectDate', FieldByName('TakeEffectDate').AsString),
                    SF('A_TakeEffectTime', FieldByName('TakeEffectTime').AsString),
                    SF('RefRecid', FieldByName('RefRecid').AsString),
                    SF('Recid', FieldByName('RecId').AsString),
                    SF('DataAreaID', gCompanyAct),
                    SF('A_Date', FormatDateTime('yyyy-mm-dd hh:mm:ss',Now))
                    ], sTable_AddTreaty, '', True);
          FListA.Add(nStr);
          Next;
        end;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
  
  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    if FIn.FData='' then
      nStr := 'delete from ' + sTable_AddTreaty
    else
      nStr := 'delete from ' + sTable_AddTreaty + 'where A_XTEadjustBillNum='''+FIn.FData+''' ';
    gDBConnManager.WorkerExec(FDBConn, nStr);
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
    Result:=True;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessCommander.GetAXCreLimCust(var nData: string): Boolean;//��ȡ���ö���������ͻ���
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result:=True;
  nDBWorker := nil;
  try
    if FIn.FData='' then
    begin
      nData:='������Ч.';
      Result:=False;
      Exit;
    end else
    begin
      nStr := 'Select * From %s Where RecId=''%s'' and DataAreaID=''%s'' ';
      nStr := Format(nStr, [sTable_AX_CreLimLog, FIn.FData, gCompanyAct]);
    end;
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    begin
      if RecordCount > 0 then
      begin
        First;
        while not Eof do
        begin
          nStr := MakeSQLByStr([SF('C_CusID', FieldByName('CustAccount').AsString),
                    SF('C_SubCash', FieldByName('XTSubCash').AsString),
                    SF('C_SubThreeBill', FieldByName('XTSubThreeBill').AsString),
                    SF('C_SubSixBil', FieldByName('XTSubSixBill').AsString),
                    SF('C_SubTmp', FieldByName('XTSubTmp').AsString),
                    SF('C_SubPrest', FieldByName('XTSubCash').AsString),
                    SF('C_Createdby', FieldByName('Createdby').AsString),
                    SF('C_Createdate', FieldByName('Createdate').AsString),
                    SF('C_Createtime', FieldByName('createtime').AsString),
                    SF('DataAreaID', FieldByName('DataReaID').AsString),
                    SF('RecID', FieldByName('RecId').AsString)
                    ], sTable_CustPresLog, '', True);
          FListA.Add(nStr);
          Next;
        end;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
  
  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
    Result:=True;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessCommander.GetAXCreLimCusCont(var nData: string): Boolean;//��ȡ���ö���������ͻ�-��ͬ��
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result:=True;
  nDBWorker := nil;
  try
    if FIn.FData='' then
    begin
      nData := '������Ч.';
      Result:=False;
      Exit;
    end else
    begin
      nStr := 'Select * From %s Where RecId=''%s'' and DataAreaID=''%s'' ';
      nStr := Format(nStr, [sTable_AX_CreLimLog, FIn.FData, gCompanyAct]);
    end;
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    begin
      if RecordCount > 0 then
      begin
        First;
        while not Eof do
        begin
          nStr := MakeSQLByStr([SF('C_CusID', FieldByName('CustAccount').AsString),
                    SF('C_SubCash', FieldByName('XTSubCash').AsString),
                    SF('C_SubThreeBill', FieldByName('XTSubThreeBill').AsString),
                    SF('C_SubSixBil', FieldByName('XTSubSixBill').AsString),
                    SF('C_SubTmp', FieldByName('XTSubTmp').AsString),
                    SF('C_SubPrest', FieldByName('XTSubCash').AsString),
                    SF('C_Createdby', FieldByName('Createdby').AsString),
                    SF('C_Createdate', FieldByName('Createdate').AsString),
                    SF('C_Createtime', FieldByName('createtime').AsString),
                    SF('DataAreaID', FieldByName('DataAreaID').AsString),
                    SF('RecID', FieldByName('RecId').AsString)
                    ], sTable_CustPresLog, '', True);
          FListA.Add(nStr);
          Next;
        end;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
  
  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
    Result:=True;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessCommander.GetAXSalesContract(var nData: string): Boolean;//��ȡ���ۺ�ͬ
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  Result:=True;
  nDBWorker := nil;
  try
    if FIn.FData='' then
    begin
      nStr := 'Select * From %s Where companyid=''%s'' ';
      nStr := Format(nStr, [sTable_AX_SalesCont, gCompanyAct]);
    end else
    begin
      nStr := 'Select * From %s Where ContactId=''%s'' and companyid=''%s'' ';
      nStr := Format(nStr, [sTable_AX_SalesCont, FIn.FData, gCompanyAct]);
    end;
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    begin
      if RecordCount > 0 then
      begin
        First;
        while not Eof do
        begin
          nStr := MakeSQLByStr([SF('C_ID', FieldByName('ContactId').AsString),
                    SF('C_CustName', FieldByName('custname').AsString),
                    SF('C_Customer', FieldByName('CUST').AsString),
                    SF('C_Addr', FieldByName('ContactAddress').AsString),
                    SF('C_SFSP', FieldByName('CMT_SFSP').AsString),
                    SF('C_ContType', FieldByName('xtEContractSuperType').AsString),
                    SF('C_ContQuota', FieldByName('XTContactQuota').AsString),
                    SF('C_Date', FormatDateTime('yyyy-mm-dd hh:mm:ss',Now)),
                    SF('DataAreaID', gCompanyAct)
                    ], sTable_SaleContract, '', True);
          FListA.Add(nStr);
          Next;
        end;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
  
  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    if FIn.FData='' then
      nStr := 'delete from ' + sTable_SaleContract
    else
      nStr := 'delete from ' + sTable_SaleContract + 'where C_ID='''+FIn.FData+''' ';
    gDBConnManager.WorkerExec(FDBConn, nStr);
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
    Result:=True;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessCommander.GetAXSalesContLine(var nData: string): Boolean;//��ȡ���ۺ�ͬ��
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
    nType: string;
begin
  FListA.Clear;
  Result:=True;
  nDBWorker := nil;
  try
    if FIn.FData='' then
    begin
      nStr := 'Select * From %s Where DataAreaID=''%s'' ';
      nStr := Format(nStr, [sTable_AX_SalContLine, gCompanyAct]);
    end else
    begin
      nStr := 'Select * From %s Where ContactId=''%s'' and DataAreaID=''%s'' ';
      nStr := Format(nStr, [sTable_AX_SalContLine, FIn.FData, gCompanyAct]);
    end;
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    begin
      if RecordCount > 0 then
      begin
        First;
        while not Eof do
        begin
          if FieldByName('packtype').AsString='1' then
            nType:='D'
          else if FieldByName('packtype').AsString='2' then
            nType:='S'
          else
            nType:=FieldByName('packtype').AsString;
          nStr := MakeSQLByStr([SF('E_CID', FieldByName('ContactId').AsString),
                    SF('E_Type', nType),
                    SF('E_StockNo', FieldByName('itemid').AsString),
                    SF('E_StockName', FieldByName('itemname').AsString),
                    SF('E_Value', FieldByName('qty').AsString),
                    SF('E_Price', FieldByName('price').AsString),
                    SF('E_Money', FieldByName('amount').AsString),
                    SF('E_Date', FormatDateTime('yyyy-mm-dd hh:mm:ss',Now)),
                    SF('DataAreaID', gCompanyAct)
                    ], sTable_SContractExt, '', True);
          FListA.Add(nStr);
          Next;
        end;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    if FIn.FData='' then
      nStr := 'delete from ' + sTable_SContractExt
    else
      nStr := 'delete from ' + sTable_SContractExt + 'where E_CID='''+FIn.FData+''' ';
    gDBConnManager.WorkerExec(FDBConn, nStr);
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
    Result:=True;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessCommander.GetAXVehicleNo(var nData: string): Boolean;//��ȡ����
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
    nPreUse,nPreValue: string;
begin
  FListA.Clear;
  Result:=True;

  Exit;
  
  nDBWorker := nil;
  try
    if FIn.FData='' then
    begin
      nStr := 'Select * From %s Where companyid=''%s'' ';
      nStr := Format(nStr, [sTable_AX_VehicleNo, gCompanyAct]);
    end else
    begin
      nStr := 'Select * From %s Where VehicleId=''%s'' and companyid=''%s'' ';
      nStr := Format(nStr, [sTable_AX_VehicleNo, FIn.FData]);
    end;
    {$IFDEF DEBUG}
    WriteLog(nStr);
    {$ENDIF}
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    begin
      if RecordCount > 0 then
      begin
        First;
        while not Eof do
        begin
          {if FieldByName('VehicleType').AsString='ɢװ' then
            nPreUse:='Y'
          else}
            nPreUse:='N';
          nPreValue:= FieldByName('TAREWEIGHT').AsString;
          if not IsNumber(nPreValue,True) then nPreValue:='0.00';
          nStr := MakeSQLByStr([SF('T_Truck', FieldByName('VehicleId').AsString),
                    SF('T_Owner', FieldByName('CZ').AsString),
                    SF('T_PrePUse', nPreUse),
                    SF('T_PrePValue', nPreValue),
                    SF('T_Driver', FieldByName('DriverId').AsString),
                    SF('T_Card', FieldByName('CMT_PrivateId').AsString),
                    SF('T_CompanyID', FieldByName('companyid').AsString),
                    SF('T_XTECB', FieldByName('XTECB').AsString),
                    SF('T_VendAccount', FieldByName('VendAccount').AsString)
                    ], sTable_Truck, '', True);
            FListA.Add(nStr);
          Next;
        end;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    if FIn.FData='' then
      nStr := 'delete from ' + sTable_Truck
    else
      nStr := 'delete from ' + sTable_Truck + 'where T_Truck='''+FIn.FData+''' ';
    gDBConnManager.WorkerExec(FDBConn, nStr);
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
    Result:=True;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessCommander.GetAXPurOrder(var nData: string): Boolean;//��ȡ�ɹ�����
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
begin
  FListA.Clear;
  nDBWorker := nil;
  try
    if FIn.FData='' then
    begin
      nStr := 'Select * From %s Where DataAreaID=''%s''';
      nStr := Format(nStr, [sTable_AX_PurOrder, gCompanyAct]);
    end else
    begin
      nStr := 'Select * From %s Where PurchId=''%s'' and DataAreaID=''%s'' ';
      nStr := Format(nStr, [sTable_AX_PurOrder, FIn.FData, gCompanyAct]);
    end;

    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    begin
      if RecordCount > 0 then
      begin
        First;
        while not Eof do
        begin
          nStr := MakeSQLByStr([SF('M_ID', FieldByName('PurchId').AsString),
                    SF('M_ProID', FieldByName('OrderAccount').AsString),
                    SF('M_ProName', FieldByName('PURCHNAME').AsString),
                    SF('M_ProPY', GetPinYinOfStr(FieldByName('PURCHNAME').AsString)),
                    SF('M_CID', FieldByName('xtContractId').AsString),
                    SF('M_BStatus', FieldByName('PurchStatus').AsString),
                    SF('M_TriangleTrade', FieldByName('CMT_TriangleTrade').AsString),
                    SF('M_IntComOriSalesId', FieldByName('InterCompanyOriginalSalesId').AsString),
                    SF('M_PurchType', FieldByName('PurchaseType').AsString),
                    SF('M_DState', FieldByName('DocumentState').AsString),
                    SF('M_Date', FormatDateTime('yyyy-mm-dd hh:mm:ss',Now)),
                    SF('DataAreaID', gCompanyAct)
                    ], sTable_OrderBaseMain, '', True);
          FListA.Add(nStr);
          Next;
        end;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    if FIn.FData='' then
      nStr := 'delete from ' + sTable_OrderBaseMain
    else
      nStr := 'delete from ' + sTable_OrderBaseMain + 'where M_ID='''+FIn.FData+''' ';
    gDBConnManager.WorkerExec(FDBConn, nStr);
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
    Result:=True;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessCommander.GetAXPurOrdLine(var nData: string): Boolean;//��ȡ�ɹ�������
var nStr: string;
    nIdx: Integer;
    nDBWorker: PDBWorker;
    nPos:Integer;
    fId,LNum,nStockName:string;
begin
  FListA.Clear;
  nDBWorker := nil;
  try
    if FIn.FData='' then
    begin
      nStr := 'Select * From %s Where DataAreaID=''%s'' ';
      nStr := Format(nStr, [sTable_AX_PurOrdLine, gCompanyAct]);
    end else
    begin
      nStr:= FIn.FData;
      nPos:=Pos(',',nStr);
      fId:=Copy(nStr,1,nPos-1);
      LNum:=Copy(nStr,nPos+1,Length(nStr)-nPos);
      nStr := 'Select * From %s Where PurchId=''%s'' and LineNum=''%s'' and DataAreaID=''%s'' ';
      nStr := Format(nStr, [sTable_AX_PurOrdLine, fId, LNum, gCompanyAct]);
    end;
    with gDBConnManager.SQLQuery(nStr, nDBWorker, sFlag_DB_AX) do
    begin
      if RecordCount > 0 then
      begin
        First;
        while not Eof do
        begin
          nStockName:= FieldByName('Name').AsString;
          nStockName:= StringReplace(nStockName,'"','',[rfReplaceAll]);
          nStr := MakeSQLByStr([SF('B_ID', FieldByName('PurchId').AsString),
                    SF('B_StockType', FieldByName('CMT_PACKTYPE').AsString),
                    SF('B_StockNo', FieldByName('ItemId').AsString),
                    SF('B_StockName', nStockName),
                    SF('B_BStatus', FieldByName('PurchStatus').AsString),
                    SF('B_Value', FieldByName('QtyOrdered').AsString),
//                    SF('B_SentValue', FieldByName('PurchReceivedNow').AsString),
                    SF('B_SentValue', FloatToStr(FieldByName('QtyOrdered').AsFloat-FieldByName('RemainPurchPhysical').AsFloat)),
                    SF('B_RestValue', FieldByName('RemainPurchPhysical').AsString),
                    SF('B_Blocked', FieldByName('Blocked').AsString),
                    SF('B_Date', FormatDateTime('yyyy-mm-dd hh:mm:ss',Now)),
                    SF('DataAreaID', FieldByName('DataAreaID').AsString),
		    SF('B_Memo', FieldByName('cmt_notes').AsString),
                    SF('B_RECID', FieldByName('Recid').AsString)
                    ], sTable_OrderBase, '', True);
          FListA.Add(nStr);
          Next;
        end;
      end;
    end;
  finally
    gDBConnManager.ReleaseConnection(nDBWorker);
  end;
  if FListA.Count > 0 then
  try
    FDBConn.FConn.BeginTrans;
    if FIn.FData='' then
      nStr := 'delete from ' + sTable_OrderBase
    else
      nStr := 'delete from ' + sTable_OrderBase + 'where B_ID='''+fId+''' and B_RECID='''+LNum+''' ';
    gDBConnManager.WorkerExec(FDBConn, nStr);
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    FDBConn.FConn.CommitTrans;
    Result:=True;
  except
    if FDBConn.FConn.InTransaction then
      FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessCommander.SyncStockBillAX(var nData: string):Boolean;//ͬ�������������˼ƻ�����AX
var nID,nIdx: Integer;
    nStr,nSQL: string;
    nService: BPM2ERPServiceSoap;
    nMsg:Integer;
    nFYPlanStatus,nCenterId,nLocationId:string;
    nLID:string;
begin
  Result := False;

  nSQL := 'select a.L_PlanQty,a.L_Truck,a.L_ID,a.L_ZhiKa,a.L_LineRecID,'+
          'a.L_InvCenterId,a.L_InvLocationId'+
          ' From %s a where L_ID = ''%s'' and l_ifneidao<>''Y''';
  nSQL := Format(nSQL,[sTable_Bill,FIn.FData]);
  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount < 1 then
    begin
      nData := '���Ϊ[ %s ]�������������.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
    //if (Pos('YS',FieldByName('L_ID').AsString)>0) then Exit;

    nFYPlanStatus:='0';
    if FieldByName('L_InvCenterId').AsString='' then
    begin
      nData := '���Ϊ[ %s ]���������Ʒû������������.';
      nData := Format(nData, [FIn.FData]);
      WriteLog(nData);
      Exit;
    end;
    //{$IFDEF GGJC}
    nLID := FieldByName('L_ID').AsString;
    //{$ELSE}
    //nLID := copy(FieldByName('L_ID').AsString,2,10);
    //{$ENDIF}
    //{$IFDEF GLPURCH}
    //nLID := FieldByName('L_ID').AsString;
    //{$ENDIF}
    nLocationId := FieldByName('L_InvLocationId').AsString;
    if nLocationId = '' then nLocationId := 'A';
    nStr:='<PRIMARY>'+
             '<PLANQTY>'+FieldByName('L_PlanQty').AsString+'</PLANQTY>'+
             '<VEHICLEId>'+FieldByName('L_Truck').AsString+'</VEHICLEId>'+
             '<VENDPICKINGLISTID>S</VENDPICKINGLISTID>'+
             '<TRANSPORTER></TRANSPORTER>'+
             '<TRANSPLANID>'+nLID+'</TRANSPLANID>'+
             '<SALESID>'+FieldByName('L_ZhiKa').AsString+'</SALESID>'+
             '<SALESLINERECID>'+FieldByName('L_LineRecID').AsString+'</SALESLINERECID>'+
             '<COMPANYID>'+gCompanyAct+'</COMPANYID>'+
             '<Destinationcode></Destinationcode>'+
             '<WMSLocationId></WMSLocationId>'+
             '<FYPlanStatus>'+nFYPlanStatus+'</FYPlanStatus>'+
             '<InventLocationId>'+nLocationId+'</InventLocationId>'+
             '<xtDInventCenterId>'+FieldByName('L_InvCenterId').AsString+'</xtDInventCenterId>'+
           '</PRIMARY>';
    //{$IFDEF DEBUG}
    WriteLog('ͬ���������ӿ�����'+nStr);
    //{$ENDIF}
    //----------------------------------------------------------------------------
    try
      nService:=GetBPM2ERPServiceSoap(True,gURLAddr,nil);
      nMsg:=nService.WRZS2ERPInfo('WRZS_001',nStr,'000');
      if nMsg=1 then
      begin
        WriteLog('����ֵ��'+IntToStr(nMsg)+','+FieldByName('L_ID').AsString+'ͬ���ɹ�');
        nSQL:='update %s set L_FYAX=''1'',L_FYNUM=L_FYNUM+1 where L_ID = ''%s'' ';
        nSQL := Format(nSQL,[sTable_Bill,FIn.FData]);
        gDBConnManager.WorkerExec(FDBConn,nSQL);
        Result := True;
      end else
      begin
        WriteLog('����ֵ��'+IntToStr(nMsg)+','+FieldByName('L_ID').AsString+'ͬ��ʧ��');
        nSQL:='update %s set L_FYNUM=L_FYNUM+1 where L_ID = ''%s'' ';
        nSQL := Format(nSQL,[sTable_Bill,FIn.FData]);
        gDBConnManager.WorkerExec(FDBConn,nSQL);
      end;
    except
      on e:Exception do
      begin
        nStr := FieldByName('L_ID').AsString+'�����ͬ��ʧ��.';
        WriteLog('AX�ӿ��쳣��'+nStr+#13#10+e.Message);
      end;
    end;
  end;
end;

//ͬ��ɾ����������AX
function TWorkerBusinessCommander.SyncDelSBillAX(var nData: string):Boolean;
var nID,nIdx: Integer;
    nStr,nSQL: string;
    nService: BPM2ERPServiceSoap;
    nMsg:Integer;
    nFYPlanStatus,nCenterId,nLocationId:string;
    s:string;
    nLID:string;
begin
  Result := False;

  nSQL := 'select a.L_PlanQty,a.L_Truck,a.L_ID,a.L_ZhiKa,L_LineRecID,'+
          'a.L_InvCenterId,a.L_InvLocationId '+
          ' From %s a where L_ID = ''%s'' and L_FYAX=''1'' ';
  nSQL := nSQL+' union select a.L_PlanQty,a.L_Truck,a.L_ID,a.L_ZhiKa,L_LineRecID,'+
          'a.L_InvCenterId,a.L_InvLocationId '+
          ' From %s a where L_ID = ''%s'' and L_FYAX=''1'' ';
  nSQL := Format(nSQL,[sTable_BillBak,FIn.FData,sTable_Bill,FIn.FData]);
  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount < 1 then
    begin
      nData := '���Ϊ[ %s ]�������������.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
    nFYPlanStatus:='1';
    if FieldByName('L_InvCenterId').AsString='' then
    begin
      nData := '���Ϊ[ %s ]���������Ʒû������������.';
      nData := Format(nData, [FIn.FData]);
      WriteLog(nData);
      Exit;
    end;
    nLocationId := FieldByName('L_InvLocationId').AsString;
    if nLocationId = '' then nLocationId := 'A';
    //{$IFDEF GGJC}
    nLID := FieldByName('L_ID').AsString;
    //{$ELSE}
    //nLID := copy(FieldByName('L_ID').AsString,2,10);
    //{$ENDIF}
    //{$IFDEF GLPURCH}
    //nLID := FieldByName('L_ID').AsString;
    //{$ENDIF}
    nStr:='<PRIMARY>'+
             '<PLANQTY>'+FieldByName('L_PlanQty').AsString+'</PLANQTY>'+
             '<VEHICLEId>'+FieldByName('L_Truck').AsString+'</VEHICLEId>'+
             '<VENDPICKINGLISTID>S</VENDPICKINGLISTID>'+
             '<TRANSPORTER></TRANSPORTER>'+
             '<TRANSPLANID>'+nLID+'</TRANSPLANID>'+
             '<SALESID>'+FieldByName('L_ZhiKa').AsString+'</SALESID>'+
             '<SALESLINERECID>'+FieldByName('L_LineRecID').AsString+'</SALESLINERECID>'+
             '<COMPANYID>'+gCompanyAct+'</COMPANYID>'+
             '<Destinationcode></Destinationcode>'+
             '<WMSLocationId></WMSLocationId>'+
             '<FYPlanStatus>'+nFYPlanStatus+'</FYPlanStatus>'+
             '<InventLocationId>'+nLocationId+'</InventLocationId>'+
             '<xtDInventCenterId>'+FieldByName('L_InvCenterId').AsString+'</xtDInventCenterId>'+
           '</PRIMARY>';
//    {$IFDEF DEBUG}
    WriteLog('ͬ��ɾ����������AX����ֵ��'+nStr);
//    {$ENDIF}
    //----------------------------------------------------------------------------
    try
      nService:=GetBPM2ERPServiceSoap(True,gURLAddr,nil);
      nMsg:=nService.WRZS2ERPInfo('WRZS_001',nStr,'000');
      if nMsg=1 then
      begin
        WriteLog('����ֵ��'+IntToStr(nMsg)+','+FieldByName('L_ID').AsString+'ͬ���ɹ�');
        nSQL:='update %s set L_FYDEL=''1'',L_FYDELNUM=L_FYDELNUM+1 where L_ID = ''%s'' ';
        nSQL := Format(nSQL,[sTable_BillBak,FIn.FData]);
        gDBConnManager.WorkerExec(FDBConn,nSQL);
        Result := True;
      end else
      begin
        WriteLog('����ֵ��'+IntToStr(nMsg)+','+FieldByName('L_ID').AsString+'ͬ��ʧ��');
        nSQL:='update %s set L_FYDELNUM=L_FYDELNUM+1 where L_ID = ''%s'' ';
        nSQL := Format(nSQL,[sTable_BillBak,FIn.FData]);
        gDBConnManager.WorkerExec(FDBConn,nSQL);
      end;
    except
      on e:Exception do
      begin
        nStr := FieldByName('L_ID').AsString+'ɾ�������ͬ��ʧ��.';
        WriteLog('AX�ӿ��쳣��'+nStr+#13#10+e.Message);
      end;
    end;
  end;
end;

//ͬ���ճ�����������
function TWorkerBusinessCommander.SyncEmptyOutBillAX(var nData: string):Boolean;
var nID,nIdx: Integer;
    nStr,nSQL: string;
    nService: BPM2ERPServiceSoap;
    nMsg:Integer;
    nFYPlanStatus,nCenterId,nLocationId:string;
    s:string;
begin
  Result := False;

  nSQL := 'select a.L_PlanQty,a.L_Truck,a.L_ID,a.L_ZhiKa,a.L_LineRecID,'+
          'a.L_InvCenterId,a.L_InvLocationId'+
          ' From %s a where L_ID = ''%s'' ';
  nSQL := Format(nSQL,[sTable_Bill,FIn.FData]);
  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount < 1 then
    begin
      nData := '���Ϊ[ %s ]�������������.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
    nFYPlanStatus:='1';
    if FieldByName('L_InvCenterId').AsString='' then
    begin
      nData := '���Ϊ[ %s ]���������Ʒû������������.';
      nData := Format(nData, [FIn.FData]);
      WriteLog(nData);
      Exit;
    end;
    nLocationId := FieldByName('L_InvLocationId').AsString;
    if nLocationId = '' then nLocationId := 'A';
    nStr:='<PRIMARY>'+
             '<PLANQTY>'+FieldByName('L_PlanQty').AsString+'</PLANQTY>'+
             '<VEHICLEId>'+FieldByName('L_Truck').AsString+'</VEHICLEId>'+
             '<VENDPICKINGLISTID>S</VENDPICKINGLISTID>'+
             '<TRANSPORTER></TRANSPORTER>'+
             '<TRANSPLANID>'+FieldByName('L_ID').AsString+'</TRANSPLANID>'+
             '<SALESID>'+FieldByName('L_ZhiKa').AsString+'</SALESID>'+
             '<SALESLINERECID>'+FieldByName('L_LineRecID').AsString+'</SALESLINERECID>'+
             '<COMPANYID>'+gCompanyAct+'</COMPANYID>'+
             '<Destinationcode></Destinationcode>'+
             '<WMSLocationId></WMSLocationId>'+
             '<FYPlanStatus>'+nFYPlanStatus+'</FYPlanStatus>'+
             '<InventLocationId>'+nLocationId+'</InventLocationId>'+
             '<xtDInventCenterId>'+FieldByName('L_InvCenterId').AsString+'</xtDInventCenterId>'+
           '</PRIMARY>';
    {$IFDEF DEBUG}
    WriteLog('����ֵ��'+nStr);
    {$ENDIF}
    //----------------------------------------------------------------------------
    try
      nService:=GetBPM2ERPServiceSoap(True,gURLAddr,nil);
      nMsg:=nService.WRZS2ERPInfo('WRZS_001',nStr,'000');
      if nMsg=1 then
      begin
        WriteLog('����ֵ��'+IntToStr(nMsg)+','+FieldByName('L_ID').AsString+'ͬ���ɹ�');
        nSQL:='update %s set L_EOUTAX=''1'',L_EOUTNUM=L_EOUTNUM+1 where L_ID = ''%s'' ';
        nSQL := Format(nSQL,[sTable_Bill,FIn.FData]);
        gDBConnManager.WorkerExec(FDBConn,nSQL);
        Result := True;
      end else
      begin
        WriteLog('����ֵ��'+IntToStr(nMsg)+','+FieldByName('L_ID').AsString+'ͬ��ʧ��');
        nSQL:='update %s set L_EOUTNUM=L_EOUTNUM+1 where L_ID = ''%s'' ';
        nSQL := Format(nSQL,[sTable_Bill,FIn.FData]);
        gDBConnManager.WorkerExec(FDBConn,nSQL);
      end;
    except
      on e:Exception do
      begin
        nStr := FieldByName('L_ID').AsString+'�ճ�����ͬ��ʧ��.';
        WriteLog('AX�ӿ��쳣��'+nStr+#13#10+e.Message);
      end;
    end;
  end;
end;

function TWorkerBusinessCommander.SyncPoundBillAX(var nData: string):Boolean;//ͬ��������AX
var nID,nIdx: Integer;
    nStr,nWeightMan:string;
    nSQL: string;
    nService: BPM2ERPServiceSoap;
    nMsg:Integer;
    nCenterId,nLocationId:string;
    s,nHYDan:string;
    nNetValue, nYKMouney:Double;
    nsWeightTime, nCustAcc, nContQuota:string;
    nNeiDao:string;
    nLID:string;
begin
  Result := False;

  nSQL := 'select a.L_ID,a.L_StockNo,a.L_Truck,a.L_PValue,a.L_MValue,a.L_Value,'+
          'a.L_InvCenterId,a.L_InvLocationId,a.L_CW,a.L_PlanQty,a.L_HYDan,a.L_Type,'+
          'a.L_MMan,a.L_MDate,b.P_ID,a.L_ZhiKa,a.L_LineRecID,a.L_StockName,'+
          'IsNull(L_Value*L_Price,''0'') as L_TotalMoney,L_CusID,L_ContQuota,l_ifneidao'+
          ' From %s a,%s b '+
          ' where a.L_ID = ''%s'' and a.L_ID=b.P_Bill and a.l_ifneidao<>''Y''';
  nSQL := Format(nSQL,[sTable_Bill,sTable_PoundLog,FIn.FData]);
  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  begin
    if RecordCount < 1 then
    begin
      nData := '��������Ϊ[ %s ]�İ���������.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
    if FieldByName('L_InvCenterId').AsString='' then
    begin
      nData := '���Ϊ[ %s ]�Ľ�������Ʒû������������.';
      nData := Format(nData, [FIn.FData]);
      WriteLog(nData);
      Exit;
    end;
    nNeiDao := FieldByName('l_ifneidao').AsString;
    nHYDan:=FieldByName('L_HYDan').AsString;
    if nHYDan='' then
    begin
      //WriteLog(FieldByName('L_StockName').AsString);
      if (Pos('����',FieldByName('L_StockName').AsString)>0) then
      begin
        nHYDan:='I';
      end else
      begin
        if nNeiDao=sflag_yes then
        begin
          nHYDan:='I';
        end
        else begin
          nData := '��������Ϊ[ %s ]�Ļ��鵥������.';
          nData := Format(nData, [FIn.FData]);
          WriteLog(nData);
          Exit;
        end;
      end;
    end;
    nsWeightTime:=formatdatetime('yyyy-mm-dd hh:mm:ss',FieldByName('L_MDate').AsDateTime);
    if nsWeightTime<>'' then
    begin
      nsWeightTime:=Copy(nsWeightTime,12,Length(nsWeightTime)-11);
    end;
    if FieldByName('L_Type').AsString='D' then
    begin
      nNetValue:=FieldByName('L_MValue').AsFloat-FieldByName('L_PValue').AsFloat;
      nNetValue := Float2Float(nNetValue, cPrecision, False);
    end else
    begin
      nNetValue := 0;
    end;

    nLID := FieldByName('L_ID').AsString;

    nStr := '<PRIMARY>';
    nStr := nStr+'<TRANSPLANID>'+nLID+'</TRANSPLANID>';
    nStr := nStr+'<ITEMID>'+FieldByName('L_StockNo').AsString+'</ITEMID>';
    nStr := nStr+'<VehicleNum>'+FieldByName('L_Truck').AsString+'</VehicleNum>';
    nStr := nStr+'<VehicleType></VehicleType>';
    nStr := nStr+'<applyvehicle></applyvehicle>';
    nStr := nStr+'<TareWeight>'+FieldByName('L_PValue').AsString+'</TareWeight>';
    nStr := nStr+'<GrossWeight>'+FieldByName('L_MValue').AsString+'</GrossWeight>';
    if FieldByName('L_Type').AsString='D' then
      nStr := nStr+'<Netweight>'+FloatToStr(nNetValue)+'</Netweight>'
    else
      nStr := nStr+'<Netweight>'+FieldByName('L_Value').AsString+'</Netweight>';
    nStr := nStr+'<REFERENCEQTY>'+FieldByName('L_PlanQty').AsString+'</REFERENCEQTY>';
    nStr := nStr+'<PackQty></PackQty>';
    nStr := nStr+'<SampleID>'+nHYDan+'</SampleID>';
    nStr := nStr+'<CMTCW>'+FieldByName('L_CW').AsString+'</CMTCW>';
    nStr := nStr+'<WeightMan>'+FieldByName('L_MMan').AsString+'</WeightMan>';
    nStr := nStr+'<WeightTime>'+nsWeightTime+'</WeightTime>';
    nStr := nStr+'<WeightDate>'+FieldByName('L_MDate').AsString+'</WeightDate>';
    nStr := nStr+'<description></description>';
    nStr := nStr+'<WeighingNum>'+FieldByName('P_ID').AsString+'</WeighingNum>';
    nStr := nStr+'<salesId>'+FieldByName('L_ZhiKa').AsString+'</salesId>';
    nStr := nStr+'<SalesLineRecid>'+FieldByName('L_LineRecID').AsString+'</SalesLineRecid>';
    nStr := nStr+'<COMPANYID>'+gCompanyAct+'</COMPANYID>';
    nStr := nStr+'<InventLocationId>'+FieldByName('L_InvLocationId').AsString+'</InventLocationId>';
    nStr := nStr+'<xtDInventCenterId>'+FieldByName('L_InvCenterId').AsString+'</xtDInventCenterId>';
    nStr := nStr+'</PRIMARY>';
//    {$IFDEF DEBUG}
    WriteLog('ͬ��������AX����ֵ��'+nStr);
//    {$ENDIF}
    try
      nService:=GetBPM2ERPServiceSoap(True,gURLAddr,nil);
      //s:=nService.test;
      //WriteLog('���Է���ֵ��'+s);
      nMsg:=nService.WRZS2ERPInfo('WRZS_002',nStr,'000');
      if (nMsg=1) or (nMsg=2) then
      begin
        WriteLog('����ֵ��'+IntToStr(nMsg)+','+FieldByName('P_ID').AsString+'ͬ���ɹ�');
        nSQL:='update %s set L_BDAX=''%s'',L_BDNUM=L_BDNUM+1 where L_ID = ''%s'' ';
        nSQL := Format(nSQL,[sTable_Bill, IntToStr(nMsg), FIn.FData]);
        gDBConnManager.WorkerExec(FDBConn,nSQL);

        if nMsg=1 then
        begin
          nYKMouney := FieldByName('L_TotalMoney').AsFloat;
          nCustAcc := FieldByName('L_CusID').AsString;
          nContQuota:= FieldByName('L_ContQuota').AsString;

          if nContQuota = '1' then
          begin
            nSQL:='Update %s Set A_ConFreezeMoney=A_ConFreezeMoney-(%s) Where A_CID=''%s''';
            nSQL:= Format(nSQL, [sTable_CusAccount, FormatFloat('0.00',nYKMouney), nCustAcc]);
          end else
          begin
            nSQL:='Update %s Set A_FreezeMoney=A_FreezeMoney-(%s) Where A_CID=''%s''';
            nSQL:= Format(nSQL, [sTable_CusAccount, FormatFloat('0.00',nYKMouney), nCustAcc]);
          end;
          
          gDBConnManager.WorkerExec(FDBConn,nSQL);
          WriteLog('['+FIn.FData+']Release YKMoney: '+nSQL);
        end;
        Result := True;
      end else
      begin
        WriteLog('����ֵ��'+IntToStr(nMsg)+','+FieldByName('P_ID').AsString+'ͬ��ʧ��');
        nSQL:='update %s set L_BDAX=''%s'',L_BDNUM=L_BDNUM+1 where L_ID = ''%s'' ';
        nSQL := Format(nSQL,[sTable_Bill, IntToStr(nMsg), FIn.FData]);
        gDBConnManager.WorkerExec(FDBConn,nSQL);
      end;
    except
      on e:Exception do
      begin
        nStr := FieldByName('P_ID').AsString+'���۰���ͬ��ʧ��.';
        WriteLog('AX�ӿ��쳣��'+#13#10+e.Message);
      end;
    end;
  end;
end;

function TWorkerBusinessCommander.SyncPurPoundBillAX(var nData: string):Boolean;//ͬ���������ɹ�����AX
var nID,nIdx: Integer;
    nStr,nWeightMan:string;
    nSQL: string;
    nService: BPM2ERPServiceSoap;
    nMsg:Integer;
    nsWeightTime:string;
begin
  Result := False;
  nSQL := 'select * From %s a, %s b, %s c where a.D_OID=b.O_ID and a.D_ID=c.P_Order and a.D_ID = ''%s'' and b.O_ifneidao<>''Y''';
  nSQL := Format(nSQL,[sTable_OrderDtl,sTable_Order,sTable_PoundLog,FIn.FData]);
  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  begin
    if RecordCount < 1 then
    begin
      nData := '�ɹ�����Ϊ[ %s ]�Ĳɹ�����������.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
    nsWeightTime:=formatdatetime('yyyy-mm-dd hh:mm:ss',FieldByName('D_PDate').AsDateTime);
    if nsWeightTime<>'' then
    begin
      nsWeightTime:=Copy(nsWeightTime,12,Length(nsWeightTime)-11);
    end;
    nStr := '<PRIMARY>';
    nStr := nStr+'<PurchId>'+FieldByName('O_BID').AsString+'</PurchId>';
    nStr := nStr+'<PurchLineRecid>'+FieldByName('O_BRecID').AsString+'</PurchLineRecid>';
    nStr := nStr+'<DlvModeId></DlvModeId>';
    nStr := nStr+'<applyvehicle></applyvehicle>';
    nStr := nStr+'<TareWeight>'+FieldByName('D_PValue').AsString+'</TareWeight>';
    nStr := nStr+'<GrossWeight>'+FieldByName('D_MValue').AsString+'</GrossWeight>';
    nStr := nStr+'<Netweight>'+FieldByName('D_Value').AsString+'</Netweight>';
    nStr := nStr+'<CMTCW></CMTCW>';
    nStr := nStr+'<VehicleNum>'+FieldByName('D_Truck').AsString+'</VehicleNum>';
    nStr := nStr+'<WeightMan>'+FieldByName('D_MMan').AsString+'</WeightMan>';
    nStr := nStr+'<WeightTime>'+nsWeightTime+'</WeightTime>';
    nStr := nStr+'<WeightDate>'+FieldByName('D_PDate').AsString+'</WeightDate>';
    nStr := nStr+'<description></description>';
    nStr := nStr+'<WeighingNum>'+FieldByName('P_ID').AsString+'</WeighingNum>';
    nStr := nStr+'<tabletransporter></tabletransporter>';
    nStr := nStr+'<COMPANYID>'+gCompanyAct+'</COMPANYID>';
    nStr := nStr+'<TransportBill></TransportBill>';
    nStr := nStr+'<TransportBillQty></TransportBillQty>';
    nStr := nStr+'</PRIMARY>';
    //----------------------------------------------------------------------------
    
    {$IFDEF DEBUG}
    WriteLog('����ֵ��'+nStr);
    {$ENDIF}
    try
      nService:=GetBPM2ERPServiceSoap(True,gURLAddr,nil);
      nMsg:=nService.WRZS2ERPInfo('WRZS_003',nStr,'000');
      if nMsg=1 then
      begin
        WriteLog('����ֵ��'+IntToStr(nMsg)+','+FieldByName('P_ID').AsString+'ͬ���ɹ�');
        nSQL:='update %s set D_BDAX=''1'',D_BDNUM=D_BDNUM+1 where D_ID = ''%s'' ';
        nSQL := Format(nSQL,[sTable_OrderDtl,FIn.FData]);
        gDBConnManager.WorkerExec(FDBConn,nSQL);
        Result := True;
      end else
      begin
        WriteLog('����ֵ��'+IntToStr(nMsg)+','+FieldByName('P_ID').AsString+'ͬ��ʧ��');
        nSQL:='update %s set D_BDNUM=D_BDNUM+1 where D_ID = ''%s'' ';
        nSQL := Format(nSQL,[sTable_OrderDtl,FIn.FData]);
        gDBConnManager.WorkerExec(FDBConn,nSQL);
      end;
    except
      on e:Exception do
      begin
        nStr := FieldByName('P_ID').AsString+'���۰���ͬ��ʧ��.';
        WriteLog('AX�ӿ��쳣��'+#13#10+e.Message);
      end;
    end;
  end;
end;

function TWorkerBusinessCommander.SyncVehicleNoAX(var nData: string):Boolean;//ͬ�����ŵ�AX
var nID,nIdx: Integer;
    nVal,nMoney: Double;
    nK3Worker: PDBWorker;
    nStr,nSQL,nBill,nStockID: string;
begin
  Result := False;
  nK3Worker := nil;
  nStr := AdjustListStrFormat(FIn.FData , '''' , True , ',' , True);

  nSQL := 'select * From $BL where T_Truck In ($IN)';
  nSQL := MacroValue(nSQL, [MI('$BL', sTable_Truck) , MI('$IN', nStr)]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL)  do
  try
    if RecordCount < 1 then
    begin
      nData := '���Ϊ[ %s ]�ĳ��Ų�����.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    nK3Worker := gDBConnManager.GetConnection(sFlag_DB_K3, FErrNum);
    if not Assigned(nK3Worker) then
    begin
      nData := '�������ݿ�ʧ��(DBConn Is Null).';
      Exit;
    end;

    if not nK3Worker.FConn.Connected then
      nK3Worker.FConn.Connected := True;
    //conn db

    FListA.Clear;
    First;

    while not Eof do
    begin
      nSQL := MakeSQLByStr([
        SF('VehicleId', FieldByName('T_Truck').AsString),
        SF('Name', FieldByName('').AsString),
        SF('CZ', FieldByName('T_Owner').AsString),
        SF('companyid', FieldByName('T_CompanyID').AsString),
        SF('XTECB', FieldByName('T_XTECB').AsString),
        SF('VendAccount', FieldByName('T_VendAccount').AsString),
        SF('Driver', FieldByName('T_Driver').AsString)
        ], sTable_AX_VehicleNo, '', True);
      FListA.Add(nSQL);
      Next;
      //xxxxx
    end;
  finally
    gDBConnManager.ReleaseConnection(nK3Worker);
  end;
  //----------------------------------------------------------------------------
  nK3Worker.FConn.BeginTrans;
  try
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(nK3Worker, FListA[nIdx]);
    //xxxxx

    nK3Worker.FConn.CommitTrans;
    Result := True;
  except
    nK3Worker.FConn.RollbackTrans;
    nStr := 'ͬ���������ݵ�AXϵͳʧ��.';
    raise Exception.Create(nStr);
  end;
end;

//��ȡ���۶�����Ϣ lih  2017-01-21
function TWorkerBusinessCommander.ReadZhikaInfo(var nData: string): Boolean;
var nStr, nRECID, nZID: string;
    nPos:Integer;
begin
  nStr := 'select D_RECID,' +                     //��ID
          '  D_ZID,' +                            //���ۿ�Ƭ���
          '  D_Type,' +                           //����(��,ɢ)
          '  D_StockNo,' +                        //ˮ����
          '  D_StockName,' +                      //ˮ������
          '  D_Price,' +                          //����
          '  D_TotalValue,' +                     //��������
          '  D_Value,' +                          //����ʣ����
          '  D_SalesStatus,' +                    //��״̬
          '  D_Blocked,' +                        //�Ƿ�ֹͣ
          '  D_Memo,' +                           //��ע��Ϣ
          '  Z_Man,' +                            //������
          '  Z_Date,' +                           //��������
          '  Z_Customer,' +                       //�ͻ����
          '  Z_Name,' +                           //�ͻ�����
          '  Z_Lading,' +                         //�����ʽ
          '  Z_CID,' +                            //��ͬ���
          '  Z_SalesStatus,' +                    //����״̬
          '  Z_SalesType,' +                      //��������
          '  Z_TriangleTrade,' +                  //����ó��
          '  Z_CompanyId,' +                      //��˾ID    ����ȷ������ó�׵Ŀͻ�����
          '  Z_XSQYBM,' +                         //�����������
          '  Z_KHSBM,' +                          //�ͻ�ʶ����
          '  Z_OrgAccountNum,' +                  //���տͻ�ID
          '  Z_OrgAccountName,' +                 //���տͻ�����
          '  Z_OrgXSQYBM ' +                      //���������������
          'from S_ZhiKa a join S_ZhiKaDtl b on a.Z_ID = b.D_ZID ' +
          'where ((Z_SalesType=''0'') or (Z_SalesType=''3'')) '+
          'and Z_SalesStatus=''1'' and D_Blocked=''0'' ';

  if FIn.FData <> '' then
  begin
    nPos := Pos(';',FIn.FData);
    if nPos > 0 then
    begin
      nZID := Copy(FIn.FData,1,nPos-1);
      nRECID :=Copy(FIn.FData,nPos+1,Length(FIn.FData)-nPos);
      nStr := nStr + Format(' and D_ZID=''%s'' and D_RECID=''%s'' ', [nZID,nRECID]);
    end else
      nStr := nStr + Format(' and D_ZID=''%s'' ', [FIn.FData]);
  end;
  //�����Ų�ѯ

  if FIn.FExtParam <> '' then
    nStr := nStr + Format(' and (%s)', [FIn.FExtParam]);
  //���Ӳ�ѯ����

  Result := False;
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      if FIn.FData = '' then
           nData := 'ϵͳ��δ�ҵ���������������.'
      else nData := Format('����:[ %s ]��Ч,�����Ѿ���ʧ.', [FIn.FData]);

      Exit;
    end;

    FListA.Clear;
    FListB.Clear;

    FListB.Values['XCB_ID']         := FieldByName('D_RECID').AsString;
    FListB.Values['XCB_CardId']     := FieldByName('D_ZID').AsString;
    FListB.Values['XCB_Origin']     := '';
    FListB.Values['XCB_BillID']     := FieldByName('Z_CID').AsString;
    FListB.Values['XCB_SetDate']    := Date2Str(FieldByName('Z_Date').AsDateTime,True);
    FListB.Values['XCB_CardType']   := FieldByName('Z_SalesType').AsString;
    FListB.Values['XCB_SourceType'] := '';
    FListB.Values['XCB_Option']     := '';
    if FieldByName('Z_TriangleTrade').AsString ='1' then
    begin
      FListB.Values['XCB_Client']     := FieldByName('Z_OrgAccountNum').AsString;
      FListB.Values['XCB_ClientName'] := FieldByName('Z_OrgAccountName').AsString;
      FListB.Values['XCB_Area']       := FieldByName('Z_OrgXSQYBM').AsString;
    end else
    begin
      FListB.Values['XCB_Client']     := FieldByName('Z_Customer').AsString;
      FListB.Values['XCB_ClientName'] := FieldByName('Z_Name').AsString;
      FListB.Values['XCB_Area']       := FieldByName('Z_XSQYBM').AsString;
    end;
    FListB.Values['XCB_WorkAddr']   := '';
    FListB.Values['XCB_Alias']      := '';
    FListB.Values['XCB_OperMan']    := '';

    FListB.Values['XCB_CementType'] := UpperCase(FieldByName('D_Type').AsString);
    FListB.Values['XCB_Cement']     := FieldByName('D_StockNo').AsString+UpperCase(FieldByName('D_Type').AsString);
    if UpperCase(FieldByName('D_Type').AsString) = 'D' then
      FListB.Values['XCB_CementName'] := FieldByName('D_StockName').AsString+'��װ'
    else
      FListB.Values['XCB_CementName'] := FieldByName('D_StockName').AsString+'ɢװ';
    FListB.Values['XCB_LadeType']   := FieldByName('Z_Lading').AsString;
    FListB.Values['XCB_Number']     := FloatToStr(FieldByName('D_TotalValue').AsFloat);
    FListB.Values['XCB_FactNum']    := '0';
    FListB.Values['XCB_PreNum']     := '0';
    FListB.Values['XCB_ReturnNum']  := '0';
    FListB.Values['XCB_OutNum']     := '0';
    FListB.Values['XCB_RemainNum']  := FloatToStr(FieldByName('D_Value').AsFloat);
    FListB.Values['XCB_AuditState'] := FieldByName('D_SalesStatus').AsString;
    FListB.Values['XCB_Status']     := FieldByName('D_Blocked').AsString;
    FListB.Values['XCB_IsOnly']     := '';
    FListB.Values['XCB_Del']        := '0';
    FListB.Values['XCB_Creator']    := FieldByName('Z_Man').AsString;
    FListB.Values['XCB_CreatorNM']  := FieldByName('Z_Man').AsString;
    FListB.Values['XCB_CDate']      := DateTime2Str(FieldByName('Z_Date').AsDateTime);
    FListB.Values['XCB_Firm']       := '';
    FListB.Values['XCB_FirmName']   := '';
    FListB.Values['pcb_id']         := '';
    FListB.Values['pcb_name']       := '';
    FListB.Values['XCB_TransID']    := '';
    FListB.Values['XCB_TransName']  := '';

    FListA.Add(PackerEncodeStr(FListB.Text));
    FOut.FData := PackerEncodeStr(FListA.Text);
    Result := True;
  end;
end;

//��ȡ�������ϼ۸� lih  2017-02-07
function TWorkerBusinessCommander.ReadStockPrice(var nData: string): Boolean;
var nStr,nRecID: string;
    nPos: Integer;
begin
  if FIn.FData <> '' then
  begin
    nPos := Pos(';',FIn.FData);
    if nPos > 0 then
      nRecID := Copy(FIn.FData,nPos+1,Length(FIn.FData)-nPos)
    else
      nRecID := FIn.FData;
  end else
  begin
    Exit;
  end;
  nStr := 'Select top 1 A_SalesNewAmount From '+sTable_AddTreaty+
          ' Where RefRecid='''+nRecID+
          ''' and convert(varchar(10),A_TakeEffectDate,23)+'' ''+'+
          'CONVERT(varchar(2),A_TakeEffectTime/(60*60*1000))+'':''+'+
          'CONVERT(varchar(2),(A_TakeEffectTime%(60*60*1000))/(60*1000))+'':''+'+
          'CONVERT(varchar(2),((A_TakeEffectTime%(60*60*1000))%(60*1000))/1000)+''.''+'+
          'CONVERT(varchar(3),A_TakeEffectTime%1000)<= convert(varchar(23),GETDATE(),21) order by Recid desc';
  Result := False;
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount < 1 then
  begin
    nStr := 'Select D_Price From %s Where D_Blocked=''0'' and D_RECID=''%s''';
    nStr := Format(nStr, [sTable_ZhiKaDtl, nRecID]);
    with gDBConnManager.WorkerQuery(FDBConn,nStr) do
    if RecordCount < 1 then
    begin
      FOut.FData := '0.00';
      Exit;
    end else
    begin
      FOut.FData := Fields[0].AsString;
      Result := True;
    end;
  end else
  begin
    FOut.FData := Fields[0].AsString;
    Result := True;
  end;
end;


//Date: 2016-09-20
//Parm: ��α��[FIn.FData]
//Desc: ��α��У��
function TWorkerBusinessCommander.CheckSecurityCodeValid(var nData: string): Boolean;
var
  nStr,nCode,nBill_id: string;
  nSprefix:string;
  nIdx,nIdlen:Integer;
  nDs:TDataSet;
  nBills: TLadingBillItems;
begin
  nSprefix := '';
  nidlen := 0;
  Result := True;
  nCode := FIn.FData;
  if nCode='' then
  begin
    nData := '';
    FOut.FData := nData;
    Exit;
  end;

  nStr := 'Select B_Prefix, B_IDLen From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_BillNo]);
  nDs :=  gDBConnManager.WorkerQuery(FDBConn, nStr);

  if nDs.RecordCount>0 then
  begin
    nSprefix := nDs.FieldByName('B_Prefix').AsString;
    nIdlen := nDs.FieldByName('B_IDLen').AsInteger;
    nIdlen := nIdlen-length(nSprefix);
  end;

  //�����������
  nBill_id := nSprefix+Copy(nCode,Length(nCode)-nIdlen+1,nIdlen);

  //��ѯ���ݿ�
  nStr := 'Select L_ID,L_ZhiKa,L_CusID,L_CusName,L_Type,L_StockNo,' +
      'L_StockName,L_Truck,L_Value,L_Price,L_ZKMoney,L_Status,' +
      'L_NextStatus,L_Card,L_IsVIP,L_PValue,L_MValue From $Bill b ';
  nStr := nStr + 'Where L_ID=''$CD''';
  nStr := MacroValue(nStr, [MI('$Bill', sTable_Bill), MI('$CD', nBill_id)]);

  nDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
  if nDs.RecordCount<1 then
  begin
    SetLength(nBills, 1);
    ZeroMemory(@nBills[0],0);
    FOut.FData := CombineBillItmes(nBills);
    Exit;
  end;

  SetLength(nBills, nDs.RecordCount);
  nIdx := 0;
  nDs.First;
  while not nDs.eof do
  begin
    with  nBills[nIdx] do
    begin
      FID         := nDs.FieldByName('L_ID').AsString;
      FZhiKa      := nDs.FieldByName('L_ZhiKa').AsString;
      FCusID      := nDs.FieldByName('L_CusID').AsString;
      FCusName    := nDs.FieldByName('L_CusName').AsString;
      FTruck      := nDs.FieldByName('L_Truck').AsString;

      FType       := nDs.FieldByName('L_Type').AsString;
      FStockNo    := nDs.FieldByName('L_StockNo').AsString;
      FStockName  := nDs.FieldByName('L_StockName').AsString;
      FValue      := nDs.FieldByName('L_Value').AsFloat;
      FPrice      := nDs.FieldByName('L_Price').AsFloat;

      FCard       := nDs.FieldByName('L_Card').AsString;
      FIsVIP      := nDs.FieldByName('L_IsVIP').AsString;
      FStatus     := nDs.FieldByName('L_Status').AsString;
      FNextStatus := nDs.FieldByName('L_NextStatus').AsString;
      FSelected := True;
      if FIsVIP = sFlag_TypeShip then
      begin
        FStatus    := sFlag_TruckZT;
        FNextStatus := sFlag_TruckOut;
      end;

      if FStatus = sFlag_BillNew then
      begin
        FStatus     := sFlag_TruckNone;
        FNextStatus := sFlag_TruckNone;
      end;

      FPData.FValue := nDs.FieldByName('L_PValue').AsFloat;
      FMData.FValue := nDs.FieldByName('L_MValue').AsFloat;
    end;

    Inc(nIdx);
    nDs.Next;
  end;

  FOut.FData := CombineBillItmes(nBills);
end;

//Date: 2016-09-20
//Parm: 
//Desc: ������װ��ѯ
function TWorkerBusinessCommander.GetWaitingForloading(var nData: string):Boolean;
var nFind: Boolean;
    nLine: PLineItem;
    nIdx,nInt, i: Integer;
    nQueues: TQueueListItems;
begin
  gTruckQueueManager.RefreshTrucks(True);
  Sleep(320);
  //ˢ������

  with gTruckQueueManager do
  try
    SyncLock.Enter;
    Result := True;

    FListB.Clear;
    FListC.Clear;

    i := 0;
    SetLength(nQueues, 0);
    //�����ѯ��¼

    for nIdx:=0 to Lines.Count - 1 do
    begin
      nLine := Lines[nIdx];

      nFind := False;
      for nInt:=Low(nQueues) to High(nQueues) do
      begin
        with nQueues[nInt] do
          if FStockNo = nLine.FStockNo then
          begin
            Inc(FLineCount);
            FTruckCount := FTruckCount + nLine.FRealCount;

            nFind := True;
            Break;
          end;
      end;

      if not nFind then
      begin
        SetLength(nQueues, i+1);
        with nQueues[i] do
        begin
          FStockNO    := nLine.FStockNo;
          FStockName  := nLine.FStockName;

          FLineCount  := 1;
          FTruckCount := nLine.FRealCount;
        end;

        Inc(i);
      end;
    end;

    for nIdx:=Low(nQueues) to High(nQueues) do
    begin
      with FListB, nQueues[nIdx] do
      begin
        Clear;

        Values['StockName'] := FStockName;
        Values['LineCount'] := IntToStr(FLineCount);
        Values['TruckCount']:= IntToStr(FTruckCount);
      end;

      FListC.Add(PackerEncodeStr(FListB.Text));
    end;

    FOut.FData := PackerEncodeStr(FListC.Text);
  finally
    SyncLock.Leave;
  end;
end;

//����������ѯ���ɹ������������۳������� lih 2017-04-19
function TWorkerBusinessCommander.GetInOutFactoryTatol(var nData:string):Boolean;
var
  nStr,nExtParam:string;
  nType,nStartDate,nEndDate:string;
  nPos:Integer;
begin
  Result := False;
  nType := Trim(fin.FData);
  nExtParam := Trim(FIn.FExtParam);
  if (nType='') or (nExtParam='') then Exit;

  nPos := Pos('and',nExtParam);
  if nPos > 0 then
  begin
    nStartDate := Copy(nExtParam,1,nPos-1)+' 00:00:00';
    nEndDate := Copy(nExtParam,nPos+3,Length(nExtParam)-nPos-2)+' 23:59:59';
  end;

  {if nType='S' then
  begin
    nStr := 'select L_StockName as StockName,'+
            'Count(R_ID) as TruckCount,'+
            'SUM(L_Value) as StockValue from %s '+
            'where L_OutFact >=''%s'' and L_OutFact <=''%s'' '+
            'and L_IfNeiDao=''N'' '+
            'group by L_StockName '+
            'union '+
            'select ''�ڲ�����'' as StockName,'+
            'Count(R_ID) as TruckCount,'+
            'SUM(L_Value) as StockValue from %s '+
            'where L_OutFact >=''%s'' and L_OutFact <=''%s'' '+
            'and L_IfNeiDao=''N'' ';
    nStr := Format(nStr,[sTable_Bill,nStartDate,nEndDate]);
  end else
  begin
    nStr := 'select D_StockName as StockName,'+
            'Count(R_ID) as TruckCount,'+
            'SUM(D_Value) as StockValue from %s '+
            'where D_OutFact >=''%s'' and D_OutFact <=''%s'' group by D_StockName ';
    nStr := Format(nStr,[sTable_OrderDtl,nStartDate,nEndDate]);
  end;}
  nStr := 'EXEC SP_InOutFactoryTotal '''+nType+''','''+nStartDate+''','''+nEndDate+''' ';

  //WriteLog(nStr);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := 'δ��ѯ���ͻ����[ %s ]��Ӧ�Ķ�����Ϣ.';
      Exit;
    end;

    FListA.Clear;
    FListB.Clear;
    First;

    while not Eof do
    begin
      FListB.Values['StockName'] := FieldByName('StockName').AsString;
      FListB.Values['TruckCount'] := FieldByName('TruckCount').AsString;
      FListB.Values['StockValue'] := FieldByName('StockValue').AsString;

      FListA.Add(PackerEncodeStr(FListB.Text));
      Next;
    end;

    FOut.FData := PackerEncodeStr(FListA.Text);
    Result := True;
  end;
end;

//Date: 2016-09-23
//Parm:
//Desc: ���϶������µ�������ѯ
function TWorkerBusinessCommander.GetBillSurplusTonnage(var nData:string):boolean;
var nStr,nCusID: string;
    nVal,nCredit,nPrice: Double;
    nStockNo:string;
begin
  nCusID := '';
  nStockNo := '';
  nPrice := 1;
  nCredit := 0;
  nVal := 0;
  Result := False;
  nCusID := Fin.FData;
  if nCusID='' then Exit;  
  //δ���ݿͻ���

  nStockNo := Fin.FExtParam;
  if nStockNo='' then Exit;
  //δ���ݲ�Ʒ���

  //��Ʒ���ۼ۸�����ѯ����
  nStr := 'select p_price from %s where P_StockNo=''%s'' order by P_Date desc';
  //nStr := Format(nStr, [sTable_SPrice, nStockNo]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := 'δ�赥�ۣ���ѯʧ��!';
      Exit;
    end;
    nPrice := FieldByName('p_price').AsFloat;
    if Float2PInt(nPrice, 100000, False)<=0 then
    begin
      nData := '�������ò���ȷ����ѯʧ��!';
      Exit;    
    end;
  end;

  //����GetCustomerValidMoney��ѯ���ý��
  Result := GetCustomerValidMoney(nData);
  if not Result then Exit;
  nVal := StrToFloat(FOut.FData);
  if Float2PInt(nVal, cPrecision, False)<=0 then
  begin
    nData := '���Ϊ[ %s ]�Ŀͻ��˻����ý���.';
    nData := Format(nData, [nCusID]);
    Exit;
  end;
  FOut.FData := FormatFloat('0.0000',nVal/nPrice);
  Result := True;  
end;

//��ȡ������Ϣ�����������µ�
function TWorkerBusinessCommander.GetOrderInfo(var nData:string):Boolean;
var nList: TStrings;
    nOut: TWorkerBusinessCommand;
    nCard,nParam:string;
    nLoginAccount,nLoginCusId,nOrderCusId:string;
    nSql:string;
    nDataSet:TDataSet;
    nOrderValid:Boolean;
begin
  nCard := fin.FData;
  nLoginAccount := FIn.FExtParam;
  nParam := sFlag_LoadExtInfo;
  Result := CallMe(cBC_ReadZhiKaInfo, nCard, '', @nOut);
  if not Result then
  begin
    nCard := nOut.FBase.FErrDesc;
    Exit;
  end;
  nList := TStringList.Create;
  try
    nList.Text := PackerDecodeStr(nOut.FData);
    nCard := nList[0];
    //cBC_ReadZhiKaInfo��ȡָ�������ȡ����,ȡ��һ��
  finally
    nList.Free;
  end;
  FOut.FData := nCard;

  //------��αУ��begin-------
  nList := TStringList.Create;
  try
    nList.Text := PackerDecodeStr(nCard);
    nOrderCusId := nList.Values['XCB_Client'];
  finally
    nList.Free;
  end;

  nSql := 'select i_itemid from %s where i_group=''%s'' and i_item=''%s'' and i_info=''%s''';
  nSql := Format(nSql,[sTable_ExtInfo,sFlag_CustomerItem,'�ֻ�',nLoginAccount]);

  nDataSet := gDBConnManager.WorkerQuery(FDBConn, nSql);
  //δ�ҵ�ע����ֻ���
  if nDataSet.RecordCount<1 then
  begin
    nData := 'δ�ҵ�ע����ֻ�����';
    nout.FBase.FErrDesc := nData;  
    Result := False;
    Exit;
  end;

  nOrderValid := False;
    
  while not nDataSet.Eof do
  begin
    nLoginCusId := nDataSet.FieldByName('i_itemid').AsString;
    if nLoginCusId=nOrderCusId then
    begin
      nOrderValid := True;
      Break;
    end;
    nDataSet.Next;
  end;

  if not nOrderValid then
  begin
    nData := '����ð�������ͻ��Ķ�����.';
    nout.FBase.FErrDesc := nData;  
    Result := False;
    Exit;  
  end;
  //------��αУ��end-------
end;

//��ȡ�����б����������µ�
function TWorkerBusinessCommander.GetOrderList(var nData:string):Boolean;
var
  nCusId,nStr:string;
begin
  Result := False;
  nCusId := Trim(fin.FData);
  if nCusId='' then Exit;
  nStr := 'select D_RECID,' +                   //��ID
        '  D_ZID,' +                            //���ۿ�Ƭ���
        '  D_Type,' +                           //����(��,ɢ)
        '  D_StockNo,' +                        //ˮ����
        '  D_StockName,' +                      //ˮ������
        '  D_Price,' +                          //����
        '  D_TotalValue,' +                     //��������
        '  D_Value,' +                          //����ʣ����
        '  D_SalesStatus,' +                    //��״̬
        '  D_Blocked,' +                        //�Ƿ�ֹͣ
        '  D_Memo,' +                           //��ע��Ϣ
        '  Z_Man,' +                            //������
        '  Z_Date,' +                           //��������
        '  Z_Customer,' +                       //�ͻ����
        '  Z_Name,' +                           //�ͻ�����
        '  Z_Lading,' +                         //�����ʽ
        '  Z_CID,' +                            //��ͬ���
        '  Z_SalesStatus,' +                    //����״̬
        '  Z_SalesType,' +                      //��������
        '  Z_TriangleTrade,' +                  //����ó��
        '  Z_CompanyId,' +                      //��˾ID    ����ȷ������ó�׵Ŀͻ�����
        '  Z_XSQYBM,' +                         //�����������
        '  Z_KHSBM,' +                          //�ͻ�ʶ����
        '  Z_OrgAccountNum,' +                  //���տͻ�ID
        '  Z_OrgAccountName,' +                 //���տͻ�����
        '  Z_OrgXSQYBM ' +                      //���������������
        'from S_ZhiKa a join S_ZhiKaDtl b on a.Z_ID = b.D_ZID ' +
        'where ((Z_SalesType=''0'') or (Z_SalesType=''3'')) '+
        'and Z_SalesStatus=''1'' and D_Blocked=''0'' '+
        'and ((Z_TriangleTrade=''1'' and Z_OrgAccountNum=''%s'') or (Z_TriangleTrade<>''1'' and Z_Customer=''%s''))';
        //����ʣ��������0��δ�ᶩ����������δֹͣ״̬
  nStr := Format(nStr,[nCusId,nCusId]);
  //WriteLog(nStr);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('δ��ѯ���ͻ����[ %s ]��Ӧ�Ķ�����Ϣ.', [nCusId]);
      Exit;
    end;

    FListA.Clear;
    FListB.Clear;
    First;

    while not Eof do
    begin
      FListB.Values['XCB_ID']         := FieldByName('D_RECID').AsString;
      FListB.Values['XCB_CardId']     := FieldByName('D_ZID').AsString+';'+FieldByName('D_RECID').AsString;
      FListB.Values['XCB_Origin']     := '';
      FListB.Values['XCB_BillID']     := FieldByName('Z_CID').AsString;
      FListB.Values['XCB_SetDate']    := Date2Str(FieldByName('Z_Date').AsDateTime,True);
      FListB.Values['XCB_CardType']   := FieldByName('Z_SalesType').AsString;
      FListB.Values['XCB_SourceType'] := '';
      FListB.Values['XCB_Option']     := FieldByName('D_Memo').AsString;
      if FieldByName('Z_TriangleTrade').AsString ='1' then
      begin
        FListB.Values['XCB_Client']     := FieldByName('Z_OrgAccountNum').AsString;
        FListB.Values['XCB_ClientName'] := FieldByName('Z_OrgAccountName').AsString;
        FListB.Values['XCB_Area']       := FieldByName('Z_OrgXSQYBM').AsString;
      end else
      begin
        FListB.Values['XCB_Client']     := FieldByName('Z_Customer').AsString;
        FListB.Values['XCB_ClientName'] := FieldByName('Z_Name').AsString;
        FListB.Values['XCB_Area']       := FieldByName('Z_XSQYBM').AsString;
      end;
      FListB.Values['XCB_WorkAddr']   := '';
      FListB.Values['XCB_Alias']      := '';
      FListB.Values['XCB_OperMan']    := '';

      FListB.Values['XCB_Cement']     := FieldByName('D_StockNo').AsString+UpperCase(FieldByName('D_Type').AsString);
      if UpperCase(FieldByName('D_Type').AsString) = 'D' then
        FListB.Values['XCB_CementName'] := FieldByName('D_StockName').AsString+'��װ'
      else
        FListB.Values['XCB_CementName'] := FieldByName('D_StockName').AsString+'ɢװ';
      FListB.Values['XCB_LadeType']   := FieldByName('Z_Lading').AsString;
      FListB.Values['XCB_Number']     := FloatToStr(FieldByName('D_TotalValue').AsFloat);
      FListB.Values['XCB_FactNum']    := '0';
      FListB.Values['XCB_PreNum']     := '0';
      FListB.Values['XCB_ReturnNum']  := '0';
      FListB.Values['XCB_OutNum']     := '0';
      FListB.Values['XCB_RemainNum']  := FloatToStr(FieldByName('D_Value').AsFloat);
      FListB.Values['XCB_AuditState'] := FieldByName('D_SalesStatus').AsString;
      FListB.Values['XCB_Status']     := FieldByName('D_Blocked').AsString;
      FListB.Values['XCB_IsOnly']     := '';
      FListB.Values['XCB_Del']        := '0';
      FListB.Values['XCB_Creator']    := FieldByName('Z_Man').AsString;
      FListB.Values['XCB_CreatorNM']  := FieldByName('Z_Man').AsString;
      FListB.Values['XCB_CDate']      := DateTime2Str(FieldByName('Z_Date').AsDateTime);
      FListB.Values['XCB_Firm']       := '';
      FListB.Values['XCB_FirmName']   := '';
      FListB.Values['pcb_id']         := '';
      FListB.Values['pcb_name']       := '';
      FListB.Values['XCB_TransID']    := '';
      FListB.Values['XCB_TransName']  := '';

      FListA.Add(PackerEncodeStr(FListB.Text));
      Next;
    end;

    FOut.FData := PackerEncodeStr(FListA.Text);
    Result := True;
  end;
end;

//��ȡ�ɹ������б����������µ�
function TWorkerBusinessCommander.GetPurchaseContractList(var nData:string):Boolean;
var nStr:string;
    nProID:string;
begin
  Result := False;
  nProID := Trim(FIn.FData);
  if nProID = '' then Exit;
  nStr := 'Select *,(B_Value-IsNull(B_SentValue,0)-IsNull(B_FreezeValue,0)) As B_MaxValue From %s a, %s b ' +
          'Where a.B_ID=b.M_ID ' +
          'And ((B_BStatus=''Y'') or (B_BStatus=''1'') or ((M_PurchType=''0'') and (B_BStatus=''0''))) '+
          'and B_Blocked=''0'' and M_ProID = ''%s'' ';
  nStr := Format(nStr , [sTable_OrderBase,sTable_OrderBaseMain, nProID]);
  
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('δ��ѯ����Ӧ��[ %s ]��Ӧ�Ķ�����Ϣ.', [FIn.FData]);
      Exit;
    end;

    FListA.Clear;
    FListB.Clear;
    First;
    while not Eof do
    try
      FListB.Values['pcId'] := FieldByName('M_ID').AsString+';'+FieldByName('B_RecID').AsString;
      FListB.Values['provider_code'] := FieldByName('M_ProID').AsString;
      FListB.Values['provider_name'] := FieldByName('M_ProName').AsString;
      FListB.Values['con_code'] := FieldByName('B_RecID').AsString;
      FListB.Values['con_materiel_Code'] := FieldByName('B_StockNo').AsString;
      FListB.Values['con_materiel_name'] := FieldByName('B_StockName').AsString;
      FListB.Values['con_price'] := FieldByName('B_RestValue').AsString; //����ʣ����
      FListB.Values['con_quantity'] := FieldByName('B_Value').AsString;
      FListB.Values['con_finished_quantity'] := FieldByName('B_SentValue').AsString;
      FListB.Values['con_date'] := DateTime2Str(FieldByName('B_Date').AsDateTime);
      FListB.Values['con_remark'] := FieldByName('B_Memo').AsString;
      FListA.Add(PackerEncodeStr(FListB.Text));

    finally
      Next;
    end;
  end;  

  FOut.FData := PackerEncodeStr(FListA.Text);
  Result := True;
end;

//��ȡ�ͻ�ע����Ϣ
function TWorkerBusinessCommander.getCustomerInfo(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_getCustomerInfo);
  if Result then
       FOut.FData := nOut.FData
  else nData := nOut.FData;
end;

//�ͻ���΢���˺Ű�
function TWorkerBusinessCommander.get_Bindfunc(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_get_Bindfunc);
  if Result then
       FOut.FData := sFlag_Yes
  else nData := nOut.FData;
end;

//������Ϣ
function TWorkerBusinessCommander.send_event_msg(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_send_event_msg);
  if Result then
       FOut.FData := sFlag_Yes
  else nData := nOut.FData;
end;

//�����̳��û�
function TWorkerBusinessCommander.edit_shopclients(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_edit_shopclients);
  if Result then
       FOut.FData := sFlag_Yes
  else nData := nOut.FData;
end;

//�����Ʒ
function TWorkerBusinessCommander.edit_shopgoods(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_edit_shopgoods);
  if Result then
       FOut.FData := sFlag_Yes
  else nData := nOut.FData;
end;

//��ȡ������Ϣ
function TWorkerBusinessCommander.get_shoporders(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_get_shoporders);
  if Result then
       FOut.FData := nOut.FData
  else nData := nOut.FData;
end;

//���ݶ����Ż�ȡ������Ϣ
function TWorkerBusinessCommander.get_shoporderbyno(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_get_shoporderbyNO);
  if Result then
       FOut.FData := nOut.FData
  else nData := nOut.FData;
end;

//���ݻ����Ż�ȡ������Ϣ-ԭ����
function TWorkerBusinessCommander.get_shopPurchasebyNO(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_get_shopPurchasebyNO);
  if Result then
       FOut.FData := nOut.FData
  else nData := nOut.FData;
end;

//�޸Ķ���״̬
function TWorkerBusinessCommander.complete_shoporders(var nData:string):Boolean;
var nOut: TWorkerBusinessCommand;
begin
  Result := CallRemoteWorker(sCLI_BusinessWebchat, FIn.FData, '', @nOut,
            cBC_WeChat_complete_shoporders);
  if Result then
       FOut.FData := sFlag_Yes
  else nData := nOut.FData;
end;

//Date: 2016-10-30
//Parm: �ſ�;����
//Desc: ��ȡnCard����ʱ��������
function TWorkerBusinessOrders.LoadOtherByCard(const nItems: TLadingBillItems;const nCard: string;
  var nData: string): Boolean;
var nStr: string;
  nDs:TDataSet;
  nysline:Pysline;
begin
  Result := True;
  nStr := 'Select * from %s Where O_Card=''%s''';
  nStr := Format(nStr, [sTable_CardOther, nCard]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '��Ƭ[ %s ]�ϵ���ʱ�������ݶ�ʧ.';
      nData := Format(nData, [nCard]);

      Result := False;
      Exit;
    end;

    FPacker.StrBuilder.Clear;
    FListB.Clear;
    First;
    
    while not Eof do
    with FListB do
    begin
      Values['ID']      := FieldByName('R_ID').AsString;
      Values['Card']    := FieldByName('O_Card').AsString;
      Values['CardUsed']:= sFlag_Other;
      Values['CardKeep']:= FieldByName('O_KeepCard').AsString;
      Values['Truck']   := FieldByName('O_Truck').AsString;

      Values['CusID']   := FieldByName('O_CusID').AsString;
      Values['CusName'] := FieldByName('O_CusName').AsString;

      Values['Type']    := FieldByName('O_MType').AsString;
      Values['Stock']   := FieldByName('O_MName').AsString;
      Values['StockName']   := FieldByName('O_MName').AsString;
      Values['StockID'] := FieldByName('O_MID').AsString;
      Values['Value']   := FieldByName('O_LimVal').AsString;

      Values['Status']  := FieldByName('O_Status').AsString;
      Values['NextStatus']    := FieldByName('O_NextStatus').AsString;

      values['PDate'] := Datetime2Str(FieldByName('O_BFPTime').AsDateTime);
      values['PMan'] := FieldByName('O_BFPMan').AsString;
      values['PValue'] := FloatToStr(FieldByName('O_BFPValue').AsFloat);

      values['MDate'] := Datetime2Str(FieldByName('O_BFMTime').AsDateTime);
      values['MMan'] := FieldByName('O_BFMMan').AsString;
      values['MValue'] := FloatToStr(FieldByName('O_BFMValue').AsFloat);
      Values['YSTDNO'] := FieldByName('o_YSTDNO').AsString;
      nStr := 'select p_id from %s where p_truck=''%s'' and p_pvalue>0.0001 and p_mvalue is null';
      nStr := Format(nStr,[sTable_PoundLog,FieldByName('O_Truck').AsString]);
      nDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
      if nDs.RecordCount>0 then
      begin
        Values['PoundID'] := nDs.FieldByName('p_id').AsString;
      end;
      nysline := GetYsLine(Values['YSTDNO']);
      if Assigned(nysline) then
      begin
        if nysline.FYS_Valid=sflag_yes then
        begin
          values['NeiDao'] := sFlag_Yes;
        end;
        Dispose(nysline);
      end;      
      FPacker.StrBuilder.Add(PackerEncodeStr(FListB.Text));
      Next;
    end;

    FOut.FData := PackerEncodeStr(FPacker.StrBuilder.Text);
  end;
end;

function TWorkerBusinessOrders.GetYsLine(const nYSno:string):PYSLine;
var nStr: string;
  nDs:TDataSet;
begin
  Result := nil;
  nStr := 'Select * from %s Where Y_id=''%s''';
  nStr := Format(nStr, [sTable_YSLines, nYSno]);
  writelog('GetYsLine.sql=['+nStr+']');
  nDs := gDBConnManager.WorkerQuery(FDBConn, nStr);
  if nDs.RecordCount>0 then
  begin
    New(Result);
    Result.FY_ID := nYSno;
    Result.FY_Name := nds.FieldByName('Y_Name').AsString;
    Result.FY_StockNo := nds.FieldByName('Y_StockNo').AsString;
    Result.FY_Stock := nds.FieldByName('Y_Stock').AsString;
    Result.FY_StockType := nds.FieldByName('Y_Stock').AsString;
    Result.FY_PeerWeight := nds.FieldByName('Y_PeerWeight').AsInteger;
    Result.FY_QueueMax := nds.FieldByName('Y_QueueMax').AsInteger;
    Result.FY_VIPLine := nds.FieldByName('Y_VIPLine').AsString;
    Result.FY_Valid := nds.FieldByName('Y_Valid').AsString;
    Result.FY_Index := nds.FieldByName('Y_Index').AsInteger;
    Result.FYS_Valid := nds.FieldByName('YS_Valid').AsString;
  end;
end;

function TWorkerBusinessOrders.getPrePInfo(const nTruck:string;var nPrePValue:Double;var nPrePMan:string;var nPrePTime:TDateTime):Boolean;
var
  nStr:string;
begin
  Result := False;
  nPrePValue := 0;
  nPrePMan := '';
  nPrePTime := now;
  nStr := 'select T_PrePValue,T_PrePMan,T_PrePTime from %s where t_truck=''%s'' and T_PrePUse=''%s''';
  nStr := format(nStr,[sTable_Truck,nTruck,sflag_yes]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
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

{//��ȡ�ͻ�ע����Ϣ
function TWorkerBusinessCommander.getCustomerInfo(var nData:string):Boolean;
var
  frmCall:TFrmCallWechatWebService;
begin
  Result := False;
  frmCall := TFrmCallWechatWebService.Create(nil);
  try
    Result := frmCall.ExecuteWebAction(cBC_WeChat_getCustomerInfo,fin.FData);
    nData := fin.FData;
    FOut.FData := fin.FData;
  finally
    frmCall.Free;
  end;
end;

//�ͻ���΢���˺Ű�
function TWorkerBusinessCommander.get_Bindfunc(var nData:string):Boolean;
var
  frmCall:TFrmCallWechatWebService;
begin
  Result := False;
  frmCall := TFrmCallWechatWebService.Create(nil);
  try
    Result := frmCall.ExecuteWebAction(cBC_WeChat_get_Bindfunc,fin.FData);
    FOut.FData := 'Y';
  finally
    frmCall.Free;
  end;
end;

//������Ϣ
function TWorkerBusinessCommander.send_event_msg(var nData:string):Boolean;
var
  frmCall:TFrmCallWechatWebService;
begin
  Result := False;
  frmCall := TFrmCallWechatWebService.Create(nil);
  try
    Result := frmCall.ExecuteWebAction(cBC_WeChat_send_event_msg,fin.FData);
//    Result := gFrmCallWechatWebService.ExecuteWebAction(cBC_WeChat_send_event_msg,fin.FData);
    FOut.FData := 'Y';
  finally
    frmCall.Free;
  end;
end;

//�����̳��û�
function TWorkerBusinessCommander.edit_shopclients(var nData:string):Boolean;
var
  frmCall:TFrmCallWechatWebService;
begin
  Result := False;
  frmCall := TFrmCallWechatWebService.Create(nil);
  try
    Result := frmCall.ExecuteWebAction(cBC_WeChat_edit_shopclients,fin.FData);
//    Result := gFrmCallWechatWebService.ExecuteWebAction(cBC_WeChat_edit_shopclients,fin.FData);
    FOut.FData := 'Y';
  finally
    frmCall.Free;
  end;
end;

//�����Ʒ
function TWorkerBusinessCommander.edit_shopgoods(var nData:string):Boolean;
var
  frmCall:TFrmCallWechatWebService;
begin
  Result := False;
  frmCall := TFrmCallWechatWebService.Create(nil);
  try
    Result := frmCall.ExecuteWebAction(cBC_WeChat_edit_shopgoods,fin.FData);
//    Result := gFrmCallWechatWebService.ExecuteWebAction(cBC_WeChat_edit_shopgoods,fin.FData);
  finally
    frmCall.Free;
  end;
end;

//��ȡ������Ϣ
function TWorkerBusinessCommander.get_shoporders(var nData:string):Boolean;
var
  frmCall:TFrmCallWechatWebService;
begin
  Result := False;
  frmCall := TFrmCallWechatWebService.Create(nil);
  try
    Result := frmCall.ExecuteWebAction(cBC_WeChat_get_shoporders,fin.FData);
//    Result := gFrmCallWechatWebService.ExecuteWebAction(cBC_WeChat_get_shoporders,fin.FData);
    nData := fin.FData;
    FOut.FData := fin.FData;
  finally
    frmCall.Free;
  end;
end;

//���ݶ����Ż�ȡ������Ϣ
function TWorkerBusinessCommander.get_shoporderbyno(var nData:string):Boolean;
var
  frmCall:TFrmCallWechatWebService;
begin
  Result := False;
  frmCall := TFrmCallWechatWebService.Create(nil);
  try
    Result := frmCall.ExecuteWebAction(cBC_WeChat_get_shoporderbyNO,fin.FData);
//    Result := gFrmCallWechatWebService.ExecuteWebAction(cBC_WeChat_get_shoporders,fin.FData);
    nData := fin.FData;
    FOut.FData := fin.FData;
  finally
    frmCall.Free;
  end;
end;

//���ݻ����Ż�ȡ������Ϣ-ԭ����
function TWorkerBusinessCommander.get_shopPurchasebyNO(var nData:string):Boolean;
var
  frmCall:TFrmCallWechatWebService;
begin
  Result := False;
  frmCall := TFrmCallWechatWebService.Create(nil);
  try
    Result := frmCall.ExecuteWebAction(cBC_WeChat_get_shopPurchasebyNO,fin.FData);
    nData := fin.FData;
    FOut.FData := fin.FData;
  finally
    frmCall.Free;
  end;
end;

//�޸Ķ���״̬
function TWorkerBusinessCommander.complete_shoporders(var nData:string):Boolean;
var
  frmCall:TFrmCallWechatWebService;
begin
  Result := False;
  frmCall := TFrmCallWechatWebService.Create(nil);
  try
    Result := frmCall.ExecuteWebAction(cBC_WeChat_complete_shoporders,fin.FData);
//    Result := gFrmCallWechatWebService.ExecuteWebAction(cBC_WeChat_get_shoporders,fin.FData);
    FOut.FData := 'Y';
  finally
    frmCall.Free;
  end;
end;}

function TWorkerBusinessCommander.GetSampleID(var nData: string):Boolean;//��ȡ�������
var
  nStr:string;
  nIdx:Integer;
begin
  Result := True;
  SetLength(FHuaYan, 0);
  FOut.FData := '';
  {$IFDEF QHSN}
    nStr := ' select R_SerialNo,R_BatQuaStart-R_BatQuaEnd as PCL,'
            +' (select SUM(L_Value) as zl from S_Bill where L_HYDan=R_SerialNo) as ZL from %s a,%s b'
            +' where a.R_PID = b.P_ID and b.P_Stock= ''%s'' and R_CenterID=''%s'''
            +' and R_BatValid=''%s'''
            +' union '
            +' select R_SerialNo,R_BatQuaStart-R_BatQuaEnd as PCL,'
            +' (select SUM(L_Value) as zl from S_Bill where L_HYDan=R_SerialNo) as ZL from %s a,%s b'
            +' where a.R_PID = b.P_ID and b.P_Stock= ''%s'' and R_CenterID=''%s'''
            +' and R_BatValid=''%s'''
            +' union '
            +' select R_SerialNo,R_BatQuaStart-R_BatQuaEnd as PCL,'
            +' (select SUM(L_Value) as zl from S_Bill where L_HYDan=R_SerialNo) as ZL from %s a,%s b'
            +' where a.R_PID = b.P_ID and b.P_Stock= ''%s'' and R_CenterID=''%s'''
            +' and R_BatValid=''%s'''
            +' union '
            +' select R_SerialNo,R_BatQuaStart-R_BatQuaEnd as PCL,'
            +' (select SUM(L_Value) as zl from S_Bill where L_HYDan=R_SerialNo) as ZL from %s a,%s b'
            +' where a.R_PID = b.P_ID and b.P_Stock= ''%s'' and R_CenterID=''%s'''
            +' and R_BatValid=''%s''';
    nStr := Format(nStr,[sTable_StockRecord, sTable_StockParam, FIn.FData, FIn.FExtParam, sFlag_Yes,
          sTable_StockRecord_slag, sTable_StockParam, FIn.FData, FIn.FExtParam, sFlag_Yes,
          sTable_StockRecord_Concrete, sTable_StockParam, FIn.FData, FIn.FExtParam, sFlag_Yes,
          sTable_StockRecord_clinker, sTable_StockParam, FIn.FData, FIn.FExtParam, sFlag_Yes]);
  {$ELSE}
  nStr := 'select R_SerialNo,R_BatQuaStart-R_BatQuaEnd as PCL, '+
          '(select SUM(L_Value) as zl from S_Bill where L_HYDan=R_SerialNo) as ZL from %s a,%s b '+
          'where a.R_PID = b.P_ID and b.P_Stock= ''%s'' and R_BatValid=''%s'' order by a.R_ID';
  nStr := Format(nStr,[sTable_StockRecord, sTable_StockParam, FIn.FData, sFlag_Yes]);
  {$ENDIF}
  WriteLog('UWorkerBusiness.pas.TWorkerBusinessCommander.GetSampleID:sql=['+nStr+']');
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    SetLength(FHuaYan, RecordCount);
    nIdx:=0;
    First;

    while not eof do
    begin
      FHuaYan[nIdx].FReriNo:= Fields[0].AsString;
      FHuaYan[nIdx].FValue:= Fields[1].AsFloat;
      FHuaYan[nIdx].FZLVal:= Fields[2].AsFloat;
      Inc(nIdx);
      Next;
    end;
  end;

  for nIdx := Low(FHuaYan) to High(FHuaYan) do
  begin
    if FHuaYan[nIdx].FValue <= FHuaYan[nIdx].FZLVal then
    begin
      nStr := 'update %s set R_BatValid=''%s'',R_TotalValue=(%.2f) where R_SerialNo=''%s'' ';
      nStr := Format(nStr,[sTable_StockRecord, sFlag_Yes, FHuaYan[nIdx].FZLVal, FHuaYan[nIdx].FReriNo]);
      gDBConnManager.WorkerExec(FDBConn,nStr);

      nStr := 'update %s set R_BatValid=''%s'',R_TotalValue=(%.2f) where R_SerialNo=''%s'' ';
      nStr := Format(nStr,[sTable_StockRecord_slag, sFlag_Yes, FHuaYan[nIdx].FZLVal, FHuaYan[nIdx].FReriNo]);
      gDBConnManager.WorkerExec(FDBConn,nStr);

      nStr := 'update %s set R_BatValid=''%s'',R_TotalValue=(%.2f) where R_SerialNo=''%s'' ';
      nStr := Format(nStr,[sTable_StockRecord_Concrete, sFlag_Yes, FHuaYan[nIdx].FZLVal, FHuaYan[nIdx].FReriNo]);
      gDBConnManager.WorkerExec(FDBConn,nStr);

      nStr := 'update %s set R_BatValid=''%s'',R_TotalValue=(%.2f) where R_SerialNo=''%s'' ';
      nStr := Format(nStr,[sTable_StockRecord_clinker, sFlag_Yes, FHuaYan[nIdx].FZLVal, FHuaYan[nIdx].FReriNo]);
      gDBConnManager.WorkerExec(FDBConn,nStr);
    end else
    begin
      nStr := 'update %s set R_TotalValue=(%.2f) where R_SerialNo=''%s'' ';
      nStr := Format(nStr,[sTable_StockRecord, FHuaYan[nIdx].FZLVal, FHuaYan[nIdx].FReriNo]);
      gDBConnManager.WorkerExec(FDBConn,nStr);

      nStr := 'update %s set R_TotalValue=(%.2f) where R_SerialNo=''%s'' ';
      nStr := Format(nStr,[sTable_StockRecord_Slag, FHuaYan[nIdx].FZLVal, FHuaYan[nIdx].FReriNo]);
      gDBConnManager.WorkerExec(FDBConn,nStr);

      nStr := 'update %s set R_TotalValue=(%.2f) where R_SerialNo=''%s'' ';
      nStr := Format(nStr,[sTable_StockRecord_Concrete, FHuaYan[nIdx].FZLVal, FHuaYan[nIdx].FReriNo]);
      gDBConnManager.WorkerExec(FDBConn,nStr);

      nStr := 'update %s set R_TotalValue=(%.2f) where R_SerialNo=''%s'' ';
      nStr := Format(nStr,[sTable_StockRecord_clinker, FHuaYan[nIdx].FZLVal, FHuaYan[nIdx].FReriNo]);
      gDBConnManager.WorkerExec(FDBConn,nStr);
      FOut.FData:=FHuaYan[nIdx].FReriNo;
      Result:=True;
      Exit;
    end;
  end;
end;

function TWorkerBusinessCommander.GetCenterID(var nData: string):Boolean;//��ȡ������ID
var
  nStr:string;
begin
  Result:=False;
  nStr := 'Select Z_CenterID,Z_LocationID From %s Where Z_StockNo=''%s'' ';
  nStr := Format(nStr, [sTable_ZTLines, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if (RecordCount > 0) then
    begin
      FOut.FData:=Fields[0].AsString;
      FOut.FExtParam:=Fields[1].AsString;
      Result:=True;
    end;
  end;
end;

{$ENDIF}

//------------------------------------------------------------------------------
class function TWorkerBusinessBills.FunctionName: string;
begin
  Result := sBus_BusinessSaleBill;
end;

constructor TWorkerBusinessBills.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  inherited;
end;

destructor TWorkerBusinessBills.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  inherited;
end;

function TWorkerBusinessBills.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
  end;
end;

procedure TWorkerBusinessBills.GetInOutData(var nIn, nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2014-09-15
//Parm: ��������
//Desc: ִ��nDataҵ��ָ��
function TWorkerBusinessBills.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := 'ҵ��ִ�гɹ�.';
  end;

  case FIn.FCommand of
   cBC_SaveBills           : Result := SaveBills(nData);
   cBC_DeleteBill          : Result := DeleteBill(nData);
   cBC_ModifyBillTruck     : Result := ChangeBillTruck(nData);
   cBC_SaleAdjust          : Result := BillSaleAdjust(nData);
   cBC_SaveBillCard        : Result := SaveBillCard(nData);
   cBC_LogoffCard          : Result := LogoffCard(nData);
   cBC_GetPostBills        : Result := GetPostBillItems(nData);
   cBC_SavePostBills       : Result := SavePostBillItems(nData);
   else
    begin
      Result := False;
      nData := '��Ч��ҵ�����(Invalid Command).';
    end;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2014/7/30
//Parm: Ʒ�ֱ��
//Desc: ����nStock��Ӧ�����Ϸ���
function TWorkerBusinessBills.GetStockGroup(const nStock: string): string;
var nIdx: Integer;
begin
  Result := '';
  //init

  for nIdx:=Low(FStockItems) to High(FStockItems) do
  if FStockItems[nIdx].FStock = nStock then
  begin
    Result := FStockItems[nIdx].FGroup;
    Exit;
  end;
end;

//Date: 2014/7/30
//Parm: Ʒ�ֱ��
//Desc: ����������������nStockͬƷ��,��ͬ��ļ�¼
function TWorkerBusinessBills.GetMatchRecord(const nStock: string): string;
var nStr: string;
    nIdx: Integer;
begin
  Result := '';
  //init

  for nIdx:=Low(FMatchItems) to High(FMatchItems) do
  if FMatchItems[nIdx].FStock = nStock then
  begin
    Result := FMatchItems[nIdx].FRecord;
    Exit;
  end;

  nStr := GetStockGroup(nStock);
  if nStr = '' then Exit;  

  for nIdx:=Low(FMatchItems) to High(FMatchItems) do
  if FMatchItems[nIdx].FGroup = nStr then
  begin
    Result := FMatchItems[nIdx].FRecord;
    Exit;
  end;
end;

//Date: 2014-09-16
//Parm: ���ƺ�;
//Desc: ��֤nTruck�Ƿ���Ч
class function TWorkerBusinessBills.VerifyTruckNO(nTruck: string;
  var nData: string): Boolean;
var nIdx: Integer;
    nWStr: WideString;
begin
  Result := False;
  nIdx := Length(nTruck);
  if (nIdx < 3) or (nIdx > 10) then
  begin
    nData := '��Ч�ĳ��ƺų���Ϊ3-10.';
    Exit;
  end;

  nWStr := LowerCase(nTruck);
  //lower
  
  for nIdx:=1 to Length(nWStr) do
  begin
    case Ord(nWStr[nIdx]) of
     Ord('-'): Continue;
     Ord('0')..Ord('9'): Continue;
     Ord('a')..Ord('z'): Continue;
    end;

    if nIdx > 1 then
    begin
      nData := Format('���ƺ�[ %s ]��Ч.', [nTruck]);
      Exit;
    end;
  end;

  Result := True;
end;

//Date: 2014-10-07
//Desc: ����ɢװ�൥
function TWorkerBusinessBills.AllowedSanMultiBill: Boolean;
var nStr: string;
begin
  Result := False;
  nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_SanMultiBill]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    Result := Fields[0].AsString = sFlag_Yes;
  end;
end;

//Lih  2016-09-01
//����nZID����Ϣ���ز�ѯ���ݼ�
function TWorkerBusinessBills.LoadZhiKaInfo(const nZID: string; var nHint: string): TDataset;
var nStr: string;
begin
  nStr := 'Select zk.*,con.C_ContQuota,cus.C_Name,cus.C_PY,con.C_Area From $ZK zk ' +
          ' Left Join $Con con On con.C_ID=zk.Z_CID ' +
          ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
          'Where Z_ID=''$ID''';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
             MI('$Con', sTable_SaleContract),
             MI('$Cus', sTable_Customer), MI('$ID', nZID)]);
  Result := gDBConnManager.WorkerQuery(FDBConn, nStr);
end;

//Date: 2014-09-15
//Desc: ��֤�ܷ񿪵�
function TWorkerBusinessBills.VerifyBeforSave(var nData: string): Boolean;
var nIdx: Integer;
    nStr,nTruck: string;
    nDBZhiKa: TDataSet;
    nOut: TWorkerBusinessCommand;
    nHint: string;
    nQHD:Boolean;
begin
  Result := False;
  nQHD := False;
  {$IFDEF QHSN}
  {$IFDEF GGJC}
  nQHD := True;
  {$ENDIF}
  {$ENDIF}
  nTruck := FListA.Values['Truck'];
  if not VerifyTruckNO(nTruck, nData) then Exit;

  if Length(FListA.Values['LID']) > 8 then
  begin
    nStr := 'Select Count(*) From %s Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, FListA.Values['LID']]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if Fields[0].AsInteger > 0 then
    begin
      nData := '���ݺ�[ %s ]�Ѵ���,�����ظ�����.';
      nData := Format(nData, [FListA.Values['LID']]);
      Exit;
    end;
  end;

  //----------------------------------------------------------------------------
  SetLength(FStockItems, 0);
  SetLength(FMatchItems, 0);
  //init

  FSanMultiBill := AllowedSanMultiBill;
  //ɢװ�����൥

  nStr := 'Select M_ID,M_Group From %s Where M_Status=''%s'' ';
  nStr := Format(nStr, [sTable_StockMatch, sFlag_Yes]);
  //Ʒ�ַ���ƥ��

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    SetLength(FStockItems, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    begin
      FStockItems[nIdx].FStock := Fields[0].AsString;
      FStockItems[nIdx].FGroup := Fields[1].AsString;

      Inc(nIdx);
      Next;
    end;
  end;

  nStr := 'Select a.R_ID,a.T_Bill,a.T_StockNo,a.T_Type,'+
          'a.T_InFact,a.T_Valid,b.L_Status From %s a ' +
          'left join %s b on a.T_Bill = b.L_ID '+
          'Where a.T_Truck=''%s'' ';
  nStr := Format(nStr, [sTable_ZTTrucks, sTable_Bill, nTruck]);
  //���ڶ����г���

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    SetLength(FMatchItems, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    begin
      if (FieldByName('T_Type').AsString = sFlag_San) and (not FSanMultiBill) and
        (FieldByName('L_Status').AsString <> sFlag_TruckOut) then
      begin
        nStr := '����[ %s ]��δ���[ %s ]������֮ǰ��ֹ����.';
        nData := Format(nStr, [nTruck, FieldByName('T_Bill').AsString]);
        Exit;
      end else

      if (FieldByName('T_Type').AsString = sFlag_Dai) and
        // (FieldByName('T_InFact').AsString <> '') and
         (FieldByName('L_Status').AsString <> sFlag_TruckOut) then
      begin
        nStr := '����[ %s ]��δ���[ %s ]������֮ǰ��ֹ����.';
        nData := Format(nStr, [nTruck, FieldByName('T_Bill').AsString]);
        Exit;
      end; {else

      if FieldByName('T_Valid').AsString = sFlag_No then
      begin
        nStr := '����[ %s ]���ѳ��ӵĽ�����[ %s ],���ȴ���.';
        nData := Format(nStr, [nTruck, FieldByName('T_Bill').AsString]);
        Exit;
      end; }

      with FMatchItems[nIdx] do
      begin
        FStock := FieldByName('T_StockNo').AsString;
        FGroup := GetStockGroup(FStock);
        FRecord := FieldByName('R_ID').AsString;
      end;

      Inc(nIdx);
      Next;
    end;
  end;

  nStr := 'Select * From %s Where O_CType = ''G'' and O_Truck=''%s'' ';
  nStr := Format(nStr, [sTable_Order, nTruck]);
  //��������ɹ����ڿ�

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    if FieldByName('O_Card').AsString <> '' then
    begin
      nStr := '����[ %s ]�Ѿ�����[ %s ]�ɹ����ڿ������ȵ��ɹ��ƿ���ע���ɹ�����.';
      nData := Format(nStr, [nTruck, FieldByName('O_StockName').AsString]);
      Exit;
    end;
  end;

  TWorkerBusinessCommander.CallMe(cBC_SaveTruckInfo, nTruck, '', @nOut);
  //���泵�ƺ�

  //----------------------------------------------------------------------------
  {nStr := 'Select zk.*,ht.C_Area,cus.C_Name,cus.C_PY From $ZK zk ' +
          ' Left Join $HT ht On ht.C_ID=zk.Z_CID ' +
          ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
          'Where Z_ID=''$ZID''';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
          MI('$HT', sTable_SaleContract),
          MI('$Cus', sTable_Customer),
          MI('$ZID', FListA.Values['ZhiKa'])]);  }
  nDBZhiKa:=LoadZhiKaInfo(FListA.Values['ZhiKa'], nHint);
  //ֽ����Ϣ
  with nDBZhiKa,FListA do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('ֽ��[ %s ]�Ѷ�ʧ.', [Values['ZhiKa']]);
      Exit;
    end;

    if FieldByName('Z_Freeze').AsString = sFlag_Yes then
    begin
      nData := Format('ֽ��[ %s ]�ѱ�����Ա����.', [Values['ZhiKa']]);
      Exit;
    end;

    if FieldByName('Z_InValid').AsString = sFlag_Yes then
    begin
      nData := Format('ֽ��[ %s ]�ѱ�����Ա����.', [Values['ZhiKa']]);
      Exit;
    end;

    nStr := FieldByName('Z_TJStatus').AsString;
    if nStr  <> '' then
    begin
      if nStr = sFlag_TJOver then
           nData := 'ֽ��[ %s ]�ѵ���,�����¿���.'
      else nData := 'ֽ��[ %s ]���ڵ���,���Ժ�.';

      nData := Format(nData, [Values['ZhiKa']]);
      Exit;
    end;

    {if FieldByName('Z_ValidDays').AsDateTime <= Date() then
    begin
      nData := Format('ֽ��[ %s ]����[ %s ]����.', [Values['ZhiKa'],
               Date2Str(FieldByName('Z_ValidDays').AsDateTime)]);
      Exit;
    end;   }
    Values['TriaTrade'] := FieldByName('Z_TriangleTrade').AsString;  //1��������ó�� 0����
    if Values['TriaTrade']='1' then
    begin
      Values['CusID'] := FieldByName('Z_OrgAccountNum').AsString;
      Values['CusName'] := FieldByName('Z_OrgAccountName').AsString;
      Values['CusPY'] := '';
    end else
    begin
      Values['CusID'] := FieldByName('Z_Customer').AsString;
      Values['CusName'] := FieldByName('C_Name').AsString;
      Values['CusPY'] := FieldByName('C_PY').AsString;
    end;

    Values['ZKMoney'] := FieldByName('Z_OnlyMoney').AsString;
    Values['CompanyId'] := FieldByName('Z_CompanyId').AsString;
    Values['ContQuota'] := FieldByName('C_ContQuota').AsString;

    Values['ContractID'] := FieldByName('Z_CID').AsString;
    Values['Area'] := FieldByName('Z_XSQYBM').AsString;
    Values['KHSBM'] := FieldByName('Z_KHSBM').AsString;

    Values['OrgXSQYMC'] := FieldByName('Z_OrgXSQYMC').AsString;
    if not nQHD then
    begin
      if (Pos('��������ɽ����',FieldByName('Z_Name').AsString)>0) then
        Values['IfNeiDao'] := 'Y'
      else
        Values['IfNeiDao'] := 'N';
    end;
  end;

  Result := True;
  //verify done
end;

//��ȡ����ģʽ
function TWorkerBusinessBills.GetOnLineModel: string;
var
  nStr: string;
begin
  Result:=sFlag_Yes;
  nStr := 'select D_Value from %s where D_Name=''%s'' ';
  nStr := Format(nStr, [sTable_SysDict, sFlag_OnLineModel]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    Result:=Fields[0].AsString;
  end;
end;

//����Զ�̻�ȡ�ͻ����ú��ʽ�
function TWorkerBusinessBills.GetRemCustomerMoney(const nZID:string; var nRemMoney:Double; var nMsg:string): Boolean;
var
  nStr:string;
  nCusID,nZcid,nContQuota: string;
  nOut: TWorkerBusinessCommand;
  nDBZhiKa:TDataSet;
  nHint: string;
begin
  nRemMoney:= 0.00;

  nStr := 'Select zk.*,con.C_ContQuota From $ZK zk ' +
          ' Left Join $Con con On con.C_ID=zk.Z_CID ' +
          ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
          'Where Z_ID=''$ID''';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
             MI('$Con', sTable_SaleContract), 
             MI('$Cus', sTable_Customer), MI('$ID', nZID)]);
  //ֽ����Ϣ
  //WriteLog(nStr);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount>0 then
  begin
    nCusID := FieldByName('Z_Customer').AsString;
    nContQuota := FieldByName('C_ContQuota').AsString;
    nZcid:= FieldByName('Z_CID').AsString;
    if nContQuota='1' then
    begin
      if not TWorkerBusinessCommander.CallMe(cBC_GetTprGemCont, nCusID+','+nZcid, gCompanyAct, @nOut) then
      begin
        nMsg := Format('���߻�ȡ[ %s ]��ͬ���ö����Ϣʧ��,����ֹ.', [nCusID+','+nZcid]);
        Result := False;
        Exit;
      end;
      Result:=True;
      nRemMoney := StrToFloat(nOut.FExtParam);
      WriteLog('ZAX Money: '+nOut.FExtParam);
      
      if nOut.FData=sFlag_No then nMsg:='['+nCusID+']�ʽ�����.';
    end else
    begin
      if not TWorkerBusinessCommander.CallMe(cBC_GetTprGem, nCusID, gCompanyAct, @nOut) then
      begin
        nMsg := Format('���߻�ȡ[ %s ]�ͻ����ö����Ϣʧ��,����ֹ.', [nCusID]);
        Result := False;
        Exit;
      end;
      Result:=True;
      nRemMoney := StrToFloat(nOut.FExtParam);
      WriteLog('ZAX Money: '+nOut.FExtParam);

      if nOut.FData=sFlag_No then nMsg:='['+nCusID+']�ʽ�����.';
    end;
  end;
end;

//����Զ�̻�ȡ����ó�׿ͻ����ú��ʽ�
function TWorkerBusinessBills.GetRemTriCustomerMoney(const nZID:string; var nRemMoney:Double; var nMsg:string): Boolean;
var
  nStr:string;
  nOrgCusID,nOriSalesId,nCompanyId,nZcid,nContQuota: string;
  nOut: TWorkerBusinessCommand;
  nDBZhiKa:TDataSet;
  nHint: string;
begin
  nRemMoney:= 0.00;
  nStr := 'Select Z_CompanyId,Z_OrgAccountNum,Z_IntComOriSalesId From $ZK Where Z_ID=''$ID''';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa), MI('$ID', nZID)]);
  //ֽ����Ϣ
  //WriteLog(nStr);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nMsg := Format('[ %s ]���۶���������,����ֹ.', [nZID]);
      Result:=False;
      Exit;
    end;
    nOrgCusID := FieldByName('Z_OrgAccountNum').AsString;
    nOriSalesId := FieldByName('Z_IntComOriSalesId').AsString;
    nCompanyId := FieldByName('Z_CompanyId').AsString;
  end;
  
  if not TWorkerBusinessCommander.CallMe(cBC_GetAXContQuota, nOriSalesId, nCompanyId, @nOut) then
  begin
    nMsg := Format('����ó�׶���[ %s ]���߻�ȡ��ͬ��Ϣʧ��,����ֹ.', [nZID]);
    Result := False;
    Exit;
  end;
  nContQuota := nOut.FData;
  nZcid:= nOut.FExtParam;
  if nContQuota = sFlag_Yes then
  begin
    if not TWorkerBusinessCommander.CallMe(cBC_GetTprGemCont, nOrgCusID+','+nZcid, nCompanyId, @nOut) then
    begin
      nMsg := Format('���߻�ȡ[ %s ]��ͬ���ö����Ϣʧ��,����ֹ.', [nOrgCusID+','+nZcid]);
      Result := False;
      Exit;
    end;
    Result:=True;
    nRemMoney := StrToFloat(nOut.FExtParam);
    WriteLog('SAX Money: '+nOut.FExtParam);

    if nOut.FData=sFlag_No then nMsg:='['+nOrgCusID+']�ʽ�����.';
  end else
  begin
    if not TWorkerBusinessCommander.CallMe(cBC_GetTprGem, nOrgCusID, nCompanyId, @nOut) then
    begin
      nMsg := Format('���߻�ȡ[ %s ]�ͻ����ö����Ϣʧ��,����ֹ.', [nOrgCusID]);
      Result := False;
      Exit;
    end;
    Result:=True;
    nRemMoney := StrToFloat(nOut.FExtParam);
    WriteLog('SAX Money: '+nOut.FExtParam);

    if nOut.FData=sFlag_No then nMsg:='['+nOrgCusID+']�ʽ�����.';
  end;
end;

//Date: 2014-09-15
//Desc: ���潻����
function TWorkerBusinessBills.SaveBills(var nData: string): Boolean;
var nStr,nSQL,nFixMoney: string;
    nIdx: Integer;
    nVal,nMoney: Double;
    nOut: TWorkerBusinessCommand;
    nBxz: Boolean;
    nAxMoney,nSendValue: Double;
    nAxMsg,nOnLineModel: string;
    nWebOrderID: string;
begin
  Result := False;
  nBxz:= True; //Ĭ��ǿ�����ö��
  FListA.Text := PackerDecodeStr(FIn.FData);
  if not VerifyBeforSave(nData) then Exit;

  nOnLineModel:=GetOnLineModel; //��ȡ�Ƿ�����ģʽ
  if FListA.Values['SalesType'] = '0' then
  begin
    nBxz:=False;
  end else
  begin
    if FListA.Values['TriaTrade']='1' then
    begin
      if nOnLineModel=sFlag_Yes then   //����ģʽ��Զ�̻�ȡ�ͻ��ʽ���
      begin
        if not TWorkerBusinessCommander.CallMe(cBC_GetAXMaCredLmt, //�Ƿ�ǿ�����ö��
                FListA.Values['CusID'], FListA.Values['CompanyId'], @nOut) then
        begin
          nData := nOut.FData;
          Exit;
        end;
        if nOut.FData = sFlag_No then
        begin
          nBxz:=False;
        end;
        if nBxz then
        begin
          if not GetRemTriCustomerMoney(FListA.Values['ZhiKa'],nAxMoney,nAxMsg) then
          begin
            nData:=nAxMsg;
            Exit;
          end;
        end;
      end else
      begin
        nData := '����ģʽ����ȡ����ó�׿ͻ���Ϣʧ��';
        Exit;
      end;
    end else
    begin
      if not TWorkerBusinessCommander.CallMe(cBC_CustomerMaCredLmt, //�Ƿ�ǿ�����ö��
                FListA.Values['CusID'], '', @nOut) then
      begin
        nData := nOut.FData;
        Exit;
      end;
      if nOut.FData = sFlag_No then
      begin
        nBxz:=False;
      end;
      if nBxz then
      begin
        if nOnLineModel=sFlag_Yes then   //����ģʽ��Զ�̻�ȡ�ͻ��ʽ���
        begin
          if not GetRemCustomerMoney(FListA.Values['ZhiKa'],nAxMoney,nAxMsg) then
          begin
            nData:=nAxMsg;
            Exit;
          end;
        end;
        if not TWorkerBusinessCommander.CallMe(cBC_GetCustomerMoney,  //��ȡ�����ʽ���
               FListA.Values['ZhiKa'], '', @nOut) then
        begin
          nData := nOut.FData;
          Exit;
        end;
        nMoney := StrToFloat(nOut.FData);
        //nFixMoney := nOut.FExtParam;
        nFixMoney := sFlag_No;
        //Customer money
      end;
    end;
    if nBxz and (nOnLineModel=sFlag_Yes) then
    begin
      nStr := 'select IsNull(SUM(L_Value*L_Price),''0'') as L_TotalMoney from %s where L_BDAX = ''2'' and L_CusID=''%s'' ';
      nStr := Format(nStr,[sTable_Bill, FListA.Values['CusID']]);
      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      if RecordCount > 0 then
      begin
        nAxMoney := nAxMoney - Fields[0].AsFloat;
        WriteLog(FListA.Values['CusID']+': '+FloatToStr(nAxMoney));
      end;
    end;
  end;

  FListB.Text := PackerDecodeStr(FListA.Values['Bills']);
  //unpack bill list
  nVal := 0;
  for nIdx:=0 to FListB.Count - 1 do
  begin
    FListC.Text := PackerDecodeStr(FListB[nIdx]);
    //get bill info

    with FListC do
      nVal := nVal + Float2Float(StrToFloat(Values['Price']) *
                     StrToFloat(Values['Value']), cPrecision, True);
    //xxxx
  end;
  
  if nBxz then
  begin
    if nOnLineModel=sFlag_Yes then   //����ģʽ��Զ�̻�ȡ�ͻ��ʽ���
    begin
      if (FloatRelation(nVal, nAxMoney, rtGreater)) then
      begin
        nData := '�ͻ�[ %s ]û���㹻�Ľ��,��������:' + #13#10#13#10 +
                 '���ý��: %.2f' + #13#10 +
                 '�������: %.2f' + #13#10#13#10 +
                 '���С��������ٿ���.';
        nData := Format(nData, [FListA.Values['CusID'], nAxMoney, nVal]);
        Exit;
      end;
    end;
    if FListA.Values['TriaTrade'] <> '1' then
    begin
      if (FloatRelation(nVal, nMoney, rtGreater)) then
      begin
        nData := '�ͻ�[ %s ]û���㹻�Ľ��,��������:' + #13#10#13#10 +
                 '���ý��: %.2f' + #13#10 +
                 '�������: %.2f' + #13#10#13#10 +
                 '���С��������ٿ���.';
        nData := Format(nData, [FListA.Values['CusID'], nMoney, nVal]);
        Exit;
      end;
    end;
  end;
  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    FOut.FData := '';
    //bill list

    for nIdx:=0 to FListB.Count - 1 do
    begin
      FListC.Values['Group'] :=sFlag_BusGroup;
      FListC.Values['Object'] := sFlag_BillNo;
      //to get serial no

      //{$IFDEF GGJC}
      if Length(FListA.Values['LID']) > 8 then
        nOut.FData := FListA.Values['LID']
      else
      begin
        if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
            FListC.Text, sFlag_Yes, @nOut) then
        raise Exception.Create(nOut.FData);
      end;
      //{$ELSE}
      {if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
          FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData); }
      //xxxxx
      //{$ENDIF}
      
      FOut.FData := FOut.FData + nOut.FData + ',';
      //combine bill
      FListC.Text := PackerDecodeStr(FListB[nIdx]);
      //get bill info
      if FListA.Values['LocationID']='' then FListA.Values['LocationID'] := 'A';
      nStr := MakeSQLByStr([SF('L_ID', nOut.FData),
              SF('L_ZhiKa', FListA.Values['ZhiKa']),
              SF('L_Project', FListA.Values['Project']),

              SF('L_CusID', FListA.Values['CusID']),
              SF('L_CusName', FListA.Values['CusName']),
              SF('L_CusPY', FListA.Values['CusPY']),

              SF('L_Type', FListC.Values['Type']),
              SF('L_StockNo', FListC.Values['StockNO']),
              SF('L_StockName', FListC.Values['StockName']),

              SF('L_Value', FListC.Values['Value'], sfVal),
              SF('L_szbz', FListC.Values['szbz'], sfVal),
              SF('L_color', FListC.Values['color']),
              SF('L_PlanQty', FListC.Values['Value'], sfVal),
              SF('L_Price', FListC.Values['Price'], sfVal),
              SF('L_LineRecID', FListC.Values['RECID']),
              
              SF('L_ZKMoney', nFixMoney),
              SF('L_Truck', FListA.Values['Truck']),
              SF('L_Status', sFlag_BillNew),

              SF('L_Lading', FListA.Values['Lading']),
              SF('L_IsVIP', FListA.Values['IsVIP']),
              SF('L_Seal', FListA.Values['Seal']),

              SF('L_Man', FIn.FBase.FFrom.FUser),
              SF('L_Date', sField_SQLServer_Now, sfVal),
              SF('L_IfHYPrint', FListA.Values['IfHYprt']),

              SF('L_HYDan', FListC.Values['SampleID']),
              SF('L_SalesType', FListA.Values['SalesType']),
              SF('L_InvCenterId', FListA.Values['CenterID']),

              SF('L_InvLocationId', FListA.Values['LocationID']),
              SF('L_Area', FListA.Values['Area']),
              SF('L_KHSBM', FListA.Values['KHSBM']),

              SF('L_JXSTHD', FListA.Values['JXSTHD']),
              SF('L_OrgXSQYMC', FListA.Values['OrgXSQYMC']),
              SF('L_CW', FListA.Values['KuWei']),

              SF('L_IfFenChe', FListA.Values['IfFenChe']),
              SF('L_IfNeiDao', FListA.Values['IfNeiDao']),
              SF('L_TriaTrade', FListA.Values['TriaTrade']),

              SF('L_ContQuota', FListA.Values['ContQuota']),
              SF('L_ToAddr', FListA.Values['ToAddr']),
              SF('L_IdNumber', FListA.Values['IdNumber'])
              ], sTable_Bill, '', True);
      gDBConnManager.WorkerExec(FDBConn, nStr);

      if FListA.Values['BuDan'] = sFlag_Yes then //����
      begin
        nStr := MakeSQLByStr([SF('L_Status', sFlag_TruckOut),
                SF('L_InTime', sField_SQLServer_Now, sfVal),
                SF('L_PValue', 0, sfVal),
                SF('L_PDate', sField_SQLServer_Now, sfVal),
                SF('L_PMan', FIn.FBase.FFrom.FUser),
                SF('L_MValue', FListC.Values['Value'], sfVal),
                SF('L_MDate', sField_SQLServer_Now, sfVal),
                SF('L_MMan', FIn.FBase.FFrom.FUser),
                SF('L_OutFact', sField_SQLServer_Now, sfVal),
                SF('L_OutMan', FIn.FBase.FFrom.FUser),
                SF('L_Card', '')
                ], sTable_Bill, SF('L_ID', nOut.FData), False);
        gDBConnManager.WorkerExec(FDBConn, nStr);
      end else
      begin
        if FListC.Values['Type'] = sFlag_San then
        begin
          nStr := '';
          //ɢװ����ϵ�
        end else
        begin
          nStr := FListC.Values['StockNO'];
          nStr := GetMatchRecord(nStr);
          //��Ʒ����װ�������еļ�¼��
        end;

        if nStr <> '' then
        begin
          nSQL := 'Update $TK Set T_Value=T_Value + $Val,' +
                  'T_HKBills=T_HKBills+''$BL.'' Where R_ID=$RD';
          nSQL := MacroValue(nSQL, [MI('$TK', sTable_ZTTrucks),
                  MI('$RD', nStr), MI('$Val', FListC.Values['Value']),
                  MI('$BL', nOut.FData)]);
          gDBConnManager.WorkerExec(FDBConn, nSQL);
        end else
        begin
          nSQL := MakeSQLByStr([
            SF('T_Truck'   , FListA.Values['Truck']),
            SF('T_StockNo' , FListC.Values['StockNO']+FListC.Values['Type']),
            SF('T_Stock'   , FListC.Values['StockName']),
            SF('T_Type'    , FListC.Values['Type']),
            SF('T_InTime'  , sField_SQLServer_Now, sfVal),
            SF('T_Bill'    , nOut.FData),
            SF('T_Valid'   , sFlag_Yes),
            SF('T_Value'   , FListC.Values['Value'], sfVal),
            SF('T_VIP'     , FListA.Values['IsVIP']),
            SF('T_HKBills' , nOut.FData + '.')
            ], sTable_ZTTrucks, '', True);
          gDBConnManager.WorkerExec(FDBConn, nSQL);
        end;
      end;
    end;

    if FListA.Values['BuDan'] = sFlag_Yes then //����
    begin
      {if FListA.Values['ContQuota'] = '1' then
      begin
        nStr := 'Update %s Set A_ConOutMoney=A_ConOutMoney+%s Where A_CID=''%s''';
        nStr := Format(nStr, [sTable_CusAccount, FloatToStr(nVal),
                FListA.Values['CusID']]);
        gDBConnManager.WorkerExec(FDBConn, nStr);
      end else
      begin
        nStr := 'Update %s Set A_OutMoney=A_OutMoney+%s Where A_CID=''%s''';
        nStr := Format(nStr, [sTable_CusAccount, FloatToStr(nVal),
                FListA.Values['CusID']]);
        gDBConnManager.WorkerExec(FDBConn, nStr);
      end;  }
      //freeze money from account
    end else
    begin
      if FListA.Values['TriaTrade'] <> '1' then
      begin
        if FListA.Values['ContQuota'] = '1' then
        begin
          nStr := 'Update %s Set A_ConFreezeMoney=A_ConFreezeMoney+%s Where A_CID=''%s''';
          nStr := Format(nStr, [sTable_CusAccount, FloatToStr(nVal),
                  FListA.Values['CusID']]);
          gDBConnManager.WorkerExec(FDBConn, nStr);
        end else
        begin
          nStr := 'Update %s Set A_FreezeMoney=A_FreezeMoney+%s Where A_CID=''%s''';
          nStr := Format(nStr, [sTable_CusAccount, FloatToStr(nVal),
                  FListA.Values['CusID']]);
          gDBConnManager.WorkerExec(FDBConn, nStr);
        end;
        //freeze money from account
        WriteLog('['+nOut.FData+']Add YKMoney: '+nStr);
      end;
    end;

    nIdx := Length(FOut.FData);
    if Copy(FOut.FData, nIdx, 1) = ',' then
      System.Delete(FOut.FData, nIdx, 1);
    //xxxxx

    nStr := 'select IsNull(SUM(L_Value),''0'') as SendValue from %s where L_LineRecID=''%s'' ';
    nStr := Format(nStr,[sTable_Bill, FListC.Values['RECID']]);
    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      nSendValue := Fields[0].AsFloat;
    end;

    nStr := 'Update %s Set D_Value=D_Value -(%.2f) Where D_RECID=''%s''';
    nStr := Format(nStr, [sTable_ZhiKaDtl, StrToFloat(FListC.Values['Value']), FListC.Values['RECID']]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
  if gSysParam.FGPWSURL <> '' then
  begin
    {$IFNDEF PLKP}
    nWebOrderID := FListA.Values['WebOrderID'];
    //�޸��̳Ƕ���״̬
    ModifyWebOrderStatus(nOut.FData,c_WeChatStatusCreateCard,nWebOrderID);
    {$ENDIF}
    //����΢����Ϣ
    SendMsgToWebMall(nOut.FData,cSendWeChatMsgType_AddBill,sFlag_Sale);
  end;
end;

//------------------------------------------------------------------------------
//Date: 2014-09-16
//Parm: ������[FIn.FData];���ƺ�[FIn.FExtParam]
//Desc: �޸�ָ���������ĳ��ƺ�
function TWorkerBusinessBills.ChangeBillTruck(var nData: string): Boolean;
var nIdx: Integer;
    nStr,nTruck: string;
begin
  Result := False;
  if not VerifyTruckNO(FIn.FExtParam, nData) then Exit;

  nStr := 'Select L_Truck,L_InTime From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount <> 1 then
    begin
      nData := '������[ %s ]����Ч.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    if Fields[1].AsString <> '' then
    begin
      nData := '������[ %s ]�����,�޷��޸ĳ��ƺ�.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;


    nTruck := Fields[0].AsString;
  end;

  nStr := 'Select R_ID,T_HKBills From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_ZTTrucks, nTruck]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    FListA.Clear;
    FListB.Clear;
    First;

    while not Eof do
    begin
      SplitStr(Fields[1].AsString, FListC, 0, '.');
      FListA.AddStrings(FListC);
      FListB.Add(Fields[0].AsString);
      Next;
    end;
  end;

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    nStr := 'Update %s Set L_Truck=''%s'' Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, FIn.FExtParam, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    //�����޸���Ϣ

    if (FListA.Count > 0) and (CompareText(nTruck, FIn.FExtParam) <> 0) then
    begin
      for nIdx:=FListA.Count - 1 downto 0 do
      if CompareText(FIn.FData, FListA[nIdx]) <> 0 then
      begin
        nStr := 'Update %s Set L_Truck=''%s'' Where L_ID=''%s''';
        nStr := Format(nStr, [sTable_Bill, FIn.FExtParam, FListA[nIdx]]);

        gDBConnManager.WorkerExec(FDBConn, nStr);
        //ͬ���ϵ����ƺ�
      end;
    end;

    if (FListB.Count > 0) and (CompareText(nTruck, FIn.FExtParam) <> 0) then
    begin
      for nIdx:=FListB.Count - 1 downto 0 do
      begin
        nStr := 'Update %s Set T_Truck=''%s'' Where R_ID=%s';
        nStr := Format(nStr, [sTable_ZTTrucks, FIn.FExtParam, FListB[nIdx]]);

        gDBConnManager.WorkerExec(FDBConn, nStr);
        //ͬ���ϵ����ƺ�
      end;
    end;

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-30
//Parm: ��������[FIn.FData];��ֽ��[FIn.FExtParam]
//Desc: ����������������ֽ���Ŀͻ�
function TWorkerBusinessBills.BillSaleAdjust(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nVal,nMon: Double;
    nOut: TWorkerBusinessCommand;
begin
  Result := False;
  //init

  //----------------------------------------------------------------------------
  nStr := 'Select L_CusID,L_StockNo,L_StockName,L_Value,L_Price,L_ZhiKa,' +
          'L_ZKMoney,L_OutFact From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('������[ %s ]�Ѷ�ʧ.', [FIn.FData]);
      Exit;
    end;

    if FieldByName('L_OutFact').AsString = '' then
    begin
      nData := '����������(������)���ܵ���.';
      Exit;
    end;

    FListB.Clear;
    with FListB do
    begin
      Values['CusID'] := FieldByName('L_CusID').AsString;
      Values['StockNo'] := FieldByName('L_StockNo').AsString;
      Values['StockName'] := FieldByName('L_StockName').AsString;
      Values['ZhiKa'] := FieldByName('L_ZhiKa').AsString;
      Values['ZKMoney'] := FieldByName('L_ZKMoney').AsString;
    end;
    
    nVal := FieldByName('L_Value').AsFloat;
    nMon := nVal * FieldByName('L_Price').AsFloat;
    nMon := Float2Float(nMon, cPrecision, True);
  end;

  //----------------------------------------------------------------------------
  nStr := 'Select zk.*,ht.C_Area,cus.C_Name,cus.C_PY,sm.S_Name From $ZK zk ' +
          ' Left Join $HT ht On ht.C_ID=zk.Z_CID ' +
          ' Left Join $Cus cus On cus.C_ID=zk.Z_Customer ' +
          ' Left Join $SM sm On sm.S_ID=Z_SaleMan ' +
          'Where Z_ID=''$ZID''';
  nStr := MacroValue(nStr, [MI('$ZK', sTable_ZhiKa),
          MI('$HT', sTable_SaleContract),
          MI('$Cus', sTable_Customer),
          MI('$SM', sTable_Salesman),
          MI('$ZID', FIn.FExtParam)]);
  //ֽ����Ϣ

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('ֽ��[ %s ]�Ѷ�ʧ.', [FIn.FExtParam]);
      Exit;
    end;

    if FieldByName('Z_Freeze').AsString = sFlag_Yes then
    begin
      nData := Format('ֽ��[ %s ]�ѱ�����Ա����.', [FIn.FExtParam]);
      Exit;
    end;

    if FieldByName('Z_InValid').AsString = sFlag_Yes then
    begin
      nData := Format('ֽ��[ %s ]�ѱ�����Ա����.', [FIn.FExtParam]);
      Exit;
    end;

    if FieldByName('Z_ValidDays').AsDateTime <= Date() then
    begin
      nData := Format('ֽ��[ %s ]����[ %s ]����.', [FIn.FExtParam,
               Date2Str(FieldByName('Z_ValidDays').AsDateTime)]);
      Exit;
    end;

    FListA.Clear;
    with FListA do
    begin
      Values['Project'] := FieldByName('Z_Project').AsString;
      Values['Area'] := FieldByName('C_Area').AsString;
      Values['CusID'] := FieldByName('Z_Customer').AsString;
      Values['CusName'] := FieldByName('C_Name').AsString;
      Values['CusPY'] := FieldByName('C_PY').AsString;
      Values['SaleID'] := FieldByName('Z_SaleMan').AsString;
      Values['SaleMan'] := FieldByName('S_Name').AsString;
      Values['ZKMoney'] := FieldByName('Z_OnlyMoney').AsString;
    end;
  end;

  //----------------------------------------------------------------------------
  nStr := 'Select D_Price From %s Where D_ZID=''%s'' And D_StockNo=''%s''';
  nStr := Format(nStr, [sTable_ZhiKaDtl, FIn.FExtParam, FListB.Values['StockNo']]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := 'ֽ��[ %s ]��û������Ϊ[ %s ]��Ʒ��.';
      nData := Format(nData, [FIn.FExtParam, FListB.Values['StockName']]);
      Exit;
    end;

    FListC.Clear;
    nStr := 'Update %s Set A_OutMoney=A_OutMoney-(%.2f) Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nMon, FListB.Values['CusID']]);
    FListC.Add(nStr); //��ԭ���������

    if FListB.Values['ZKMoney'] = sFlag_Yes then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney+(%.2f) ' +
              'Where Z_ID=''%s'' And Z_OnlyMoney=''%s''';
      nStr := Format(nStr, [sTable_ZhiKa, nMon,
              FListB.Values['ZhiKa'], sFlag_Yes]);
      FListC.Add(nStr); //��ԭ�����������
    end;

    nMon := nVal * FieldByName('D_Price').AsFloat;
    nMon := Float2Float(nMon, cPrecision, True);

    if not TWorkerBusinessCommander.CallMe(cBC_GetZhiKaMoney,
            FIn.FExtParam, '', @nOut) then
    begin
      nData := nOut.FData;
      Exit;
    end;

    if FloatRelation(nMon, StrToFloat(nOut.FData), rtGreater, cPrecision) then
    begin
      nData := '�ͻ�[ %s.%s ]����,��������:' + #13#10#13#10 +
               '��.�������: %.2fԪ' + #13#10 +
               '��.��������: %.2fԪ' + #13#10 +
               '��.�� �� ��: %.2fԪ' + #13#10#13#10 +
               '�뵽�����Ұ���"��������"����,Ȼ���ٴε���.';
      nData := Format(nData, [FListA.Values['CusID'], FListA.Values['CusName'],
               StrToFloat(nOut.FData), nMon,
               Float2Float(nMon - StrToFloat(nOut.FData), cPrecision, True)]);
      Exit;
    end;

    nStr := 'Update %s Set A_OutMoney=A_OutMoney+(%.2f) Where A_CID=''%s''';
    nStr := Format(nStr, [sTable_CusAccount, nMon, FListA.Values['CusID']]);
    FListC.Add(nStr); //���ӵ���������

    if FListA.Values['ZKMoney'] = sFlag_Yes then
    begin
      nStr := 'Update %s Set Z_FixedMoney=Z_FixedMoney+(%.2f) Where Z_ID=''%s''';
      nStr := Format(nStr, [sTable_ZhiKa, nMon, FIn.FExtParam]);
      FListC.Add(nStr); //�ۼ�������������
    end;

    nStr := MakeSQLByStr([SF('L_ZhiKa', FIn.FExtParam),
            SF('L_Project', FListA.Values['Project']),
            SF('L_Area', FListA.Values['Area']),
            SF('L_CusID', FListA.Values['CusID']),
            SF('L_CusName', FListA.Values['CusName']),
            SF('L_CusPY', FListA.Values['CusPY']),
            SF('L_SaleID', FListA.Values['SaleID']),
            SF('L_SaleMan', FListA.Values['SaleMan']),
            SF('L_Price', FieldByName('D_Price').AsFloat, sfVal),
            SF('L_ZKMoney', FListA.Values['ZKMoney'])
            ], sTable_Bill, SF('L_ID', FIn.FData), False);
    FListC.Add(nStr); //���ӵ���������
  end;

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListC.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListC[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//by lih 2016-06-06
//ɾ������΢����Ϣ
function TWorkerBusinessBills.DelBillSendMsgWx(LID:string):Boolean;
var
  nSql,nStr: string;
  nRID:string;
  wxservice:ReviceWS;
  nMsg:WideString;
  nhead:TXmlNode;
  errcode,errmsg:string;
begin
  Result:=False;
  try
    nSql := 'Select a.R_ID,b.C_Factory,b.C_ToUser,a.L_ID,a.L_Card,a.L_Truck,a.L_StockNo,' +
            'a.L_StockName,a.L_CusID,a.L_CusName,a.L_CusAccount,a.L_MDate,a.L_MMan,' +
            'a.L_TransID,a.L_TransName,a.L_Searial,a.L_OutFact,a.L_OutMan From %s a,%s b ' +
            'Where a.L_CusID=b.C_ID and b.C_IsBind=''1'' and a.L_ID =''%s'' ';
    nSql := Format(nSql, [sTable_BillBak,sTable_Customer,LID]);
    {$IFDEF DEBUG}
    WriteLog(nSql);
    {$ENDIF}
    with gDBConnManager.WorkerQuery(FDBConn, nSql) do
    if RecordCount > 0 then
    begin
      nRID:=Fields[0].AsString;
      nStr:='<?xml version="1.0" encoding="UTF-8"?>'+
            '<DATA>'+
            '<head>'+
            '<Factory>'+Fields[1].AsString+'</Factory>'+
            '<ToUser>'+Fields[2].AsString+'</ToUser>'+
            '<MsgType>4</MsgType>'+
            '</head>'+
            '<Items>'+
              '<Item>'+
              '<BillID>'+Fields[3].AsString+'</BillID>'+
              '<Card>'+Fields[4].AsString+'</Card>'+
              '<Truck>'+Fields[5].AsString+'</Truck>'+
              '<StockNo>'+Fields[6].AsString+'</StockNo>'+
              '<StockName>'+Fields[7].AsString+'</StockName>'+
              '<CusID>'+Fields[8].AsString+'</CusID>'+
              '<CusName>'+Fields[9].AsString+'</CusName>'+
              '<CusAccount>'+Fields[10].AsString+'</CusAccount>'+
              '<MakeDate>'+Fields[11].AsString+'</MakeDate>'+
              '<MakeMan>'+Fields[12].AsString+'</MakeMan>'+
              '<TransID>'+Fields[13].AsString+'</TransID>'+
              '<TransName>'+Fields[14].AsString+'</TransName>'+
              '<Searial>'+Fields[15].AsString+'</Searial>'+
              '<OutFact>'+Fields[16].AsString+'</OutFact>'+
              '<OutMan>'+Fields[17].AsString+'</OutMan>'+
              '</Item>'+
            '</Items>'+
             '<remark/>'+
            '</DATA>';
      {$IFDEF DEBUG}
      WriteLog(nStr);
      {$ENDIF}
      wxservice:=GetReviceWS(true,'',nil);
      nMsg:=wxservice.mainfuncs('send_event_msg',nStr);
      {$IFDEF DEBUG}
      WriteLog(nMsg);
      {$ENDIF}
      FPacker.XMLBuilder.ReadFromString(nMsg);
      with FPacker.XMLBuilder do
      begin
        nhead:=Root.FindNode('head');
        if Assigned(nhead) then
        begin
          errcode:=nhead.NodebyName('errcode').ValueAsString;
          errmsg:=nhead.NodebyName('errmsg').ValueAsString;
          if errcode='0' then
          begin
            nSql:='update %s set L_DelSendWx=''Y'' where R_ID=%s';
            nSql:=Format(nSql,[sTable_BillBak,nRID]);
            gDBConnManager.WorkerExec(FDBConn,nSql);
            Result:=True;
          end;
        end;
      end;
    end;
  except
    on e:Exception do
    begin
      WriteLog(e.Message);
    end;
  end;
end;

//Date: 2014-09-16
//Parm: ��������[FIn.FData]
//Desc: ɾ��ָ��������
function TWorkerBusinessBills.DeleteBill(var nData: string): Boolean;
var nIdx: Integer;
    nHasOut: Boolean;
    nVal,nMoney: Double;
    nStr,nP,nFix,nRID,nCus,nBill,nZK: string;
    nOut:TWorkerBusinessCommand;
    nDBZhiKa:TDataSet;
    nHint,nLineRecID:string;
    nSendValue:Double;
begin
  Result := False;
  //init

  nStr := 'Select L_ZhiKa,L_Value,L_Price,L_CusID,L_OutFact,L_ZKMoney,L_LineRecID From %s ' +
          'Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      nData := '������[ %s ]����Ч.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    nHasOut := FieldByName('L_OutFact').AsString <> '';
    //�ѳ���

    if nHasOut then
    begin
      nData := '������[ %s ]�ѳ���,������ɾ��.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
    
    nCus := FieldByName('L_CusID').AsString;
    nZK  := FieldByName('L_ZhiKa').AsString;
    nFix := FieldByName('L_ZKMoney').AsString;

    nVal := FieldByName('L_Value').AsFloat;
    nMoney := Float2Float(nVal*FieldByName('L_Price').AsFloat, cPrecision, True);
    nLineRecID := FieldByName('L_LineRecID').AsString;
  end;
                   
  nStr := 'Select R_ID,T_HKBills,T_Bill From %s ' +
          'Where T_HKBills Like ''%%%s%%''';
  nStr := Format(nStr, [sTable_ZTTrucks, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    if RecordCount <> 1 then
    begin
      nData := '������[ %s ]�����ڶ�����¼��,�쳣��ֹ!';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    nRID := Fields[0].AsString;
    nBill := Fields[2].AsString;
    SplitStr(Fields[1].AsString, FListA, 0, '.')
  end else
  begin
    nRID := '';
    FListA.Clear;
  end;

  FDBConn.FConn.BeginTrans;
  try
    if FListA.Count = 1 then
    begin
      nStr := 'Delete From %s Where R_ID=%s';
      nStr := Format(nStr, [sTable_ZTTrucks, nRID]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end else

    if FListA.Count > 1 then
    begin
      nIdx := FListA.IndexOf(FIn.FData);
      if nIdx >= 0 then
        FListA.Delete(nIdx);
      //�Ƴ��ϵ��б�

      if nBill = FIn.FData then
        nBill := FListA[0];
      //����������

      nStr := 'Update %s Set T_Bill=''%s'',T_Value=T_Value-(%.2f),' +
              'T_HKBills=''%s'' Where R_ID=%s';
      nStr := Format(nStr, [sTable_ZTTrucks, nBill, nVal,
              CombinStr(FListA, '.'), nRID]);
      //xxxxx

      gDBConnManager.WorkerExec(FDBConn, nStr);
      //���ºϵ���Ϣ
    end;

    //--------------------------------------------------------------------------
    {if nHasOut then
    begin
      nDBZhiKa:=LoadZhiKaInfo(nZK,nHint);
      with nDBZhiKa do
      begin
        if FieldByName('C_ContQuota').AsString='1' then
        begin
          nStr := 'Update %s Set A_ConOutMoney=A_ConOutMoney-(%.2f) Where A_CID=''%s''';
          nStr := Format(nStr, [sTable_CusAccount, nMoney, nCus]);
        end else
        begin
          nStr := 'Update %s Set A_OutMoney=A_OutMoney-(%.2f) Where A_CID=''%s''';
          nStr := Format(nStr, [sTable_CusAccount, nMoney, nCus]);
        end;
        gDBConnManager.WorkerExec(FDBConn, nStr);
      end;
      //�ͷų���
    end else}
    //if (GetOnLineModel <> sFlag_Yes) then
    begin
      nDBZhiKa:=LoadZhiKaInfo(nZK,nHint);
      if Assigned(nDBZhiKa) then
      with nDBZhiKa do
      begin
        if FieldByName('Z_TriangleTrade').AsString <> '1' then
        begin
          if FieldByName('C_ContQuota').AsString='1' then
          begin
            nStr := 'Update %s Set A_ConFreezeMoney=A_ConFreezeMoney-(%.2f) Where A_CID=''%s''';
            nStr := Format(nStr, [sTable_CusAccount, nMoney, nCus]);
          end else
          begin
            nStr := 'Update %s Set A_FreezeMoney=A_FreezeMoney-(%.2f) Where A_CID=''%s''';
            nStr := Format(nStr, [sTable_CusAccount, nMoney, nCus]);
          end;
          gDBConnManager.WorkerExec(FDBConn, nStr);
          WriteLog('['+FIn.FData+']Release YKMoney: '+nStr);
        end;
      end;
      //�ͷŶ����
    end;

    //--------------------------------------------------------------------------
    nStr := Format('Select * From %s Where 1<>1', [sTable_Bill]);
    //only for fields
    nP := '';

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      for nIdx:=0 to FieldCount - 1 do
       if (Fields[nIdx].DataType <> ftAutoInc) and
          (Pos('L_Del', Fields[nIdx].FieldName) < 1) then
        nP := nP + Fields[nIdx].FieldName + ',';
      //�����ֶ�,������ɾ��

      System.Delete(nP, Length(nP), 1);
    end;

    nStr := 'Insert Into $BB($FL,L_DelMan,L_DelDate) ' +
            'Select $FL,''$User'',$Now From $BI Where L_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$BB', sTable_BillBak),
            MI('$FL', nP), MI('$User', FIn.FBase.FFrom.FUser),
            MI('$Now', sField_SQLServer_Now),
            MI('$BI', sTable_Bill), MI('$ID', FIn.FData)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Delete From %s Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    
    FDBConn.FConn.CommitTrans;

    nStr := 'select IsNull(SUM(L_Value),''0'') as SendValue from %s where L_LineRecID=''%s'' ';
    nStr := Format(nStr,[sTable_Bill, nLineRecID]);
    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      nSendValue := Fields[0].AsFloat;
    end;

    nStr := 'Update %s Set D_Value=D_Value + (%.2f) Where D_RECID=''%s''';
    nStr := Format(nStr, [sTable_ZhiKaDtl, nVal, nLineRecID]);
    //xxxxx
    gDBConnManager.WorkerExec(FDBConn, nStr);
    
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
  if gSysParam.FGPWSURL <> '' then
  begin
    //�޸��̳Ƕ���״̬
    ModifyWebOrderStatus(FIn.FData,2);
  end;
end;

//Date: 2014-09-17
//Parm: ������[FIn.FData];�ſ���[FIn.FExtParam]
//Desc: Ϊ�������󶨴ſ�
function TWorkerBusinessBills.SaveBillCard(var nData: string): Boolean;
var nStr,nSQL,nTruck,nType,nLid: string;
begin  
  nType := '';
  nTruck := '';
  Result := False;

  FListB.Text := FIn.FExtParam;
  //�ſ��б�
  nStr := AdjustListStrFormat(FIn.FData, '''', True, ',', False);
  //�������б�
  nLid := nStr;

  nSQL := 'Select L_ID,L_Card,L_Type,L_Truck,L_OutFact From %s ' +
          'Where L_ID In (%s)';
  nSQL := Format(nSQL, [sTable_Bill, nStr]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('������[ %s ]�Ѷ�ʧ.', [FIn.FData]);
      Exit;
    end;

    First;
    while not Eof do
    begin
      if FieldByName('L_OutFact').AsString <> '' then
      begin
        nData := '������[ %s ]�ѳ���,��ֹ�쿨.';
        nData := Format(nData, [FieldByName('L_ID').AsString]);
        Exit;
      end;

      nStr := FieldByName('L_Truck').AsString;
      if (nTruck <> '') and (nStr <> nTruck) then
      begin
        nData := '������[ %s ]�ĳ��ƺŲ�һ��,���ܲ���.' + #13#10#13#10 +
                 '*.��������: %s' + #13#10 +
                 '*.��������: %s' + #13#10#13#10 +
                 '��ͬ�ƺŲ��ܲ���,���޸ĳ��ƺ�,���ߵ����쿨.';
        nData := Format(nData, [FieldByName('L_ID').AsString, nStr, nTruck]);
        Exit;
      end;

      if nTruck = '' then
        nTruck := nStr;
      //xxxxx

      nStr := FieldByName('L_Type').AsString;
      if (nType <> '') and ((nStr <> nType) or (nStr = sFlag_San)) then
      begin
        if nStr = sFlag_San then
             nData := '������[ %s ]ͬΪɢװ,���ܲ���.'
        else nData := '������[ %s ]��ˮ�����Ͳ�һ��,���ܲ���.';
          
        nData := Format(nData, [FieldByName('L_ID').AsString]);
        Exit;
      end;

      if nType = '' then
        nType := nStr;
      //xxxxx

      nStr := FieldByName('L_Card').AsString;
      //����ʹ�õĴſ�
        
      if (nStr <> '') and (FListB.IndexOf(nStr) < 0) then
        FListB.Add(nStr);
      Next;
    end;
  end;

  //----------------------------------------------------------------------------
  SplitStr(FIn.FData, FListA, 0, ',');
  //�������б�
  nStr := AdjustListStrFormat2(FListB, '''', True, ',', False);
  //�ſ��б�

  nSQL := 'Select L_ID,L_Type,L_Truck From %s Where L_Card In (%s)';
  nSQL := Format(nSQL, [sTable_Bill, nStr]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := FieldByName('L_Type').AsString;
      if (nStr <> sFlag_Dai) or ((nType <> '') and (nStr <> nType)) then
      begin
        nData := '����[ %s ]����ʹ�øÿ�,�޷�����.';
        nData := Format(nData, [FieldByName('L_Truck').AsString]);
        Exit;
      end;

      nStr := FieldByName('L_Truck').AsString;
      if (nTruck <> '') and (nStr <> nTruck) then
      begin
        nData := '����[ %s ]����ʹ�øÿ�,��ͬ�ƺŲ��ܲ���.';
        nData := Format(nData, [nStr]);
        Exit;
      end;

      nStr := FieldByName('L_ID').AsString;
      if FListA.IndexOf(nStr) < 0 then
        FListA.Add(nStr);
      Next;
    end;
  end;

  //----------------------------------------------------------------------------
  nSQL := 'Select T_HKBills From %s Where T_Truck=''%s'' ';
  nSQL := Format(nSQL, [sTable_ZTTrucks, nTruck]);

  //���ڶ����г���
  nStr := '';
  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    try
      nStr := nStr + Fields[0].AsString;
    finally
      Next;
    end;

    nStr := Copy(nStr, 1, Length(nStr)-1);
    nStr := StringReplace(nStr, '.', ',', [rfReplaceAll]);
  end; 

  nStr := AdjustListStrFormat(nStr, '''', True, ',', False);
  //�����н������б�

  nSQL := 'Select L_Card From %s Where L_ID In (%s)';
  nSQL := Format(nSQL, [sTable_Bill, nStr]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      if (Fields[0].AsString <> '') and
         (Fields[0].AsString <> FIn.FExtParam) then
      begin
        nData := '����[ %s ]�Ĵſ��Ų�һ��,���ܲ���.' + #13#10#13#10 +
                 '*.�����ſ�: [%s]' + #13#10 +
                 '*.�����ſ�: [%s]' + #13#10#13#10 +
                 '��ͬ�ſ��Ų��ܲ���,���޸ĳ��ƺ�,���ߵ����쿨.';
        nData := Format(nData, [nTruck, FIn.FExtParam, Fields[0].AsString]);
        Exit;
      end;

      Next;
    end;  
  end;

  FDBConn.FConn.BeginTrans;
  try
    if FIn.FData <> '' then
    begin
      nStr := AdjustListStrFormat2(FListA, '''', True, ',', False);
      //���¼����б�

      nSQL := 'Update %s Set L_Card=''%s'' Where L_ID In(%s)';
      nSQL := Format(nSQL, [sTable_Bill, FIn.FExtParam, nStr]);
      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end;

    nStr := 'Select Count(*) From %s Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, FIn.FExtParam]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if Fields[0].AsInteger < 1 then
    begin
      nStr := MakeSQLByStr([SF('C_Card', FIn.FExtParam),
              SF('C_Status', sFlag_CardUsed),
              SF('C_Used', sFlag_Sale),
              SF('C_Freeze', sFlag_No),
              SF('C_Man', FIn.FBase.FFrom.FUser),
              SF('C_Date', sField_SQLServer_Now, sfVal)
              ], sTable_Card, '', True);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end else
    begin
      nStr := Format('C_Card=''%s''', [FIn.FExtParam]);
      nStr := MakeSQLByStr([SF('C_Status', sFlag_CardUsed),
              SF('C_Used', sFlag_Sale),
              SF('C_Freeze', sFlag_No),
              SF('C_Man', FIn.FBase.FFrom.FUser),
              SF('C_Date', sField_SQLServer_Now, sfVal)
              ], sTable_Card, nStr, False);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
  if gSysParam.FGPWSURL <> '' then
  begin
    {$IFDEF PLKP}
    nLid := Copy(nLid,2,Length(nLid)-2);
    ModifyWebOrderStatus(nLid,c_WeChatStatusCreateCard,'');
    {$ENDIF}
  end;
end;

//Date: 2014-09-17
//Parm: �ſ���[FIn.FData]
//Desc: ע���ſ�
function TWorkerBusinessBills.LogoffCard(var nData: string): Boolean;
var nStr: string;
  nNeidao:string;
begin
  nNeidao := FIn.FExtParam;
  FDBConn.FConn.BeginTrans;
  try
    if nNeidao=sflag_yes then
    begin
      nStr := 'Update %s Set l_status=''%s'',l_nextstatus='''' Where L_Card=''%s'' and l_status=''%s'' and l_nextstatus=''%s''';
      nStr := Format(nStr, [sTable_Bill, sFlag_TruckOut, FIn.FData, sFlag_TruckIn, sFlag_TruckBFP]);
      gDBConnManager.WorkerExec(FDBConn, nStr);

      nStr := 'delete from %s where t_bill =(select l_id from %s where l_card=''%s'')';
      nStr := Format(nStr, [sTable_ZTTrucks, sTable_Bill, FIn.FData]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;
    nStr := 'Update %s Set L_Card=Null Where L_Card=''%s''';
    nStr := Format(nStr, [sTable_Bill, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Update %s Set C_Status=''%s'', C_Used=Null Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, sFlag_CardInvalid, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-17
//Parm: �ſ���[FIn.FData];��λ[FIn.FExtParam]
//Desc: ��ȡ�ض���λ����Ҫ�Ľ������б�
function TWorkerBusinessBills.GetPostBillItems(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nIsBill: Boolean;
    nBills: TLadingBillItems;
begin
  Result := False;
  nIsBill := False;

  nStr := 'Select B_Prefix, B_IDLen From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_BillNo]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nIsBill := (Pos(Fields[0].AsString, FIn.FData) = 1) and
               (Length(FIn.FData) = Fields[1].AsInteger);
    //ǰ׺�ͳ��ȶ����㽻�����������,����Ϊ��������
  end;

  if not nIsBill then
  begin
    nStr := 'Select C_Status,C_Freeze From %s Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, FIn.FData]);
    //card status

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := Format('�ſ�[ %s ]��Ϣ�Ѷ�ʧ.', [FIn.FData]);
        Exit;
      end;

      if Fields[0].AsString <> sFlag_CardUsed then
      begin
        nData := '�ſ�[ %s ]��ǰ״̬Ϊ[ %s ],�޷����.';
        nData := Format(nData, [FIn.FData, CardStatusToStr(Fields[0].AsString)]);
        Exit;
      end;

      if Fields[1].AsString = sFlag_Yes then
      begin
        nData := '�ſ�[ %s ]�ѱ�����,�޷����.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;
    end;
  end;

  nStr := 'Select L_ID,L_ZhiKa,L_CusID,L_CusName,L_Type,L_StockNo,' +
          'L_StockName,L_Truck,L_Value,L_Price,L_ZKMoney,L_Status,' +
          'L_NextStatus,L_Card,L_IsVIP,L_PValue,L_MValue,L_SalesType,'+
          'L_EmptyOut,L_LineRecID,L_InvLocationId,L_InvCenterId,'+
          'L_IfNeiDao,L_TriaTrade,L_szbz,L_color From $Bill b ';
  //xxxxx

  if nIsBill then
       nStr := nStr + 'Where L_ID=''$CD'''
  else nStr := nStr + 'Where L_Card=''$CD''';

  nStr := MacroValue(nStr, [MI('$Bill', sTable_Bill), MI('$CD', FIn.FData)]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      if nIsBill then
           nData := '������[ %s ]����Ч.'
      else nData := '�ſ���[ %s ]û�н�����.';

      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    SetLength(nBills, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    with nBills[nIdx] do
    begin
      FID         := FieldByName('L_ID').AsString;
      FZhiKa      := FieldByName('L_ZhiKa').AsString;
      FCusID      := FieldByName('L_CusID').AsString;
      FCusName    := FieldByName('L_CusName').AsString;
      FTruck      := FieldByName('L_Truck').AsString;

      FType       := FieldByName('L_Type').AsString;
      FStockNo    := FieldByName('L_StockNo').AsString;
      FStockName  := FieldByName('L_StockName').AsString;
      FValue      := FieldByName('L_Value').AsFloat;
      FPrice      := FieldByName('L_Price').AsFloat;

      FCard       := FieldByName('L_Card').AsString;
      FIsVIP      := FieldByName('L_IsVIP').AsString;
      FStatus     := FieldByName('L_Status').AsString;
      FNextStatus := FieldByName('L_NextStatus').AsString;

      if FIsVIP = sFlag_TypeShip then
      begin
        FStatus    := sFlag_TruckZT;
        FNextStatus := sFlag_TruckOut;
      end;

      if FStatus = sFlag_BillNew then
      begin
        FStatus     := sFlag_TruckNone;
        FNextStatus := sFlag_TruckNone;
      end;

      FPData.FValue := FieldByName('L_PValue').AsFloat;
      FMData.FValue := FieldByName('L_MValue').AsFloat;
      FSalesType    := FieldByName('L_SalesType').AsString;

      FYSValid      := FieldByName('L_EmptyOut').AsString;
      FRecID        := FieldByName('L_LineRecID').AsString;
      FLocationID   := FieldByName('L_InvLocationId').AsString;

      FCenterID     := FieldByName('L_InvCenterId').AsString;
      FNeiDao       := FieldByName('L_IfNeiDao').AsString;
      FTriaTrade    := FieldByName('L_TriaTrade').AsString;
      Fszbz         := FieldByName('L_szbz').asString;
      Fcolor        := FieldByName('L_color').asString;

      if FNeiDao=sflag_yes then
      begin
        FMData.FValue := 0;      
        if (FStatus=sFlag_TruckIn) and (FnextStatus=sFlag_TruckBFP) then
        begin
          FPData.FValue := 0;
        end;
      end;
      
      FSelected := True;

      Inc(nIdx);
      Next;
    end;
  end;

  FOut.FData := CombineBillItmes(nBills);
  Result := True;
end;

//Date: 2014-09-18
//Parm: ������[FIn.FData];��λ[FIn.FExtParam]
//Desc: ����ָ����λ�ύ�Ľ������б�
function TWorkerBusinessBills.SavePostBillItems(var nData: string): Boolean;
var nStr,nSQL,nTmp: string;
    f,m,nVal,nMVal: Double;
    i,nIdx,nInt: Integer;
    nBills: TLadingBillItems;
    nOut: TWorkerBusinessCommand;
    nUpdateVal: Double;
    nBxz:Boolean;
    nAxMoney: Double;
    nAxMsg,nOnLineModel: string;
    nDBZhiKa:TDataSet;
    nHint,nReiNo: string;
    nTriaTrade: string;
    nTriCusID, nCompanyId: string;
    nS, nNs, nCard:string;
begin
  Result := False;
  AnalyseBillItems(FIn.FData, nBills);
  nInt := Length(nBills);

  if nInt < 1 then
  begin
    nData := '��λ[ %s ]�ύ�ĵ���Ϊ��.';
    nData := Format(nData, [PostTypeToStr(FIn.FExtParam)]);
    Exit;
  end;

  if (nBills[0].FType = sFlag_San) and (nInt > 1) then
  begin
    nData := '��λ[ %s ]�ύ��ɢװ�ϵ�,��ҵ��ϵͳ��ʱ��֧��.';
    nData := Format(nData, [PostTypeToStr(FIn.FExtParam)]);
    Exit;
  end;

  FListA.Clear;
  //���ڴ洢SQL�б�

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckIn then //����
  begin
    with nBills[0] do
    begin
      FStatus := sFlag_TruckIn;
      FNextStatus := sFlag_TruckBFP;
    end;

    if nBills[0].FType = sFlag_Dai then
    begin
      nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
      nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_PoundIfDai]);

      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
       if (RecordCount > 0) and (Fields[0].AsString = sFlag_No) then
        nBills[0].FNextStatus := sFlag_TruckZT;
      //��װ������
    end; 

    for nIdx:=Low(nBills) to High(nBills) do
    begin
      nStr := SF('L_ID', nBills[nIdx].FID);
      nSQL := MakeSQLByStr([
              SF('L_Status', nBills[0].FStatus),
              SF('L_NextStatus', nBills[0].FNextStatus),
              SF('L_InTime', sField_SQLServer_Now, sfVal),
              SF('L_InMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, nStr, False);
      FListA.Add(nSQL);

      nSQL := 'Update %s Set T_InFact=%s Where T_HKBills Like ''%%%s%%''';
      nSQL := Format(nSQL, [sTable_ZTTrucks, sField_SQLServer_Now,
              nBills[nIdx].FID]);
      FListA.Add(nSQL);
      //���¶��г�������״̬
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckBFP then //����Ƥ��
  begin
    FListB.Clear;
    nStr := 'Select D_Value From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_NFStock]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        FListB.Add(Fields[0].AsString);
        Next;
      end;
    end;

    nInt := -1;
    for nIdx:=Low(nBills) to High(nBills) do
    if nBills[nIdx].FPoundID = sFlag_Yes then
    begin
      nInt := nIdx;
      Break;
    end;

    if nInt < 0 then
    begin
      nData := '��λ[ %s ]�ύ��Ƥ������Ϊ0.';
      nData := Format(nData, [PostTypeToStr(FIn.FExtParam)]);
      Exit;
    end;

    //--------------------------------------------------------------------------
    FListC.Clear;
    FListC.Values['Field'] := 'T_PValue';
    FListC.Values['Truck'] := nBills[nInt].FTruck;
    FListC.Values['Value'] := FloatToStr(nBills[nInt].FPData.FValue);

    if not TWorkerBusinessCommander.CallMe(cBC_UpdateTruckInfo,
          FListC.Text, '', @nOut) then
      raise Exception.Create(nOut.FData);
    //���泵����ЧƤ��

    FListC.Clear;
    FListC.Values['Group'] := sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_PoundID;

    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      FStatus := sFlag_TruckBFP;
      if FType = sFlag_Dai then
           FNextStatus := sFlag_TruckZT
      else FNextStatus := sFlag_TruckFH;

      if FListB.IndexOf(FStockNo) >= 0 then
        FNextStatus := sFlag_TruckBFM;
      //�ֳ�������ֱ�ӹ���

      nSQL := MakeSQLByStr([
              SF('L_Status', FStatus),
              SF('L_NextStatus', FNextStatus),
              SF('L_PValue', nBills[nInt].FPData.FValue, sfVal),
              SF('L_PDate', sField_SQLServer_Now, sfVal),
              SF('L_PMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, SF('L_ID', FID), False);
      FListA.Add(nSQL);

      if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
            FListC.Text, sFlag_Yes, @nOut) then
        raise Exception.Create(nOut.FData);
      //xxxxx

      FOut.FData := nOut.FData;
      //���ذ񵥺�,�������հ�

      nSQL := MakeSQLByStr([
              SF('P_ID', nOut.FData),
              SF('P_Type', sFlag_Sale),
              SF('P_Bill', FID),
              SF('P_Truck', FTruck),
              SF('P_CusID', FCusID),
              SF('P_CusName', FCusName),
              SF('P_MID', FStockNo),
              SF('P_MName', FStockName),
              SF('P_MType', FType),
              SF('P_LimValue', FValue),
              SF('P_PValue', nBills[nInt].FPData.FValue, sfVal),
              SF('P_PDate', sField_SQLServer_Now, sfVal),
              SF('P_PMan', FIn.FBase.FFrom.FUser),
              SF('P_FactID', nBills[nInt].FFactory),
              SF('P_PStation', nBills[nInt].FPData.FStation),
              SF('P_Direction', '����'),
              SF('P_PModel', FPModel),
              SF('P_Status', sFlag_TruckBFP),
              SF('P_Valid', sFlag_Yes),
              SF('P_PrintNum', 1, sfVal)
              ], sTable_PoundLog, '', True);
      FListA.Add(nSQL);
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckZT then //ջ̨�ֳ�
  begin
    nInt := -1;
    for nIdx:=Low(nBills) to High(nBills) do
    if nBills[nIdx].FPData.FValue > 0 then
    begin
      nInt := nIdx;
      Break;
    end;

    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      FStatus := sFlag_TruckZT;
      if nInt >= 0 then //�ѳ�Ƥ
           FNextStatus := sFlag_TruckBFM
      else FNextStatus := sFlag_TruckOut;

      {$IFDEF QHSN}
      nStr := 'select Z_Name,Z_CenterID from %s a,%s b '+
              'where a.Z_ID = b.T_Line and b.T_Bill = ''%s'' ';
      nStr := Format(nStr, [sTable_ZTLines,sTable_ZTTrucks,FID]);
      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      if RecordCount > 0 then
      begin
        FCenterID:= FieldByName('Z_CenterID').AsString;
        FKw:= FieldByName('Z_Name').AsString;
      end;

      if FNeiDao=sflag_yes then
      begin
        nReiNo := '';
        FSampleID := ''; 
      end
      else begin
        if not TWorkerBusinessCommander.CallMe(cBC_GetSampleID,
          FStockName, FCenterID, @nOut) then
        begin
          WriteLog(nOut.FData);
          raise Exception.Create(nOut.FData);
        end;
        if nOut.FData='' then
        begin
          nData := '��λ[ %s ]�������ʹ�����.';
          nData := Format(nData, [PostTypeToStr(FIn.FExtParam)]);
          WriteLog(nData);
          Exit;
        end;

        nReiNo:=nOut.FData;  //��ȡʽ�����
        WriteLog('['+FID+']GetSampleID: '+nReiNo);
        FSampleID := nReiNo;
//        try
//          SaveHyDan(FID + sFlag_ManualD,nReiNo,FStockno,FStockname,FIn.FExtParam,'Y=ͨ��;N=��ֹ;I=����', '������');
//        except
//        end;
      end;

      nSQL := MakeSQLByStr([SF('L_Status', FStatus),
              SF('L_NextStatus', FNextStatus),
              SF('L_LadeTime', sField_SQLServer_Now, sfVal),
              SF('L_LadeMan', FIn.FBase.FFrom.FUser),
              SF('L_EmptyOut', FYSValid),
              SF('L_WorkOrder', FWorkOrder),
              SF('L_InvCenterId', FCenterID),
              SF('L_HYDan', nReiNo),
              SF('L_CW', FKw)
              ], sTable_Bill, SF('L_ID', FID), False);
      {$ELSE}
      nSQL := MakeSQLByStr([SF('L_Status', FStatus),              SF('L_NextStatus', FNextStatus),              SF('L_LadeTime', sField_SQLServer_Now, sfVal),              SF('L_LadeMan', FIn.FBase.FFrom.FUser),              SF('L_HYDan', FSampleID),              SF('L_EmptyOut', FYSValid),              SF('L_WorkOrder', FWorkOrder),              SF('L_CW', FKw)              ], sTable_Bill, SF('L_ID', FID), False);      {$ENDIF}
      FListA.Add(nSQL);
      
      nSQL := 'Update %s Set T_InLade=%s Where T_HKBills Like ''%%%s%%''';
      nSQL := Format(nSQL, [sTable_ZTTrucks, sField_SQLServer_Now, FID]);
      FListA.Add(nSQL);
      //���¶��г������״̬
    end;
  end else

  if FIn.FExtParam = sFlag_TruckFH then //�Ż��ֳ�
  begin
    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      {$IFDEF QHSN}
      nStr := 'select Z_Name,Z_CenterID from %s a,%s b '+
              'where a.Z_ID = b.T_Line and b.T_Bill = ''%s'' ';
      nStr := Format(nStr, [sTable_ZTLines,sTable_ZTTrucks,FID]);
      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      if RecordCount > 0 then
      begin
        FCenterID:= FieldByName('Z_CenterID').AsString;
        FKw:= FieldByName('Z_Name').AsString;
      end;
      if FNeiDao=sFlag_Yes then
      begin
        nReiNo := '';
        FSampleID := nReiNo;
      end
      else begin
        if not TWorkerBusinessCommander.CallMe(cBC_GetSampleID,
          FStockName, FCenterID, @nOut) then
        begin
          WriteLog(nOut.FData);
          raise Exception.Create(nOut.FData);
        end;
        if nOut.FData='' then
        begin
          nData := '��λ[ %s ]�������ʹ�����.';
          nData := Format(nData, [PostTypeToStr(FIn.FExtParam)]);
          WriteLog(nData);
          Exit;
        end;

        nReiNo:=nOut.FData; //��ȡʽ�����
        WriteLog('['+FID+']GetSampleID: '+nReiNo);
        FSampleID := nReiNo;
//        try
//          SaveHyDan(FID + sFlag_ManualD,nReiNo,FStockno,FStockname,FIn.FExtParam,'Y=ͨ��;N=��ֹ;I=����', '������');
//        except
//        end;
      end;

      nSQL := MakeSQLByStr([SF('L_Status', sFlag_TruckFH),
              SF('L_NextStatus', sFlag_TruckBFM),
              SF('L_LadeTime', sField_SQLServer_Now, sfVal),
              SF('L_LadeMan', FIn.FBase.FFrom.FUser),
              SF('L_EmptyOut', FYSValid),
              SF('L_WorkOrder', FWorkOrder),
              SF('L_InvCenterId', FCenterID),
              SF('L_HYDan', nReiNo),
              SF('L_CW', FKw)
              ], sTable_Bill, SF('L_ID', FID), False);
      {$ELSE}
      nSQL := MakeSQLByStr([SF('L_Status', sFlag_TruckFH),              SF('L_NextStatus', sFlag_TruckBFM),              SF('L_LadeTime', sField_SQLServer_Now, sfVal),              SF('L_LadeMan', FIn.FBase.FFrom.FUser),              SF('L_HYDan', FSampleID),              SF('L_EmptyOut', FYSValid),              SF('L_WorkOrder', FWorkOrder),              SF('L_CW', FKw)              ], sTable_Bill, SF('L_ID', FID), False);      {$ENDIF}
      FListA.Add(nSQL);

      nSQL := 'Update %s Set T_InLade=%s Where T_HKBills Like ''%%%s%%''';
      nSQL := Format(nSQL, [sTable_ZTTrucks, sField_SQLServer_Now, FID]);
      FListA.Add(nSQL);
      //���¶��г������״̬
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckBFM then //����ë��
  begin
    nBxz := True;
    nInt := -1;
    nMVal := 0;
    
    for nIdx:=Low(nBills) to High(nBills) do
    if nBills[nIdx].FPoundID = sFlag_Yes then
    begin
      nMVal := nBills[nIdx].FMData.FValue;
      nInt := nIdx;
      Break;
    end;

    if nInt < 0 then
    begin
      nData := '��λ[ %s ]�ύ��ë������Ϊ0.';
      nData := Format(nData, [PostTypeToStr(FIn.FExtParam)]);
      Exit;
    end;

    with nBills[0] do//ɢװ��װ����У���ʽ��
    begin
      if FYSValid <> sFlag_Yes then   //�ж��Ƿ�ճ�����
      begin
        nOnLineModel:=GetOnLineModel; //��ȡ�Ƿ�����ģʽ
        if nBills[0].FSalesType='0' then
        begin
          nBxz:=False;
        end else
        begin
          {if not TWorkerBusinessCommander.CallMe(cBC_GetTriangleTrade,    //��ȡ�Ƿ�����ó��
                nBills[0].FZhiKa, '', @nOut) then
          begin
            nData := nOut.FData;
            Exit;
          end;
          nTriaTrade:=nOut.FData;
          if nTriaTrade = sFlag_Yes then }   // ����ó��
          WriteLog('ó�����ͣ�'+FTriaTrade);
          if FTriaTrade = '1' then    // ����ó��
          begin
            if nOnLineModel=sFlag_Yes then   //����ģʽ��Զ�̻�ȡ�ͻ��ʽ���
            begin
              if not TWorkerBusinessCommander.CallMe(cBC_GetCustNo,    //��ȡ���տͻ�
                    nBills[0].FZhiKa, '', @nOut) then
              begin
                nData := nOut.FData;
                WriteLog(nData);
                Exit;
              end;
              nTriCusID:= nOut.FData;
              nCompanyId:= nOut.FExtParam;
              if nCompanyId = '' then nCompanyId := gCompanyAct;
              if not TWorkerBusinessCommander.CallMe(cBC_GetAXMaCredLmt, //�Ƿ�ǿ�����ö��
                      nTriCusID, nCompanyId, @nOut) then
              begin
                nData := nOut.FData;
                WriteLog(nData);
                Result:= True;
                Exit;
              end;
              if nOut.FData = sFlag_No then
              begin
                nBxz:=False;
              end;
              if nBxz then
              begin
                if not GetRemTriCustomerMoney(nBills[0].FZhiKa,nAxMoney,nAxMsg) then
                begin
                  nData:=nAxMsg;
                  Result:=True;
                  Exit;
                end;
              end;

              //+dmzn: 2017-07-24,ǿ��ʹ�ñ�������
              nStr := 'Select C_AntiAXCredit From %s Where C_ID=''%s''';
              nStr := Format(nStr, [sTable_Customer, nTriCusID]);

              with gDBConnManager.WorkerQuery(FDBConn, nStr) do
              if RecordCount > 0 then
              begin
                nVal := Fields[0].AsFloat;
                if nVal > 0 then
                begin
                  nAxMoney := nAxMoney + nVal;
                  nStr := '�ͻ�[ %s ]��֤����[ %s ]ʱʹ����ʱ����[ %.2f ]Ԫ.';
                  WriteLog(Format(nStr, [nTriCusID, nBills[0].FZhiKa, nVal]));
                end;
                nAxMoney := Float2Float(nAxMoney, cPrecision, False);
              end;
            end else
            begin
              nData:='����ģʽ����ȡ����ó�׿ͻ���Ϣʧ��';
              WriteLog(nData);
              Result:=True;
              Exit;
            end;
          end else
          begin
            if not TWorkerBusinessCommander.CallMe(cBC_CustomerMaCredLmt,
                  nBills[0].FCusID, '', @nOut) then
            begin
              nData := nOut.FData;
              Exit;
            end;
            if nOut.FData= sFlag_No then
            begin
              nBxz:=False;
            end;
            if nBxz then
            begin
              if nOnLineModel=sFlag_Yes then   //����ģʽ��Զ�̻�ȡ�ͻ��ʽ���
              begin
                if not GetRemCustomerMoney(nBills[0].FZhiKa,nAxMoney,nAxMsg) then
                begin
                  nData:=nAxMsg;
                  Result:=True;
                  Exit;
                end;
              end;
              if not TWorkerBusinessCommander.CallMe(cBC_GetCustomerMoney,  //���ػ�ȡ�ͻ��ʽ���
               nBills[0].FZhiKa, '', @nOut) then
              begin
                nData := nOut.FData;
                Result:=True;
                Exit;
              end;
              m := StrToFloat(nOut.FData);
              WriteLog(nBills[0].FID+'�����ʽ�'+Floattostr(m));
              m := m + Float2Float(FPrice * FValue, cPrecision, False);
              WriteLog(nBills[0].FCusID+'�����ʽ�'+Floattostr(Float2Float(FPrice * FValue, cPrecision, False)));
              //�ͻ����ý�
            end;
          end;
          if nBxz and (nOnLineModel=sFlag_Yes) then
          begin
            nStr := 'select IsNull(SUM(L_Value*L_Price),''0'') as L_TotalMoney from %s where L_BDAX=''2'' and L_CusID=''%s'' ';
            nStr := Format(nStr,[sTable_Bill, FCusID]);
            with gDBConnManager.WorkerQuery(FDBConn, nStr) do
            if RecordCount > 0 then
            begin
              nAxMoney := nAxMoney - Fields[0].AsFloat;
            end;
            WriteLog(nBills[0].FID+'�����ʽ�'+Floattostr(nAxMoney));
          end;
        end;

        if FType = sFlag_Dai then
        begin
          if nBxz then
          begin
            if nOnLineModel=sFlag_Yes then
            begin
              f := Float2Float(FPrice * FValue, cPrecision, True) - nAxMoney;
              //ʵ������������ý���
              if (f > 0) then
              begin
                nData := '�ͻ�[ %s.%s ]�ʽ�����,��������:' + #13#10#13#10 +
                         '���ý��: %.2fԪ' + #13#10 +
                         '������: %.2fԪ' + #13#10 +
                         '�� �� ��: %.2fԪ' + #13#10+#13#10 +
                         '�뵽�����Ұ���"��������"����,Ȼ���ٴγ���.';
                nData := Format(nData, [FCusID, FCusName, nAxMoney, FPrice * FValue, f]);
                nStr := '�ͻ��ʽ�����,�貹��: %.2fԪ';
                nStr := Format(nStr, [f]);
                FOut.FData:= nStr;
                Result:=True;
                Exit;
              end;
            end;
            //if nTriaTrade <> sFlag_Yes then
            if FTriaTrade <> '1' then
            begin
              f := Float2Float(FPrice * FValue, cPrecision, True) - m;
              //ʵ������������ý���
              if (f > 0) then
              begin
                nData := '�ͻ�[ %s.%s ]�ʽ�����,��������:' + #13#10#13#10 +
                         '���ý��: %.2fԪ' + #13#10 +
                         '������: %.2fԪ' + #13#10 +
                         '�� �� ��: %.2fԪ' + #13#10+#13#10 +
                         '�뵽�����Ұ���"��������"����,Ȼ���ٴγ���.';
                nData := Format(nData, [FCusID, FCusName, m, FPrice * FValue, f]);
                nStr := '�ͻ��ʽ�����,�貹��: %.2fԪ';
                nStr := Format(nStr, [f]);
                FOut.FData:= nStr;
                Result:=True;
                Exit;
              end;
            end;
          end;
        end else
        begin
          nVal := FValue;
          FValue := nMVal - FPData.FValue;
            //�¾���,ʵ�������
          if nBxz then
          begin
            if nOnLineModel=sFlag_Yes then
            begin
              f := Float2Float(FPrice * FValue, cPrecision, True) - nAxMoney;
              //ʵ������������ý���
              if (f > 0) then
              begin
                nData := '�ͻ�[ %s.%s ]�ʽ�����,��������:' + #13#10#13#10 +
                         '���ý��: %.2fԪ' + #13#10 +
                         '������: %.2fԪ' + #13#10 +
                         '�� �� ��: %.2fԪ' + #13#10+#13#10 +
                         '�뵽�����Ұ���"��������"����,Ȼ���ٴγ���.';
                nData := Format(nData, [FCusID, FCusName, nAxMoney, FPrice * FValue, f]);
                nStr := '�ͻ��ʽ�����,�貹��: %.2fԪ';
                nStr := Format(nStr, [f]);
                FOut.FData:= nStr;
                Result:=True;
                Exit;
              end;
            end;
            //if nTriaTrade <> sFlag_Yes then
            if FTriaTrade <> '1' then
            begin
              f := Float2Float(FPrice * FValue, cPrecision, True) - m;
              //ʵ������������ý���
              if (f > 0) then
              begin
                nData := '�ͻ�[ %s.%s ]�ʽ�����,��������:' + #13#10#13#10 +
                         '���ý��: %.2fԪ' + #13#10 +
                         '������: %.2fԪ' + #13#10 +
                         '�� �� ��: %.2fԪ' + #13#10+#13#10 +
                         '�뵽�����Ұ���"��������"����,Ȼ���ٴγ���.';
                nData := Format(nData, [FCusID, FCusName, m, FPrice * FValue, f]);
                nStr := '�ͻ��ʽ�����,�貹��: %.2fԪ';
                nStr := Format(nStr, [f]);
                FOut.FData:= nStr;
                Result:=True;
                Exit;
              end;
            end;
          end;

          //if nTriaTrade <> sFlag_Yes then
          if FTriaTrade <> '1' then
          begin
            m := Float2Float(FPrice * FValue, cPrecision, True);
            m := m - Float2Float(FPrice * nVal, cPrecision, True);
            //����������
            nDBZhiKa:=LoadZhiKaInfo(nBills[0].FZhiKa,nHint);
            with nDBZhiKa do
            begin
              if FieldByName('C_ContQuota').AsString='1' then
              begin
                nSQL := 'Update %s Set A_ConFreezeMoney=A_ConFreezeMoney+(%.2f) ' +
                        'Where A_CID=''%s''';
                nSQL := Format(nSQL, [sTable_CusAccount, m, FCusID]);
              end else
              begin
                nSQL := 'Update %s Set A_FreezeMoney=A_FreezeMoney+(%.2f) ' +
                        'Where A_CID=''%s''';
                nSQL := Format(nSQL, [sTable_CusAccount, m, FCusID]);
              end;
              FListA.Add(nSQL); //�����˻�
              WriteLog('['+FID+']Update YKMoney: '+nSQL);
            end;
          end;
          
          nSQL := MakeSQLByStr([SF('L_Value', FValue, sfVal)
                  ], sTable_Bill, SF('L_ID', FID), False);
          FListA.Add(nSQL); //���������

          nUpdateVal := FValue-nVal;
          nSQL := 'Update %s Set D_Value=D_Value-(%.2f) ' +
                  'Where D_RECID=''%s''';
          nSQL := Format(nSQL, [sTable_ZhiKaDtl, nUpdateVal, FRecID]);
          FListA.Add(nSQL); //����ֽ������
        end;
      end else
      begin
        nSQL := 'Update %s Set D_Value=D_Value+(%.2f) ' +
                'Where D_RECID=''%s''';
        nSQL := Format(nSQL, [sTable_ZhiKaDtl, FValue, FRecID]);
        FListA.Add(nSQL); //����ֽ������

        m := Float2Float(FPrice * FValue, cPrecision, True);
        WriteLog('�ճ�������'+FYSValid);
        nDBZhiKa:=LoadZhiKaInfo(FZhiKa,nHint);

        with nDBZhiKa do
        begin
          if FieldByName('Z_TriangleTrade').AsString <> '1' then
          begin
            if FieldByName('C_ContQuota').AsString='1' then
            begin
              nSQL := 'Update %s Set A_ConFreezeMoney=A_ConFreezeMoney-(%.2f) Where A_CID=''%s''';
              nSQL := Format(nSQL, [sTable_CusAccount, m, FCusID]);
            end else
            begin
              nSQL := 'Update %s Set A_FreezeMoney=A_FreezeMoney-(%.2f) Where A_CID=''%s''';
              nSQL := Format(nSQL, [sTable_CusAccount, m, FCusID]);
            end;
            FListA.Add(nSQL); //���¿ͻ��ʽ�(���ܲ�ͬ�ͻ�)
            WriteLog('['+FID+']Relese YKMoney: '+nSQL);
          end;
        end;
      end;
    end;
    
    nVal := 0;
    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      if nIdx < High(nBills) then
      begin
        FMData.FValue := FPData.FValue + FValue;
        nVal := nVal + FValue;
        //�ۼƾ���

        nSQL := MakeSQLByStr([
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', sField_SQLServer_Now, sfVal),
                SF('P_MMan', FIn.FBase.FFrom.FUser),
                SF('P_MStation', nBills[nInt].FMData.FStation)
                ], sTable_PoundLog, SF('P_Bill', FID), False);
        if fneidao=sflag_yes then
        begin
          nSQL := 'P_Bill=''%s'' and p_mvalue is null';
          nSQL := Format(nSQL,[Fid]);
          nSQL := MakeSQLByStr([
                  SF('P_MValue', FMData.FValue, sfVal),
                  SF('P_MDate', sField_SQLServer_Now, sfVal),
                  SF('P_MMan', FIn.FBase.FFrom.FUser),
                  SF('P_MStation', nBills[nInt].FMData.FStation)
                  ], sTable_PoundLog, nSql, False);
        end;
        FListA.Add(nSQL);
      end else
      begin
        FMData.FValue := nMVal - nVal;
        //�ۼ����ۼƵľ���

        nSQL := MakeSQLByStr([
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', sField_SQLServer_Now, sfVal),
                SF('P_MMan', FIn.FBase.FFrom.FUser),
                SF('P_MStation', nBills[nInt].FMData.FStation)
                ], sTable_PoundLog, SF('P_Bill', FID), False);
        if fneidao=sflag_yes then
        begin
          nSQL := 'P_Bill=''%s'' and p_mvalue is null';
          nSQL := Format(nSQL,[Fid]);
          nSQL := MakeSQLByStr([
                  SF('P_MValue', FMData.FValue, sfVal),
                  SF('P_MDate', sField_SQLServer_Now, sfVal),
                  SF('P_MMan', FIn.FBase.FFrom.FUser),
                  SF('P_MStation', nBills[nInt].FMData.FStation)
                  ], sTable_PoundLog, nSql, False);
        end;                
        FListA.Add(nSQL);
      end;
    end;

    FListB.Clear;
    if nBills[nInt].FPModel <> sFlag_PoundCC then //����ģʽ,ë�ز���Ч
    begin
      nSQL := 'Select L_ID From %s Where L_Card=''%s'' And L_MValue Is Null';
      nSQL := Format(nSQL, [sTable_Bill, nBills[nInt].FCard]);
      //δ��ë�ؼ�¼

      with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
      if RecordCount > 0 then
      begin
        First;

        while not Eof do
        begin
          FListB.Add(Fields[0].AsString);
          Next;
        end;
      end;
    end;

    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      if nBills[nInt].FPModel = sFlag_PoundCC then Continue;
      //����ģʽ,������״̬

      i := FListB.IndexOf(FID);
      if i >= 0 then
        FListB.Delete(i);
      //�ų����γ���
      if FYSValid <> sFlag_Yes then   //�ж��Ƿ�ճ�����
      begin
        if not isbrick(FStockNo) then
        begin
          nSQL := MakeSQLByStr([SF('L_Value', FValue, sfVal),
                  SF('L_Status', sFlag_TruckBFM),
                  SF('L_NextStatus', sFlag_TruckOut),
                  SF('L_MValue', FMData.FValue , sfVal),
                  SF('L_MDate', sField_SQLServer_Now, sfVal),
                  SF('L_MMan', FIn.FBase.FFrom.FUser)
                  ], sTable_Bill, SF('L_ID', FID), False);
        end
        //����ש�飬�����������        
        else begin
          nSQL := MakeSQLByStr([SF('L_Status', sFlag_TruckBFM),
                  SF('L_NextStatus', sFlag_TruckOut),
                  SF('L_MValue', FMData.FValue , sfVal),
                  SF('L_MDate', sField_SQLServer_Now, sfVal),
                  SF('L_MMan', FIn.FBase.FFrom.FUser)
                  ], sTable_Bill, SF('L_ID', FID), False);
        end;
        FListA.Add(nSQL);
      end else
      begin
        nSQL := MakeSQLByStr([SF('L_Value', 0.00, sfVal),
                SF('L_Status', sFlag_TruckBFM),
                SF('L_NextStatus', sFlag_TruckOut),
                SF('L_MValue', FMData.FValue , sfVal),
                SF('L_MDate', sField_SQLServer_Now, sfVal),
                SF('L_MMan', FIn.FBase.FFrom.FUser)
                ], sTable_Bill, SF('L_ID', FID), False);
        FListA.Add(nSQL);
      end;
    end;

    if FListB.Count > 0 then
    begin
      nTmp := AdjustListStrFormat2(FListB, '''', True, ',', False);
      //δ���ؽ������б�

      nStr := Format('L_ID In (%s)', [nTmp]);
      nSQL := MakeSQLByStr([
              SF('L_PValue', nMVal, sfVal),
              SF('L_PDate', sField_SQLServer_Now, sfVal),
              SF('L_PMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, nStr, False);
      FListA.Add(nSQL);
      //û�г�ë�ص������¼��Ƥ��,���ڱ��ε�ë��

      nStr := Format('P_Bill In (%s)', [nTmp]);
      nSQL := MakeSQLByStr([
              SF('P_PValue', nMVal, sfVal),
              SF('P_PDate', sField_SQLServer_Now, sfVal),
              SF('P_PMan', FIn.FBase.FFrom.FUser),
              SF('P_PStation', nBills[nInt].FMData.FStation)
              ], sTable_PoundLog, nStr, False);
      FListA.Add(nSQL);
      //û�г�ë�صĹ�����¼��Ƥ��,���ڱ��ε�ë��
    end;

    nSQL := 'Select P_ID From %s Where P_Bill=''%s'' And P_MValue Is Null';
    nSQL := Format(nSQL, [sTable_PoundLog, nBills[nInt].FID]);
    //δ��ë�ؼ�¼

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    if RecordCount > 0 then
    begin
      FOut.FData := Fields[0].AsString;
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckOut then
  begin
    FListB.Clear;
    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      FListB.Add(FID);
      //�������б�
      nS := sFlag_TruckOut;
      nNs := '';
      nCard := '';
      if FNeiDao=sflag_yes then
      begin
        nS := sFlag_TruckIn;
        nNs := sFlag_TruckBFP;
        nCard := FCard;
      end;

      nSQL := MakeSQLByStr([SF('L_Status', ns),
              SF('L_NextStatus', nNs),
              SF('L_Card', nCard),
              SF('L_OutFact', sField_SQLServer_Now, sfVal),
              SF('L_OutMan', FIn.FBase.FFrom.FUser)
              ], sTable_Bill, SF('L_ID', FID), False);
      FListA.Add(nSQL); //���½�����

      nVal := Float2Float(FPrice * FValue, cPrecision, True);
      //������
      if (FYSValid = sFlag_Yes) and (FTriaTrade <> '1') then   //�ж��Ƿ�ճ�����
      begin
        nDBZhiKa:=LoadZhiKaInfo(nBills[nIdx].FZhiKa,nHint);
        with nDBZhiKa do
        begin
          if FieldByName('C_ContQuota').AsString='1' then
          begin
            nSQL := 'Update %s Set A_ConFreezeMoney=A_ConFreezeMoney-(%.2f) Where A_CID=''%s''';
            nSQL := Format(nSQL, [sTable_CusAccount, nVal, FCusID]);
          end else
          begin
            nSQL := 'Update %s Set A_FreezeMoney=A_FreezeMoney-(%.2f) Where A_CID=''%s''';
            nSQL := Format(nSQL, [sTable_CusAccount, nVal, FCusID]);
          end;
          FListA.Add(nSQL); //���¿ͻ��ʽ�(���ܲ�ͬ�ͻ�)
          WriteLog('['+FID+']Relese YKMoney: '+nSQL);
        end;
      end;
    end;
    if nBills[0].FNeiDao<>sflag_yes then
    begin
      nSQL := 'Update %s Set C_Status=''%s'' Where C_Card=''%s''';
      nSQL := Format(nSQL, [sTable_Card, sFlag_CardIdle, nBills[0].FCard]);
      FListA.Add(nSQL); //���´ſ�״̬
    end;

    nStr := AdjustListStrFormat2(FListB, '''', True, ',', False);
    //�������б�

    nSQL := 'Select T_Line,Z_Name as T_Name,T_Bill,T_PeerWeight,T_Total,' +
            'T_Normal,T_BuCha,T_HKBills From %s ' +
            ' Left Join %s On Z_ID = T_Line ' +
            'Where T_Bill In (%s)';
    nSQL := Format(nSQL, [sTable_ZTTrucks, sTable_ZTLines, nStr]);

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    begin
      SetLength(FBillLines, RecordCount);
      //init

      if RecordCount > 0 then
      begin
        nIdx := 0;
        First;

        while not Eof do
        begin
          with FBillLines[nIdx] do
          begin
            FBill    := FieldByName('T_Bill').AsString;
            FLine    := FieldByName('T_Line').AsString;
            FName    := FieldByName('T_Name').AsString;
            FPerW    := FieldByName('T_PeerWeight').AsInteger;
            FTotal   := FieldByName('T_Total').AsInteger;
            FNormal  := FieldByName('T_Normal').AsInteger;
            FBuCha   := FieldByName('T_BuCha').AsInteger;
            FHKBills := FieldByName('T_HKBills').AsString;
          end;

          Inc(nIdx);
          Next;
        end;
      end;
    end;

    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      nInt := -1;
      for i:=Low(FBillLines) to High(FBillLines) do
       if (Pos(FID, FBillLines[i].FHKBills) > 0) and
          (FID <> FBillLines[i].FBill) then
       begin
          nInt := i;
          Break;
       end;
      //�Ͽ�,��������

      if nInt < 0 then Continue;
      //����װ����Ϣ

      with FBillLines[nInt] do
      begin
        if FPerW < 1 then Continue;
        //������Ч

        i := Trunc(FValue * 1000 / FPerW);
        //����

        nSQL := MakeSQLByStr([SF('L_LadeLine', FLine),
                SF('L_LineName', FName),
                SF('L_DaiTotal', i, sfVal),
                SF('L_DaiNormal', i, sfVal),
                SF('L_DaiBuCha', 0, sfVal)
                ], sTable_Bill, SF('L_ID', FID), False);
        FListA.Add(nSQL); //����װ����Ϣ

        FTotal := FTotal - i;
        FNormal := FNormal - i;
        //�ۼ��Ͽ�������װ����
      end;
    end;

    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      nInt := -1;
      for i:=Low(FBillLines) to High(FBillLines) do
       if FID = FBillLines[i].FBill then
       begin
          nInt := i;
          Break;
       end;
      //�Ͽ�����

      if nInt < 0 then Continue;
      //����װ����Ϣ

      with FBillLines[nInt] do
      begin
        nSQL := MakeSQLByStr([SF('L_LadeLine', FLine),
                SF('L_LineName', FName),
                SF('L_DaiTotal', FTotal, sfVal),
                SF('L_DaiNormal', FNormal, sfVal),
                SF('L_DaiBuCha', FBuCha, sfVal)
                ], sTable_Bill, SF('L_ID', FID), False);
        FListA.Add(nSQL); //����װ����Ϣ
      end;
    end;
    if nBills[0].FNeiDao<>sflag_yes then
    begin
      nSQL := 'Delete From %s Where T_Bill In (%s)';
      nSQL := Format(nSQL, [sTable_ZTTrucks, nStr]);
      //WriteLog('Clear Trucks: '+nSQL);
      FListA.Add(nSQL); //����װ������
    end;
  end;
  //----------------------------------------------------------------------------
  
  //----------�����¼���֪ͨ---------------
  if (FIn.FExtParam = sFlag_TruckZT) or (FIn.FExtParam = sFlag_TruckFH) then
  begin
    for nIdx:=Low(nBills) to High(nBills)do
    begin
      with nBills[nIdx] do
      begin
        if FSampleID<>'' then
        begin
          try
            SaveHyDan(FID + sFlag_ManualD,FSampleID,FStockno+Ftype,FStockname,FIn.FExtParam,'Y=ͨ��;N=��ֹ;I=����', '������');
          except
            on E:Exception do
            begin
              WriteLog('TWorkerBusinessBills.SavePostBillItems.SaveHyDan error:'+e.message);
            end;
          end;
        end;
      end;
    end;
  end;
  //----------�����¼���֪ͨ---------------

  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;

  if FIn.FExtParam = sFlag_TruckBFM then //����ë��
  begin
    {$IFDEF QHSN}
    for nIdx:=Low(nBills) to High(nBills) do
    with nBills[nIdx] do
    begin
      if FNeiDao='Y' then
      begin
        if Assigned(gHardShareData) then
          gHardShareData('TruckOut:' + nBills[0].FCard);
        //���������Զ�����
      end;
    end;
      {$IFDEF GGJC}
        if Assigned(gHardShareData) then
            gHardShareData('TruckOut:' + nBills[0].FCard);
        Exit;
      {$ENDIF}
    {$ELSE}
       {$IFNDEF ZXKP}
       if Assigned(gHardShareData) then
          gHardShareData('TruckOut:' + nBills[0].FCard);
        //���������Զ�����
       {$ENDIF}
    {$ENDIF}
  end;

end;
//------------------------------------------------------------------------------
class function TWorkerBusinessOrders.FunctionName: string;
begin
  Result := sBus_BusinessPurchaseOrder;
end;

constructor TWorkerBusinessOrders.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FListC := TStringList.Create;
  inherited;
end;

destructor TWorkerBusinessOrders.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  FreeAndNil(FListC);
  inherited;
end;

function TWorkerBusinessOrders.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
  end;
end;

procedure TWorkerBusinessOrders.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FDataOutNeedUnPack := False;
end;

//Date: 2015-8-5
//Parm: ��������
//Desc: ִ��nDataҵ��ָ��
function TWorkerBusinessOrders.DoDBWork(var nData: string): Boolean;
begin
  with FOut.FBase do
  begin
    FResult := True;
    FErrCode := 'S.00';
    FErrDesc := 'ҵ��ִ�гɹ�.';
  end;

  case FIn.FCommand of
   cBC_SaveOrder            : Result := SaveOrder(nData);
   cBC_DeleteOrder          : Result := DeleteOrder(nData);
   cBC_SaveOrderBase        : Result := SaveOrderBase(nData);
   cBC_DeleteOrderBase      : Result := DeleteOrderBase(nData);
   cBC_SaveOrderCard        : Result := SaveOrderCard(nData);
   cBC_LogoffOrderCard      : Result := LogoffOrderCard(nData);
   cBC_ModifyBillTruck      : Result := ChangeOrderTruck(nData);
   cBC_GetPostOrders        : Result := GetPostOrderItems(nData);
   cBC_SavePostOrders       : Result := SavePostOrderItems(nData);
   cBC_GetGYOrderValue      : Result := GetGYOrderValue(nData);
   else
    begin
      Result := False;
      nData := '��Ч��ҵ�����(Invalid Command).';
    end;
  end;
end;


function TWorkerBusinessOrders.SaveOrderBase(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nOut: TWorkerBusinessCommand;
begin
  FListA.Text := PackerDecodeStr(FIn.FData);
  //unpack Order

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    FOut.FData := '';
    //bill list

    FListC.Values['Group'] :=sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_OrderBase;
    //to get serial no

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
          FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx

    FOut.FData := FOut.FData + nOut.FData + ',';
    //combine Order

    nStr := MakeSQLByStr([SF('B_ID', nOut.FData),
            SF('B_BStatus', FListA.Values['IsValid']),

            SF('B_Project', FListA.Values['Project']),
            SF('B_Area', FListA.Values['Area']),

            SF('B_Value', StrToFloat(FListA.Values['Value']),sfVal),
            SF('B_RestValue', StrToFloat(FListA.Values['Value']),sfVal),
            SF('B_LimValue', StrToFloat(FListA.Values['LimValue']),sfVal),
            SF('B_WarnValue', StrToFloat(FListA.Values['WarnValue']),sfVal),

            SF('B_SentValue', 0,sfVal),
            SF('B_FreezeValue', 0,sfVal),

            SF('B_ProID', FListA.Values['ProviderID']),
            SF('B_ProName', FListA.Values['ProviderName']),
            SF('B_ProPY', GetPinYinOfStr(FListA.Values['ProviderName'])),

            SF('B_SaleID', FListA.Values['SaleID']),
            SF('B_SaleMan', FListA.Values['SaleMan']),
            SF('B_SalePY', GetPinYinOfStr(FListA.Values['SaleMan'])),

            SF('B_StockType', sFlag_San),
            SF('B_StockNo', FListA.Values['StockNO']),
            SF('B_StockName', FListA.Values['StockName']),

            SF('B_Man', FIn.FBase.FFrom.FUser),
            SF('B_Date', sField_SQLServer_Now, sfVal),
            SF('B_RecID', FListA.Values['RecID'])
            ], sTable_OrderBase, '', True);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := MakeSQLByStr([SF('M_ID', nOut.FData),
            SF('M_BStatus', FListA.Values['IsValid']),

            SF('M_ProID', FListA.Values['ProviderID']),
            SF('M_ProName', FListA.Values['ProviderName']),
            SF('M_ProPY', GetPinYinOfStr(FListA.Values['ProviderName'])),

            SF('M_Man', FIn.FBase.FFrom.FUser),
            SF('M_Date', sField_SQLServer_Now, sfVal)
            ], sTable_OrderBaseMain, '', True);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nIdx := Length(FOut.FData);
    if Copy(FOut.FData, nIdx, 1) = ',' then
      System.Delete(FOut.FData, nIdx, 1);
    //xxxxx
    
    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;
//------------------------------------------------------------------------------
//Date: 2015/9/19
//Parm: 
//Desc: ɾ���ɹ����뵥
function TWorkerBusinessOrders.DeleteOrderBase(var nData: string): Boolean;
var nStr,nP: string;
    nIdx: Integer;
begin
  Result := False;
  //init

  nStr := 'Select Count(*) From %s Where O_BID=''%s''';
  nStr := Format(nStr, [sTable_Order, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if Fields[0].AsInteger > 0 then
    begin
      nData := '�ɹ����뵥[ %s ]��ʹ��.';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
  end;

  FDBConn.FConn.BeginTrans;
  try
    //--------------------------------------------------------------------------
    nStr := Format('Select * From %s Where 1<>1', [sTable_OrderBase]);
    //only for fields
    nP := '';

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      for nIdx:=0 to FieldCount - 1 do
       if (Fields[nIdx].DataType <> ftAutoInc) and
          (Pos('B_Del', Fields[nIdx].FieldName) < 1) then
        nP := nP + Fields[nIdx].FieldName + ',';
      //�����ֶ�,������ɾ��

      System.Delete(nP, Length(nP), 1);
    end;

    nStr := 'Insert Into $OB($FL,B_DelMan,B_DelDate) ' +
            'Select $FL,''$User'',$Now From $OO Where B_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$OB', sTable_OrderBaseBak),
            MI('$FL', nP), MI('$User', FIn.FBase.FFrom.FUser),
            MI('$Now', sField_SQLServer_Now),
            MI('$OO', sTable_OrderBase), MI('$ID', FIn.FData)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Delete From %s Where B_ID=''%s''';
    nStr := Format(nStr, [sTable_OrderBase, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2015/9/20
//Parm: 
//Desc: ��ȡ��Ӧ���ջ���
function TWorkerBusinessOrders.GetGYOrderValue(var nData: string): Boolean;
var nSQL: string;
    nVal, nSent, nLim, nWarn, nFreeze,nMax: Double;
begin
  Result := False;
  //init

  nSQL := 'Select B_Value,B_SentValue,B_RestValue, ' +
          'B_LimValue,B_WarnValue,B_FreezeValue ' +
          'From $OrderBase b1 inner join $Order o1 on b1.B_ID=o1.O_BID ' +
          'Where O_ID=''$ID''';
  nSQL := MacroValue(nSQL, [MI('$OrderBase', sTable_OrderBase),
          MI('$Order', sTable_Order), MI('$ID', FIn.FData)]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount<1 then
    begin
      nData := '�ɹ����뵥[%s]��Ϣ�Ѷ�ʧ';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;

    nVal    := FieldByName('B_Value').AsFloat;
    nSent   := FieldByName('B_SentValue').AsFloat;
    nLim    := FieldByName('B_LimValue').AsFloat;
    nWarn   := FieldByName('B_WarnValue').AsFloat;
    nFreeze := FieldByName('B_FreezeValue').AsFloat;

    nMax := nVal - nSent - nFreeze;
  end;  

  with FListB do
  begin
    Clear;

    if nVal>0 then
         Values['NOLimite'] := sFlag_No
    else Values['NOLimite'] := sFlag_Yes;

    Values['MaxValue']    := FloatToStr(nMax);
    Values['LimValue']    := FloatToStr(nLim);
    Values['WarnValue']   := FloatToStr(nWarn);
    Values['FreezeValue'] := FloatToStr(nFreeze);
  end;

  FOut.FData := PackerEncodeStr(FListB.Text);
  Result := True;
end;

//Date: 2015-8-5
//Desc: ����ɹ���
function TWorkerBusinessOrders.SaveOrder(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nVal,nOppositeValue: Double;
    nOut,nOutTemp: TWorkerBusinessCommand;
begin
  FListA.Text := PackerDecodeStr(FIn.FData);
  nVal := StrToFloat(FListA.Values['Value']);
  nOppositeValue := StrToFloat(FListA.Values['OppositeValue']);
  //unpack Order

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    FOut.FData := '';
    //bill list

    FListC.Values['Group'] :=sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_Order;
    //to get serial no

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
          FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx

    FOut.FData := FOut.FData + nOut.FData + ',';
    //combine Order

    nStr := MakeSQLByStr([SF('O_ID', nOut.FData),

            SF('O_CType', FListA.Values['CardType']),
            SF('O_Project', FListA.Values['Project']),
            SF('O_Area', FListA.Values['Area']),

            SF('O_BID', FListA.Values['SQID']),
            SF('O_Value', nVal,sfVal),
            SF('O_OppositeValue', nOppositeValue,sfVal),

            SF('O_ProID', FListA.Values['ProviderID']),
            SF('O_ProName', FListA.Values['ProviderName']),
            SF('O_ProPY', GetPinYinOfStr(FListA.Values['ProviderName'])),

            SF('O_SaleID', FListA.Values['SaleID']),
            SF('O_SaleMan', FListA.Values['SaleMan']),
            SF('O_SalePY', GetPinYinOfStr(FListA.Values['SaleMan'])),

            SF('O_Type', sFlag_San),
            SF('O_StockNo', FListA.Values['StockNO']),
            SF('O_StockName', FListA.Values['StockName']),
            SF('O_YSTDNo', FListA.Values['YSTDNO']),
            SF('O_Truck', FListA.Values['Truck']),
            SF('O_Man', FIn.FBase.FFrom.FUser),
            SF('O_Date', sField_SQLServer_Now, sfVal),
            SF('O_BRecID', FListA.Values['RecID']),
            SF('O_IfNeiDao', FListA.Values['NeiDao'])
            ], sTable_Order, '', True);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    if FListA.Values['CardType'] = sFlag_OrderCardL then
    begin
      nStr := 'Update %s Set B_FreezeValue=B_FreezeValue+%.2f ' +
              'Where B_ID = ''%s'' and B_Value>0';
      nStr := Format(nStr, [sTable_OrderBase, nVal,FListA.Values['SQID']]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;

    nIdx := Length(FOut.FData);
    if Copy(FOut.FData, nIdx, 1) = ',' then
      System.Delete(FOut.FData, nIdx, 1);
    //xxxxx
    
    FDBConn.FConn.CommitTrans;

    TWorkerBusinessCommander.CallMe(cBC_SaveTruckInfo, FListA.Values['Truck'], '', @nOutTemp);
    //���泵�ƺ�

    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
  if gSysParam.FGPWSURL <> '' then
  begin
    //�޸��̳Ƕ���״̬
    ModifyWebOrderStatus(nOut.FData,c_WeChatStatusCreateCard);
    //����΢����Ϣ
    SendMsgToWebMall(nOut.FData,cSendWeChatMsgType_AddBill,sFlag_Provide);
  end;
end;

//Date: 2015-8-5
//Desc: ����ɹ���
function TWorkerBusinessOrders.DeleteOrder(var nData: string): Boolean;
var nStr,nP: string;
    nIdx: Integer;
begin
  Result := False;
  //init

  nStr := 'Select Count(*) From %s Where ((D_Status<>''%s'') and (D_Status<>''%s'')) and D_OID=''%s''';
  nStr := Format(nStr, [sTable_OrderDtl, sFlag_TruckNone, sFlag_TruckIn, FIn.FData]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if Fields[0].AsInteger > 0 then
    begin
      nData := '�ɹ���[ %s ]��ʹ�ã���ֹɾ����';
      nData := Format(nData, [FIn.FData]);
      Exit;
    end;
  end;

  FDBConn.FConn.BeginTrans;
  try
    //--------------------------------------------------------------------------
    nStr := Format('Select * From %s Where 1<>1', [sTable_Order]);
    //only for fields
    nP := '';

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      for nIdx:=0 to FieldCount - 1 do
       if (Fields[nIdx].DataType <> ftAutoInc) and
          (Pos('O_Del', Fields[nIdx].FieldName) < 1) then
        nP := nP + Fields[nIdx].FieldName + ',';
      //�����ֶ�,������ɾ��

      System.Delete(nP, Length(nP), 1);
    end;

    nStr := 'Insert Into $OB($FL,O_DelMan,O_DelDate) ' +
            'Select $FL,''$User'',$Now From $OO Where O_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$OB', sTable_OrderBak),
            MI('$FL', nP), MI('$User', FIn.FBase.FFrom.FUser),
            MI('$Now', sField_SQLServer_Now),
            MI('$OO', sTable_Order), MI('$ID', FIn.FData)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Delete From %s Where O_ID=''%s''';
    nStr := Format(nStr, [sTable_Order, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-17
//Parm: �ɹ�����[FIn.FData];�ſ���[FIn.FExtParam]
//Desc: Ϊ�ɹ����󶨴ſ�
function TWorkerBusinessOrders.SaveOrderCard(var nData: string): Boolean;
var nStr,nSQL,nTruck: string;
begin
  Result := False;
  nTruck := '';

  FListB.Text := FIn.FExtParam;
  //�ſ��б�
  nStr := AdjustListStrFormat(FIn.FData, '''', True, ',', False);
  //�ɹ����б�

  nSQL := 'Select O_ID,O_Card,O_Truck From %s Where O_ID In (%s)';
  nSQL := Format(nSQL, [sTable_Order, nStr]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  begin
    if RecordCount < 1 then
    begin
      nData := Format('�ɹ�����[ %s ]�Ѷ�ʧ.', [FIn.FData]);
      Exit;
    end;

    First;
    while not Eof do
    begin
      nStr := FieldByName('O_Truck').AsString;
      if (nTruck <> '') and (nStr <> nTruck) then
      begin
        nData := '�ɹ���[ %s ]�ĳ��ƺŲ�һ��,���ܲ���.' + #13#10#13#10 +
                 '*.��������: %s' + #13#10 +
                 '*.��������: %s' + #13#10#13#10 +
                 '��ͬ�ƺŲ��ܲ���,���޸ĳ��ƺ�,���ߵ����쿨.';
        nData := Format(nData, [FieldByName('O_ID').AsString, nStr, nTruck]);
        Exit;
      end;

      if nTruck = '' then
        nTruck := nStr;
      //xxxxx

      nStr := FieldByName('O_Card').AsString;
      //����ʹ�õĴſ�
        
      if (nStr <> '') and (FListB.IndexOf(nStr) < 0) then
        FListB.Add(nStr);
      Next;
    end;
  end;

  //----------------------------------------------------------------------------
  nSQL := 'Select O_ID,O_Truck From %s Where O_Card In (''%s'')';
  nSQL := Format(nSQL, [sTable_Order, FIn.FExtParam]);

  with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
  if RecordCount > 0 then
  begin
    nData := '����[ %s ]����ʹ�øÿ�,�޷�����.';
    nData := Format(nData, [FieldByName('O_Truck').AsString]);
    Exit;
  end;

  FDBConn.FConn.BeginTrans;
  try
    if FIn.FData <> '' then
    begin
      nStr := AdjustListStrFormat(FIn.FData, '''', True, ',', False);
      //���¼����б�

      nSQL := 'Update %s Set O_Card=''%s'' Where O_ID In (%s)';
      nSQL := Format(nSQL, [sTable_Order, FIn.FExtParam, nStr]);
      gDBConnManager.WorkerExec(FDBConn, nSQL);

      nSQL := 'Update %s Set D_Card=''%s'' Where D_OID In(%s) and D_OutFact Is NULL';
      nSQL := Format(nSQL, [sTable_OrderDtl, FIn.FExtParam, nStr]);
      gDBConnManager.WorkerExec(FDBConn, nSQL);
    end;

    nStr := 'Select Count(*) From %s Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, FIn.FExtParam]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if Fields[0].AsInteger < 1 then
    begin
      nStr := MakeSQLByStr([SF('C_Card', FIn.FExtParam),
              SF('C_Status', sFlag_CardUsed),
              SF('C_Used', sFlag_Provide),
              SF('C_Freeze', sFlag_No),
              SF('C_Man', FIn.FBase.FFrom.FUser),
              SF('C_Date', sField_SQLServer_Now, sfVal)
              ], sTable_Card, '', True);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end else
    begin
      nStr := Format('C_Card=''%s''', [FIn.FExtParam]);
      nStr := MakeSQLByStr([SF('C_Status', sFlag_CardUsed),
              SF('C_Used', sFlag_Provide),
              SF('C_Freeze', sFlag_No),
              SF('C_Man', FIn.FBase.FFrom.FUser),
              SF('C_Date', sField_SQLServer_Now, sfVal)
              ], sTable_Card, nStr, False);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2015-8-5
//Desc: ����ɹ���
function TWorkerBusinessOrders.LogoffOrderCard(var nData: string): Boolean;
var nStr: string;
  nNeiDao:string;
begin
  nNeiDao := FIn.FExtParam;
  FDBConn.FConn.BeginTrans;
  try
    nStr := 'Update %s Set O_Card=Null Where O_Card=''%s''';
    nStr := Format(nStr, [sTable_Order, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    if nNeiDao=sflag_yes then
    begin
      nStr := 'Update %s Set d_status=''%s'',d_nextstatus='''' Where D_Card=''%s'' and d_status=''%s'' and d_nextstatus=''%s''';
      nStr := Format(nStr, [sTable_OrderDtl, sFlag_TruckOut, FIn.FData, sFlag_TruckIn, sFlag_TruckBFP]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;
    nStr := 'Update %s Set D_Card=Null Where D_Card=''%s''';
    nStr := Format(nStr, [sTable_OrderDtl, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Update %s Set C_Status=''%s'', C_Used=Null Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, sFlag_CardInvalid, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

function TWorkerBusinessOrders.ChangeOrderTruck(var nData: string): Boolean;
var nStr: string;
begin
  //Result := False;
  //Init

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    nStr := 'Update %s Set O_Truck=''%s'' Where O_ID=''%s''';
    nStr := Format(nStr, [sTable_Order, FIn.FExtParam, FIn.FData]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    //�����޸���Ϣ

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;
end;

//Date: 2014-09-17
//Parm: �ſ���[FIn.FData];��λ[FIn.FExtParam]
//Desc: ��ȡ�ض���λ����Ҫ�Ľ������б�
function TWorkerBusinessOrders.GetPostOrderItems(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nIsOrder: Boolean;
    nBills: TLadingBillItems;
    nCardType:string;
begin
  Result := False;
  nIsOrder := False;

  nStr := 'Select B_Prefix, B_IDLen From %s ' +
          'Where B_Group=''%s'' And B_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialBase, sFlag_BusGroup, sFlag_Order]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nIsOrder := (Pos(Fields[0].AsString, FIn.FData) = 1) and
               (Length(FIn.FData) = Fields[1].AsInteger);
    //ǰ׺�ͳ��ȶ�����ɹ����������,����Ϊ�ɹ�����
  end;

  if not nIsOrder then
  begin
    nStr := 'Select C_Status,C_Freeze,C_Used From %s Where C_Card=''%s''';
    nStr := Format(nStr, [sTable_Card, FIn.FData]);
    //card status

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      if RecordCount < 1 then
      begin
        nData := Format('�ſ�[ %s ]��Ϣ�Ѷ�ʧ.', [FIn.FData]);
        Exit;
      end;

      if Fields[0].AsString <> sFlag_CardUsed then
      begin
        nData := '�ſ�[ %s ]��ǰ״̬Ϊ[ %s ],�޷����.';
        nData := Format(nData, [FIn.FData, CardStatusToStr(Fields[0].AsString)]);
        Exit;
      end;

      if Fields[1].AsString = sFlag_Yes then
      begin
        nData := '�ſ�[ %s ]�ѱ�����,�޷����.';
        nData := Format(nData, [FIn.FData]);
        Exit;
      end;
      
      nCardType := FieldByName('C_Used').AsString;
    end;
  end;
	
	if nCardType = sFlag_Provide then
	begin
	  nStr := 'Select O_ID,O_Card,O_ProID,O_ProName,O_Type,O_StockNo,' +
	          'O_StockName,O_Truck,O_Value,O_BRecID,O_IfNeiDao,o_ystdno ' +
	          'From $OO oo ';
	  //xxxxx
	
	  if nIsOrder then
	       nStr := nStr + 'Where O_ID=''$CD'''
	  else nStr := nStr + 'Where O_Card=''$CD''';
	
	  nStr := MacroValue(nStr, [MI('$OO', sTable_Order),MI('$CD', FIn.FData)]);
	  //xxxxx
	
	  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
	  begin
	    if RecordCount < 1 then
	    begin
	      if nIsOrder then
	           nData := '�ɹ���[ %s ]����Ч.'
	      else nData := '�ſ���[ %s ]�޶���';
	
	      nData := Format(nData, [FIn.FData]);
	      Exit;
	    end else
	    with FListA do
	    begin
	      Clear;
	
	      Values['O_ID']         := FieldByName('O_ID').AsString;
	      Values['O_ProID']      := FieldByName('O_ProID').AsString;
	      Values['O_ProName']    := FieldByName('O_ProName').AsString;
	      Values['O_Truck']      := FieldByName('O_Truck').AsString;
	
	      Values['O_Type']       := FieldByName('O_Type').AsString;
	      Values['O_StockNo']    := FieldByName('O_StockNo').AsString;
	      Values['O_StockName']  := FieldByName('O_StockName').AsString;
	
	      Values['O_Card']       := FieldByName('O_Card').AsString;
	      Values['O_Value']      := FloatToStr(FieldByName('O_Value').AsFloat);
	      Values['O_BRecID']     := FieldByName('O_BRecID').AsString;
	
	      Values['NeiDao']         := FieldByName('O_IfNeiDao').AsString;
        Values['YSTDNO']         := FieldByName('o_ystdno').asstring;
	    end;
	  end;
	
	  nStr := 'Select D_ID,D_OID,D_PID,D_YLine,D_Status,D_NextStatus,' +
	          'D_KZValue,D_Memo,D_YSResult,' +
	          'P_PStation,P_PValue,P_PDate,P_PMan,' +
	          'P_MStation,P_MValue,P_MDate,P_MMan ' +
	          'From $OD od Left join $PD pd on pd.P_Order=od.D_ID ' +
	          'Where D_OutFact Is Null And D_OID=''$OID''';
	  //xxxxx
	
	  nStr := MacroValue(nStr, [MI('$OD', sTable_OrderDtl),
	                            MI('$PD', sTable_PoundLog),
	                            MI('$OID', FListA.Values['O_ID'])]);
	  //xxxxx
	
	  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
	  begin
	    if RecordCount<1 then
	    begin
	      SetLength(nBills, 1);
	
	      with nBills[0], FListA do
	      begin
	        FZhiKa      := Values['O_ID'];
	        FCusID      := Values['O_ProID'];
	        FCusName    := Values['O_ProName'];
	        FTruck      := Values['O_Truck'];
	
	        FType       := Values['O_Type'];
	        FStockNo    := Values['O_StockNo'];
	        FStockName  := Values['O_StockName'];
	        FValue      := StrToFloat(Values['O_Value']);
	
	        FCard       := Values['O_Card'];
	        FStatus     := sFlag_TruckNone;
	        FNextStatus := sFlag_TruckNone;
	
	        FRecID      := Values['O_BRecID'];
	        FNeiDao     := Values['NeiDao'];
          Fystdno     := Values['YSTDNO'];
	        FSelected := True;
	      end;  
	    end else
	    begin
	      SetLength(nBills, RecordCount);
	
	      nIdx := 0;
	
	      First; 
	      while not Eof do
	      with nBills[nIdx], FListA do
	      begin
	        FID         := FieldByName('D_ID').AsString;
	        FZhiKa      := FieldByName('D_OID').AsString;
	        FPoundID    := FieldByName('D_PID').AsString;
	
	        FCusID      := Values['O_ProID'];
	        FCusName    := Values['O_ProName'];
	        FTruck      := Values['O_Truck'];
	
	        FType       := Values['O_Type'];
	        FStockNo    := Values['O_StockNo'];
	        FStockName  := Values['O_StockName'];
	        FValue      := StrToFloat(Values['O_Value']);
	
	        FCard       := Values['O_Card'];
	        FStatus     := FieldByName('D_Status').AsString;
	        FNextStatus := FieldByName('D_NextStatus').AsString;
	
	        if (FStatus = '') or (FStatus = sFlag_BillNew) then
	        begin
	          FStatus     := sFlag_TruckNone;
	          FNextStatus := sFlag_TruckNone;
	        end;
	
	        with FPData do
	        begin
	          FStation  := FieldByName('P_PStation').AsString;
	          FValue    := FieldByName('P_PValue').AsFloat;
	          FDate     := FieldByName('P_PDate').AsDateTime;
	          FOperator := FieldByName('P_PMan').AsString;
	        end;
	
	        with FMData do
	        begin
	          FStation  := FieldByName('P_MStation').AsString;
	          FValue    := FieldByName('P_MValue').AsFloat;
	          FDate     := FieldByName('P_MDate').AsDateTime;
	          FOperator := FieldByName('P_MMan').AsString;
	        end;
	
	        FKZValue  := FieldByName('D_KZValue').AsFloat;
	        FMemo     := FieldByName('D_Memo').AsString;
	        FYSValid  := FieldByName('D_YSResult').AsString;
	
	        FRecID      := Values['O_BRecID'];
	        FNeiDao     := Values['NeiDao'];
          Fystdno     := Values['YSTDNO'];
	        FSelected := True;
	
	        Inc(nIdx);
	        Next;
	      end;
	    end;    
	  end;	
	end
	else if nCardType = sFlag_Other then
	begin
		Result := LoadOtherByCard(nbills,FIn.FData, nData);
    Exit;
	end;

  FOut.FData := CombineBillItmes(nBills);
  Result := True;
end;

//��ȡ����ģʽ
function TWorkerBusinessOrders.GetOnLineModel: string;
var
  nStr: string;
begin
  Result:=sFlag_Yes;
  nStr := 'select D_Value from %s where D_Name=''%s'' ';
  nStr := Format(nStr, [sTable_SysDict, sFlag_OnLineModel]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    Result:=Fields[0].AsString;
  end;
end;

//Date: 2016-10-30
//Parm: �ſ�;��λ;����
//Desc: ����ʹ��nCard����ʱҵ���ڸ���λ������
function TWorkerBusinessOrders.SavePostOther(const nCard, nPost: string;
  var nData: string; npound:TLadingBillItem; const nExtData: TStrings): Boolean;
const  sField_SQLServer_Now           = 'getDate()';  
var nStr,nNS,nCD: string;
  nysline:Pysline;
  nIsPreTruck:Boolean;
  nPrePValue:Double;
  nPrePMan:string;
  nPrePTime:TDateTime;
  npoundid:string;
  ns:string;
begin
  Result := True;
  npoundid := '';
  nIsPreTruck := getPrepinfo(npound.Ftruck,nPrePValue,nPrePMan,nPrePTime);

  nysline := getysline(npound.FYSTDNO);
  if nPost = sFlag_TruckIn then
  begin
    nStr := MakeSQLByStr([
            SF('O_Status', sFlag_TruckIn),
            SF('O_NextStatus', sFlag_TruckBFP),
            SF('O_InTime', sField_SQLServer_Now, sfVal),
            SF('O_InMan', FIn.FBase.FFrom.FUser)
            ], sTable_CardOther, SF('O_Card', nCard), False);

    gDBConnManager.WorkerExec(FDBConn, nStr);
  end else

  if nPost = sFlag_TruckOut then
  begin
    if nPound.Fcardkeep then
    begin
      ns := sFlag_TruckIn;
      nNS := sFlag_TruckBFP;
      nCD := nCard;
    end else
    begin
      ns := sFlag_TruckOut;
      nNS := '';
      nCD := '';
    end;

    nStr := MakeSQLByStr([
            SF('O_Status', ns),
            SF('O_NextStatus', nNS),
            SF('O_Card', nCD),
            SF('O_OutTime', sField_SQLServer_Now, sfVal),
            SF('O_OutMan', FIn.FBase.FFrom.FUser)
            ], sTable_CardOther, SF('O_Card', nCard), False);

    gDBConnManager.WorkerExec(FDBConn, nStr);
  end
  else if (nPost = sFlag_TruckBFP) then
  begin
    //��������
    if not Assigned(nysline) or (nysline.FYS_Valid<>sflag_yes) then
    begin
      //Ԥ��Ƥ��
      if nIsPreTruck then
      begin
        nStr := MakeSQLByStr([
                SF('O_BFMValue', npound.FPData.FValue, sfVal),
                SF('O_BFMTime', sField_SQLServer_Now, sfVal),
                SF('O_BFMMan', FIn.FBase.FFrom.FUser),
                SF('O_BFPValue', nPrePValue, sfVal),
                SF('O_BFPTime', DateTime2Str(nPrePTime)),
                SF('O_BFPMan', nPrePMan),
                SF('O_Status', sFlag_TruckBFM),
                SF('O_NextStatus', sFlag_TruckOut)
                ], sTable_CardOther, SF('O_Card', nCard), False);

        gDBConnManager.WorkerExec(FDBConn, nStr);

        if Assigned(gHardShareData) then
        begin
          gHardShareData('TruckOut:' + nCard);
          WriteLog('��ʱ����Ԥ��Ƥ���Զ�����');
        end;
      end
      //��Ԥ��Ƥ��
      else begin
        nStr := MakeSQLByStr([
                SF('O_BFPValue', npound.FPData.FValue, sfVal),
                SF('O_BFPTime', sField_SQLServer_Now, sfVal),
                SF('O_BFPMan', FIn.FBase.FFrom.FUser),
                SF('O_Status', sFlag_TruckBFP),
                SF('O_NextStatus', sFlag_TruckBFM)
                ], sTable_CardOther, SF('O_Card', nCard), False);

        gDBConnManager.WorkerExec(FDBConn, nStr);
      end;
    end
    //��Ҫ����
    else begin
      nStr := MakeSQLByStr([
              SF('O_BFPValue', npound.FPData.FValue, sfVal),
              SF('O_BFPTime', sField_SQLServer_Now, sfVal),
              SF('O_BFPMan', FIn.FBase.FFrom.FUser),
              SF('O_Status', sFlag_TruckBFP),
              SF('O_NextStatus', sFlag_TruckXH)
              ], sTable_CardOther, SF('O_Card', nCard), False);

      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;
//    gDBConnManager.WorkerExec(FDBConn, nStr);

    //Ԥ��Ƥ����Ҫ���°���
    if nIsPreTruck then
    begin
      nStr := 'select p_id from %s where p_truck=''%s'' and p_pvalue>0.0001 and p_mvalue is null';
      nStr := Format(nStr,[sTable_PoundLog,npound.Ftruck]);
      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      begin
        if RecordCount>0 then
        begin
          nPoundid := FieldByName('p_id').AsString;
        end;
      end;

      if npoundid<>'' then
      begin
        nStr := MakeSQLByStr([
                SF('P_MValue', npound.FPData.FValue, sfVal),
                SF('P_MDate', sField_SQLServer_Now, sfVal),
                SF('P_MMan', FIn.FBase.FFrom.FUser),

                SF('P_PValue', nPrePValue, sfVal),
                SF('P_PDate', DateTime2Str(nPrePTime)),
                SF('P_PMan', nPrePMan)
                ], sTable_PoundLog, SF('P_id', npoundid), False);
        gDBConnManager.WorkerExec(FDBConn, nStr);
      end;
    end;
  end
  else if (nPost = sFlag_TruckBFM) then
  begin
    //��һ�οճ����ڶ����س�
    if npound.FPData.FDate>0 then
    begin
      nStr := MakeSQLByStr([
              SF('O_BFPValue', npound.FPData.FValue, sfVal),
              SF('O_BFPTime', DateTime2Str(npound.FPData.FDate)),
              SF('O_BFPMan', npound.FPData.FOperator),
              SF('O_BFMValue', npound.FMData.FValue, sfVal),
              SF('O_BFMTime', sField_SQLServer_Now, sfVal),
              SF('O_BFMMan', FIn.FBase.FFrom.FUser),
              SF('O_Status', sFlag_TruckBFM),
              SF('O_NextStatus', sFlag_TruckOut)
              ], sTable_CardOther, SF('O_Card', nCard), False);
    end
    //��һ���س����ڶ��οճ�
    else if npound.FMData.FDate>0 then
    begin
      nStr := MakeSQLByStr([
              SF('O_BFPValue', npound.FPData.FValue, sfVal),
              SF('O_BFPTime', sField_SQLServer_Now, sfVal),
              SF('O_BFPMan', FIn.FBase.FFrom.FUser),
              SF('O_BFMValue', npound.FMData.FValue, sfVal),
              SF('O_BFMTime', DateTime2Str(npound.FMData.FDate)),
              SF('O_BFMMan', npound.FMData.FOperator),
              SF('O_Status', sFlag_TruckBFM),
              SF('O_NextStatus', sFlag_TruckOut)
              ], sTable_CardOther, SF('O_Card', nCard), False);
    end;

    gDBConnManager.WorkerExec(FDBConn, nStr);
  end
  else if (nPost = sFlag_TruckXH) then
  begin
    nStr := MakeSQLByStr([
            SF('O_BFMValue', npound.FPData.FValue, sfVal),
            SF('O_BFMTime', DateTime2Str(npound.FPData.FDate)),
            SF('O_BFMMan', npound.FPData.FOperator),
            SF('O_BFPValue', nPrePValue, sfVal),
            SF('O_BFPTime', DateTime2Str(nPrePTime)),
            SF('O_BFPMan', nPrePMan),
            SF('O_Status', sFlag_TruckXH),
            SF('O_NextStatus', sFlag_TruckOut)
            ], sTable_CardOther, SF('O_Card', nCard), False);

    gDBConnManager.WorkerExec(FDBConn, nStr);

    if Assigned(gHardShareData) then
    begin
      gHardShareData('TruckOut:' + nCard);
      WriteLog('��ʱ�����ֳ����պ��Զ�����');
    end;
  end;
end;

//Date: 2014-09-18
//Parm: ������[FIn.FData];��λ[FIn.FExtParam]
//Desc: ����ָ����λ�ύ�Ľ������б�
function TWorkerBusinessOrders.SavePostOrderItems(var nData: string): Boolean;
var nVal, nNet, nAKVal: Double;
    nIdx: Integer;
    nStr,nSQL: string;
    nPound: TLadingBillItems;
    nOut: TWorkerBusinessCommand;
    nCardType:string;
    nysline:Pysline;
  nIsPreTruck:Boolean;
  nPrePValue:Double;
  nPrePMan:string;
  nPrePTime:TDateTime;
  nTempData: TPoundStationData;
begin
  Result := False;
  
  AnalyseBillItems(FIn.FData, nPound);
  //��������

  nIsPreTruck := getPrepinfo(nPound[0].Ftruck,nPrePValue,nPrePMan,nPrePTime);
  
  FListA.Clear;
  //���ڴ洢SQL�б�

  nCardType := '';
  if not GetCardUsed(nPound[0].Fcard, nCardType) then Exit;

  if nCardType=sFlag_Other then
  begin
    Result := SavePostOther(nPound[0].Fcard, FIn.FExtParam,
                nData, npound[0],FPacker.StrBuilder);
                
    if (FIn.FExtParam = sFlag_TruckBFP) or (FIn.FExtParam = sFlag_TruckBFM) then
    begin
      FListC.Clear;
      FListC.Values['Group'] := sFlag_BusGroup;
      FListC.Values['Object'] := sFlag_PoundID;

      if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
              FListC.Text, sFlag_Yes, @nOut) then
        raise Exception.Create(nOut.FData);
      //xxxxx

      FOut.FData := nOut.FData;
      //���ذ񵥺�,�������հ�

      if (FIn.FExtParam = sFlag_TruckBFM) then
      begin
        if Assigned(gHardShareData) then
        begin
          gHardShareData('TruckOut:' + nPound[0].FCard);
          //���������Զ�����
          WriteLog('���������Զ�����');
        end;
      end;
    end;
    
    Exit;
  end;
//  nCardType := nPound[0]
  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckIn then //����
  begin
    FListC.Clear;
    FListC.Values['Group'] := sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_OrderDtl;

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
        FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx

    with nPound[0] do
    begin
      nSQL := MakeSQLByStr([
            SF('D_ID', nOut.FData),
            SF('D_Card', FCard),
            SF('D_OID', FZhiKa),
            SF('D_Truck', FTruck),
            SF('D_ProID', FCusID),
            SF('D_ProName', FCusName),
            SF('D_ProPY', GetPinYinOfStr(FCusName)),

            SF('D_Type', FType),
            SF('D_StockNo', FStockNo),
            SF('D_StockName', FStockName),

            SF('D_Status', sFlag_TruckIn),
            SF('D_NextStatus', sFlag_TruckBFP),
            SF('D_InMan', FIn.FBase.FFrom.FUser),
            SF('D_InTime', sField_SQLServer_Now, sfVal),
            SF('D_RecID', FRecID)
            ], sTable_OrderDtl, '', True);
      FListA.Add(nSQL);
    end;  
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckBFP then //����Ƥ��
  begin
    FListB.Clear;
    nStr := 'Select D_Value From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_NFStock]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      First;
      while not Eof do
      begin
        FListB.Add(Fields[0].AsString);
        Next;
      end;
    end;

    FListC.Clear;
    FListC.Values['Group'] := sFlag_BusGroup;
    FListC.Values['Object'] := sFlag_PoundID;

    if not TWorkerBusinessCommander.CallMe(cBC_GetSerialNO,
            FListC.Text, sFlag_Yes, @nOut) then
      raise Exception.Create(nOut.FData);
    //xxxxx

    FOut.FData := nOut.FData;
    //���ذ񵥺�,�������հ�
    with nPound[0] do
    begin
      FStatus := sFlag_TruckBFP;
      FNextStatus := sFlag_TruckXH;
      nysline := getysline(FYSTDNO);
      if Assigned(nysline) then
      begin
        if nysline.FYS_Valid<>sflag_yes then
        begin
          FNextStatus := sFlag_TruckBFM;
        end;
        Dispose(nysline);
      end;
      {if FListB.IndexOf(FStockNo) >= 0 then
        FNextStatus := sFlag_TruckBFM; }
      nStr := 'Select D_Value From %s Where ((D_Name=''%s'') or (D_Name=''%s'')) and D_Value=''%s'' ';
      nStr := Format(nStr, [sTable_SysDict, sFlag_NFStock, sFlag_NFPurch, FStockNo]);

      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      if RecordCount > 0 then
      begin
        FNextStatus := sFlag_TruckBFM;
      end;
      //�ֳ�������ֱ�ӹ���
      {$IFDEF GLPURCH}
      if (pos('����',FStockName)>0) then FNextStatus := sFlag_TruckBFM;
      {$ENDIF}

      nSQL := MakeSQLByStr([
            SF('P_ID', nOut.FData),
            SF('P_Type', sFlag_Provide),
            SF('P_Order', FID),
            SF('P_Truck', FTruck),
            SF('P_CusID', FCusID),
            SF('P_CusName', FCusName),
            SF('P_MID', FStockNo),
            SF('P_MName', FStockName),
            SF('P_MType', FType),
            SF('P_LimValue', 0),
            SF('P_PValue', FPData.FValue, sfVal),
            SF('P_PDate', sField_SQLServer_Now, sfVal),
            SF('P_PMan', FIn.FBase.FFrom.FUser),
            SF('P_FactID', FFactory),
            SF('P_PStation', FPData.FStation),
            SF('P_Direction', '����'),
            SF('P_PModel', FPModel),
            SF('P_Status', sFlag_TruckBFP),
            SF('P_Valid', sFlag_Yes),
            SF('P_PrintNum', 1, sfVal)
            ], sTable_PoundLog, '', True);
      FListA.Add(nSQL);

      nSQL := MakeSQLByStr([
              SF('D_Status', FStatus),
              SF('D_NextStatus', FNextStatus),
              SF('D_PValue', FPData.FValue, sfVal),
              SF('D_PDate', sField_SQLServer_Now, sfVal),
              SF('D_PMan', FIn.FBase.FFrom.FUser)
              ], sTable_OrderDtl, SF('D_ID', FID), False);
      FListA.Add(nSQL);
    end;  

  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckXH then //�����ֳ�
  begin
    with nPound[0] do
    begin
      FStatus := sFlag_TruckXH;
      FNextStatus := sFlag_TruckBFM;

      nStr := SF('P_Order', FID);
      //where
      nSQL := MakeSQLByStr([
                SF('P_KZValue', FKZValue, sfVal)
                ], sTable_PoundLog, nStr, False);
        //���տ���
       FListA.Add(nSQL);

      nSQL := MakeSQLByStr([
              SF('D_Status', FStatus),
              SF('D_NextStatus', FNextStatus),
              SF('D_YTime', sField_SQLServer_Now, sfVal),
              SF('D_YMan', FIn.FBase.FFrom.FUser),
              SF('D_KZValue', FKZValue, sfVal),
              SF('D_YSResult', FYSValid),
              SF('D_Memo', FMemo)
              ], sTable_OrderDtl, SF('D_ID', FID), False);
      FListA.Add(nSQL);
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckBFM then //����ë��
  begin
    with nPound[0] do
    begin
      nStr := 'Select D_CusID,D_Value,D_Type From %s ' +
              'Where D_Stock=''%s'' And D_Valid=''%s''';
      nStr := Format(nStr, [sTable_Deduct, FStockNo, sFlag_Yes]);
      //WriteLog(nStr);
      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      if RecordCount > 0 then
      begin
        First;

        while not Eof do
        begin
          if FieldByName('D_CusID').AsString = FCusID then
            Break;
          //�ͻ�+���ϲ�������

          Next;
        end;

        if Eof then First;
        //ʹ�õ�һ������

        if FMData.FValue > FPData.FValue then
             nNet := FMData.FValue - FPData.FValue
        else nNet := FPData.FValue - FMData.FValue;

        nVal := 0;
        //���ۼ���
        nStr := FieldByName('D_Type').AsString;

        if nStr = sFlag_DeductFix then
          nVal := FieldByName('D_Value').AsFloat;
        //��ֵ�ۼ�

        if nStr = sFlag_DeductPer then
        begin
          nVal := FieldByName('D_Value').AsFloat;
          nVal := nNet * nVal;
          //WriteLog('�ۼ����㣺'+FloatToStr(nVal));
        end; //�����ۼ�

        if (nVal > 0) and (nNet > nVal) then
        begin
          nVal := Float2Float(nVal, cPrecision, False);
          //���������ۼ�Ϊ2λС��;
          nAKVal := nVal;
          if FMData.FValue > FPData.FValue then
               FMData.FValue := (FMData.FValue*1000 - nVal*1000) / 1000
          else FPData.FValue := (FPData.FValue*1000 - nVal*1000) / 1000;
        end;
      end;

      nStr := SF('P_Order', FID);
      //where

      nVal := FMData.FValue - FPData.FValue -FKZValue;

      if FMData.FValue < FPData.FValue then
      begin
        nTempData := FPData;
        FPData := FMData;
        FMData := nTempData;
      end;

      if FNextStatus = sFlag_TruckBFP then
      begin
        nSQL := MakeSQLByStr([
                SF('P_PValue', FPData.FValue, sfVal),
                SF('P_PDate', sField_SQLServer_Now, sfVal),
                SF('P_PMan', FIn.FBase.FFrom.FUser),
                SF('P_PStation', FPData.FStation),
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', DateTime2Str(FMData.FDate)),
                SF('P_MMan', FMData.FOperator),
                SF('P_MStation', FMData.FStation)
                ], sTable_PoundLog, nStr, False);
        //����ʱ,����Ƥ�ش�,����Ƥë������
        FListA.Add(nSQL);

        nSQL := MakeSQLByStr([
                SF('D_Status', sFlag_TruckBFM),
                SF('D_NextStatus', sFlag_TruckOut),
                SF('D_PValue', FPData.FValue, sfVal),
                SF('D_PDate', sField_SQLServer_Now, sfVal),
                SF('D_PMan', FIn.FBase.FFrom.FUser),
                SF('D_MValue', FMData.FValue, sfVal),
                SF('D_MDate', DateTime2Str(FMData.FDate)),
                SF('D_MMan', FMData.FOperator),
                SF('D_AKValue', nAKVal, sfVal),
                SF('D_Value', nVal, sfVal)
                ], sTable_OrderDtl, SF('D_ID', FID), False);
        FListA.Add(nSQL);

      end else
      begin
        nSQL := MakeSQLByStr([
                SF('P_MValue', FMData.FValue, sfVal),
                SF('P_MDate', sField_SQLServer_Now, sfVal),
                SF('P_MMan', FIn.FBase.FFrom.FUser),
                SF('P_MStation', FMData.FStation)
                ], sTable_PoundLog, nStr, False);
        //xxxxx
        FListA.Add(nSQL);

        nSQL := MakeSQLByStr([
                SF('D_Status', sFlag_TruckBFM),
                SF('D_NextStatus', sFlag_TruckOut),
                SF('D_MValue', FMData.FValue, sfVal),
                SF('D_MDate', sField_SQLServer_Now, sfVal),
                SF('D_MMan', FMData.FOperator),
                SF('D_Value', nVal, sfVal)
                ], sTable_OrderDtl, SF('D_ID', FID), False);
        FListA.Add(nSQL);
      end;

      nSQL := 'Update $OrderBase Set B_SentValue=B_SentValue+$Val, ' +
              'B_RestValue=B_Value-B_SentValue-$Val '+
              'Where B_RecID = ''$RID'' ';
      nSQL := MacroValue(nSQL, [MI('$OrderBase', sTable_OrderBase),
              MI('$RID', FRecID), MI('$Val', FloatToStr(nVal))]);
      FListA.Add(nSQL);
      //�������ջ���
      
      nSQL := 'Select P_ID From %s Where P_Order=''%s'' ';
      nSQL := Format(nSQL, [sTable_PoundLog, FID]);
      //δ��ë�ؼ�¼
      with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
      if RecordCount > 0 then
      begin
        FOut.FData := Fields[0].AsString;
      end;
    end;
  end else

  //----------------------------------------------------------------------------
  if FIn.FExtParam = sFlag_TruckOut then
  begin
    with nPound[0] do
    begin
      nSQL := MakeSQLByStr([SF('D_Status', sFlag_TruckOut),
              SF('D_NextStatus', ''),
              SF('D_Card', ''),
              SF('D_OutFact', sField_SQLServer_Now, sfVal),
              SF('D_OutMan', FIn.FBase.FFrom.FUser)
              ], sTable_OrderDtl, SF('D_ID', FID), False);
      FListA.Add(nSQL); //���²ɹ���
    end;

    nSQL := 'Select O_CType,O_Card From %s Where O_ID=''%s''';
    nSQL := Format(nSQL, [sTable_Order, nPound[0].FZhiKa]);

    with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
    if RecordCount > 0 then
    begin
      nStr := FieldByName('O_Card').AsString;
      if FieldByName('O_CType').AsString = sFlag_OrderCardL then
      if not CallMe(cBC_LogOffOrderCard, nStr, '', @nOut) then
      begin
        nData := nOut.FData;
        Exit;
      end;
    end;
    //�������ʱ��Ƭ����ע����Ƭ
  end;

  //----------------------------------------------------------------------------
  FDBConn.FConn.BeginTrans;
  try
    for nIdx:=0 to FListA.Count - 1 do
      gDBConnManager.WorkerExec(FDBConn, FListA[nIdx]);
    //xxxxx

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    FDBConn.FConn.RollbackTrans;
    raise;
  end;

  if FIn.FExtParam = sFlag_TruckBFM then //����ë��
  begin
    if Assigned(gHardShareData) then
    begin
      {$IFDEF GGJC}
      gHardShareData('TruckOut:' + nPound[0].FCard);
      //���������Զ�����
      WriteLog('���������Զ�����');
      {$ELSE}
      nSQL := 'Select D_Value From %s Where D_Name=''AutoOutStock'' and D_Value=''%s''';
      nSQL := Format(nSQL, [sTable_SysDict, nPound[0].FStockNo]);

      with gDBConnManager.WorkerQuery(FDBConn, nSQL) do
      if RecordCount > 0 then
      begin
        gHardShareData('TruckOut:' + nPound[0].FCard);
        //���������Զ�����
        WriteLog('���������Զ�����');
      end;
      {$ENDIF}
    end;
  end;
end;

//Date: 2014-09-15
//Parm: ����;����;����;���
//Desc: ���ص���ҵ�����
class function TWorkerBusinessOrders.CallMe(const nCmd: Integer;
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
    nPacker.InitData(@nIn, True, False);
    //init

    nStr := nPacker.PackIn(@nIn);
    nWorker := gBusinessWorkerManager.LockWorker(FunctionName);
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

function TWorkerBusinessBills.IsBrick(const nStockno: string): Boolean;
var
  nStr:string;
begin
  Result := False;
  nStr := 'select * from %s where d_name=''%s'' and d_desc=''%s''';
  nStr := Format(nStr,[sTable_SysDict,sFlag_BrickItem,nStockno]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    Result := RecordCount>0;
  end;
end;

procedure TWorkerBusinessBills.SaveHyDan(const nEID,nHydan,nStockno,nStockname,nFrom,nSolution,nDepartment: string);
var
  nFile:string;
  nIni: TIniFile;
  nLastHyDan:string;
  nStr:string;
  nEvent:string;
begin
  nIni := nil;
  try
    try
      nIni := TIniFile.Create(gPath + sConfigFile);
      nLastHyDan := nini.ReadString('HyDan', nStockno, '');
      nini.WriteString('HyDan', nStockno, nHydan);
      if nLastHyDan='' then Exit;

      if (nLastHyDan<>nHydan) then
      begin
        nStr := 'Select * From %s Where E_ID=''%s''';
        nStr := Format(nStr, [sTable_ManualEvent, nEID]);

        with gDBConnManager.WorkerQuery(FDBConn, nStr) do
        begin
          if RecordCount > 0 then
          begin
            nStr := '�¼���¼:[ %s ]�Ѵ���';
            nStr := Format(nStr, [nEID]);
            WriteLog(nStr);
            Exit;
          end;
        end;
        nEvent := 'Ʒ��[ %s ]�Ļ����¼���� [%s] ���Ϊ [%s],�뾡�찲��ȡ��';
        nEvent := Format(nEvent,[nStockname,nLastHyDan,nHydan]);
        nStr := MakeSQLByStr([
            SF('E_ID', nEID),
            SF('E_Key', ''),
            SF('E_From', TruckStatusToStr(nFrom)),
            SF('E_Event', nEvent),
            SF('E_Solution', nSolution),
            SF('E_Departmen', nDepartment),
            SF('E_Date', sField_SQLServer_Now, sfVal)
            ], sTable_ManualEvent, '', True);
//        gDBConnManager.WorkerExec(FDBConn, nStr);
        FListA.Add(nStr);
      end;
    except
      on E: Exception do
      begin
        WriteLog('TWorkerBusinessBills.SaveHyDan(nEID='+nEID+',nHydan='+nHydan+',nStockno='+nStockno+',nStockname='+nStockname+',nFrom='+nFrom+',nSolution='+nSolution+',nDepartment='+nDepartment+') Error:'+e.message);
      end;
    end;
  finally
    nIni.Free;
  end;
end;

//Date: 2017-12-2
//Parm: ���ƺ�(Truck); ��������(Bill);��λ(Pos)
//Desc: ץ�ıȶ�
function TWorkerBusinessCommander.VerifySnapTruck(var nData: string): Boolean;
var nStr: string;
    nTruck, nBill, nPos, nSnapTruck, nEvent, nDept, nPicName: string;
    nUpdate, nNeedManu: Boolean;
begin
  Result := False;
  FListA.Text := FIn.FData;
  nSnapTruck:= '';
  nEvent:= '' ;
  nNeedManu := False;

  nTruck := FListA.Values['Truck'];
  nBill  := FListA.Values['Bill'];
  nPos   := FListA.Values['Pos'];
  nDept  := FListA.Values['Dept'];

  nStr := 'Select D_Value From %s Where D_Name=''%s'' and D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_TruckInNeedManu,nPos]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
    begin
      nNeedManu := FieldByName('D_Value').AsString = sFlag_Yes;
    end;
  end;
  WriteLog('����ʶ��:'+'��λ:'+nPos+'�¼����ղ���:'+nDept);
  {$IFDEF SaveAllSnap}
  nStr := 'Select * From %s Where S_ID=''%s''';
  nStr := Format(nStr, [sTable_SnapTruck, nPos]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
      nSnapTruck := FieldByName('S_Truck').AsString;
  end;

  nStr := 'Select * From %s Where E_ID=''%s''';
  nStr := Format(nStr, [sTable_ManualEvent, nBill+sFlag_ManualE]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
      nUpdate := True
    else
      nUpdate := False;
  end;

  nEvent := '����[ %s ]����ʶ��ɹ�,ץ�ĳ��ƺ�:[ %s ]';
  nEvent := Format(nEvent, [nTruck,nSnapTruck]);

  nStr := SF('E_ID', nBill+sFlag_ManualE);
  nStr := MakeSQLByStr([
          SF('E_ID', nBill+sFlag_ManualE),
          SF('E_Key', nTruck),
          SF('E_From', nDept),
          SF('E_Result', 'I'),
          SF('E_ManDeal', 'Auto'),
          SF('E_DateDeal', sField_SQLServer_Now, sfVal),
          SF('E_Event', nEvent),
          SF('E_Solution', sFlag_Solution_YN),
          SF('E_Departmen', nDept),
          SF('E_Date', sField_SQLServer_Now, sfVal)
          ], sTable_ManualEvent, nStr, (not nUpdate));
  //xxxxx
  gDBConnManager.WorkerExec(FDBConn, nStr);
  {$ENDIF}

  nData := '����[ %s ]����ʶ��ʧ��';
  nData := Format(nData, [nTruck]);
  FOut.FData := nData;
  //default

  nStr := 'Select * From %s Where S_ID=''%s'' order by R_ID desc ';
  nStr := Format(nStr, [sTable_SnapTruck, nPos]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then
    begin
      if not nNeedManu then
        Result := True;
      nData := '����[ %s ]ץ���쳣';
      nData := Format(nData, [nTruck]);
      FOut.FData := nData;
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
        nData := '����[ %s ]����ʶ��ɹ�,ץ�ĳ��ƺ�:[ %s ]';
        nData := Format(nData, [nTruck,nSnapTruck]);
        FOut.FData := nData;
        Exit;
      end;
      //����ʶ��ɹ�
      Next;
    end;
  end;

  nStr := 'Select * From %s Where E_ID=''%s''';
  nStr := Format(nStr, [sTable_ManualEvent, nBill+sFlag_ManualE]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount > 0 then
    begin
      if FieldByName('E_Result').AsString = 'N' then
      begin
        nData := '����[ %s ]����ʶ��ʧ��,ץ�ĳ��ƺ�:[ %s ],����Ա��ֹ����';
        nData := Format(nData, [nTruck,nSnapTruck]);
        FOut.FData := nData;
        Exit;
      end;
      if FieldByName('E_Result').AsString = 'Y' then
      begin
        Result := True;
        nData := '����[ %s ]����ʶ��ʧ��,ץ�ĳ��ƺ�:[ %s ],����Ա����';
        nData := Format(nData, [nTruck,nSnapTruck]);
        FOut.FData := nData;
        Exit;
      end;
      nUpdate := True;
    end
    else
    begin
      nData := '����[ %s ]����ʶ��ʧ��,ץ�ĳ��ƺ�:[ %s ]';
      nData := Format(nData, [nTruck,nSnapTruck]);
      FOut.FData := nData;
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

  nStr := SF('E_ID', nBill+sFlag_ManualE);
  nStr := MakeSQLByStr([
          SF('E_ID', nBill+sFlag_ManualE),
          SF('E_Key', nPicName),
          SF('E_From', nDept),
          SF('E_Result', 'Null', sfVal),

          SF('E_Event', nEvent),
          SF('E_Solution', sFlag_Solution_YN),
          SF('E_Departmen', nDept),
          SF('E_Date', sField_SQLServer_Now, sfVal)
          ], sTable_ManualEvent, nStr, (not nUpdate));
  //xxxxx
  gDBConnManager.WorkerExec(FDBConn, nStr);
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TBusWorkerQueryField, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TWorkerBusinessCommander, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TWorkerBusinessBills, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TWorkerBusinessOrders, sPlug_ModuleBus);
end.
