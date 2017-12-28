unit WS.HelloController;

interface

uses
  MVCFramework, MVCFramework.Commons;

type

  [MVCPath('/')]
  TWSHelloController = class(TMVCController)
  public
    [MVCPath('/')]
    [MVCHTTPMethod([httpGET])]
    [MVCProduces('text/html')]
    procedure Index;

    [MVCPath('/hello/($FirstName)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetSpecializedHello(const FirstName: String);
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;
  end;

implementation

uses WS.Common,
  MVCFramework.Logger, WS.Controller, oData.GenScript.Typescript;

procedure TWSHelloController.Index;
begin
  render('<http><body>'+
   'ODataBr - OData Server<hr />'+
   '  Hello teste:  <a href="./hello/MVCBr">/hello/[nome]</a><br>'+
  '  <a href="./system/describeserver.info">describeserver.info</a><br>'+
  '  <a href="./OData">OData Services</a><br>'+
  '  <a href="./OData/$metadata">OData $metadata</a><br>'+
  '  <a href="http://www.odata.org">Especificação by OData.Org</a><br>'+
  '<b>Geradores Scripts</b><br>'+
  '  <a href="./OData/hello/ng">Script Angular5</a>'+
   '<hr />Powered by: DelphiMVCFramework with OData/MVCBr'+
  '</body></http>');
end;

procedure TWSHelloController.GetSpecializedHello(const FirstName: String);
begin
  Render('Hello ' + FirstName);
end;

procedure TWSHelloController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TWSHelloController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;



initialization
   RegisterWSController(TWSHelloController);

end.
