unit ViewFile;

interface

uses
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  cxContainer, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Vcl.Dialogs,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, upAnyDataset,
  cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, System.Classes, Vcl.Controls, cxGrid, Vcl.Forms,
  System.SysUtils, NativeXml, System.StrUtils, FireDAC.Phys.IB,
  FireDAC.Phys.IBDef, FireDAC.VCLUI.Wait, HTMLUn2, HtmlView, Winapi.Windows, URLSubs;

type
  TfrmViewFile = class(TForm)
    Connection: TFDConnection;
    ReadTransaction: TFDTransaction;
    DataSet: TupAnyDataSet;
    FindDialog: TFindDialog;
    HtmlViewer: THtmlViewer;
    procedure FindDialogFind(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HtmlViewerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    procedure ViewFile(const AFile: string);
  end;

implementation

{$R *.dfm}

uses
  System.JSON, REST.Json;

{ TfrmViewFile }

procedure TfrmViewFile.ViewFile(const AFile: String);
var
  Stream: TStringStream;
begin
  Stream := TStringStream.Create();
  try
    Stream.WriteString(TJson.Format(TJSONObject.ParseJSONValue(AFile)));
    Stream.Seek(0, soBeginning);
    HtmlViewer.LoadFromStream(Stream, '', TextType);
  finally
    FreeAndNil(Stream);
  end;
end;

procedure TfrmViewFile.FindDialogFind(Sender: TObject);
begin
  with FindDialog do
    if not HtmlViewer.FindEx(FindText, frMatchCase in Options, not (frDown in Options)) then
      Application.MessageBox(PChar(Format('Совпадений с "%s" не найдено!', [FindText])),
        'Сообщение системы', MB_ICONINFORMATION or MB_OK);
end;

procedure TfrmViewFile.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmViewFile.HtmlViewerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and (key = 67) then
    HtmlViewer.CopyToClipboard
  else if (ssCtrl in Shift) and (Key = 70) then
    FindDialog.Execute();
end;

end.
