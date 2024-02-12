program COVID_19;

uses
  Vcl.Forms,
  Main in 'Main.pas' {MainForm},
  SendClass in 'Classes\SendClass.pas',
  LogClass in 'Classes\LogClass.pas',
  DataModuleLog in 'Modules\DataModuleLog.pas' {DMLog: TDataModule},
  LogInterfaces in 'Interfaces\LogInterfaces.pas',
  LogService in 'Modules\LogService.pas' {LogServiceModule: TDataModule},
  RESTer in 'Classes\RESTer.pas',
  SQLModule in 'Modules\SQLModule.pas' {SQLDataModule: TDataModule},
  MT19937 in 'Other\MT19937.pas',
  BaseConnectClass in 'Classes\BaseConnectClass.pas',
  HashFunctions in 'Other\HashFunctions.pas',
  ViewFile in 'Forms\ViewFile.pas' {frmViewFile},
  ViewLog in 'Forms\ViewLog.pas' {frmViewLog},
  GlobalVariables in 'Other\GlobalVariables.pas',
  JWTGenerator in 'Other\JWTGenerator.pas',
  JOSE.Builder in 'Other\JOSE\JOSE.Builder.pas',
  JOSE.Consumer in 'Other\JOSE\JOSE.Consumer.pas',
  JOSE.Consumer.Validators in 'Other\JOSE\JOSE.Consumer.Validators.pas',
  JOSE.Context in 'Other\JOSE\JOSE.Context.pas',
  JOSE.Core.Base in 'Other\JOSE\JOSE.Core.Base.pas',
  JOSE.Core.Builder in 'Other\JOSE\JOSE.Core.Builder.pas',
  JOSE.Core.JWA.Compression in 'Other\JOSE\JOSE.Core.JWA.Compression.pas',
  JOSE.Core.JWA.Encryption in 'Other\JOSE\JOSE.Core.JWA.Encryption.pas',
  JOSE.Core.JWA.Factory in 'Other\JOSE\JOSE.Core.JWA.Factory.pas',
  JOSE.Core.JWA in 'Other\JOSE\JOSE.Core.JWA.pas',
  JOSE.Core.JWA.Signing in 'Other\JOSE\JOSE.Core.JWA.Signing.pas',
  JOSE.Core.JWE in 'Other\JOSE\JOSE.Core.JWE.pas',
  JOSE.Core.JWK in 'Other\JOSE\JOSE.Core.JWK.pas',
  JOSE.Core.JWS in 'Other\JOSE\JOSE.Core.JWS.pas',
  JOSE.Core.JWT in 'Other\JOSE\JOSE.Core.JWT.pas',
  JOSE.Core.Parts in 'Other\JOSE\JOSE.Core.Parts.pas',
  JOSE.Encoding.Base64 in 'Other\JOSE\JOSE.Encoding.Base64.pas',
  JOSE.Hashing.HMAC in 'Other\JOSE\JOSE.Hashing.HMAC.pas',
  JOSE.Types.Arrays in 'Other\JOSE\JOSE.Types.Arrays.pas',
  JOSE.Types.Bytes in 'Other\JOSE\JOSE.Types.Bytes.pas',
  JOSE.Types.JSON in 'Other\JOSE\JOSE.Types.JSON.pas',
  ServiceConstants in 'Other\ServiceConstants.pas',
  DBSettings in 'Forms\DBSettings.pas' {frmDBSettings},
  RosVacCOVID in 'Classes\RosVacCOVID.pas',
  SendVac in 'Classes\SendVac.pas',
  JOSE.OpenSSL.Headers in 'Other\JOSE\JOSE.OpenSSL.Headers.pas',
  JOSE.Types.Utils in 'Other\JOSE\JOSE.Types.Utils.pas',
  JOSE.Signing.Base in 'Other\JOSE\JOSE.Signing.Base.pas',
  JOSE.Signing.ECDSA in 'Other\JOSE\JOSE.Signing.ECDSA.pas',
  JOSE.Signing.RSA in 'Other\JOSE\JOSE.Signing.RSA.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
