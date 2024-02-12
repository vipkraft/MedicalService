unit ViewLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, Vcl.Menus, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.StdCtrls, cxButtons,
  Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, MyGridDBColumn, cxClasses,
  cxGridCustomView, cxGrid, DataModuleLog, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.Client, FireDAC.Comp.DataSet, upAnyDataset,
  System.DateUtils, Vcl.GraphUtil, dxBarBuiltInMenu, cxPC, ViewFile,
  NativeXml, cxEditRepositoryItems, Vcl.Clipbrd, Winapi.ShellAPI, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.VCLUI.Wait;

type
  TfrmViewLog = class(TForm)
    pcLog: TcxPageControl;
    tabLog: TcxTabSheet;
    tabFiles: TcxTabSheet;
    grLog: TcxGrid;
    grLogView: TMyGridDBTableView;
    colServiceName: TMyGridDBColumn;
    colHWND: TMyGridDBColumn;
    colComments: TMyGridDBColumn;
    colDateon: TMyGridDBColumn;
    colColor: TMyGridDBColumn;
    grLogLevel: TcxGridLevel;
    Panel3: TPanel;
    butRefreshLog: TcxButton;
    teLogDateEnd: TcxDateEdit;
    teLogDateStart: TcxDateEdit;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    grFiles: TcxGrid;
    grFilesView: TMyGridDBTableView;
    grFilesViewOWNER: TMyGridDBColumn;
    grFilesViewFILE: TMyGridDBColumn;
    grFilesViewDATEON: TMyGridDBColumn;
    grFilesViewANSWER: TMyGridDBColumn;
    grFilesLevel: TcxGridLevel;
    Panel1: TPanel;
    butRefreshFiles: TcxButton;
    teFilesDateEnd: TcxDateEdit;
    teFilesDateStart: TcxDateEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    teFilesSearch: TcxTextEdit;
    PopupMenuFiles: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    EditRepository: TcxEditRepository;
    TextEditPhone: TcxEditRepositoryMaskItem;
    EditRepositoryMemoItem1: TcxEditRepositoryMemoItem;
    EditRepositoryMemoItem2: TcxEditRepositoryMemoItem;
    EditRepositoryMemoItem3: TcxEditRepositoryMemoItem;
    EditRepositoryMemoItem4: TcxEditRepositoryMemoItem;
    EditRepositoryMemoItem5: TcxEditRepositoryMemoItem;
    LogConnection: TFDConnection;
    ReadOnlyTransaction: TFDTransaction;
    DataSourceLog: TDataSource;
    DataSourceLogFiles: TDataSource;
    dsLog: TupAnyDataSet;
    dsLogFiles: TupAnyDataSet;
    dsGetFile: TupAnyDataSet;
    procedure butRefreshLogClick(Sender: TObject);
//    procedure GridLogStylesGetContentStyle(Sender: TcxCustomGridTableView;
//      ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
    procedure FormCreate(Sender: TObject);
    procedure butRefreshFilesClick(Sender: TObject);
    procedure tabLogShow(Sender: TObject);
    procedure tabFilesShow(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure grFilesViewFILEGetProperties(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AProperties: TcxCustomEditProperties);
    procedure grFilesViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grLogViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    function GetFile(const Id: Integer): string;
    procedure CopyToClipboard(const GridView: TMyGridDBTableView; const AKey: Word; const AShift: TShiftState);
    procedure RefreshLogDates;
    procedure RefreshDatesOfFiles;
  end;

implementation

uses
  GlobalVariables;

{$R *.dfm}

procedure TfrmViewLog.butRefreshLogClick(Sender: TObject);
begin
  RefreshLogDates();

  grLogView.DataController.BeginUpdate();
  try
    dsLog.PBN('DATESTART').AsDateTime := teLogDateStart.Date;
    dsLog.PBN('DATEEND').AsDateTime := teLogDateEnd.Date;
    dsLog.CloseOpen();
  finally
    grLogView.DataController.EndUpdate();
  end;

  grLogView.Controller.FocusRecord(grLogView.DataController.RecordCount - 1, True);
end;

procedure TfrmViewLog.butRefreshFilesClick(Sender: TObject);
begin
  RefreshDatesOfFiles();

  grFilesView.Controller.BeginUpdate();
  try
    if teFilesSearch.Text = '' then
      TupAnyDataSet(grFilesView.DataController.DataSet).MainWhereClause := 'RF.DATEON between :DATESTART and :DATEEND'
    else
    begin
      TupAnyDataSet(grFilesView.DataController.DataSet).MainWhereClause := 'RF.DATEON between :DATESTART and :DATEEND and upper(RF.XML_FILE) like ''%'' || upper(:PART_FILE) || ''%''';
      TupAnyDataSet(grFilesView.DataController.DataSet).PBN('PART_FILE').AsString := teFilesSearch.Text;
    end;

    dsLogFiles.PBN('DATESTART').AsDateTime := teFilesDateStart.Date;
    dsLogFiles.PBN('DATEEND').AsDateTime := teFilesDateEnd.Date;
    dsLogFiles.Open;
  finally
    grFilesView.Controller.EndUpdate;
  end;

  grFilesView.Controller.FocusRecord(grFilesView.DataController.RecordCount - 1, True);
end;

procedure TfrmViewLog.RefreshLogDates();
begin
  if (teLogDateStart.Date = -700000) then
    teLogDateStart.Date := StartOfTheDay(IncDay(Now, -2));
  if (teLogDateEnd.Date = -700000) then
    teLogDateEnd.Date := EndOfTheDay(Now);
end;

procedure TfrmViewLog.RefreshDatesOfFiles();
begin
  if (teFilesDateStart.Date = -700000) then
    teFilesDateStart.Date := StartOfTheDay(IncDay(Now, -1));
  if (teFilesDateEnd.Date = -700000) then
    teFilesDateEnd.Date := EndOfTheDay(Now);
end;

procedure TfrmViewLog.tabLogShow(Sender: TObject);
begin
  RefreshLogDates();
end;

procedure TfrmViewLog.tabFilesShow(Sender: TObject);
begin
  RefreshDatesOfFiles();
end;

procedure TfrmViewLog.FormCreate(Sender: TObject);
begin
  grLogView.DataController.DataSource := DataSourceLog;
  grFilesView.DataController.DataSource := DataSourceLogFiles;

  pcLog.ActivePage := tabFiles;

  LogConnection.Open();
end;

//procedure TfrmViewLog.GridLogStylesGetContentStyle(Sender: TcxCustomGridTableView; ARecord: TcxCustomGridRecord; AItem: TcxCustomGridTableItem; var AStyle: TcxStyle);
//var
//  Color: String;
//begin
//  if (ARecord = nil) or (AItem = nil) or not ARecord.IsData or
//    VarIsNull(ARecord.Values[colColor.Index])then
//    Exit;
//
//  if not Assigned(AStyle) then
//    AStyle := TcxStyle.Create(Sender);
//  Color := IntToStr(WebColorToRGB(ARecord.Values[colColor.Index]));
//
//  if not Assigned(FDMLog.StylesRep.FindComponent('Style' + Color)) then
//    FDMLog.CreateStyle(Color);
//
//  AStyle := FDMLog.StylesRep.FindComponent(Color) as TcxStyle;
//end;

procedure TfrmViewLog.grLogViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  CopyToClipboard(grLogView, Key, Shift);
end;

function TfrmViewLog.GetFile(const Id: Integer): string;
begin
  Result := '';

  dsGetFile.PBN('ID').AsInteger := Id;
  dsGetFile.Open();
  if dsGetFile.RecordCount > 0 then
    Result := dsGetFile.FBN('FILE').AsString;
  dsGetFile.Close();
end;

procedure TfrmViewLog.grFilesViewFILEGetProperties(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AProperties: TcxCustomEditProperties);
begin
  AProperties := EditRepositoryMemoItem5.Properties;
end;

procedure TfrmViewLog.CopyToClipboard(const GridView: TMyGridDBTableView; const AKey: Word; const AShift: TShiftState);
begin
  if (ssCtrl in AShift) and ((AKey = Ord('C')) or (AKey = Ord('Ñ'))) then
    Clipboard.AsText := GridView.Controller.FocusedRecord.Values[GridView.Controller.FocusedItem.Index];
end;

procedure TfrmViewLog.grFilesViewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CopyToClipboard(grFilesView, Key, Shift);
end;

procedure TfrmViewLog.N1Click(Sender: TObject);
var
  Child: TfrmViewFile;
begin
  if grFilesView.Controller.SelectedRowCount = 0 then
    Exit;
  Child := TfrmViewFile.Create(nil);
  Child.ViewFile(GetFile(dsLogFiles.FBN('ID').AsInteger));
  Child.ShowModal;
end;

procedure TfrmViewLog.N2Click(Sender: TObject);
begin
  if grFilesView.Controller.SelectedRowCount = 0 then
    Exit;

  if not DirectoryExists(ExeDir + 'LogFiles') then
    ForceDirectories(ExeDir + 'LogFiles');

  dsGetFile.PBN('ID').AsInteger := (grFilesView.DataController.DataSet as TupAnyDataSet).FBN('ID').AsInteger;
  dsGetFile.CloseOpen;
  if dsGetFile.RecordCount > 0 then
    TBlobField(dsGetFile.FBN('FILE')).SaveToFile(
      ExeDir + 'LogFiles\' + VarToStrDef(grFilesView.Controller.FocusedRecord.Values[grFilesViewOWNER.Index], 'File')
      + ' ' + FormatDateTime('dd.mm.yy hh-mm-ss', VarToDateTime(grFilesView.Controller.FocusedRecord.Values[grFilesViewDATEON.Index])) + '.xml'
    );
  dsGetFile.Close;

  ShellExecute(0, 'open', PChar(ExeDir + 'LogFiles'), '', '', SW_NORMAL);
end;

end.
