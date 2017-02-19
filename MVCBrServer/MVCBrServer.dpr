program MVCBrServer;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  MVCBr.ApplicationController,
  WS.HelloController in 'WS.HelloController.pas',
  WS.QueryController in 'WS.QueryController.pas',
  WS.Controller.Interf in 'WS\WS.Controller.Interf.pas',
  WS.Controller in 'WS\WS.Controller.pas';

{$R *.res}

begin
  ApplicationController.Run( TWSController.New  );
end.
