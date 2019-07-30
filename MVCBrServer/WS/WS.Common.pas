unit WS.Common;

interface

uses System.Classes, System.SysUtils, System.Generics.Collections, MVCFramework,
  MVCFramework.Commons,
  MVCFramework.SysControllers, MVCFramework.Logger;

type
  TMVCControllerClass = class of TMVCController;

function RegisterWSController(const AClass: TMVCControllerClass): integer;
procedure LoadWSControllers(FMVC: TMVCEngine);

type
  TMVCAutenticationProc = procedure(AContext: TWebContext;
    var Handled: boolean);

var
  WSConnectionString: string;
  EnableAutentication: boolean;
  MVCAutenticationProc: TMVCAutenticationProc = nil;
  AutenticatiorServerSecrets: string;

implementation

uses MVCAsyncMiddleware, MVCFramework.Middleware.CORS,
  MVCFramework.Middleware.JWT, MVCFramework.JWT,
  MVCServerAutentication,
  MVCgzipMiddleware;

var
  FList: TThreadList<TMVCControllerClass>;

procedure LoadWSControllers(FMVC: TMVCEngine);
var
  i: integer;
  lClaimsSetup: TJWTClaimsSetup;
begin

  lClaimsSetup := procedure(const JWT: TJWT)
    begin
      JWT.Claims.Issuer := 'MVCBr Autentication';
      JWT.Claims.ExpirationTime := Now + (1 / 24); // valid for 1 hour
      JWT.Claims.NotBefore := Now - (1 / 24 / 60) * 5;
      // valid since 5 minutes ago
      JWT.Claims.IssuedAt := Now;
      JWT.CustomClaims['AppServer'] := 'odatabr';
    end;

  LogLevelLimit := TLogLevel.levException;
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

  if EnableAutentication then
    FMVC.AddMiddleware(TMVCJWTAuthenticationMiddleware.Create
      (TAuthenticationServer.Create, lClaimsSetup, AutenticatiorServerSecrets));

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

EnableAutentication := true;
AutenticatiorServerSecrets := 'mvcbrs3cr2018';
FList := TThreadList<TMVCControllerClass>.Create;

finalization

FList.Free;

end.
