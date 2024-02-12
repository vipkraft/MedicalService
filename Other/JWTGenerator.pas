unit JWTGenerator;

interface

uses
  System.SysUtils, System.Classes, System.DateUtils, Winapi.Windows;

type
  TJWTGenerator = class
  private
    FOpenedKey: String;
    FClosedKey: String;
    FSubject: String;  // Идентификатор РМИС
    FAudience: String;
    function ClearCert(S: String): String; // URL получателя
  public
    constructor Create(OpenedKey, ClosedKey, Subject, Audience: String);
  public
    function CreateToken(): String;
  end;

implementation

uses
  JOSE.Core.JWA, JOSE.Core.JWT, JOSE.Core.JWS, JOSE.Core.JWK, Jose.Types.Bytes,
  System.Variants;

constructor TJWTGenerator.Create(OpenedKey, ClosedKey, Subject, Audience: String);
begin
  FOpenedKey := ClearCert(OpenedKey);
  FClosedKey := ClosedKey;
  FSubject := Subject;
  FAudience := Audience;
end;

function TJWTGenerator.ClearCert(S: String): String;
const
  BEGIN_RSA_KEY = '-----BEGIN RSA PUBLIC KEY-----';
  END_RSA_KEY = '-----END RSA PUBLIC KEY-----';
  BEGIN_PUBLIC_KEY = '-----BEGIN PUBLIC KEY-----';
  END_PUBLIC_KEY = '-----END PUBLIC KEY-----';
  BEGIN_CERT = '-----BEGIN CERTIFICATE REQUEST-----';
  END_CERT = '-----END CERTIFICATE REQUEST-----';
  BEGIN_CERT_ALL = '-----BEGIN CERTIFICATE-----';
  END_CERT_ALL = '-----END CERTIFICATE-----';
begin
  Result := S.Replace(BEGIN_RSA_KEY, '', [rfReplaceAll, rfIgnoreCase]);
  Result := Result.Replace(END_RSA_KEY, '', [rfReplaceAll, rfIgnoreCase]);
  Result := Result.Replace(BEGIN_PUBLIC_KEY, '', [rfReplaceAll, rfIgnoreCase]);
  Result := Result.Replace(END_PUBLIC_KEY, '', [rfReplaceAll, rfIgnoreCase]);
  Result := Result.Replace(BEGIN_CERT, '', [rfReplaceAll, rfIgnoreCase]);
  Result := Result.Replace(END_CERT, '', [rfReplaceAll, rfIgnoreCase]);
  Result := Result.Replace(BEGIN_CERT_ALL, '', [rfReplaceAll, rfIgnoreCase]);
  Result := Result.Replace(END_CERT_ALL, '', [rfReplaceAll, rfIgnoreCase]);
  Result := Result.Replace(Chr($D), '', [rfReplaceAll, rfIgnoreCase]);
  Result := Result.Replace(Chr($A), '', [rfReplaceAll, rfIgnoreCase]);
  Result := Result.Trim();
end;

function GetTimeZone:Integer;
var
  TIME_ZONE:_TIME_ZONE_INFORMATION;
  i:integer;
begin
  GetTimeZoneInformation(TIME_ZONE);
  i:=TIME_ZONE.Bias div 60;
  Result:= i * -1;
end;

function TJWTGenerator.CreateToken(): String;
var                
  LToken: TJWT;
  LSigner: TJWS;
  Jwk: TJWK;
  FNow : TDateTime;
begin
  LToken := TJWT.Create;
  try
    LToken.Header.CertArray := VarArrayOf([FOpenedKey]);
    LToken.Header.Algorithm := 'RS256';
//    LToken.Header.HeaderType := '';

    LToken.Claims.Subject := FSubject;
    LToken.Claims.Audience := FAudience;

    FNow:= IncHour(Now,GetTimeZone-3);
//    LToken.Claims.Expiration := IncMinute(FNow, 5);
    LToken.Claims.IssuedAt := FNow;

    LSigner := TJWS.Create(LToken);
    try
      LSigner.SkipKeyValidation := True;

      Jwk := TJWK.Create();
      try
        Jwk.Key := FClosedKey;
        LSigner.Sign(Jwk, TJOSEAlgorithmId.RS256);
      finally
        FreeAndNil(Jwk);
      end;
      Result := LSigner.CompactToken.AsString;
    finally
      FreeAndNil(LSigner);
    end;
  finally
    FreeAndNil(LToken);
  end;
end;

end.
