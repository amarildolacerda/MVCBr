unit WS.Common;

interface

uses System.Generics.Collections, MVCFramework, MVCFramework.Commons, MVCFramework.SysControllers,MVCFramework.Logger;

type
  TMVCControllerClass = class of TMVCController;

function RegisterWSController(const AClass: TMVCControllerClass): integer;
procedure LoadWSControllers(FMVC: TMVCEngine);

var
  WSConnectionString: string;

implementation


uses MVCAsyncMiddleware, MVCFramework.Middleware.CORS,
  MVCgzipMiddleware;

var
  FList: TThreadList<TMVCControllerClass>;

procedure LoadWSControllers(FMVC: TMVCEngine);
var
  i: integer;
begin
  with FList.LockList do
    try
      for i := 0 to Count - 1 do
        FMVC.AddController(Items[i]);
    finally
      FList.UnlockList;
    end;
  FMVC.AddMiddleware(TMVCgzipCallBackMiddleware.Create);
  FMVC.AddMiddleware(TMVCAsyncCallBackMiddleware.Create);
  FMVC.AddMiddleware(TCORSMiddleware.Create);

end;

function RegisterWSController(const AClass: TMVCControllerClass): integer;
begin
  with FList.LockList do
    try
      Add(AClass);
      result := Count - 1;
    finally
      FList.UnlockList;
    end;
end;

initialization

FList := TThreadList<TMVCControllerClass>.Create;

finalization

FList.Free;

end.
