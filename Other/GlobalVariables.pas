unit GlobalVariables;

interface

uses
  System.Classes, System.SysUtils, Winapi.Windows, System.IOUtils, Vcl.Forms, System.IniFiles;

var
//  IsRunningFromIDE: Boolean;

  ExePath: String;
  ExeDir: String;
//  VersionExe: String;
//  GetMyComputer: String;
//  APP_BUILD_TIME: String;
  CERT_INFO: String;

implementation

function GetFileVersion(const FileName: string): string;
var
  pInfo, pPointer: Pointer;
  nSize: DWORD;
  nHandle: DWORD;
  pVerInfo: PVSFIXEDFILEINFO;
  nVerInfoSize: DWORD;
  nValue1, nValue2, nValue3, nValue4:integer;
begin
  Result := '?.?.?.?';

  nSize := GetFileVersionInfoSize(PChar(FileName), nHandle);
  if nSize = 0 then
    Exit;
  GetMem(pInfo, nSize);
  try
    FillChar(pInfo^, nSize, 0);
    if (GetFileVersionInfo(PChar(FileName), nHandle, nSize, pInfo)) then
    begin
      nVerInfoSize := SizeOf(VS_FIXEDFILEINFO);

      GetMem(pVerInfo, nVerInfoSize);
      try
        FillChar(pVerInfo^, nVerInfoSize, 0);
        pPointer := Pointer(pVerInfo);
        VerQueryValue(pInfo, '\', pPointer, nVerInfoSize);
        nValue1 := PVSFIXEDFILEINFO(pPointer)^.dwFileVersionMS shr 16;
        nValue2 := PVSFIXEDFILEINFO(pPointer)^.dwFileVersionMS and $FFFF;
        nValue3 := PVSFIXEDFILEINFO(pPointer)^.dwFileVersionLS shr 16;
        nValue4 := PVSFIXEDFILEINFO(pPointer)^.dwFileVersionLS and $FFFF;
        Result := IntToStr(nValue1) + '.' + IntToStr(nValue2) + '.' + IntToStr(nValue3) + '.' + IntToStr(nValue4);
      finally
        FreeMem(pVerInfo, nVerInfoSize);
      end;
    end;
  finally
    FreeMem(pInfo, nSize);
  end;
end;

function IsAppRunningFromIDE: Boolean;
var
  IsDebuggerPresent: function: Boolean; stdcall;
  KernelHandle: THandle;
begin
  Result := False;

  KernelHandle := GetModuleHandle(kernel32);
  @IsDebuggerPresent := GetProcAddress(KernelHandle, 'IsDebuggerPresent');
  if Assigned(@IsDebuggerPresent) then
    Result := IsDebuggerPresent;
end;

function GetMyComputerName: string;
var
  ComputerName: Array [0 .. 256] of Char;
  Size: DWORD;
begin
  Size := 256;
  GetComputerName(ComputerName, Size);
  Result := ComputerName;
end;

function GetApplicationBuildTime: TDateTime;
type
 UShort = Word;

 TImageDosHeader = packed record
    e_magic: UShort;               //магическое число
    e_cblp: UShort;                //количество байт на последней странице файла
    e_cp: UShort;                  //количество страниц вфайле
    e_crlc: UShort;                //Relocations
    e_cparhdr: UShort;             //размер заголовка в параграфах
    e_minalloc: UShort;            //Minimum extra paragraphsneeded
    e_maxalloc: UShort;            //Maximum extra paragraphsneeded
    e_ss: UShort;                  //начальное( относительное ) значение
    e_sp: UShort;                  //начальное значениерегистра SP
    e_csum: UShort;                //контрольная сумма
    e_ip: UShort;                  //начальное значение регистра IP
    e_cs: UShort;                  //начальное( относительное ) значение
    e_lfarlc: UShort;              //адрес в файле на таблицу переадресации
    e_ovno: UShort;                //количество оверлеев
    e_res: array[0..3] of UShort;  //Зарезервировано
    e_oemid: UShort;               //OEM identifier (for e_oeminfo)
    e_oeminfo: UShort;             //OEM information; e_oemid specific
    e_res2: array [0..9] of UShort;//Зарезервировано
    e_lfanew: LongInt;             //адрес в файле нового .exeзаголовка
  end;

 TImageResourceDirectory = packed record
    Characteristics: DWord;
    TimeDateStamp: DWord;
    MajorVersion: Word;
    MinorVersion: Word;
    NumberOfNamedEntries: Word;
    NumberOfIdEntries: Word;
  end;

  PImageResourceDirectory = ^TImageResourceDirectory;

var
  hExeFile: HFile;
  ImageDosHeader: TImageDosHeader;
  Signature: Cardinal;
  ImageFileHeader: TImageFileHeader;
  ImageOptionalHeader: TImageOptionalHeader;
  ImageSectionHeader: TImageSectionHeader;
  ImageResourceDirectory: TImageResourceDirectory;
  Temp: Cardinal;
  i: Integer;
begin
  hExeFile := CreateFile(PChar(ParamStr(0)), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  try
    ReadFile(hExeFile, ImageDosHeader, SizeOf(ImageDosHeader), Temp, nil);
    SetFilePointer(hExeFile, ImageDosHeader.e_lfanew, nil, FILE_BEGIN);
    ReadFile(hExeFile, Signature, SizeOf(Signature), Temp, nil);
    ReadFile(hExeFile, ImageFileHeader, SizeOf(ImageFileHeader), Temp, nil);
    ReadFile(hExeFile, ImageOptionalHeader, SizeOf(ImageOptionalHeader), Temp, nil);
    for i := 0 to ImageFileHeader.NumberOfSections - 1 do
    begin
      ReadFile(hExeFile, ImageSectionHeader, SizeOf(ImageSectionHeader), Temp, nil);
      if (StrComp(@ImageSectionHeader.Name, '.rsrc') = 0) then
        Break;
    end;
    SetFilePointer(hExeFile, ImageSectionHeader.PointerToRawData, nil, FILE_BEGIN);
    ReadFile(hExeFile, ImageResourceDirectory, SizeOf(ImageResourceDirectory), Temp, nil);
  finally
    FileClose(hExeFile);
  end;

  try
    if ImageResourceDirectory.TimeDateStamp <> 0 then
      Result := FileDateToDateTime(ImageResourceDirectory.TimeDateStamp)
    else
      Result := EncodeDate(1899, 12, 30);
  except
    Result := EncodeDate(1899, 12, 30);
  end;
end;

function GetCertInfo: String;
var
  Options: TIniFile;
begin
  Options := TIniFile.Create(ExeDir + 'setup.ini');
  try
    Result := Options.ReadString('certificate', 'certificate_info', '');
  finally
    FreeAndNil(Options);
  end;
end;

initialization
  ExePath := ExtractFileDir(ParamStr(0));
  ExeDir := ExtractFilePath(ParamStr(0));
//  VersionExe := GetFileVersion(Application.ExeName);
//  IsRunningFromIDE := IsAppRunningFromIDE();
//  GetMyComputer := GetMyComputerName;
//  APP_BUILD_TIME := DateTimeToStr(GetApplicationBuildTime);
  CERT_INFO := GetCertInfo();

end.
