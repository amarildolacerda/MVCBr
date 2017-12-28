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
  LOldEnabled: Boolean;
  LStoped: Boolean;
begin
  LOldEnabled := Enabled;
  try
    Enabled := false;
    try
      if assigned(FProc) then
        FProc
      else if assigned(FFunc) then
      begin
        LStoped := FFunc;
        if LStoped then
          FIntervalAfter := 0;
      end;
    except
    end;
    if FIntervalAfter <= 0 then
      free
    else
      Interval := FIntervalAfter;
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
  FTimer.Interval := AIntervalFirst;
  FTimer.Enabled := true;
  result := FTimer;
end;

class function TTimerHelper.CreateAnonymousTimer(AFunc: TFunc<Boolean>;
  AIntervalFirst, AIntervalRegular: Integer): TTimer;
var
  FTimer: TTimerExtended;
begin
  FTimer := TTimerExtended.Create(Application);
  FTimer.FFunc := AFunc;
  FTimer.FIntervalAfter := AIntervalRegular;
  FTimer.Interval := AIntervalFirst;
  FTimer.Enabled := true;
  result := FTimer;
end;

end.
