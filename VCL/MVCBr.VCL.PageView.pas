unit MVCBr.VCL.PageView;

{ .$define USE_PG_INTERPOSE }

interface

uses VCL.Forms, VCL.Controls, System.Classes, System.SysUtils, MVCBr.Interf,
  WinApi.Windows, System.Types,
  WinApi.Messages,
  MVCBr.PageView, MVCBr.FormView, VCL.ComCtrls;

const
  WM_TABSHEET_CLOSE = WM_USER + 1;

type

  TMVCBrPageControl = class(TPageControl)
  private
    FCloseButtonMouseDownTab: TTabSheet;
    FCloseButtonShowPushed: boolean;
    FShowTabClose: boolean;
    procedure PageControlCloseButtonDrawTab(Control: TCustomTabControl;
      TabIndex: integer; const Rect: TRect; Active: boolean);
    function GetActivePage: TTabSheet;
    procedure SetActivePage(const Value: TTabSheet);
    function GetPages(idx: integer): TTabSheet;
    procedure PageControlCloseButtonMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure PageControlCloseButtonMouseLeave(Sender: TObject);
    procedure PageControlCloseButtonMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: integer);
    procedure PageControlCloseButtonMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure SetShowTabClose(const Value: boolean);
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    function FindNextPage(CurPage: TTabSheet;
      GoForward, CheckTabVisible: boolean): TTabSheet;
    property ActivePage: TTabSheet read GetActivePage write SetActivePage;
    property Pages[idx: integer]: TTabSheet read GetPages;
    property ShowTabClose: boolean read FShowTabClose write SetShowTabClose;
  end;

{$IFDEF USE_PG_INTERPOSE}

  TPageControl = class(TMVCBrPageControl);
{$ENDIF}
  TVCLpageViewOnQueryClose = procedure(APageView: IPageView;
    var ACanClose: boolean) of object;

  TVCLPageViewManager = class(TCustomPageViewFactory, IPageViews)
  private
    FOldPageChange: TNotifyEvent;
    FOnQueryClose: TVCLpageViewOnQueryClose;
    FAfterTabCreate: TNotifyEvent;
    FAfterCreateComplete: TNotifyEvent;
    procedure Init(APageView: TPageView); override;
    procedure SetPageControlEx(const Value: TPageControl);
    function GetPageControlEx: TPageControl;
    procedure SetOnQueryClose(const Value: TVCLpageViewOnQueryClose);
    procedure SetAfterTabCreate(const Value: TNotifyEvent);
    procedure SetAfterCreateComplete(const Value: TNotifyEvent);
    procedure DoPageChange(Sender: TObject);
    procedure DoFormCloseQuery(Sender: TObject; var canClose: boolean);
    function TabsheetIndexOf(tab: TObject): integer;
    procedure DoTabClose(Sender: TObject);
    function IndexOfTab(Sender: TObject): integer;
  protected
    Procedure DoQueryClose(const APageView: TPageView;
      var ACanClose: boolean); override;
    procedure SetActivePage(Const tab: TObject); override;
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;
    function GetPageViewClass: TPageViewClass; override;

  public
    class function New(AController: IController): IPageViews;
    [weak]
    function Update: IModel; virtual;

    function GetPageTabClass: TComponentClass; override;
    function GetPageContainerClass: TComponentClass; override;
    function NewTab(APageView: TPageView): TObject; override;
    function AddView(AView: IView; ABoforeShow: TProc<IView>)
      : TPageView; override;
    function AddView(AView: IView): TPageView; override;
    function AddView(Const AController: TGuid): TPageView; overload; override;
  published
    property PageControl: TPageControl read GetPageControlEx
      write SetPageControlEx;
    property AfterViewCreate;
    property AfterCreateComplete: TNotifyEvent read FAfterCreateComplete
      write SetAfterCreateComplete;
    property AfterTabCreate: TNotifyEvent read FAfterTabCreate
      write SetAfterTabCreate;
    property OnQueryClose: TVCLpageViewOnQueryClose read FOnQueryClose
      write SetOnQueryClose;
  end;

procedure register;

implementation

uses System.Classes.Helper, VCL.Graphics, MVCBr.Controller, VCL.Themes,
  VCL.Styles;

procedure register;
begin
  RegisterComponents('MVCBr', [TMVCBrPageControl, TVCLPageViewManager]);
end;

type

  TTabSheetView = class(TTabSheet)
  private
    FCloseButtonRect: TRect;
    FOnClose: TNotifyEvent;
    FShowTabClose: boolean;
    FReleased: boolean;
    procedure SetOnClose(const Value: TNotifyEvent);
    procedure SetShowTabClose(const Value: boolean);
    function GetCaption: string;
    procedure SetCaption(const Value: string);
  protected
    FPageView: TPageView;
    Procedure DoCloseMessage(var TMessage); message WM_TABSHEET_CLOSE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoClose; virtual;
    procedure canClose(var ACanClose: boolean);
  published
    property OnClose: TNotifyEvent read FOnClose write SetOnClose;
    Property ShowTabClose: boolean read FShowTabClose write SetShowTabClose;
    property Caption: string read GetCaption write SetCaption;
  public
  end;

function IsTabSheetView(ts: TTabSheet): boolean;
begin
  result := false;
  if assigned(ts) then
    result := ts.InheritsFrom(TTabSheetView);
end;

function IsShowTabClose(ts: TTabSheet): boolean;
begin
  result := false;
  if IsTabSheetView(ts) then
    result := TTabSheetView(ts).FShowTabClose;
end;

function IsPgShowTabClose(pc: TPageControl): boolean;
begin
  result := false;
  if assigned(pc) and pc.InheritsFrom(TMVCBrPageControl) then
    result := TMVCBrPageControl(pc).ShowTabClose;
end;

function TMVCBrPageControl.GetActivePage: TTabSheet;
begin
  result := TTabSheet(inherited ActivePage);
end;

function TMVCBrPageControl.GetPages(idx: integer): TTabSheet;
begin
  result := TTabSheet(inherited Pages[idx]);
end;

procedure TMVCBrPageControl.PageControlCloseButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  I: integer;
  PageControl: TPageControl;
  TabSheet: TTabSheet;
begin
  PageControl := Sender as TPageControl;

  if Button = mbLeft then
  begin
    for I := 0 to PageControl.PageCount - 1 do
    begin
      if not(PageControl.Pages[I] is TTabSheet) then
        Continue;
      TabSheet := PageControl.Pages[I] as TTabSheet;

      if IsTabSheetView(TabSheet) and
        PtInRect(TTabSheetView(TabSheet).FCloseButtonRect, Point(X, Y)) then
      begin
        FCloseButtonMouseDownTab := TabSheet;
        FCloseButtonShowPushed := True;
        PageControl.Repaint;
      end;
    end;
  end;
end;

procedure TMVCBrPageControl.PageControlCloseButtonMouseLeave(Sender: TObject);
var
  PageControl: TPageControl;
begin
  PageControl := Sender as TPageControl;
  FCloseButtonShowPushed := false;
  PageControl.Repaint;
end;

constructor TMVCBrPageControl.Create(AOwner: TComponent);
begin
  inherited;
  OnDrawTab := PageControlCloseButtonDrawTab;
  OnMouseDown := PageControlCloseButtonMouseDown;
  OnMouseLeave := PageControlCloseButtonMouseLeave;
  OnMouseMove := PageControlCloseButtonMouseMove;
  OnMouseUp := PageControlCloseButtonMouseUp;
  OwnerDraw := True;

end;

destructor TMVCBrPageControl.Destroy;
begin

  inherited;
end;

function TMVCBrPageControl.FindNextPage(CurPage: TTabSheet;
  GoForward, CheckTabVisible: boolean): TTabSheet;
begin
  result := TTabSheet(inherited FindNextPage(CurPage, GoForward,
    CheckTabVisible));
end;

procedure TMVCBrPageControl.PageControlCloseButtonMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: integer);
var
  PageControl: TPageControl;
  Inside: boolean;
begin
  PageControl := Sender as TPageControl;

  if IsTabSheetView(FCloseButtonMouseDownTab) then
    if (ssLeft in Shift) and assigned(FCloseButtonMouseDownTab) then
    begin
      Inside := PtInRect(TTabSheetView(FCloseButtonMouseDownTab)
        .FCloseButtonRect, Point(X, Y));
      if FCloseButtonShowPushed <> Inside then
      begin
        FCloseButtonShowPushed := Inside;
        PageControl.Repaint;
      end;
    end;
end;

procedure TMVCBrPageControl.PageControlCloseButtonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  PageControl: TPageControl;
begin
  PageControl := Sender as TPageControl;

  if (Button = mbLeft) and assigned(FCloseButtonMouseDownTab) and
    IsTabSheetView(FCloseButtonMouseDownTab) then
  begin
    if PtInRect(TTabSheetView(FCloseButtonMouseDownTab).FCloseButtonRect,
      Point(X, Y)) then
    begin
      postMessage(FCloseButtonMouseDownTab.Handle, WM_TABSHEET_CLOSE, 0, 0);
      FCloseButtonMouseDownTab := nil;
      PageControl.Repaint;
    end;
  end;
end;

procedure TMVCBrPageControl.PageControlCloseButtonDrawTab
  (Control: TCustomTabControl; TabIndex: integer; const Rect: TRect;
  Active: boolean);
var
  CloseBtnSize: integer;
  PageControl: TPageControl;
  TabSheet: TTabSheet;
  TabCaption: TPoint;
  CloseBtnRect: TRect;
  CloseBtnDrawState: Cardinal;
  CloseBtnDrawDetails: TThemedElementDetails;
begin

  PageControl := Control as TPageControl;
  TabCaption.Y := Rect.Top + 3;

  if Active then
  begin
    CloseBtnRect.Top := Rect.Top + 4;
    CloseBtnRect.Right := Rect.Right - 5;
    TabCaption.X := Rect.Left + 6;
  end
  else
  begin
    CloseBtnRect.Top := Rect.Top + 3;
    CloseBtnRect.Right := Rect.Right - 5;
    TabCaption.X := Rect.Left + 3;
  end;

  if IsPgShowTabClose(PageControl) and
    (PageControl.Pages[TabIndex] is TTabSheet) and
    IsTabSheetView(PageControl.Pages[TabIndex]) then
  begin
    TabSheet := PageControl.Pages[TabIndex] as TTabSheet;
    CloseBtnSize := 14;

    CloseBtnRect.Bottom := CloseBtnRect.Top + CloseBtnSize;
    CloseBtnRect.Left := CloseBtnRect.Right - CloseBtnSize;
    TTabSheetView(TabSheet).FCloseButtonRect := CloseBtnRect;

    PageControl.Canvas.FillRect(Rect);
    PageControl.Canvas.TextOut(TabCaption.X, TabCaption.Y,
      PageControl.Pages[TabIndex].Caption);

    if not ThemeServices.ThemesEnabled then
    begin
      if (FCloseButtonMouseDownTab = TabSheet) and FCloseButtonShowPushed then
        CloseBtnDrawState := DFCS_CAPTIONCLOSE + DFCS_PUSHED
      else
        CloseBtnDrawState := DFCS_CAPTIONCLOSE;

      WinApi.Windows.DrawFrameControl(PageControl.Canvas.Handle,
        TTabSheetView(TabSheet).FCloseButtonRect, DFC_CAPTION,
        CloseBtnDrawState);
    end
    else
    begin
      Dec(TTabSheetView(TabSheet).FCloseButtonRect.Left);

      if (FCloseButtonMouseDownTab = TabSheet) and FCloseButtonShowPushed then
        CloseBtnDrawDetails := ThemeServices.GetElementDetails
          (twCloseButtonPushed)
      else
        CloseBtnDrawDetails := ThemeServices.GetElementDetails
          (twCloseButtonNormal);

      ThemeServices.DrawElement(PageControl.Canvas.Handle, CloseBtnDrawDetails,
        TTabSheetView(TabSheet).FCloseButtonRect);
    end;
  end
  else
  begin
    PageControl.Canvas.FillRect(Rect);
    PageControl.Canvas.TextOut(TabCaption.X, TabCaption.Y,
      PageControl.Pages[TabIndex].Caption);
  end;
end;

procedure TMVCBrPageControl.SetActivePage(const Value: TTabSheet);
begin
  inherited ActivePage := Value;
end;

procedure TMVCBrPageControl.SetShowTabClose(const Value: boolean);
begin

  if FShowTabClose = Value then
    exit;

  FShowTabClose := Value;
  OwnerDraw := Value;
  if Value then
  begin
    OnDrawTab := PageControlCloseButtonDrawTab;
    OnMouseDown := PageControlCloseButtonMouseDown;
    OnMouseLeave := PageControlCloseButtonMouseLeave;
    OnMouseMove := PageControlCloseButtonMouseMove;
    OnMouseUp := PageControlCloseButtonMouseUp;
  end
  else
  begin
    OnDrawTab := nil;
  end;

end;

{ TVCLPageViewFactory }

function TVCLPageViewManager.AddView(AView: IView): TPageView;
begin
  result := inherited AddView(AView);
end;

function TVCLPageViewManager.AddView(const AController: TGuid): TPageView;
begin
  result := inherited AddView(AController);
end;

procedure TVCLPageViewManager.DoQueryClose(const APageView: TPageView;
  var ACanClose: boolean);
begin
  inherited;
  if assigned(FOnQueryClose) then
    FOnQueryClose(APageView, ACanClose);
end;

function TVCLPageViewManager.AddView(AView: IView; ABoforeShow: TProc<IView>)
  : TPageView;
begin
  result := inherited AddView(AView, ABoforeShow);
end;

procedure TVCLPageViewManager.DoFormCloseQuery(Sender: TObject;
  var canClose: boolean);
var
  LPageView: IPageView;
begin
  LPageView := FindViewByClassName(Sender.ClassName);
  if not assigned(LPageView) then
    exit;
  postMessage(TTabSheet(LPageView.This.tab).Handle, WM_TABSHEET_CLOSE, 0, 0);
end;

procedure TVCLPageViewManager.DoPageChange(Sender: TObject);
begin
  if assigned(FOldPageChange) then
    FOldPageChange(Sender);
  ActivePageIndex := TPageControl(FPageContainer).ActivePageIndex;
end;

function TVCLPageViewManager.GetPageContainerClass: TComponentClass;
begin
  result := TPageControl;
end;

function TVCLPageViewManager.GetPageControlEx: TPageControl;
begin
  result := TPageControl(FPageContainer);
end;

procedure TTabSheetView.canClose(var ACanClose: boolean);
var
  form: TForm;
  ref: TVCLPageViewManager;
  s: string;
  v: IView;
begin
  // chamado quando a tabsheet é apagada.
  ACanClose := True;
  if assigned(FPageView) and (GetOwner <> nil) then
    try
      { ref := TVCLPageViewManager(FPageView.GetOwner);
        if assigned(ref) then
        ref.DoQueryClose(FPageView, ACanClose);
      } if ACanClose then
        if assigned(FPageView) then
          if assigned(FPageView.View) then
          begin
            form := TForm(FPageView.View);
            if assigned(form) then
              if assigned(form.OnCloseQuery) then
                form.OnCloseQuery(self, ACanClose);
            if ACanClose then
            begin
              if supports(FPageView.View, IView, v) then
                TControllerAbstract.RevokeInstance(v.GetController.This);
            end;

          end;
    except
    end;

end;

destructor TTabSheetView.Destroy;
var
  LCanClose: boolean;
begin
  FReleased := True;
  LCanClose := True;
  if assigned(FPageView) then
  begin
    canClose(LCanClose);
    if not LCanClose then
      abort;
    TForm(FPageView.View).OnCloseQuery := nil;
    // FPageView.remove;
    FreeAndNil(FPageView);
    // FPageView := nil;
  end;
  inherited Destroy;
end;

function TVCLPageViewManager.GetPageTabClass: TComponentClass;
begin
  result := TTabSheetView;
end;

procedure TVCLPageViewManager.DoTabClose(Sender: TObject);
var
  nPage: integer;
  pg: TPageView;
  frm: TForm;
  canClose: boolean;
  LOnClose: TProc<TObject>;
begin
  nPage := IndexOfTab(Sender);
  if nPage >= 0 then
  begin
    pg := TPageView(FList.items[nPage]);
    LOnClose := pg.This.OnCloseDelegate;
    frm := TForm(pg.This.View);
    DoQueryClose(pg, canClose);
    if not canClose then
      abort;
    if assigned(LOnClose) then
      LOnClose(frm);
  end;
end;

function TVCLPageViewManager.IndexOfTab(Sender: TObject): integer;
var
  I: integer;
begin
  result := -1;
  try
    with FList do
      for I := 0 to Count - 1 do
        if TPageView(items[I]).tab.Equals(Sender) then
        begin
          result := I;
          exit;
        end;
  except
  end;
end;

procedure TVCLPageViewManager.Init(APageView: TPageView);
var
  frm: TForm;
  v: IView;
begin
  if assigned(APageView) then
    if assigned(APageView.This.View) then
    begin
      if APageView.This.View.InheritsFrom(TViewFactoryAdapter) then
      begin
        frm := TForm(TViewFactoryAdapter(APageView.This.View).form);
        APageView.This.text := frm.Caption;
      end
      else
        frm := TForm(APageView.This.View);
      with frm do
      begin
        parent := TTabSheet(APageView.This.tab);
        with TTabSheetView(APageView.This.tab) do
        begin
          FShowTabClose := True;
          OnClose := DoTabClose;
        end;
        Align := alClient;
        BorderStyle := bsNone;
        TTabSheetView(APageView.This.tab).Caption := APageView.This.text;

        supports(APageView.View, IView, v);
        if APageView.View.InheritsFrom(TFormFactory) then
        begin
          OnCloseQuery := DoFormCloseQuery;
          TFormFactory(APageView.View).isShowModal := false;

          with TFormFactory(APageView.View) do
            if assigned(APageView.This.OnBeforeShowDelegate) then
              APageView.This.OnBeforeShowDelegate(v);
          v.ShowView(nil);
          v.Init;
          show;
        end
        else
          show;
      end;
      if assigned(FAfterCreateComplete) then
        FAfterCreateComplete(APageView.This);
    end;
end;

class function TVCLPageViewManager.New(AController: IController): IPageViews;
begin
  result := TVCLPageViewManager.Create(nil);
  result.Controller(AController);
end;

type
  TVCLPageView = class(TPageView)
  public
    procedure SetPageIndex(const idx: integer); override;
  end;

function TVCLPageViewManager.GetPageViewClass: TPageViewClass;
begin
  result := TVCLPageView;
end;

function TVCLPageViewManager.NewTab(APageView: TPageView): TObject;
var
  tab: TTabSheetView;
begin
  tab := GetPageTabClass.Create(FPageContainer) as TTabSheetView;
  tab.PageControl := TPageControl(FPageContainer);
  tab.FPageView := APageView;
  TPageControl(FPageContainer).ActivePage := tab;
  result := tab;
  if assigned(FAfterTabCreate) then
    FAfterTabCreate(tab);
end;

procedure TVCLPageViewManager.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited;

end;

procedure TVCLPageViewManager.SetActivePage(const tab: TObject);
begin
  inherited;
  TPageControl(FPageContainer).ActivePage := TTabSheet(tab);
end;

procedure TVCLPageViewManager.SetAfterCreateComplete(const Value: TNotifyEvent);
begin
  FAfterCreateComplete := Value;
end;

procedure TVCLPageViewManager.SetAfterTabCreate(const Value: TNotifyEvent);
begin
  FAfterTabCreate := Value;
end;

procedure TVCLPageViewManager.SetOnQueryClose(const Value
  : TVCLpageViewOnQueryClose);
begin
  FOnQueryClose := Value;
end;

procedure TVCLPageViewManager.SetPageControlEx(const Value: TPageControl);
begin
  if assigned(Value) then
  begin
    FOldPageChange := Value.OnChange;
    Value.OnChange := DoPageChange;
  end
  else
  begin
    FOldPageChange := nil;
  end;
  FPageContainer := Value;
end;

function TVCLPageViewManager.TabsheetIndexOf(tab: TObject): integer;
var
  I: integer;
begin
  result := -1;
  with TPageControl(FPageContainer) do
    for I := 0 to PageCount - 1 do
      if Pages[I].Equals(tab) then
      begin
        result := I;
        exit;
      end;
end;

function TVCLPageViewManager.Update: IModel;
var
  APageView: TPageView;
begin
  ActivePageIndex := TPageControl(FPageContainer).ActivePageIndex;
  APageView := ActivePage;
  Init(APageView);
end;

{ TVCLPageView }

{ TTabSheet }

procedure TTabSheetView.SetCaption(const Value: string);
var
  X: integer;
begin
  if ShowTabClose then
    inherited Caption := Trim(Value) + '   X'
  else
    inherited Caption := Trim(Value);
end;

procedure TTabSheetView.SetOnClose(const Value: TNotifyEvent);
begin
  FOnClose := Value;
end;

procedure TTabSheetView.SetShowTabClose(const Value: boolean);
begin
  FShowTabClose := Value;
end;

procedure TTabSheetView.DoClose;
begin
  if assigned(FOnClose) then
    FOnClose(self);
  free;
end;

procedure TTabSheetView.DoCloseMessage(var TMessage);
begin
  DoClose;
end;

function TTabSheetView.GetCaption: string;
begin
  result := inherited Caption;
end;

constructor TTabSheetView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCloseButtonRect := Rect(0, 0, 0, 0);
end;

{ TVCLPageView }

procedure TVCLPageView.SetPageIndex(const idx: integer);
begin
  TTabSheetView(tab).PageIndex := idx;
end;

type
  TTabControlStyleHookBtnClose = class(TTabControlStyleHook)
  private
    FHotIndex: integer;
    FWidthModified: boolean;
    procedure WMMouseMove(var Message: TMessage); message WM_MOUSEMOVE;
    procedure WMLButtonUp(var Message: TWMMouse); message WM_LBUTTONUP;
    function GetButtonCloseRect(Index: integer): TRect;
  strict protected
    procedure DrawTab(Canvas: TCanvas; Index: integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  public
    constructor Create(AControl: TWinControl); override;
  end;

constructor TTabControlStyleHookBtnClose.Create(AControl: TWinControl);
begin
  inherited;
  FHotIndex := -1;
  FWidthModified := false;
end;

procedure TTabControlStyleHookBtnClose.DrawTab(Canvas: TCanvas; Index: integer);
var
  Details: TThemedElementDetails;
  ButtonR: TRect;
  FButtonState: TThemedWindow;
  pg: TPageControl;
begin
  inherited;
  if not Control.InheritsFrom(TPageControl) then
    exit;
  if (FHotIndex >= 0) and (Index = FHotIndex) then
    FButtonState := twSmallCloseButtonHot
  else if Index = TabIndex then
    FButtonState := twSmallCloseButtonNormal
  else
    FButtonState := twSmallCloseButtonDisabled;

  Details := StyleServices.GetElementDetails(FButtonState);

  ButtonR := GetButtonCloseRect(Index);

  if Control is TPageControl then
  begin
    pg := TPageControl(Control);
    if (not IsPgShowTabClose(pg)) or (not IsShowTabClose(pg.Pages[index])) then
      exit;
  end;

  TThread.NameThreadForDebugging('PageControl.StyleServices.DrawElement');
  if ButtonR.Bottom - ButtonR.Top > 0 then
    StyleServices.DrawElement(Canvas.Handle, Details, ButtonR);
end;

procedure TTabControlStyleHookBtnClose.WMLButtonUp(var Message: TWMMouse);
Var
  LPoint: TPoint;
  LIndex: integer;
begin
  LPoint := Message.Pos;
  for LIndex := 0 to TabCount - 1 do
    if PtInRect(GetButtonCloseRect(LIndex), LPoint) then
    begin
      if (Control is TPageControl) and
        (IsShowTabClose(TPageControl(Control).Pages[LIndex])) then
      begin
        postMessage(TPageControl(Control).Pages[LIndex].Handle,
          WM_TABSHEET_CLOSE, 0, 0);
      end;
      break;
    end;
end;

procedure TTabControlStyleHookBtnClose.WMMouseMove(var Message: TMessage);
Var
  LPoint: TPoint;
  LIndex: integer;
  LHotIndex: integer;
begin
  inherited;
  LHotIndex := -1;
  LPoint := TWMMouseMove(Message).Pos;
  for LIndex := 0 to TabCount - 1 do
    if PtInRect(GetButtonCloseRect(LIndex), LPoint) then
    begin
      LHotIndex := LIndex;
      break;
    end;

  if (FHotIndex <> LHotIndex) then
  begin
    FHotIndex := LHotIndex;
    Invalidate;
  end;
end;

function TTabControlStyleHookBtnClose.GetButtonCloseRect(Index: integer): TRect;
var
  FButtonState: TThemedWindow;
  Details: TThemedElementDetails;
  R, ButtonR: TRect;
begin
  R := TabRect[Index];
  if R.Left < 0 then
    exit;

  if TabPosition in [tpTop, tpBottom] then
  begin
    if Index = TabIndex then
      InflateRect(R, 0, 2);
  end
  else if Index = TabIndex then
    Dec(R.Left, 2)
  else
    Dec(R.Right, 2);

  result := R;
  FButtonState := twSmallCloseButtonNormal;

  Details := StyleServices.GetElementDetails(FButtonState);
  if not StyleServices.GetElementContentRect(0, Details, result, ButtonR) then
    ButtonR := Rect(0, 0, 0, 0);

  // Result.Left :=Result.Right - (ButtonR.Width) - 5;
  result.Left := result.Right - (ButtonR.Width) - 5;
  result.Width := ButtonR.Width;

end;

procedure TTabControlStyleHookBtnClose.MouseEnter;
begin
  inherited;
  FHotIndex := -1;
end;

procedure TTabControlStyleHookBtnClose.MouseLeave;
begin
  inherited;
  if FHotIndex >= 0 then
  begin
    FHotIndex := -1;
    Invalidate;
  end;
end;

initialization

TStyleManager.Engine.RegisterStyleHook(TCustomTabControl,
  TTabControlStyleHookBtnClose);
TStyleManager.Engine.RegisterStyleHook(TTabControl,
  TTabControlStyleHookBtnClose);

end.
