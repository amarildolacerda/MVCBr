unit MVCServerAdmin;

interface

uses
  System.Classes, System.SysUtils,
  MVCFramework, MVCFramework.Commons;

type

  [MVCPath('/OData/admin')]
  TODataUsers = class(TMVCController)
  public
    [MVCPath('/token/new')]
    [MVCHTTPMethod([httpGET])]
    procedure TokenNew;

    [MVCPath('/hellos/($FirstName)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetSpecializedHello(const FirstName: String);
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string;
      var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext;
      const AActionName: string); override;
  end;

implementation

uses
  WS.Common,
  MVCFramework.Logger, OData.Packet;

procedure TODataUsers.TokenNew;
var
  s: string;
  r: IODataJsonPacket;
begin
  r :=  TODataJsonPacket.New( self.context.Request.PathInfo ,true);
  r.GenValue('token', TGuid.NewGuid.ToString());
  Render(r.AsJsonObject);
end;

procedure TODataUsers.GetSpecializedHello(const FirstName: String);
begin
  Render('Hello ' + FirstName);
end;

procedure TODataUsers.OnAfterAction(Context: TWebContext;
  const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TODataUsers.OnBeforeAction(Context: TWebContext;
  const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

initialization

RegisterWSController(TODataUsers);

end.
