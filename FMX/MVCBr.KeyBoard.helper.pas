unit MVCBr.KeyBoard.helper;
// unit vkbdhelper;

{
  Force focused control visible when Android/IOS Virtual Keyboard showed or hiden
  How to use:
  place vkdbhelper into your project uses section. No more code needed.

  == Known issues == :
  * after device rotation keyboard can change height without form notification.
  this can move focused control to wrong y-coord...
  * sometimes keyboard_show notification become with wrong size calc.
  Especially after device rotation (hide keyboard-rotate device-show keyboard). Why??? I don`t know...
  But standart demo app (Scrollable form demo) has same behavior.
  Changes by kami
  =======
  2016.03.14
  * Total rewrite. Only idea and fundamental points have not changed, all others - rewrited.
  * Add new function - ControlIsIgnored. If returns True, then this control
  will not be moved to common layout. Designed for custom keyboards, based on frames.
  If you not need this functionality, you can simply return False in this function.
  2016.02.29
  * fix issue with double-raised Keyboard_Show event, when FocusedControl.AbsoluteRect
  is already "upped" by own TLayout.
  2016.02.28
  * fix issue with Form.Fill vanish after AdjustByLayout applied.
  * disable not needed (???) timer proc.
  * improve own TLayout detection.
  * some refactoring
  2016.01.26
  * fix issue with wrong VK coordinates calculation. Remove VKOffset.
  Changes by ZuBy
  ======= =======
  2016.01.24
  * clean Uses section
  * top margin value for Virtual Keyboard (global var VKOffset := [integer])
  * now cross-platform (IOS, Android)
  Changes
  =======
  2015.7.12
  * Fix space after hide ime and rotate
  * Fix rotate detection
}
interface

implementation

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  System.Types,
  System.Messaging,
  FMX.Types,
  FMX.Controls,
  FMX.Layouts,
  FMX.Objects,
  FMX.Forms;

type
  TVKStateHandler = class(TComponent)
  protected
    FVKMsgId: Integer;
    FSizeMsgId: Integer;

    FVKBounds: TRectF;

    FLayoutTag: Integer;
    FLastControl: TControl;

    FOldCalcContentBounds: TOnCalcContentBoundsEvent;

    function IsVKVisible: Boolean;
    function GetVKBounds(var ARect: TRect; NewFormSize: TSize): Boolean;

    function FindCommonLayout(AParent: TCommonCustomForm): TLayout;
    function FindOrCreateCommonLayout(AForm: TCommonCustomForm): TLayout;
    function FindOffsettedScrollBox(AControl: TControl; VKBounds: TRectF)
      : TCustomScrollBox;
    function GetParentForm(AControl: TFmxObject): TCommonCustomForm;

    procedure MoveCtrls(AOldParent: TCommonCustomForm; ANewParent: TFmxObject);

    procedure OffsetForControl(AMovedLayout: TLayout; FocusedControl: TControl);
    procedure ScrollIntoControl(AScrollBox: TCustomScrollBox;
      FocusedControl: TControl);

    procedure CalcScrollBoxContentBounds(Sender: TObject;
      var ContentBounds: TRectF);

    procedure DoVKVisibleChanged(const Sender: TObject;
      const Msg: System.Messaging.TMessage);
    procedure DoSizeChanged(const Sender: TObject;
      const Msg: System.Messaging.TMessage);
    procedure LastControlNotification(AComponent: TComponent;
      Operation: TOperation);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); overload; override;
    destructor Destroy; override;
  end;

var
  VKHandler: TVKStateHandler;

const
  sVKBHelperLayout = 'ltVKBHelperLayout';

function ControlIsBackground(AControl: TFmxObject): Boolean;
begin
  Result := (AControl is TRectangle) and (AControl.Parent is TCommonCustomForm)
    and (TRectangle(AControl).Align = TAlignLayout.Contents);
end;

function ControlIsIgnored(AControl: TFmxObject): Boolean;
begin
  Result := AControl.TagFloat = -1.5;
end;

function ControlIsCommonLayout(AControl: TFmxObject): Boolean;
begin
  Result := (AControl is TLayout) and (AControl.Parent is TCommonCustomForm) and
    (StartsStr(sVKBHelperLayout, AControl.Name));
end;

{ TVKStateHandler }
procedure TVKStateHandler.CalcScrollBoxContentBounds(Sender: TObject;
  var ContentBounds: TRectF);
  function Max(A, B: Single): Single;
  begin
    if A > B then
      Result := A
    else
      Result := B;
  end;

begin
  if IsVKVisible and (FVKBounds.Top > 0) and (Sender is TControl) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom,
      2 * TControl(Sender).Height);
  end;
end;

constructor TVKStateHandler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVKMsgId := TMessageManager.DefaultManager.SubscribeToMessage
    (TVKStateChangeMessage, DoVKVisibleChanged);
  FSizeMsgId := TMessageManager.DefaultManager.SubscribeToMessage
    (TSizeChangedMessage, DoSizeChanged);
end;

destructor TVKStateHandler.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TVKStateChangeMessage, FVKMsgId);
  TMessageManager.DefaultManager.Unsubscribe(TSizeChangedMessage, FSizeMsgId);
  inherited;
end;

procedure TVKStateHandler.DoSizeChanged(const Sender: TObject;
  const Msg: System.Messaging.TMessage);
var
  ASizeMsg: TSizeChangedMessage absolute Msg;
  R: TRect;
begin
  if Sender = Screen.ActiveForm then
    if GetVKBounds(R, ASizeMsg.Value) then
      TMessageManager.DefaultManager.SendMessage(Sender,
        TVKStateChangeMessage.Create(true, R));
end;

procedure TVKStateHandler.DoVKVisibleChanged(const Sender: TObject;
  const Msg: System.Messaging.TMessage);
var
  AVKMsg: TVKStateChangeMessage absolute Msg;
  FocusedControl: TControl;

var
  tmpParentForm: TCommonCustomForm;
  tmpScrollBox: TCustomScrollBox;
  tmpLayout: TLayout;
begin
  if AVKMsg.KeyboardVisible then
  begin

    if Screen.FocusControl <> nil then
    begin
      FocusedControl := Screen.FocusControl.GetObject as TControl;

      tmpParentForm := GetParentForm(FocusedControl);
      FVKBounds := TRectF.Create(AVKMsg.KeyboardBounds);
      if Assigned(tmpParentForm) then
      begin
        FVKBounds.TopLeft := tmpParentForm.ScreenToClient(FVKBounds.TopLeft);
        FVKBounds.BottomRight := tmpParentForm.ScreenToClient
          (FVKBounds.BottomRight);
      end;

      tmpScrollBox := FindOffsettedScrollBox(FocusedControl, FVKBounds);
      if Assigned(tmpScrollBox) then
      begin
        tmpScrollBox.FreeNotification(Self);
        LastControlNotification(tmpScrollBox, TOperation.opInsert);
        ScrollIntoControl(tmpScrollBox, FocusedControl);
      end
      else
      begin
        tmpLayout := FindOrCreateCommonLayout(tmpParentForm);
        tmpLayout.FreeNotification(Self);
        LastControlNotification(tmpLayout, TOperation.opInsert);
        OffsetForControl(tmpLayout, FocusedControl);
      end;
    end
  end
  else
  begin
    FVKBounds := TRectF.Empty;
    if Assigned(FLastControl) then
    begin
      FLastControl.RemoveFreeNotification(Self);
      LastControlNotification(FLastControl, opRemove);
    end;
  end;
end;

function TVKStateHandler.FindCommonLayout(AParent: TCommonCustomForm): TLayout;
var
  i: Integer;
begin
  Result := nil;
  if not Assigned(AParent) then
    Exit;
  if AParent.ChildrenCount = 0 then
    Exit;

  for i := 0 to AParent.ChildrenCount - 1 do
  begin
    if ControlIsBackground(AParent.Children[i]) then
      Continue;
    if ControlIsCommonLayout(AParent.Children[i]) then
    begin
      Result := TLayout(AParent.Children[i]);
      Continue;
    end;
    if ControlIsIgnored(AParent.Children[i]) then
      Continue;
    Result := nil;
    Break;
  end;
end;

function TVKStateHandler.FindOffsettedScrollBox(AControl: TControl;
  VKBounds: TRectF): TCustomScrollBox;
var
  FocusedControlRect: TRectF;
  tmpParent: TFmxObject;
begin
  Result := nil;
  FocusedControlRect := AControl.AbsoluteRect;

  tmpParent := AControl.Parent;
  while Assigned(tmpParent) do
  begin
    if (tmpParent is TCustomScrollBox) then
      if (TCustomScrollBox(tmpParent).AbsoluteRect.Top +
        FocusedControlRect.Height) < VKBounds.Top then
      begin
        Result := TCustomScrollBox(tmpParent);
        Break;
      end;
    tmpParent := tmpParent.Parent;
  end;
end;

function TVKStateHandler.FindOrCreateCommonLayout
  (AForm: TCommonCustomForm): TLayout;
begin
  Result := FindCommonLayout(AForm);
  if not Assigned(Result) then
  begin
    Result := TLayout.Create(AForm);
    Result.Parent := AForm;
    Result.Name := sVKBHelperLayout + FLayoutTag.ToString;
    Result.Align := TAlignLayout.None;
    Result.SetBounds(0, 0, AForm.Width, AForm.Height);
    Inc(FLayoutTag);
    MoveCtrls(AForm, Result);
  end;
end;

function TVKStateHandler.GetParentForm(AControl: TFmxObject): TCommonCustomForm;
var
  tmpParent: TFmxObject;
begin
  Result := nil;
  tmpParent := AControl.Parent;
  while Assigned(tmpParent) do
  begin
    if tmpParent is TCommonCustomForm then
      Result := TCommonCustomForm(tmpParent);
    tmpParent := tmpParent.Parent;
  end;
end;

function TVKStateHandler.GetVKBounds(var ARect: TRect;
  NewFormSize: TSize): Boolean;
var
  fm: TCommonCustomForm;
  ContentRect: TRectF;
begin
  Result := IsVKVisible;
  if Result then
  begin
    fm := Screen.ActiveForm;
    FVKBounds.Width := fm.ClientWidth;
    FVKBounds.Offset(0, { fm.top + } fm.ClientHeight - FVKBounds.Bottom);
    ContentRect.TopLeft := fm.ClientToScreen(FVKBounds.TopLeft);
    ContentRect.BottomRight := fm.ClientToScreen(FVKBounds.BottomRight);
    ARect := ContentRect.Truncate;
  end;
end;

function TVKStateHandler.IsVKVisible: Boolean;
begin
  Result := not FVKBounds.IsEmpty;
end;

procedure TVKStateHandler.LastControlNotification(AComponent: TComponent;
  Operation: TOperation);
var
  tmpControl: TControl;
begin
  if Assigned(FLastControl) then
    if (AComponent = FLastControl) and (Operation = TOperation.opRemove) or
      ((AComponent <> FLastControl) and (Operation = TOperation.opInsert)) then
    begin
      if ControlIsCommonLayout(FLastControl) then
      begin
        TLayout(FLastControl).Align := TAlignLayout.Client;
      end;
      if FLastControl is TCustomScrollBox then
      begin
        TCustomScrollBox(FLastControl).OnCalcContentBounds :=
          FOldCalcContentBounds;
        TCustomScrollBox(FLastControl).RealignContent;
        FOldCalcContentBounds := nil;
      end;
      tmpControl := FLastControl;
      FLastControl := nil;
      tmpControl.RemoveFreeNotification(Self);
    end;

  if (Operation = TOperation.opInsert) and (AComponent is TControl) then
  begin
    if ControlIsCommonLayout(TControl(AComponent)) then
    begin
      TControl(AComponent).Align := TAlignLayout.None;
      TControl(AComponent).SetBounds(0, 0,
        TCommonCustomForm(TControl(AComponent).Parent).ClientWidth,
        TCommonCustomForm(TControl(AComponent).Parent).ClientHeight);
    end;
    if (AComponent is TCustomScrollBox) and (AComponent <> FLastControl) then
    begin
      FOldCalcContentBounds := TCustomScrollBox(AComponent).OnCalcContentBounds;
      TCustomScrollBox(AComponent).OnCalcContentBounds :=
        CalcScrollBoxContentBounds;
      TCustomScrollBox(AComponent).RealignContent;
    end;
    FLastControl := TControl(AComponent);
  end;
end;

procedure TVKStateHandler.MoveCtrls(AOldParent: TCommonCustomForm;
  ANewParent: TFmxObject);
var
  i: Integer;
  AChild: TFmxObject;
begin
  i := 0;
  while i < AOldParent.ChildrenCount do
  begin
    AChild := AOldParent.Children[i];
    if AChild <> ANewParent then
    begin
      if AChild.Parent = AOldParent then
        if (not ControlIsBackground(AChild)) and (not ControlIsIgnored(AChild))
        then
        begin
          AChild.Parent := ANewParent;
          Continue;
        end;
    end;
    Inc(i);
  end;
end;

procedure TVKStateHandler.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  LastControlNotification(AComponent, Operation);
  inherited;
end;

procedure TVKStateHandler.OffsetForControl(AMovedLayout: TLayout;
  FocusedControl: TControl);
var
  FocusedRect: TRectF;
begin
  FocusedRect := FocusedControl.AbsoluteRect;
  FocusedRect.Offset(0, -AMovedLayout.Position.Y);
  if FocusedRect.IntersectsWith(FVKBounds) then
    AMovedLayout.SetBounds(AMovedLayout.Position.X,
      FVKBounds.Top - FocusedRect.Bottom, AMovedLayout.Width,
      AMovedLayout.Height);
end;

procedure TVKStateHandler.ScrollIntoControl(AScrollBox: TCustomScrollBox;
  FocusedControl: TControl);
var
  FocusRect: TRectF;
begin
  FocusRect := FocusedControl.AbsoluteRect;
  FocusRect.Offset(AScrollBox.ViewportPosition);

  if (FocusRect.IntersectsWith(FVKBounds)) and (FocusRect.Bottom > FVKBounds.Top)
  then
  begin
    AScrollBox.ViewportPosition := PointF(AScrollBox.ViewportPosition.X,
      FocusRect.Bottom - FVKBounds.Top);
  end;
end;

initialization

VKHandler := TVKStateHandler.Create(nil);

finalization

FreeAndNil(VKHandler);

end.
