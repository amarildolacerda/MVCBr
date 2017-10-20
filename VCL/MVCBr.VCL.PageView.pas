unit MVCBr.VCL.PageView;

{ .$define USE_PG_INTERPOSE }

interface

uses VCL.Forms, VCL.Controls, System.Classes, System.SysUtils, MVCBr.Interf,
  MVCBr.patterns.Memento,
  System.Generics.Collections,
  WinApi.Windows, System.Types,
  WinApi.Messages,
  MVCBr.PageView, MVCBr.FormView, VCL.ComCtrls;

const
  WM_TABSHEET_CLOSE = WM_USER + 1;

type

  TCloseTabQueryEvent = procedure(ASender: TObject; AIndex: Integer;
    var ACanClose: boolean) of object;

  TMVCBrPageControl = class(TPageControl)
  private
    FCloseButtonMouseDownTab: TTabSheet;
    FCloseButtonShowPushed: boolean;
    FShowTabClose: boolean;
    FonFormDrawTab: TDrawTabEvent;
    FonFormMouseDown: TMouseEvent;
    FOnFormMouseMove: TMouseMoveEvent;
    FonFormMouseUp: TMouseEvent;
    FOnFormMouseLeave: TNotifyEvent;
    procedure PageControlCloseButtonDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: boolean);
    function GetActivePage: TTabSheet;
    procedure SetActivePage(const Value: TTabSheet);
    function GetPages(idx: Integer): TTabSheet;
    procedure PageControlCloseButtonMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PageControlCloseButtonMouseLeave(Sender: TObject);
    procedure PageControlCloseButtonMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure PageControlCloseButtonMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SetShowTabClose(const Value: boolean);
    procedure SetonDrawTab(const Value: TDrawTabEvent);
    procedure SetonMouseDown(const Value: TMouseEvent);
    procedure SetOnMouseLeave(const Value: TNotifyEvent);
    procedure SetOnMouseMove(const Value: TMouseMoveEvent);
    procedure SetonMouseUp(const Value: TMouseEvent);
    function GetShowTabColor: boolean;
    procedure SetShowTabColor(const Value: boolean);
  protected
    function GetShowCaptions: boolean;
    procedure SetShowCaptions(const Value: boolean);

  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    function FindNextPage(CurPage: TTabSheet;
      GoForward, CheckTabVisible: boolean): TTabSheet;
    property ActivePage: TTabSheet read GetActivePage write SetActivePage;
    property Pages[idx: Integer]: TTabSheet read GetPages;
    property ShowTabClose: boolean read FShowTabClose write SetShowTabClose;
    property ShowCaptions: boolean read GetShowCaptions write SetShowCaptions;
    property ShowTabColor: boolean read GetShowTabColor write SetShowTabColor;
  published
    property onDrawTab: TDrawTabEvent read FonFormDrawTab write SetonDrawTab;
    property onMouseDown: TMouseEvent read FonFormMouseDown
      write SetonMouseDown;
    property onMouseUp: TMouseEvent read FonFormMouseUp write SetonMouseUp;
    property OnMouseMove: TMouseMoveEvent read FOnFormMouseMove
      write SetOnMouseMove;
    property OnMouseLeave: TNotifyEvent read FOnFormMouseLeave
      write SetOnMouseLeave;
  end;

{$IFDEF USE_PG_INTERPOSE}

  TPageControl = class(TMVCBrPageControl);
{$ENDIF}
  TVCLpageViewOnQueryClose = procedure(APageView: TPageView;
    var ACanClose: boolean) of object;

  TVCLPageViewManager = class(TCustomPageViewFactory, IPageViews)
  type
    TPageHistory = class(TMVCBrMementoFactory<string>)
    end;
  private
    FLock: TObject;
    FOnDestroing: boolean;
    FPageHistory: TPageHistory;
    FOldPageChange: TNotifyEvent;
    FOnQueryClose: TVCLpageViewOnQueryClose;
    FAfterTabCreate: TNotifyEvent;
    FAfterCreateComplete: TNotifyEvent;
    FInheritedDraw: boolean;
    FUsePageHistory: boolean;
    procedure Init(APageView: TPageView); override;
    procedure SetPageControlEx(const Value: TPageControl);
    function GetPageControlEx: TPageControl;
    procedure SetOnQueryClose(const Value: TVCLpageViewOnQueryClose);
    procedure SetAfterTabCreate(const Value: TNotifyEvent);
    procedure SetAfterCreateComplete(const Value: TNotifyEvent);
    procedure DoPageChange(Sender: TObject);
    procedure DoFormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure DoTabClose(Sender: TObject);
    function GetShowCaptions: boolean;
    procedure SetShowCaptions(const Value: boolean);
    procedure SetInheritedDraw(const Value: boolean);
    function GetShowTabColor: boolean;
    procedure SetShowTabColor(const Value: boolean);
    function IndexOfTabByCaption(ACaption: string): Integer;
    procedure SetUsePageHistory(const Value: boolean);
    function ContainerName: String;
    function GetContainer: TComponent;
    // procedure DoTabCanClose(Sender: TObject; var ACanClose: boolean);
  protected
    Procedure DoQueryClose(const APageView: TPageView;
      var ACanClose: boolean); override;
    procedure SetActivePage(Const tab: TObject); override;
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;
    function GetPageViewClass: TPageViewClass; override;
    function InvokePageHistory: TPageHistory;
  public
    procedure Lock;
    procedure Unlock;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class function New(AController: IController): IPageViews;
    [weak]
    function Update: IModel; virtual;
    function FindByTabIndex(AIndex: Integer): TPageView;
    function IndexOfTab(Sender: TObject): Integer;
    function TabsheetIndexOf(tab: TObject): Integer;

    function GetPageTabClass: TComponentClass; override;
    function GetPageContainerClass: TComponentClass; override;
    function NewTab(APageView: TPageView; ACaption: String): TObject; override;
    function AddView(AView: IView; ABoforeShow: TProc<IView>)
      : TPageView; override;
    function AddView(AView: IView): TPageView; override;
    function AddView(Const AController: TGuid): TPageView; overload; override;
    function AddView(const AController: TGuid; ABeforeShow: TProc<IView>)
      : TPageView; overload; override;
  published
    property PageControl: TPageControl read GetPageControlEx
      write SetPageControlEx;
    property ShowCaptions: boolean read GetShowCaptions write SetShowCaptions;
    property ShowTabColor: boolean read GetShowTabColor write SetShowTabColor;

    property AfterViewCreate;
    property AfterCreateComplete: TNotifyEvent read FAfterCreateComplete
      write SetAfterCreateComplete;
    property AfterTabCreate: TNotifyEvent read FAfterTabCreate
      write SetAfterTabCreate;
    property OnQueryClose: TVCLpageViewOnQueryClose read FOnQueryClose
      write SetOnQueryClose;
    property InheritedDraw: boolean read FInheritedDraw write SetInheritedDraw;
    property UsePageHistory: boolean read FUsePageHistory
      write SetUsePageHistory;
  end;

  TMVCBrTabSheetView = class(TTabSheet)
  private
    FShowCaption: boolean;
    procedure SetShowCaption(const Value: boolean);
  public
    property ShowCaption: boolean read FShowCaption write SetShowCaption;
  end;

procedure register;

implementation

uses
  MVCBr.Observable,
  System.RTTI, System.JSON, System.JSON.Helper,
  System.Classes.Helper, VCL.Graphics, MVCBr.Controller, VCL.Themes,
  VCL.Styles;

type
  TPageControlExtender = record
    ShowCaptions: boolean;
    InheritedDraw: boolean;
    ShowTabColor: boolean;
  end;

var
  LPageControlExtender: TDictionary<TPageControl, TPageControlExtender>;

procedure register;
begin
  RegisterComponents('MVCBr', [TMVCBrPageControl, TVCLPageViewManager]);
end;

type

  TTabSheetView = class(TMVCBrTabSheetView)
  private
    FPageFactory: TCustomPageViewFactory;
    FCloseButtonRect: TRect;
    FOnClose: TNotifyEvent;
    FShowTabClose: boolean;
    FReleased: boolean;
    FOnCloseQuery: TCloseQueryEvent;
    procedure SetOnClose(const Value: TNotifyEvent);
    procedure SetShowTabClose(const Value: boolean);
    function GetCaption: string;
    procedure SetCaption(const Value: string);
    procedure SetOnCloseQuery(const Value: TCloseQueryEvent);
  protected
    FControllerGuid: TGuid;
    FPageView: TPageView;
    Procedure DoCloseMessage(var TMessage); message WM_TABSHEET_CLOSE;
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DoClose; virtual;
    procedure CanClose(var ACanClose: boolean);
  published

    property OnClose: TNotifyEvent read FOnClose write SetOnClose;
    property OnCloseQuery: TCloseQueryEvent read FOnCloseQuery
      write SetOnCloseQuery;
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

function TMVCBrPageControl.GetPages(idx: Integer): TTabSheet;
begin
  result := TTabSheet(inherited Pages[idx]);
end;

function XGetPageControlExtender(pg: TPageControl): TPageControlExtender;
begin
  if assigned(pg) and LPageControlExtender.ContainsKey(pg) then
    result := LPageControlExtender.Items[pg];
end;

function TMVCBrPageControl.GetShowCaptions: boolean;
begin
  result := XGetPageControlExtender(self).ShowCaptions;
end;

function TMVCBrPageControl.GetShowTabColor: boolean;
begin
  result := XGetPageControlExtender(self).ShowTabColor;
end;

procedure TMVCBrPageControl.PageControlCloseButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  I: Integer;
  PageControl: TPageControl;
  TabSheet: TTabSheet;
begin
  PageControl := Sender as TPageControl;
  FCloseButtonShowPushed := false;
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
        FCloseButtonShowPushed := true;
        PageControl.Repaint;
      end;
    end;
  end;
  if assigned(FonFormMouseDown) then
    FonFormMouseDown(Sender, Button, Shift, X, Y);
end;

procedure TMVCBrPageControl.PageControlCloseButtonMouseLeave(Sender: TObject);
var
  PageControl: TPageControl;
begin
  PageControl := Sender as TPageControl;
  FCloseButtonShowPushed := false;
  PageControl.Repaint;
  if assigned(FOnFormMouseLeave) then
    FOnFormMouseLeave(Sender);
end;

constructor TMVCBrPageControl.Create(AOwner: TComponent);
begin
  inherited;
  inherited onDrawTab := PageControlCloseButtonDrawTab;
  inherited onMouseDown := PageControlCloseButtonMouseDown;
  inherited OnMouseLeave := PageControlCloseButtonMouseLeave;
  inherited OnMouseMove := PageControlCloseButtonMouseMove;
  inherited onMouseUp := PageControlCloseButtonMouseUp;
  ShowCaptions := true;
  OwnerDraw := true;
end;

destructor TMVCBrPageControl.Destroy;
begin
  LPageControlExtender.Remove(self);
  inherited;
end;

function TMVCBrPageControl.FindNextPage(CurPage: TTabSheet;
  GoForward, CheckTabVisible: boolean): TTabSheet;
begin
  result := TTabSheet(inherited FindNextPage(CurPage, GoForward,
    CheckTabVisible));
end;

procedure TMVCBrPageControl.PageControlCloseButtonMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
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

  if assigned(FOnFormMouseMove) then
    FOnFormMouseMove(Sender, Shift, X, Y);
end;

procedure TMVCBrPageControl.PageControlCloseButtonMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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
  if assigned(FonFormMouseUp) then
    FonFormMouseUp(Sender, Button, Shift, X, Y);
end;

procedure TMVCBrPageControl.PageControlCloseButtonDrawTab
  (Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect;
  Active: boolean);
var
  CloseBtnSize: Integer;
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
  if assigned(FonFormDrawTab) then
    FonFormDrawTab(Control, TabIndex, Rect, Active);
end;

procedure TMVCBrPageControl.SetActivePage(const Value: TTabSheet);
begin
  inherited ActivePage := Value;
end;

procedure TMVCBrPageControl.SetonDrawTab(const Value: TDrawTabEvent);
begin
  FonFormDrawTab := Value;
end;

procedure TMVCBrPageControl.SetonMouseDown(const Value: TMouseEvent);
begin
  FonFormMouseDown := Value;
end;

procedure TMVCBrPageControl.SetOnMouseLeave(const Value: TNotifyEvent);
begin
  FOnFormMouseLeave := Value;
end;

procedure TMVCBrPageControl.SetOnMouseMove(const Value: TMouseMoveEvent);
begin
  FOnFormMouseMove := Value;
end;

procedure TMVCBrPageControl.SetonMouseUp(const Value: TMouseEvent);
begin
  FonFormMouseUp := Value;
end;

procedure XSetShowCaptions(pg: TPageControl; Value: boolean);
var
  rec: TPageControlExtender;
begin
  if LPageControlExtender.ContainsKey(pg) then
  begin
    rec := LPageControlExtender.Items[pg];
    rec.ShowCaptions := Value;
  end;
  LPageControlExtender.AddOrSetValue(pg, rec);
end;

procedure XSetShowTabColor(pg: TPageControl; Value: boolean);
var
  rec: TPageControlExtender;
begin
  if LPageControlExtender.ContainsKey(pg) then
  begin
    rec := LPageControlExtender.Items[pg];
    rec.ShowTabColor := Value;
  end;
  LPageControlExtender.AddOrSetValue(pg, rec);
end;

procedure TMVCBrPageControl.SetShowCaptions(const Value: boolean);
begin
  XSetShowCaptions(self, Value);
end;

procedure TMVCBrPageControl.SetShowTabClose(const Value: boolean);
begin

  if FShowTabClose = Value then
    exit;

  FShowTabClose := Value;
  OwnerDraw := Value;
  if Value then
  begin
    inherited onDrawTab := PageControlCloseButtonDrawTab;
    inherited onMouseDown := PageControlCloseButtonMouseDown;
    inherited OnMouseLeave := PageControlCloseButtonMouseLeave;
    inherited OnMouseMove := PageControlCloseButtonMouseMove;
    inherited onMouseUp := PageControlCloseButtonMouseUp;
  end
  else
  begin
    inherited onDrawTab := nil;
    inherited onMouseUp := nil;
    inherited onMouseDown := nil;
    inherited OnMouseLeave := nil;
    inherited OnMouseMove := nil;
  end;

end;

procedure TMVCBrPageControl.SetShowTabColor(const Value: boolean);
begin
  XSetShowTabColor(self, Value);
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

function TVCLPageViewManager.AddView(Const AController: TGuid;
  ABeforeShow: TProc<IView>): TPageView;
begin
  Lock;
  try
    result := inherited AddView(AController, ABeforeShow);
    if assigned(result) then
      TTabSheetView(result.tab).FControllerGuid := AController;
  finally
    Unlock;
  end;
end;

constructor TVCLPageViewManager.Create(AOwner: TComponent);
begin
  inherited;
  FLock := TObject.Create;
  FUsePageHistory := true;
  InvokePageHistory;

end;

function TVCLPageViewManager.AddView(AView: IView; ABoforeShow: TProc<IView>)
  : TPageView;
begin
  result := inherited AddView(AView, ABoforeShow);
end;

(*
  function TVCLPageViewManager.DockablePageView: TMVCBrDockablePageViewManager;
  begin
  if not assigned(FPageContainer) then
  raise exception.Create('Não inicializou TVCLPageViewManager.PageContainer');
  if not assigned(FDockablePageView) then
  begin
  FDockablePageView := TMVCBrDockablePageViewManager.Create
  (TPageControl(FPageContainer));
  end;
  result := FDockablePageView;
  end;
*)

destructor TVCLPageViewManager.Destroy;
begin
  TMVCBrObservable.UnSubscribe(self);
  FOnDestroing := true;
  if assigned(FPageHistory) then
  begin
    FPageHistory.disposeOf;
    FPageHistory := nil;
  end;
  FLock.free;
  inherited;
end;

procedure TVCLPageViewManager.DoFormCloseQuery(Sender: TObject;
  var CanClose: boolean);
var
  LPageView: TPageView;
begin
  LPageView := FindViewByClassName(Sender.ClassName);
  if not assigned(LPageView) then
    exit;
  if LPageView.view.InheritsFrom(TFormFactory) then
    TFormFactory(LPageView.view).OnCloseQuery := nil;
  postMessage(TTabSheet(LPageView.This.tab).Handle, WM_TABSHEET_CLOSE, 0, 0);
end;

procedure TVCLPageViewManager.DoPageChange(Sender: TObject);
var
  s: string;
begin
  if assigned(FOldPageChange) then
    FOldPageChange(Sender);
  ActivePageIndex := TPageControl(FPageContainer).ActivePageIndex;
  s := TPageControl(FPageContainer).ActivePage.Caption;
  InvokePageHistory.add('history', s.trim); // 1 to 1
end;

function TVCLPageViewManager.GetPageContainerClass: TComponentClass;
begin
  result := TPageControl;
end;

function TVCLPageViewManager.GetPageControlEx: TPageControl;
begin
  result := TPageControl(FPageContainer);
end;

procedure TTabSheetView.CanClose(var ACanClose: boolean);
var
  form: TFormFactory;
  ref: TVCLPageViewManager;
  s: string;
  v: IView;
begin
  // chamado quando a tabsheet é apagada.
  ACanClose := true;

  if assigned(FOnCloseQuery) then
    FOnCloseQuery(self, ACanClose);
  if not ACanClose then
    abort;

  if assigned(FPageView) and (GetOwner <> nil) then
    if ACanClose then
      if assigned(FPageView) then
      begin
        try
          if assigned(FPageView.view) and
            (FPageView.view.InheritsFrom(TFormFactory)) then
          begin
            form := TFormFactory(FPageView.view);
            if assigned(form) then
              if assigned(form.OnCloseQuery) then
                form.OnCloseQuery(self, ACanClose);
            if ACanClose then
            begin
            end;
          end;
        except
        end;
      end;
end;

destructor TTabSheetView.Destroy;
var
  LCanClose: boolean;
  AGuid: TGuid;
begin
  FReleased := true;
  LCanClose := true;
  if assigned(FPageView) then
  begin
    AGuid := FPageView.ControllerGuid;
    CanClose(LCanClose);
    if not LCanClose then
      abort;
    try
      if assigned(FPageFactory) then
        FPageFactory.Remove(FControllerGuid);
    except
    end;
    FPageView := nil;
  end;
  TMVCBr.Revoke(AGuid);
  inherited Destroy;
end;

function TVCLPageViewManager.GetPageTabClass: TComponentClass;
begin
  result := TTabSheetView;
end;

procedure TVCLPageViewManager.DoTabClose(Sender: TObject);
var
  nPage: Integer;
  pg: TPageView;
  frm: TForm;
  CanClose: boolean;
  LOnClose: TProc<TObject>;
  sPage: string;
begin
  nPage := IndexOfTab(Sender);
  if nPage >= 0 then
  begin
    pg := TPageView(FList.Items[nPage]);
    LOnClose := pg.This.OnCloseDelegate;
    DoQueryClose(pg, CanClose);
    if not CanClose then
      abort;
    frm := TForm(pg.This.view);
    if assigned(LOnClose) then
      LOnClose(frm);
  end;
end;

function TVCLPageViewManager.FindByTabIndex(AIndex: Integer): TPageView;
var
  ts: TTabSheet;
  I: Integer;
begin
  result := nil;
  ts := PageControl.Pages[AIndex];
  I := IndexOfTab(ts);
  if I >= 0 then
    result := TPageView(Items[I]);
end;

function TVCLPageViewManager.IndexOfTab(Sender: TObject): Integer;
var
  I: Integer;
begin
  result := -1;
  try
    with FList do
      for I := Count - 1 downto 0 do
        if TPageView(Items[I]).tab.Equals(Sender) then
        begin
          result := I;
          exit;
        end;
  except
  end;
end;

function TVCLPageViewManager.IndexOfTabByCaption(ACaption: string): Integer;
var
  I: Integer;
  s: string;
begin
  result := -1;
  if ACaption.IsEmpty then
    exit;
  try
    with FList do
      for I := Count - 1 downto 0 do
      begin
        s := TTabSheet(TPageView(Items[I]).tab).Caption;
        if sametext(s.trim, ACaption) then
        begin
          result := I;
          exit;
        end;
      end;
  except
  end;
end;

procedure TVCLPageViewManager.Init(APageView: TPageView);
var
  frm: TForm;
  v: IView;
begin
  Lock;
  try
    if assigned(APageView) then
      if assigned(APageView.This.view) then
      begin
        if APageView.This.view.InheritsFrom(TViewFactoryAdapter) then
        begin
          frm := TForm(TViewFactoryAdapter(APageView.This.view).form);
          APageView.This.text := frm.Caption;
        end
        else
          frm := TForm(APageView.This.view);
        with frm do
        begin
          parent := TTabSheet(APageView.This.tab);
          with TTabSheetView(APageView.This.tab) do
          begin
            FShowTabClose := true;
            OnClose := DoTabClose;
          end;
          Align := alClient;
          BorderStyle := bsNone;
          TTabSheetView(APageView.This.tab).Caption := APageView.This.text;

          supports(APageView.view, IView, v);
          if APageView.view.InheritsFrom(TFormFactory) then
          begin
            OnCloseQuery := DoFormCloseQuery;
            TFormFactory(APageView.view).isShowModal := false;

            with TFormFactory(APageView.view) do
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
  finally
    Unlock;
  end;
end;

function TVCLPageViewManager.InvokePageHistory: TPageHistory;
begin
  result := nil;
  if FOnDestroing then
    exit;
  if not assigned(FPageHistory) then
  begin
    FPageHistory := TPageHistory.Create;
    FPageHistory.MaxItens := 20;
  end;
  result := FPageHistory;
end;

procedure TVCLPageViewManager.Lock;
begin
  System.TMonitor.Enter(FLock);
end;

class function TVCLPageViewManager.New(AController: IController): IPageViews;
begin
  result := TVCLPageViewManager.Create(nil);
  result.Controller(AController);
end;

type
  TVCLPageView = class(TPageView)
  public
    procedure SetPageIndex(const idx: Integer); override;
  end;

function TVCLPageViewManager.GetPageViewClass: TPageViewClass;
begin
  result := TVCLPageView;
end;

function TVCLPageViewManager.GetShowCaptions: boolean;
begin
  result := XGetPageControlExtender(TPageControl(FPageContainer)).ShowCaptions;
end;

function TVCLPageViewManager.GetShowTabColor: boolean;
begin
  result := XGetPageControlExtender(TPageControl(FPageContainer)).ShowTabColor;
end;

{ procedure TVCLPageViewManager.DoTabCanClose(Sender: TObject;
  var ACanClose: boolean);
  begin
  if assigned(FOnQueryClose) then
  if Sender.InheritsFrom(TTabSheetView) then
  FOnQueryClose(TTabSheetView(Sender).FPageView, ACanClose);
  end;
}

function TVCLPageViewManager.NewTab(APageView: TPageView;
  ACaption: String): TObject;
var
  tab: TTabSheetView;
begin
  tab := GetPageTabClass.Create(FPageContainer) as TTabSheetView;
  tab.PageControl := TPageControl(FPageContainer);
  tab.Caption := ACaption;
  tab.FPageView := APageView;
  tab.FPageFactory := self;
  // tab.OnCloseQuery := DoTabCanClose;
  TPageControl(FPageContainer).ActivePage := tab;
  result := tab;
  if assigned(FAfterTabCreate) then
    FAfterTabCreate(tab);

  TMVCBrObservable.Notify(PageControl.ClassName + '.tabcreate', nil);
  FPageHistory.Remove('history', ACaption);
  FPageHistory.add('history', ACaption);
end;

procedure TVCLPageViewManager.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited;

end;

procedure TVCLPageViewManager.SetActivePage(const tab: TObject);
begin
  inherited;
  if TTabSheet(tab).TabVisible = false then
    TTabSheet(tab).TabVisible := true;
  TPageControl(FPageContainer).ActivePage := TTabSheet(tab);
  TMVCBrObservable.Notify(FPageContainer.ClassName + '.tabchange', nil);
end;

procedure TVCLPageViewManager.SetAfterCreateComplete(const Value: TNotifyEvent);
begin
  FAfterCreateComplete := Value;
end;

procedure TVCLPageViewManager.SetAfterTabCreate(const Value: TNotifyEvent);
begin
  FAfterTabCreate := Value;
end;

procedure TVCLPageViewManager.SetInheritedDraw(const Value: boolean);
var
  rec: TPageControlExtender;
begin
  FInheritedDraw := Value;
  if assigned(FPageContainer) then
  begin
    if LPageControlExtender.ContainsKey(TPageControl(FPageContainer)) then
    begin
      rec := LPageControlExtender.Items[TPageControl(FPageContainer)];
      rec.InheritedDraw := Value;
    end;
    LPageControlExtender.AddOrSetValue(TPageControl(FPageContainer), rec);
  end;
end;

procedure TVCLPageViewManager.SetOnQueryClose(const Value
  : TVCLpageViewOnQueryClose);
begin
  FOnQueryClose := Value;
end;

function TVCLPageViewManager.ContainerName: String;
begin
  result := FPageContainer.name;
end;

function TVCLPageViewManager.GetContainer: TComponent;
begin
  result := FPageContainer;
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
  if assigned(FPageContainer) then
    XSetShowTabColor(TPageControl(FPageContainer), false);

  TMVCBrObservable.UnSubscribe(self, FPageContainer.ClassName + '.tabclose');
  // limpa
  TMVCBrObservable.Subscribe(self, FPageContainer.ClassName + '.tabclose',
    procedure(js: TJsonValue)
    var
      sPage: string;
      nPage: Integer;
    begin
      try
        if js.s('pagecontrol') = ContainerName then
        begin
          if assigned(FPageHistory) then
          begin
            sPage := js.s('caption').trim;
            InvokePageHistory.Remove('history', sPage);
            if FUsePageHistory then
            begin
              if InvokePageHistory.ItemsCount('history') > 0 then
              begin
                sPage := InvokePageHistory.peek('history');
                nPage := IndexOfTabByCaption(sPage);
                if nPage >= 0 then
                  TPageControl(GetContainer).ActivePageIndex := nPage;
              end;
            end;
          end;
        end;

      except
      end;
    end);

end;

procedure TVCLPageViewManager.SetShowCaptions(const Value: boolean);
begin
  if assigned(FPageContainer) then
    XSetShowCaptions(TPageControl(FPageContainer), Value);
end;

procedure TVCLPageViewManager.SetShowTabColor(const Value: boolean);
begin
  if assigned(FPageContainer) then
    XSetShowTabColor(TPageControl(FPageContainer), Value);
end;

procedure TVCLPageViewManager.SetUsePageHistory(const Value: boolean);
begin
  FUsePageHistory := Value;
end;

function TVCLPageViewManager.TabsheetIndexOf(tab: TObject): Integer;
var
  I: Integer;
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

procedure TVCLPageViewManager.Unlock;
begin
  System.TMonitor.exit(FLock);
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
  X: Integer;
  b: boolean;
begin
  b := IsPgShowTabClose(PageControl);

  if not b then
    ShowTabClose := false;

  if ShowTabClose then
    inherited Caption := trim(Value) + '      '
  else
    inherited Caption := trim(Value);
end;

procedure TTabSheetView.SetOnClose(const Value: TNotifyEvent);
begin
  FOnClose := Value;
end;

procedure TTabSheetView.SetOnCloseQuery(const Value: TCloseQueryEvent);
begin
  FOnCloseQuery := Value;
end;

procedure TTabSheetView.SetShowTabClose(const Value: boolean);
begin
  FShowTabClose := Value;
end;

procedure TTabSheetView.DoClose;
var
  ATo: String;
  sPage: string;
  nPageIndex: Integer;
  sPageName: string;
  js: IJsonObject;
begin
  sPage := Caption;
  nPageIndex := PageIndex;
  sPageName := PageControl.name;
  ATo := PageControl.ClassName + '.tabclose';

  if assigned(FOnClose) then
    FOnClose(self);
  free;

  js := TInterfacedJson.New;
  try
    js.addPair('pagecontrol', sPageName);
    js.addPair('caption', sPage);
    js.addPair('pageindex', nPageIndex);
    TMVCBrObservable.Notify(ATo, js.JsonValue);
  finally
    // js.free -  é feito interno no observable;
  end;

end;

procedure TTabSheetView.DoCloseMessage(var TMessage);
begin
  DoClose;
end;

function TTabSheetView.GetCaption: string;
begin
  result := inherited Caption;
end;

procedure TTabSheetView.Notification(AComponent: TComponent;
AOperation: TOperation);
begin
  inherited;
  if AComponent.Equals(FPageFactory) and (AOperation = TOperation.opRemove) then
    FPageFactory := nil;
end;

constructor TTabSheetView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowCaption := true;
  FCloseButtonRect := Rect(0, 0, 0, 0);
end;

{ TVCLPageView }

procedure TVCLPageView.SetPageIndex(const idx: Integer);
begin
  TTabSheetView(tab).PageIndex := idx;
end;

type
  TTabControlStyleHookBtnClose = class(TTabControlStyleHook)
  private
    FHotIndex: Integer;
    FWidthModified: boolean;
    class var FUseBorder: boolean;
    procedure WMMouseMove(var Message: TMessage); message WM_MOUSEMOVE;
    procedure WMLButtonUp(var Message: TWMMouse); message WM_LBUTTONUP;
    function GetButtonCloseRect(Index: Integer): TRect;
    procedure AngleTextOut2(Canvas: TCanvas; Angle, X, Y: Integer;
    const text: string);
  strict protected
    procedure DrawTab(Canvas: TCanvas; Index: Integer); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
  protected
    class property UseBorder: boolean read FUseBorder write FUseBorder;

  public
    constructor Create(AControl: TWinControl); override;

  end;

constructor TTabControlStyleHookBtnClose.Create(AControl: TWinControl);
begin
  inherited;
  FHotIndex := -1;
  FWidthModified := false;
end;

type
  TWinControlClass = class(TWinControl);
  TCustomTabControlClass = class(TCustomTabControl);

function GetBorderColorTab: TColor;
begin
  result := clBlack;
end;

function GetColorTab(Index: Integer): TColor;
Const
  MaxColors = 9;
  Colors: Array [0 .. MaxColors - 1] of TColor = (6512214, 16755712, 8355381,
    1085522, 115885, 1098495, 1735163, 2248434, 4987610);
begin
  result := Colors[Index mod MaxColors];
end;

function GetColorTextTab(ThemedTab: TThemedTab): TColor;
Const
  ColorSelected = clYellow;
  ColorHot = clGray;
  ColorNormal = clWhite;
begin
  result := ColorNormal;
  case ThemedTab of
    ttTabItemSelected, ttTabItemLeftEdgeSelected, ttTabItemBothEdgeSelected,
      ttTabItemRightEdgeSelected:
      result := ColorSelected;

    ttTabItemHot, ttTabItemLeftEdgeHot, ttTabItemBothEdgeHot,
      ttTabItemRightEdgeHot:
      result := ColorHot;

    ttTabItemNormal, ttTabItemLeftEdgeNormal, ttTabItemBothEdgeNormal,
      ttTabItemRightEdgeNormal:
      result := ColorNormal;
  end;
end;

procedure TTabControlStyleHookBtnClose.AngleTextOut2(Canvas: TCanvas;
Angle, X, Y: Integer; const text: string);
var
  LSavedDC: Integer;
begin
  LSavedDC := SaveDC(Canvas.Handle);
  try
    SetBkMode(Canvas.Handle, TRANSPARENT);
    Canvas.Font.Orientation := Angle;
    Canvas.TextOut(X, Y, text);
  finally
    RestoreDC(Canvas.Handle, LSavedDC);
  end;
end;

procedure TTabControlStyleHookBtnClose.DrawTab(Canvas: TCanvas; Index: Integer);
var
  s: string;
  Details: TThemedElementDetails;
  ButtonR: TRect;
  FButtonState: TThemedWindow;
  pg: TPageControl;
  // begin
  // inherited;
  // inicio
  // procedure TTabColorControlStyleHook.DrawTab(Canvas: TCanvas; Index: Integer);
  // var
  LDetails: TThemedElementDetails;
  LImageIndex: Integer;
  LThemedTab: TThemedTab;
  LIconRect: TRect;
  R, LayoutR: TRect;
  LImageW, LImageH, DxImage: Integer;
  LTextX, LTextY: Integer;
  LTextColor: TColor;

  procedure DrawControlText(const s: string; var R: TRect; Flags: Cardinal);
  var
    TextFormat: TTextFormatFlags;
  begin
    Canvas.Font := TWinControlClass(Control).Font;
    TextFormat := TTextFormatFlags(Flags);
    Canvas.Font.Color := LTextColor;
    StyleServices.DrawText(Canvas.Handle, LDetails, s, R, TextFormat,
      Canvas.Font.Color);
  end;

var
  AInheritedDraw: boolean;
  ARec: TPageControlExtender;
  TabSheet: TTabSheet;
  PageControl: TPageControl;
begin
  AInheritedDraw := true;
  if Control.InheritsFrom(TPageControl) then
  begin
    PageControl := TPageControl(Control);
    TabSheet := PageControl.Pages[index];
    if trim(TabSheet.Caption) = 'hide' then
      exit;
    if TabSheet.Caption = '' then
      TabSheet.Caption := (index+1).toString;
    if LPageControlExtender.ContainsKey(PageControl) then
    begin
      ARec := LPageControlExtender.Items[PageControl];
      if ARec.InheritedDraw = false then
      begin
        if ARec.ShowCaptions = false then
          exit;

        if TabSheet.InheritsFrom(TMVCBrTabSheetView) then
          if TMVCBrTabSheetView(TabSheet).ShowCaption = false then
            exit;

      end;
    end;
  end;
  if ARec.InheritedDraw then
    Inherited
  else
  begin
    if (Images <> nil) and (Index < Images.Count) then
    begin
      LImageW := Images.Width;
      LImageH := Images.Height;
      DxImage := 3;
    end
    else
    begin
      LImageW := 0;
      LImageH := 0;
      DxImage := 0;
    end;

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

    Canvas.Font.Assign(TCustomTabControlClass(Control).Font);
    LayoutR := R;
    LThemedTab := ttTabDontCare;
    // Get the type of the active tab
    case TabPosition of
      tpTop:
        begin
          if Index = TabIndex then
            LThemedTab := ttTabItemSelected
          else if (Index = HotTabIndex) and MouseInControl then
            LThemedTab := ttTabItemHot
          else
            LThemedTab := ttTabItemNormal;
        end;
      tpLeft:
        begin
          if Index = TabIndex then
            LThemedTab := ttTabItemLeftEdgeSelected
          else if (Index = HotTabIndex) and MouseInControl then
            LThemedTab := ttTabItemLeftEdgeHot
          else
            LThemedTab := ttTabItemLeftEdgeNormal;
        end;
      tpBottom:
        begin
          if Index = TabIndex then
            LThemedTab := ttTabItemBothEdgeSelected
          else if (Index = HotTabIndex) and MouseInControl then
            LThemedTab := ttTabItemBothEdgeHot
          else
            LThemedTab := ttTabItemBothEdgeNormal;
        end;
      tpRight:
        begin
          if Index = TabIndex then
            LThemedTab := ttTabItemRightEdgeSelected
          else if (Index = HotTabIndex) and MouseInControl then
            LThemedTab := ttTabItemRightEdgeHot
          else
            LThemedTab := ttTabItemRightEdgeNormal;
        end;
    end;

    // draw the tab
    if StyleServices.Available then
    begin
      LDetails := StyleServices.GetElementDetails(LThemedTab);
      // necesary for  DrawControlText

      if FUseBorder then
      begin
        case TabPosition of
          tpTop:
            begin
              InflateRect(R, -1, 0);
              if TabIndex <> Index then
                R.Bottom := R.Bottom + 1
              else
                R.Bottom := R.Bottom - 1;

              Canvas.Brush.Color := GetBorderColorTab;
              Canvas.FillRect(R);

              if TabIndex = Index then
              begin
                InflateRect(R, -1, -1);
                R.Bottom := R.Bottom + 1;
              end
              else
                InflateRect(R, -1, -1);
            end;

          tpBottom:
            begin
              InflateRect(R, -1, 0);
              if TabIndex <> Index then
                R.Bottom := R.Bottom + 1
              else
                R.Top := R.Top + 3;

              Canvas.Brush.Color := GetBorderColorTab;
              Canvas.FillRect(R);

              if TabIndex = Index then
              begin
                InflateRect(R, -1, 0);
                R.Bottom := R.Bottom - 1;
              end
              else
                InflateRect(R, -1, -1);
            end;

          tpLeft:
            begin
              InflateRect(R, 0, -1);

              if TabIndex <> Index then
                R.Left := R.Left + 1
              else
                R.Right := R.Right - 1;

              Canvas.Brush.Color := GetBorderColorTab;
              Canvas.FillRect(R);

              if TabIndex = Index then
              begin
                InflateRect(R, -1, -1);
                R.Right := R.Right + 1;
              end
              else
                InflateRect(R, -1, -1);

            end;

          tpRight:
            begin
              InflateRect(R, 0, -1);

              if TabIndex <> Index then
                // R.Left:=R.Left+1
              else
                R.Left := R.Left + 3;

              Canvas.Brush.Color := GetBorderColorTab;
              Canvas.FillRect(R);

              if TabIndex = Index then
              begin
                InflateRect(R, -1, -1);
                R.Left := R.Left - 1;
              end
              else
                InflateRect(R, -1, -1);

            end;

        end;

        Canvas.Brush.Color := GetColorTab(Index);
        Canvas.FillRect(R);
      end
      else
      Begin
        InflateRect(R, -1, 0);
        // adjust the size of the tab creating blanks space between the tabs
        Canvas.Brush.Color := GetColorTab(Index);
        Canvas.FillRect(R);
      end;

    end;

    // get the index of the image (icon)
    if Control is TCustomTabControl then
      LImageIndex := TCustomTabControlClass(Control).GetImageIndex(Index)
    else
      LImageIndex := Index;

    // draw the image
    if (Images <> nil) and (LImageIndex >= 0) and (LImageIndex < Images.Count)
    then
    begin
      LIconRect := LayoutR;
      case TabPosition of
        tpTop, tpBottom:
          begin
            LIconRect.Left := LIconRect.Left + DxImage;
            LIconRect.Right := LIconRect.Left + LImageW;
            LayoutR.Left := LIconRect.Right;
            LIconRect.Top := LIconRect.Top + (LIconRect.Bottom - LIconRect.Top)
              div 2 - LImageH div 2;
            if (TabPosition = tpTop) and (Index = TabIndex) then
              OffsetRect(LIconRect, 0, -1)
            else if (TabPosition = tpBottom) and (Index = TabIndex) then
              OffsetRect(LIconRect, 0, 1);
          end;
        tpLeft:
          begin
            LIconRect.Bottom := LIconRect.Bottom - DxImage;
            LIconRect.Top := LIconRect.Bottom - LImageH;
            LayoutR.Bottom := LIconRect.Top;
            LIconRect.Left := LIconRect.Left +
              (LIconRect.Right - LIconRect.Left) div 2 - LImageW div 2;
          end;
        tpRight:
          begin
            LIconRect.Top := LIconRect.Top + DxImage;
            LIconRect.Bottom := LIconRect.Top + LImageH;
            LayoutR.Top := LIconRect.Bottom;
            LIconRect.Left := LIconRect.Left +
              (LIconRect.Right - LIconRect.Left) div 2 - LImageW div 2;
          end;
      end;
      if StyleServices.Available then
        StyleServices.DrawIcon(Canvas.Handle, LDetails, LIconRect,
          Images.Handle, LImageIndex);
    end;

    // draw the text of the tab
    if StyleServices.Available then
    begin
      LTextColor := GetColorTextTab(LThemedTab);

      if (TabPosition = tpTop) and (Index = TabIndex) then
        OffsetRect(LayoutR, 0, -1)
      else if (TabPosition = tpBottom) and (Index = TabIndex) then
        OffsetRect(LayoutR, 0, 1);

      if TabPosition = tpLeft then
      begin
        LTextX := LayoutR.Left + (LayoutR.Right - LayoutR.Left) div 2 -
          Canvas.TextHeight(Tabs[Index]) div 2;
        LTextY := LayoutR.Top + (LayoutR.Bottom - LayoutR.Top) div 2 +
          Canvas.TextWidth(Tabs[Index]) div 2;
        Canvas.Font.Color := LTextColor;
        AngleTextOut2(Canvas, 900, LTextX, LTextY, Tabs[Index]);
      end
      else if TabPosition = tpRight then
      begin
        LTextX := LayoutR.Left + (LayoutR.Right - LayoutR.Left) div 2 +
          Canvas.TextHeight(Tabs[Index]) div 2;
        LTextY := LayoutR.Top + (LayoutR.Bottom - LayoutR.Top) div 2 -
          Canvas.TextWidth(Tabs[Index]) div 2;
        Canvas.Font.Color := LTextColor;
        AngleTextOut2(Canvas, -900, LTextX, LTextY, Tabs[Index]);
      end
      else
      begin
        s := PageControl.Pages[index].Caption;
        DrawControlText(s, LayoutR, DT_VCENTER or DT_CENTER or DT_SINGLELINE or
          DT_NOCLIP);
      end;
    end;
    // fim
  end;
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
  LIndex: Integer;
begin
  LPoint := Message.Pos;
  for LIndex := 0 to TabCount - 1 do
    if PtInRect(GetButtonCloseRect(LIndex), LPoint) then
    begin
      if (Control is TPageControl) and IsPgShowTabClose(TPageControl(Control))
        and (IsShowTabClose(TPageControl(Control).Pages[LIndex])) then
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
  LIndex: Integer;
  LHotIndex: Integer;
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

function TTabControlStyleHookBtnClose.GetButtonCloseRect(Index: Integer): TRect;
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

{ TMVCBrTabSheetView }

procedure TMVCBrTabSheetView.SetShowCaption(const Value: boolean);
begin
  FShowCaption := Value;
  Update;
end;

initialization

TStyleManager.Engine.RegisterStyleHook(TCustomTabControl,
  TTabControlStyleHookBtnClose);
TStyleManager.Engine.RegisterStyleHook(TTabControl,
  TTabControlStyleHookBtnClose);

LPageControlExtender :=
  TDictionary<TPageControl, TPageControlExtender>.Create();

finalization

LPageControlExtender.free;

end.
