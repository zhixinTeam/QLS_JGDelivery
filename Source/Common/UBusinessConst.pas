{*******************************************************************************
  ����: dmzn@163.com 2012-02-03
  ����: ҵ��������

  ��ע:
  *.����In/Out����,��ô���TBWDataBase������,��λ�ڵ�һ��Ԫ��.
*******************************************************************************}
unit UBusinessConst;

interface

uses
  Classes, SysUtils, UBusinessPacker, ULibFun, USysDB;

const
  {*channel type*}
  cBus_Channel_Connection     = $0002;
  cBus_Channel_Business       = $0005;

  {*query field define*}
  cQF_Bill                    = $0001;

  {*business command*}
  cBC_GetSerialNO             = $0001;   //��ȡ���б��
  cBC_ServerNow               = $0002;   //��������ǰʱ��
  cBC_IsSystemExpired         = $0003;   //ϵͳ�Ƿ��ѹ���
  cBC_GetCardUsed             = $0004;   //��ȡ��Ƭ����
  cBC_UserLogin               = $0005;   //�û���¼
  cBC_UserLogOut              = $0006;   //�û�ע��

  cBC_CustomerMaCredLmt       = $0009;   //��ȡ�ͻ��Ƿ�ǿ��У������
  cBC_GetCustomerMoney        = $0010;   //��ȡ�ͻ����ý�
  cBC_GetZhiKaMoney           = $0011;   //��ȡֽ�����ý�
  cBC_CustomerHasMoney        = $0012;   //�ͻ��Ƿ������

  cBC_SaveTruckInfo           = $0013;   //���泵����Ϣ
  cBC_UpdateTruckInfo         = $0017;   //���泵����Ϣ
  cBC_GetTruckPoundData       = $0015;   //��ȡ������������
  cBC_SaveTruckPoundData      = $0016;   //���泵����������
  cBC_ReadZhiKaInfo           = $0018;   //��ȡ���۶�����Ϣ
  cBC_ReadStockPrice          = $0019;   //��ȡ�������ϼ۸�

  cBC_SaveBills               = $0020;   //���潻�����б�
  cBC_DeleteBill              = $0021;   //ɾ��������
  cBC_ModifyBillTruck         = $0022;   //�޸ĳ��ƺ�
  cBC_SaleAdjust              = $0023;   //���۵���
  cBC_SaveBillCard            = $0024;   //�󶨽������ſ�
  cBC_LogoffCard              = $0025;   //ע���ſ�
  cBC_GetSampleID             = $0026;   //��ȡ�������
  cBC_GetCenterID             = $0027;   //��ȡ������ID

  cBC_GetPostBills            = $0030;   //��ȡ��λ������
  cBC_SavePostBills           = $0031;   //�����λ������
  
  
  cBC_SaveOrder               = $0040;
  cBC_DeleteOrder             = $0041;
  cBC_SaveOrderCard           = $0042;
  cBC_LogOffOrderCard         = $0043;
  cBC_GetPostOrders           = $0044;   //��ȡ��λ�ɹ���
  cBC_SavePostOrders          = $0045;   //�����λ�ɹ���
  cBC_SaveOrderBase           = $0046;   //����ɹ����뵥
  cBC_DeleteOrderBase         = $0047;   //ɾ���ɹ����뵥
  cBC_GetGYOrderValue         = $0048;   //��ȡ���ջ���

  cBC_GetPostDDs              = $0049;   //��ȡ��λ�ɹ���
  cBC_SavePostDDs             = $0050;   //�����λ�ɹ���
  cBC_AXSyncDuanDao           = $0051;   //ͬ���̵�

  cBC_ChangeDispatchMode      = $0053;   //�л�����ģʽ
  cBC_GetPoundCard            = $0054;   //��ȡ��վ����
  cBC_GetQueueData            = $0055;   //��ȡ��������
  cBC_PrintCode               = $0056;
  cBC_PrintFixCode            = $0057;   //����
  cBC_PrinterEnable           = $0058;   //�������ͣ

  cBC_JSStart                 = $0060;
  cBC_JSStop                  = $0061;
  cBC_JSPause                 = $0062;
  cBC_JSGetStatus             = $0063;
  cBC_SaveCountData           = $0064;   //����������
  cBC_RemoteExecSQL           = $0065;

  cBC_RemoteSnapDisPlay       = $0066;   //ץ��С����ʾ
  cBC_GetPoundReaderInfo      = $0067;   //��ȡ��վ��������λ������

  cBC_IsTunnelOK              = $0075;   //��ѯ����״̬
  cBC_TunnelOC                = $0076;   //���̵ƿ���
  cBC_OPenPoundDoor           = $0077;   //��բ̧��
  cBC_VerifySnapTruck         = $0079;   //���Ʊȶ�
  
  cBC_SyncCustomer            = $0080;   //Զ��ͬ���ͻ�
  cBC_SyncSaleMan             = $0081;   //Զ��ͬ��ҵ��Ա
  cBC_SyncStockBill           = $0082;   //ͬ�����ݵ�Զ��
  cBC_CheckStockValid         = $0083;   //��֤�Ƿ�������
  cBC_SyncStockOrder          = $0084;   //ͬ���ɹ����ݵ�Զ��
  cBC_SyncProvider            = $0085;   //Զ��ͬ����Ӧ��
  cBC_SyncMaterails           = $0086;   //Զ��ͬ��ԭ����

  cBC_RegWeiXin               = $0087;   //΢��ע��
  cBC_BindUserWeiXin          = $0088;   //���û�

  cBC_SyncInvDim              = $0089;   //Զ��ͬ��ά����Ϣ
  cBC_SyncInvCenter           = $0090;   //Զ��ͬ����������Ϣ

  cBC_GetPurOrder             = $0104;   //��ȡ�ɹ�����
  cBC_GetPurOrdLine           = $0105;   //��ȡ�ɹ�������
  cBC_SyncFYBillAX            = $0106;   //ͬ���������AX
  cBC_GetTprGem               = $0109;   //���߻�ȡ���ö�ȣ��ͻ���
  cBC_GetTprGemCont           = $0110;   //���߻�ȡ���ö�ȣ��ͻ�-��ͬ��
  cBC_SyncDelSBillAX          = $0111;   //ͬ��ɾ�������
  cBC_SyncEmpOutBillAX        = $0112;   //ͬ���ճ����������
  cBC_GetTriangleTrade        = $0113;   //�ж��Ƿ�����ó��
  cBC_GetAXMaCredLmt          = $0114;   //�Ƿ�ǿ�����ö��
  cBC_GetAXContQuota          = $0115;   //�Ƿ�ר��ר��
  cBC_GetCustNo               = $0116;   //��ȡ���տͻ�
  cBC_GetAXCompanyArea        = $0117;   //���߻�ȡ��������
  cBC_GetAXInVentSum          = $0118;   //���߻�ȡ����������
  cBC_SyncAXwmsLocation       = $0119;   //ͬ����λ��Ϣ��DL
  cBC_SyncInvLocation         = $0120;   //Զ��ͬ���ֿ���Ϣ
  cBC_SyncTprGem              = $0121;   //Զ��ͬ�����ö�ȣ��ͻ���
  cBC_SyncTprGemCont          = $0122;   //Զ��ͬ�����ö�ȣ��ͻ�-��ͬ��
  cBC_SyncEmpTable            = $0123;   //Զ��ͬ��Ա����Ϣ
  cBC_SyncInvCenGroup         = $0124;   //Զ��ͬ��������������
  cBC_GetSalesOrder           = $0125;   //��ȡ���۶���
  cBC_GetSalesOrdLine         = $0126;   //��ȡ���۶�����
  cBC_GetSupAgreement         = $0127;   //��ȡ����Э��
  cBC_GetCreLimCust           = $0128;   //��ȡ���ö���������ͻ���
  cBC_GetCreLimCusCont        = $0129;   //��ȡ���ö���������ͻ�-��ͬ��
  cBC_GetSalesCont            = $0130;   //��ȡ���ۺ�ͬ
  cBC_GetSalesContLine        = $0131;   //��ȡ���ۺ�ͬ��
  cBC_GetVehicleNo            = $0132;   //��ȡ����
  cBC_GetSalesOrdValue        = $0133;   //��ȡ����������
  cBC_SyncVehNoAX             = $0134;   //ͬ�����ŵ�AX
  cBC_SyncAXCement            = $0135;   //Զ��ͬ��ˮ������

  cBC_VerifPrintCode          = $0091;   //��֤������Ϣ
  cBC_WaitingForloading       = $0092;   //������װ��ѯ
  cBC_BillSurplusTonnage      = $0093;   //���϶������µ�������ѯ
  cBC_GetOrderInfo            = $0094;   //��ȡ������Ϣ�����������̳��µ�

  cBC_GetOrderList            = $0103;   //��ȡ�����б����������̳��µ�
  cBC_GetPurchaseContractList = $0107;   //��ȡ�ɹ������б����������̳��µ�

  cBC_WeChat_getCustomerInfo  = $0095;   //΢��ƽ̨�ӿڣ���ȡ�ͻ�ע����Ϣ
  cBC_WeChat_get_Bindfunc     = $0096;   //΢��ƽ̨�ӿڣ��ͻ���΢���˺Ű�
  cBC_WeChat_send_event_msg   = $0097;   //΢��ƽ̨�ӿڣ�������Ϣ
  cBC_WeChat_edit_shopclients = $0098;   //΢��ƽ̨�ӿڣ������̳��û�
  cBC_WeChat_edit_shopgoods   = $0099;   //΢��ƽ̨�ӿڣ������Ʒ
  cBC_WeChat_get_shoporders   = $0100;   //΢��ƽ̨�ӿڣ���ȡ������Ϣ
  cBC_WeChat_complete_shoporders   = $0101;   //΢��ƽ̨�ӿڣ��޸Ķ���״̬
  cBC_WeChat_get_shoporderbyNO   = $0102;   //΢��ƽ̨�ӿڣ����ݶ����Ż�ȡ������Ϣ
  
  cBC_WeChat_get_shopPurchasebyNO   = $0108;   //΢��ƽ̨�ӿڣ����ݶ����Ż�ȡ������Ϣ
  cBC_WeChat_InOutFactoryTotal  = $0200;   //����������ѯ���ɹ������������۳�������

type
  PWorkerQueryFieldData = ^TWorkerQueryFieldData;
  TWorkerQueryFieldData = record
    FBase     : TBWDataBase;
    FType     : Integer;           //����
    FData     : string;            //����
  end;

  PWorkerBusinessCommand = ^TWorkerBusinessCommand;
  TWorkerBusinessCommand = record
    FBase     : TBWDataBase;
    FCommand  : Integer;           //����
    FData     : string;            //����
    FExtParam : string;            //����
    FRemoteUL : string;            //����������UL
  end;

  TPoundStationData = record
    FStation  : string;            //��վ��ʶ
    FValue    : Double;           //Ƥ��
    FDate     : TDateTime;        //��������
    FOperator : string;           //����Ա
  end;

  PLadingBillItem = ^TLadingBillItem;
  TLadingBillItem = record
    FID         : string;          //��������
    FZhiKa      : string;          //ֽ�����
    FProject    : string;          //��Ŀ���
    FCusID      : string;          //�ͻ����
    FCusName    : string;          //�ͻ�����
    FTruck      : string;          //���ƺ���

    FType       : string;          //Ʒ������
    FStockNo    : string;          //Ʒ�ֱ��
    FStockName  : string;          //Ʒ������
    FValue      : Double;          //�����
    FPrice      : Double;          //�������

    FCard       : string;          //�ſ���
    FIsVIP      : string;          //ͨ������
    FStatus     : string;          //��ǰ״̬
    FNextStatus : string;          //��һ״̬
    FLineGroup  : string;          //�������

    FPData      : TPoundStationData; //��Ƥ
    FMData      : TPoundStationData; //��ë
    FFactory    : string;          //�������
    FPModel     : string;          //����ģʽ
    FPType      : string;          //ҵ������
    FPoundID    : string;          //���ؼ�¼
    FHKRecord   : string;          //�ϵ���¼
    FSelected   : Boolean;         //ѡ��״̬
    FCardKeep   : Boolean;

    FYSValid    : string;          //���ս����Y���ճɹ���N���գ�
    FKZValue    : Double;          //��Ӧ�۳�
    FMemo       : string;          //������ע
    FSampleID   : string;          //�������
    FCenterID   : string;          //������ID
    FLocationID : string;          //�ֿ�ID
    FSalesType  : string;          //��������
    FRecID      : string;          //�����б���
    FKw         : string;          //��λ
    FWorkOrder  : string;          //���
    FNeiDao     : string;          //�ڵ�
    FTriaTrade  : string;          //����ó��
    Fszbz       : string;          //ɢװ����
    Fcolor      : string;          //��ɫ
    Fystdno     : string;          //����ͨ��
  end;

  TLadingBillItems = array of TLadingBillItem;
  //�������б�

  TQueueListItem = record
    FStockNO   : string;
    FStockName : string;

    FLineCount : Integer;
    FTruckCount: Integer;
  end;
  TQueueListItems = array of TQueueListItem;
  //��װ�����Ŷ��б�

  PWorkerWebChatData = ^TWorkerWebChatData;
  TWorkerWebChatData = record
    FBase     : TBWDataBase;
    FCommand  : Integer;           //����
    FData     : string;            //����
    FExtParam : string;            //����
    FRemoteUL : string;            //����������UL
  end;

  PBrickItem = ^TBrickItem;
  TBrickItem = record
    Fcode:string;                    //����
    FSquareOfPerTon:Double;          //ÿ��XXƽ
    FTonOfPerSquare:double;          //ÿƽXX��
  end;

procedure AnalyseBillItems(const nData: string; var nItems: TLadingBillItems);
//������ҵ����󷵻صĽ���������
function CombineBillItmes(const nItems: TLadingBillItems): string;
//�ϲ�����������Ϊҵ������ܴ�����ַ���

procedure AnalyseQueueListItems(const nData: string; var nItems: TQueueListItems);
//������ҵ����󷵻صĴ�װ�Ŷ�����

resourcestring
  {*PBWDataBase.FParam*}
  sParam_NoHintOnError        = 'NHE';                  //����ʾ����

  {*plug module id*}
  sPlug_ModuleBus             = '{DF261765-48DC-411D-B6F2-0B37B14E014E}';
                                                        //ҵ��ģ��
  sPlug_ModuleHD              = '{B584DCD6-40E5-413C-B9F3-6DD75AEF1C62}';
                                                        //Ӳ���ػ�
  sPlug_ModuleRemote          = '{B584DCD7-40E5-413C-B9F3-6DD75AEF1C63}';
                                                      //MIT�������                                                        
                                                                                                   
  {*common function*}  
  sSys_BasePacker             = 'Sys_BasePacker';       //���������

  {*business mit function name*}
  sBus_ServiceStatus          = 'Bus_ServiceStatus';    //����״̬
  sBus_GetQueryField          = 'Bus_GetQueryField';    //��ѯ���ֶ�
  sBus_BusinessWebchat        = 'Bus_BusinessWebchat';  //Webƽ̨����

  sBus_BusinessSaleBill       = 'Bus_BusinessSaleBill'; //���������
  sBus_BusinessCommand        = 'Bus_BusinessCommand';  //ҵ��ָ��
  sBus_HardwareCommand        = 'Bus_HardwareCommand';  //Ӳ��ָ��
  sBus_BusinessDuanDao        = 'Bus_BusinessDuanDao';  //�̵�ҵ�����
  sBus_BusinessPurchaseOrder  = 'Bus_BusinessPurchaseOrder'; //�ɹ������

  {*client function name*}
  sCLI_ServiceStatus          = 'CLI_ServiceStatus';    //����״̬
  sCLI_GetQueryField          = 'CLI_GetQueryField';    //��ѯ���ֶ�
  sCLI_BusinessSaleBill       = 'CLI_BusinessSaleBill'; //������ҵ��
  sCLI_BusinessCommand        = 'CLI_BusinessCommand';  //ҵ��ָ��
  sCLI_HardwareCommand        = 'CLI_HardwareCommand';  //Ӳ��ָ��
  sCLI_BusinessDuanDao        = 'CLI_BusinessDuanDao';  //�̵�ҵ�����
  sCLI_BusinessPurchaseOrder  = 'CLI_BusinessPurchaseOrder'; //�ɹ������
  sCLI_BusinessWebchat        = 'CLI_BusinessWebchat';  //Webƽ̨����

implementation

//Date: 2014-09-17
//Parm: ����������;�������
//Desc: ����nDataΪ�ṹ���б�����
procedure AnalyseBillItems(const nData: string; var nItems: TLadingBillItems);
var nStr: string;
    nIdx,nInt: Integer;
    nListA,nListB: TStrings;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nListA.Text := PackerDecodeStr(nData);
    //bill list
    nInt := 0;
    SetLength(nItems, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      //bill item

      with nListB,nItems[nInt] do
      begin
        FID         := Values['ID'];
        FZhiKa      := Values['ZhiKa'];
        FProject    := Values['Project'];
        FCusID      := Values['CusID'];
        FCusName    := Values['CusName'];
        FTruck      := Values['Truck'];

        FType       := Values['Type'];
        FStockNo    := Values['StockNo'];
        FStockName  := Values['StockName'];

        FCard       := Values['Card'];
        FIsVIP      := Values['IsVIP'];
        FStatus     := Values['Status'];
        FNextStatus := Values['NextStatus'];

        FFactory    := Values['Factory'];
        FPModel     := Values['PModel'];
        FPType      := Values['PType'];
        FPoundID    := Values['PoundID'];
        FSelected   := Values['Selected'] = sFlag_Yes;
        FCardKeep   := Values['CardKeep'] = sFlag_Yes;

        with FPData do
        begin
          FStation  := Values['PStation'];
          FDate     := Str2DateTime(Values['PDate']);
          FOperator := Values['PMan'];

          nStr := Trim(Values['PValue']);
          if (nStr <> '') and IsNumber(nStr, True) then
               FPData.FValue := StrToFloat(nStr)
          else FPData.FValue := 0;
        end;

        with FMData do
        begin
          FStation  := Values['MStation'];
          FDate     := Str2DateTime(Values['MDate']);
          FOperator := Values['MMan'];

          nStr := Trim(Values['MValue']);
          if (nStr <> '') and IsNumber(nStr, True) then
               FMData.FValue := StrToFloat(nStr)
          else FMData.FValue := 0;
        end;

        nStr := Trim(Values['Value']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FValue := StrToFloat(nStr)
        else FValue := 0;

        nStr := Trim(Values['Price']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FPrice := StrToFloat(nStr)
        else FPrice := 0;

        nStr := Trim(Values['KZValue']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FKZValue := StrToFloat(nStr)
        else FKZValue := 0;

        FYSValid:= Values['YSValid'];
        FMemo := Values['Memo'];
        FSampleID := Values['SampleID'];          //�������
        FCenterID := Values['CenterID'];          //������ID
        FLocationID:= Values['LocationID'];       //�ֿ�ID
        FSalesType:= Values['SalesType'];         //��������
        FRecID    := Values['RecID'];             //�����б���
        FKw       := Values['KuWei'];             //��λ
        FWorkOrder:= Values['WorkOrder'];         //���
        FNeiDao   := Values['NeiDao'];            //�ڵ�
        FTriaTrade:= Values['TriaTrade'];         //����ó��
        Fszbz     := Values['szbz'];              //ɢװ����
        Fcolor    := Values['color'];             //��ɫ
	      FYSTDno   := Values['YSTDNO'];            //����ͨ��
      end;

      Inc(nInt);
    end;
  finally
    nListB.Free;
    nListA.Free;
  end;   
end;

//Date: 2014-09-18
//Parm: �������б�
//Desc: ��nItems�ϲ�Ϊҵ������ܴ����
function CombineBillItmes(const nItems: TLadingBillItems): string;
var nIdx: Integer;
    nListA,nListB: TStrings;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    Result := '';
    nListA.Clear;
    nListB.Clear;

    for nIdx:=Low(nItems) to High(nItems) do
    with nItems[nIdx] do
    begin
      if not FSelected then Continue;
      //ignored

      with nListB do
      begin
        Values['ID']         := FID;
        Values['ZhiKa']      := FZhiKa;
        Values['Project']    := FProject;
        Values['CusID']      := FCusID;
        Values['CusName']    := FCusName;
        Values['Truck']      := FTruck;

        Values['Type']       := FType;
        Values['StockNo']    := FStockNo;
        Values['StockName']  := FStockName;
        Values['Value']      := FloatToStr(FValue);
        Values['Price']      := FloatToStr(FPrice);

        Values['Card']       := FCard;
        Values['IsVIP']      := FIsVIP;
        Values['Status']     := FStatus;
        Values['NextStatus'] := FNextStatus;

        Values['Factory']    := FFactory;
        Values['PModel']     := FPModel;
        Values['PType']      := FPType;
        Values['PoundID']    := FPoundID;
        if FCardKeep then Values['CardKeep']    := sFlag_Yes;
        with FPData do
        begin
          Values['PStation'] := FStation;
          Values['PValue']   := FloatToStr(FPData.FValue);
          Values['PDate']    := DateTime2Str(FDate);
          Values['PMan']     := FOperator;
        end;

        with FMData do
        begin
          Values['MStation'] := FStation;
          Values['MValue']   := FloatToStr(FMData.FValue);
          Values['MDate']    := DateTime2Str(FDate);
          Values['MMan']     := FOperator;
        end;

        if FSelected then
             Values['Selected'] := sFlag_Yes
        else Values['Selected'] := sFlag_No;

        Values['KZValue']    := FloatToStr(FKZValue);
        Values['YSValid']    := FYSValid;
        Values['Memo']       := FMemo;
        
        Values['SampleID']   := FSampleID;          //�������
        Values['CenterID']   := FCenterID;          //������ID
        Values['LocationID'] := FLocationID;        //�ֿ�ID
        Values['SalesType']  := FSalesType;         //��������
        Values['RecID']      := FRecID;             //�����б���
        Values['KuWei']      := FKw;                //��λ
        Values['WorkOrder']  := FWorkOrder;         //���
        Values['NeiDao']     := FNeiDao;            //�ڵ�
        Values['TriaTrade']  := FTriaTrade;         //����ó��
        Values['szbz']       := Fszbz;              //ɢװ����
        Values['color']      := Fcolor;             //��ɫ
	      Values['YSTDNO']     := FYSTDNO;            //����ͨ��
      end;

      nListA.Add(PackerEncodeStr(nListB.Text));
      //add bill
    end;

    Result := PackerEncodeStr(nListA.Text);
    //pack all
  finally
    nListB.Free;
    nListA.Free;
  end;
end;

//Date: 2016-09-20
//Parm: ��װ��������;�������
//Desc: ����nDataΪ�ṹ���б�����
procedure AnalyseQueueListItems(const nData: string; var nItems: TQueueListItems);
var nIdx,nInt: Integer;
    nListA,nListB: TStrings;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nListA.Text := PackerDecodeStr(nData);
    //bill list
    nInt := 0;
    SetLength(nItems, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      //bill item

      with nListB,nItems[nInt] do
      begin
        FStockName := Values['StockName'];
        FLineCount := StrToIntDef(Values['LineCount'],0);
        FTruckCount := StrToIntDef(Values['TruckCount'],0);
      end;
      Inc(nInt);
    end;
  finally
    nListB.Free;
    nListA.Free;
  end;   
end;

end.




