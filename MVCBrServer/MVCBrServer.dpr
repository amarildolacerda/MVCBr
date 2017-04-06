program MVCBrServer;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  MVCFramework.Logger,
  MVCFramework.Commons,
  {$ifdef MSWINDOWS}
  Winapi.Windows,
  Winapi.ShellAPI,
  ReqMulti,
  {$endif }
  Web.WebReq,
  Web.WebBroker,
  System.JsonFiles,
  IdHTTPWebBrokerBridge,
  MVCBr.ApplicationController,
  WS.WebModule in 'WS.WebModule.pas' {WSWebModule: TWebModule},
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
  WS.Datamodule in 'WS.Datamodule.pas' {WSDatamodule: TDataModule},
  oData.Dialect.MySQL in '..\oData\oData.Dialect.MySQL.pas',
  WSConfig.Controller.Interf in 'WSConfig\WSConfig.Controller.Interf.pas',
  WSConfig.Controller in 'WSConfig\WSConfig.Controller.pas',
  WSConfigView in 'WSConfig\WSConfigView.pas' {WSConfigView},
  MVCBr.ObjectConfigList in '..\MVCBr.ObjectConfigList.pas',
  oData.JSON in '..\oData\oData.JSON.pas',
  MVCAsyncMiddleware in 'MVCAsyncMiddleware.pas',
  WS.Common in 'WS\WS.Common.pas';

{$R *.res}

procedure RunServer(APort: Integer);
var
  LInputRecord: TInputRecord;
  LEvent: DWord;
  LHandle: THandle;
  LServer: TIdHTTPWebBrokerBridge;
  ini:TJsonFile;
begin
  Ini := TJsonFile.Create(ExtractFilePath(ParamStr(0)) + 'MVCBrServer.config');
  try
    APort := Ini.ReadInteger('Config', 'WSPort', 8080);
    Writeln('** MVCBrOData powered by DMVCFramework Server ** build ' +
      DMVCFRAMEWORK_VERSION);
    Writeln(Format('Starting HTTP Server on port %d', [APort]));
    LServer := TIdHTTPWebBrokerBridge.create(nil);
    try
      LServer.DefaultPort := APort;
      LServer.Active := True;
      LogI(Format('Server started on port %s', [APort.ToString]));
      { more info about MaxConnections
        http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_MaxConnections.html }
      LServer.MaxConnections := Ini.ReadInteger('Config', 'MaxConnections', 0);
      { more info about ListenQueue
        http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_ListenQueue.html }
      LServer.ListenQueue := Ini.ReadInteger('Config', 'ListenQueue', 200);
      { Comment the next line to avoid the default browser startup }
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
    finally
      LServer.Free;
    end;
  finally
    Ini.Free;
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
