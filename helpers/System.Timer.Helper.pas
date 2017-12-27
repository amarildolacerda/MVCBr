unit System.Timer.Helper;

interface

uses System.Classes, System.SysUtils, VCL.ExtCtrls;

type

  TTimerHelper = class helper for TTimer
  public
    class function CreateAnonymousTimer(proc: TProc; AInicial: Integer;
      AInterval: Integer): TTimer;overload;
    class function CreateAnonymousTimer(proc: TFunc<Boolean>; AInicial: Integer;
      AInterval: Integer): TTimer;overload;
  end;

implementation

uses VCL.Forms;

type
  TTimerExtended = class(TTimer)
  private
    FProc: TProc;
    FFunc: TFunc<Boolean>;
    FIntervalAfter: Integer;
    procedure DoTimer(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  end;

constructor TTimerExtended.Create(AOwner: TComponent);
begin
  inherited;
  FIntervalAfter := 1000;
  OnTimer := DoTimer;
end;

procedure TTimerExtended.DoTimer(Sender: TObject);
var
  FOld: Boolean;
  stop: Boolean;
begin
  FOld := Enabled and (FIntervalAfter > 0);
  try
    Enabled := false;
    try
      if assigned(FProc) then
        FProc
      else if assigned(FFunc) then
      begin
        stop := FFunc;
        if stop then
          FIntervalAfter := 0;
      end;
    except
    end;
    if FIntervalAfter = 0 then
      free
    else
      Interval := FIntervalAfter;
  finally
    Enabled := FOld;
  end;

end;

class function TTimerHelper.CreateAnonymousTimer(proc: TProc; AInicial: Integer;
  AInterval: Integer): TTimer;
var
  FTimer: TTimerExtended;
begin
  FTimer := TTimerExtended.Create(Application);
  FTimer.FProc := proc;
  FTimer.FIntervalAfter := AInterval;
  FTimer.Interval := AInicial;
  FTimer.Enabled := true;
  result := FTimer;
end;

class function TTimerHelper.CreateAnonymousTimer(proc: TFunc<Boolean>;
  AInicial, AInterval: Integer): TTimer;
var
  FTimer: TTimerExtended;
begin
  FTimer := TTimerExtended.Create(Application);
  FTimer.FFunc := proc;
  FTimer.FIntervalAfter := AInterval;
  FTimer.Interval := AInicial;
  FTimer.Enabled := true;
  result := FTimer;
end;

end.
