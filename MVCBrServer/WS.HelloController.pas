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

uses
  MVCFramework.Logger, WS.Controller;

procedure TWSHelloController.Index;
begin
  //use Context property to access to the HTTP request and response
  //ContentType := 'text/html';
  render('<http><body>Hello MVCBr <br>Para teste:  <a href="/hello/MVCBr">/hello/[nome]</a><br>'+
  '<a href="/system/describeserver.info">describeserver.info</a>'+
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
