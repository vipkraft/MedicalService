unit DataModuleLog;

interface

uses
  Windows, SysUtils, Classes, Controls, IniFiles, ExtCtrls, cxStyles,
  RekvizitTypes, FireDAC.Stan.Intf, Vcl.Forms,
  FireDAC.Stan.Option, FireDAC.Phys.Intf, FireDAC.Stan.Param,
  Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet, upAnyDataset,
  FireDAC.Comp.UI, FireDAC.Phys.IB, System.DateUtils, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.VCLUI.Wait, cxClasses, NativeXml,
  FireDAC.Comp.ScriptCommands, FireDAC.Comp.Script, System.Variants,
  FireDAC.Phys.IBDef, FireDAC.Stan.Util, FireDAC.Phys.IBBase,
  FireDAC.Phys.FBDef, FireDAC.Phys.FB;

type
  TDMLog = class(TDataModule)
    Connection: TFDConnection;
    dsWriteServices: TupAnyDataSet;
    WriteTransaction: TFDTransaction;
    dsWriteFile: TupAnyDataSet;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ConnectionRecover(ASender, AInitiator: TObject; AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
    procedure ConnectionRestored(Sender: TObject);
    procedure ConnectionAfterConnect(Sender: TObject);
  private
    FConnectCount: Integer;
    function ConnectBase(): Boolean;
    procedure DisconnectBase();
  public
    procedure AppendRecord(ServiceName: String; Color: Cardinal; Handle: HWND; Comment: String);
    procedure AddFile(OwnerName, AFile, Answer: String);
  end;

implementation

{$R *.dfm}

{ TDMLog }

procedure TDMLog.DataModuleCreate(Sender: TObject);
begin
  ConnectBase();
end;

procedure TDMLog.DataModuleDestroy(Sender: TObject);
begin
  DisconnectBase();
end;

function TDMLog.ConnectBase(): Boolean;
begin
  Connection.ConnectionDefName := 'LOG';
  try
    Connection.Open();
    Connection.ResourceOptions.AutoReconnect := True;
  except
  end;
  Result := Connection.Connected;
end;

procedure TDMLog.DisconnectBase();
begin
  try
    Connection.Close();
  except
  end;
end;

procedure TDMLog.ConnectionAfterConnect(Sender: TObject);
begin
  FConnectCount := 0;
end;

procedure TDMLog.ConnectionRecover(ASender, AInitiator: TObject; AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
begin
  if FConnectCount < 50 then
  begin
    AAction := faRetry;
    inc(FConnectCount);
  end
  else
    AAction := faFail;
end;

procedure TDMLog.ConnectionRestored(Sender: TObject);
begin
  FConnectCount := 0;
end;

//------------------------------------------------------------------------------
procedure TDMLog.AddFile(OwnerName, AFile, Answer: String);
begin
  try
    dsWriteFile.Close;
    dsWriteFile.PBN('OWNER_NAME').AsString := OwnerName;
    dsWriteFile.PBN('XML_FILE').AsString := AFile;
    dsWriteFile.PBN('ANSWER').AsString := Answer;
    dsWriteFile.ExecSQL;
    if dsWriteFile.Transaction.Active then
      dsWriteFile.Transaction.Commit;
  except
    if dsWriteFile.Transaction.Active then
      dsWriteFile.Transaction.Rollback;
  end;
end;

procedure TDMLog.AppendRecord(ServiceName: String; Color: Cardinal; Handle: HWND; Comment: String);
begin
  try
    dsWriteServices.Close;
    dsWriteServices.PBN('DATEON').AsDateTime     := Now;
    dsWriteServices.PBN('SERVICE_NAME').AsString := ServiceName;
    dsWriteServices.PBN('COLOR').AsLongword      := Color;
    dsWriteServices.PBN('HWND').AsInteger        := Handle;
    dsWriteServices.PBN('COMMENT').AsString      := Comment;
    dsWriteServices.ExecSQL;
    if dsWriteServices.Transaction.Active then
      dsWriteServices.Transaction.Commit;
    dsWriteServices.Close;
  except
    if dsWriteServices.Transaction.Active then
      dsWriteServices.Transaction.Rollback;
  end;
end;

end.
