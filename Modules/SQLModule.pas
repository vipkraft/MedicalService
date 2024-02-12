unit SQLModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.UI.Intf, FireDAC.Stan.Async, FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util,
  FireDAC.Stan.Intf, FireDAC.Comp.Script;

type
  TSQLDataModule = class(TDataModule)
    COVIDScripts: TFDScript;
    fdscrpt1: TFDScript;
  private
    { Private declarations }
  public
    function FindScript(ComponentName, ScriptName: String): String;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TSQLDataModule }

function TSQLDataModule.FindScript(ComponentName, ScriptName: String): String;
var
  FDScript: TFDScript;
  FDSQLScript: TFDSQLScript;
begin
  FDScript := Self.FindComponent(ComponentName) as TFDScript;
  if (FDScript = nil) then
    raise Exception.Create(Format('FDScript по имени [%s] не найден!', [ComponentName]));
  FDSQLScript := FDScript.SQLScripts.FindScript(ScriptName);
  if (FDSQLScript = nil) then
    raise Exception.Create(Format('“екст запроса [%s] не найден [%s]', [ScriptName, ComponentName]));
  Result := FDSQLScript.SQL.Text;
end;

end.
