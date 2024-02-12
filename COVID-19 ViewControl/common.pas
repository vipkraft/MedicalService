unit common;

interface

uses MT19937, System.SysUtils;

const
  StringAllSimbol ='@$:|¸éöóêåíã34øùçõúôûâàïğîëäæı^;ÿ÷ñìèòüˆáşqwer&t¢yuiopasdfghjklzxcvbnm<>_ÉÖÓÊÅÍÃØ12¹ÙÇÕÚÔÛÂÀÏ—ĞÎ™ËÄÆ®İß×Ñ¤ÌÈ*Ò567890«ÜÁŞQWERT¨YUI+-=~"`?OPASDFG±HJKLZXCVBNM';
  lengthStringAllSimbol: Word = Length(StringAllSimbol);

var
  Generator: TMT19937;

function GenKey_UIN(): String;

implementation

function GenKey_UIN(): String;
var i: integer;
begin
  Result := '';

  for i := 1 to 16 do
    Result := Result + StringAllSimbol[(Generator.val32 mod lengthStringAllSimbol) + 1];
end;

initialization
  Generator := TMT19937.Create(Round(Now * 10000000000));

finalization
  if Assigned(Generator) then FreeAndNil(Generator);

end.
