unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  cxControls, cxContainer, cxEdit, dxCore, cxDateUtils, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxNavigator,
  Data.DB, cxDBData, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client, cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, Vcl.StdCtrls, cxButtons,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, upAnyDataset, cxImageComboBox,
  cxGridBandedTableView, cxGridDBBandedTableView, MyGridDBColumn, cxCheckBox, cxRichEdit, cxPropertiesStore;

type
  TSendCode = (scGet = 3, scDel = 4);

  TForm5 = class(TForm)
    PageControl1: TPageControl;
    tsUpload: TTabSheet;
    pConfigView: TPanel;
    cxBtnRefresh: TcxButton;
    cxLblDataBy: TcxLabel;
    cxDtEFrom: TcxDateEdit;
    cxLblDataFrom: TcxLabel;
    cxDtEBy: TcxDateEdit;
    MSSQLConnection: TFDConnection;
    Transaction: TFDTransaction;
    dsCOVID19: TupAnyDataSet;
    DataSourceCOVID19: TDataSource;
    cxBtnRepeatUpload: TcxButton;
    cxGridCovid19Level: TcxGridLevel;
    cxGridCovid19: TcxGrid;
    cxGridCovid19DBTableView: TMyGridDBTableView;
    cxGridCovid19ColRepeatUpload: TMyGridDBColumn;
    cxGridCovid19ColDateEdit: TMyGridDBColumn;
    GridCovid19DateUpload: TMyGridDBColumn;
    cxGridCovid19ColDateEditSended: TMyGridDBColumn;
    cxGridCovid19ColResSended: TMyGridDBColumn;
    cxGridCovid19ColMessage: TMyGridDBColumn;
    cxGridCovid19ColDateDoc: TMyGridDBColumn;
    cxGridCovid19ColTitle: TMyGridDBColumn;
    cxGridCovid19ColTypeSend: TMyGridDBColumn;
    cxCheckBox1: TcxCheckBox;
    cxGridCovid19DBUIN: TMyGridDBColumn;
    GroupBox1: TGroupBox;
    cxGridHistoryUpload: TcxGrid;
    MyGridDBHistoryUpload: TMyGridDBTableView;
    cxGridLevelHistoryUpload: TcxGridLevel;
    MyGridDBHistoryUploadDATE_SEND: TMyGridDBColumn;
    dsHistoryUpload: TupAnyDataSet;
    DataSourceHistoryUpload: TDataSource;
    MyGridDBHistoryUploadUIN: TMyGridDBColumn;
    MyGridDBHistoryUploadIS_REPEAT_UPLOAD: TMyGridDBColumn;
    MyGridDBHistoryUploadDATE_LAST_EDIT: TMyGridDBColumn;
    MyGridDBHistoryUploadMESSAGE: TMyGridDBColumn;
    MyGridDBHistoryUploadUIN_SYNC: TMyGridDBColumn;
    MyGridDBHistoryUploadSEND_STATUS: TMyGridDBColumn;
    MyGridDBHistoryUploadTYPE_SEND_TITLE: TMyGridDBColumn;
    MyGridDBHistoryUploadTYPE_SEND_COD: TMyGridDBColumn;
    GridCovid19DB_ID: TMyGridDBColumn;
    GridCovid19DB_UIN_Last: TMyGridDBColumn;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    btnRefreshGet: TcxButton;
    cxLabel1: TcxLabel;
    cxDateGetFrom: TcxDateEdit;
    cxLabel2: TcxLabel;
    cxDateGetBy: TcxDateEdit;
    cxButton2: TcxButton;
    GridCOVID19Get: TcxGrid;
    GridDBCOVID19Get: TMyGridDBTableView;
    GridDBCOVID19Get_CovidID: TMyGridDBColumn;
    GridDBCOVID19Get_IsRepUpload: TMyGridDBColumn;
    GridDBCOVID19Get_DateLastEdit: TMyGridDBColumn;
    GridDBCOVID19Get_DateSend: TMyGridDBColumn;
    GridDBCOVID19Get_DateLastEditSended: TMyGridDBColumn;
    GridDBCOVID19GetSendStatus: TMyGridDBColumn;
    GridDBCOVID19Get_TypeSendedTitle: TMyGridDBColumn;
    GridDBCOVID19Get_Message: TMyGridDBColumn;
    GridDBCOVID19Get_DateDoc: TMyGridDBColumn;
    GridDBCOVID19Get_Title: TMyGridDBColumn;
    GridDBCOVID19Get_UIN: TMyGridDBColumn;
    GridDBCOVID19Get_UinLast: TMyGridDBColumn;
    GridLevelCOVID19Get: TcxGridLevel;
    dsCOVID19Get: TupAnyDataSet;
    DataSourceCOVID19Get: TDataSource;
    btnGetRecord: TcxButton;
    dsCreateRequest: TupAnyDataSet;
    GridGetHistory: TcxGrid;
    GridDBGetHistory: TMyGridDBTableView;
    GridDBGetHistory_DateSend: TMyGridDBColumn;
    GridDBGetHistory_UIN: TMyGridDBColumn;
    GridDBGetHistoryDateLastEdit: TMyGridDBColumn;
    GridDBGetHistoryMessage: TMyGridDBColumn;
    GridDBGetHistoryUINSync: TMyGridDBColumn;
    GridDBGetHistorySendStatus: TMyGridDBColumn;
    GridDBGetHistoryTypeSendTitle: TMyGridDBColumn;
    GridDBGetHistoryTypeSendCod: TMyGridDBColumn;
    GridLevelGetHistory: TcxGridLevel;
    DataSourceGetHistory: TDataSource;
    dsGetHistory: TupAnyDataSet;
    GridCovid19DB_IsAnswered: TMyGridDBColumn;
    MyGridDBHistoryUploadIS_ANSWERED: TMyGridDBColumn;
    btnDel: TcxButton;
    GridCovid19DBlast_Send_title: TMyGridDBColumn;
    GridCovid19DBPARENT_DOC_COVID: TMyGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure cxBtnRefreshClick(Sender: TObject);
    procedure cxBtnRepeatUploadClick(Sender: TObject);
    procedure cxGridCovid19DBTableViewStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
      AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure cxCheckBox1PropertiesEditValueChanged(Sender: TObject);
    procedure cxGridCovid19DBTableViewFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
    procedure btnRefreshGetClick(Sender: TObject);
    procedure btnGetRecordClick(Sender: TObject);
    procedure GridDBCOVID19GetFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
    procedure btnDelClick(Sender: TObject);
  private
    cxStyleYellow: TcxStyle;
    cxStyleGreen: TcxStyle;
    cxStyleLightRed: TcxStyle;
    cxStyleReLoad: TcxStyle;


    procedure CreateRequestByRegister(SendCode: TSendCode);
    procedure IsShowAll(val: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

uses System.DateUtils, common;

{$R *.dfm}

procedure TForm5.btnDelClick(Sender: TObject);
begin
  CreateRequestByRegister(scDel);
end;

procedure TForm5.btnGetRecordClick(Sender: TObject);
begin
  CreateRequestByRegister(scGet);
end;

procedure TForm5.btnRefreshGetClick(Sender: TObject);
begin
  dsCOVID19Get.PBN('DATE_FROM').AsDateTime := cxDateGetFrom.Date;
  dsCOVID19Get.PBN('DATE_BY').AsDateTime := cxDateGetBy.Date;
  dsCOVID19Get.CloseOpen();
end;

procedure TForm5.CreateRequestByRegister(SendCode: TSendCode);
const
  SQLText = 'SELECT rec.ID FROM MIS_KSAMU.dbo.REG_EXTERNAL_COVID rec '
          + 'INNER JOIN MIS_KSAMU.dbo.REF_COVID_TYPE_SEND rc ON rc.ID = rec.TYPE_SENDED '
          + 'WHERE OWNER = :OWNER AND DATE_SEND IS NULL AND rc.CODE = :SEND_CODE';
var
  sTemp: string;
  dsTempSelect: TupAnyDataSet;
begin
  if cxGridCovid19DBTableView.DataController.RecNo = -1 then
    Exit;

  if cxGridCovid19DBUIN.EditValue = null then
  begin
    if SendCode = scGet then
      sTemp := 'Запросить'
    else
      sTemp := 'Удалить';
    ShowMessage(Format('%s регистровую запись возможно только для выгруженных документов', [sTemp]));
    Exit;
  end;

  dsTempSelect := TupAnyDataSet.Create(nil);
  try
    dsTempSelect.Transaction := Transaction;
    dsTempSelect.Connection := MSSQLConnection;
    dsTempSelect.SQL.Text := SQLText;
    dsTempSelect.PBN('OWNER').AsString := GridCovid19DB_ID.EditValue;
    dsTempSelect.PBN('SEND_CODE').AsInteger := Integer(SendCode);
    dsTempSelect.CloseOpen();

    if dsTempSelect.RecordCount > 0 then
    begin
      if SendCode = scGet then
        sTemp := 'Получение'
      else
        sTemp := 'Удаление';
      ShowMessage(Format('Для регистровой записи уже есть запрос на "%s" в очереди', [sTemp]));
      Exit;
    end;
  finally
    FreeAndNil(dsTempSelect);
  end;

  dsCreateRequest.Params.ClearValues();
  dsCreateRequest.PBN('ID').AsString := GenKey_UIN();
  dsCreateRequest.PBN('OWNER').AsString := GridCovid19DB_ID.EditValue;
  dsCreateRequest.PBN('SEND_CODE').AsInteger := Integer(SendCode);
  dsCreateRequest.ExecSQL();
end;

procedure TForm5.cxBtnRefreshClick(Sender: TObject);
begin
  dsCOVID19.PBN('DATE_FROM').AsDateTime := cxDtEFrom.Date;
  dsCOVID19.PBN('DATE_BY').AsDateTime := cxDtEBy.Date;
  IsShowAll(cxCheckBox1.Checked);
  dsCOVID19.CloseOpen();
end;

procedure TForm5.cxBtnRepeatUploadClick(Sender: TObject);
begin
  if (cxGridCovid19DBTableView.DataController.RecNo = -1)
   { or (cxGridCovid19ColIsAnswered.EditValue = 1) }then
    Exit;

  cxGridCovid19DBTableView.EditData;
  cxGridCovid19ColRepeatUpload.EditValue := 1;
  cxGridCovid19DBTableView.PostDate;
  if Transaction.Active then
      Transaction.Commit;
  Exit;


  cxGridCovid19DBTableView.BeginUpdate();
  try
    cxGridCovid19ColRepeatUpload.EditValue := 1;
  finally
    cxGridCovid19DBTableView.EndUpdate;

    if Transaction.Active then
      Transaction.Commit;
  end;
end;

procedure TForm5.cxCheckBox1PropertiesEditValueChanged(Sender: TObject);
begin
  IsShowAll(cxCheckBox1.Checked);
  dsCOVID19.Refresh();
end;

procedure TForm5.cxGridCovid19DBTableViewFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  dsHistoryUpload.PBN('OWNER').AsString := dsCOVID19.FBN('COVID_ID').AsString;
  dsHistoryUpload.CloseOpen();
end;

procedure TForm5.cxGridCovid19DBTableViewStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord;
  AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
begin
  if not ARecord.IsData then // Проверка на то что строка не является группой
    exit;

  // если не выгружен, то ни как не подсвечиваем
  if ARecord.Values[GridCovid19DateUpload.Index] = null then
    exit;

  if ARecord.Values[cxGridCovid19ColRepeatUpload.Index] = 1 then  /// на перевыгрузку
  begin
    AStyle := cxStyleReLoad;
    Exit;
  end;

  if not VarIsNull(ARecord.Values[GridCovid19DB_IsAnswered.Index]) and (ARecord.Values[GridCovid19DB_IsAnswered.Index] = 0) then
  begin
    AStyle := cxStyleYellow;
    Exit;
  end;

  if (ARecord.Values[GridCovid19DB_UIN_Last.Index] <> null) // сначала смотрим, если присвоен номер в регистре
      or ( not VarIsNull(ARecord.Values[GridCovid19DB_IsAnswered.Index]) and (ARecord.Values[GridCovid19DB_IsAnswered.Index] = 1)
          and VarIsNull(ARecord.Values[cxGridCovid19ColMessage.Index])) then // или ответ принят с пустум сообщением, то все гуд
    AStyle := cxStyleGreen
  else
    AStyle := cxStyleLightRed;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  MSSQLConnection.Open();
  cxDtEFrom.Date := Date() - 2;
  cxDtEBy.Date := EndOfTheDay(Date());

  cxDateGetFrom.Date := Date() - 2;
  cxDateGetBy.Date := EndOfTheDay(Date());

  cxStyleYellow := TcxStyle.Create(self);
  cxStyleYellow.Color := clYellow;
  cxStyleGreen := TcxStyle.Create(self);
  cxStyleGreen.Color := clMoneyGreen;
  cxStyleLightRed := TcxStyle.Create(self);
  cxStyleLightRed.Color := clWebPaleVioletRed; //clWebOrangeRed;
  cxStyleReLoad := TcxStyle.Create(self);
  cxStyleReLoad.Color := clOlive;
end;

procedure TForm5.GridDBCOVID19GetFocusedRecordChanged(Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  dsGetHistory.PBN('OWNER').AsString := dsCOVID19Get.FBN('COVID_ID').AsString;
  dsGetHistory.CloseOpen();
end;

procedure TForm5.IsShowAll(val: Boolean);
begin
  if val then
    dsCOVID19.PBN('Show_ALL').AsInteger := 0
  else
    dsCOVID19.PBN('Show_ALL').AsInteger := 1;
end;

end.
