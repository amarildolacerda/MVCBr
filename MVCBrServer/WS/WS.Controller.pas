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
  IdHTTPWebBrokerBridge,
  WS.WebModule,
  WS.RegisterControllers,
  System.RTTI;

type
  TWSController = class(TControllerFactory, IWSController,
    IThisAs<TWSController> { , IModelAs<IWSViewModel> } )
  private
    procedure RunServer(APort: integer);
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

implementation

procedure TWSController.RunServer(APort: integer);
var
  LInputRecord: TInputRecord;
  LEvent: DWord;
  LHandle: THandle;
  LServer: TIdHTTPWebBrokerBridge;
begin
  Writeln('** DMVCFramework Server ** build ' + DMVCFRAMEWORK_VERSION);
  Writeln(Format('Starting HTTP Server on port %d', [APort]));
  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    LServer.DefaultPort := APort;
    LServer.Active := True;
    LogI(Format('Server started on port %d', [APort]));
    { more info about MaxConnections
      http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_MaxConnections.html }
    LServer.MaxConnections := 0;
    { more info about ListenQueue
      http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_ListenQueue.html }
    LServer.ListenQueue := 200;
    { Comment the next line to avoid the default browser startup }
    if not assigned(FView) then
    begin
      ShellExecute(0, 'open', PChar('http://localhost:' + inttostr(APort)), nil,
        nil, SW_SHOWMAXIMIZED);
      Writeln('Press ESC to stop the server');
      LHandle := GetStdHandle(STD_INPUT_HANDLE);
      while True do
      begin
        Win32Check(ReadConsoleInput(LHandle, LInputRecord, 1, LEvent));
        if (LInputRecord.EventType = KEY_EVENT) and
          LInputRecord.Event.KeyEvent.bKeyDown and
          (LInputRecord.Event.KeyEvent.wVirtualKeyCode = VK_ESCAPE) then
          break;
      end;
    end;
  finally
    LServer.Free;
  end;
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

  ReportMemoryLeaksOnShutdown := True;
  IsMultiThread := True;
  try
    if WebRequestHandler <> nil then
      WebRequestHandler.WebModuleClass := WebModuleClass;
    WebRequestHandlerProc.MaxConnections := 1024;
    AfterInit;
    RunServer(8080);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

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
// TWSController.New(TWSView.New,TWSViewModel.New)).init();
// RegisterInterfacedClass(TWSController.ClassName, IWSController, TWSController);

finalization

FList.Free;
// unRegisterInterfacedClass(TWSController.ClassName);

end.
