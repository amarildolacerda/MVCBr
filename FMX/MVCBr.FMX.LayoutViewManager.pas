{ //************************************************************// }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //                                                            // }
{ //************************************************************// }
{ // Data: 15/02/2017 23:07:44                                  // }
{ //************************************************************// }
///
/// PageView - Adapter para navegação com TLayout
///
unit MVCBr.FMX.LayoutViewManager;

interface

uses FMX.Forms, FMX.Controls, System.Classes, System.SysUtils, MVCBr.Interf,
  System.Generics.collections,
  MVCBr.PageView, MVCBr.FormView, FMX.Layouts, FMX.Types;

type

  TFMXLayoutViewManager = class;

  TFMXpageViewOnQueryClose = procedure(APageView: IPageView;
    var ACanClose: boolean) of object;

  TLayoutTabItem = class(TLayout)
  protected
    FViewer: TLayout;
  public
    LayoutContainer: TLayout;
    Text: string;
    PageView: IPageView;
    constructor create(AOwner: TComponent); override;
    destructor destroy; override;
    procedure CanClose(var ACanClose: boolean);
  end;

  /// cria uma lista de view que associado com o TLayout gera navegação
  /// das views com o Layout;
  TFMXLayoutViewManager = class(TCustomPageViewFactory, IPageViews)
  private
    FOldPageChange: TNotifyEvent;
    FOnQueryClose: TFMXpageViewOnQueryClose;
    FAfterTabCreate: TNotifyEvent;
    FAfterCreate: TNotifyEvent;
    procedure Init(APageView: IPageView); override;
    procedure SetLayoutContainer(const Value: TLayout);
    function GetLayoutContainer: TLayout;
    procedure SetOnQueryClose(const Value: TFMXpageViewOnQueryClose);
    procedure SetAfterTabCreate(const Value: TNotifyEvent);
    procedure SetAfterCreate(const Value: TNotifyEvent);
    procedure DoPageChange(Sender: TObject);
    function GetActiveTab: TLayoutTabItem;
  protected
    Procedure DoQueryClose(const APageView: IPageView;
      var ACanClose: boolean); override;

  public
    constructor create(AOwner: TComponent); override;
    destructor destroy; override;
    class function New(AController: IController): IPageViews;
    function Update: IModel; virtual;

    function GetPageTabClass: TComponentClass; override;
    function GetPageContainerClass: TComponentClass; override;
    function NewTab(APageView: IPageView): TObject; override;
    function AddView(AView: IView): IPageView; override;
    function AddView(Const AController: TGuid): IPageView; overload; override;
    property ActiveTab: TLayoutTabItem read GetActiveTab;
  published
    property Layout: TLayout read GetLayoutContainer write SetLayoutContainer;
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

procedure register;
begin
  RegisterComponents('MVCBr', [TFMXLayoutViewManager]);
end;

{ TVCLPageViewFactory }

function TFMXLayoutViewManager.AddView(AView: IView): IPageView;
begin
  result := inherited AddView(AView);
end;

function TFMXLayoutViewManager.AddView(const AController: TGuid): IPageView;
begin
  result := inherited AddView(AController);
end;

constructor TFMXLayoutViewManager.create(AOwner: TComponent);
begin
  inherited;
end;

destructor TFMXLayoutViewManager.destroy;
var
  item: TObject;
begin
  { while FList.Count > 0 do
    begin
    item := IPageView(FList.Items[FList.Count - 1]).This.Tab;
    freeAndNil(item);
    FList.Delete(FList.Count - 1);
    end;
  }
  inherited;
end;

procedure TFMXLayoutViewManager.DoQueryClose(const APageView: IPageView;
  var ACanClose: boolean);
begin
  inherited;
  if assigned(FOnQueryClose) then
    FOnQueryClose(APageView, ACanClose);
end;

procedure TFMXLayoutViewManager.DoPageChange(Sender: TObject);
begin
  if assigned(FOldPageChange) then
    FOldPageChange(Sender);
end;

function TFMXLayoutViewManager.GetActiveTab: TLayoutTabItem;
begin
  result := TLayoutTabItem((FList[ActivePageIndex] as IPageView).This.Tab);
end;

function TFMXLayoutViewManager.GetPageContainerClass: TComponentClass;
begin
  result := TLayout;
end;

function TFMXLayoutViewManager.GetLayoutContainer: TLayout;
begin
  result := FPageContainer as TLayout;
end;

procedure TLayoutTabItem.CanClose(var ACanClose: boolean);
var
  form: TForm;
  ref: TFMXLayoutViewManager;
begin
  ref := TFMXLayoutViewManager(PageView.This.GetOwner);
  if assigned(ref) and assigned(ref.OnQueryClose) then
    TFMXLayoutViewManager(ref).OnQueryClose(PageView, ACanClose);

  if ACanClose then
    if assigned(PageView) then
      if assigned(PageView.This.View) then
      begin
        form := TForm(PageView.This.View.This);
        if assigned(form) then
          if assigned(form.OnCloseQuery) then
            form.OnCloseQuery(self, ACanClose);
        if ACanClose then
          //with PageView.This.View.GetController do
          begin
            TControllerAbstract.RevokeInstance(PageView.This.View.GetController);
          end;
      end;
end;

function TFMXLayoutViewManager.GetPageTabClass: TComponentClass;
begin
  result := TLayoutTabItem;
end;

procedure TFMXLayoutViewManager.Init(APageView: IPageView);
var
  frm: TForm;
  tl: TLayout;
  o: TComponent;
  LLayout: ILayout;
  base: TObject;
  iChild: Integer;
begin
  if assigned(APageView) then
    if assigned(APageView.This.View) then
    begin
      if APageView.This.View.This.InheritsFrom(TViewFactoryAdapter) then
      begin
        frm := TForm(TViewFactoryAdapter(APageView.This.View.This).form);
        APageView.This.Text := frm.Caption;
      end
      else
        frm := TForm(APageView.This.View.This);
      with frm do
      begin
        if supports(frm, ILayout, LLayout) and
          (LLayout.GetLayout.InheritsFrom(TLayout)) then
        begin
          base := LLayout.GetLayout;
          iChild := 0;
          while Layout.ChildrenCount > iChild do
          begin
            if Layout.Children[iChild].InheritsFrom(TLayout) and
              (Layout.Children[iChild] = base) then
              inc(iChild)
            else
              Layout.RemoveObject(iChild);
          end;
          TFormFactory(APageView.This.View.This).isShowModal := false;
          if iChild = 0 then
          begin
            Layout.AddObject(TLayout(LLayout.GetLayout));
            APageView.This.View.init();
          end;
          if assigned(AfterCreateComplete) then
            AfterCreateComplete(APageView.This);
        end
        else
        begin
          while Layout.ChildrenCount > 0 do
            Layout.RemoveObject(0);
          while frm.ChildrenCount > 0 do
            frm.Children[0].Parent :=
              TLayoutTabItem(APageView.This.Tab).FViewer;
          Layout.AddObject(TLayoutTabItem(APageView.This.Tab).FViewer);
          BorderStyle := TFmxFormBorderStyle.None;
          TLayoutTabItem(APageView.This.Tab).Text := APageView.This.Text;
          if APageView.This.View.This.InheritsFrom(TFormFactory) then
          begin
            TFormFactory(APageView.This.View.This).isShowModal := false;
            APageView.This.View.ShowView(nil);
          end
          else if assigned(AfterCreateComplete) then
            AfterCreateComplete(APageView.This);

        end;
      end;
    end;
end;

class function TFMXLayoutViewManager.New(AController: IController): IPageViews;
begin
  result := TFMXLayoutViewManager.create(nil);
  result.Controller(AController);
end;

function TFMXLayoutViewManager.NewTab(APageView: IPageView): TObject;
var
  Tab: TLayoutTabItem;
begin
  Tab := TLayoutTabItem.create(self);
  FList.Add(Tab);
  Tab.LayoutContainer := GetLayoutContainer;
  Tab.Parent := GetLayoutContainer;
  Tab.PageView := APageView;
  ActivePageIndex := FList.Count - 1;
  result := Tab;
  if assigned(FAfterTabCreate) then
    FAfterTabCreate(Tab);
end;

procedure TFMXLayoutViewManager.SetAfterCreate(const Value: TNotifyEvent);
begin
  FAfterCreate := Value;
end;

procedure TFMXLayoutViewManager.SetAfterTabCreate(const Value: TNotifyEvent);
begin
  FAfterTabCreate := Value;
end;

procedure TFMXLayoutViewManager.SetOnQueryClose(const Value
  : TFMXpageViewOnQueryClose);
begin
  FOnQueryClose := Value;
end;

procedure TFMXLayoutViewManager.SetLayoutContainer(const Value: TLayout);
begin
  FPageContainer := Value;
end;

function TFMXLayoutViewManager.Update: IModel;
var
  APageView: IPageView;
begin
  APageView := ActivePage;
  Init(APageView);
end;

{ TLayoutTabItem }

constructor TLayoutTabItem.create(AOwner: TComponent);
begin
  inherited;
  FViewer := TLayout.create(self);
  if assigned(AOwner) and (AOwner.InheritsFrom(TFMXLayoutViewManager)) then
  begin
    LayoutContainer := TFMXLayoutViewManager(AOwner).Layout;
  end;
  FViewer.Parent := LayoutContainer;
  FViewer.Align := TAlignLayout.Client;

end;

destructor TLayoutTabItem.destroy;
var
  LCanClose: boolean;
  item: TObject;
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
  inherited;
end;

end.
