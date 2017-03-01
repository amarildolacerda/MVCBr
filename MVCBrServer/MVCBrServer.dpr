program MVCBrServer;

 {$APPTYPE CONSOLE}

uses
  System.SysUtils,
  MVCFramework.Logger,
  MVCFramework.Commons,
  Winapi.Windows,
  Winapi.ShellAPI,
  ReqMulti,
  Web.WebReq,
  Web.WebBroker,
  IniFiles,
  IdHTTPWebBrokerBridge,
  MVCBr.ApplicationController,
  WS.WebModule in 'WS.WebModule.pas' {WSWebModule: TWebModule},
  WS.Controller.Interf in 'WS\WS.Controller.Interf.pas',
  WS.Controller in 'WS\WS.Controller.pas',
  MVC.oData.Base in '..\oData\MVC.oData.Base.pas',
  oData.Client.Builder in '..\oData\oData.Client.Builder.pas',
  oData.Client in '..\oData\oData.Client.pas',
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
  WS.Datamodule in 'WS.Datamodule.pas' {WSDatamodule: TDataModule};

{$R *.res}

procedure RunServer(APort: Integer);
var
  LInputRecord: TInputRecord;
  LEvent: DWord;
  LHandle: THandle;
  LServer: TIdHTTPWebBrokerBridge;
  Ini:TIniFile;
begin
  Ini:=TIniFile.create(ExtractFilePath(ParamStr(0)+'MVBrServer.ini'));
  try
  APort := ini.ReadInteger('Config','Port',8080);
  Writeln('** MVCBr / DMVCFramework Server ** build ' + DMVCFRAMEWORK_VERSION);
  Writeln(Format('Starting HTTP Server on port %d', [APort]));
  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    LServer.DefaultPort := APort;
    LServer.Active := True;
    LogI(Format('Server started on port %s', [APort.ToString]));
    { more info about MaxConnections
      http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_MaxConnections.html}
    LServer.MaxConnections := ini.ReadInteger('Config','MaxConnections',0);
    { more info about ListenQueue
      http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_ListenQueue.html}
    LServer.ListenQueue := ini.ReadInteger('Config','ListenQueue',200);
    { Comment the next line to avoid the default browser startup }
    ShellExecute(0, 'open', PChar('http://localhost:' + inttostr(APort)), nil, nil, SW_SHOWMAXIMIZED);
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
    ini.Free;
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

