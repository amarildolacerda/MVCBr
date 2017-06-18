unit MVCBr.Observer;

interface

uses System.Json, MVCBr.Interf;

Type

  TMCVBrObserver = class(TInterfacedObject, IMVCBrObserver)
  public
    function This:TObject;virtual;
    procedure Update(AJsonValue: TJsonValue; var AHandled: boolean); virtual;
  end;

implementation

{ TMCVBrObserver }

function TMCVBrObserver.This: TObject;
begin
   result := self;
end;

procedure TMCVBrObserver.Update(AJsonValue: TJsonValue; var AHandled: boolean);
begin

end;

end.
