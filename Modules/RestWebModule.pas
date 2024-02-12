unit RestWebModule;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, NativeXml, LogInterfaces,
  Vcl.Dialogs, SOAPPasInv, SOAPHTTPPasInv, SOAPHTTPDisp,
  System.DateUtils, WebBrokerSOAP, IdBaseComponent, IdComponent,
  Winsock, Winapi.Windows, Soap.InvokeRegistry, Soap.WSDLIntf, System.TypInfo,
  Soap.WebServExp, Soap.WSDLBind, Xml.XMLSchema, Soap.WSDLPub, GlobalVariables,
  System.IniFiles, System.StrUtils,
  FireDAC.UI.Intf, FireDAC.Stan.Async, FireDAC.Comp.ScriptCommands,
  FireDAC.Stan.Util, FireDAC.Stan.Intf, FireDAC.Comp.Script,
  Soap.OpConvertOptions, Vcl.Forms;

type
  TRestWM = class(TWebModule)
    procedure RestWMwaReturnJwtTokenAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private

  end;

implementation

uses
  JWTGenerator, ServiceConstants;

{$R *.dfm}

procedure TRestWM.RestWMwaReturnJwtTokenAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  Strings: TStringList;
  OpenedKey: String;
  ClosedKey: String;
  JwtGenerator: TJWTGenerator;
begin
  Strings := TStringList.Create();
  try
    Strings.LoadFromFile(OPENED_KEY_FILE_NAME);
    OpenedKey := Strings.Text;
    Strings.LoadFromFile(CLOSED_KEY_FILE_NAME);
    ClosedKey := Strings.Text;
  finally
    FreeAndNil(Strings);
  end;

  JwtGenerator := TJWTGenerator.Create(OpenedKey, ClosedKey, SYSTEM_ID, SERVICE_ADDRESS);
  try
    Response.ContentType := 'application/json';
    Response.SetCustomHeader('Authorization', 'Bearer ' + JwtGenerator.CreateToken());
    Response.StatusCode := 200;
    Response.SendResponse();
  finally
    FreeAndNil(JwtGenerator);
  end;
end;

end.
