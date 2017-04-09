{
  amarildo lacerda
}
unit System.Finance;

interface

function EquivalentRate(ARate, ANFrom, ANTo: Double): Double;
function PMTAtEndOf(APresentValue: Double; AValueAtBegin: Double;
  ARate: Double; ANPeriod: Integer): Double;


implementation

uses System.Math;


// Calculo de prestação constante com a primeira parcela no final do periodo
// exemplo:    PMTAtEndOf(50000, 2500,0.5, 120)  = 527.35
// por: amarildo Lacerda
function PMTAtEndOf(APresentValue: Double; AValueAtBegin: Double;
  ARate: Double; ANPeriod: Integer): Double;
var
  p_vp: Double;
begin
  // ( p_vp * (p_i/100)  ) /    (1-(1/power(1 + (p_i/100),p_n))); - copiei a formula da Package Firebird  - github://   amarildo lacerda
  p_vp := APresentValue - AValueAtBegin;
  Result := (p_vp * (ARate / 100)) / (1 - (1 / Power(1 + (ARate / 100), ANPeriod)));
end;

function EquivalentRate(ARate, ANFrom, ANTo: Double): Double;
begin
  Result := 0;
  if ANFrom <> 0 then
    Result := (Power(1 + (ARate / 100), ANTo / ANFrom)
      - 1) * 100;
end;



end.
