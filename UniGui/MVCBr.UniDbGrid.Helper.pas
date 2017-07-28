unit MVCBr.UniDbGrid.Helper;

interface

Uses System.Classes, UniDbGrid, DB;

type

  TUniDbGridHelper = Class Helper for TUniDbGrid

  public
    Procedure ResizeColumns(AMin, AMed, AMax: integer);
  end;

implementation

uses MVCBr.UniHelper;

{ TUniDbGridHelper }

procedure TUniDbGridHelper.ResizeColumns(AMin, AMed, AMax: integer);
var
  i: integer;
  n: integer;
begin

  for i := 0 to columns.count - 1 do
  begin
    n := TMVCBrUniHelper.GetColumnMaxWidth(columns[i].Field, 5, 15, 30);
    if n > 0 then
      columns[i].width := n * 10;
  end;

end;

end.
