unit MVCBr.VCL.PageControl;

interface

uses VCL.Forms, VCL.Controls, System.Classes, System.SysUtils, MVCBr.Interf,
  MVCBr.PageView, MVCBr.FormView, VCL.ComCtrls;

type

  TVCLpageViewOnQueryClose = procedure(APageView: IPageView;
    var ACanClose: boolean) of object;

  TVCLPageViewFactory = class(TCustomPageViewFactory, IPageViews)
  private
    FOnQueryClose: TVCLpageViewOnQueryClose;
    FAfterTabCreate: TNotifyEvent;
    FAfterInited: TNotifyEvent;
    procedure Init(APageView: IPageView); override;
    procedure SetPageControlEx(const Value: TPageControl);
    function GetPageControlEx: TPageControl;
    procedure SetOnQueryClose(const Value: TVCLpageViewOnQueryClose);
    procedure SetAfterTabCreate(const Value: TNotifyEvent);
    procedure SetAfterInited(const Value: TNotifyEvent);
  protected
    Procedure DoQueryClose(const APageView: IPageView;
      var ACanClose: boolean); override;

  public
    class function New(AController: IController): IPageViews;
    function Update: IModel; virtual;

    function GetPageTabClass: TComponentClass; override;
    function GetPageContainerClass: TComponentClass; override;
    function NewTab(APageView: IPageView): TObject; override;
    function AddView(AView: IView): IPageView; override;
    function AddView(Const AController: TGuid): IPageView; overload; override;
  published
    property PageControl: TPageControl read GetPageControlEx
      write SetPageControlEx;
    property AfterViewCreate;
    property AfterInited: TNotifyEvent read FAfterInited write SetAfterInited;
    property AfterTabCreate: TNotifyEvent read FAfterTabCreate
      write SetAfterTabCreate;
    property OnQueryClose: TVCLpageViewOnQueryClose read FOnQueryClose
      write SetOnQueryClose;
  end;

procedure register;

implementation

procedure register;
begin
  RegisterComponents('VCL MVCBr', [TVCLPageViewFactory]);
end;

{ TVCLPageViewFactory }

function TVCLPageViewFactory.AddView(AView: IView): IPageView;
begin
  result := inherited AddView(AView);
  Init(result);
end;

function TVCLPageViewFactory.AddView(const AController: TGuid): IPageView;
begin
  result := inherited AddView(AController);
end;

procedure TVCLPageViewFactory.DoQueryClose(const APageView: IPageView;
  var ACanClose: boolean);
begin
  inherited;
  if assigned(FOnQueryClose) then
    FOnQueryClose(APageView, ACanClose);
end;

function TVCLPageViewFactory.GetPageContainerClass: TComponentClass;
begin
  result := TPageControl;
end;

function TVCLPageViewFactory.GetPageControlEx: TPageControl;
begin
  result := TPageControl(FPageContainer);
end;

type
  TTabSheetView = class(TTabSheet)
  public
    PageView: IPageView;
    destructor destroy; override;
    procedure CanClose(var ACanClose: boolean);
  end;

procedure TTabSheetView.CanClose(var ACanClose: boolean);
var
  form: TForm;
  ref: TVCLPageViewFactory;
begin
  ref := TVCLPageViewFactory(PageView.This.GetOwner);
  if assigned(ref) and assigned(ref.OnQueryClose) then
    TVCLPageViewFactory(ref).OnQueryClose(PageView, ACanClose);

  if ACanClose then
    if assigned(PageView) then
      if assigned(PageView.This.View) then
      begin
        form := TForm(PageView.This.View.This);
        if assigned(form) then
          if assigned(form.OnCloseQuery) then
            form.OnCloseQuery(self, ACanClose);
      end;
end;

destructor TTabSheetView.destroy;
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

function TVCLPageViewFactory.GetPageTabClass: TComponentClass;
begin
  result := TTabSheetView;
end;

procedure TVCLPageViewFactory.Init(APageView: IPageView);
begin
  if assigned(APageView) then
    if assigned(APageView.This.View) then
      with TForm(APageView.This.View.This) do
      begin
        parent := TTabSheet(APageView.This.Tab);
        Align := alClient;
        BorderStyle := bsNone;
        TTabSheet(APageView.This.Tab).Caption := APageView.This.Text;
        if APageView.This.View.This.InheritsFrom(TFormFactory) then
        begin
          TFormFactory(APageView.This.View.This).isShowModal := false;
          APageView.This.View.ShowView(nil);
          show;
        end
        else
          show;
        if assigned(AfterInited) then
          AfterInited(APageView.This);
      end;
end;

class function TVCLPageViewFactory.New(AController: IController): IPageViews;
begin
  result := TVCLPageViewFactory.Create(nil);
  result.Controller(AController);
end;

function TVCLPageViewFactory.NewTab(APageView: IPageView): TObject;
var
  Tab: TTabSheetView;
begin
  Tab := GetPageTabClass.Create(FPageContainer) as TTabSheetView;
  Tab.PageControl := TPageControl(FPageContainer);
  Tab.PageView := APageView;

  result := Tab;
  if assigned(FAfterTabCreate) then
    FAfterTabCreate(Tab);
end;

procedure TVCLPageViewFactory.SetAfterInited(const Value: TNotifyEvent);
begin
  FAfterInited := Value;
end;

procedure TVCLPageViewFactory.SetAfterTabCreate(const Value: TNotifyEvent);
begin
  FAfterTabCreate := Value;
end;

procedure TVCLPageViewFactory.SetOnQueryClose(const Value
  : TVCLpageViewOnQueryClose);
begin
  FOnQueryClose := Value;
end;

procedure TVCLPageViewFactory.SetPageControlEx(const Value: TPageControl);
begin
  FPageContainer := Value;
end;

function TVCLPageViewFactory.Update: IModel;
var
  APageView: IPageView;
begin
  ActivePageIndex := TPageControl(FPageContainer).ActivePageIndex;
  APageView := ActivePage;
  Init(APageView);
end;

end.
