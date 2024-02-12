unit LogInterfaces;

interface

uses
  System.Classes, System.SysUtils, Winapi.Windows;

type
  ILog = interface(IInterface)
    ['{9F4AA848-6369-41BA-A665-0463459684BA}']
    procedure AppendRecord(ServiceName: String; Color: Cardinal; Handle: HWND; Comment: String);
    procedure SaveFile(AOwner, AFile, AAnswer: string);
  end;

implementation

end.
