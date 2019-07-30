unit VCL.Controls.Helper;

interface

uses VCL.Controls, VCL.Graphics;

type
  TImageListHelper = class helper for TImageList
  public
    function AddIconAsBitmap(ico: TIcon): integer;
  end;
  
   TWinControlHelper = class helper for TWinControl
    public
     function TryFocus : boolean;
  end;

implementation

{ TImageListHelper }

function TWinControlHelper.TryFocus: boolean;
begin
  Result := False;
  if self.CanFocus then
  begin
     self.setFocus;
     Result := True;
  end;
end;

function TImageListHelper.AddIconAsBitmap(ico: TIcon): integer;
var
  bm: TBitmap;
begin
  bm := TBitmap.create;
  try
    if assigned(ico) then
    begin
      bm.Width := ico.Width;
      bm.Height := ico.Height;
      bm.Canvas.Draw(0, 0, ico);
    end;
    result := Add(bm, nil);

  finally
    bm.free;
  end;
end;

end.
