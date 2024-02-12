unit DBSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, dxBarBuiltInMenu, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxMaskEdit, cxDropDownEdit, cxTextEdit,
  cxLabel, cxGroupBox, cxPC, IniFiles, cxButtonEdit, FireDAC.Phys.MSSQL,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client;

type
  TfrmDBSettings = class(TForm)
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    Label25: TLabel;
    cxGroupBox2: TcxGroupBox;
    cxLabel8: TcxLabel;
    cxLabel9: TcxLabel;
    ServerName: TcxTextEdit;
    Password: TcxTextEdit;
    cxLabel10: TcxLabel;
    UserName: TcxTextEdit;
    cxLabel11: TcxLabel;
    TypeServer: TcxComboBox;
    TypeAuth: TcxComboBox;
    cxLabel12: TcxLabel;
    cxLabel13: TcxLabel;
    Database: TcxTextEdit;
    SerNumberPodpis: TcxTextEdit;
    cxTabSheet2: TcxTabSheet;
    Label16: TLabel;
    TextEditPathCovidService: TcxTextEdit;
    cxTabSheet3: TcxTabSheet;
    Label23: TLabel;
    TextEditSerNumberCovid: TcxTextEdit;
    Pane: TPanel;
    Save: TcxButton;
    Cancel: TcxButton;
    DatabaseFiles: TcxTextEdit;
    cxLabel1: TcxLabel;
    Label1: TLabel;
    PathToKey1: TcxTextEdit;
    Label2: TLabel;
    PathToKey2: TcxTextEdit;
    Label3: TLabel;
    IdentIS: TcxTextEdit;
    btnConnect: TcxButton;
    cxLabel2: TcxLabel;
    FDConnection1: TFDConnection;
    procedure FormShow(Sender: TObject);
    procedure TypeServerPropertiesChange(Sender: TObject);
    procedure TypeAuthPropertiesChange(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDBSettings: TfrmDBSettings;

implementation

{$R *.dfm}
uses HashFunctions;

procedure TfrmDBSettings.btnConnectClick(Sender: TObject);
var
  ParamsList : TStringList;
begin
    ParamsList := TStringList.Create();
    try
      ParamsList.Add('DriverID=MSSQL');
      if (ServerName.Text <> '') and (TypeServer.Text='Удаленный сервер') then
        ParamsList.Add('Server=' + ServerName.Text)
      else
        ParamsList.Add('Server=127.0.0.1');
      if (TypeAuth.Text='MSSQL-сервер') then
        ParamsList.Add('OSAuthent=No')
      else
        ParamsList.Add('OSAuthent=Yes');
//      if Database.Text <> '' then
//        ParamsList.Add('Database=' + Database.Text);
//      if DatabaseFiles.Text <> '' then
//        ParamsList.Add('DatabaseFiles=' + Database.Text);
      if UserName.Text <> '' then
        ParamsList.Add('User_name=' + UserName.Text);
      if Password.Text <> '' then
      ParamsList.Add('Password=' + Password.Text);
      ParamsList.Add('ApplicationName=CAEHR');

      FDConnection1.Params.Assign(ParamsList);
      FDConnection1.Params.Database := 'MIS_KSAMU';
    //FDConnection1.DriverName:='MSSQL';
  //Пробуем подключиться
  try
   cxLabel2.Visible := true;
   FDConnection1.Connected:=true;

   if FDConnection1.Connected then
       cxLabel2.Caption := 'Успешно'
     else
       cxLabel2.Caption := 'Ошибка !';
   except
   on E: EFDDBEngineException do
    case E.Kind of
    ekUserPwdInvalid:
       // user name or password are incorrect
       raise Exception.Create('DBConnection Error. User name or password are incorrect'+
       #13#10+#13#10+E.ClassName+' поднята ошибка, с сообщением : '+E.Message);
    ekUserPwdExpired:
      raise Exception.Create('DBConnection Error. User password is expired'
    +#13#10+#13#10+E.ClassName+' поднята ошибка, с сообщением : '+E.Message);
    ekServerGone:
      raise Exception.Create('DBConnection Error. DBMS is not accessible due to some reason'
      +#13#10+#13#10+E.ClassName+' поднята ошибка, с сообщением : '+E.Message);
    else                // other issues
      raise Exception.Create('DBConnection Error. UnknownMistake'
      +#13#10+#13#10+E.ClassName+' поднята ошибка, с сообщением : '+E.Message);
    end;

    on E : Exception do
      raise Exception.Create(
      E.ClassName+' поднята ошибка, с сообщением : '+#13#10+#13#10+E.Message
      );
   end;

    finally
      FreeAndNil(ParamsList);
    end;
end;


procedure TfrmDBSettings.FormShow(Sender: TObject);
var
  FileOptionsConnect: TIniFile;
begin
  FileOptionsConnect:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'Setup.INI');

  if FileOptionsConnect.ReadString('OptionConnect', 'ServerName', '')=''
  then
    TypeServer.Text:='Локальный сервер (этот компьютер)'
  else
    TypeServer.Text:='Удаленный сервер';
  ServerName.Text:=FileOptionsConnect.ReadString('OptionConnect', 'ServerName', '');
  if FileOptionsConnect.ReadString('OptionConnect', 'AuthType', '')='SERVER'
  then
    TypeAuth.Text:='MSSQL-сервер'
  else
    TypeAuth.Text:='Windows-аутентификация';

  UserName.Text:=DecodingBlowFish(FileOptionsConnect.ReadString('OptionConnect', 'UserName', ''));
  Password.Text:=DecodingBlowFish(FileOptionsConnect.ReadString('OptionConnect', 'Password', ''));
  Database.Text:=FileOptionsConnect.ReadString('OptionConnect', 'Database', 'MIS_KSAMU');
  DatabaseFiles.Text:=FileOptionsConnect.ReadString('OptionConnect', 'DatabaseFiles', 'FileStorage');

  if FileOptionsConnect.ReadString('OptionConnect', 'PathCovidService', '')<>'' then
    TextEditPathCovidService.Text:=FileOptionsConnect.ReadString('OptionConnect', 'PathCovidService', '');
  if FileOptionsConnect.ReadString('OptionConnect', 'SerNumberCovid', '')<>'' then
    TextEditSerNumberCovid.Text:=FileOptionsConnect.ReadString('OptionConnect', 'SerNumberCovid', '');
  if FileOptionsConnect.ReadString('OptionConnect', 'IdentIS', '')<>'' then
    IdentIS.Text:=FileOptionsConnect.ReadString('OptionConnect', 'IdentIS', '');
  if FileOptionsConnect.ReadString('OptionConnect', 'PathToKey1', '')<>'' then
    PathToKey1.Text:=FileOptionsConnect.ReadString('OptionConnect', 'PathToKey1', '');
  if FileOptionsConnect.ReadString('OptionConnect', 'PathToKey2', '')<>'' then
    PathToKey2.Text:=FileOptionsConnect.ReadString('OptionConnect', 'PathToKey2', '');

  FreeAndNil(FileOptionsConnect);
end;

procedure TfrmDBSettings.SaveClick(Sender: TObject);
var
  FileOptionsConnect: TIniFile;
begin
  FileOptionsConnect:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'Setup.INI');

  FileOptionsConnect.WriteString('setupServer', 'DriverID', 'MSSQL');
  if Database.Text <> '' then
    FileOptionsConnect.WriteString('setupServer', 'Database', Database.Text);
  if DatabaseFiles.Text <> '' then
    FileOptionsConnect.WriteString('setupServer', 'DatabaseFiles', DatabaseFiles.Text);
  if TypeServer.Text='Удаленный сервер' then
    FileOptionsConnect.WriteString('setupServer', 'ServerName', ServerName.Text)
  else
    FileOptionsConnect.WriteString('setupServer', 'ServerName', '');

  if TypeAuth.Text='MSSQL-сервер' then
  begin
    FileOptionsConnect.WriteString('setupServer', 'AuthType', 'SERVER');
    if UserName.Text <> '' then
      FileOptionsConnect.WriteString('setupServer', 'UserName', CodingBlowFish(UserName.Text));
    if Password.Text <> '' then
      FileOptionsConnect.WriteString('setupServer', 'Password', CodingBlowFish(Password.Text));
  end
  else
  begin
    FileOptionsConnect.WriteString('setupBD', 'AuthType', 'OSAuth');
  end;

  FileOptionsConnect.WriteString('OptionConnect', 'PathCovidService', TextEditPathCovidService.Text);
  FileOptionsConnect.WriteString('OptionConnect', 'SerNumberCovid', TextEditSerNumberCovid.Text);
  FileOptionsConnect.WriteString('OptionConnect', 'IdentIS', IdentIS.Text);
  FileOptionsConnect.WriteString('OptionConnect', 'PathToKey1', PathToKey1.Text);
  FileOptionsConnect.WriteString('OptionConnect', 'PathToKey2', PathToKey2.Text);

  FreeAndNil(FileOptionsConnect);
end;

procedure TfrmDBSettings.TypeAuthPropertiesChange(Sender: TObject);
begin
  if TypeAuth.Text='MSSQL-сервер' then
  begin
    UserName.Enabled:=True;
    Password.Enabled:=True;
  end
  else
  begin
    UserName.Enabled:=false;
    Password.Enabled:=false;
    UserName.Text:='';
    Password.Text:='';
  end;
end;

procedure TfrmDBSettings.TypeServerPropertiesChange(Sender: TObject);
begin
  if TypeServer.Text='Удаленный сервер' then
    ServerName.Enabled:=True
  else
  begin
    ServerName.Clear;
    ServerName.Enabled:=False;
  end;
end;

end.
