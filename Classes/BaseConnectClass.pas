unit BaseConnectClass;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Option, FireDAC.Stan.Intf, System.SysUtils, upAnyDataset,
  FireDAC.Phys.Intf, Winapi.Windows, MT19937, SQLModule, LogInterfaces, FireDAC.Stan.Param, System.Classes;

type
  TBaseConnectClass = class
  private
    //количество попыток переподключения
    FTryErrorsCount: Integer;
    //компоненты доступа к БД
    FConnection: TFDConnection;
    FConnectionFiles: TFDConnection;
//    FTransactionRead: TFDTransaction;

    //DataSet проверки уникальности ID
    FdsIDExistinTable: TupAnyDataSet;
    //на случай дисконектов БД
    procedure ConnectionAfterConnect(Sender: TObject);
    procedure ConnectionRecover(ASender, AInitiator: TObject; AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
    procedure ConnectionRestored(Sender: TObject);
  protected
    FLog: ILog;
    //дата модуль с SQL запросами
    FSQLModule: TSQLDataModule;
    FTransaction: TFDTransaction;
    FTransactionFiles: TFDTransaction;
    //наши конструктор и деструктор компонентов
    procedure CreateComponents(); virtual;
    procedure DestroyComponents(); virtual;
    //переопределяем логирование, чтобы отдавать только текст ошибки
    procedure Log(const AMessage: String); overload;
    procedure Log(const AOwner, AMessage: String); overload;
    //создаем пишущие и читающие ДатаСеты
//    function CreateDataSet(const SQLScript: String = ''): TupAnyDataSet;
    function CreateDataSet(SQLScript: String = ''; TableName: String = ''; KeyFields: String = ''): TupAnyDataSet;
    function CreateDataSetFiles(SQLScript: String = ''; TableName: String = ''; KeyFields: String = ''): TupAnyDataSet;

    procedure SetReadOnlyContext();
    procedure SetWriteContext();
    //генерим ID
    function GenKey_UIN(const TableName: String): String;
    //получаем собственный ID МО
    function GetSelfKey_UIN(const CODEST, SERVER_NUMBER: String): String;
  public
    //разрешаем всем делать коннект к БД, не только классу наследнику
    function ConnectBase(): boolean;
    function DisconnectBase(): boolean;

    constructor Create();
    destructor Destroy(); override;
  end;

implementation

uses
  Vcl.Forms, LogClass;

const
  StringAllSimbol ='@$:|ёйцукенг34шщзхъфывапролджэ^;ячсмить€бюqwer&tўyuiopasdfghjklzxcvbnm<>_ЙЦУКЕНГШ12№ЩЗХЪФЫВАП—РО™ЛДЖ®ЭЯЧС¤МИ*Т567890«ЬБЮQWERTЁYUI+-=~"`?OPASDFG±HJKLZXCVBNM';
  lengthStringAllSimbol: Word = Length(StringAllSimbol);
  MAX_TRIES = 2;

var
  Generator: TMT19937;

function TBaseConnectClass.GetSelfKey_UIN(const CODEST, SERVER_NUMBER: String): String;
var DataSet: TupAnyDataSet;
begin
  Result := '';
  DataSet := CreateDataSet('select A.ID from MIS_KSAMU.dbo.REF_MO A where A.CODEST = :CODEST and A.NUMBER_P = :NUMBER_P');
  try
    DataSet.PBN('CODEST').AsString := CODEST;
    DataSet.PBN('NUMBER_P').AsString := SERVER_NUMBER;
    DataSet.CloseOpen();
    if DataSet.RecordCount > 0 then
      Result := DataSet.FBN('ID').AsString
    else
      raise Exception.Create('Сервер Медицинской Организации (МО) с кодом МО "' + CODEST + '" и номером сервера "' + SERVER_NUMBER + '" не найден.');
  finally
    FreeAndNil(DataSet);
  end;
end;

procedure TBaseConnectClass.Log(const AMessage: String);
begin
  FLog.AppendRecord(Self.ClassName, 0, 0, AMessage);
end;

procedure TBaseConnectClass.Log(const AOwner, AMessage: String);
begin
  FLog.AppendRecord(AOwner, 0, 0, AMessage);
end;

procedure TBaseConnectClass.SetReadOnlyContext;
begin
  with (FTransaction.Options) do
  begin
    AutoCommit := True;
    AutoStop := True;
    DisconnectAction := TFDTxAction.xdCommit;
    ReadOnly := True;
  end;
  with (FTransactionFiles.Options) do
  begin
    AutoCommit := True;
    AutoStop := True;
    DisconnectAction := TFDTxAction.xdCommit;
    ReadOnly := True;
  end;
end;

procedure TBaseConnectClass.SetWriteContext;
begin
  with (FTransaction.Options) do
  begin
    AutoCommit := False;
    AutoStop := False;
    DisconnectAction := TFDTxAction.xdRollback;
    ReadOnly := False;
  end;
  with (FTransactionFiles.Options) do
  begin
    AutoCommit := False;
    AutoStop := False;
    DisconnectAction := TFDTxAction.xdRollback;
    ReadOnly := False;
  end;
end;

function TBaseConnectClass.ConnectBase: Boolean;
begin
  try
    fConnection.Open();
  except
    on E: Exception do
    begin
      Log('[Error][ConnectBase]: ' + E.Message);
      fConnection.Close;
    end;
  end;
  try
    FConnectionFiles.Open();
  except
    on E: Exception do
    begin
      Log('[Error][ConnectBase]: ' + E.Message);
      FConnectionFiles.Close;
    end;
  end;
  Result := fConnection.Connected and FConnectionFiles.Connected;
end;

function TBaseConnectClass.DisconnectBase: Boolean;
begin
  try
    fConnection.Close;
  except
  end;
  try
    FConnectionFiles.Close;
  except
  end;
  Result := not fConnection.Connected and not FConnectionFiles.Connected;
end;

procedure TBaseConnectClass.ConnectionAfterConnect(Sender: TObject);
begin
  fTryErrorsCount := 0;
end;

procedure TBaseConnectClass.ConnectionRecover(ASender, AInitiator: TObject; AException: Exception; var AAction: TFDPhysConnectionRecoverAction);
begin
  if fTryErrorsCount < MAX_TRIES then
  begin
    AAction := faRetry;
    inc(fTryErrorsCount);
  end
  else
    AAction := faFail;
end;

procedure TBaseConnectClass.ConnectionRestored(Sender: TObject);
begin
  fTryErrorsCount := 0;
end;

constructor TBaseConnectClass.Create();
begin
  FLog := TLogClass.Create();
  CreateComponents();
end;

destructor TBaseConnectClass.Destroy;
begin
  DestroyComponents();
  inherited;
end;

procedure TBaseConnectClass.CreateComponents;
begin
  fConnection := TFDConnection.Create(nil);
  fConnection.ConnectionDefName                 := 'MIS_KSAMU';
  fConnection.LoginPrompt                       := False;
  fConnection.TxOptions.AutoCommit              := False;
  fConnection.TxOptions.AutoStop                := False;
  fConnection.UpdateOptions.CheckReadOnly       := False;
  fConnection.UpdateOptions.UpdateNonBaseFields := False;
  fConnection.UpdateOptions.RefreshMode         := rmAll;
  fConnection.ResourceOptions.AutoReconnect     := True;
  fConnection.FormatOptions.OwnMapRules         := True;
  fConnection.OnRestored                        := ConnectionRestored;
  fConnection.OnRecover                         := ConnectionRecover;
  fConnection.AfterConnect                      := ConnectionAfterConnect;

  FTransaction := TFDTransaction.Create(nil);
  FTransaction.Connection               := fConnection;
  FTransaction.Options.AutoCommit       := False;
  FTransaction.Options.AutoStop         := False;
  FTransaction.Options.DisconnectAction := xdRollback;

  with fConnection.FormatOptions.MapRules.Add do
  begin
    NameMask       := 'IS\_%';
    SourceDataType := dtInt32;
    TargetDataType := dtBoolean;
  end;

  with fConnection.FormatOptions.MapRules.Add do
  begin
    NameMask       := 'IS\_%';
    SourceDataType := dtByte;
    TargetDataType := dtBoolean;
  end;

  with fConnection.FormatOptions.MapRules.Add do
  begin
    NameMask       := 'IS\_%';
    SourceDataType := dtInt16;
    TargetDataType := dtBoolean;
  end;

  fdsIDExistinTable := CreateDataSet();

  FSQLModule := TSQLDataModule.Create(nil);

  FConnectionFiles := TFDConnection.Create(nil);
  FConnectionFiles.ConnectionDefName                 := 'FileStorage';
  FConnectionFiles.LoginPrompt                       := False;
  FConnectionFiles.TxOptions.AutoCommit              := False;
  FConnectionFiles.TxOptions.AutoStop                := False;
  FConnectionFiles.UpdateOptions.CheckReadOnly       := False;
  FConnectionFiles.UpdateOptions.UpdateNonBaseFields := False;
  FConnectionFiles.UpdateOptions.RefreshMode         := rmAll;
  FConnectionFiles.ResourceOptions.AutoReconnect     := True;
  FConnectionFiles.FormatOptions.OwnMapRules         := True;
  FConnectionFiles.OnRestored                        := ConnectionRestored;
  FConnectionFiles.OnRecover                         := ConnectionRecover;
  FConnectionFiles.AfterConnect                      := ConnectionAfterConnect;

  FTransactionFiles := TFDTransaction.Create(nil);
  FTransactionFiles.Connection               := FConnectionFiles;
  FTransactionFiles.Options.AutoCommit       := False;
  FTransactionFiles.Options.AutoStop         := False;
  FTransactionFiles.Options.DisconnectAction := xdRollback;

  with FConnectionFiles.FormatOptions.MapRules.Add do
  begin
    NameMask       := 'IS\_%';
    SourceDataType := dtInt32;
    TargetDataType := dtBoolean;
  end;

  with FConnectionFiles.FormatOptions.MapRules.Add do
  begin
    NameMask       := 'IS\_%';
    SourceDataType := dtByte;
    TargetDataType := dtBoolean;
  end;

  with FConnectionFiles.FormatOptions.MapRules.Add do
  begin
    NameMask       := 'IS\_%';
    SourceDataType := dtInt16;
    TargetDataType := dtBoolean;
  end;
end;


procedure TBaseConnectClass.DestroyComponents;
begin
  FreeAndNil(FSQLModule);
  FreeAndNil(FdsIDExistinTable);
  FreeAndNil(FConnection);
  FreeAndNil(FTransaction);
  FreeAndNil(FConnectionFiles);
  FreeAndNil(FTransactionFiles);
end;


//function TBaseConnectClass.CreateReadDataSet(const SQLScript: String = ''): TupAnyDataSet;
//begin
//  Result := TupAnyDataSet.Create(nil);
//  Result.Connection := fConnection;
//  Result.Transaction := FTransaction;
//  Result.UpdateTransaction := FTransaction;
//  Result.SQL.Text := SQLScript;
////  Result.UpdateOptions.LockMode := lmOptimistic;
//  Result.UpdateOptions.ReadOnly := True;
//end;

function TBaseConnectClass.CreateDataSet(
  SQLScript: String = '';
  TableName: string = '';
  KeyFields: string = ''): TupAnyDataSet;
begin
  Result := TupAnyDataSet.Create(nil);
  Result.Connection := fConnection;
  Result.Transaction := FTransaction;
  Result.UpdateTransaction := FTransaction;
  Result.SQL.Text := SQLScript;
  Result.UpdateOptions.UpdateTableName := TableName;
  Result.UpdateOptions.KeyFields := KeyFields;
  if (TupAnyDacOptionsValue.vnAutoCommit in Result.Options) then
    Result.Options := Result.Options - [TupAnyDacOptionsValue.vnAutoCommit];
end;

function TBaseConnectClass.CreateDataSetFiles(SQLScript, TableName,
  KeyFields: String): TupAnyDataSet;
begin
  Result := TupAnyDataSet.Create(nil);
  Result.Connection := FConnectionFiles;
  Result.Transaction := FTransactionFiles;
  Result.UpdateTransaction := FTransactionFiles;
  Result.SQL.Text := SQLScript;
  Result.UpdateOptions.UpdateTableName := TableName;
  Result.UpdateOptions.KeyFields := KeyFields;
  if (TupAnyDacOptionsValue.vnAutoCommit in Result.Options) then
    Result.Options := Result.Options - [TupAnyDacOptionsValue.vnAutoCommit];
end;

function TBaseConnectClass.GenKey_UIN(const TableName: String): String;
var i: integer;
begin
  Result := '';

  for i := 1 to 16 do
    Result := Result + StringAllSimbol[(Generator.val32 mod lengthStringAllSimbol) + 1];

  if TableName <> '' then
  begin
    fdsIDExistinTable.SQL.Text := 'SELECT ID from ' + TableName + ' WHERE ID = :ID';
    fdsIDExistinTable.PBN('ID').AsString := Result;
    fdsIDExistinTable.CloseOpen;
    if fdsIDExistinTable.RecordCount > 0 then
      Result := GenKey_UIN(TableName);
  end;
end;

initialization
  Generator := TMT19937.Create(Round(Now * 10000000000));

finalization
  if Assigned(Generator) then FreeAndNil(Generator);

end.
