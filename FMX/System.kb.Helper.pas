unit System.kb.Helper;

interface

uses
  System.Generics.Defaults, System.Messaging, System.Types, System.Classes,
  FMX.Forms, FMX.Controls;

type
  TVKControlManager = class(TSingletonImplementation)
  private
    class var FCurrent: TVKControlManager;
  private
    FFocusedParent: TControl;
    FPositionAdjusted: Boolean;
    FSavedHeight: Single;
    FSavedPositionY: Single;
    FVKVisible: Boolean;
    FVKRect: TRect;
    FOnPositionAdjusted: TNotifyEvent;
    FOnPositionRestored: TNotifyEvent;
    procedure DoPositionAdjusted;
    procedure DoPositionRestored;
    function GetFocusedControl: TControl;
    procedure PositionAdjust;
    procedure PositionRestore;
    procedure VirtualKeyboardChangeHandler(const Sender: TObject; const Msg: TMessage);
  public
    constructor Create;
    destructor Destroy; override;
    class function Current: TVKControlManager;
    procedure FormFocusChangedHandler(Sender: TObject);
    property FocusedParent: TControl read FFocusedParent;
    property OnPositionAdjusted: TNotifyEvent read FOnPositionAdjusted write FOnPositionAdjusted;
    property OnPositionRestored: TNotifyEvent read FOnPositionRestored write FOnPositionRestored;
  end;

implementation

uses
  System.Math,
  {$IF Defined(IOS)}
  FMX.Helpers.iOS,
  {$ENDIF}
  {$IF Defined(Android)}
  FMX.Helpers.Android,
  {$ENDIF}
  FMX.Types, FMX.Layouts;


function GetStatusBarHeight: Single;
begin
  {$IF Defined(IOS)}
  Result := Min(SharedApplication.statusBarFrame.size.width, SharedApplication.statusBarFrame.size.height);
  {$ELSE}
  Result := 0;
  {$ENDIF}
end;

{ TVKControlManager }

class function TVKControlManager.Current: TVKControlManager;
begin
  if FCurrent = nil then
    FCurrent := TVKControlManager.Create;
  Result := FCurrent;
end;

constructor TVKControlManager.Create;
begin
  inherited;
  TMessageManager.DefaultManager.SubscribeToMessage(TVKStateChangeMessage, VirtualKeyboardChangeHandler);
end;

destructor TVKControlManager.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TVKStateChangeMessage, VirtualKeyboardChangeHandler);
  inherited;
end;

procedure TVKControlManager.DoPositionAdjusted;
begin
  if Assigned(FOnPositionAdjusted) then
    FOnPositionAdjusted(Self);
end;

procedure TVKControlManager.DoPositionRestored;
begin
  if Assigned(FOnPositionRestored) then
    FOnPositionRestored(Self);
end;

procedure TVKControlManager.FormFocusChangedHandler(Sender: TObject);
begin
  if FVKVisible then
    PositionAdjust;
end;

procedure TVKControlManager.PositionAdjust;
var
  LControl: TControl;
  LAbsolute: TPointF;
  LOffset: Single;
begin
  LControl := GetFocusedControl;
  if LControl = nil then
    Exit; // <======
  LAbsolute := LControl.LocalToAbsolute(PointF(0,0));
  LOffset := GetStatusBarHeight + (LAbsolute.Y - FVKRect.Top) + LControl.Height;
  // Is the bottom of the control below the top of the VK?
  if (LAbsolute.Y + LOffset) > FVKRect.Top then
  begin
    FFocusedParent := LControl;
    // Find the furthest parent that is not nil, or is a scrollbox
    while (FFocusedParent.ParentControl <> nil) and not (FFocusedParent.ParentControl is TCustomScrollBox)  do
      FFocusedParent := FFocusedParent.ParentControl;
    // If the position has not been adjusted, save the current position and the parent's parent height (if any)
    if not FPositionAdjusted then
    begin
      FSavedPositionY := FFocusedParent.Position.Y;
      if FFocusedParent.ParentControl <> nil then
        FSavedHeight := FFocusedParent.ParentControl.Height;
    end;
    // Increase the parent's parent height (if any) to accomodate the shift
    if FFocusedParent.ParentControl <> nil then
      FFocusedParent.ParentControl.Height := FSavedHeight + LOffset;
    // Move the parent "up" so that the control is in view
    FFocusedParent.Position.Y := FSavedPositionY - LOffset;
    FPositionAdjusted := True;
    DoPositionAdjusted;
  end;
end;

procedure TVKControlManager.PositionRestore;
begin
  if FPositionAdjusted and (FFocusedParent <> nil) then
  begin
    if FFocusedParent.ParentControl <> nil then
      FFocusedParent.Height := FSavedHeight;
    FFocusedParent.Position.Y := FSavedPositionY;
  end;
  FPositionAdjusted := False;
  DoPositionRestored;
end;

function TVKControlManager.GetFocusedControl: TControl;
begin
  Result := nil;
  if (Screen.FocusControl <> nil) and (Screen.FocusControl.GetObject is TControl) then
    Result := TControl(Screen.FocusControl.GetObject);
end;

procedure TVKControlManager.VirtualKeyboardChangeHandler(const Sender: TObject; const Msg: TMessage);
begin
  if not FVKVisible and TVKStateChangeMessage(Msg).KeyboardVisible then
  begin
    FVKVisible := True;
    FVKRect := TVKStateChangeMessage(Msg).KeyboardBounds;
    PositionAdjust;
  end
  else if FVKVisible and not TVKStateChangeMessage(Msg).KeyboardVisible then
  begin
    FVKVisible := False;
    PositionRestore;
  end;
end;

end.

