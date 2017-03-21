unit MVCBr.Servico;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs;

type
  TMVCBrService = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceAfterInstall(Sender: TService);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    procedure RunServer(APort: Integer);
  end;

var
  MVCBrService: TMVCBrService;

implementation

{$R *.dfm}

uses
  System.Win.Registry,

  MVCBr.ApplicationController,
  WS.Controller,
  Web.WebReq,
  WS.WebModule,

  Winapi.ShellAPI,
  ReqMulti,
  IdHTTPWebBrokerBridge,

  MVCFramework.Logger,
  MVCFramework.Commons,

  Web.WebBroker,
  IniFiles;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  MVCBrService.Controller(CtrlCode);
end;

function TMVCBrService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TMVCBrService.RunServer(APort: Integer);
var
  LInputRecord: TInputRecord;
  LEvent: DWord;
  LHandle: THandle;
  LServer: TIdHTTPWebBrokerBridge;
  Ini: TIniFile;
begin
  Ini := TIniFile.create(ExtractFilePath(ParamStr(0) + 'MVBrServer.ini'));
  try

    APort := Ini.ReadInteger('Config', 'Port', 8080);
    Writeln('** MVCBr / DMVCFramework Server ** build ' +
      DMVCFRAMEWORK_VERSION);
    //Writeln(Format('Starting HTTP Server on port %d', [APort]));
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
      //ShellExecute(0, 'open', PChar('http://localhost:' + inttostr(APort)), nil,
       // nil, SW_SHOWMAXIMIZED);
      //Writeln('Press ESC to stop the server');

      LHandle := GetStdHandle(STD_INPUT_HANDLE);
      while True do
      begin
        //Win32Check(ReadConsoleInput(LHandle, LInputRecord, 1, LEvent));
       // if (LInputRecord.EventType = KEY_EVENT) and
        //  LInputRecord.Event.KeyEvent.bKeyDown and
         // (LInputRecord.Event.KeyEvent.wVirtualKeyCode = VK_ESCAPE) then
         // break;
      end;
    finally
      LServer.Free;
    end;
  finally
    Ini.Free;
  end;

end;

procedure TMVCBrService.ServiceAfterInstall(Sender: TService);
var
  regEdit : TRegistry;
begin
  regEdit := TRegistry.Create(KEY_READ or KEY_WRITE);
  try
    regEdit.RootKey := HKEY_LOCAL_MACHINE;

    if regEdit.OpenKey('\SYSTEM\CurrentControlSet\Services\' + Name,False) then
    begin
      regEdit.WriteString('Description', 'Servidor MVCBr');
      regEdit.CloseKey;
    end;

  finally
    FreeAndNil(regEdit);
  end;

end;

procedure TMVCBrService.ServiceStart(Sender: TService; var Started: Boolean);
begin

  ApplicationController.Run(TWSController.New);
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
end;

end.
