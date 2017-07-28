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
    procedure DoFormCloseQuery(Sender: TObject; var canClose: boolean);
    function TabsheetIndexOf(tab: TObject): integer;
  protected
    Procedure DoQueryClose(const APageView: IPageView;
      var ACanClose: boolean); override;
    procedure SetActivePage(Const tab: TObject); override;
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;

  public
    class function New(AController: IController): IPageViews;
    [weak]function Update: IModel; virtual;

    function GetPageTabClass: TComponentClass; override;
    function GetPageContainerClass: TComponentClass; override;
    function NewTab(APageView: IPageView): TObject; override;
    [weak]function AddView(AView: IView): IPageView; override;
    [weak]function AddView(Const AController: TGuid): IPageView; overload; override;
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

uses MVCBr.Controller;

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

procedure TVCLPageViewManager.DoFormCloseQuery(Sender: TObject;
  var canClose: boolean);
var
  LPageView: IPageView;
  i: integer;
  tab: TObject;
  pgIndex: integer;
begin
  LPageView := FindViewByClassName(Sender.ClassName);
  if not assigned(LPageView) then
    exit;
  DoQueryClose(LPageView, canClose);

  if not canClose then
    abort;
  pgIndex := PageViewIndexOf(LPageView);
  if (pgIndex >= 0) and assigned(LPageView) then
  begin
    i := TabsheetIndexOf(LPageView.This.tab);
    if (i >= 0) and (pgIndex >= 0) then
    begin
      TForm(LPageView.This.View.This).OnCloseQuery := nil;
      LPageView.This.tab.Free;

    end;
  end;
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
  TTabSheetView = class(TTabsheet)
  public
    PageView: IPageView;
    destructor destroy; override;
    procedure canClose(var ACanClose: boolean);
  end;

procedure TTabSheetView.canClose(var ACanClose: boolean);
var
  form: TForm;
  ref: TVCLPageViewManager;
begin
  // chamado quando a tabsheet é apagada.
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
        begin
          TControllerAbstract.RevokeInstance(  PageView.This.View.GetController  );
        end;

      end;
end;

destructor TTabSheetView.destroy;
var
  LCanClose: boolean;
begin
  LCanClose := true;
  canClose(LCanClose);
  if not LCanClose then
    abort;
  if assigned(PageView) then
  begin
    TForm(PageView.This.View.This).OnCloseQuery := nil;
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
        parent := TTabsheet(APageView.This.tab);
        Align := alClient;
        BorderStyle := bsNone;
        TTabsheet(APageView.This.tab).Caption := APageView.This.text;
        if APageView.This.View.This.InheritsFrom(TFormFactory) then
        begin
          with TFormFactory(APageView.This.View.This) do
          begin
            OnCloseQuery := DoFormCloseQuery;
            isShowModal := false;
          end;
          APageView.This.View.ShowView(nil);
          APageView.This.View.Init;
          show;
        end
        else
          show;
        if assigned(FAfterCreateComplete) then
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
  tab: TTabSheetView;
begin
  tab := GetPageTabClass.Create(FPageContainer) as TTabSheetView;
  tab.PageControl := TPageControl(FPageContainer);
  tab.PageView := APageView;
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
  TPageControl(FPageContainer).ActivePage := TTabsheet(tab);
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
  i: integer;
begin
  result := -1;
  with TPageControl(FPageContainer) do
    for i := 0 to PageCount - 1 do
      if Pages[i].Equals(tab) then
      begin
        result := i;
        exit;
      end;
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
