unit LogClass;

interface

uses
  Winapi.Windows, LogInterfaces, DataModuleLog;

type
  TLogClass = class(TInterfacedObject, ILog)
  private
    FDataModule: TDMLog;
  public
    procedure AppendRecord(ClassName: String; Color: Cardinal; Handle: HWND; AMessage: String);
    procedure SaveFile(AOwner, AFile, AAnswer: string);

    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;


implementation

uses
  System.SysUtils;

{ TLogClass }

procedure TLogClass.AfterConstruction;
begin
  inherited;
  FDataModule := TDMLog.Create(nil);
end;

procedure TLogClass.BeforeDestruction;
begin
  FreeAndNil(FDataModule);
  inherited;
end;

procedure TLogClass.AppendRecord(ClassName: string; Color: Cardinal; Handle: HWND; AMessage: String);
begin
  FDataModule.AppendRecord(ClassName, Color, Handle, AMessage);
end;

procedure TLogClass.SaveFile(AOwner, AFile, AAnswer: string);
begin
  FDataModule.AddFile(AOwner, AFile, AAnswer);
end;

end.
