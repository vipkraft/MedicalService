unit MT19937;
{$Q-}{$R+}
interface

const
  fmask = $ffffffff;
  Upper_Mask = $80000000;
  Lower_mask = $7fffffff;
  mag01: array[0..1] of cardinal = (0,$9908b0df);
  N = 624;

type
  TMT19937 = class(TObject)
  private
    M: smallint;
    mti: smallint;
    Mt: array[0..N - 1] of cardinal;
    firsttime: boolean;
  public
    constructor Create(s: cardinal); overload;
    constructor Create(init_key: array of cardinal); overload;
    function  val32: Cardinal;
    function  val31: LongInt;
    function  real1: Double;
    function  real2: Double;
    function  real3: Double;
    function  res53: Double;
    procedure init_genrand(s: cardinal);
    procedure init_by_ary(init_key: array of cardinal);
  end;

implementation

{ initialize the objet with a zeroed seed }
procedure Tmt19937.init_genrand(s: cardinal);
begin
  Mt[0] := s and fmask;
  mti := 1;
  while mti < N Do
  begin
    Mt[mti] := (1812433253 * (Mt[mti - 1] xor (Mt[mti - 1] shr 30)) + Cardinal(mti));
    Mt[mti] := Mt[mti] and fmask;
    Inc(mti);
  end;
end;

procedure Tmt19937.init_by_ary;
var i, j, k, key_length: Cardinal;
begin
  if firsttime then
    init_genrand(19650218);

  i := 1;
  j := 0;
  key_length := high(init_key) + 1;
  k := key_length;

  if N > k then
    k := N;

  while k > 0 Do
  begin
    Mt[i] := (Mt[i] xor ((Mt[i - 1] xor (Mt[i - 1] shr 30)) * 1664525)) + init_key[j] + j;
    Mt[i] := Mt[i] and fmask;
    Inc(i);
    Inc(j);
    if i >= N then
    begin
      Mt[0] := Mt[N - 1];
      i := 1;
    end;
    if j >= key_length then
      j := 0;
    Dec(k); //k := k - 1;
  end;

  k := N - 1;
  while k > 0 Do
  begin
    Mt[i] := (Mt[i] xor ((Mt[i - 1] xor (Mt[i - 1] shr 30)) * 1566083941)) - i;
    Mt[i] := Mt[i] and fmask;
    Inc(i); //i := i + 1;
    if i >= N then
    begin
      Mt[0] := Mt[N - 1];
      i := 1;
    end;
    Dec(k);
  end;
  Mt[0] := $80000000;
end;

constructor Tmt19937.Create(s: cardinal);
begin
  M := 397;
  mti := M + 1;
  firsttime := True;
  init_genrand(s);
end;

constructor Tmt19937.Create(init_key: array of cardinal);
begin
  create(19650218);
  firsttime := false;
  init_by_ary(init_key);
  firsttime := true;
end;

function Tmt19937.val32: Cardinal;
var y: Cardinal;
    CountFor, CountWhile, kk: integer;
begin
  if mti >= N  then
  begin
    if mti = (N + 1) then
      init_genrand(5489);

    CountFor := N - M - 1;
    for kk := 0 to CountFor do
    begin
      y := (Mt[kk] and Upper_Mask) or (Mt[kk + 1] and Lower_mask);
      Mt[kk] := Mt[kk + M] xor (y shr 1) xor mag01[y and 1];
    end;

    if CountFor >= 0 then
      kk := CountFor + 1
    else
      kk := 0;

    CountWhile := n - 1;
    while kk < CountWhile do
    begin
      y := (Mt[kk] and Upper_Mask) or (Mt[kk + 1] and Lower_mask);
      Mt[kk] := Mt[kk + (M - N)] xor (y shr 1) xor mag01[y and 1];
      Inc(kk); //kk := kk + 1;
    end;

    y := (Mt[N - 1] and Upper_Mask) or (Mt[0] and Lower_mask);
    Mt[N - 1] := Mt[M - 1] xor (y shr 1) xor mag01[y and 1];
    mti := 0;
  end;

  y := Mt[mti];
  Inc(mti); //mti := mti + 1;
  y := y xor (y shr 11);
  y := y xor ((y shl 7) and $9d2c5680);
  y := y xor ((y shl 15) and $efc60000);
  y := y xor (y shr 18);
  Result := y;
end;

function Tmt19937.val31: Longint;
begin
  Result := val32 shr 1;
end;

function Tmt19937.real1: Double;
begin
  Result := val32 * (1.0 / 4294967295.0);
end;

function Tmt19937.real2: Double;
begin
  Result := val32 * (1.0 / 4294967296.0);
end;

function Tmt19937.real3: Double;
begin
  Result := (val32 + 0.5) * (1.0 / 4294967296.0);
end;

function Tmt19937.res53: Double;
var a, b: Cardinal;
begin
  a := val32 shr 5;
  b := val32 shr 6;
  Result := (a * 67108864.0 + b) * (1.0 / 9007199254740992.0);
end;

end.
