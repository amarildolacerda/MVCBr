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
  WSConfig.Controller.Interf,
  MVCFramework, System.Generics.Collections, MVCFramework.Logger,
  MVCFramework.Commons,
  MVCFramework.SysControllers,
{$IFDEF MSWINDOWS}
  Winapi.Windows,
  Winapi.ShellAPI,
  ReqMulti,
{$ENDIF}
{$IFDEF LINUX}
  FireDAC.ConsoleUI.Wait,
{$ENDIF}
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
  public
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); override;
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
    function WSConfig:IWSConfigController;
    // function ModelAs: IWSViewModel;
  end;

{$IFDEF DMVC2}
{$ELSE}

  TMVCControllerClass = class of TMVCController;
{$ENDIF}
function CreateMVCEngine(ASender: TWebModule): TMVCEngine;

implementation

uses WS.Common, WSConfigView,
  WSConfig.Controller, WS.Datamodule,
  MVCAsyncMiddleware, MVCFramework.Middleware.CORS,
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
      //Config[TMVCConfigKey.Messaging] := 'false';
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

var
  FWSConfig: IWSConfigController;

function TWSController.WSConfig: IWSConfigController;
begin
  result := FWSConfig;
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

initialization

FWSConfig := ApplicationController.resolveController(IWSConfigController)
  as IWSConfigController;
WSConnectionString := FWSConfig.ConnectionString;

finalization

end.
