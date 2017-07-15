unit MVCBr.UniHelper;

interface

uses System.Classes, Data.DB;

type
  TMVCBrUniHelper = record
  public
    class function GetColumnMaxWidth(Field: TField; AMin, AMed, AMax: integer)
      : integer; static;
  end;

implementation

{ TMVCBrUniHelper }

class function TMVCBrUniHelper.GetColumnMaxWidth(Field: TField;
  AMin, AMed, AMax: integer): integer;
var
  n: integer;
  k: integer;
begin
  result := -1;
  if not assigned(Field) then
    exit;

  n := Field.DisplayWidth;
  if n >= AMax then
    n := AMax
  else if n <= AMin then
    n := AMin
  else
  begin
    k := AMed + ((AMax - AMed) div 2);
    if n > (k) then
      n := k;
    n := AMed;
    k := AMed - ((AMed - AMin) div 2);
    if n > k then
      n := k;
  end;

  k := length(Field.AsString);
  if k > 0 then
  begin
    if (k > n) and (k > AMax) then
      n := AMax
    else if (k < AMin) then
      n := AMin
    else if k > AMed then
      n := k;
  end;

  k := length(Field.DisplayName);
  if k > n then
    n := k;

  case Field.DataType of
    ftDateTime, ftTimeStamp, ftTimeStampOffset:
      n := 12;
    ftInteger, ftSmallInt, ftBoolean, ftDate, ftTime:
      n := 8;
    ftFloat:
      n := 12;
    ftCurrency:
      n := 12;

  end;

  result := n;

end;

end.
