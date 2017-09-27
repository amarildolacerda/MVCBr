unit MVCBr.FMX.PageView;

interface

uses FMX.Forms, FMX.Controls, System.Classes, System.SysUtils, MVCBr.Interf,
  MVCBr.PageView, MVCBr.FormView, FMX.TabControl, FMX.Types;

type

  TFMXpageViewOnQueryClose = procedure(APageView: IPageView;
    var ACanClose: boolean) of object;

  TFMXPageViewManager = class(TCustomPageViewFactory, IPageViews)
  private
    FOldPageChange: TNotifyEvent;
    FOnQueryClose: TFMXpageViewOnQueryClose;
    FAfterTabCreate: TNotifyEvent;
    FAfterCreate: TNotifyEvent;
    procedure Init(APageView: TPageView); override;
    procedure SetTabControl(const Value: TTabControl);
    function GetTabControl: TTabControl;
    procedure SetOnQueryClose(const Value: TFMXpageViewOnQueryClose);
    procedure SetAfterTabCreate(const Value: TNotifyEvent);
    procedure SetAfterCreate(const Value: TNotifyEvent);
    procedure DoPageChange(Sender: TObject);
  protected
    Procedure DoQueryClose(const APageView: TPageView;
      var ACanClose: boolean); override;
    procedure SetActivePage(Const Tab: TObject); override;

  public
    class function New(AController: IController): IPageViews;
    function Update: IModel; virtual;

    function GetPageTabClass: TComponentClass; override;
    function GetPageContainerClass: TComponentClass; override;
    function NewTab(APageView: TPageView; ACaption: String = '')
      : TObject; override;
    function AddView(AView: IView): TPageView; override;
    function AddView(Const AController: TGuid): TPageView; overload; override;
  published
    property TabControl: TTabControl read GetTabControl write SetTabControl;
    property AfterViewCreate;
    property AfterCreateComplete: TNotifyEvent read FAfterCreate
      write SetAfterCreate;
    property AfterTabCreate: TNotifyEvent read FAfterTabCreate
      write SetAfterTabCreate;
    property OnQueryClose: TFMXpageViewOnQueryClose read FOnQueryClose
      write SetOnQueryClose;
  end;

procedure register;

implementation

uses FMX.Layouts;

procedure register;
begin
  RegisterComponents('MVCBr', [TFMXPageViewManager]);
end;

{ TVCLPageViewFactory }

function TFMXPageViewManager.AddView(AView: IView): TPageView;
begin
  result := inherited AddView(AView);
end;

function TFMXPageViewManager.AddView(const AController: TGuid): TPageView;
begin
  result := inherited AddView(AController);
end;

procedure TFMXPageViewManager.DoQueryClose(const APageView: TPageView;
  var ACanClose: boolean);
begin
  inherited;
  if assigned(FOnQueryClose) then
    FOnQueryClose(APageView, ACanClose);
end;

procedure TFMXPageViewManager.DoPageChange(Sender: TObject);
begin
  if assigned(FOldPageChange) then
    FOldPageChange(Sender);
  ActivePageIndex := TTabControl(FPageContainer).TabIndex;
end;

function TFMXPageViewManager.GetPageContainerClass: TComponentClass;
begin
  result := TTabControl;
end;

function TFMXPageViewManager.GetTabControl: TTabControl;
begin
  result := TTabControl(FPageContainer);
end;

type
  TTabItemView = class(TTabItem)
  private
    FViewer: TLayout;
    FPageView: TPageView;
    procedure SetPageView(const Value: TPageView);
  public
    property PageView: TPageView read FPageView write SetPageView;
    constructor Create(AOwner: TComponent); override;
    destructor destroy; override;
    procedure CanClose(var ACanClose: boolean);
  end;

procedure TTabItemView.CanClose(var ACanClose: boolean);
var
  form: TForm;
  ref: TFMXPageViewManager;
begin
  ref := TFMXPageViewManager(PageView.This.GetOwner);
  if assigned(ref) and assigned(ref.OnQueryClose) then
    TFMXPageViewManager(ref).OnQueryClose(PageView, ACanClose);

  if ACanClose then
    if assigned(PageView) then
      if assigned(PageView.This.View) then
      begin
        form := TForm(PageView.View);
        if assigned(form) then
          if assigned(form.OnCloseQuery) then
            form.OnCloseQuery(self, ACanClose);
        if ACanClose then
        // with PageView.This.View.GetController do
        begin
          TControllerAbstract.RevokeInstance(PageView.Controller);
        end;
      end;
end;

constructor TTabItemView.create(AOwner: TComponent);
begin
  inherited;
  FPageView := nil;
  FViewer := TLayout.create(self);
  FViewer.Parent := self;
  FViewer.Align := TAlignLayout.Client;
end;

destructor TTabItemView.destroy;
var
  LCanClose: boolean;
begin
  LCanClose := true;
  CanClose(LCanClose);
  if not LCanClose then
    abort;
  if assigned(PageView) then
  begin
    PageView.remove;
    PageView := nil;
  end;
  inherited destroy;
end;

procedure TTabItemView.SetPageView(const Value: TPageView);
begin
  FPageView := Value;
end;

function TFMXPageViewManager.GetPageTabClass: TComponentClass;
begin
  result := TTabItemView;
end;

procedure TFMXPageViewManager.Init(APageView: TPageView);
var
  frm: TForm;
  tl: TLayout;
  o: TComponent;
  v: IView;
begin
  if assigned(APageView) then
    if assigned(APageView.This.View) then
    begin
      if APageView.View.InheritsFrom(TViewFactoryAdapter) then
      begin
        frm := TForm(TViewFactoryAdapter(APageView.View).form);
        APageView.This.text := frm.Caption;
      end
      else
        frm := TForm(APageView.View);
      with frm do
      begin
        frm.Parent := TTabItemView(APageView.This.Tab).FViewer;
        while frm.ChildrenCount > 0 do
          frm.Children[0].Parent := TTabItemView(APageView.This.Tab).FViewer;
        BorderStyle := TFmxFormBorderStyle.None;
        TTabItem(APageView.This.Tab).text := APageView.This.text;
        if APageView.View.InheritsFrom(TFormFactory) then
        begin
          TFormFactory(APageView.View).isShowModal := false;
          if supports(APageView.View, IView, v) then
            with TFormFactory(APageView.View) do
              if assigned(OnShow) then
                OnShow(self);
          // v.ShowView(nil);
        end
        else if assigned(AfterCreateComplete) then
          AfterCreateComplete(APageView.This);
      end;
    end;
end;

class function TFMXPageViewManager.New(AController: IController): IPageViews;
begin
  result := TFMXPageViewManager.create(nil);
  result.Controller(AController);
end;

function TFMXPageViewManager.NewTab(APageView: TPageView;
  ACaption: String): TObject;
var
  Tab: TTabItemView;
begin
  Tab := GetPageTabClass.create(FPageContainer) as TTabItemView;
  Tab.Parent := TTabControl(FPageContainer);
  Tab.PageView := APageView;
  Tab.text := ACaption;
  TTabControl(FPageContainer).ActiveTab := Tab;
  result := Tab;
  if assigned(FAfterTabCreate) then
    FAfterTabCreate(Tab);
end;

procedure TFMXPageViewManager.SetActivePage(const Tab: TObject);
begin
  inherited;
  TTabControl(FPageContainer).ActiveTab := TTabItem(Tab);
end;

procedure TFMXPageViewManager.SetAfterCreate(const Value: TNotifyEvent);
begin
  FAfterCreate := Value;
end;

procedure TFMXPageViewManager.SetAfterTabCreate(const Value: TNotifyEvent);
begin
  FAfterTabCreate := Value;
end;

procedure TFMXPageViewManager.SetOnQueryClose(const Value
  : TFMXpageViewOnQueryClose);
begin
  FOnQueryClose := Value;
end;

procedure TFMXPageViewManager.SetTabControl(const Value: TTabControl);
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

function TFMXPageViewManager.Update: IModel;
var
  APageView: TPageView;
begin
  ActivePageIndex := TTabControl(FPageContainer).TabIndex;
  APageView := ActivePage;
  Init(APageView);
end;

end.
