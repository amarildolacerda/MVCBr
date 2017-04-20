program MVCBrServer_Linux;
{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  MVCFramework.Logger,
  MVCFramework.Commons,
{$IFDEF LINUX}
  MVCFramework.REPLCommandsHandlerU,
{$ELSE}
  Winapi.Windows,
{$ENDIF }
  Web.WebReq,
  Web.WebBroker,
  System.JsonFiles,
  IdHTTPWebBrokerBridge,
  MVCBr.ApplicationController,
  WSConfig.Controller.Interf,
  WS.WebModule in 'WS.WebModule.pas' {WSWebModule: TWebModule} ,
  WS.Controller.Interf in 'WS\WS.Controller.Interf.pas',
  WS.Controller in 'WS\WS.Controller.pas',
  MVC.oData.Base in '..\oData\MVC.oData.Base.pas',
  oData.Collections in '..\oData\oData.Collections.pas',
  oData.Dialect.Firebird in '..\oData\oData.Dialect.Firebird.pas',
  oData.Dialect in '..\oData\oData.Dialect.pas',
  oData.Engine in '..\oData\oData.Engine.pas',
  oData.Interf in '..\oData\oData.Interf.pas',
  oData.ServiceModel in '..\oData\oData.ServiceModel.pas',
  oData.Parse in '..\oData\oData.Parse.pas',
  oData.ProxyBase in '..\oData\oData.ProxyBase.pas',
  oData.SQL.FireDAC in '..\oData\oData.SQL.FireDAC.pas',
  oData.SQL in '..\oData\oData.SQL.pas',
  WS.Datamodule in 'WS.Datamodule.pas' {WSDatamodule: TDataModule} ,
  oData.Dialect.MySQL in '..\oData\oData.Dialect.MySQL.pas',
  MVCBr.ObjectConfigList in '..\MVCBr.ObjectConfigList.pas',
  oData.JSON in '..\oData\oData.JSON.pas',
  MVCAsyncMiddleware in 'MVCAsyncMiddleware.pas',
  WS.Common in 'WS\WS.Common.pas',
  WSConfigView in 'WSConfig\WSConfigView.pas',
  config.Model in 'Models\config.Model.pas',
  config.Model.Interf in 'Models\config.Model.Interf.pas',
  oData.Dialect.MSSQL in '..\oData\oData.Dialect.MSSQL.pas';

{$R *.res}

procedure RunServer(APort: Integer);
var
{$IFDEF LINUX}
  lCustomHandler: TMVCCustomREPLCommandsHandler;
  lCmd, lStartupCommand: string;
{$ELSE}
  LInputRecord: TInputRecord;
  LEvent: DWord;
{$ENDIF}
  LHandle: THandle;
  LServer: TIdHTTPWebBrokerBridge;
  LConfig: IWSConfigController;
  ctrl:IWSController;
begin
  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    Writeln('** MVCBrOData powered by DMVCFramework Server ** build ' +
      DMVCFRAMEWORK_VERSION{$ifdef LINUX} +' (LINUX)'{$endif});
    Writeln(Format('Starting HTTP Server on port %d', [APort]));
    ctrl := applicationController.FindController(IWsController) as IWsController;
    try
      LConfig := ctrl.WSConfig;
      APort := LConfig.GetPort;
      LServer.DefaultPort := APort;
      { more info about MaxConnections
        http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_MaxConnections.html }
      LServer.MaxConnections := 0;//ini.ReadInteger('Config', 'MaxConnections', 0);
      { more info about ListenQueue
        http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_ListenQueue.html }
      LServer.ListenQueue := 200;//ini.ReadInteger('Config', 'ListenQueue', 200);
      { Comment the next line to avoid the default browser startup }
    finally
//      ini.Free;
    end;
    LServer.Active := True;
    LogI(Format('Server started on port %s', [APort.ToString]));
{$IFDEF LINUX}
    Writeln('Write "quit" or "exit" to shutdown the server');
    repeat
      // TextColor(RED);
      // TextColor(LightRed);
      Write('-> ');
      // TextColor(White);
      if lStartupCommand.IsEmpty then
        ReadLn(lCmd)
      else
      begin
        lCmd := lStartupCommand;
        lStartupCommand := '';
        Writeln(lCmd);
      end;

      case HandleCommand(lCmd.ToLower, LServer, lCustomHandler) of
        THandleCommandResult.Continue:
          begin
            Continue;
          end;
        THandleCommandResult.Break:
          begin
            Break;
          end;
        THandleCommandResult.Unknown:
          begin
            REPLEmit('Unknown command: ' + lCmd);
          end;
      end;
    until false;

{$ELSE}
{$IFDEF WIN32}
    // ShellExecute(0, 'open', PChar('http://localhost:' + inttostr(APort)), nil,
    // nil, SW_SHOWMAXIMIZED);
{$ENDIF}
    Writeln('Press ESC to stop the server');
    LHandle := GetStdHandle(STD_INPUT_HANDLE);
    while True do
    begin
      Win32Check(ReadConsoleInput(LHandle, LInputRecord, 1, LEvent));
      if (LInputRecord.EventType = KEY_EVENT) and
        LInputRecord.Event.KeyEvent.bKeyDown and
        (LInputRecord.Event.KeyEvent.wVirtualKeyCode = VK_ESCAPE) then
        Break;
    end;
{$ENDIF}
  finally
    LServer.Free;
  end;
end;

begin
  ApplicationController.Run(TWSController.New);
  ReportMemoryLeaksOnShutdown := True;
  IsMultiThread := True;
  try
    if WebRequestHandler <> nil then
      WebRequestHandler.WebModuleClass := WebModuleClass;
    WebRequestHandlerProc.MaxConnections := 1024;
    RunServer(0);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
