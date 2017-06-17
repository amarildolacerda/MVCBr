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
  oData.Interf,

  WS.WebModule in 'WS.WebModule.pas' {WSWebModule: TWebModule},
  WSConfig.Controller.Interf in 'WSConfig\WSConfig.Controller.Interf.pas',
  WSConfig.Controller in 'WSConfig\WSConfig.Controller.pas',
  WSConfigView in 'WSConfig\WSConfigView.pas' {WSConfigView},
  WS.Common in 'WS\WS.Common.pas',
  WS.Controller.Interf in 'WS\WS.Controller.Interf.pas',
  WS.Controller in 'WS\WS.Controller.pas',
  WS.QueryController in 'WS\WS.QueryController.pas',
  MVCAsyncMiddleware in 'MVCAsyncMiddleware.pas',
  MVCgzipMiddleware in 'MVCgzipMiddleware.pas',
  MVCSupportZLib in 'MVCSupportZLib.pas',
  WS.Datamodule in 'WS.Datamodule.pas' {WSDatamodule: TDataModule},
  WS.HelloController in 'WS.HelloController.pas',
  MVC.oData.Base in '..\oData\MVC.oData.Base.pas';

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
      (BuildLogWriter([TLoggerProFileAppender.Create(5, 2000, GetODataConfigFilePath + 'logs')
      ], nil, TLogType.Error));


  Application.Run;



end.
