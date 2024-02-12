unit HashFunctions;

interface

uses Classes, SysUtils, DCPsha1, DCPmd5, DCPcrypt2, DCPsha256, DCPblowfish, IniFiles;

Function CodingBlowFish(const EditPass: String): string;
Function DecodingBlowFish(const EditPass: String): string;
function SHA1_DigestToStr(const Digest: array of byte): string;
function GetHashSHA1(const Source: String): string;
function GetHashSHA256(const Source: String): String; overload;
function GetHashSHA256(Source: TStream): String; overload;
function GetHashMD5(const SourceValue: String): String;
function ReadStringOption(OptionFile:TIniFile; const SectionName, OptionName, OpenKeyValue: String): String;

implementation

const
  KEY_BLOW_FISH = '0bZlo9LWMQUBxMjbXS433OCVh975uSb5eDVxTBzRw3Tgm/5FRTBrFTYvXN7hTNlOHvL/wQ==';

// Кодирование BlowFish
function CodingBlowFish(const EditPass: String): String;
var
  Cipher: TDCP_BlowFish;
begin
  Cipher:=TDCP_BlowFish.Create(nil);
  try
    Cipher.InitStr(KEY_BLOW_FISH, TDCP_sha1);
    Result := Cipher.EncryptString(EditPass);
    Cipher.Burn();
  finally
    FreeAndNil(Cipher);
  end;
end;

// Декодирование BlowFish
function DecodingBlowFish(const EditPass: String): String;
var
  Cipher: TDCP_BlowFish;
begin
  Cipher := TDCP_BlowFish.Create(nil);
  try
    Cipher.InitStr(KEY_BLOW_FISH, TDCP_sha1);
    Result := Cipher.DecryptString(EditPass);
    Cipher.Burn();
  finally
    FreeAndNil(Cipher);
  end;
end;

function GetHashSHA1(const Source: String): String;
var
  Hash: TDCP_sha1;
  Digest: array[0..19] of Byte;
begin
  Hash := TDCP_sha1.Create(nil);
  try
    Hash.Init;
    Hash.UpdateStr(Source);
    Hash.Final(Digest);
  finally
    Hash.Free;
  end;

  Result := SHA1_DigestToStr(Digest);
end;

function SHA1_DigestToStr(const Digest: array of byte): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to 19 do
    Result := Result + LowerCase(IntToHex(Digest[i], 2));
end;

function GetHashSHA256(const Source: string): string;
var
  HASH_SHA256: TDCP_sha256;
  Digest: array [1..32] of Byte;
  i: integer;
begin
  //SHA256
  HASH_SHA256 := TDCP_sha256.Create(nil);
  try
    HASH_SHA256.Init;
    HASH_SHA256.UpdateStr(Source);
    HASH_SHA256.Final(Digest);
  finally
    FreeAndNil(HASH_SHA256);
  end;

  Result := '';
  for i := 1 to 32 do
    Result:= Result + IntToHex(Digest[i], 2);
end;

function GetHashSHA256(Source: TStream): string;
var
  HASH_SHA256: TDCP_sha256;
  Digest: array [1..32] of Byte;
  i: integer;
begin
  //SHA256
  HASH_SHA256 := TDCP_sha256.Create(nil);
  try
    HASH_SHA256.Init;
    HASH_SHA256.UpdateStream(Source, Source.Size);
    HASH_SHA256.Final(Digest);
  finally
    FreeAndNil(HASH_SHA256);
  end;

  Result:= '';
  for i := 1 to 32 do
    Result := Result + IntToHex(Digest[i], 2);
end;

function GetHashMD5(const SourceValue: string): string;
var
  HASH_MD5: TDCP_md5;
  Digest:array [1..16] of Byte;
  i: integer;
begin
  //MD5
  HASH_MD5 := TDCP_md5.Create(nil);
  try
    HASH_MD5.Init;
    HASH_MD5.UpdateStr(SourceValue);
    HASH_MD5.Final(Digest);
  finally
    FreeAndNil(HASH_MD5);
  end;

  Result:= '';
  for i := 1 to 16 do
    Result := Result + IntToHex(Digest[i], 2);
end;

function ReadStringOption(OptionFile: TIniFile; const SectionName, OptionName, OpenKeyValue: String): String;
var
  TempString: string;
begin
  TempString := OptionFile.ReadString(SectionName, OptionName, '');
  if TempString = OpenKeyValue then
    Result := TempString
  else
    Result := DecodingBlowFish(TempString);
end;

end.
