library MVCBrServer_ISAPI;

uses
  Winapi.ActiveX,
  System.Win.ComObj,
  Web.WebBroker,
  Web.Win.ISAPIApp,
  Web.Win.ISAPIThreadPool,
  LoggerPro,
  LoggerPro.FileAppender,
  MVCFramework.Logger,
  MVCFramework.Commons,

  WS.WebModule in 'WS.WebModule.pas' {WSWebModule: TWebModule},
  WS.Common in 'WS\WS.Common.pas',
  WS.Controller.Interf in 'WS\WS.Controller.Interf.pas',
  WS.Controller in 'WS\WS.Controller.pas',
  WS.QueryController in 'WS\WS.QueryController.pas',
  WSConfig.Controller.Interf in 'WSConfig\WSConfig.Controller.Interf.pas',
  WSConfig.Controller in 'WSConfig\WSConfig.Controller.pas',
  WSConfigView in 'WSConfig\WSConfigView.pas' {WSConfigView};

//  WebModuleU in '..\DMVC\samples\ISAPI\WebModules\WebModuleU.pas' {WebModule1: TWebModule},
//  BusinessObjectsU in '..\DMVC\samples\ISAPI\BO\BusinessObjectsU.pas',
//  RoutingSampleControllerU in '..\DMVC\samples\ISAPI\Controllers\RoutingSampleControllerU.pas';

{$R *.res}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  CoInitFlags := COINIT_MULTITHREADED;
  Application.Initialize;
  Application.WebModuleClass := WebModuleClass;

    MVCFramework.Logger.SetDefaultLogger
      (BuildLogWriter([TLoggerProFileAppender.Create(5, 2000, AppPath + 'logs')
      ], nil, TLogType(TLogType.Error)));

  Application.Run;
end.
