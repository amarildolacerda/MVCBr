program MVCBrServerService;

uses
  Vcl.SvcMgr,
  MVCBr.Servico in 'MVCBr.Servico.pas' {MVCBrService: TService},
  MVCBr.ApplicationController in '..\MVCBr.ApplicationController.pas',
  MVCBr.ObjectConfigList in '..\MVCBr.ObjectConfigList.pas',
  MVC.oData.Base in '..\oData\MVC.oData.Base.pas',
  oData.Collections in '..\oData\oData.Collections.pas',
  oData.Dialect.Firebird in '..\oData\oData.Dialect.Firebird.pas',
  oData.Dialect.MySQL in '..\oData\oData.Dialect.MySQL.pas',
  oData.Dialect in '..\oData\oData.Dialect.pas',
  oData.Engine in '..\oData\oData.Engine.pas',
  oData.Interf in '..\oData\oData.Interf.pas',
  oData.JSON in '..\oData\oData.JSON.pas',
  oData.Parse in '..\oData\oData.Parse.pas',
  oData.ProxyBase in '..\oData\oData.ProxyBase.pas',
  oData.ServiceModel in '..\oData\oData.ServiceModel.pas',
  WSConfig.Controller.Interf in 'WSConfig\WSConfig.Controller.Interf.pas',
  WSConfig.Controller in 'WSConfig\WSConfig.Controller.pas',
  WSConfigView in 'WSConfig\WSConfigView.pas' {WSConfigView},
  MVCAsyncMiddleware in 'MVCAsyncMiddleware.pas',
  oData.SQL in '..\oData\oData.SQL.pas',
  oData.SQL.FireDAC in '..\oData\oData.SQL.FireDAC.pas',
  WS.Controller.Interf in 'WS\WS.Controller.Interf.pas',
  WS.Controller in 'WS\WS.Controller.pas',
  WS.QueryController in 'WS\WS.QueryController.pas',
  WS.Common in 'WS\WS.Common.pas';

{$R *.RES}

begin
  // Windows 2003 Server requires StartServiceCtrlDispatcher to be
  // called before CoRegisterClassObject, which can be called indirectly
  // by Application.Initialize. TServiceApplication.DelayInitialize allows
  // Application.Initialize to be called from TService.Main (after
  // StartServiceCtrlDispatcher has been called).
  //
  // Delayed initialization of the Application object may affect
  // events which then occur prior to initialization, such as
  // TService.OnCreate. It is only recommended if the ServiceApplication
  // registers a class object with OLE and is intended for use with
  // Windows 2003 Server.
  //
  // Application.DelayInitialize := True;
  //
  ReportMemoryLeaksOnShutdown := True;

  if not Vcl.SvcMgr.Application.DelayInitialize or Vcl.SvcMgr.Application.Installing then
    Vcl.SvcMgr.Application.Initialize;
  Vcl.SvcMgr.Application.CreateForm(TMVCBrService, MVCBrService);
  Vcl.SvcMgr.Application.Run;

end.
