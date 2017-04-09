unit ControlMover;

interface

uses
  FMX.Forms, FMX.Controls, System.Types, FMX.Types;

type
  TSaveProperties = record
    Control: TControl;
    Align: TAlignLayout;
    Position: TPointF;
  end;

  TGetMoveControlEvent = procedure(Sender: TObject; FocusedControl: TControl; var MoveControl: TControl) of object;

  TControlMover = class(TObject)
  private
    FForm: TCommonCustomForm;
    FSaveProps: TSaveProperties;
    FVKBounds: TRect;
    FVKVisible: Boolean;
    FOnGetMoveControl: TGetMoveControlEvent;
    procedure DoGetMoveControl;
    function GetFocusedControlOffset(KeyboardRect: TRect): Single;
    function GetStatusBarHeight: Single;
    function GetViewRect: TRectF;
    function FocusedControl: TControl;
    procedure FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
  public
    constructor Create(AForm: TCommonCustomForm);
    procedure SlideControl;
    property OnGetMoveControl: TGetMoveControlEvent read FOnGetMoveControl write FOnGetMoveControl;
  end;

implementation

uses
{$IFDEF IOS}
  iOSApi.Foundation, iOSApi.UIKit, FMX.Platform.iOS,
{$ENDIF}
  System.SysUtils, FMX.Memo;

{ TControlMover }

constructor TControlMover.Create(AForm: TCommonCustomForm);
begin
  inherited Create;
  FForm := AForm;
  FForm.OnVirtualKeyboardShown := FormVirtualKeyboardShown;
  FForm.OnVirtualKeyboardHidden := FormVirtualKeyboardHidden;
end;

procedure TControlMover.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FVKVisible := False;
  if Assigned(FSaveProps.Control) then
  begin
    FSaveProps.Control.AnimateFloat('Position.Y', FSaveProps.Position.Y, 0.1);
    FSaveProps.Control.Align := FSaveProps.Align;
  end;
end;

procedure TControlMover.FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FVKVisible := True;
  FVKBounds := Bounds;
  if FocusedControl = nil then
    Exit;
  DoGetMoveControl;
  if Assigned(FSaveProps.Control) then
  begin
    FSaveProps.Control.Align := TAlignLayout.alNone;
    FSaveProps.Position.Y := FSaveProps.Control.Position.Y;
    SlideControl;
  end;
end;

procedure TControlMover.DoGetMoveControl;
var
  MoveControl: TControl;
begin
  MoveControl := nil;
  if Assigned(FOnGetMoveControl) then
    FOnGetMoveControl(Self, FocusedControl, MoveControl);
  FSaveProps.Control := MoveControl;
end;

function TControlMover.FocusedControl: TControl;
begin
  Result := nil;
  if Assigned(FForm.Focused) and (FForm.Focused.GetObject is TControl) then
    Result := TControl(FForm.Focused.GetObject);
end;

function TControlMover.GetFocusedControlOffset(KeyboardRect: TRect): Single;
var
  Control: TControl;
  ControlPos: TPointF;
  ControlHeight: Single;
  Memo: TMemo;
  Caret: TCaret;
  ViewRect: TRectF;
begin
  Result := 0;
  Control := FocusedControl;
  if Assigned(Control) then
  begin
    ControlPos := Control.LocalToAbsolute(PointF(0, 0));
    ControlHeight := Control.Height;
    if Control is TMemo then
    begin
      Memo := TMemo(Control);
      Caret := Memo.Caret;
      ControlPos.Y := ControlPos.Y + (Caret.Pos.Y - Memo.ViewportPosition.Y);
      ControlHeight := Caret.Size.Height + 4;
    end;
    ViewRect := GetViewRect;
    Result := (ControlPos.Y + ControlHeight + 2)
      // Subtract the keyboard height from the view height to obtain the actual top of the keyboard
      - ((ViewRect.Bottom - ViewRect.Top) - (KeyboardRect.Bottom - KeyboardRect.Top))
      // Add the status bar height
      + GetStatusBarHeight;
    if Result < 0 then
      Result := 0;
  end;
end;

function TControlMover.GetStatusBarHeight: Single;
{$IFDEF IOS}
begin
  Result := 0;
  {$IFDEF CPUARM} // i.e. on an iOS device
  if TOSVersion.Check(7, 0) then
    Result := TUIApplication.wrap(TUIApplication.OCClass.SharedApplication).statusBarFrame.size.height;
  {$ENDIF}
end;
{$ELSE}
begin
  Result := 0;
end;
{$ENDIF}

function TControlMover.GetViewRect: TRectF;
{$IFDEF IOS}
var
  ARect: NSRect;
begin
  ARect := WindowHandleToPlatform(FForm.Handle).View.bounds;
  Result := RectF(ARect.origin.x, ARect.origin.y, ARect.size.width - ARect.origin.x, ARect.size.height - ARect.origin.y);
end;
{$ELSE}
begin
  // TODO - Android
end;
{$ENDIF}

procedure TControlMover.SlideControl;
begin
  if FVKVisible and Assigned(FSaveProps.Control) then
    FSaveProps.Control.AnimateFloat('Position.Y', FSaveProps.Control.Position.Y - GetFocusedControlOffset(FVKBounds), 0.1);
end;

end.
