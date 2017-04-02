{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/02/2017 22:07:42                                  // }
{ //************************************************************// }
unit WS.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils,
  // {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf,
  // MVCBr.Model,
  MVCBr.Controller,
  // MVCBr.ApplicationController,
  WS.Controller.Interf,
  MVCFramework, System.Generics.Collections, MVCFramework.Logger,
  MVCFramework.Commons,
  MVCFramework.SysControllers,
  Winapi.Windows,
  Winapi.ShellAPI,
  ReqMulti,
  Web.WebReq,
  Web.WebBroker,
  Web.HTTPApp,
  IdHTTPWebBrokerBridge,
  System.RTTI;

type
  TWSController = class(TControllerFactory, IWSController,
    IThisAs<TWSController> { , IModelAs<IWSViewModel> } )
  private
  protected
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); override;
  public
    // inicializar os módulos personalizados em CreateModules
    Procedure CreateModules; virtual;
    Constructor Create; override;
    Destructor Destroy; override;
    class function New(): IController; overload;
    class function New(const AView: IView; const AModel: IModel)
      : IController; overload;
    class function New(const AModel: IModel): IController; overload;
    function ThisAs: TWSController;
    procedure init; override;
    // function ModelAs: IWSViewModel;
  end;

function RegisterWSController(const AClass: TMVCControllerClass): integer;
procedure LoadWSControllers(FMVC: TMVCEngine);
function CreateMVCEngine(ASender: TWebModule): TMVCEngine;

implementation

uses WSConfig.Controller, WS.Datamodule, WSConfig.Controller.Interf,
  WSConfigView,
  MVCAsyncMiddleware,
  MVCgzipMiddleware, MVCBr.ApplicationController;

function CreateMVCEngine(ASender: TWebModule): TMVCEngine;
begin

  result := TMVCEngine.Create(ASender,
    procedure(Config: TMVCConfig)
    begin
      // enable static files
      Config[TMVCConfigKey.DocumentRoot] :=
        ExtractFilePath(GetModuleName(HInstance)) + '\www';
      // session timeout (0 means session cookie)
      Config[TMVCConfigKey.SessionTimeout] := '0';
      // default content-type
      Config[TMVCConfigKey.DefaultContentType] :=
        TMVCConstants.DEFAULT_CONTENT_TYPE;
      // default content charset
      Config[TMVCConfigKey.DefaultContentCharset] :=
        TMVCConstants.DEFAULT_CONTENT_CHARSET;
      // unhandled actions are permitted?
      Config[TMVCConfigKey.AllowUnhandledAction] := 'true'; // 'false';
      // default view file extension
      Config[TMVCConfigKey.DefaultViewFileExtension] := 'html';
      // view path
      Config[TMVCConfigKey.ViewPath] := 'templates';
      // Enable STOMP messaging controller
      Config[TMVCConfigKey.Messaging] := 'false';
      // Enable Server Signature in response
      Config[TMVCConfigKey.ExposeServerSignature] := 'true';
      // Define a default URL for requests that don't map to a route or a file (useful for client side web app)
      Config[TMVCConfigKey.FallbackResource] := 'index.html';
    end);

  LoadWSControllers(result);

end;

Constructor TWSController.Create;
begin
  inherited;
  // add(TWSViewModel.New(self).ID('{WS.ViewModel}')); CreateModules; //< criar os modulos persolnizados
end;

Destructor TWSController.Destroy;
begin
  inherited;
end;

class function TWSController.New(): IController;
begin
  result := New(nil, nil);
end;

class function TWSController.New(const AView: IView; const AModel: IModel)
  : IController;
var
  vm: IViewModel;
begin
  result := TWSController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

class function TWSController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

function TWSController.ThisAs: TWSController;
begin
  result := self;
end;

Procedure TWSController.DoCommand(ACommand: string;
const AArgs: Array of TValue);
begin
  inherited;
end;

procedure TWSController.init;
begin
  inherited;

end;

// Adicionar os modulos e MODELs personalizados
Procedure TWSController.CreateModules;
begin
  // adicionar os mudulos aqui
  // exemplo: add( MeuModel.new(self) );
end;

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

var
  Config: IWSConfigController;

initialization

Config := ApplicationController.resolveController(IWSConfigController)
  as IWSConfigController;
WSConnectionString := Config.ConnectionString;

FList := TThreadList<TMVCControllerClass>.Create;

finalization

FList.Free;

end.
