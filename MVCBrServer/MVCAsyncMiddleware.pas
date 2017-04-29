{
  Amarildo Lacerda - 09/03/2017
  MVCBr

  #compartilhandoconhecimento #wba10anos

}
unit MVCAsyncMiddleware;

interface

uses System.Classes, System.SysUtils, MVCFramework;

type

  TMVCAsyncCallBackMiddleware = class(TInterfacedObject, IMVCMiddleware)
  protected
    /// <summary>
    /// Procedure is called before the MVCEngine routes the request to a specific controller/method.
    /// </summary>
    /// <param name="Context">Webcontext which contains the complete request and response of the actual call.</param>
    /// <param name="Handled">If set to True the Request would finished. Response must be set by the implementor. Default value is False.</param>
    procedure OnBeforeRouting(Context: TWebContext; var Handled: Boolean);
    /// <summary>
    /// Procedure is called before the specific controller method is called.
    /// </summary>
    /// <param name="Context">Webcontext which contains the complete request and response of the actual call.</param>
    /// <param name="AControllerQualifiedClassName">Qualified classname of the matching controller.</param>
    /// <param name="AActionNAme">Method name of the matching controller method.</param>
    /// <param name="Handled">If set to True the Request would finished. Response must be set by the implementor. Default value is False.</param>
    procedure OnBeforeControllerAction(Context: TWebContext;
      const AControllerQualifiedClassName: string; const aActionName: string;
      var Handled: Boolean);
    /// <summary>
    /// Procedure is called after the specific controller method was called.
    /// It is still possible to cancel or to completly modifiy the request.
    /// </summary>
    /// <param name="Context">Webcontext which contains the complete request and response of the actual call.</param>
    /// <param name="AActionNAme">Method name of the matching controller method.</param>
    /// <param name="Handled">If set to True the Request would finished. Response must be set by the implementor. Default value is False.</param>
    procedure OnAfterControllerAction(Context: TWebContext;
      const aActionName: string; const Handled: Boolean);
  end;

  TMVCContinueBool = Boolean;

var
  MVCCallBack_FieldName: string = '__callback';
  MVCBeforeControllerAction: TFunc<TWebContext, TMVCContinueBool>;
  MVCBeforeControllerRouting: TFunc<TWebContext, TMVCContinueBool>;
  MVCAfterControllerAction: TFunc<TWebContext, TMVCContinueBool>;
  // can change to fit owner callback name

implementation

{ TMVCAsyncCallBackMiddeware }

procedure TMVCAsyncCallBackMiddleware.OnAfterControllerAction
  (Context: TWebContext; const aActionName: string; const Handled: Boolean);
var
  funcName: string;
begin
  funcName := Context.Request.QueryStringParam(MVCCallBack_FieldName);
  if (funcName <> '') and ( Context.Response.ContentType.Contains('/json') ) then
  begin
    funcName := Format('%s(%s);',
      [funcName, Context.Response.RawWebResponse.Content]);
    Context.Response.ContentType := 'text/javascript; charset=utf-8;';
    Context.Response.RawWebResponse.Content := funcName;
    Context.Response.RawWebResponse.ContentLength :=
      length(Context.Response.RawWebResponse.Content);
  end;
  if assigned(MVCAfterControllerAction) then
  begin
    MVCAfterControllerAction(Context);
  end;
end;

procedure TMVCAsyncCallBackMiddleware.OnBeforeControllerAction
  (Context: TWebContext; const AControllerQualifiedClassName,
  aActionName: string; var Handled: Boolean);
begin
  if assigned(MVCBeforeControllerAction) then
  begin
    Handled := not MVCBeforeControllerAction(Context);
  end;
end;

procedure TMVCAsyncCallBackMiddleware.OnBeforeRouting(Context: TWebContext;
  var Handled: Boolean);
begin
  if assigned(MVCBeforeControllerRouting) then
  begin
    Handled := not MVCBeforeControllerRouting(Context);
  end;

end;

end.
