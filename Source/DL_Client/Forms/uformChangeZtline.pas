unit uformChangeZtline;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Menus, StdCtrls, cxButtons, cxLabel, cxTextEdit,
  cxMaskEdit, cxDropDownEdit;

type
  TFormChangeZtLine = class(TForm)
    cbbZtLines: TcxComboBox;
    cxLabel1: TcxLabel;
    btnOk: TcxButton;
    BtnCancel: TcxButton;
    procedure FormShow(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FOldLine:string;
    FNewLine:string;
    FStockno:string;
    Fcenterid:string;
    procedure InitCbbZTlines;
  public
    { Public declarations }
    property OldLine: string read FOldLine write FOldLine;
    property NewLine: string read FnewLine;
    property StockNo: string read FStockno write Fstockno;
    property CenterId: string read Fcenterid write Fcenterid;
  end;

implementation
uses
  UDataModule,USysDB,ULibFun,USysConst;
{$R *.dfm}

procedure TFormChangeZtLine.FormShow(Sender: TObject);
begin
  Caption := '请选择新的装车通道号';
  cbbZtLines.Properties.DropDownListStyle := lsFixedList;
  InitCbbZTlines;
end;

procedure TFormChangeZtLine.InitCbbZTlines;
var
  nStr:string;
  nId,nName:string;
begin
  nStr := 'Select z_id,z_name From %s Where Z_ID<>''%s'' and z_stockno=''%s'' and z_centerid=''%s''';
  nStr := Format(nStr, [sTable_ZTLines, FOldLine,FStockno,Fcenterid]);
  with FDM.QueryTemp(nStr) do
  begin
    while not Eof do
    begin
      nId := FieldByName('z_id').AsString;
      nName := FieldByName('z_name').AsString;
      cbbZtLines.Properties.Items.Add(nid+'='+nName);
      Next;
    end;
  end;
  cbbZtLines.ItemIndex := 0;
end;

procedure TFormChangeZtLine.BtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormChangeZtLine.btnOkClick(Sender: TObject);
var
  nIdx:Integer;
begin
  nIdx := cbbZtLines.ItemIndex;
  if nIdx = -1 then
  begin
    showmsg('请选择',sHint);
    Exit;
  end;
  FNewLine := cbbZtLines.Properties.Items.Names[nidx];
  ModalResult := mrOk;
end;

procedure TFormChangeZtLine.FormCreate(Sender: TObject);
begin
  FOldLine := '';
  FNewLine := '';
  FStockno := '';
  Fcenterid := '';
end;

end.
