unit Service.CrontabList;

interface

uses
  System.Classes, System.SysUtils, System.RTTI, System.ThreadSafe,
  System.Classes.Helper;

type

  TServiceCronTabState = (ctsNone, ctsLoading, ctsExecuting, ctsSupended,
    cstDestroing);

  TServiceCronTab = class(TObjectFired)
  private
    FState: TServiceCronTabState;
    FResponse: TProc<TValue>;
    procedure SetState(const Value: TServiceCronTabState);
    procedure SetResponse(const Value: TProc<TValue>);
  public
    Constructor Create;
    Destructor Destroy; override;
    function CanExec: boolean;
    procedure SendResponse(AValue: TValue); virtual;
    property State: TServiceCronTabState read FState write SetState;
    function Execute(AValue: TValue): boolean; virtual; abstract;
    property ResponseTo: TProc<TValue> read FResponse write SetResponse;
  end;

  TServiceCronTabClass = class of TServiceCronTab;

  TServiceCronTabList = class(TThreadSafeObjectList<TServiceCronTab>)
  private
    function ExecServ(AObject: TServiceCronTab; AValue: TValue): boolean;
  public
    class function Default: TServiceCronTabList; static;
    class function Execute(AIndex: integer; AValue: TValue): boolean; static;
    class function ExecuteAll(AValue: TValue): boolean; static;
  end;

function RegisterCronTab(AClass: TServiceCronTabClass): TServiceCronTab;

implementation

{ TServiceCronTabList }

type
  IServiceCronTabList = IObjectAdapter<TServiceCronTabList>;

var
  FDestroing: boolean;
  LSingleton: IServiceCronTabList;
  LLock: TObject;

function Lock: IServiceCronTabList;
begin
  System.TMonitor.enter(LLock);
  result := TServiceCronTabList.Default;
end;

procedure UnLock;
begin
  System.TMonitor.exit(LLock);
end;

function RegisterCronTab(AClass: TServiceCronTabClass): TServiceCronTab;
begin
  result := AClass.Create;
  TServiceCronTabList.Default.Add(result);
  result.State := ctsNone;
end;

class function TServiceCronTabList.Default: TServiceCronTabList;
begin
  result := nil;
  if FDestroing then
    exit;
  if not assigned(LSingleton) then
    LSingleton := TObjectAdapter<TServiceCronTabList>.new
      (TServiceCronTabList.Create);
  result := LSingleton;
end;

function TServiceCronTabList.ExecServ(AObject: TServiceCronTab;
  AValue: TValue): boolean;
begin
  result := false;
  if AObject.CanExec then
  begin
    AObject.State := ctsExecuting;
    run(
      procedure
      var
        rt: boolean;
      begin
        try
          try
            rt := AObject.Execute(AValue);
            AObject.SendResponse(rt);
          finally
            AObject.State := ctsNone;
          end;
        except
          AObject.ContinueWith(NotOnFaulted);
        end;
      end);
    result := true;
  end;
end;

class function TServiceCronTabList.Execute(AIndex: integer;
AValue: TValue): boolean;
begin
  result := false;
  Lock;
  try
    if assigned(LSingleton) then
      with LSingleton do
        result := ExecServ(Items[AIndex], AValue);
  finally
    UnLock;
  end;
end;

class function TServiceCronTabList.ExecuteAll(AValue: TValue): boolean;
var
  AIndex: integer;
begin
  result := true;
  Lock;
  try
    if assigned(LSingleton) then
      with LSingleton do
        for AIndex := 0 to Count - 1 do
          result := result and ExecServ(Items[AIndex], AValue);
  finally
    UnLock;
  end;
end;

{ TServiceCronTab }

function TServiceCronTab.CanExec: boolean;
begin
  result := FState = ctsNone;
end;

constructor TServiceCronTab.Create;
begin
  FState := ctsLoading;
end;

destructor TServiceCronTab.Destroy;
begin
  FState := cstDestroing;
  inherited;
end;

procedure TServiceCronTab.SendResponse(AValue: TValue);
begin
  if assigned(FResponse) then
    FResponse(AValue);
end;

procedure TServiceCronTab.SetResponse(const Value: TProc<TValue>);
begin
  FResponse := Value;
end;

procedure TServiceCronTab.SetState(const Value: TServiceCronTabState);
begin
  FState := Value;
end;

initialization

FDestroing := false;
LLock := TObject.Create;

finalization

FDestroing := true;
LSingleton := nil;
LLock.DisposeOf;

end.
