unit oData.GenScript;

interface

Uses System.Classes, System.SysUtils, System.ThreadSafe;

type

  IODataGenScript = interface
    ['{6696C3C3-5A74-47BF-A2DD-5E46B295DFDA}']
  end;

  TODataGenScriptEngineFunctionResult = string;
  TODataGenScriptEngineFunction = TFunc<TODataGenScriptEngineFunctionResult>;

  TODataGenScript = class(TInterfacedObject, IODataGenScript)
  type
    TScriptEngines = class(TThreadSafeDictionary<string,
      TODataGenScriptEngineFunction>);
  private
    class var FReleased: Boolean;
    class var FEngines: TScriptEngines;

  public
    class Function Engines: TScriptEngines;
    class procedure Release;
    class function GetScript(AEngine: string): TODataGenScriptEngineFunctionResult;
    class procedure Register(AEngineName: String;
      AProcEngine: TODataGenScriptEngineFunction);
  end;

implementation

class procedure TODataGenScript.Register(AEngineName: String;
  AProcEngine: TODataGenScriptEngineFunction);
begin
  TODataGenScript.Engines.AddOrSetValue(AEngineName, AProcEngine);
end;

{ TODataGenScript }

class function TODataGenScript.Engines: TScriptEngines;
begin
  if not assigned(FEngines) then
    FEngines := TScriptEngines.create();
  result := FEngines;
end;

class function TODataGenScript.GetScript(AEngine: string)
  : TODataGenScriptEngineFunctionResult;
var
  AProc: TODataGenScriptEngineFunction;
  LEngine:TScriptEngines;
begin
  if FReleased then
    exit;
  LEngine := TODataGenScript.Engines;
  AProc := LEngine.Items[AEngine];
  if assigned(AProc) then
    result := AProc
  else
    raise exception.create('GenScriptEngine não registrado [' + AEngine + ']');

end;

class procedure TODataGenScript.Release;
begin
  FReleased := true;
  if assigned(FEngines) then
    FEngines.free;
  FEngines := nil;
end;

initialization

finalization

TODataGenScript.Release;

end.
