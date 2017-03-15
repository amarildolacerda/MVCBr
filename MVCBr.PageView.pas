{ //************************************************************// }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //                                                            // }
{ //************************************************************// }
{ // Data: 15/02/2017 23:07:44                                  // }
{ //************************************************************// }
///
/// PageView é adapter para gerar controller para PageViews Abstract
///
unit MVCBr.PageView;

interface

uses {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, System.SysUtils, MVCBr.Interf, MVCBr.Controller,
  MVCBr.Component, MVCBr.FormView;

type
  TPageView = class;
  TCustomPageViewFactory = class;

  IPageView = interface
    ['{FCAA865A-3ED1-46B2-AFCA-627F511B3A2C}']
    function This: TPageView;
    procedure Remove;
  end;

  IPageViews = interface(IModel)
    ['{60605589-283D-4403-B434-D32A024BB049}']
    procedure SetPageContainer(const Value: TComponent);

    function GetPageContainer: TComponent;
    property PageContainer: TComponent read GetPageContainer
      write SetPageContainer;

    function GetItems(idx: Integer): IPageView;
    procedure SetItems(idx: Integer; const Value: IPageView);
    function Count: Integer;

    property Items[idx: Integer]: IPageView read GetItems write SetItems;
    function FindViewByID(Const AID: String): IPageView;
    function AddView(AView: IView): IPageView; overload;
    function AddView(Const AController: TGuid): IPageView; overload;
    function FindView(Const AGuid: TGuid): IPageView; overload;
    function FindView(Const AView: IView): IPageView; overload;
    function IndexOf(Const AGuid: TGuid): Integer;

  end;

  /// TPageControllerView - Atributos para o PageView
  TPageView = class(TMVCFactoryAbstract, IPageView)
  private
    FOwner: TCustomPageViewFactory;
    FText: string;
    FTab: TObject;
    FID: String;
    FView: IView;
    procedure SetText(const Value: string);
    function GetText: string;
    procedure SetTab(const Value: TObject);
    procedure SetID(const Value: String);
    procedure SetView(const Value: IView);
  protected
    FClassType: TClass;
  public
    function GetOwner: TCustomPageViewFactory;
    function This: TPageView;
    property Text: string read GetText write SetText;
    property Tab: TObject read FTab write SetTab;
    property ID: String read FID write SetID;
    property View: IView read FView write SetView;
    procedure Remove; virtual;
  end;

  /// Adaptador para associar a lista de View com o TPageControl ativo
  /// Cada View é mostrado em uma aba do PageControl
  TCustomPageViewFactory = class(TComponentFactory, IModel)
  private
    FActivePageIndex: Integer;
    FAfterViewCreate: TNotifyEvent;
    function GetItems(idx: Integer): IPageView;
    procedure SetItems(idx: Integer; const Value: IPageView);
    procedure SetActivePageIndex(const Value: Integer);
    procedure SetAfterViewCreate(const Value: TNotifyEvent);
  protected
    FPageContainer: TComponent;
    FList: TMVCInterfacedList<IPageView>;
    procedure AfterConstruction; override;
    procedure SetPageContainer(const Value: TComponent); virtual;
    function GetPageContainer: TComponent; virtual;
    /// ligação para o PageControl component
    property PageContainer: TComponent read GetPageContainer
      write SetPageContainer;
    procedure Init(APageView: IPageView); virtual;
    procedure Remove(APageView: IPageView); virtual;
    Procedure DoQueryClose(const APageView: IPageView;
      var ACanClose: Boolean); virtual;
    Procedure DoViewCreate(Sender: TObject); virtual;
    procedure Notification(AComponent: TComponent;
      AOperation: TOperation); override;
  public

    function NewTab(APageView: IPageView): TObject; virtual;
    function GetPageTabClass: TComponentClass; virtual;
    function GetPageContainerClass: TComponentClass; virtual;
    function Count: Integer;
    function ActivePage: IPageView; virtual;
    procedure SetActivePage(Const Tab: TObject); virtual;
    property ActivePageIndex: Integer read FActivePageIndex
      write SetActivePageIndex;

    property Items[idx: Integer]: IPageView read GetItems write SetItems;
    function NewItem(Const ACaption: string): IPageView; virtual;
    function AddView(AView: IView): IPageView; overload; virtual;
    function AddView(Const AController: TGuid): IPageView; overload; virtual;
    function AddForm(AClass: TFormClass): IPageView; virtual;
    function FindViewByID(Const AID: String): IPageView; virtual;
    function FindViewByClassName(const AClassName: String): IPageView; virtual;
    function FindView(Const AGuid: TGuid): IPageView; overload; virtual;
    function FindView(Const AView: IView): IPageView; overload; virtual;
    function IndexOf(Const AGuid: TGuid): Integer;
    property AfterViewCreate: TNotifyEvent read FAfterViewCreate
      write SetAfterViewCreate;
  end;

implementation

{ TPageControllerView }

function TPageView.GetOwner: TCustomPageViewFactory;
begin
  result := FOwner;
end;

function TPageView.GetText: string;
begin
  result := FText;
end;

procedure TPageView.Remove;
begin
  if assigned(FOwner) then
    FOwner.Remove(self);
end;

procedure TPageView.SetID(const Value: String);
begin
  FID := Value;
end;

procedure TPageView.SetTab(const Value: TObject);
begin
  FTab := Value;
end;

procedure TPageView.SetText(const Value: string);
begin
  FText := Value;
end;

procedure TPageView.SetView(const Value: IView);
begin
  FView := Value;
  FID := Value.GetID;
end;

function TPageView.This: TPageView;
begin
  result := self;
end;

{ TPageControlFactory }

function TCustomPageViewFactory.AddView(AView: IView): IPageView;
begin
  result := NewItem(AView.Text);
  result.This.View := AView;
  DoViewCreate(AView.This);
  Init(result);
end;

function TCustomPageViewFactory.ActivePage: IPageView;
begin
  result := FList.Items[FActivePageIndex] as IPageView;
end;

function TCustomPageViewFactory.AddForm(AClass: TFormClass): IPageView;
var
  ref: TForm;
  vw: IView;
begin
  // checa se o formulario ja esta carregao e reutiliza
  result := FindViewByClassName(AClass.ClassName);
  if assigned(result) then
  begin
    SetActivePage(result.This.FTab);
    exit;
  end;
  // instancia novo formulario
  ref := AClass.Create(self);
  if supports(ref, IView, vw) then
  begin
    result := AddView(vw);
    exit;
  end;
  // usa um stub para embeded de uma formulario como (sem IVIEW)
  result := AddView(TViewFactoryAdapter.New(ref, false));
end;

function TCustomPageViewFactory.AddView(const AController: TGuid): IPageView;
var
  LController: IController;
  LView: IView;
begin
  result := nil;
  LController := ResolveController(AController);

  // checa se já existe uma aba para a mesma view
  LView := LController.GetView;
  if not assigned(LView) then
    exit;

  result := FindView(LView);
  if assigned(result) then
    exit;

  // criar nova aba
  result := AddView(LView);

end;

procedure TCustomPageViewFactory.AfterConstruction;
begin
  inherited;
  FList := TMVCInterfacedList<IPageView>.Create;
end;

procedure TCustomPageViewFactory.DoQueryClose(const APageView: IPageView;
  var ACanClose: Boolean);
begin
  ACanClose := true;
end;

procedure TCustomPageViewFactory.DoViewCreate(Sender: TObject);
begin
  if assigned(FAfterViewCreate) then
    FAfterViewCreate(Sender);
end;

function TCustomPageViewFactory.Count: Integer;
begin
  result := FList.Count;
end;

function TCustomPageViewFactory.IndexOf(const AGuid: TGuid): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    if supports(Items[i].This, AGuid) then
    begin
      result := i;
      exit;
    end;
end;

procedure TCustomPageViewFactory.Init(APageView: IPageView);
begin
end;

function TCustomPageViewFactory.FindView(const AGuid: TGuid): IPageView;
var
  i: Integer;
begin
  result := nil;
  i := IndexOf(AGuid);
  if i >= 0 then
    result := Items[i];
end;

function TCustomPageViewFactory.FindView(const AView: IView): IPageView;
var
  i: Integer;
begin
  result := nil;
  for i := 0 to Count - 1 do
    if Items[i].This.FView = AView then
    begin
      result := Items[i];
      exit;
    end;
end;

function TCustomPageViewFactory.FindViewByClassName(const AClassName: String)
  : IPageView;
var
  i: Integer;
  frm: TObject;
begin
  result := nil;
  for i := 0 to Count - 1 do
  begin
    if not assigned(Items[i].This.FView) then
      continue;
    if Items[i].This.View.This.InheritsFrom(TViewFactoryAdapter) then
      frm := TViewFactoryAdapter(Items[i].This.View.This).Form
    else
      frm := Items[i].This.FView.This;
    if sametext(frm.ClassName, AClassName) then
    begin
      result := Items[i];
      exit;
    end;
  end;
end;

function TCustomPageViewFactory.FindViewByID(const AID: String): IPageView;
var
  i: Integer;
begin
  result := nil;
  for i := 0 to FList.Count - 1 do
    if sametext(AID, (FList.Items[i] as IPageView).This.ID) then
    begin
      result := FList.Items[i] as IPageView;
      exit;
    end;
end;

function TCustomPageViewFactory.GetItems(idx: Integer): IPageView;
begin
  result := FList.Items[idx] as IPageView;
end;

function TCustomPageViewFactory.GetPageContainer: TComponent;
begin
  result := FPageContainer;
end;

function TCustomPageViewFactory.GetPageContainerClass: TComponentClass;
begin
  raise Exception.Create('Error: implements in inherited class');
end;

function TCustomPageViewFactory.GetPageTabClass: TComponentClass;
begin
  raise Exception.Create('Error: implements in inherited class');
end;

function TCustomPageViewFactory.NewItem(const ACaption: string): IPageView;
var
  obj: TPageView;
begin
  obj := TPageView.Create;
  FList.Add(obj);
  obj.FOwner := self;
  obj.Text := ACaption;
  obj.Tab := NewTab(obj);
  if obj.Tab <> nil then
    obj.FClassType := obj.Tab.ClassType;
  result := obj;
end;

function TCustomPageViewFactory.NewTab(APageView: IPageView): TObject;
begin
  result := GetPageTabClass.Create(nil);
end;

procedure TCustomPageViewFactory.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited;
  if AOperation = TOperation.opRemove then
    if AComponent = FPageContainer then
      FPageContainer := nil;
end;

procedure TCustomPageViewFactory.Remove(APageView: IPageView);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if APageView.This.ID = (FList.Items[i] as IPageView).This.ID then
    begin
      FList.Delete(i);
      exit;
    end;
end;

procedure TCustomPageViewFactory.SetActivePage(const Tab: TObject);
begin
  // implementar na class herdada;
end;

procedure TCustomPageViewFactory.SetActivePageIndex(const Value: Integer);
begin
  FActivePageIndex := Value;
end;

procedure TCustomPageViewFactory.SetAfterViewCreate(const Value: TNotifyEvent);
begin
  FAfterViewCreate := Value;
end;

procedure TCustomPageViewFactory.SetItems(idx: Integer; const Value: IPageView);
begin
  FList.Items[idx] := Value;
end;

procedure TCustomPageViewFactory.SetPageContainer(const Value: TComponent);
begin
  FPageContainer := Value;
end;

end.
