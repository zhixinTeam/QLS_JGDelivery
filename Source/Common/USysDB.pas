{*******************************************************************************
  ����: dmzn@163.com 2008-08-07
  ����: ϵͳ���ݿⳣ������

  ��ע:
  *.�Զ�����SQL���,֧�ֱ���:$Inc,����;$Float,����;$Integer=sFlag_Integer;
    $Decimal=sFlag_Decimal;$Image,��������
*******************************************************************************}
unit USysDB;

{$I Link.inc}
interface

uses
  SysUtils, Classes;

const
  cSysDatabaseName: array[0..4] of String = (
     'Access', 'SQL', 'MySQL', 'Oracle', 'DB2');
  //db names

  cPrecision            = 100;
  {-----------------------------------------------------------------------------
   ����: ���㾫��
   *.����Ϊ�ֵļ�����,С��ֵ�Ƚϻ����������ʱ�������,���Ի��ȷŴ�,ȥ��
     С��λ������������.�Ŵ����ɾ���ֵȷ��.
  -----------------------------------------------------------------------------}

type
  TSysDatabaseType = (dtAccess, dtSQLServer, dtMySQL, dtOracle, dtDB2);
  //db types

  PSysTableItem = ^TSysTableItem;
  TSysTableItem = record
    FTable: string;
    FNewSQL: string;
  end;
  //ϵͳ����

var
  gSysTableList: TList = nil;                        //ϵͳ������
  gSysDBType: TSysDatabaseType = dtSQLServer;        //ϵͳ��������

//------------------------------------------------------------------------------
const
  //�����ֶ�
  sField_Access_AutoInc          = 'Counter';
  sField_SQLServer_AutoInc       = 'Integer IDENTITY (1,1) PRIMARY KEY';

  //С���ֶ�
  sField_Access_Decimal          = 'Float';
  sField_SQLServer_Decimal       = 'Decimal(15, 5)';

  //ͼƬ�ֶ�
  sField_Access_Image            = 'OLEObject';
  sField_SQLServer_Image         = 'Image';

  //�������
  sField_SQLServer_Now           = 'getDate()';

ResourceString     
  {*Ȩ����*}
  sPopedom_Read       = 'A';                         //���
  sPopedom_Add        = 'B';                         //���
  sPopedom_Edit       = 'C';                         //�޸�
  sPopedom_Delete     = 'D';                         //ɾ��
  sPopedom_Preview    = 'E';                         //Ԥ��
  sPopedom_Print      = 'F';                         //��ӡ
  sPopedom_Export     = 'G';                         //����
  sPopedom_ViewPrice  = 'H';                         //�鿴����

  {*���ݿ��ʶ*}
  sFlag_DB_K3         = 'King_K3';                   //������ݿ�
  sFlag_DB_NC         = 'YonYou_NC';                 //�������ݿ�
  sFlag_DB_AX         = 'AX_DB';                     //AX���ݿ�

  {*��ر��*}
  sFlag_Yes           = 'Y';                         //��
  sFlag_No            = 'N';                         //��
  sFlag_Unknow        = 'U';                         //δ֪ 
  sFlag_Enabled       = 'Y';                         //����
  sFlag_Disabled      = 'N';                         //����

  sFlag_Integer       = 'I';                         //����
  sFlag_Decimal       = 'D';                         //С��

  sFlag_ManualNo      = '%';                         //�ֶ�ָ��(��ϵͳ�Զ�)
  sFlag_NotMatter     = '@';                         //�޹ر��(�����Ŷ���)
  sFlag_ForceDone     = '#';                         //ǿ�����(δ���ǰ����)
  sFlag_FixedNo       = '$';                         //ָ�����(ʹ����ͬ���)

  sFlag_Provide       = 'P';                         //��Ӧ
  sFlag_Sale          = 'S';                         //����
  sFlag_Returns       = 'R';                         //�˻�
  sFlag_Other         = 'O';                         //����
  sFlag_DuanDao       = 'D';                         //�̵�(Ԥ��Ƥ��,���γ���)
  sFlag_ST            = 'T';                         //����

  sFlag_ManualA       = 'A';                         //Ƥ��Ԥ��(�����¼�����)
  sFlag_ManualB       = 'B';                         //Ƥ�س�����Χ
  sFlag_ManualC       = 'C';                         //���س�����Χ
  sFlag_ManualD       = 'D';                         //������ű��֪ͨ  
  sFlag_ManualE       = 'E';
  sFlag_TiHuo         = 'T';                         //����
  sFlag_SongH         = 'S';                         //�ͻ�
  sFlag_XieH          = 'X';                         //��ж

  sFlag_Dai           = 'D';                         //��װˮ��
  sFlag_San           = 'S';                         //ɢװˮ��

  sFlag_BillNew       = 'N';                         //�µ�
  sFlag_BillEdit      = 'E';                         //�޸�
  sFlag_BillDel       = 'D';                         //ɾ��
  sFlag_BillLading    = 'L';                         //�����
  sFlag_BillPick      = 'P';                         //����
  sFlag_BillPost      = 'G';                         //����
  sFlag_BillDone      = 'O';                         //���

  sFlag_OrderNew       = 'N';                        //�µ�
  sFlag_OrderEdit      = 'E';                        //�޸�
  sFlag_OrderDel       = 'D';                        //ɾ��
  sFlag_OrderPuring    = 'L';                        //�ͻ���
  sFlag_OrderDone      = 'O';                        //���
  sFlag_OrderAbort     = 'A';                        //����
  sFlag_OrderStop      = 'S';                        //��ֹ

  sFlag_OrderCardL     = 'L';                        //��ʱ
  sFlag_OrderCardG     = 'G';                        //�̶�

  sFlag_TypeShip      = 'S';                         //����
  sFlag_TypeZT        = 'Z';                         //ջ̨
  sFlag_TypeVIP       = 'V';                         //VIP
  sFlag_TypeCommon    = 'C';                         //��ͨ,��������

  sFlag_CardIdle      = 'I';                         //���п�
  sFlag_CardUsed      = 'U';                         //ʹ����
  sFlag_CardLoss      = 'L';                         //��ʧ��
  sFlag_CardInvalid   = 'N';                         //ע����

  sFlag_TruckNone     = 'N';                         //��״̬����
  sFlag_TruckIn       = 'I';                         //��������
  sFlag_TruckOut      = 'O';                         //��������
  sFlag_TruckBFP      = 'P';                         //����Ƥ�س���
  sFlag_TruckBFM      = 'M';                         //����ë�س���
  sFlag_TruckSH       = 'S';                         //�ͻ�����
  sFlag_TruckFH       = 'F';                         //�Żҳ���
  sFlag_TruckZT       = 'Z';                         //ջ̨����
  sFlag_TruckXH       = 'X';                         //���ճ���

  sFlag_TJNone        = 'N';                         //δ����
  sFlag_TJing         = 'T';                         //������
  sFlag_TJOver        = 'O';                         //�������
  
  sFlag_PoundBZ       = 'B';                         //��׼
  sFlag_PoundPZ       = 'Z';                         //Ƥ��
  sFlag_PoundPD       = 'P';                         //���
  sFlag_PoundCC       = 'C';                         //����(����ģʽ)
  sFlag_PoundLS       = 'L';                         //��ʱ
  
  sFlag_MoneyHuiKuan  = 'R';                         //�ؿ����
  sFlag_MoneyJiaCha   = 'C';                         //���ɼ۲�
  sFlag_MoneyZhiKa    = 'Z';                         //ֽ���ؿ�
  sFlag_MoneyFanHuan  = 'H';                         //�����û�

  sFlag_InvNormal     = 'N';                         //������Ʊ
  sFlag_InvHasUsed    = 'U';                         //���÷�Ʊ
  sFlag_InvInvalid    = 'V';                         //���Ϸ�Ʊ
  sFlag_InvRequst     = 'R';                         //���뿪��
  sFlag_InvDaily      = 'D';                         //�ճ�����

  sFlag_DeductFix     = 'F';                         //�̶�ֵ�ۼ�
  sFlag_DeductPer     = 'P';                         //�ٷֱȿۼ�
  sFlag_LoadExtInfo   = 'ExtInfo;';                  //���븽��
  sFlag_AllowZeroNum  = 'ZeroNum;';                  //����û��

  sFlag_wuchaType_D   = '1';                         //�����������-��װˮ��
  sFlag_wuchaType_S   = '2';                         //�����������-ɢװˮ��
  sFlag_wuchaType_Z   = '3';                         //�����������-ש��

  sFlag_SysParam      = 'SysParam';                  //ϵͳ����
  sFlag_EnableBakdb   = 'Uses_BackDB';               //���ÿ�
  sFlag_ValidDate     = 'SysValidDate';              //��Ч��
  sFlag_ZhiKaVerify   = 'ZhiKaVerify';               //ֽ�����
  sFlag_PrintZK       = 'PrintZK';                   //��ӡֽ��
  sFlag_PrintBill     = 'PrintStockBill';            //���ӡ����
  sFlag_PrintFHD      = 'PrintFHD';                  //��ӡ���˵�
  sFlag_ViaBillCard   = 'ViaBillCard';               //ֱ���ƿ�
  sFlag_PayCredit     = 'Pay_Credit';                //�ؿ������
  sFlag_HYValue       = 'HYMaxValue';                //����������
  sFlag_SaleManDept   = 'SaleManDepartment';         //ҵ��Ա���ű��
  sFlag_OrderLimValue = 'OrderLimValue';                //����������ֵ
  
  sFlag_PDaiWuChaZ    = 'PoundDaiWuChaZ';            //��װ����� 10t-150t
  sFlag_PDaiWuChaF    = 'PoundDaiWuChaF';            //��װ����� 10t-150t
  sFlag_PDaiPercent   = 'PoundDaiPercent';           //�������������
  sFlag_PDaiWuChaStop = 'PoundDaiWuChaStop';         //��װ���ʱֹͣҵ��
  sFlag_PSanWuChaStop = 'PoundSanWuChaStop';         //ɢװ���ʱֹͣҵ��
  sFlag_PBrickWuChaStop = 'PoundBrickWuChaStop';     //ש�����ʱֹͣҵ��
  sFlag_PSanWuChaF    = 'PoundSanWuChaF';            //ɢװ�����
  sFlag_PoundWuCha    = 'PoundWuCha';                //����������
  sFlag_PoundIfDai    = 'PoundIFDai';                //��װ�Ƿ����
  sFlag_NFStock       = 'NoFaHuoStock';              //�ֳ����跢��
  sFlag_NFPurch       = 'NoFaHuoPurch';              //�ֳ����跢����ԭ���ϣ�
  sFlag_PEmpTWuCha    = 'EmpTruckWuCha';             //�ճ��������
  sFlag_NoEleCard     = 'NoEleCard';                 //���������ӱ�ǩ

  sFlag_CommonItem    = 'CommonItem';                //������Ϣ
  sFlag_CardItem      = 'CardItem';                  //�ſ���Ϣ��
  sFlag_AreaItem      = 'AreaItem';                  //������Ϣ��
  sFlag_TruckItem     = 'TruckItem';                 //������Ϣ��
  sFlag_CustomerItem  = 'CustomerItem';              //�ͻ���Ϣ��
  sFlag_BankItem      = 'BankItem';                  //������Ϣ��
  sFlag_UserLogItem   = 'UserLogItem';               //�û���¼��

  sFlag_StockItem     = 'StockItem';                 //ˮ����Ϣ��
  sFlag_ContractItem  = 'ContractItem';              //��ͬ��Ϣ��
  sFlag_SalesmanItem  = 'SalesmanItem';              //ҵ��Ա��Ϣ��
  sFlag_ZhiKaItem     = 'ZhiKaItem';                 //ֽ����Ϣ��
  sFlag_BillItem      = 'BillItem';                  //�ᵥ��Ϣ��
  sFlag_TruckQueue    = 'TruckQueue';                //��������
  sFlag_ZTLineGroup   = 'ZTLineGroup';               //ջ̨����
  sFlag_brickcolor    = 'BrickColor';                //����ש����ɫ

  sFlag_PaymentItem   = 'PaymentItem';               //���ʽ��Ϣ��
  sFlag_PaymentItem2  = 'PaymentItem2';              //���ۻؿ���Ϣ��
  sFlag_LadingItem    = 'LadingItem';                //�����ʽ��Ϣ��

  sFlag_ProviderItem  = 'ProviderItem';              //��Ӧ����Ϣ��
  sFlag_MaterailsItem = 'MaterailsItem';             //ԭ������Ϣ��

  sFlag_HardSrvURL    = 'HardMonURL';
  sFlag_MITSrvURL     = 'MITServiceURL';             //�����ַ
  sFlag_Factoryid     = 'FactoryId';                 //����ID����΢��ƽ̨��������ʱʹ��
  sFlag_AICMWorkshop  = 'aicmworkshop';              //�����쿨ϵͳ-�����������

  sFlag_AutoIn        = 'Truck_AutoIn';              //�Զ�����
  sFlag_AutoOut       = 'Truck_AutoOut';             //�Զ�����
  sFlag_InTimeout     = 'InFactTimeOut';             //������ʱ(����)
  sFlag_InAndCreate   = 'InFactAndCreate';           //HY�������
  sFlag_SanMultiBill  = 'SanMultiBill';              //ɢװԤ���൥
  sFlag_NoDaiQueue    = 'NoDaiQueue';                //��װ���ö���
  sFlag_NoSanQueue    = 'NoSanQueue';                //ɢװ���ö���
  sFlag_DelayQueue    = 'DelayQueue';                //�ӳ��Ŷ�(����)
  sFlag_PoundQueue    = 'PoundQueue';                //�ӳ��Ŷ�(�������ݹ�Ƥʱ��)
  sFlag_NetPlayVoice  = 'NetPlayVoice';              //ʹ��������������
  sFlag_Standard      = 'standard';                  //������ִ�б�׼

  sFlag_BusGroup      = 'BusFunction';               //ҵ�������
  sFlag_BillNo        = 'Bus_Bill';                  //��������
  sFlag_PoundID       = 'Bus_Pound';                 //���ؼ�¼
  sFlag_Customer      = 'Bus_Customer';              //�ͻ����
  sFlag_SaleMan       = 'Bus_SaleMan';               //ҵ��Ա���
  sFlag_ZhiKa         = 'Bus_ZhiKa';                 //ֽ�����
  sFlag_WeiXin        = 'Bus_WeiXin';                //΢��ӳ����
  sFlag_HYDan         = 'Bus_HYDan';                 //���鵥��
  sFlag_ForceHint     = 'Bus_HintMsg';               //ǿ����ʾ
  sFlag_Order         = 'Bus_Order';                 //�ɹ�����
  sFlag_OrderDtl      = 'Bus_OrderDtl';              //�ɹ�����
  sFlag_OrderBase     = 'Bus_OrderBase';             //�ɹ����뵥��
  sFlag_Transfer      = 'Bus_Transfer';              //�̵�����
  sFlag_Hhcl          = 'HuYanHhcl';                 //��ϲ���
  sFlag_OnLineModel   = 'OnLineModel';               //����ģʽ
  sFlag_NoSampleID    = 'NoSampleID';                //���������
  sFlag_Sgzl          = 'HuYanSgzl';                 //ʯ������
  sFlag_BrickItem     = 'BrickItem';                 //����ש������
  sFlag_NoKcStock     = 'NoKcStock';                 //�޿������
  sFlag_TruckInNeedManu = 'TruckInNeedManu';         //����ʶ����Ҫ�˹���Ԥ
  sFlag_SnapInfoPost  = 'SnapInfoPost';              //����ʶ����Ϣ���͸�λ

  sFlag_Departments   = 'Departments';               //�����б�
//  sFlag_DepDaTing     = '����';                      //�������
//  sFlag_DepJianZhuang = '��װ';                      //��װ
//  sFlag_DepBangFang   = '����';                      //����

  sFlag_Solution_YN   = 'Y=ͨ��;N=��ֹ';

  {*���ݱ�*}
  sTable_Group        = 'Sys_Group';                 //�û���
  sTable_User         = 'Sys_User';                  //�û���
  sTable_Menu         = 'Sys_Menu';                  //�˵���
  sTable_Popedom      = 'Sys_Popedom';               //Ȩ�ޱ�
  sTable_PopItem      = 'Sys_PopItem';               //Ȩ����
  sTable_Entity       = 'Sys_Entity';                //�ֵ�ʵ��
  sTable_DictItem     = 'Sys_DataDict';              //�ֵ���ϸ
  sTable_ManualEvent  = 'Sys_ManualEvent';           //�˹���Ԥ�¼�  

  sTable_SysDict      = 'Sys_Dict';                  //ϵͳ�ֵ�
  sTable_ExtInfo      = 'Sys_ExtInfo';               //������Ϣ
  sTable_SysLog       = 'Sys_EventLog';              //ϵͳ��־
  sTable_BaseInfo     = 'Sys_BaseInfo';              //������Ϣ
  sTable_SerialBase   = 'Sys_SerialBase';            //��������
  sTable_SerialStatus = 'Sys_SerialStatus';          //���״̬
  sTable_WorkePC      = 'Sys_WorkePC';               //��֤��Ȩ

  sTable_Customer     = 'S_Customer';                //�ͻ���Ϣ
  sTable_CustomerExt  = 'S_CustomerExt';             //�ͻ���չ
  sTable_Salesman     = 'S_Salesman';                //ҵ����Ա
  sTable_SaleContract = 'S_Contract';                //���ۺ�ͬ
  sTable_SContractExt = 'S_ContractExt';             //��ͬ��չ

  sTable_ZhiKa        = 'S_ZhiKa';                   //ֽ������
  sTable_ZhiKaDtl     = 'S_ZhiKaDtl';                //ֽ����ϸ
  sTable_Card         = 'S_Card';                    //���۴ſ�
  sTable_CardOther    = 'S_CardOther';               //��ʱ����
  sTable_Bill         = 'S_Bill';                    //�����
  sTable_BillBak      = 'S_BillBak';                 //��ɾ������

  sTable_StockMatch   = 'S_StockMatch';              //Ʒ��ӳ��
  sTable_StockParam   = 'S_StockParam';              //Ʒ�ֲ���
  sTable_StockParamExt= 'S_StockParamExt';           //������չ
  sTable_StockRecord  = 'S_StockRecord';             //�����¼
  sTable_StockHuaYan  = 'S_StockHuaYan';             //�����鵥
  sTable_StockRecord_Slag  = 'S_StockRecord_Slag';   //�����ۼ����¼
  sTable_StockRecord_Concrete  = 'S_StockRecord_Concrete';   //��������Ʒ�����¼
  sTable_StockRecord_clinker  = 'S_StockRecord_clinker';     //ͨ�����ϼ����¼

  sTable_Truck        = 'S_Truck';                   //������
  sTable_ZTLines      = 'S_ZTLines';                 //װ����
  sTable_ZTTrucks     = 'S_ZTTrucks';                //��������
  sTable_YSLines      = 'S_YSLines';                 //����ͨ��

  sTable_Provider     = 'P_Provider';                //�ͻ���
  sTable_Materails    = 'P_Materails';               //���ϱ�
  sTable_Order        = 'P_Order';                   //�ɹ�����
  sTable_OrderBak     = 'P_OrderBak';                //��ɾ���ɹ�����
  sTable_OrderBaseMain= 'P_OrderBaseMain';           //�ɹ����붩������
  sTable_OrderBase    = 'P_OrderBase';               //�ɹ����붩��
  sTable_OrderBaseBak = 'P_OrderBaseBak';            //��ɾ���ɹ����붩��
  sTable_OrderDtl     = 'P_OrderDtl';                //�ɹ�������ϸ
  sTable_OrderDtlBak  = 'P_OrderDtlBak';             //�ɹ�������ϸ
  sTable_Deduct       = 'S_PoundDeduct';             //��������

  sTable_Transfer     = 'P_Transfer';                //�̵���ϸ��
  sTable_TransferBak  = 'P_TransferBak';             //�̵���ϸ��
  
  sTable_CusAccount   = 'Sys_CustomerAccount';       //�ͻ��˻�
  sTable_InOutMoney   = 'Sys_CustomerInOutMoney';    //�ʽ���ϸ
  sTable_CusCredit    = 'Sys_CustomerCredit';        //�ͻ����ã��ͻ���
  sTable_SysShouJu    = 'Sys_ShouJu';                //�վݼ�¼

  sTable_Invoice      = 'Sys_Invoice';               //��Ʊ�б�
  sTable_InvoiceDtl   = 'Sys_InvoiceDetail';         //��Ʊ��ϸ
  sTable_InvoiceWeek  = 'Sys_InvoiceWeek';           //��������
  sTable_InvoiceReq   = 'Sys_InvoiceRequst';         //��������
  sTable_InvReqtemp   = 'Sys_InvoiceReqtemp';        //��ʱ����
  sTable_DataTemp     = 'Sys_DataTemp';              //��ʱ����

  sTable_WeixinLog    = 'Sys_WeixinLog';             //΢����־
  sTable_WeixinMatch  = 'Sys_WeixinMatch';           //�˺�ƥ��
  sTable_WeixinTemp   = 'Sys_WeixinTemplate';        //��Ϣģ��
  sTable_WeixinBind   = 'sys_WeixinCusBind';         //΢���˺Ű�
  sTable_WeixinBindP  = 'sys_WeixinProBind';         //΢���˺Ű󶨣��ɹ���

  sTable_PoundLog     = 'Sys_PoundLog';              //��������
  sTable_PoundBak     = 'Sys_PoundBak';              //��������
  sTable_Picture      = 'Sys_Picture';               //���ͼƬ

  sTable_BindInfo     = 'W_BindInfo';                //�û��󶨣�΢�ţ�
  sTable_CustomerInfo = 'W_CustomerInfo';            //�ͻ���Ϣ��΢�ţ�
  sTable_WebOrderMatch   = 'S_WebOrderMatch';        //�̳Ƕ���ӳ��
  sTable_SnapTruck    = 'Sys_SnapTruck';             //����ץ�ļ�¼

  sTable_InventDim       = 'Sys_InventDim';          //ά����Ϣ
  sTable_InventCenter    = 'Sys_InventCenter';       //�����߻�����
  sTable_ForceCenterID   = 'Sys_ForceCenterID';       //ǿ�������߱�
  sTable_InventLocation  = 'Sys_InventLocation';     //�ֿ������
  sTable_CusContCredit   = 'Sys_CustContCredit';     //�ͻ����ã��ͻ�-��ͬ��
  sTable_CustPresLog     = 'Sys_CustPresLog';        //���ö������(�ͻ�)
  sTable_ContPresLog     = 'Sys_ContPresLog';        //���ö������(�ͻ�-��ͬ)
  sTable_AddTreaty       = 'Sys_AddTreaty';          //����Э��
  sTable_InvCenGroup     = 'Sys_InvCenGroup';        //������������
  sTable_EMPL            = 'Sys_EMPLOYEES';          //Ա����
  sTable_PoundWucha      = 'Sys_PoundWuCha';         //������������
  sTable_PoundDevia      = 'Sys_PoundDevia';         //�������ֵ
  sTable_ZTWorkSet       = 'S_ZTWorkSet';            //������ñ�
  sTable_InOutFatory     = 'L_InOutFactory';         //��ʱ����������
  sTable_KuWei           = 'Sys_KuWei';              //��λ���ñ�
  sTable_CompanyArea     = 'Sys_CompanyArea';        //��������
  sTable_STInOutFact     = 'L_STInOutFact';          //���ų�������
  sTable_AxPlanInfo      = 'E_AxPlanInfo';           //�����Ϣ��
  sTable_AxMsgList       = 'E_AxMsgList';            //AX��Ϣ���б�

  sTable_K3_SyncItem  = 'DL_SyncItem';               //����ͬ����
  sTable_K3_Customer  = 'T_Organization';            //��֯�ṹ(�ͻ�)

  sTable_AX_Cust      = 'ERP_CustTable';             //�ͻ���Ϣ
  sTable_AX_VEND      = 'ERP_VVendTable';            //��Ӧ����Ϣ
  sTable_AX_COMPANY   = 'COMPANYDOMAINLIST';         //��˾��Ϣ
  sTable_AX_INVENT    = 'ERP_InventTable';           //������Ϣ
  sTable_AX_INVENTDIM = 'INVENTDIM';                 //ά�Ȼ�����
  sTable_AX_INVENTCENTER  = 'XTTINVENTCENTERTABLE';  //�����߻�����
  sTable_AX_INVENTLOCATION  = 'INVENTLOCATION';      //�ֿ������
  sTable_AX_TPRESTIGEMANAGE  = 'XT_TPRESTIGEMANAGE'; //���ö�ȣ��ͻ���
  sTable_AX_TPRESTIGEMBYCONT  = 'XT_TPRESTIGEMANAGEBYCONTRACT';  //���ö�ȣ��ͻ�-��ͬ��
  STable_AX_EMPL      = 'EMPLTABLE';                 //Ա����Ϣ��
  sTable_AX_InvCenGroup = 'xtTInventCenterItemGroup';//������������
  sTable_AX_WMSLocation = 'WMSLocation';//��λ��Ϣ��
  //----------------------------------------------------------------------------
  //sTable_AX_Sales     = 'SALESTABLE';                //���۶���
  sTable_AX_Sales     = 'SalesTalbeView';                //���۶���
  sTable_AX_SalLine   = 'SALESLINE';                 //���۶�����
  sTable_AX_SupAgre   = 'XTADDTreatyRefSL';          //����Э��
  sTable_AX_CreLimLog = 'XT_CUSTPRESTIGEQUOTALOG';   //���ö������(�ͻ�)
  sTable_AX_ContCreLimLog = 'XT_CustPQLogContractId';//���ö������(�ͻ�-��ͬ)
  sTable_AX_SalesCont = 'CMT_ContractTable';         //���ۺ�ͬ
  sTable_AX_SalContLine = 'CMT_ContractTrans';       //���ۺ�ͬ��
  sTable_AX_VehicleNo = 'CMT_Vehicle';               //������Ϣ
  sTable_AX_PurOrder  = 'purchtable';                //�ɹ�����
  sTable_AX_PurOrdLine= 'Purchline';                 //�ɹ�������
  sTable_AX_CompArea  = 'XT_COMPACTAREA';            //��������
  sTable_AX_InventSum = 'XT_VInventSumDim';               //����������



  {*�½���*}
  sSQL_NewSysDict = 'Create Table $Table(D_ID $Inc, D_Name varChar(15),' +
       'D_Desc varChar(30), D_Value varChar(50), D_Memo varChar(20),' +
       'D_ParamA $Float, D_ParamB varChar(50), D_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   ϵͳ�ֵ�: SysDict
   *.D_ID: ���
   *.D_Name: ����
   *.D_Desc: ����
   *.D_Value: ȡֵ
   *.D_Memo: �����Ϣ
   *.D_ParamA: �������
   *.D_ParamB: �ַ�����
   *.D_Index: ��ʾ����
  -----------------------------------------------------------------------------}
  
  sSQL_NewExtInfo = 'Create Table $Table(I_ID $Inc, I_Group varChar(20),' +
       'I_ItemID varChar(20), I_Item varChar(30), I_Info varChar(500),' +
       'I_ParamA $Float, I_ParamB varChar(50), I_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   ��չ��Ϣ��: ExtInfo
   *.I_ID: ���
   *.I_Group: ��Ϣ����
   *.I_ItemID: ��Ϣ��ʶ
   *.I_Item: ��Ϣ��
   *.I_Info: ��Ϣ����
   *.I_ParamA: �������
   *.I_ParamB: �ַ�����
   *.I_Memo: ��ע��Ϣ
   *.I_Index: ��ʾ����
  -----------------------------------------------------------------------------}
  
  sSQL_NewSysLog = 'Create Table $Table(L_ID $Inc, L_Date DateTime,' +
       'L_Man varChar(32),L_Group varChar(20), L_ItemID varChar(20),' +
       'L_KeyID varChar(20), L_Event varChar(220))';
  {-----------------------------------------------------------------------------
   ϵͳ��־: SysLog
   *.L_ID: ���
   *.L_Date: ��������
   *.L_Man: ������
   *.L_Group: ��Ϣ����
   *.L_ItemID: ��Ϣ��ʶ
   *.L_KeyID: ������ʶ
   *.L_Event: �¼�
  -----------------------------------------------------------------------------}

  sSQL_NewBaseInfo = 'Create Table $Table(B_ID $Inc, B_Group varChar(15),' +
       'B_Text varChar(100), B_Py varChar(25), B_Memo varChar(50),' +
       'B_PID Integer, B_Index Float)';
  {-----------------------------------------------------------------------------
   ������Ϣ��: BaseInfo
   *.B_ID: ���
   *.B_Group: ����
   *.B_Text: ����
   *.B_Py: ƴ����д
   *.B_Memo: ��ע��Ϣ
   *.B_PID: �ϼ��ڵ�
   *.B_Index: ����˳��
  -----------------------------------------------------------------------------}

  sSQL_NewSerialBase = 'Create Table $Table(R_ID $Inc, B_Group varChar(15),' +
       'B_Object varChar(32), B_Prefix varChar(25), B_IDLen Integer,' +
       'B_Base Integer, B_Date DateTime)';
  {-----------------------------------------------------------------------------
   ���б�Ż�����: SerialBase
   *.R_ID: ���
   *.B_Group: ����
   *.B_Object: ����
   *.B_Prefix: ǰ׺
   *.B_IDLen: ��ų�
   *.B_Base: ����
   *.B_Date: �ο�����
  -----------------------------------------------------------------------------}

  sSQL_NewSerialStatus = 'Create Table $Table(R_ID $Inc, S_Object varChar(32),' +
       'S_SerailID varChar(32), S_PairID varChar(32), S_Status Char(1),' +
       'S_Date DateTime)';
  {-----------------------------------------------------------------------------
   ����״̬��: SerialStatus
   *.R_ID: ���
   *.S_Object: ����
   *.S_SerailID: ���б��
   *.S_PairID: ��Ա��
   *.S_Status: ״̬(Y,N)
   *.S_Date: ����ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewWorkePC = 'Create Table $Table(R_ID $Inc, W_Name varChar(100),' +
       'W_MAC varChar(32), W_Factory varChar(32), W_Serial varChar(32),' +
       'W_Departmen varChar(32), W_ReqMan varChar(32), W_ReqTime DateTime,' +
       'W_RatifyMan varChar(32), W_RatifyTime DateTime, W_Valid Char(1))';
  {-----------------------------------------------------------------------------
   ������Ȩ: WorkPC
   *.R_ID: ���
   *.W_Name: ��������
   *.W_MAC: MAC��ַ
   *.W_Factory: �������
   *.W_Departmen: ����
   *.W_Serial: ���
   *.W_ReqMan,W_ReqTime: ��������
   *.W_RatifyMan,W_RatifyTime: ��׼
   *.W_Valid: ��Ч(Y/N)
  -----------------------------------------------------------------------------}

  sSQL_NewManualEvent = 'Create Table $Table(R_ID $Inc, E_ID varChar(32),' +
       'E_From varChar(32), E_Key varChar(32), E_Event varChar(200), ' +
       'E_Solution varChar(100), E_Result varChar(12),E_Departmen varChar(32),' +
       'E_Date DateTime, E_ManDeal varChar(32), E_DateDeal DateTime)';
  {-----------------------------------------------------------------------------
   �˹���Ԥ�¼�: ManualEvent
   *.R_ID: ���
   *.E_ID: ��ˮ��
   *.E_From: ��Դ
   *.E_Key: ��¼��ʶ
   *.E_Event: �¼�
   *.E_Solution: ������(��ʽ��: Y=ͨ��;N=��ֹ) 
   *.E_Result: ������(Y/N)
   *.E_Departmen: ������
   *.E_Date: ����ʱ��
   *.E_ManDeal,E_DateDeal: ������
  -----------------------------------------------------------------------------}  

  sSQL_NewSyncItem = 'Create Table $Table(R_ID $Inc, S_Table varChar(100),' +
       'S_Action Char(1), S_Record varChar(32), S_Param1 varChar(100),' +
       'S_Param2 $Float, S_Time DateTime)';
  {-----------------------------------------------------------------------------
   ͬ��������: SyncItem
   *.R_ID: ���
   *.S_Table: ������
   *.S_Action: ��ɾ��(A,E,D)
   *.S_Record: ��¼���
   *.S_Param1,S_Param2: ����
   *.S_Time: ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewStockMatch = 'Create Table $Table(R_ID $Inc, M_Group varChar(8),' +
       'M_ID varChar(20), M_Name varChar(80), M_Status Char(1), M_LineNo varChar(32))';
  {-----------------------------------------------------------------------------
   ����Ʒ��ӳ��: StockMatch
   *.R_ID: ��¼���
   *.M_Group: ����
   *.M_ID: ���Ϻ�
   *.M_Name: ��������
   *.M_Status: ״̬
   *.M_LineNo: ͨ��ר�÷���
  -----------------------------------------------------------------------------}
  
  sSQL_NewSalesMan = 'Create Table $Table(R_ID $Inc, S_ID varChar(15),' +
       'S_Name varChar(30), S_PY varChar(30), S_Phone varChar(20),' +
       'S_Area varChar(50), S_InValid Char(1), S_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ҵ��Ա��: SalesMan
   *.R_ID: ��¼��
   *.S_ID: ���
   *.S_Name: ����
   *.S_PY: ��ƴ
   *.S_Phone: ��ϵ��ʽ
   *.S_Area:��������
   *.S_InValid: ����Ч
   *.S_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewCustomer = 'Create Table $Table(R_ID $Inc, C_ID varChar(15), ' +
       'C_Name varChar(80), C_PY varChar(80), C_Addr varChar(100), ' +
       'C_FaRen varChar(50), C_LiXiRen varChar(50), C_WeiXin varChar(15),' +
       'C_Phone varChar(15), C_Fax varChar(15), C_Tax varChar(32),' +
       'C_Bank varChar(35), C_Account varChar(18), C_SaleMan varChar(15),' +
       'C_Param varChar(32), C_Memo varChar(50), C_XuNi Char(1),' +
       'C_Factory varChar(50), C_ToUser varChar(50), C_IsBind Char(1),'+
       'C_CredMax Decimal(15,5) Default 0,C_MaCredLmt varChar(32),'+
       'C_CelPhone varChar(32))';
  {-----------------------------------------------------------------------------
   �ͻ���Ϣ��: Customer
   *.R_ID: ��¼��
   *.C_ID: ���
   *.C_Name: ����
   *.C_PY: ƴ����д
   *.C_Addr: ��ַ
   *.C_FaRen: ����
   *.C_LiXiRen: ��ϵ��
   *.C_Phone: �绰
   *.C_WeiXin: ΢��
   *.C_Fax: ����
   *.C_Tax: ˰��
   *.C_Bank: ������
   *.C_Account: �ʺ�
   *.C_SaleMan: ҵ��Ա
   *.C_Param: ���ò���
   *.C_Memo: ��ע��Ϣ
   *.C_XuNi: ����(��ʱ)�ͻ�
   *.C_Factory���������к�
   *.C_ToUser�����û�ID
   *.C_IsBind����״̬��0����� 1���󶨣�
   --����ɽ�����ֶ�
   *.C_CredMax�����ö��
   *.C_MaCredLmt��ǿ�����ö��[У���Ƿ�ǿ��]
   *.C_CelPhone���ƶ��绰
  -----------------------------------------------------------------------------}

  sSQL_NewCustomerExt = 'Create Table $Table(R_ID $Inc, E_CusID varChar(15), ' +
       'E_CusName varChar(80), E_CusPY varChar(80), E_CustExtName varChar(100), ' +
       'E_CustExtPY varChar(50), E_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   �ͻ���չ��: CustomerExt
   *.R_ID: ��¼��
   *.E_CusID: �ͻ����
   *.E_CusName: �ͻ�����
   *.E_CusPY: ƴ����д
   *.E_CustExtName: �ͻ���չ����
   *.E_CustExtPY: �ͻ���չƴ��
   *.E_Memo: ��ע��Ϣ
  -----------------------------------------------------------------------------}

  sSQL_NewCusAccount = 'Create Table $Table(R_ID $Inc, A_CID varChar(15),' +
       'A_Used Char(1), A_InMoney Decimal(15,5) Default 0,' +
       'A_OutMoney Decimal(15,5) Default 0, A_DebtMoney Decimal(15,5) Default 0,' +
       'A_Compensation Decimal(15,5) Default 0,' +
       'A_FreezeMoney Decimal(15,5) Default 0,' +
       'A_CreditLimit Decimal(15,5) Default 0, A_Date DateTime,'+
       'A_ConFreezeMoney Decimal(15,5) not null Default 0,'+
       'A_ConOutMoney Decimal(15,5) not null Default 0)';
  {-----------------------------------------------------------------------------
   �ͻ��˻�:CustomerAccount
   *.R_ID:��¼���
   *.A_CID:�ͻ���
   *.A_Used:��;(��Ӧ,����)
   *.A_InMoney:���
   *.A_OutMoney:����
   *.A_DebtMoney:Ƿ��
   *.A_Compensation:������
   *.A_FreezeMoney:�����ʽ�
   *.A_CreditLimit:���ö��
   *.A_Date:��������
   *.A_ConFreezeMoney:��ͬר��ר�ö����ʽ�
   *.A_ConOutMoney:��ͬר��ר�ó���

   *.ˮ����������
     A_InMoney:�ͻ������˻��Ľ��
     A_OutMoney:�ͻ�ʵ�ʻ��ѵĽ��
     A_DebtMoney:��δ֧���Ľ��
     A_Compensation:���ڲ���˻����ͻ��Ľ��
     A_FreezeMoney:�Ѱ�ֽ����δ��������Ľ��
     A_CreditLimit:���Ÿ��û�����߿�Ƿ����

     ������� = ��� + ���ö� - ���� - ������ - �Ѷ���
     �����ܶ� = ���� + Ƿ�� + �Ѷ���
  -----------------------------------------------------------------------------}

  sSQL_NewInOutMoney = 'Create Table $Table(R_ID $Inc, M_SaleMan varChar(15),' +
       'M_CusID varChar(15), M_CusName varChar(80), ' +
       'M_Type Char(1), M_Payment varChar(20),' +
       'M_Money Decimal(15,5), M_ZID varChar(15), M_Date DateTime,' +
       'M_Man varChar(32), M_Memo varChar(200))';
  {-----------------------------------------------------------------------------
   �������ϸ:CustomerInOutMoney
   *.M_ID:��¼���
   *.M_SaleMan:ҵ��Ա
   *.M_CusID:�ͻ���
   *.M_CusName:�ͻ���
   *.M_Type:����(����,�ؿ��)
   *.M_Payment:���ʽ
   *.M_Money:���ɽ��
   *.M_ZID:ֽ����
   *.M_Date:��������
   *.M_Man:������
   *.M_Memo:����

   *.ˮ�����������
     ��� = ���� x ���� + ����
  -----------------------------------------------------------------------------}

  sSQL_NewSysShouJu = 'Create Table $Table(R_ID $Inc ,S_Code varChar(15),' +
       'S_Sender varChar(100), S_Reason varChar(100), S_Money Decimal(15,5),' +
       'S_BigMoney varChar(50), S_Bank varChar(35), S_Man varChar(32),' +
       'S_Date DateTime, S_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   �վ���ϸ:ShouJu
   *.R_ID:���
   *.S_Code:����ƾ������
   *.S_Sender:����(��Դ)
   *.S_Reason:����(����)
   *.S_Money:���
   *.S_Bank:����
   *.S_Man:����Ա
   *.S_Date:����
   *.S_Memo:��ע
  -----------------------------------------------------------------------------}

  sSQL_NewCusCredit = 'Create Table $Table(R_ID $Inc ,C_CusID varChar(15),' +
       'C_Money Decimal(15,5), C_Man varChar(32), C_Date DateTime, ' +
       'C_End DateTime, C_Memo varChar(50), C_CustName varChar(50), '+
       'C_CashBalance numeric(28, 12), C_BillBalance3M numeric(28, 12), '+
       'C_BillBalance6M numeric(28, 12), C_PrestigeQuota numeric(28, 12), '+
       'C_TemporBalance numeric(28, 12), C_TemporAmount numeric(28, 12), '+
       'C_WarningAmount numeric(28, 12), C_TemporTakeEffect char(1), '+
       'C_FailureDate DateTime, DataAreaID varChar(3),'+
       'C_LSCreditNum varChar(20), C_PrestigeStatus char(1))';
  {-----------------------------------------------------------------------------
   ������ϸ���ͻ���:CustomerCredit
   *.R_ID:���
   *.C_CusID:�ͻ����
   *.C_Money:���Ŷ�
   *.C_Man:������
   *.C_Date:����
   *.C_End: ��Ч��
   *.C_Memo:��ע
   ����ɽ����
   *.C_CustName���ͻ�����
   *.C_CashBalance���ֽ����
   *.C_BillBalance3M��������Ʊ�����
   *.C_BillBalance6M��������Ʊ�����
   *.C_PrestigeQuota���̶��������
   *.C_TemporBalance����ʱ���Ž��
   *.C_TemporAmount�� ��ʱ���
   *.C_WarningAmount��Ԥ�����
   *.C_TemporTakeEffect���Ƿ�ʧЧ(0����/1����)
   *.C_FailureDate��ʧЧ����
   *.DataAreaID����˾����
   *.C_LSCreditNum: ��ʱ���ŵ���
   *.C_PrestigeStatus: �̶����ñ�ʾ��0������/1��ͣ�ã�
  -----------------------------------------------------------------------------}

  sSQL_NewCusConCredit = 'Create Table $Table(R_ID $Inc ,C_CusID varChar(15),' +
       'C_Money Decimal(15,5), C_CustName varChar(50), C_ContractId varChar(60),'+
       'C_CashBalance Decimal(15,5), C_BillBalance3M Decimal(15,5), '+
       'C_BillBalance6M Decimal(15,5), C_PrestigeQuota Decimal(15,5), '+
       'C_TemporBalance Decimal(15,5), C_TemporAmount Decimal(15,5), '+
       'C_WarningAmount Decimal(15,5), C_TemporTakeEffect char(1), '+
       'C_FailureDate DateTime, DataAreaID varChar(3),'+
       'C_LSCreditNum varChar(20), C_Date DateTime)';
  {-----------------------------------------------------------------------------
   ������ϸ���ͻ�-��ͬ��:CustContCredit
   *.R_ID:���
   *.C_CusID:�ͻ����
   *.C_Money:���Ŷ�
   *.C_CustName���ͻ�����
   *.C_ContractId����ͬ���
   *.C_CashBalance���ֽ����
   *.C_BillBalance3M��������Ʊ�����
   *.C_BillBalance6M��������Ʊ�����
   *.C_PrestigeQuota���̶��������
   *.C_TemporBalance����ʱ���
   *.C_TemporAmount����ʱ���Ž��
   *.C_WarningAmount��Ԥ�����
   *.C_TemporTakeEffect���Ƿ�ʧЧ
   *.C_FailureDate��ʧЧ����
   *.DataAreaID����˾����
   *.C_LSCreditNum: ��ʱ���ŵ���
  -----------------------------------------------------------------------------}
  sSQL_NewCustPresLog = 'Create Table $Table(R_ID $Inc ,C_CusID varChar(15),' +
       'C_SubCash Decimal(15,5), C_SubThreeBill Decimal(15,5), '+
       'C_SubSixBil Decimal(15,5), C_SubTmp Decimal(15,5), '+
       'C_SubPrest Decimal(15,5), C_Subdate DateTime, '+
       'C_Createdby varChar(30), C_Createdate int not null default ((0)), '+
       'C_Createtime DateTime, DataAreaID varChar(3),'+
       'RecID bigint not null default ((0)),'+
       'C_YKAmount Decimal(15,5), C_TransPlanID varchar(20))';
  {-----------------------------------------------------------------------------
   ���ö��������:Sys_CustPresLog    ����ɽ����
   *.R_ID:���
   *.C_CusID:�ͻ����
   *.C_SubCash���ֽ�����
   *.C_SubThreeBill��������Ʊ������
   *.C_SubSixBil��������Ʊ������
   *.C_SubTmp����ʱ����
   *.C_SubPrest���̶�����
   *.C_Subdate������ʱ��
   *.C_Createdby��������
   *.C_Createdate����������
   *.C_Createtime������ʱ��
   *.DataAreaID����˾����
   *.RecID: �б���
   *.C_YKAmount Ԥ�۽��
   *.C_TransPlanID ���˼ƻ���
  -----------------------------------------------------------------------------}
  sSQL_NewContPresLog = 'Create Table $Table(R_ID $Inc ,C_CusID varChar(15),' +
       'C_ContractId varChar(20),'+
       'C_SubCash Decimal(15,5), C_SubThreeBill Decimal(15,5), '+
       'C_SubSixBil Decimal(15,5), C_SubTmp Decimal(15,5), '+
       'C_SubPrest Decimal(15,5), C_Subdate DateTime, '+
       'C_Createdby varChar(30), C_Createdate int not null default((0)), '+
       'C_Createtime DateTime, DataAreaID varChar(3),'+
       'RecID bigint not null default ((0)),'+
       'C_YKAmount Decimal(15,5), C_TransPlanID varchar(20))';
  {-----------------------------------------------------------------------------
   ���ö��������(�ͻ�-��ͬ):Sys_CustPresLog    ����ɽ����
   *.R_ID:���
   *.C_CusID:�ͻ����
   *.C_ContractId:��ͬ���
   *.C_SubCash���ֽ�����
   *.C_SubThreeBill��������Ʊ������
   *.C_SubSixBil��������Ʊ������
   *.C_SubTmp����ʱ����
   *.C_SubPrest���̶�����
   *.C_Subdate������ʱ��
   *.C_Createdby��������
   *.C_Createdate����������
   *.C_Createtime������ʱ��
   *.DataAreaID����˾����
   *.RecID���б���
   *.C_YKAmount Ԥ�۽��
   *.C_TransPlanID ���˼ƻ���
  -----------------------------------------------------------------------------}
  sSQL_NewSaleContract = 'Create Table $Table(R_ID $Inc, C_ID varChar(15),' +
       'C_Project varChar(100),C_SaleMan varChar(15), C_Customer varChar(20), '+
       'C_CustName varChar(60),' +
       'C_Date varChar(20), C_Area varChar(50), C_Addr varChar(50),' +
       'C_Delivery varChar(50), C_Payment varChar(20), C_Approval varChar(30),' +
       'C_ZKDays Integer, C_XuNi Char(1), C_Freeze Char(1), C_Memo varChar(50),'+
       'C_SFSP int not null default((0)),C_ContType int not null default((0)),'+
       'C_ContQuota int not null default((0)), DataAreaID varChar(3) not null default(''dat''))';
  {-----------------------------------------------------------------------------
   ���ۺ�ͬ: SalesContract
   *.R_ID: ���
   *.C_ID: ��ͬ���
   *.C_Project: ��Ŀ����
   *.C_SaleMan: ������Ա
   *.C_CustName: �ͻ�����
   *.C_Customer: �ͻ�ID
   *.C_Date: ǩ��ʱ��
   *.C_Area: ��������
   *.C_Addr: ǩ���ص�
   *.C_Delivery: ������
   *.C_Payment: ���ʽ
   *.C_Approval: ��׼��
   *.C_ZKDays: ֽ����Ч��
   *.C_XuNi: �����ͬ
   *.C_Freeze: �Ƿ񶳽�
   *.C_Memo: ��ע��Ϣ
   ����ɽ����
   *.C_SFSP: ��ͬ״̬
   *.C_ContType: ��ͬ����
   *.C_ContQuota: �Ƿ�ר��ר�ú�ͬ
   *.DataAreaID: ����
  -----------------------------------------------------------------------------}

  sSQL_NewSContractExt = 'Create Table $Table(R_ID $Inc,' +
       'E_CID varChar(15), E_Type Char(1), ' +
       'E_StockNo varChar(20), E_StockName varChar(80),' +
       'E_Value Decimal(15,5), E_Price Decimal(15,5), E_Money Decimal(15,5),'+
       'DataAreaID varChar(3) not null default (''dat''),'+
       'E_RecID bigint not null default ((0)))';
  {-----------------------------------------------------------------------------
   ���ۺ�ͬ��ϸ: SalesContract
   *.R_ID: ��¼���
   *.E_CID: ���ۺ�ͬ
   *.E_Type: ����(��,ɢ)
   *.E_StockNo,E_StockName: ˮ������
   *.E_Value: ����
   *.E_Price: ����
   *.E_Money: ���
   *.DataAreaID: ����
   *.E_RecID: �б���
  -----------------------------------------------------------------------------}

  sSQL_NewZhiKa = 'Create Table $Table(R_ID $Inc,Z_ID varChar(15),' +
       'Z_Name varChar(100),Z_Card varChar(16),' +
       'Z_CID varChar(50), Z_Project varChar(100), Z_Customer varChar(15),' +
       'Z_SaleMan varChar(15), Z_Payment varChar(20), Z_Lading Char(1),' +
       'Z_ValidDays DateTime, Z_Password varChar(16), Z_OnlyPwd Char(1),' +
       'Z_Verified Char(1), Z_InValid Char(1), Z_Freeze Char(1),' +
       'Z_YFMoney $Float, Z_FixedMoney $Float, Z_OnlyMoney Char(1),' +
       'Z_TJStatus Char(1), Z_Memo varChar(200), Z_Man varChar(32),' +
       'Z_Date DateTime, Z_SalesStatus int Default 0, Z_SalesType int Default 0, '+
       'Z_TriangleTrade int Default 0, Z_OrgAccountNum varChar(40),'+
       'Z_XSQYBM varChar(10), Z_KHSBM varChar(20), DataAreaID varChar(3),'+
       'Z_IntComOriSalesId varChar(40),Z_PurchType int, Z_CompanyId varchar(3),'+
       'Z_OrgAccountName varChar(120), Z_OrgXSQYMC varChar(20),'+
       'Z_OrgXSQYBM varChar(20),Z_inventlocationid varchar(20))';
  {-----------------------------------------------------------------------------
   ֽ������: ZhiKa
   *.R_ID:��¼���
   *.Z_ID:ֽ����
   *.Z_Card:�ſ���
   *.Z_Name:ֽ������
   *.Z_CID:���ۺ�ͬ
   *.Z_Project:��Ŀ����
   *.Z_Customer:�ͻ����
   *.Z_SaleMan:ҵ��Ա
   *.Z_Payment:���ʽ
   *.Z_Lading:�����ʽ(����,�ͻ�)  0������
   *.Z_ValidDays:��Ч��
   *.Z_Password: ����
   *.Z_OnlyPwd: ͳһ����
   *.Z_Verified:�����
   *.Z_InValid:����Ч
   *.Z_Freeze:�Ѷ���
   *.Z_YFMoney:Ԥ�����
   *.Z_FixedMoney:���ý�
   *.Z_OnlyMoney:ֻʹ�ÿ��ý�
   *.Z_TJStatus:����״̬
   *.Z_Man:������
   *.Z_Date:����ʱ��
   *.Z_SalesStatus: ״̬
   *.Z_SalesType:��������
   *.Z_TriangleTrade: ����ó��
   *.Z_CompanyId: ��˾ID    ����ȷ������ó�׵Ŀͻ�����
   *.Z_XSQYBM: ����������
   *.Z_KHSBM: �ͻ�ʶ����
   *.DataAreaID: ����
   *.Z_IntComOriSalesId: ���۶���ID���ڲ��ɹ�������ó��ʹ�ã�
   *.Z_PurchType: �ɹ�����
   *.Z_OrgAccountNum: �����˻�
   *.Z_OrgAccountName: �����˻�����
   *.Z_OrgXSQYMC: ����������������
   *.Z_OrgXSQYBM: ���������������
   *.Z_inventlocationid:��λ����
  -----------------------------------------------------------------------------}

  sSQL_NewZhiKaDtl = 'Create Table $Table(R_ID $Inc, D_ZID varChar(15),' +
       'D_Type Char(1), D_StockNo varChar(20), D_StockName varChar(80),' +
       'D_Price $Float, D_Value $Float, D_PPrice $Float, ' +
       'D_TPrice Char(1) Default ''Y'', D_LineNum numeric(28, 12) Default 0,'+
       'D_SalesStatus int Default(0), DATAAREAID varChar(3),'+
       'D_RECID bigint not null default ((0)),D_Blocked int not null default((0)),'+
       'D_Memo varChar(200), D_TotalValue $Float)';
  {-----------------------------------------------------------------------------
   ֽ����ϸ:ZhiKaDtl
   *.R_ID:��¼���
   *.D_ZID:ֽ����
   *.D_Type:����(��,ɢ)
   *.D_StockNo,D_StockName:ˮ������
   *.D_Price:����
   *.D_Value:������
   *.D_PPrice:����ǰ����
   *.D_TPrice:�������
   *.D_LineNum:�к�
   *.D_RECID:�б���
   *.D_SalesStatus:��״̬
   *.DATAAREAID: ����
   *.D_Blocked����ֹͣ
   *.D_Memo: ��ע
   *.D_TotalValue: ��������
  -----------------------------------------------------------------------------}

  sSQL_NewBill = 'Create Table $Table(R_ID $Inc, L_ID varChar(20),' +
       'L_Card varChar(16), L_ZhiKa varChar(15), L_Project varChar(100),' +
       'L_Area varChar(50),' +
       'L_CusID varChar(15), L_CusName varChar(80), L_CusPY varChar(80),' +
       'L_CusAccount varChar(30),'+
       'L_SaleID varChar(15), L_SaleMan varChar(32),' +
       'L_Type Char(1), L_StockNo varChar(20), L_StockName varChar(80),' +
       'L_Value $Float, L_Price $Float, L_ZKMoney Char(1),' +
       'L_Truck varChar(15), L_Status Char(1), L_NextStatus Char(1),' +
       'L_InTime DateTime, L_InMan varChar(32),' +
       'L_PValue $Float, L_PDate DateTime, L_PMan varChar(32),' +
       'L_MValue $Float, L_MDate DateTime, L_MMan varChar(32),' +
       'L_LadeTime DateTime, L_LadeMan varChar(32), ' +
       'L_LadeLine varChar(15), L_LineName varChar(32), ' +
       'L_DaiTotal Integer , L_DaiNormal Integer, L_DaiBuCha Integer,' +
       'L_TransID varChar(32),L_TransName varChar(32),L_Searial varChar(32),'+
       'L_OutFact DateTime, L_OutMan varChar(32),' +
       'L_Lading Char(1), L_IsVIP varChar(1), L_Seal varChar(100),' +
       'L_HYDan varChar(15), L_Man varChar(32), L_Date DateTime,' +
       'L_DelMan varChar(32), L_DelDate DateTime,';
  sSQL_NewBill1 ='L_NewSendWx Char(1), L_DelSendWx Char(1), L_OutSendWx Char(1), '+
       'P_PStation varChar(10), P_MStation varChar(10), L_PID varChar(15),'+
       'L_LineNum numeric(28, 12) not null Default ((0)),L_LineRecID bigint,'+
       'L_InvLocationId varChar(20),L_InvCenterId varChar(20),'+
       'L_PlanQty numeric(28, 12) not null Default ((0)),L_CW varChar(10),'+
       'L_Transporter varChar(20),L_vendpicklistid varChar(60),'+
       'L_FYAX Char(1) not null default((0)),L_BDAX Char(1) not null default((0)),'+
       'L_FYNUM int not null default((0)),L_BDNUM int not null default((0)),'+
       'L_SalesType Char(1),L_FYDEL Char(1) not null default((0)),'+
       'L_FYDELNUM int not null default((0)),L_EmptyOut char(1) not null default(''N''),'+
       'L_EOUTAX Char(1) not null default((0)),L_EOUTNUM int not null default((0)),'+
       'L_WorkOrder varchar(10), L_KHSBM varchar(20), L_OrgXSQYMC varChar(20),'+
       'L_IfHYPrint Char(1), L_IfFenChe Char(1), L_IfNeiDao Char(1),'+
       'L_TriaTrade Char(1), L_ContQuota Char(1),L_ToAddr varChar(100),'+
       'L_IdNumber varChar(50),L_szbz char(1),l_color varchar(32))';
  {-----------------------------------------------------------------------------
   ��������: Bill
   *.R_ID: ���
   *.L_ID: �ᵥ��   (AX����)
   *.L_Card: �ſ���
   *.L_ZhiKa: ֽ����/���ۡ��ɹ�������  (AX����)
   *.L_Area: ����
   *.L_CusID,L_CusName,L_CusPY:�ͻ�
   *.L_SaleID,L_SaleMan:ҵ��Ա
   *.L_Type: ����(��,ɢ)
   *.L_StockNo: ���ϱ��
   *.L_StockName: �������� 
   *.L_Value: �����
   *.L_Price: �������
   *.L_ZKMoney: ռ��ֽ������(Y/N)
   *.L_Truck: ������
   *.L_Status,L_NextStatus:״̬����
   *.L_InTime,L_InMan: ��������
   *.L_PValue,L_PDate,L_PMan: ��Ƥ��
   *.L_MValue,L_MDate,L_MMan: ��ë��
   *.L_LadeTime,L_LadeMan: ����ʱ��,������
   *.L_LadeLine,L_LineName: ����ͨ��
   *.L_DaiTotal,L_DaiNormal,L_DaiBuCha:��װ,����,����
   *.L_OutFact,L_OutMan: ��������
   *.L_Lading: �����ʽ(����,�ͻ�)
   *.L_IsVIP:VIP��
   *.L_Seal: ��ǩ��
   *.L_HYDan: ���鵥
   *.L_Man:������
   *.L_Date:����ʱ��
   *.L_DelMan: ������ɾ����Ա
   *.L_DelDate: ������ɾ��ʱ��
   *.L_NewSendWx: ������΢����Ϣ��ʶ
   *.L_DelSendWx��ɾ����΢����Ϣ��ʶ
   *.L_OutSendWx��������΢����Ϣ��ʶ
   *.L_Memo: ������ע
   *.P_PStation,P_MStation: ��Ƥ/ë���ذ����
   *.L_PID: ������
   ����ɽ����
   *.L_LineNum:�к�
   *.L_LineRecID: �����б���  (AX����)
   *.L_InvLocationId:�ֿ� (AX����)
   *.L_InvCenterId:������ (AX����)
   *.L_PlanQty:�ƻ���������  (AX����)
   *.L_CW:��λ
   *.L_Transporter:��Ӧ���˻�
   *.L_vendpicklistid:���������������
   *. ����   (AX����) --���ֶβ��ڱ��д�������ȡȫ�ֱ���
   *.L_FYAX: �ϴ��������ʶ
   *.L_BDAX: �ϴ�������ʶ
   *.L_FYNUM: �ϴ����������
   *.L_BDNUM���ϴ���������
   *.L_SalesType: �������ͣ�0��������־��
   *.L_FYDEL: �ϴ�ɾ���������ʶ
   *.L_FYDELNUM: �ϴ�ɾ�����������
   *.L_EmptyOut: �ճ��������
   *.L_EOUTAX: �ճ������ϴ����
   *.L_EOUTNUM���ճ������ϴ�����
   *.L_WorkOrder: ���
   *.L_KHSBM: ������
   *.L_OrgXSQYMC: ������������
   *.L_IfHYPrint: �Ƿ��ӡ���鵥
   *.L_IfFenChe: �Ƿ�ֳ����
   *.L_IfNeiDao: �Ƿ��ڵ�
   *.L_TriaTrade: �Ƿ�����ó��
   *.L_ContQuota: �Ƿ�ר��ר�ã�0���� 1���ǣ�
   *.L_ToAddr: ȥ���ͻ��ص㣩
   *.L_IdNumber: ˾�����֤��
   *.L_szbz:ɢװ���أ�0���� 1���ǣ�
   *.l_color:��ɫ������ש�飩
  -----------------------------------------------------------------------------}
  sSQL_NewOrdBaseMain = 'Create Table $Table(R_ID $Inc, M_ID varChar(20),' +
       'M_CID varChar(50), M_BStatus Char(1), ' +
       'M_ProID varChar(32), M_ProName varChar(80), M_ProPY varChar(80),' +
       'M_TriangleTrade Char(1), M_IntComOriSalesId varChar(20), M_PurchType Char(1),' +
       'M_Man varChar(32), M_Date DateTime, ' +
       'M_DelMan varChar(32), M_DelDate DateTime, M_Memo varChar(500),'+
       'DATAAREAID varChar(3),M_DState varChar(10))';
  {-----------------------------------------------------------------------------
   �ɹ����뵥����: OrderBaseMain
   *.R_ID: ���
   *.M_ID: ���뵥��
   *.M_CID: ��ͬ��
   *.M_BStatus: ����״̬
   *.M_ProID,M_ProName,M_ProPY:��Ӧ��
   *.M_TriangleTrade: ����ó��
   *.M_IntComOriSalesId�����۶����ţ��ڲ��ɹ�������ó��ʹ�ã�
   *.M_PurchType: �ɹ�����
   *.M_Man:������
   *.M_Date:����ʱ��
   *.M_DelMan: �ɹ����뵥ɾ����Ա
   *.M_DelDate: �ɹ����뵥ɾ��ʱ��
   *.M_Memo: ������ע
   *.DATAAREAID������
   *.M_DState: ���״̬(30,40��Ч) 0  �ݸ� 10 ������� 20 �Ѿܾ�  30 ����׼ 35 ���ڽ����ⲿ��� 50 ���� 40 ��ȷ��
  -----------------------------------------------------------------------------}

  sSQL_NewOrderBase = 'Create Table $Table(R_ID $Inc, B_ID varChar(20),' +
       'B_Value $Float, B_SentValue $Float,B_RestValue $Float,' +
       'B_LimValue $Float, B_WarnValue $Float,B_FreezeValue $Float,' +
       'B_BStatus Char(1),B_Area varChar(50), B_Project varChar(100),' +
       'B_ProID varChar(32), B_ProName varChar(80), B_ProPY varChar(80),' +
       'B_SaleID varChar(32), B_SaleMan varChar(80), B_SalePY varChar(80),' +
       'B_StockType Char(1), B_StockNo varChar(32), B_StockName varChar(80),' +
       'B_Man varChar(32), B_Date DateTime, DATAAREAID varChar(3),' +
       'B_DelMan varChar(32), B_DelDate DateTime, B_Memo varChar(500),'+
       'B_RecID bigint not null default ((0)), B_Blocked int not null default((0)))';
  {-----------------------------------------------------------------------------
   �ɹ����뵥��: Order
   *.R_ID: ���
   *.B_ID: �ᵥ��
   *.B_Value,B_SentValue,B_RestValue:���������ѷ�����ʣ����
   *.B_LimValue,B_WarnValue,B_FreezeValue:������������;����Ԥ����,����������
   *.B_BStatus: ����״̬
   *.B_Area,B_Project: ����,��Ŀ
   *.B_ProID,B_ProName,B_ProPY:��Ӧ��
   *.B_SaleID,B_SaleMan,B_SalePY:ҵ��Ա
   *.B_StockType: ����(��,ɢ)
   *.B_StockNo: ԭ���ϱ��
   *.B_StockName: ԭ��������
   *.B_Man:������
   *.B_Date:����ʱ��
   *.B_DelMan: �ɹ����뵥ɾ����Ա
   *.B_DelDate: �ɹ����뵥ɾ��ʱ��
   *.B_Memo: ������ע
   *.B_RecID: �б���
   *.B_Blocked: ��ֹͣ
   *.DATAAREAID������
  -----------------------------------------------------------------------------}
  sSQL_NewDeduct = 'Create Table $Table(R_ID $Inc, D_Stock varChar(32),' +
       'D_Name varChar(80), D_CusID varChar(32), D_CusName varChar(80),' +
       'D_Value $Float, D_Type Char(1), D_Valid Char(1))';
  {-----------------------------------------------------------------------------
   ���α����: Batcode
   *.R_ID: ���
   *.D_Stock: ���Ϻ�
   *.D_Name: ������
   *.D_CusID: �ͻ���
   *.D_CusName: �ͻ���
   *.D_Value: ȡֵ
   *.D_Type: ����(F,�̶�ֵ;P,�ٷֱ�)
   *.D_Valid: �Ƿ���Ч(Y/N)
  -----------------------------------------------------------------------------}

  sSQL_NewOrder = 'Create Table $Table(R_ID $Inc, O_ID varChar(20),' +
       'O_BID varChar(20),O_Card varChar(16), O_CType varChar(1),' +
       'O_Value $Float,O_OppositeValue $Float,O_Area varChar(50), O_Project varChar(100),' +
       'O_ProID varChar(32), O_ProName varChar(80), O_ProPY varChar(80),' +
       'O_SaleID varChar(32), O_SaleMan varChar(80), O_SalePY varChar(80),' +
       'O_Type Char(1), O_StockNo varChar(32), O_StockName varChar(80),' +
       'O_Truck varChar(15), O_OStatus Char(1),' +
       'O_Man varChar(32), O_Date DateTime,' +
       'O_DelMan varChar(32), O_DelDate DateTime, O_Memo varChar(500),'+
       'O_BRecID bigint not null default ((0)),O_IfNeiDao Char(1),O_YSTDno varchar(32))';
  {-----------------------------------------------------------------------------
   �ɹ�������: Order
   *.R_ID: ���
   *.O_ID: �ᵥ��
   *.O_BID: �ɹ����뵥�ݺ�
   *.O_Card,O_CType: �ſ���,�ſ�����(L����ʱ��;G���̶���)
   *.O_Value:��������
   *.O_OppositeValue:�Է�������
   *.O_OStatus: ����״̬
   *.O_Area,O_Project: ����,��Ŀ
   *.O_ProID,O_ProName,O_ProPY:��Ӧ��
   *.O_SaleID,O_SaleMan:ҵ��Ա
   *.O_Type: ����(��,ɢ)
   *.O_StockNo: ԭ���ϱ��
   *.O_StockName: ԭ��������
   *.O_Truck: ������
   *.O_Man:������
   *.O_Date:����ʱ��
   *.O_DelMan: �ɹ���ɾ����Ա
   *.O_DelDate: �ɹ���ɾ��ʱ��
   *.O_Memo: ������ע
   *.O_BRecID: �б���
   *.O_IfNeiDao: �ڵ���Y: ��  N: ��
   *.O_YSTDno:����ͨ����
  -----------------------------------------------------------------------------}

  sSQL_NewOrderDtl = 'Create Table $Table(R_ID $Inc, D_ID varChar(20),' +
       'D_OID varChar(20), D_PID varChar(20), D_Card varChar(16), ' +
       'D_Area varChar(50), D_Project varChar(100),D_Truck varChar(15), ' +
       'D_ProID varChar(32), D_ProName varChar(80), D_ProPY varChar(80),' +
       'D_SaleID varChar(32), D_SaleMan varChar(80), D_SalePY varChar(80),' +
       'D_Type Char(1), D_StockNo varChar(32), D_StockName varChar(80),' +
       'D_DStatus Char(1), D_Status Char(1), D_NextStatus Char(1),' +
       'D_InTime DateTime, D_InMan varChar(32),' +
       'D_PValue $Float, D_PDate DateTime, D_PMan varChar(32),' +
       'D_MValue $Float, D_MDate DateTime, D_MMan varChar(32),' +
       'D_YTime DateTime, D_YMan varChar(32), ' +
       'D_Value $Float,D_KZValue $Float, D_AKValue $Float,' +
       'D_YLine varChar(15), D_YLineName varChar(32), ' +
       'D_DelMan varChar(32), D_DelDate DateTime, D_YSResult Char(1), ' +
       'D_OutFact DateTime, D_OutMan varChar(32), D_Memo varChar(500),'+
       'D_BDAX Char(1) not null default((0)),D_BDNUM int not null default((0))),'+
       'D_RecID bigint not null default ((0)))';
  {-----------------------------------------------------------------------------
   �ɹ�������ϸ��: OrderDetail
   *.R_ID: ���
   *.D_ID: �ɹ���ϸ��
   *.D_OID: �ɹ�����
   *.D_PID: ������
   *.D_Card: �ɹ��ſ���
   *.D_DStatus: ����״̬
   *.D_Area,D_Project: ����,��Ŀ
   *.D_ProID,D_ProName,D_ProPY:��Ӧ��
   *.D_SaleID,D_SaleMan:ҵ��Ա
   *.D_Type: ����(��,ɢ)
   *.D_StockNo: ԭ���ϱ��
   *.D_StockName: ԭ��������
   *.D_Truck: ������
   *.D_Status,D_NextStatus: ״̬
   *.D_InTime,D_InMan: ��������
   *.D_PValue,D_PDate,D_PMan: ��Ƥ��
   *.D_MValue,D_MDate,D_MMan: ��ë��
   *.D_YTime,D_YMan: �ջ�ʱ��,������,
   *.D_Value,D_KZValue,D_AKValue: �ջ���,���տ۳�(����),����
   *.D_YLine,D_YLineName: �ջ�ͨ��
   *.D_YSResult: ���ս��
   *.D_OutFact,D_OutMan: ��������
   *.D_BDAX: �Ƿ��ϴ�
   *.D_BDNUM: �ϴ�����
   *.D_RecID: �����б���
  -----------------------------------------------------------------------------}

  sSQL_NewCard = 'Create Table $Table(R_ID $Inc, C_Card varChar(16),' +
       'C_Card2 varChar(32), C_Card3 varChar(32),' +
       'C_Owner varChar(15), C_TruckNo varChar(15), C_Status Char(1),' +
       'C_Freeze Char(1), C_Used Char(1), C_UseTime Integer Default 0,' +
       'C_Man varChar(32), C_Date DateTime, C_Memo varChar(500))';
  {-----------------------------------------------------------------------------
   �ſ���:Card
   *.R_ID:��¼���
   *.C_Card:������
   *.C_Card2,C_Card3:������
   *.C_Owner:�����˱�ʶ
   *.C_TruckNo:�������
   *.C_Used:��;(��Ӧ,����,��ʱ)
   *.C_UseTime:ʹ�ô���
   *.C_Status:״̬(����,ʹ��,ע��,��ʧ)
   *.C_Freeze:�Ƿ񶳽�
   *.C_Man:������
   *.C_Date:����ʱ��
   *.C_Memo:��ע��Ϣ
  -----------------------------------------------------------------------------}

  sSQL_NewCardOther = 'Create Table $Table(R_ID $Inc, O_Card varChar(16),' +
       'O_Truck varChar(15), O_CusID varChar(32), O_CusName varChar(80),' +
       'O_MID varChar(32), O_MName varChar(80), ' +
       'O_MType varChar(10), O_LimVal $Float, ' +
       'O_Status Char(1), O_NextStatus Char(1),' +
       'O_InTime DateTime, O_InMan varChar(32),' +
       'O_OutTime DateTime, O_OutMan varChar(32),' +
       'O_BFPTime DateTime, O_BFPMan varChar(32), O_BFPValue $Float Default 0,' +
       'O_BFMTime DateTime, O_BFMMan varChar(32), O_BFMValue $Float Default 0,' +
       'O_KeepCard varChar(1), O_Man varChar(32), O_Date DateTime,' +
       'O_UsePValue Char(1) Default ''N'', O_OneDoor Char(1) Default ''N'', ' +
       'O_ManDel varChar(32), O_DateDel DateTime,O_YSTDno varchar(32))';
  {-----------------------------------------------------------------------------
   ��ʱ�ſ�:CardOther
   *.R_ID:��¼���
   *.O_Card:����
   *.O_Truck: ����
   *.O_CusID,O_CusName:��Ӧ��
   *.O_MID,O_MName:����
   *.O_MType:��,ɢ��
   *.O_LimVal:Ʊ��
   *.O_Status,O_NextStatus: �г�״̬
   *.O_InTime,O_InMan:����ʱ��,������
   *.O_OutTime,O_OutMan:����ʱ��,������
   *.O_BFPTime,O_BFPMan,T_BFPValue:Ƥ��ʱ��,������,Ƥ��
   *.O_BFMTime,O_BFMMan,T_BFMValue:ë��ʱ��,������,ë��
   *.O_KeepCard: ˾����(Y/N),����ʱ������
   *.O_Man,O_Date:�ƿ���
   *.O_UsePValue: �Կճ�ΪƤ��
   *.O_OneDoor: �������
   *.O_ManDel,O_DateDel: ɾ����
   *.O_YSTDno: ����ͨ�����
  -----------------------------------------------------------------------------}  

    sSQL_NewTruck = 'Create Table $Table(R_ID $Inc, T_Truck varChar(15), ' +
       'T_PY varChar(15), T_Owner varChar(32), T_Phone varChar(15), T_Used Char(1), ' +
       'T_OwnerIDCard varChar(64), T_SerialNO varChar(64),' +
       'T_PrePValue $Float, T_PrePMan varChar(32), T_PrePTime DateTime, ' +
       'T_PrePUse Char(1), T_MinPVal $Float, T_MaxPVal $Float, ' +
       'T_PValue $Float Default 0, T_PTime Integer Default 0,' +
       'T_PlateColor varChar(12),T_Type varChar(12), T_LastTime DateTime, ' +
       'T_Card varChar(32),T_Card2 varChar(32), T_CardUse Char(1), T_NoVerify Char(1),' +
       'T_Valid Char(1), T_VIPTruck Char(1), T_HasGPS Char(1), T_DDCard varChar(32),'+
       'T_CompanyID varChar(10),T_XTECB varChar(10),T_VendAccount varChar(20),'+
       'T_Driver varChar(10), T_SaleID varChar(20), T_RecID bigint not null default ((0)),'+
       'T_MatePID varChar(15), T_MateID varChar(15), T_MateName varChar(80),' +
       'T_SrcAddr varChar(150), T_DestAddr varChar(150)' +
       ')';
  {-----------------------------------------------------------------------------
   ������Ϣ:Truck
   *.R_ID: ��¼��
   *.T_Truck: ���ƺ�
   *.T_PY: ����ƴ��
   *.T_Owner: ����
   *.T_Phone: ��ϵ��ʽ
   *.T_OwnerIDCard: �������֤��
   *.T_SerialNO: �г�֤��
   *.T_Used: ��;(��Ӧ,����)
   *.T_PrePValue: Ԥ��Ƥ��
   *.T_PrePMan: Ԥ��˾��
   *.T_PrePTime: Ԥ��ʱ��
   *.T_PrePUse: ʹ��Ԥ��
   *.T_MinPVal: ��ʷ��СƤ��
   *.T_MaxPVal: ��ʷ���Ƥ��
   *.T_PValue: ��ЧƤ��
   *.T_PTime: ��Ƥ����
   *.T_PlateColor: ������ɫ
   *.T_Type: ����
   *.T_LastTime: �ϴλ
   *.T_Card: ���ӱ�ǩ1
   *.T_Card2: ���ӱ�ǩ2
   *.T_CardUse: ʹ�õ���ǩ(Y/N)
   *.T_NoVerify: ��У��ʱ��
   *.T_Valid: �Ƿ���Ч
   *.T_VIPTruck:�Ƿ�VIP
   *.T_HasGPS:��װGPS(Y/N)
   *.T_CompanyID:��˾�ʻ�ID
   *.T_XTECB:�������У��⳵��
   *.T_VendAccount:��Ӧ���˻�����дĬ�ϳ����̣�
   *.T_Driver:˾��

   ��Чƽ��Ƥ���㷨:
   T_PValue = (T_PValue * T_PTime + ��Ƥ��) / (T_PTime + 1)
   //---------------------------�̵�ҵ��������Ϣ--------------------------------
   *.T_MatePID:�ϸ����ϱ��
   *.T_MateID:���ϱ��
   *.T_MateName: ��������
   *.T_SrcAddr:������ַ
   *.T_DestAddr:�����ַ
   *.T_SaleID:������
   *.T_RecID�������б���
   *.T_DDCard:�̵��ſ�
   ---------------------------------------------------------------------------//
  -----------------------------------------------------------------------------}

  sSQL_NewPoundLog = 'Create Table $Table(R_ID $Inc, P_ID varChar(15),' +
       'P_Type varChar(1), P_Order varChar(20), P_Card varChar(16),' +
       'P_Bill varChar(20), P_Truck varChar(15), P_CusID varChar(32),' +
       'P_CusName varChar(80), P_MID varChar(32),P_MName varChar(80),' +
       'P_MType varChar(10), P_LimValue $Float,' +
       'P_PValue $Float, P_PDate DateTime, P_PMan varChar(32), ' +
       'P_MValue $Float, P_MDate DateTime, P_MMan varChar(32), ' +
       'P_FactID varChar(32), P_PStation varChar(10), P_MStation varChar(10),' +
       'P_Direction varChar(10), P_PModel varChar(10), P_Status Char(1),' +
       'P_Valid Char(1), P_PrintNum Integer Default 1,' +
       'P_DelMan varChar(32), P_DelDate DateTime, P_KZValue $Float,'+
       'P_HisTruck varchar(15), P_HisPValue decimal(15,5),'+
       'P_KWDate datetime)';
  {-----------------------------------------------------------------------------
   ������¼: Materails
   *.P_ID: ���
   *.P_Type: ����(����,��Ӧ,��ʱ)
   *.P_Order: ������(��Ӧ)
   *.P_Bill: ������
   *.P_Truck: ����
   *.P_CusID: �ͻ���
   *.P_CusName: ������
   *.P_MID: ���Ϻ�
   *.P_MName: ������
   *.P_MType: ��,ɢ��
   *.P_LimValue: Ʊ��
   *.P_PValue,P_PDate,P_PMan: Ƥ��
   *.P_MValue,P_MDate,P_MMan: ë��
   *.P_FactID: �������
   *.P_PStation,P_MStation: ���ذ�վ
   *.P_Direction: ��������(��,��)
   *.P_PModel: ����ģʽ(��׼,��Ե�)
   *.P_Status: ��¼״̬
   *.P_Valid: �Ƿ���Ч
   *.P_PrintNum: ��ӡ����
   *.P_DelMan,P_DelDate: ɾ����¼
   *.P_KZValue: ��Ӧ����
   *.P_HisTruck: ���󳵺�
   *.P_HisPValue: ����Ƥ��
   *.P_KWDate: ��������

  -----------------------------------------------------------------------------}

  sSQL_NewPicture = 'Create Table $Table(R_ID $Inc, P_ID varChar(15),' +
       'P_Name varChar(32), P_Mate varChar(80), P_Date DateTime, P_Picture Image)';
  {-----------------------------------------------------------------------------
   ͼƬ: Picture
   *.P_ID: ���
   *.P_Name: ����
   *.P_Mate: ����
   *.P_Date: ʱ��
   *.P_Picture: ͼƬ
  -----------------------------------------------------------------------------}

  sSQL_NewZTLines = 'Create Table $Table(R_ID $Inc, Z_ID varChar(15),' +
       'Z_Name varChar(32), Z_StockNo varChar(20), Z_Stock varChar(80),' +
       'Z_StockType Char(1), Z_PeerWeight Integer,' +
       'Z_QueueMax Integer, Z_VIPLine Char(1), Z_Valid Char(1), Z_Index Integer,'+
       'Z_CenterID Varchar(20),Z_LocationID Varchar(20))';
  {-----------------------------------------------------------------------------
   װ��������: ZTLines
   *.R_ID: ��¼��
   *.Z_ID: ���
   *.Z_Name: ����
   *.Z_StockNo: Ʒ�ֱ��
   *.Z_Stock: Ʒ��
   *.Z_StockType: ����(��,ɢ)
   *.Z_PeerWeight: ����
   *.Z_QueueMax: ���д�С
   *.Z_VIPLine: VIPͨ��
   *.Z_Valid: �Ƿ���Ч
   *.Z_Index: ˳������
   *.Z_CenterID: ������
   *.Z_LocationID: �ֿ�
  -----------------------------------------------------------------------------}

  sSQL_NewZTTrucks = 'Create Table $Table(R_ID $Inc, T_Truck varChar(15),' +
       'T_StockNo varChar(20), T_Stock varChar(80), T_Type Char(1),' +
       'T_Line varChar(15), T_Index Integer, ' +
       'T_InTime DateTime, T_InFact DateTime, T_InQueue DateTime,' +
       'T_InLade DateTime, T_VIP Char(1), T_Valid Char(1), T_Bill varChar(15),' +
       'T_Value $Float, T_PeerWeight Integer, T_Total Integer Default 0,' +
       'T_Normal Integer Default 0, T_BuCha Integer Default 0,' +
       'T_PDate DateTime, T_IsPound Char(1),T_HKBills varChar(200))';
  {-----------------------------------------------------------------------------
   ��װ������: ZTTrucks
   *.R_ID: ��¼��
   *.T_Truck: ���ƺ�
   *.T_StockNo: Ʒ�ֱ��
   *.T_Stock: Ʒ������
   *.T_Type: Ʒ������(D,S)
   *.T_Line: ���ڵ�
   *.T_Index: ˳������
   *.T_InTime: ���ʱ��
   *.T_InFact: ����ʱ��
   *.T_InQueue: ����ʱ��
   *.T_InLade: ���ʱ��
   *.T_VIP: ��Ȩ
   *.T_Bill: �ᵥ��
   *.T_Valid: �Ƿ���Ч
   *.T_Value: �����
   *.T_PeerWeight: ����
   *.T_Total: ��װ����
   *.T_Normal: ��������
   *.T_BuCha: �������
   *.T_PDate: ����ʱ��
   *.T_IsPound: �����(Y/N)
   *.T_HKBills: �Ͽ��������б�
  -----------------------------------------------------------------------------}

  sSQL_NewYSLines = 'Create Table $Table(R_ID $Inc, Y_ID varChar(15),' +
       'Y_Name varChar(32), Y_StockNo varChar(1024), Y_Stock varChar(1024),' +
       'Y_StockType Char(1), Y_PeerWeight Integer,' +
       'Y_QueueMax Integer, Y_VIPLine Char(1), Y_Valid Char(1), Y_Index Integer,YS_Valid char(1))';
  {-----------------------------------------------------------------------------
   ����ͨ������: YSLines
   *.R_ID: ��¼��
   *.Y_ID: ���
   *.Y_Name: ����
   *.Y_StockNo: Ʒ�ֱ��
   *.Y_Stock: Ʒ��
   *.Y_StockType: ����(��,ɢ)
   *.Y_PeerWeight: ����
   *.Y_QueueMax: ���д�С
   *.Y_VIPLine: VIPͨ��
   *.Y_Valid: �Ƿ���Ч
   *.Y_Index: ˳������
   *.YS_Valid:�����Ƿ���Ч
  -----------------------------------------------------------------------------}

  sSQL_NewDataTemp = 'Create Table $Table(T_SysID varChar(15))';
  {-----------------------------------------------------------------------------
   ��ʱ���ݱ�: DataTemp
   *.T_SysID: ϵͳ���
  -----------------------------------------------------------------------------}
  
  sSQL_NewInvoiceWeek = 'Create Table $Table(W_ID $Inc, W_NO varChar(15),' +
       'W_Name varChar(50), W_Begin DateTime, W_End DateTime,' +
       'W_Man varChar(32), W_Date DateTime, W_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ��Ʊ��������:InvoiceWeek
   *.W_ID:��¼���
   *.W_NO:���ڱ��
   *.W_Name:����
   *.W_Begin:��ʼ
   *.W_End:����
   *.W_Man:������
   *.W_Date:����ʱ��
   *.W_Memo:��ע��Ϣ
  -----------------------------------------------------------------------------}
  
  sSQL_NewInvoice = 'Create Table $Table(I_ID varChar(25) PRIMARY KEY,' +
       'I_Week varChar(15), I_CusID varChar(15), I_Customer varChar(80),' +
       'I_SaleID varChar(15), I_SaleMan varChar(50), I_Status Char(1),' +
       'I_Flag Char(1), I_InMan varChar(32), I_InDate DateTime,' +
       'I_OutMan varChar(32), I_OutDate DateTime, I_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ��ƱƱ��:Invoice
   *.I_ID:���
   *.I_Week:��������
   *.I_CusID:�ͻ����
   *.I_Customer:�ͻ���
   *.I_SaleID:ҵ��Ա��
   *.I_SaleMan:ҵ��Ա
   *.I_Status:״̬
   *.I_Flag:���
   *.I_InMan:¼����
   *.I_InDate:¼������
   *.I_OutMan:������
   *.I_OutDate:��������
   *.I_Memo:��ע
  -----------------------------------------------------------------------------}

  sSQL_NewInvoiceDtl = 'Create Table $Table(D_ID $Inc, D_Invoice varChar(25),' +
       'D_Type Char(1), D_Stock varChar(30), D_Price $Float Default 0,' +
       'D_Value $Float Default 0, D_KPrice $Float Default 0,' +
       'D_DisCount $Float Default 0, D_DisMoney $Float Default 0)';
  {-----------------------------------------------------------------------------
   ��Ʊ��ϸ:InvoiceDetail
   *.D_ID:���
   *.D_Invoice:Ʊ��
   *.D_Type:����(��,ɢ)
   *.D_Stock:Ʒ��
   *.D_Price:����
   *.D_Value:��Ʊ��
   *.D_KPrice:��Ʊ��
   *.D_DisCount:�ۿ۱�
   *.D_DisMoney:�ۿ�Ǯ��
  -----------------------------------------------------------------------------}

  sSQL_NewInvoiceReq = 'Create Table $Table(R_ID $Inc, R_Week varChar(15),' +
       'R_CusID varChar(15), R_Customer varChar(80),' +
       'R_SaleID varChar(15), R_SaleMan varChar(50), R_Type Char(1),' +
       'R_Stock varChar(30), R_Price $Float, R_Value $Float, ' +
       'R_PreHasK $Float Default 0, R_ReqValue $Float, R_KPrice $Float,' +
       'R_KValue $Float Default 0, R_KOther $Float Default 0,' +
       'R_Man varChar(32), R_Date DateTime)';
  {-----------------------------------------------------------------------------
   ��Ʊ��������:InvoiceReq
   *.R_ID:��¼���
   *.R_Week:��������
   *.R_CusID:�ͻ���
   *.R_Customer:�ͻ���
   *.R_SaleID:ҵ��Ա��
   *.R_SaleMan:ҵ��Ա��
   *.R_Type:ˮ������(D,S)
   *.R_Stock:ˮ������
   *.R_Price:����
   *.R_Value:�����
   *.R_PreHasK:֮ǰ�ѿ���
   *.R_ReqValue:������
   *.R_KPrice:��Ʊ����
   *.R_KValue:�����������
   *.R_KOther:����������֮���ѿ�
   *.R_Man:������
   *.R_Date:����ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewWXLog = 'Create Table $Table(R_ID $Inc, L_UserID varChar(50), ' +
       'L_Data varChar(2000), L_MsgID varChar(20), L_Result varChar(150),' +
       'L_Count Integer Default 0, L_Status Char(1), ' +
       'L_Comment varChar(100), L_Date DateTime)';
  {-----------------------------------------------------------------------------
   ΢�ŷ�����־:WeixinLog
   *.R_ID:��¼���
   *.L_UserID: ������ID
   *.L_Data:΢������
   *.L_Count:���ʹ���
   *.L_MsgID: ΢�ŷ��ر�ʶ
   *.L_Result:���ͷ�����Ϣ
   *.L_Status:����״̬(N������,I������,Y�ѷ���)
   *.L_Comment:��ע
   *.L_Date: ����ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewWXMatch = 'Create Table $Table(R_ID $Inc, M_ID varChar(15), ' +
       'M_WXID varChar(50), M_WXName varChar(64), M_WXFactory varChar(15), ' +
       'M_IsValid Char(1), M_Comment varChar(100), ' +
       'M_AttentionID varChar(32), M_AttentionType Char(1))';
  {-----------------------------------------------------------------------------
   ΢���˻�:WeixinMatch
   *.R_ID:��¼���
   *.M_ID: ΢�ű��
   *.M_WXID:����ID
   *.M_WXName:΢����
   *.M_WXFactory:΢��ע�Ṥ������
   *.M_IsValid: �Ƿ���Ч
   *.M_Comment: ��ע             
   *.M_AttentionID,M_AttentionType: ΢�Ź�ע�ͻ�ID,����(S��ҵ��Ա;C���ͻ�;G������Ա)
  -----------------------------------------------------------------------------}

  sSQL_NewWXTemplate = 'Create Table $Table(R_ID $Inc, W_Type varChar(15), ' +
       'W_TID varChar(50), W_TFields varChar(64), ' +
       'W_TComment Char(300), W_IsValid Char(1))';
  {-----------------------------------------------------------------------------
   ΢���˻�:WeixinMatch
   *.R_ID:��¼���
   *.W_Type:����
   *.W_TID:��ʶ
   *.W_TFields:�������
   *.W_IsValid: �Ƿ���Ч
   *.W_TComment: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewWeixinCusBind = 'Create Table $Table(R_ID $Inc, w_CID varchar(15),'
        +'w_CusName varchar(500),wcb_Phone varchar(11),'
        +'wcb_Appid varchar(20),wcb_Bindcustomerid varchar(32),wcb_Namepinyin varchar(20),'
        +'wcb_Email varchar(20),wcb_Openid varchar(28),wcb_Binddate varchar(25),'
        +'wcb_WebMallStatus char(1))';
  {-----------------------------------------------------------------------------
  sys_WeixinCusBind΢�ſͻ���
  *.R_ID:��¼��
  *.w_CID:�ͻ���
  *.w_CusName:�ͻ�����
  *.wcb_Phone:�绰����
  *.wcb_Appid:appid
  *.wcb_Bindcustomerid:�󶨿ͻ�id
  *.wcb_Namepinyin:����
  *.wcb_Email:����
  *.wcb_Openid:openid
  *.wcb_Binddate:������
  *.wcb_WebMallStatus:�Ƿ�ͨ�̳��û���Ĭ��ֵ0��δ��ͨ 1���ѿ�ͨ
  -----------------------------------------------------------------------------}

  sSQL_NewWeixinProBind = 'Create Table $Table(R_ID $Inc, w_PID varchar(15),'
        +'w_PName varchar(500),wcb_Phone varchar(11),'
        +'wcb_Appid varchar(20),wcb_Bindcustomerid varchar(32),wcb_Namepinyin varchar(20),'
        +'wcb_Email varchar(20),wcb_Openid varchar(28),wcb_Binddate varchar(25),'
        +'wcb_WebMallStatus char(1))';
  {-----------------------------------------------------------------------------
  sys_WeixinCusBind΢�ſͻ���
  *.R_ID:��¼��
  *.w_PID:��Ӧ�̱��
  *.w_PName:��Ӧ������
  *.wcb_Phone:�绰����
  *.wcb_Appid:appid
  *.wcb_Bindcustomerid:�󶨹�Ӧ��id
  *.wcb_Namepinyin:����
  *.wcb_Email:����
  *.wcb_Openid:openid
  *.wcb_Binddate:������
  *.wcb_WebMallStatus:�Ƿ�ͨ�̳��û���Ĭ��ֵ0��δ��ͨ 1���ѿ�ͨ
  -----------------------------------------------------------------------------}

  sSQL_NewProvider = 'Create Table $Table(R_ID $Inc, P_ID varChar(32),' +
       'P_Name varChar(80),P_PY varChar(80), P_Phone varChar(20),' +
       'P_Saler varChar(32),P_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ��Ӧ��: Provider
   *.P_ID: ���
   *.P_Name: ����
   *.P_PY: ƴ����д
   *.P_Phone: ��ϵ��ʽ
   *.P_Saler: ҵ��Ա
   *.P_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewMaterails = 'Create Table $Table(R_ID $Inc, M_ID varChar(32),' +
       'M_Name varChar(80),M_PY varChar(80),M_Unit varChar(20),M_Price $Float,' +
       'M_PrePValue Char(1), M_PrePTime Integer, M_Memo varChar(50),'+
       'M_GroupID varChar(20), M_CenterID varChar(20),M_Weighning char(1))';
  {-----------------------------------------------------------------------------
   ���ϱ�: Materails
   *.M_ID: ���
   *.M_Name: ����
   *.M_PY: ƴ����д
   *.M_Unit: ��λ
   *.M_PrePValue: Ԥ��Ƥ��
   *.M_PrePTime: Ƥ��ʱ��(��)
   *.M_Memo: ��ע
   *.M_GroupID: ��������
   *.M_CenterID: �����߱��
   *.M_Weighning: �Ƿ����
  -----------------------------------------------------------------------------}

  sSQL_NewStockParam = 'Create Table $Table(P_ID varChar(15), P_Stock varChar(30),' +
       'P_Type Char(1), P_Name varChar(50), P_QLevel varChar(20), P_Memo varChar(50),P_standard varchar(50),' +
       'P_MgO varChar(20), P_SO3 varChar(20), P_ShaoShi varChar(20),' +
       'P_CL varChar(20), P_BiBiao varChar(20), P_ChuNing varChar(20),' +
       'P_ZhongNing varChar(20), P_AnDing varChar(20), P_XiDu varChar(20),' +
       'P_Jian varChar(20), P_ChouDu varChar(20), P_BuRong varChar(20),' +
       'P_YLiGai varChar(20), P_Water varChar(20), P_KuangWu varChar(20),' +
       'P_GaiGui varChar(20), P_3DZhe varChar(20), P_28Zhe varChar(20),' +
       'P_3DYa varChar(20), P_28Ya varChar(20))';
  {-----------------------------------------------------------------------------
   Ʒ�ֲ���:StockParam
   *.P_ID:��¼���
   *.P_Stock:Ʒ��
   *.P_Type:����(��,ɢ)
   *.P_Name:�ȼ���
   *.P_QLevel:ǿ�ȵȼ�
   *.P_Memo:��ע
   *.P_standard:ִ�б�׼
   *.P_MgO:����þ
   *.P_SO3:��������
   *.P_ShaoShi:��ʧ��
   *.P_CL:������
   *.P_BiBiao:�ȱ����
   *.P_ChuNing:����ʱ��
   *.P_ZhongNing:����ʱ��
   *.P_AnDing:������
   *.P_XiDu:ϸ��
   *.P_Jian:���
   *.P_ChouDu:���
   *.P_BuRong:������
   *.P_YLiGai:�����
   *.P_Water:��ˮ��
   *.P_KuangWu:�����ο���
   *.P_GaiGui:�ƹ��
   *.P_3DZhe:3�쿹��ǿ��
   *.P_28DZhe:28����ǿ��
   *.P_3DYa:3�쿹ѹǿ��
   *.P_28DYa:28��ѹǿ��
  -----------------------------------------------------------------------------}

  sSQL_NewStockRecord = 'Create Table $Table(R_ID $Inc, R_SerialNo varChar(15),' +
       'R_PID varChar(15),' +
       'R_SGType varChar(20), R_SGValue varChar(20),' +
       'R_HHCType varChar(20), R_HHCValue varChar(20),' +
       'R_MgO varChar(20), R_SO3 varChar(20), R_ShaoShi varChar(20),' +
       'R_CL varChar(20), R_BiBiao varChar(20), R_ChuNing varChar(20),' +
       'R_ZhongNing varChar(20), R_AnDing varChar(20), R_XiDu varChar(20),' +
       'R_Jian varChar(20), R_ChouDu varChar(20), R_BuRong varChar(20),' +
       'R_YLiGai varChar(20), R_Water varChar(20), R_KuangWu varChar(20),' +
       'R_GaiGui varChar(20),' +
       'R_3DZhe1 varChar(20), R_3DZhe2 varChar(20), R_3DZhe3 varChar(20),' +
       'R_28Zhe1 varChar(20), R_28Zhe2 varChar(20), R_28Zhe3 varChar(20),' +
       'R_3DYa1 varChar(20), R_3DYa2 varChar(20), R_3DYa3 varChar(20),' +
       'R_3DYa4 varChar(20), R_3DYa5 varChar(20), R_3DYa6 varChar(20),' +
       'R_28Ya1 varChar(20), R_28Ya2 varChar(20), R_28Ya3 varChar(20),' +
       'R_28Ya4 varChar(20), R_28Ya5 varChar(20), R_28Ya6 varChar(20),' +
       'R_Date DateTime, R_Man varChar(32),'+
       'R_BatQuaStart int not null default 0,'+
       'R_BatQuaEnd int not null default 0,'+
       'R_TotalValue $Float Default 0,'+
       'R_BatValid char(1) not null default(''Y''),'+
       'R_ZMJNAME varChar(20), R_ZMJVALUE varChar(20),'+
       'R_C3S varChar(20), R_C3A varChar(20),'+
       'R_SHR3D varChar(20), R_SHR7D varChar(20),'+
       'R_C2S varChar(20),R_CenterID varChar(20))';
  {-----------------------------------------------------------------------------
   �����¼:StockRecord
   *.R_ID:��¼���
   *.R_SerialNo:ˮ����
   *.R_PID:Ʒ�ֲ���
   *.R_SGType: ʯ������
   *.R_SGValue: ʯ�������
   *.R_HHCType: ��ϲ�����
   *.R_HHCValue: ��ϲĲ�����
   *.R_MgO:����þ
   *.R_SO3:��������
   *.R_ShaoShi:��ʧ��
   *.R_CL:������
   *.R_BiBiao:�ȱ����
   *.R_ChuNing:����ʱ��
   *.R_ZhongNing:����ʱ��
   *.R_AnDing:������
   *.R_XiDu:ϸ��
   *.R_Jian:���
   *.R_ChouDu:���
   *.R_BuRong:������
   *.R_YLiGai:�����
   *.R_Water:��ˮ��
   *.R_KuangWu:�����ο���
   *.R_GaiGui:�ƹ��
   *.R_3DZhe1:3�쿹��ǿ��1
   *.R_3DZhe2:3�쿹��ǿ��2
   *.R_3DZhe3:3�쿹��ǿ��3
   *.R_28Zhe1:28����ǿ��1
   *.R_28Zhe2:28����ǿ��2
   *.R_28Zhe3:28����ǿ��3
   *.R_3DYa1:3�쿹ѹǿ��1
   *.R_3DYa2:3�쿹ѹǿ��2
   *.R_3DYa3:3�쿹ѹǿ��3
   *.R_3DYa4:3�쿹ѹǿ��4
   *.R_3DYa5:3�쿹ѹǿ��5
   *.R_3DYa6:3�쿹ѹǿ��6
   *.R_28Ya1:28��ѹǿ��1
   *.R_28Ya2:28��ѹǿ��2
   *.R_28Ya3:28��ѹǿ��3
   *.R_28Ya4:28��ѹǿ��4
   *.R_28Ya5:28��ѹǿ��5
   *.R_28Ya6:28��ѹǿ��6
   *.R_Date:ȡ������
   *.R_Man:¼����
   *.R_ZMJNAME: ��ĥ������
   *.R_ZMJVALUE: ��ĥ����
   *.R_C3S: ����C3S
   *.R_C3A: ����C3A
   *.R_SHR3D: ˮ����3D
   *.R_SHR7D��ˮ����7D
   *.R_C2S: ����C2S
   *.R_CenterID: ������ID
   *.R_BatQuaStart: ������
   *.R_BatQuaEnd: Ԥ����
   *.R_TotalValue: �ѷ���
  -----------------------------------------------------------------------------}

  sSQL_NewStockRecord_Slag = 'Create Table $Table(R_ID $Inc,'
  		+'R_SerialNo varChar(15),'
  		+'R_PID varChar(20),'
  		+'R_Stockname varChar(80),'
  		+'R_QualityGrade varChar(20),'
  		+'R_BatQuaStart int not null default 0,'
  		+'R_Date DateTime,R_Density varChar(20),'
  		+'R_BiBiao varChar(20),'
  		+'R_ActivityIndex_7d varChar(20),'
  		+'R_ActivityIndex_28d varChar(20),'
  		+'R_FluidityRatio varChar(20),'
  		+'R_WaterContent varChar(20),'
  		+'R_SO3 varChar(20),R_CL varChar(20),'
  		+'R_ShaoShi varChar(20),'
  		+'R_SGType varChar(20),'
  		+'R_SGValue varChar(20),'
  		+'R_ZMJNAME varChar(20),'
  		+'R_ZMJVALUE varChar(20),'
  		+'R_Remark varChar(200),'
  		+'R_Man varChar(32),'
  		+'R_CenterID varChar(20),'
  		+'R_BatQuaEnd int not null default 0,'
  		+'R_TotalValue $Float Default 0,'
  		+'R_BatValid char(1) not null default(''Y''))';
  {-----------------------------------------------------------------------------
   �����ۼ����¼:StockRecord_Slag
   *.R_ID:��¼���
	 *.R_SerialNo:�������
	 *.R_PID:��Ʒ���
	 *.R_Stockname:��Ʒ����
	 *.R_QualityGrade:�����ȼ�
	 *.R_BatQuaStart:������
	 *.R_Date:¼������
	 *.R_Density:�ܶ�
	 *.R_BiBiao:�ȱ����
	 *.R_ActivityIndex_7d:����ָ��7D
	 *.R_ActivityIndex_28d:����ָ��28D
	 *.R_FluidityRatio:�����ȱ�
	 *.R_WaterContent:��ˮ��
	 *.R_SO3:��������
	 *.R_CL:������
	 *.R_ShaoShi:��ʧ��
	 *.R_SGType:ʯ������
	 *.R_SGValue:ʯ�������
	 *.R_ZMJNAME:��ĥ������
	 *.R_ZMJVALUE:��ĥ����
	 *.R_Remark:��ע
	 *.R_Man:¼����
	 *.R_CenterID:������ID
	 *.R_BatQuaEnd:Ԥ����
	 *.R_TotalValue:�ѷ���
	 *.R_BatValid:״̬
  -----------------------------------------------------------------------------}

  sSQL_NewStockRecord_Concrete = 'Create Table $Table(R_ID $Inc,'
  		+'R_SerialNo varChar(15),'
  		+'R_PID varChar(20),'
  		+'R_Stockname varChar(80),'
  		+'R_Date DateTime,'
  		+'R_StrengthGrade varChar(20),'
  		+'R_Specifications varChar(50),'
  		+'R_BatQuaStart int not null default 0,'
  		+'R_AppearanceQuality varChar(20),'
  		+'R_DimensionalDeviation varChar(20),'
  		+'R_WaterAbsorption varChar(20),'
  		+'R_AvgCompressiveStrength varChar(20),'
  		+'R_MinCompressiveStrength varChar(20),'
  		+'R_Conclusion varChar(200),'
  		+'R_Remark varChar(200),'
  		+'R_Man varChar(32),'
  		+'R_CenterID varChar(20),'
  		+'R_BatQuaEnd int not null default 0,'
  		+'R_TotalValue $Float Default 0,'
  		+'R_BatValid char(1) not null default(''Y''))';
  {-----------------------------------------------------------------------------
   ��������Ʒ�����¼:StockRecord_Concrete
   *.R_ID:��¼���
	 *.R_SerialNo:�������
	 *.R_PID:��Ʒ���
	 *.R_Stockname:��Ʒ����
	 *.R_Date:¼������
	 *.R_StrengthGrade:ǿ�ȵȼ�	
	 *.R_Specifications:����ͺ�
	 *.R_BatQuaStart:����
	 *.R_AppearanceQuality:�������	
	 *.R_DimensionalDeviation:�ߴ�ƫ��	
	 *.R_WaterAbsorption:��ˮ��(%)	
	 *.R_AvgCompressiveStrength:��ѹǿ��(Mpa)ƽ��ֵ
	 *.R_MinCompressiveStrength:��ѹǿ��(Mpa)������Сֵ
	 *.R_Conclusion:�����ۼ����
	 *.R_Remark:��ע
	 *.R_Man:¼����
	 *.R_CenterID:������ID
	 *.R_BatQuaEnd:Ԥ����
	 *.R_TotalValue:�ѷ���
	 *.R_BatValid:״̬
  -----------------------------------------------------------------------------}

  sSQL_NewStockRecord_clinker = 'Create Table $Table(R_ID $Inc,'
  		+'R_SerialNo varChar(15),'
  		+'R_PID varChar(20),'
  		+'R_Stockname varChar(80),'
  		+'R_Clinkertype varChar(20),'
  		+'R_Fcao varChar(20),'
  		+'R_Mgo varChar(20),'
  		+'R_ShaoShi varChar(20),'
  		+'R_BuRong varChar(20),'
  		+'R_So3 varChar(20),'
  		+'R_Alkalinity varChar(20),'
  		+'R_C3S_C2S varChar(20),'
  		+'R_3DYa1 varChar(20),'
  		+'R_28Ya1 varChar(20),'
  		+'R_3DChuNing varChar(20),'
  		+'R_28DZhongNing varChar(20),'
  		+'R_AnDing varChar(20),'
  		+'R_Date DateTime,'
  		+'R_Man varChar(32),'
  		+'R_CenterID varChar(20),'
  		+'R_BatQuaStart int not null default 0,'
  		+'R_BatQuaEnd int not null default 0,'
  		+'R_TotalValue $Float Default 0,'
  		+'R_BatValid char(1) not null default(''Y''))';
  {-----------------------------------------------------------------------------
   ͨ�����ϼ����¼:StockRecord_clinker
   *.R_ID:��¼���
	 *.R_SerialNo:�������
	 *.R_PID:��Ʒ���
	 *.R_Stockname:��Ʒ����
	 *.R_Clinkertype:��������
	 *.R_Fcao:f-CaO	
	 *.R_Mgo:MgO	
	 *.R_ShaoShi:��ʧ��	
	 *.R_BuRong:������	
	 *.R_So3:SO3	
	 *.R_Alkalinity:CaO/SiO2
	 *.R_C3S_C2S:3CaO��SiO2+2CaO��SiO2
	 *.R_3DYa1:3�쿹ѹǿ��
	 *.R_28Ya1:28��ѹǿ��
	 *.R_3DChuNing:����ʱ��
	 *.R_28DZhongNing:����ʱ��
	 *.R_AnDing:������
	 *.R_Date:¼������
	 *.R_Man:¼����
	 *.R_CenterID:������ID
	 *.R_BatQuaStart:������
	 *.R_BatQuaEnd:Ԥ����
	 *.R_TotalValue:�ѷ���
	 *.R_BatValid:״̬
  -----------------------------------------------------------------------------}    
    
  sSQL_NewStockHuaYan = 'Create Table $Table(H_ID $Inc, H_No varChar(15),' +
       'H_Custom varChar(15), H_CusName varChar(80), H_SerialNo varChar(15),' +
       'H_Truck varChar(15), H_Value $Float, H_BillDate DateTime,' +
       'H_EachTruck Char(1), H_ReportDate DateTime, H_Reporter varChar(32))';
  {-----------------------------------------------------------------------------
   �����鵥:StockHuaYan
   *.H_ID:��¼���
   *.H_No:���鵥��
   *.H_Custom:�ͻ����
   *.H_CusName:�ͻ�����
   *.H_SerialNo:ˮ����
   *.H_Truck:�������
   *.H_Value:�����
   *.H_BillDate:�������
   *.H_EachTruck: �泵����
   *.H_ReportDate:��������
   *.H_Reporter:������
  -----------------------------------------------------------------------------}
  sSQL_NewBindInfo = 'Create Table $Table(ID $Inc, Phone varChar(30),' +
       'Factory varChar(50), ToUser varChar(50), IsBind Char(1),' +
       'ErrCode int, ErrMsg varChar(30), BindDate DateTime)';
  {-----------------------------------------------------------------------------
   �������û���W_BindInfo
   *.ID:��¼��ţ���������
   *.Phone���ֻ�����
   *.Factory������ID
   *.ToUser�����û�ID
   *.IsBind�������ͣ��󶨡����
   *.ErrCode��������
   *.ErrMsg�����ؽ��
   *.BindDate��������
  -----------------------------------------------------------------------------}

  sSQL_NewCustomerInfo = 'Create Table $Table(ID $Inc, ErrCode int,' +
       'ErrMsg varChar(30), Factory varChar(50), Phone varChar(20),' +
       'AppId varChar(30), BindCustomerId varChar(50), NamePinYin varChar(30),' +
       'Email varChar(30), OpenId varChar(30), BindDate DateTime)';
  {-----------------------------------------------------------------------------
   ��ȡ΢�Ź��ںſͻ���Ϣ��W_CustomerInfo
   *.ID����¼��ţ���������
   *.ErrCode��������
   *.ErrMsg��������Ϣ
   *.Factory������ID
   *.Phone���ֻ�����
   *.AppId��
   *.BindCustomerId���󶨿ͻ�ID
   *.NamePinYin���ͻ�����ȫƴ
   *.Email����������
   *.OpenId��
   *.BindDate��������
  -----------------------------------------------------------------------------}
  sSQL_NewWebOrderMatch = 'Create Table $Table(R_ID $Inc,'+
       'WOM_WebOrderID varchar(32) null,WOM_LID varchar(20) null,'+
       'WOM_deleted char(1) default ''N'')';
  {-----------------------------------------------------------------------------
   �̳Ƕ�������������ձ�: WebOrderMatch
   *.R_ID: ��¼���
   *.WOM_WebOrderID: �̳Ƕ���
   *.WOM_LID: �����
  -----------------------------------------------------------------------------}
  sSQL_NewInventDim = 'Create Table $Table(ID $Inc, I_DimID varChar(20),' +
       'I_BatchID varChar(20), I_WMSLocationID varChar(10), I_SerialID varChar(20),' +
       'I_LocationID varChar(20), I_DatareaID varChar(4), I_RecVersion int,' +
       'I_RECID bigint, I_CenterID varChar(20))';
  {-----------------------------------------------------------------------------
   ά����Ϣ��Sys_InventDim
   *.ID��������ID
   *.I_DimID��
   *.I_BatchID��
   *.I_WMSLocationID��
   *.I_SerialID��
   *.I_LocationID��
   *.I_DatareaID��
   *.I_RecVersion��
   *.I_RECID��
   *.I_CenterID��
  -----------------------------------------------------------------------------}
  sSQL_NewInventCenter ='Create Table $Table(ID $Inc, I_CenterID varChar(20),' +
       'I_Name varChar(60), I_DataReaID varChar(4))';
  {-----------------------------------------------------------------------------
   �����߻�����Sys_InventCenter
   *.ID��������ID
   *.I_CenterID�������߱��
   *.I_Name������������
   *.I_DataReaID����˾����
  -----------------------------------------------------------------------------}
  sSQL_NewForceCenterID = 'Create Table $Table(R_ID $Inc, F_ID varChar(15), ' +
   'F_Name varChar(100), F_StockNo varChar(20), F_Stock varChar(100), F_StockType Char(1), ' +
   'F_CenterID varChar(20), F_Valid  Char(1), F_CusGroup varChar(100))';
  {-----------------------------------------------------------------------------
   ǿ��������:
   *.R_ID: ��¼��
   *.F_ID: �ͻ����
   *.F_Name: �ͻ�����
   *.F_StockNo: ˮ����
   *.F_Stock: ˮ������
   *.F_StockType: ˮ������
   *.F_CenterID: ������
   *.F_Valid: ��Ч��־
   *.F_CusGroup: �ͻ�������
  -----------------------------------------------------------------------------}

  sSQL_NewInvCenGroup ='Create Table $Table(ID $Inc, G_ItemGroupID varChar(20),' +
       'G_InventCenterID varChar(60), DataAreaID varChar(3))';
  {-----------------------------------------------------------------------------
   �����������ߣ�sys_InvCenGroup
   *.ID��������ID
   *.G_ItemGroupID��������ID
   *.G_InventCenterID��������ID
   *.DataAreaID����˾����
  -----------------------------------------------------------------------------}
  sSQL_NewInventLocation ='Create Table $Table(ID $Inc, I_LocationID varChar(20),' +
       'I_Name varChar(60), I_DataReaID varChar(4))';
  {-----------------------------------------------------------------------------
   �ֿ������Sys_InventLocation
   *.ID��������ID
   *.I_LocationID���ֿ���
   *.I_Name���ֿ�����
   *.I_DataReaID����˾����
  -----------------------------------------------------------------------------}
  sSQL_NewAddTreaty ='Create Table $Table(ID $Inc, A_SalesId varChar(20),' +
       'A_XTEadjustBillNum varChar(20), A_ItemId varChar(60), '+
       'A_SalesNewAmount numeric(28, 12),A_TakeEffectDate DateTime,'+
       'A_TakeEffectTime int not null default((1)), '+
       'RefRecid bigint not null default ((0)),'+
       'Recid bigint not null default ((0)),'+
       'DataAreaID varChar(3) not null default (''dat''),'+
       'A_Date datetime)';
  {-----------------------------------------------------------------------------
   ����Э���Sys_AddTreaty
   *.ID��������ID
   *.A_SalesId�����۶�����
   *.A_XTEadjustBillNum������Э�鵥��
   *.A_ItemId�����ϱ��
   *.A_SalesNewAmount: �����۸�
   *.A_TakeEffectDate: ��Ч����
   *.A_TakeEffectTime: ��Чʱ��
   *.DataAreaID: ����
   *.RefRecid: ���۶����й���ID
   *.Recid: �б��
   *.A_Date: ����/��������
  -----------------------------------------------------------------------------}
  sSQL_NewEmployees = 'Create Table $Table(ID $Inc, EmplId varChar(10),' +
       'EmplName varChar(60), '+
       'DataAreaID varChar(3) not null default (''dat''))';
  {-----------------------------------------------------------------------------
   Ա����Ϣ��Sys_Employees
   *.EmplId: Ա�����
   *.EmplName��Ա������
   *.DataAreaID������
  -----------------------------------------------------------------------------}
  sSQL_NewPoundWucha = 'Create Table $Table(ID $Inc, W_Type Char(1),' +
       'W_StartValue $Float, W_EndValue $Float, '+
       'W_ZValue $Float, W_FValue $Float, W_Memo varChar(60), '+
       'W_Date datetime)';
  {-----------------------------------------------------------------------------
   ������������Sys_PoundWuCha
   *.W_Type: ���� 1 ��װˮ�� 2 ɢװˮ�� 3 ש��
   *.W_StartValue����ʼ��λ
   *.W_EndValue��������λ
   *.W_ZValue�������ֵ
   *.W_FValue�������ֵ
   *.W_Memo����ע
   *.W_Date: ��������
  -----------------------------------------------------------------------------}
  sSQL_NewPoundDevia = 'Create Table $Table(R_ID $Inc, D_Bill varChar(20),' +
       'D_Truck varChar(20), D_CusID varChar(32), D_CusName varChar(80), '+
       'D_StockName varChar(80), '+
       'D_PlanValue $Float, D_JValue $Float, D_DeviaValue $Float, '+
       'D_Memo varChar(80), D_Date datetime)';
  {-----------------------------------------------------------------------------
   ������������Sys_PoundDevia
   *.D_Bill: �������
   *.D_Truck������
   *.D_CusID���ͻ�ID
   *.D_CusName���ͻ�����
   *.D_StockName��ˮ������
   *.D_PlanValue: Ʊ��
   *.D_JValue: ����
   *.D_DeviaValue: ���ֵ
   *.D_Memo����ע
   *.D_Date: ��������
  -----------------------------------------------------------------------------}
  sSQL_NewZTWorkSet = 'Create Table $Table(R_ID $Inc, Z_WorkOrder varchar(20),' +
       'Z_StartTime time(7), Z_EndTime time(7), Z_Date datetime)';
  {-----------------------------------------------------------------------------
   ջ̨������ñ�S_ZTWorkSet
   *.Z_WorkOrder: ���
   *.Z_StartTime����ʼʱ��
   *.Z_EndTime������ʱ��
   *.Z_Date: ��������
  -----------------------------------------------------------------------------}
  sSQL_NewInOutFatory = 'Create Table $Table(R_ID $Inc, I_Card varChar(16),I_Truck varChar(20),' +
       'I_CusName varChar(80), I_Context varChar(100), I_Memo varChar(200), '+
       'I_Man varChar(20),I_Date datetime, I_InDate datetime, I_OutDate datetime,'+
       'I_CType varChar(10))';
  {-----------------------------------------------------------------------------
   ��ʱ������������L_InOutFactory
   *.I_Card: ����
   *.I_CType: �����ͣ����޶��壩
   *.I_Truck������
   *.I_CusName���ͻ�����
   *.I_Context������
   *.I_Memo����ע
   *.I_Man: ������
   *.I_Date: ��������
   *.I_InDate: ��������
   *.I_OutDate: ��������
  -----------------------------------------------------------------------------}
  sSQL_NewKuWei = 'Create Table $Table(R_ID $Inc, K_Type varChar(16),' +
       'K_LocationID varChar(20), K_KuWeiNo varChar(50), K_Date datetime)';
  {-----------------------------------------------------------------------------
   ��λ���ñ�Sys_KuWei
   *.K_Type: ����  ����װ��ɢװ�����ϣ�
   *.K_LocationID: �ֿ�ID
   *.K_KuWeiNo����λ
   *.K_Date����������
  -----------------------------------------------------------------------------}
  sSQL_NewCompanyArea = 'Create Table $Table(R_ID $Inc, C_XSQYBM varChar(20),' +
       'C_XSQYMC varChar(20), C_XSGSDM varChar(20), C_XSGSMC varChar(20),'+
       'C_XTESALESAREATYPE int,C_ISVALID int,C_RECVERSION int,C_RECID bigint)';
  {-----------------------------------------------------------------------------
   ���������Sys_CompanyArea
   *.C_XSQYBM: �����������
   *.C_XSQYMC��������������
   *.C_XSGSDM�����۹�˾����
   *.C_XSGSMC: ���۹�˾����
  -----------------------------------------------------------------------------}
  sSQL_NewTransfer = 'Create Table $Table(R_ID $Inc, T_ID varChar(20),' +
       'T_Card varChar(16), T_Truck varChar(15), T_PID varChar(15),' +
       'T_SrcAddr varChar(160), T_DestAddr varChar(160),' +
       'T_Type Char(1), T_StockNo varChar(32), T_StockName varChar(160),' +
       'T_PValue $Float, T_PDate DateTime, T_PMan varChar(32),' +
       'T_MValue $Float, T_MDate DateTime, T_MMan varChar(32),' +
       'T_Value $Float, T_Man varChar(32), T_Date DateTime,' +
       'T_DelMan varChar(32), T_DelDate DateTime, T_Memo varChar(500),' +
       'T_DDAX Char(1), T_SyncNum Integer Default 0, T_SyncDate DateTime, T_SyncMemo varChar(500),'+
       'T_BID varChar(20), T_BRecID bigint not null default ((0)))';
  {-----------------------------------------------------------------------------
   �볧��: Transfer
   *.R_ID: ���
   *.T_ID: �̵�ҵ���
   *.T_PID: �������
   *.T_Card: �ſ���
   *.T_Truck: ���ƺ�
   *.T_SrcAddr:�����ص�
   *.T_DestAddr:����ص�
   *.T_Type: ����(��,ɢ)
   *.T_StockNo: ���ϱ��
   *.T_StockName: ��������
   *.T_PValue,T_PDate,T_PMan: ��Ƥ��
   *.T_MValue,T_MDate,T_MMan: ��ë��
   *.T_Value: �ջ���
   *.T_Man,T_Date: ������Ϣ
   *.T_DelMan,T_DelDate: ɾ����Ϣ
   *.T_DDAX, T_SyncNum, T_SyncDate, T_SyncMemo: ͬ������; ͬ�����ʱ��; ͬ����Ϣ
   *.T_BID: �������
   *.T_BRecID: �б���
  -----------------------------------------------------------------------------}
    sSQL_NewSTInOutFact = 'Create Table $Table(R_ID $Inc, I_Card varChar(16),I_Truck varChar(20),' +
       'I_CusName varChar(80), I_Context varChar(100), I_Memo varChar(200), '+
       'I_Man varChar(20),I_Date datetime, I_InDate datetime, I_OutDate datetime,'+
       'I_CType varChar(32))';
  {-----------------------------------------------------------------------------
   ���ſ�������L_STInOutFact
   *.I_Card: ����
   *.I_CType: �����ͣ����޶��壩
   *.I_Truck������
   *.I_CusName���ͻ�����
   *.I_Context������
   *.I_Memo����ע
   *.I_Man: ������
   *.I_Date: ��������
   *.I_InDate: ��������
   *.I_OutDate: ��������
  -----------------------------------------------------------------------------}
  sSQL_NewAxPlanInfo = 'Create Table $Table(R_ID $Inc, AX_PLANQTY $Float, ' +
       'AX_VEHICLEId varChar(30), AX_ITEMID varChar(30), AX_ITEMNAME varChar(50),  '+
       'AX_ITEMTYPE varChar(10), AX_ITEMPRICE $Float, AX_CUSTOMERID varChar(30), '+
       'AX_CUSTOMERNAME varChar(400), AX_TRANSPORTER varChar(50), AX_TRANSPLANID varChar(50), '+
       'AX_SALESID varChar(50), AX_SALESLINERECID bigint, AX_COMPANYID varChar(30), '+
       'AX_Destinationcode varChar(32), AX_WMSLocationId varChar(32), AX_FYPlanStatus varChar(32), '+
       'AX_InventLocationId varChar(32), AX_xtDInventCenterId varChar(32))';
  {-----------------------------------------------------------------------------
   AX�����Ϣ��E_AxPlanInfo
   *.AX_PLANQTY: �ƻ������
   *.AX_VEHICLEId: ���ƺ���
   *.AX_ITEMID�����ϱ���
   *.AX_ITEMNAME����������
   *.AX_ITEMTYPE���������ͣ�D��װ��Sɢװ��
   *.AX_ITEMPRICE������
   *.AX_CUSTOMERID: �ͻ�ID
   *.AX_CUSTOMERNAME: �ͻ�����
   *.AX_TRANSPORTER:
   *.AX_TRANSPLANID: ������ţ����˼ƻ��ţ�
   *.AX_SALESID: �������
   *.AX_SALESLINERECID�������б��
   *.AX_COMPANYID������
   *.AX_Destinationcode��
   *.AX_WMSLocationId��
   *.AX_FYPlanStatus��״̬
   *.AX_InventLocationId���ֿ�
   *.AX_xtDInventCenterId��������
  -----------------------------------------------------------------------------}
  sSQL_NewAxMsgList = 'Create Table $Table(R_ID $Inc, AX_ProcessId varChar(30), ' +
       'AX_Recid varChar(30), AX_CompanyId varChar(30), AX_Status varChar(10))';
  {-----------------------------------------------------------------------------
   AX��Ϣ���б�E_AxMsgList
   *.AX_ProcessId: ҵ��ID
   *.AX_Recid: ��ID
   *.AX_CompanyId������
   *.AX_Status: ״̬
  -----------------------------------------------------------------------------}

//------------------------------------------------------------------------------
// ���ݲ�ѯ
//------------------------------------------------------------------------------
  sQuery_SysDict = 'Select D_ID, D_Value, D_Memo, D_ParamA, ' +
         'D_ParamB From $Table Where D_Name=''$Name'' Order By D_Index ASC';
  {-----------------------------------------------------------------------------
   �������ֵ��ȡ����
   *.$Table:�����ֵ��
   *.$Name:�ֵ�������
  -----------------------------------------------------------------------------}

  sQuery_ExtInfo = 'Select I_ID, I_Item, I_Info From $Table Where ' +
         'I_Group=''$Group'' and I_ItemID=''$ID'' Order By I_Index Desc';
  {-----------------------------------------------------------------------------
   ����չ��Ϣ���ȡ����
   *.$Table:��չ��Ϣ��
   *.$Group:��������
   *.$ID:��Ϣ��ʶ
  -----------------------------------------------------------------------------}

  sSQL_SnapTruck = 'Create Table $Table(R_ID $Inc, S_ID varChar(20), ' +
       'S_Truck varChar(20), S_Date DateTime, S_PicName varChar(80))';
  {-----------------------------------------------------------------------------
   ����ʶ��:
   *.R_ID:��¼���
   *.S_ID: ץ�ĸ�λ
   *.S_Truck:ץ�ĳ��ƺ�
   *.S_Date: ץ��ʱ��
   *.S_PicName: ץ��ͼƬ·��
  -----------------------------------------------------------------------------}

function CardStatusToStr(const nStatus: string): string;
//�ſ�״̬
function TruckStatusToStr(const nStatus: string): string;
//����״̬
function BillTypeToStr(const nType: string): string;
//��������
function PostTypeToStr(const nPost: string): string;
//��λ����

implementation

//Desc: ��nStatusתΪ�ɶ�����
function CardStatusToStr(const nStatus: string): string;
begin
  if nStatus = sFlag_CardIdle then Result := '����' else
  if nStatus = sFlag_CardUsed then Result := '����' else
  if nStatus = sFlag_CardLoss then Result := '��ʧ' else
  if nStatus = sFlag_CardInvalid then Result := 'ע��' else Result := 'δ֪';
end;

//Desc: ��nStatusתΪ��ʶ�������
function TruckStatusToStr(const nStatus: string): string;
begin
  if nStatus = sFlag_TruckIn then Result := '����' else
  if nStatus = sFlag_TruckOut then Result := '����' else
  if nStatus = sFlag_TruckBFP then Result := '��Ƥ��' else
  if nStatus = sFlag_TruckBFM then Result := '��ë��' else
  if nStatus = sFlag_TruckSH then Result := '�ͻ���' else
  if nStatus = sFlag_TruckXH then Result := '���մ�' else
  if nStatus = sFlag_TruckFH then Result := '�ŻҴ�' else
  if nStatus = sFlag_TruckZT then Result := 'ջ̨' else Result := 'δ����';
end;

//Desc: ����������תΪ��ʶ������
function BillTypeToStr(const nType: string): string;
begin
  if nType = sFlag_TypeShip then Result := '����' else
  if nType = sFlag_TypeZT   then Result := 'ջ̨' else
  if nType = sFlag_TypeVIP  then Result := 'VIP' else Result := '��ͨ';
end;

//Desc: ����λתΪ��ʶ������
function PostTypeToStr(const nPost: string): string;
begin
  if nPost = sFlag_TruckIn   then Result := '��������' else
  if nPost = sFlag_TruckOut  then Result := '��������' else
  if nPost = sFlag_TruckBFP  then Result := '������Ƥ' else
  if nPost = sFlag_TruckBFM  then Result := '��������' else
  if nPost = sFlag_TruckFH   then Result := 'ɢװ�Ż�' else
  if nPost = sFlag_TruckZT   then Result := '��װջ̨' else Result := '����';
end;

//------------------------------------------------------------------------------
//Desc: ���ϵͳ����
procedure AddSysTableItem(const nTable,nNewSQL,nNewSQL1: String);
var nP: PSysTableItem;
begin
  New(nP);
  gSysTableList.Add(nP);

  nP.FTable := nTable;
  nP.FNewSQL := nNewSQL+nNewSQL1;
end;

//Desc: ϵͳ��
procedure InitSysTableList;
begin
  gSysTableList := TList.Create;

  AddSysTableItem(sTable_SysDict, sSQL_NewSysDict,'');
  AddSysTableItem(sTable_ExtInfo, sSQL_NewExtInfo,'');
  AddSysTableItem(sTable_SysLog, sSQL_NewSysLog,'');

  AddSysTableItem(sTable_BaseInfo, sSQL_NewBaseInfo,'');
  AddSysTableItem(sTable_SerialBase, sSQL_NewSerialBase,'');
  AddSysTableItem(sTable_SerialStatus, sSQL_NewSerialStatus,'');
  AddSysTableItem(sTable_StockMatch, sSQL_NewStockMatch,'');
  AddSysTableItem(sTable_WorkePC, sSQL_NewWorkePC,'');
  AddSysTableItem(sTable_ManualEvent, sSQL_NewManualEvent,'');

  AddSysTableItem(sTable_Customer, sSQL_NewCustomer,'');
  AddSysTableItem(sTable_CustomerExt, sSQL_NewCustomerExt,'');
  AddSysTableItem(sTable_Salesman, sSQL_NewSalesMan,'');
  AddSysTableItem(sTable_SaleContract, sSQL_NewSaleContract,'');
  AddSysTableItem(sTable_SContractExt, sSQL_NewSContractExt,'');

  AddSysTableItem(sTable_CusAccount, sSQL_NewCusAccount,'');
  AddSysTableItem(sTable_InOutMoney, sSQL_NewInOutMoney,'');
  AddSysTableItem(sTable_CusCredit, sSQL_NewCusCredit,'');
  AddSysTableItem(sTable_SysShouJu, sSQL_NewSysShouJu,'');

  AddSysTableItem(sTable_InvoiceWeek, sSQL_NewInvoiceWeek,'');
  AddSysTableItem(sTable_Invoice, sSQL_NewInvoice,'');
  AddSysTableItem(sTable_InvoiceDtl, sSQL_NewInvoiceDtl,'');
  AddSysTableItem(sTable_InvoiceReq, sSQL_NewInvoiceReq,'');
  AddSysTableItem(sTable_InvReqtemp, sSQL_NewInvoiceReq,'');
  AddSysTableItem(sTable_DataTemp, sSQL_NewDataTemp,'');

  AddSysTableItem(sTable_WeixinLog, sSQL_NewWXLog,'');
  AddSysTableItem(sTable_WeixinMatch, sSQL_NewWXMatch,'');
  AddSysTableItem(sTable_WeixinTemp, sSQL_NewWXTemplate,'');
  AddSysTableItem(sTable_WeixinBind,sSQL_NewWeixinCusBind,'');
  AddSysTableItem(sTable_WeixinBindP,sSQL_NewWeixinProBind,'');

  AddSysTableItem(sTable_ZhiKa, sSQL_NewZhiKa,'');
  AddSysTableItem(sTable_ZhiKaDtl, sSQL_NewZhiKaDtl,'');
  AddSysTableItem(sTable_Card, sSQL_NewCard,'');
  AddSysTableItem(sTable_CardOther, sSQL_NewCardOther,'');
  
  AddSysTableItem(sTable_Bill, sSQL_NewBill, sSQL_NewBill1);
  AddSysTableItem(sTable_BillBak, sSQL_NewBill, sSQL_NewBill1);

  AddSysTableItem(sTable_Truck, sSQL_NewTruck,'');
  AddSysTableItem(sTable_ZTLines, sSQL_NewZTLines,'');
  AddSysTableItem(sTable_ZTTrucks, sSQL_NewZTTrucks,'');
  
  AddSysTableItem(sTable_PoundLog, sSQL_NewPoundLog,'');
  AddSysTableItem(sTable_PoundBak, sSQL_NewPoundLog,'');
  AddSysTableItem(sTable_Picture, sSQL_NewPicture,'');
  AddSysTableItem(sTable_Provider, ssql_NewProvider,'');
  AddSysTableItem(sTable_Materails, sSQL_NewMaterails,'');

  AddSysTableItem(sTable_StockParam, sSQL_NewStockParam,'');
  AddSysTableItem(sTable_StockParamExt, sSQL_NewStockRecord,'');
  AddSysTableItem(sTable_StockRecord, sSQL_NewStockRecord,'');
  AddSysTableItem(sTable_StockHuaYan, sSQL_NewStockHuaYan,'');
  AddSysTableItem(sTable_StockRecord_Slag, sSQL_NewStockRecord_Slag,'');
  AddSysTableItem(sTable_StockRecord_Concrete, sSQL_NewStockRecord_Concrete,'');
  AddSysTableItem(sTable_StockRecord_clinker, sSQL_NewStockRecord_clinker,'');

  AddSysTableItem(sTable_Order, sSQL_NewOrder,'');
  AddSysTableItem(sTable_OrderBak, sSQL_NewOrder,'');
  AddSysTableItem(sTable_OrderDtl, sSQL_NewOrderDtl,'');
  AddSysTableItem(sTable_OrderDtlBak, sSQL_NewOrderDtl,'');
  AddSysTableItem(sTable_OrderBaseMain, sSQL_NewOrdBaseMain,'');
  AddSysTableItem(sTable_OrderBase, sSQL_NewOrderBase,'');
  AddSysTableItem(sTable_OrderBaseBak, sSQL_NewOrderBase,'');
  AddSysTableItem(sTable_Deduct, sSQL_NewDeduct,'');
  AddSysTableItem(sTable_BindInfo, sSQL_NewBindInfo,'');
  AddSysTableItem(sTable_CustomerInfo, sSQL_NewCustomerInfo,'');

  AddSysTableItem(sTable_InventDim, sSQL_NewInventDim,'');
  AddSysTableItem(sTable_InventCenter, sSQL_NewInventCenter,'');
  AddSysTableItem(sTable_ForceCenterID, sSQL_NewForceCenterID,'');
  AddSysTableItem(sTable_InventLocation, sSQL_NewInventLocation,'');
  AddSysTableItem(sTable_CusContCredit, sSQL_NewCusConCredit,'');
  AddSysTableItem(sTable_CustPresLog, sSQL_NewCustPresLog,'');
  AddSysTableItem(sTable_AddTreaty, sSQL_NewAddTreaty,'');
  AddSysTableItem(sTable_ContPresLog, sSQL_NewContPresLog,'');
  AddSysTableItem(sTable_InvCenGroup, sSQL_NewInvCenGroup,'');
  AddSysTableItem(sTable_EMPL, sSQL_NewEmployees,'');
  AddSysTableItem(sTable_PoundWucha, sSQL_NewPoundWucha,'');
  AddSysTableItem(sTable_PoundDevia, sSQL_NewPoundDevia,'');
  AddSysTableItem(sTable_ZTWorkSet, sSQL_NewZTWorkSet,'');
  AddSysTableItem(sTable_InOutFatory, sSQL_NewInOutFatory,'');
  AddSysTableItem(sTable_KuWei, sSQL_NewKuWei,'');
  AddSysTableItem(sTable_CompanyArea, sSQL_NewCompanyArea, '');

  AddSysTableItem(sTable_Transfer, sSQL_NewTransfer,'');
  AddSysTableItem(sTable_TransferBak, sSQL_NewTransfer,'');
  AddSysTableItem(sTable_STInOutFact, sSQL_NewSTInOutFact,'');
  AddSysTableItem(sTable_WebOrderMatch,sSQL_NewWebOrderMatch,'');

  AddSysTableItem(sTable_AxPlanInfo, sSQL_NewAxPlanInfo,'');
  AddSysTableItem(sTable_AxMsgList, sSQL_NewAxMsgList,'');
  AddSysTableItem(sTable_YSLines, sSQL_NewYSLines, '');
  AddSysTableItem(sTable_SnapTruck,sSQL_SnapTruck, '');
end;

//Desc: ����ϵͳ��
procedure ClearSysTableList;
var nIdx: integer;
begin
  for nIdx:= gSysTableList.Count - 1 downto 0 do
  begin
    Dispose(PSysTableItem(gSysTableList[nIdx]));
    gSysTableList.Delete(nIdx);
  end;

  FreeAndNil(gSysTableList);
end;

initialization
  InitSysTableList;
finalization
  ClearSysTableList;
end.


