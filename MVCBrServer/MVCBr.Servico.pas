{  

   MVCBr - OData Service
   Coder: Giovani Da Cruz 2017-03-20 
   
}

{
  Alterações:
    * 01/04/2017 - alterado o RunServer para permitir rodar em loop do serviço - por: amarildo lacerda
    * 02/04/2017 - alterado para gravar configurações no MVCBrServer.json - por: AL
}

unit MVCBr.Servico;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs;

type
  TMVCBrService = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    FCanStop: Boolean;
  public
    property CanStop: Boolean read FCanStop write FCanStop;
    function GetServiceController: TServiceController; override;
    procedure RunServer(APort: Integer);
  end;

var
  MVCBrService: TMVCBrService;

implementation

{$R *.dfm}

uses
  MVCBr.ApplicationController,

  WS.Controller,
  WS.WebModule,

  MVCFramework.Logger,
  MVCFramework.Commons,

  IdHTTPWebBrokerBridge,

  Web.ReqMulti,
  Web.WebBroker,
  Web.WebReq,

  System.Win.Registry,
  System.JsonFiles;

var
  LServer: TIdHTTPWebBrokerBridge;

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
  Ini: TJsonFile;
begin
  Ini := TJsonFile.create(ExtractFilePath(ParamStr(0)) + 'MVCBrServer.config');
  try

    APort := Ini.ReadInteger('Config', 'WSPort', 8080);
//    LogI('** MVCBr / DMVCFramework Server Service ** build ' +
//      DMVCFRAMEWORK_VERSION);

    LServer := TIdHTTPWebBrokerBridge.create(nil);
    try
      LServer.DefaultPort := APort;
//      LogI(Format('Server started on port %s', [APort.ToString]));

      { more info about MaxConnections
        http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_MaxConnections.html }
      LServer.MaxConnections := Ini.ReadInteger('Config', 'MaxConnections', 0);

      { more info about ListenQueue
        http://www.indyproject.org/docsite/html/frames.html?frmname=topic&frmfile=TIdCustomTCPServer_ListenQueue.html }
      LServer.ListenQueue := Ini.ReadInteger('Config', 'ListenQueue', 200);


      LServer.Active := True;

      LHandle := GetStdHandle(STD_INPUT_HANDLE);
      (* while not (CanStop) do
        begin
        { Service Run... }
        end; *)
    finally
      // LServer.Free;
    end;
  finally
    Ini.Free;
  end;

end;

procedure TMVCBrService.ServiceAfterInstall(Sender: TService);
var
  regEdit: TRegistry;
begin
  regEdit := TRegistry.create(KEY_READ or KEY_WRITE);
  try
    regEdit.RootKey := HKEY_LOCAL_MACHINE;

    if regEdit.OpenKey('\SYSTEM\CurrentControlSet\Services\' + Name, False) then
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
  CanStop := False;
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

procedure TMVCBrService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  CanStop := True;
end;

end.
