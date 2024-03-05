unit Main;

interface

uses
  System.Classes, System.SysUtils, Vcl.Graphics, Vcl.Controls, Vcl.Forms, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxControls, cxContainer, cxEdit, cxTextEdit, Vcl.Dialogs,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Phys.MSSQLDef, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSSQL,
  FireDAC.Stan.Intf, FireDAC.Comp.UI, IPPeerClient, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  System.ImageList, Vcl.ImgList, AdvMenus, Vcl.ExtCtrls, System.StrUtils, Winapi.Windows, Winapi.TlHelp32, SendClass, SendVac;
//  IdHTTPWebBrokerBridge;

type
  TSenCovidThread = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

  TMainForm = class(TForm)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    MainMenu: TMainMenu;
    N1: TMenuItem;
    NLogs: TMenuItem;
    N3: TMenuItem;
    NCloseService: TMenuItem;
    NStartService: TMenuItem;
    N6: TMenuItem;
    NSetting: TMenuItem;
    TrayIcon: TTrayIcon;
    PopupMenuTray: TAdvPopupMenu;
    CloseServer: TMenuItem;
    TrayRazdelitel: TMenuItem;
    StopServer: TMenuItem;
    OnlineServer: TMenuItem;
    ImageList: TImageList;
    ImageListTray: TImageList;
    TimerUpdate: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure NCloseServiceClick(Sender: TObject);
    procedure NLogsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NStartServiceClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure CloseServerClick(Sender: TObject);
    procedure TimerUpdateTimer(Sender: TObject);
    procedure OnlineServerClick(Sender: TObject);
    procedure StopServerClick(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure TrayIconMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NSettingClick(Sender: TObject);
  private
//    FServer: TIdHTTPWebBrokerBridge;
    IS_SEND: Boolean;
    procedure LoadParams();
  public
    { Public declarations }
    Child: TSendClass;

  end;

var
  MainForm: TMainForm;

implementation

uses
  LogService, System.RegularExpressions, System.IniFiles,
  FireDAC.Comp.Client,
//   RosVacCOVID,
   HashFunctions, ViewLog, DBSettings, ServiceConstants;

{$R *.dfm}


function KillTask(ExeFileName: string): integer;
const PROCESS_TERMINATE=$0001;
var ContinueLoop: BOOL;
     FSnapshotHandle: THandle;
     FProcessEntry32: TProcessEntry32;
begin
  result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot (TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while integer(ContinueLoop)<> 0 do
   begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExeFileName)) or
       (UpperCase(FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
     Result := Integer(TerminateProcess(OpenProcess( PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID), 0));
     ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);end;
     CloseHandle(FSnapshotHandle);
end;

procedure TMainForm.CloseServerClick(Sender: TObject);
begin
  KillTask('COVID_19.exe');
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  MainForm.Visible:=False;
  CanClose:=False;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  LogService: TLogServiceModule;
  Options: TIniFile;
  ParamsList: TStringList;
  ServerName: String;
begin
FormatSettings.ShortDateFormat := 'yyyy-mm-dd';
FormatSettings.DateSeparator := '-';
FormatSettings.LongTimeFormat := 'hh:nn:ss';
FormatSettings.TimeSeparator := ':';
  LogService := TLogServiceModule.Create(Application);
  try
    LogService.AddLogDefenition();
    LogService.CreateAndUpdateDB();
  finally
    FreeAndNil(LogService);
  end;

  Options := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Setup.ini');
  try
    ParamsList := TStringList.Create();
    try
      ParamsList.Add('DriverID=' + Options.ReadString('OptionConnect', 'DriverID', 'MSSQL'));
      ServerName := Options.ReadString('OptionConnect', 'ServerName', '');
      if ServerName = '' then
        ServerName := '(local)';
      ParamsList.Add('Server=' + ServerName);
      ParamsList.Add('Database=' + Options.ReadString('OptionConnect', 'Database', ''));

      if Options.ReadString('OptionConnect', 'AuthType', '') = 'OSAuth' then
        ParamsList.Add('OSAuthent=Yes')
      else
        ParamsList.Add('OSAuthent=No');

      ParamsList.Add('User_name=' + DecodingBlowFish(Options.ReadString('OptionConnect', 'UserName', '')));
      ParamsList.Add('Password=' + DecodingBlowFish(Options.ReadString('OptionConnect', 'Password', '')));
      ParamsList.Add('ApplicationName=CAEHR');

      FDManager.AddConnectionDef('MIS_KSAMU', 'MSSQL', ParamsList);
      FDManager.AddConnectionDef('FileStorage', 'MSSQL', ParamsList);
    finally
      FreeAndNil(ParamsList);
    end;
  finally
    FreeAndNil(Options);
  end;

  LoadParams();
//  FServer := TIdHTTPWebBrokerBridge.Create(nil);
//  FServer.RegisterWebModuleClass(TRestWM);
//  FServer.Bindings.Clear;
//  FServer.DefaultPort := 65432;
//  FServer.Bindings.Add;
//  FServer.MaxConnections := 10;
//  FServer.Active := True;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
//  FreeAndNil(FServer);
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  i: Integer;
begin
  for i := 1 to ParamCount do
  begin
    if LeftStr(ParamStr(i), 2)='-S' then
    begin
      NStartService.Click;
    end;
  end;
  TrayIcon.Visible:=True;
end;

procedure TMainForm.NLogsClick(Sender: TObject);
var
  ChildForm: TfrmViewLog;
begin
  ChildForm := TfrmViewLog.Create(Self);
  try
    ChildForm.ShowModal();
  finally
    FreeAndNil(ChildForm);
  end;
end;

procedure TMainForm.NCloseServiceClick(Sender: TObject);
begin
  Application.Terminate();
  Application.ProcessMessages();
end;

procedure TMainForm.NSettingClick(Sender: TObject);
var
  ChildForm: TfrmDBSettings;
begin
  ChildForm := TfrmDBSettings.Create(Self);
  try
    ChildForm.ShowModal();
  finally
    FreeAndNil(ChildForm);
  end;
end;

procedure TMainForm.NStartServiceClick(Sender: TObject);
begin
  LoadParams();
  TimerUpdate.Enabled:=True;
end;

procedure TMainForm.LoadParams();
var
  Options: TIniFile;
begin
  Options := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Setup.ini');
  PathCovidService:= Options.ReadString('OptionConnect', 'PathCovidService', 'https://ips.egisz.rosminzdrav.ru/8e05a39d5d5c9');
  SerNumberCovid:=Options.ReadString('OptionConnect', 'SerNumberCovid', '10');
  IdentIS:=Options.ReadString('OptionConnect', 'IdentIS', '');
  PathToKey1:=Options.ReadString('OptionConnect', 'PathToKey1', 'Keys/Key1.cer');
  PathToKey2:=Options.ReadString('OptionConnect', 'PathToKey2', 'Keys/Key2.cer');
  FreeAndNil(Options);
end;

procedure TMainForm.OnlineServerClick(Sender: TObject);
begin
  if Assigned(Child) then
    Child.Free();
  TimerUpdate.Enabled:=True;
end;

procedure TMainForm.StopServerClick(Sender: TObject);
begin
  Child.Free();
  TimerUpdate.Enabled:=False;
end;

procedure TMainForm.TimerUpdateTimer(Sender: TObject);
var
  TSenCovid: TSenCovidThread;
begin
  TimerUpdate.Enabled:=False;
  if IS_SEND = false then
  begin
    IS_SEND:=True;
    TSenCovid:=TSenCovidThread.Create;
  end;
  TimerUpdate.Enabled:=True;
end;

procedure TMainForm.TrayIconClick(Sender: TObject);
begin
  MainForm.Visible:=True;
  MainForm.WindowState:=wsNormal;
end;

procedure TMainForm.TrayIconMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Assigned(Child)) or (TimerUpdate.Enabled=true) then
    TrayIcon.Hint:= 'Выгрузка работает'
   else
    TrayIcon.Hint:= 'Сервис остановлен';
end;

{ TSenCovidThread }

procedure TSenCovidThread.Execute;
var
  Child: TSendClass;
//  Child : TSendVac;
begin
  inherited;
  Child := TSendClass.Create();
//    Child := TSendVac.Create();
  try
   Child.Send();
//    Child.sendone();
//    Child.updateone();
  finally
    Child.Free();
  end;

  MainForm.IS_SEND:=False;
end;

end.
