unit MVCBr.VCL.PageView;

interface

uses VCL.Forms, VCL.Controls, System.Classes, System.SysUtils, MVCBr.Interf,
  MVCBr.PageView, MVCBr.FormView, VCL.ComCtrls;

type

  TVCLpageViewOnQueryClose = procedure(APageView: IPageView;
    var ACanClose: boolean) of object;

  TVCLPageViewManager = class(TCustomPageViewFactory, IPageViews)
  private
    FOldPageChange: TNotifyEvent;
    FOnQueryClose: TVCLpageViewOnQueryClose;
    FAfterTabCreate: TNotifyEvent;
    FAfterCreateComplete: TNotifyEvent;
    procedure Init(APageView: IPageView); override;
    procedure SetPageControlEx(const Value: TPageControl);
    function GetPageControlEx: TPageControl;
    procedure SetOnQueryClose(const Value: TVCLpageViewOnQueryClose);
    procedure SetAfterTabCreate(const Value: TNotifyEvent);
    procedure SetAfterCreateComplete(const Value: TNotifyEvent);
    procedure DoPageChange(Sender: TObject);
  protected
    Procedure DoQueryClose(const APageView: IPageView;
      var ACanClose: boolean); override;
    procedure SetActivePage(Const Tab: TObject); override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;


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
    property AfterCreateComplete: TNotifyEvent read FAfterCreateComplete write SetAfterCreateComplete;
    property AfterTabCreate: TNotifyEvent read FAfterTabCreate
      write SetAfterTabCreate;
    property OnQueryClose: TVCLpageViewOnQueryClose read FOnQueryClose
      write SetOnQueryClose;
  end;

procedure register;

implementation

procedure register;
begin
  RegisterComponents('MVCBr', [TVCLPageViewManager]);
end;

{ TVCLPageViewFactory }

function TVCLPageViewManager.AddView(AView: IView): IPageView;
begin
  result := inherited AddView(AView);
end;

function TVCLPageViewManager.AddView(const AController: TGuid): IPageView;
begin
  result := inherited AddView(AController);
end;

procedure TVCLPageViewManager.DoQueryClose(const APageView: IPageView;
  var ACanClose: boolean);
begin
  inherited;
  if assigned(FOnQueryClose) then
    FOnQueryClose(APageView, ACanClose);
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
  ref: TVCLPageViewManager;
begin
  ref := TVCLPageViewManager(PageView.This.GetOwner);
  if assigned(ref) and assigned(ref.OnQueryClose) then
    TVCLPageViewManager(ref).OnQueryClose(PageView, ACanClose);

  if ACanClose then
    if assigned(PageView) then
      if assigned(PageView.This.View) then
      begin
        form := TForm(PageView.This.View.This);
        if assigned(form) then
          if assigned(form.OnCloseQuery) then
            form.OnCloseQuery(self, ACanClose);
        if ACanClose then
          with PageView.This.View.GetController do
          begin
            RevokeInstance;
          end;

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

function TVCLPageViewManager.GetPageTabClass: TComponentClass;
begin
  result := TTabSheetView;
end;

procedure TVCLPageViewManager.Init(APageView: IPageView);
var
  frm: TForm;
begin
  if assigned(APageView) then
    if assigned(APageView.This.View) then
    begin
      if APageView.This.View.This.InheritsFrom(TViewFactoryAdapter) then
      begin
        frm := TForm(TViewFactoryAdapter(APageView.This.View.This).form);
        APageView.This.text := frm.Caption;
      end
      else
        frm := TForm(APageView.This.View.This);
      with frm do
      begin
        parent := TTabSheet(APageView.This.Tab);
        Align := alClient;
        BorderStyle := bsNone;
        TTabSheet(APageView.This.Tab).Caption := APageView.This.text;
        if APageView.This.View.This.InheritsFrom(TFormFactory) then
        begin
          TFormFactory(APageView.This.View.This).isShowModal := false;
          APageView.This.View.ShowView(nil);
          show;
        end
        else
          show;
        if assigned(FAfterCreateComplete ) then
          FAfterCreateComplete(APageView.This);
      end;
    end;
end;

class function TVCLPageViewManager.New(AController: IController): IPageViews;
begin
  result := TVCLPageViewManager.Create(nil);
  result.Controller(AController);
end;

function TVCLPageViewManager.NewTab(APageView: IPageView): TObject;
var
  Tab: TTabSheetView;
begin
  Tab := GetPageTabClass.Create(FPageContainer) as TTabSheetView;
  Tab.PageControl := TPageControl(FPageContainer);
  Tab.PageView := APageView;
  TPageControl(FPageContainer).ActivePage := Tab;
  result := Tab;
  if assigned(FAfterTabCreate) then
    FAfterTabCreate(Tab);
end;

procedure TVCLPageViewManager.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited;

end;

procedure TVCLPageViewManager.SetActivePage(const Tab: TObject);
begin
  inherited;
  TPageControl(FPageContainer).ActivePage := TTabSheet(Tab);
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

function TVCLPageViewManager.Update: IModel;
var
  APageView: IPageView;
begin
  ActivePageIndex := TPageControl(FPageContainer).ActivePageIndex;
  APageView := ActivePage;
  Init(APageView);
end;

end.
