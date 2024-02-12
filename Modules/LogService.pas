unit LogService;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, upAnyDataset, FireDAC.Comp.Client;

type
  TLogServiceModule = class(TDataModule)
    Connection: TFDConnection;
    ExecuteScripts: TFDScript;
    ManualWriteTransaction: TFDTransaction;
    dsUpdateVerLogDB: TupAnyDataSet;
    LogDBScripts: TFDScript;
    SpecialScripts: TFDScript;
    MetaInfoQuery: TFDMetaInfoQuery;
    dsGetVerDB: TupAnyDataSet;
    WriteTransaction: TFDTransaction;
    ReadOnlyTransaction: TFDTransaction;
    procedure DataModuleCreate(Sender: TObject);
  private
    FDBPath: String;
    procedure CreateLogDB();
    procedure UpdateLogDB();
    function ConnectBase: Boolean;
    procedure DisconnectBase;
    procedure IncVersion(const NewVer: String);
    procedure CheckParamsSys;
    function IsNotActualDBFile(out CurrentVer: String): Boolean;
  public
    procedure AddLogDefenition();
    procedure CreateAndUpdateDB();
  end;

implementation

uses
  Winapi.Windows, System.Variants;

{$R *.dfm}

procedure TLogServiceModule.CreateAndUpdateDB();
begin
  if not FileExists(FDBPath) then
    CreateLogDB();
  if FileExists(FDBPath) then
  begin
    ConnectBase();
    try
      UpdateLogDB();
    finally
      DisconnectBase();
    end;
  end;
end;

procedure TLogServiceModule.CreateLogDB();
begin
  with Connection.Params do
  begin
    Clear;
    Add('DriverID=FB');
    Add('DataBase=' + FDBPath);
    Add('User_Name=SYSDBA');
    Add('Password=masterkey');
    Add('CharacterSet=WIN1251');
    Add('ExtendedMetadata=True');
    Add('CreateDatabase=Yes');
    Add('Protocol=Local');
    try
      Connection.Open();
      Connection.Close();
    except
      on E: Exception do
      begin
        E.Message := 'Не удалось создать БД лога: ' + E.Message;
        raise E;
      end;
    end;
    Clear();
  end;
end;

procedure TLogServiceModule.UpdateLogDB();
var
  StartScript, I: Integer;
  CurrentVer: String;
begin
  CheckParamsSys();

  if IsNotActualDBFile(CurrentVer) then
  begin
    if CurrentVer = '0' then
      CurrentVer := LogDBScripts.SQLScripts[0].Name;

    if Assigned(LogDBScripts.SQLScripts.FindScript(CurrentVer)) then
    begin
      StartScript := LogDBScripts.SQLScripts.FindScript(CurrentVer).Index;
      for I := StartScript to LogDBScripts.SQLScripts.Count - 1 do
      begin
        ExecuteScripts.Transaction.StartTransaction;
        ExecuteScripts.ExecuteScript(LogDBScripts.SQLScripts[I].SQL);
        if ExecuteScripts.Transaction.Active then
          if ExecuteScripts.TotalErrors = 0 then
            ExecuteScripts.Transaction.Commit
          else
            ExecuteScripts.Transaction.Rollback;
        IncVersion(LogDBScripts.SQLScripts[I].Name);
      end;
    end;
  end;
end;

procedure TLogServiceModule.CheckParamsSys();
begin
  MetaInfoQuery.Open();
  if not MetaInfoQuery.Locate('COLUMN_NAME', VarArrayOf(['TITLE'])) then
  begin
    try
      ExecuteScripts.Transaction.StartTransaction;
      ExecuteScripts.ExecuteScript(SpecialScripts.SQLScripts.FindScript('DropParamsSys').SQL);
      ExecuteScripts.Transaction.Commit;
    except on E: Exception do
      if ExecuteScripts.Transaction.Active then
        ExecuteScripts.Transaction.Rollback;
    end;
  end;
end;

function TLogServiceModule.IsNotActualDBFile(out CurrentVer: String): Boolean;
begin
  try
    dsGetVerDB.CloseOpen();
    CurrentVer := dsGetVerDB.FBN('VERSTR').AsString;
    dsGetVerDB.Close;
  except
    CurrentVer := '0';
  end;
  Result := CurrentVer <> LogDBScripts.SQLScripts.Items[LogDBScripts.SQLScripts.Count - 1].Name;
end;

procedure TLogServiceModule.IncVersion(const NewVer: String);
begin
  try
    dsUpdateVerLogDB.Close;
    dsUpdateVerLogDB.PBN('NEW_VER').AsString := NewVer;
    dsUpdateVerLogDB.ExecSQL;
    dsUpdateVerLogDB.Transaction.Commit;
  except on E: Exception do
    if dsUpdateVerLogDB.Transaction.Active then
      dsUpdateVerLogDB.Transaction.Rollback;
  end;
end;

procedure TLogServiceModule.DataModuleCreate(Sender: TObject);
begin
  FDBPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'LOG.FDB';
end;

procedure TLogServiceModule.AddLogDefenition();
var
  Params: TStringList;
begin
  Params := TStringList.Create;
  try
    Params.Add('DriverID=FB');
    Params.Add('DataBase=' + FDBPath);
    Params.Add('User_Name=SYSDBA');
    Params.Add('Password=masterkey');
    Params.Add('CharacterSet=WIN1251');

    FDManager.AddConnectionDef('LOG', 'FB', Params);
  finally
    FreeAndNil(Params);
  end;
end;

function TLogServiceModule.ConnectBase(): Boolean;
begin
  Connection.Params.Clear();
  Connection.ConnectionDefName := 'LOG';
  try
    Connection.Open();
    Connection.ResourceOptions.AutoReconnect := True;
  except
  end;
  Result := Connection.Connected;
end;

procedure TLogServiceModule.DisconnectBase();
begin
  try
    Connection.Close();
  except
  end;
end;

end.
