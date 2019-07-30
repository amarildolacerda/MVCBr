/// <summary>
/// TTimer.CreateAnonymousTimer
///
/// Auth:  amarildo lacerda - tireideletra.com.br
///
/// </summary>

(*
  sample:
  TTimer.createAnonymousTimer(
  function: boolean
  begin
  /// executa em loop enquanto retornar FALSE... para finalizar o Timer: retornar  TRUE;
  return  :=  not queroContinuar();
  end, 10, 500);
*)

unit System.Timer.Helper;

interface

uses System.Classes, System.SysUtils, VCL.ExtCtrls;

type

  /// <summary>
  /// Criar um timer com metodo anonymous
  /// </summary>
  TTimerHelper = class helper for TTimer
  public
    class function CreateAnonymousTimer(AProc: TProc; AIntervalFirst: Integer;
      AIntervalRegular: Integer): TTimer; overload;
    /// <summary>
    /// Executa em LOOP enquanto a AFunc retornar false
    /// </summary>
    /// <param name="AFunc">
    /// Anonymous para validar  TRUE encerrar   FALSE continuar
    /// </param>
    /// <param name="AInicial">
    /// Intervalo inicial para  a primeira execução
    /// </param>
    /// <param name="AInterval">
    /// Intervalo para as demais execuções
    /// </param>
    class function CreateAnonymousTimer(AFunc: TFunc<Boolean>;
      AIntervalFirst: Integer; AIntervalRegular: Integer): TTimer; overload;

    class procedure CreateAnonymous(AControl: TComponent; AProc: TProc<TObject>;
      AInterval: Integer); overload;
    class procedure CreateAnonymous<T: Class>(AControl: TComponent;
      AProc: TProc<T>; AInterval: Integer); overload;

    class procedure executeOnce(proc: TProc; interval: Integer);
  end;

type
  TTimerExtended = class(TTimer)
  protected
    FProc: TProc;
    FProcObject: TProc<TObject>;
    FFunc: TFunc<Boolean>;
    FIntervalAfter: Integer;
    FObject: TObject;
    procedure DoTimer(Sender: TObject); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    property Server: TObject read FObject;
  end;

  TTimerExtended<T: Class> = class(TTimerExtended)
  protected
    FProcComp: TProc<T>;
    FObjectComp: TComponent;
    procedure DoTimer(Sender: TObject); override;
    constructor Create(AOwner: TComponent); override;
    property Server: TComponent read FObjectComp;
  end;

implementation

uses VCL.Forms;

constructor TTimerExtended.Create(AOwner: TComponent);
begin
  inherited;
  FIntervalAfter := 1000;
  OnTimer := DoTimer;
end;

procedure TTimerExtended.DoTimer(Sender: TObject);
var
  LOldEnabled: Boolean;
  LStoped: Boolean;
begin
  LOldEnabled := Enabled;
  try
    Enabled := false;
    try
      if assigned(FProcObject) then
        FProcObject(FObject)
      else if assigned(FProc) then
        FProc
      else if assigned(FFunc) then
      begin
        LStoped := FFunc;
        if LStoped then
          FIntervalAfter := -1; // terminate;
      end;
    except
    end;
    if FIntervalAfter <= 0 then
      free
    else
      interval := FIntervalAfter;
  finally
    Enabled := LOldEnabled and (FIntervalAfter > 0);
  end;

end;

class function TTimerHelper.CreateAnonymousTimer(AProc: TProc;
  AIntervalFirst: Integer; AIntervalRegular: Integer): TTimer;
var
  FTimer: TTimerExtended;
begin
  FTimer := TTimerExtended.Create(Application);
  FTimer.FProc := AProc;
  FTimer.FIntervalAfter := AIntervalRegular;
  FTimer.interval := AIntervalFirst;
  FTimer.Enabled := true;
  result := FTimer;
end;

class procedure TTimerHelper.CreateAnonymous<T>(AControl: TComponent;
  AProc: TProc<T>; AInterval: Integer);
var
  FTimer: TTimerExtended<T>;
begin
  FTimer := TTimerExtended<T>.Create(AControl);
  FTimer.FProcComp := AProc;
  FTimer.FIntervalAfter := AInterval;
  FTimer.interval := AInterval;
  FTimer.Enabled := true;

end;

class function TTimerHelper.CreateAnonymousTimer(AFunc: TFunc<Boolean>;
  AIntervalFirst, AIntervalRegular: Integer): TTimer;
var
  FTimer: TTimerExtended;
begin
  FTimer := TTimerExtended.Create(Application);
  FTimer.FFunc := AFunc;
  FTimer.FIntervalAfter := AIntervalRegular;
  FTimer.interval := AIntervalFirst;
  FTimer.Enabled := true;
  result := FTimer;
end;

class procedure TTimerHelper.executeOnce(proc: TProc; interval: Integer);
begin
  TTimer.CreateAnonymousTimer(
    function: Boolean
    begin
      proc;
      result := false;
    end, interval, 5000);
end;

class procedure TTimerHelper.CreateAnonymous(AControl: TComponent;
AProc: TProc<TObject>; AInterval: Integer);
var
  FTimer: TTimerExtended;
begin
  FTimer := TTimerExtended.Create(AControl);
  FTimer.FProcObject := AProc;
  FTimer.FObject := AControl;
  FTimer.FIntervalAfter := AInterval;
  FTimer.interval := AInterval;
  FTimer.Enabled := true;

end;

{ TTimerExtended<T> }

constructor TTimerExtended<T>.Create(AOwner: TComponent);
begin
  inherited;
  FObjectComp := AOwner;
end;

procedure TTimerExtended<T>.DoTimer(Sender: TObject);
begin
  TThread.Queue(nil,
    procedure
    begin
      if assigned(FProcComp) then
        FProcComp(FObjectComp);
      inherited;
    end);
end;

end.
