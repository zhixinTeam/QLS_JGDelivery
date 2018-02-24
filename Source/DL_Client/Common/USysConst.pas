{*******************************************************************************
  ����: dmzn@ylsoft.com 2007-10-09
  ����: ��Ŀͨ�ó�,�������嵥Ԫ
*******************************************************************************}
unit USysConst;

interface

uses
  SysUtils, Classes, ComCtrls;

const
  cSBar_Date            = 0;                         //�����������
  cSBar_Time            = 1;                         //ʱ���������
  cSBar_User            = 2;                         //�û��������
  cRecMenuMax           = 5;                         //���ʹ�õ����������Ŀ��
  
  cShouJuIDLength       = 7;                         //�����վݱ�ʶ����
  cItemIconIndex        = 11;                        //Ĭ�ϵ�������б�ͼ��

const
  {*Frame ID*}
  cFI_FrameSysLog       = $0001;                     //ϵͳ��־
  cFI_FrameViewLog      = $0002;                     //������־
  cFI_FrameAuthorize    = $0003;                     //ϵͳ��Ȩ

  cFI_FrameCustomer     = $0004;                     //�ͻ�����
  cFI_FrameSalesMan     = $0005;                     //ҵ��Ա
  cFI_FrameSaleContract = $0006;                     //���ۺ�ͬ
  cFI_FrameZhiKa        = $0007;                     //����ֽ��
  cFI_FrameMakeCard     = $0012;                     //�����ſ�
  cFI_FrameBill         = $0013;                     //�������
  cFI_FrameBillQuery    = $0014;                     //������ѯ
  cFI_FrameMakeOCard    = $0015;                     //�����ɹ��ſ�
  cFI_FrameBill_brick   = $0016;                     //����ש�鿪����ѯ
  cFI_FormTodo          = $0017;                     //����������

  cFI_FrameShouJu       = $0020;                     //�վݲ�ѯ
  cFI_FrameZhiKaVerify  = $0021;                     //ֽ�����
  cFI_FramePayment      = $0022;                     //���ۻؿ�
  cFI_FrameCusCredit    = $0023;                     //���ù���

  cFI_FrameLadingDai    = $0030;                     //��װ���
  cFI_FramePoundQuery   = $0031;                     //������ѯ
  cFI_FrameFangHuiQuery = $0032;                     //�ŻҲ�ѯ
  cFI_FrameZhanTaiQuery = $0033;                     //ջ̨��ѯ
  cFI_FrameZTDispatch   = $0034;                     //ջ̨����
  cFI_FramePoundManual  = $0035;                     //�ֶ�����
  cFI_FramePoundAuto    = $0036;                     //�Զ�����

  cFI_FrameStock        = $0042;                     //Ʒ�ֹ���
  cFI_FrameStockRecord  = $0043;                     //�����¼
  cFI_FrameStockHuaYan  = $0045;                     //�����鵥
  cFI_FrameStockHY_Each = $0046;                     //�泵����
  cFI_FrameStockRecord_Slag  = $0047;                //�����ۼ����¼
  cFI_FrameStockRecord_Concrete  = $0048;            //��������Ʒ�����¼
  cFI_FrameStockRecord_clinker  = $0049;             //ͨ�����ϼ����¼


  cFI_FrameTruckQuery   = $0050;                     //������ѯ
  cFI_FrameCusAccountQuery = $0051;                  //�ͻ��˻�
  cFI_FrameCusInOutMoney   = $0052;                  //�������ϸ
  cFI_FrameSaleTotalQuery  = $0053;                  //�ۼƷ���
  cFI_FrameSaleDetailQuery = $0054;                  //������ϸ
  cFI_FrameZhiKaDetail  = $0055;                     //ֽ����ϸ
  cFI_FrameDispatchQuery = $0056;                    //���Ȳ�ѯ
  cFI_FrameOrderDetailQuery = $0057;                 //�ɹ���ϸ

  cFI_FrameSaleInvoice  = $0061;                     //��Ʊ����
  cFI_FrameMakeInvoice  = $0062;                     //���߷�Ʊ
  cFI_FrameInvoiceWeek  = $0063;                     //��������
  cFI_FrameSaleZZ       = $0065;                     //��������
  cFI_FrameSaleJS       = $0069;                     //���۽���

  cFI_FrameTrucks       = $0070;                     //��������

  cFI_FrameProvider     = $0102;                     //��Ӧ
  cFI_FrameProvideLog   = $0105;                     //��Ӧ��־
  cFI_FrameMaterails    = $0106;                     //ԭ����
  cFI_FrameOrder        = $0107;                     //�ɹ�����
  cFI_FrameOrderBase    = $0108;                     //�ɹ����뵥
  cFI_FrameOrderDetail  = $0109;                     //�ɹ���ϸ

  cFI_FrameWXAccount    = $0110;                     //΢���˻�
  cFI_FrameWXSendLog    = $0111;                     //������־
  cFI_FrameDeduct       = $0112;                     //���۹���

  cFI_FrameLSCard       = $0113;                     //��ʱ��������ѯ
  cFI_FormLSCard        = $0114;                     //��ʱ������
  cFI_FrameSTCard       = $0115;                     //���ſ�������ѯ
  cFI_FormSTCard        = $0116;                     //���ſ�����

  cFI_FormMemo          = $1000;                     //��ע����
  cFI_FormBackup        = $1001;                     //���ݱ���
  cFI_FormRestore       = $1002;                     //���ݻָ�
  cFI_FormIncInfo       = $1003;                     //��˾��Ϣ
  cFI_FormChangePwd     = $1005;                     //�޸�����

  cFI_FormBaseInfo      = $1006;                     //������Ϣ
  cFI_FormCustomer      = $1007;                     //�ͻ�����
  cFI_FormSaleMan       = $1008;                     //ҵ��Ա
  cFI_FormSaleContract  = $1009;                     //���ۺ�ͬ
  cFI_FormZhiKa         = $1010;                     //ֽ������
  cFI_FormZhiKaParam    = $1011;                     //ֽ������
  cFI_FormGetZhika      = $1012;                     //ѡ��ֽ��
  cFI_FormMakeCard      = $1013;                     //�����ſ�
  cFI_FormMakeRFIDCard  = $1014;                     //�������ӱ�ǩ

  cFI_FormQLSBill       = $1015;                     //�������
  cFI_FormBill          = $1016;                     //�������
  cFI_FormShouJu        = $1017;                     //���վ�
  cFI_FormZhiKaVerify   = $1018;                     //ֽ�����
  cFI_FormCusCredit     = $1019;                     //���ñ䶯
  cFI_FormPayment       = $1020;                     //���ۻؿ�
  cFI_FormTruckIn       = $1021;                     //��������
  cFI_FormTruckOut      = $1022;                     //��������
  cFI_FormVerifyCard    = $1023;                     //�ſ���֤
  cFI_FormAutoBFP       = $1024;                     //�Զ���Ƥ
  cFI_FormBangFangP     = $1025;                     //����Ƥ��
  cFI_FormBangFangM     = $1026;                     //����ë��
  cFI_FormLadDai        = $1027;                     //��װ���
  cFI_FormLadSan        = $1028;                     //ɢװ���
  cFI_FormJiShuQi       = $1029;                     //��������
  cFI_FormBFWuCha       = $1030;                     //�������
  cFI_FormZhiKaQuery    = $1031;                     //��Ƭ��Ϣ
  cFI_FormBuDan         = $1032;                     //���۲���
  cFI_FormZhiKaInfoExt1 = $1033;                     //ֽ����չ
  cFI_FormZhiKaInfoExt2 = $1034;                     //ֽ����չ
  cFI_FormZhiKaAdjust   = $1035;                     //ֽ������
  cFI_FormZhiKaFixMoney = $1036;                     //������
  cFI_FormSaleAdjust    = $1037;                     //���۵���
  cFI_FormEditPrice     = $1040;                     //�������
  cFI_FormGetProvider   = $1041;                     //ѡ��Ӧ��
  cFI_FormGetMeterail   = $1042;                     //ѡ��ԭ����
  cFI_FormTruckEmpty    = $1043;                     //�ճ�����
  cFI_FormReadCard      = $1044;                     //��ȡ�ſ�
  cFI_FormZTLine        = $1045;                     //װ����   

  cFI_FormGetTruck      = $1047;                     //ѡ����
  cFI_FormGetContract   = $1048;                     //ѡ���ͬ
  cFI_FormGetCustom     = $1049;                     //ѡ��ͻ�
  cFI_FormGetStockNo    = $1050;                     //ѡ����
  cFI_FormProvider      = $1051;                     //��Ӧ��
  cFI_FormMaterails     = $1052;                     //ԭ����
  cFI_FormOrder         = $1053;                     //�ɹ�����
  cFI_FormOrderBase     = $1054;                     //�ɹ�����
  cFI_FormPurchase      = $1055;                     //�ɹ�����
  cFI_FormGetPOrderBase = $1056;                     //�ɹ�����
  cFI_FormDeduct        = $1057;                     //���۹���
  cFI_FormGetNCStock    = $1058;                     //ѡ������

  cFI_FormStockParam    = $1065;                     //Ʒ�ֹ���
  cFI_FormStockHuaYan   = $1066;                     //�����鵥
  cFI_FormStockHY_Each  = $1067;                     //�泵����

  cFI_FormPaymentZK     = $1068;                     //ֽ���ؿ�
  cFI_FormFreezeZK      = $1069;                     //����ֽ��
  cFI_FormAdjustPrice   = $1070;                     //ֽ������

  cFI_FormTrucks        = $1071;                     //��������

  cFI_FormInvoiceWeek   = $1075;                     //��������
  cFI_FormSaleInvoice   = $1076;                     //��Ʊ����
  cFI_FormMakeInvoice   = $1077;                     //���߷�Ʊ
  cFI_FormViewInvoices  = $1078;                     //��Ʊ�б�
  cFI_FormSaleZZALL     = $1079;                     //����(ȫ��)
  cFI_FormSaleZZCus     = $1080;                     //����(�ͻ�)
  cFI_FormInvGetWeek    = $1081;                     //ѡ������
  cFI_FormInvAdjust     = $1082;                     //�޸�������

  cFI_FormAuthorize     = $1090;                     //��ȫ��֤
  cFI_FormWXAccount     = $1091;                     //΢���˻�
  cFI_FormWXSendlog     = $1092;                     //΢����־
  cFI_FormWeixinReg     = $1093;                     //΢��ע��
  cFI_FormWeixinBind    = $1094;                     //���û�
  cFI_FormAXBaseLoad    = $1095;                     //AX������������
  cFI_FormSiteConfirm   = $1096;                     //�ֳ�װ��ȷ��
  cFI_FrameUpInfo       = $1097;                     //�����ϴ���Ϣ
  cFI_FramePoundWc      = $1098;                     //�����������
  cFI_FormPoundWc       = $1099;                     //�����������
  cFI_FormPoundKw       = $1100;                     //���ؿ���
  cFI_FormWorkSet       = $1101;                     //�������
  cFI_FrameUpPurchase   = $1102;                     //�ɹ��ϴ���Ϣ
  cFI_FramePoundDevia   = $1103;                     //��������ѯ
  cFI_FrameTransferDetailQuery = $1104;              //�̵���ѯ
  cFI_FormTransfer      = $1105;                     //�̵��ƿ�
  cFI_FrameWXBind       = $1106;                     //΢���˺Ű�
  cFI_FormGetWechartAccount    = $1107;              //�ͻ�ע����Ϣ
  cFI_FormAXBaseLoadS    = $1108;                    //���ۻ�����������
  cFI_FormAXBaseLoadP    = $1109;                    //�ɹ�������������
  cFI_FrameYSLines       = $1110;                    //�ɹ�����ͨ��
  cFI_FormYSLine         = $1111;                    //�ɹ�����ͨ������

  cFI_FrameQPoundTemp   = $1112;                      //��ʱ����
  CFI_FormMakeCardOther = $1113;                     //��ʱ����ҵ��
  cFI_FormBill_brick    = $1114;                     //�������_����ש��
  cFI_FormGetZhika_brick = $1115;                     //ѡ��ֽ��_����ש��
  cFI_FrameBrick         = $1116;                     //ש��Ʒ�ֹ���
  cFI_FormBrick         = $1117;                     //ש��Ʒ�ֹ���
  {*Command*}
  cCmd_RefreshData      = $0002;                     //ˢ������
  cCmd_ViewSysLog       = $0003;                     //ϵͳ��־

  cCmd_ModalResult      = $1001;                     //Modal����
  cCmd_FormClose        = $1002;                     //�رմ���
  cCmd_AddData          = $1003;                     //��������
  cCmd_EditData         = $1005;                     //�޸�����
  cCmd_ViewData         = $1006;                     //�鿴����
  cCmd_GetData          = $1007;                     //ѡ������
type
  TSysParam = record
    FProgID     : string;                            //�����ʶ
    FAppTitle   : string;                            //�����������ʾ
    FMainTitle  : string;                            //���������
    FHintText   : string;                            //��ʾ�ı�
    FCopyRight  : string;                            //��������ʾ����
    FFactory    : string;                            //����ID

    FUserID     : string;                            //�û���ʶ
    FUserName   : string;                            //��ǰ�û�
    FUserPwd    : string;                            //�û�����
    FGroupID    : string;                            //������
    FIsAdmin    : Boolean;                           //�Ƿ����Ա
    FIsNormal   : Boolean;                           //�ʻ��Ƿ�����

    FRecMenuMax : integer;                           //����������
    FIconFile   : string;                            //ͼ�������ļ�
    FUsesBackDB : Boolean;                           //ʹ�ñ��ݿ�

    FLocalIP    : string;                            //����IP
    FLocalMAC   : string;                            //����MAC
    FLocalName  : string;                            //��������
    FHardMonURL : string;                            //Ӳ���ػ�
    FDepartment : string;                            //��������
    
    FFactNum    : string;                            //�������
    FSerialID   : string;                            //���Ա��
    FIsManual   : Boolean;                           //�ֶ�����
    FAutoPound  : Boolean;                           //�Զ�����

    FPoundDaiZ  : Double;
    FPoundDaiZ_1: Double;                            //��װ�����
    FPoundDaiF  : Double;
    FPoundDaiF_1: Double;                            //��װ�����
    FDaiPercent : Boolean;                           //����������ƫ��
    FDaiWCStop  : Boolean;                           //��������װƫ��
    FSanWCStop  : Boolean;                           //������ɢװƫ��
    FBrickWCStop  : Boolean;                         //������ש��ƫ��
    FPoundSanF  : Double;                            //ɢװ�����
    FPicBase    : Integer;                           //ͼƬ����
    FPicPath    : string;                            //ͼƬĿ¼
    FVoiceUser  : Integer;                           //��������
    FProberUser : Integer;                           //���������
    FEmpTruckWc : Double;                            //�ճ��������
  end;
  //ϵͳ����

  TModuleItemType = (mtFrame, mtForm);
  //ģ������

  PMenuModuleItem = ^TMenuModuleItem;
  TMenuModuleItem = record
    FMenuID: string;                                 //�˵�����
    FModule: integer;                                //ģ���ʶ
    FItemType: TModuleItemType;                      //ģ������
  end;

//------------------------------------------------------------------------------
var
  gPath: string;                                     //��������·��
  gSysParam:TSysParam;                               //���򻷾�����
  gStatusBar: TStatusBar;                            //ȫ��ʹ��״̬��
  gMenuModule: TList = nil;                          //�˵�ģ��ӳ���

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //Ĭ�ϱ�ʶ
  sAppTitle           = 'DMZN';                      //�������
  sMainCaption        = 'DMZN';                      //�����ڱ���

  sHint               = '��ʾ';                      //�Ի������
  sWarn               = '����';                      //==
  sAsk                = 'ѯ��';                      //ѯ�ʶԻ���
  sError              = 'δ֪����';                  //����Ի���

  sDate               = '����:��%s��';               //����������
  sTime               = 'ʱ��:��%s��';               //������ʱ��
  sUser               = '�û�:��%s��';               //�������û�

  sLogDir             = 'Logs\';                     //��־Ŀ¼
  sLogExt             = '.log';                      //��־��չ��
  sLogField           = #9;                          //��¼�ָ���

  sImageDir           = 'Images\';                   //ͼƬĿ¼
  sReportDir          = 'Report\';                   //����Ŀ¼
  sBackupDir          = 'Backup\';                   //����Ŀ¼
  sBackupFile         = 'Bacup.idx';                 //��������
  sCameraDir          = 'Camera\';                   //ץ��Ŀ¼

  sConfigFile         = 'Config.Ini';                //�������ļ�
  sConfigSec          = 'Config';                    //������С��
  sVerifyCode         = ';Verify:';                  //У������

  sFormConfig         = 'FormInfo.ini';              //��������
  sSetupSec           = 'Setup';                     //����С��
  sDBConfig           = 'DBConn.ini';                //��������
  sDBConfig_bk        = 'isbk';                      //���ݿ�

  sExportExt          = '.txt';                      //����Ĭ����չ��
  sExportFilter       = '�ı�(*.txt)|*.txt|�����ļ�(*.*)|*.*';
                                                     //������������ 

  sInvalidConfig      = '�����ļ���Ч���Ѿ���';    //�����ļ���Ч
  sCloseQuery         = 'ȷ��Ҫ�˳�������?';         //�������˳�

implementation

//------------------------------------------------------------------------------
//Desc: ���Ӳ˵�ģ��ӳ����
procedure AddMenuModuleItem(const nMenu: string; const nModule: Integer;
 const nType: TModuleItemType = mtFrame);
var nItem: PMenuModuleItem;
begin
  New(nItem);
  gMenuModule.Add(nItem);

  nItem.FMenuID := nMenu;
  nItem.FModule := nModule;
  nItem.FItemType := nType;
end;

//Desc: �˵�ģ��ӳ���
procedure InitMenuModuleList;
begin
  gMenuModule := TList.Create;

  AddMenuModuleItem('MAIN_A01', cFI_FormIncInfo, mtForm);
  AddMenuModuleItem('MAIN_A02', cFI_FrameSysLog);
  AddMenuModuleItem('MAIN_A03', cFI_FormBackup, mtForm);
  AddMenuModuleItem('MAIN_A04', cFI_FormRestore, mtForm);
  AddMenuModuleItem('MAIN_A05', cFI_FormChangePwd, mtForm);
  AddMenuModuleItem('MAIN_A07', cFI_FrameAuthorize);
  AddMenuModuleItem('MAIN_A08', cFI_FormTodo, mtForm);  

  AddMenuModuleItem('MAIN_B01', cFI_FormBaseInfo, mtForm);
  AddMenuModuleItem('MAIN_B02', cFI_FrameCustomer);
  AddMenuModuleItem('MAIN_B03', cFI_FrameSalesMan);
  AddMenuModuleItem('MAIN_B04', cFI_FrameSaleContract);

  AddMenuModuleItem('MAIN_C01', cFI_FrameZhiKaVerify);
  AddMenuModuleItem('MAIN_C02', cFI_FramePayment);
  AddMenuModuleItem('MAIN_C03', cFI_FrameCusCredit);
  AddMenuModuleItem('MAIN_C04', cFI_FrameSaleInvoice);
  AddMenuModuleItem('MAIN_C05', cFI_FrameMakeInvoice);
  AddMenuModuleItem('MAIN_C06', cFI_FrameInvoiceWeek);
  AddMenuModuleItem('MAIN_C07', cFI_FrameShouJu);
  AddMenuModuleItem('MAIN_C08', cFI_FrameSaleZZ);

  AddMenuModuleItem('MAIN_D01', cFI_FormZhiKa, mtForm);
  AddMenuModuleItem('MAIN_D02', cFI_FrameMakeCard);
  AddMenuModuleItem('MAIN_D03', cFI_FormBill, mtForm);
  AddMenuModuleItem('MAIN_D04', cFI_FormBill, mtForm);
  AddMenuModuleItem('MAIN_D05', cFI_FrameZhiKa);
  AddMenuModuleItem('MAIN_D06', cFI_FrameBill);
  AddMenuModuleItem('MAIN_D08', cFI_FormTruckEmpty, mtForm);
  AddMenuModuleItem('MAIN_D09', cFI_FormQLSBill, mtForm);
  AddMenuModuleItem('MAIN_D10', cFI_FormBill_brick, mtForm);
  AddMenuModuleItem('MAIN_D11', cFI_FrameBill_brick);

  AddMenuModuleItem('MAIN_E01', cFI_FramePoundManual);
  AddMenuModuleItem('MAIN_E02', cFI_FramePoundAuto);
  AddMenuModuleItem('MAIN_E03', cFI_FramePoundQuery);
  AddMenuModuleItem('MAIN_E04', cFI_FramePoundWc); 
  AddMenuModuleItem('MAIN_E05', cFI_FramePoundDevia);

  AddMenuModuleItem('MAIN_F01', cFI_FormLadDai, mtForm);
  AddMenuModuleItem('MAIN_F03', cFI_FrameZhanTaiQuery);
  AddMenuModuleItem('MAIN_F04', cFI_FrameZTDispatch);
  AddMenuModuleItem('MAIN_F05', cFI_FormPurchase, mtForm);
  AddMenuModuleItem('MAIN_F06', cFI_FormSiteConfirm,mtForm);

  AddMenuModuleItem('MAIN_G01', cFI_FormLadSan, mtForm);
  AddMenuModuleItem('MAIN_G02', cFI_FrameFangHuiQuery);

  AddMenuModuleItem('MAIN_K01', cFI_FrameStock);
  AddMenuModuleItem('MAIN_K02', cFI_FrameStockRecord);
  AddMenuModuleItem('MAIN_K03', cFI_FrameStockHuaYan);
  AddMenuModuleItem('MAIN_K04', cFI_FormStockHuaYan, mtForm);
  AddMenuModuleItem('MAIN_K05', cFI_FormStockHY_Each, mtForm);
  AddMenuModuleItem('MAIN_K06', cFI_FrameStockHY_Each);
  AddMenuModuleItem('MAIN_K07', cFI_FrameBrick);
  AddMenuModuleItem('MAIN_K08', cFI_FrameStockRecord_Slag);
  AddMenuModuleItem('MAIN_K09', cFI_FrameStockRecord_Concrete);
  AddMenuModuleItem('MAIN_K10', cFI_FrameStockRecord_clinker);

  AddMenuModuleItem('MAIN_L01', cFI_FrameTruckQuery);
  AddMenuModuleItem('MAIN_L02', cFI_FrameCusAccountQuery);
  AddMenuModuleItem('MAIN_L03', cFI_FrameCusInOutMoney);
  AddMenuModuleItem('MAIN_L05', cFI_FrameDispatchQuery);
  AddMenuModuleItem('MAIN_L06', cFI_FrameSaleDetailQuery);
  AddMenuModuleItem('MAIN_L07', cFI_FrameSaleTotalQuery);
  AddMenuModuleItem('MAIN_L08', cFI_FrameZhiKaDetail);
  AddMenuModuleItem('MAIN_L09', cFI_FrameOrderDetailQuery); 

  AddMenuModuleItem('MAIN_H01', cFI_FormTruckIn, mtForm);
  AddMenuModuleItem('MAIN_H02', cFI_FormTruckOut, mtForm);
  AddMenuModuleItem('MAIN_H03', cFI_FrameTruckQuery);

  AddMenuModuleItem('MAIN_J01', cFI_FrameTrucks);

  AddMenuModuleItem('MAIN_M01', cFI_FrameProvider);
  AddMenuModuleItem('MAIN_M02', cFI_FrameMaterails);
  AddMenuModuleItem('MAIN_M03', cFI_FrameMakeOCard); 
  AddMenuModuleItem('MAIN_M04', cFI_FrameOrder);
  AddMenuModuleItem('MAIN_M08', cFI_FrameOrderDetail);
  AddMenuModuleItem('MAIN_M09', cFI_FrameOrderBase);
  AddMenuModuleItem('MAIN_M10', cFI_FrameDeduct);
  AddMenuModuleItem('MAIN_M11', cFI_FrameLSCard);
  AddMenuModuleItem('MAIN_M12', cFI_FrameYSLines);
  AddMenuModuleItem('MAIN_M13', cFI_FrameQPoundTemp);

  AddMenuModuleItem('MAIN_W01', cFI_FrameWXAccount);
  AddMenuModuleItem('MAIN_W02', cFI_FrameWXSendLog);
  AddMenuModuleItem('MAIN_W03', cFI_FrameWXBind);
  AddMenuModuleItem('MAIN_S01', cFI_FormAXBaseLoad,mtForm);
  AddMenuModuleItem('MAIN_S02', cFI_FrameUpInfo);
  AddMenuModuleItem('MAIN_S03', cFI_FrameUpPurchase);
  AddMenuModuleItem('MAIN_T01', cFI_FrameSTCard);

  AddMenuModuleItem('MAIN_S04', cFI_FormAXBaseLoadS,mtForm);
  AddMenuModuleItem('MAIN_S05', cFI_FormAXBaseLoadP,mtForm);
end;

//Desc: ����ģ���б�
procedure ClearMenuModuleList;
var nIdx: integer;
begin
  for nIdx:=gMenuModule.Count - 1 downto 0 do
  begin
    Dispose(PMenuModuleItem(gMenuModule[nIdx]));
    gMenuModule.Delete(nIdx);
  end;

  FreeAndNil(gMenuModule);
end;

initialization
  InitMenuModuleList;
finalization
  ClearMenuModuleList;
end.

