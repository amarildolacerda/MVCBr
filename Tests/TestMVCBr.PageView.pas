unit TestMVCBr.PageView;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils, System.Classes, System.JSON, System.Rtti,
  VCL.Forms,
  MVCBr.Interf, MVCBr.PageView, MVCBr.Controller, MVCBr.View;

type
  TFakePageViewOwner = class(TCustomPageViewFactory)
  public
    constructor Create(AOwner: TComponent); override;
    function GetPageTabClass: TComponentClass; override;
    function GetPageContainerClass: TComponentClass; override;
  end;

  TFakeView = class(TInterfacedObject, IView)
  private
    FController: IController;
    FID: string;
    FTitle: string;
  public
    constructor Create;
    function This: TObject;
    function ShowView(const AProc: TProc<IView>): integer; overload;
    function ShowView(): IView; overload;
    function UpdateView: IView;
    procedure Update(AJsonValue: TJsonValue; var AHandled: boolean); overload;
    function ViewEvent(AMessage: string; var AHandled: boolean): IView; overload;
    function ViewEvent(AMessage: TJsonValue; var AHandled: boolean): IView; overload;
    function Controller(const AController: IController): IView;
    function GetController: IController;
    procedure SetController(const AController: IController);
    function GetModel(AII: TGuid): IModel;
    function GetViewModel: IViewModel;
    procedure SetViewModel(const AViewModel: IViewModel);
    function GetID: string;
    function GetTitle: String;
    procedure SetTitle(const AText: String);
    procedure DoCommand(ACommand: string; const AArgs: array of TValue);
    function ShowView(const AProcBeforeShow: TProc<IView>; AShowModal: boolean): IView; overload;
    function ShowView(const AProcBeforeShow: TProc<IView>; const AProcOnClose: TProc<IView>): IView; overload;
    procedure UpdateObserver(AJson: TJsonValue); overload;
    procedure UpdateObserver(AName: string; AJson: TJsonValue); overload;
    procedure Init;
    function GetPropertyValue(ANome: string): TValue;
    procedure SetPropertyValue(ANome: string; const Value: TValue);
    function ApplicationControllerInternal: IApplicationController;
    function GetGuid(AII: IInterface): TGuid;
    procedure release;
  end;

  TTestablePageViewFactory = class(TCustomPageViewFactory)
  public
    constructor Create(AOwner: TComponent); override;
    function GetPageTabClass: TComponentClass; override;
    function GetPageContainerClass: TComponentClass; override;
  end;

  [TestFixture]
  TestTPageView = class
  private
    FOwner: TFakePageViewOwner;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure Create_Default_SetsProperties;
    [Test]
    procedure Text_SetAndGet_Works;
    [Test]
    procedure ID_SetAndGet_Works;
    [Test]
    procedure Tab_SetAndGet_Works;
    [Test]
    procedure This_ReturnsSelf;
    [Test]
    procedure GetOwner_ReturnsOwner;
    [Test]
    procedure SetController_Nil_DoesNotRaise;
    [Test]
    procedure Destroy_CallsOnCloseDelegate;
  end;

  [TestFixture]
  TestTCustomPageViewFactory = class
  private
    FSut: TTestablePageViewFactory;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure Create_Default_CountZero;
    [Test]
    procedure NewItem_AddsToCount;
    [Test]
    procedure NewItem_ReturnsTPageView;
    [Test]
    procedure AddView_WithIView_IncreasesCount;
    [Test]
    procedure AddView_WithIView_ReturnsTPageView;
    [Test]
    procedure FindViewByID_ReturnsCorrectItem;
    [Test]
    procedure Remove_ByPageView_DecreasesCount;
    [Test]
    procedure IndexOf_NotFound_ReturnsMinusOne;
    [Test]
    procedure PageViewIndexOf_NotFound_ReturnsMinusOne;
    [Test]
    procedure Lock_Unlock_DoesNotRaise;
  end;

implementation

uses
  MVCBr.ApplicationController;

{ TFakePageViewOwner }

constructor TFakePageViewOwner.Create(AOwner: TComponent);
begin
  inherited;
  FPageContainer := TComponent.Create(nil);
end;

function TFakePageViewOwner.GetPageTabClass: TComponentClass;
begin
  Result := TComponent;
end;

function TFakePageViewOwner.GetPageContainerClass: TComponentClass;
begin
  Result := TComponent;
end;

{ TFakeView }

constructor TFakeView.Create;
begin
  inherited;
  FID := 'FakeView';
  FTitle := 'Fake View Title';
end;

function TFakeView.This: TObject;
begin
  Result := Self;
end;

function TFakeView.ShowView(const AProc: TProc<IView>): integer;
begin
  Result := 0;
end;

function TFakeView.ShowView: IView;
begin
  Result := Self;
end;

function TFakeView.UpdateView: IView;
begin
  Result := Self;
end;

procedure TFakeView.Update(AJsonValue: TJsonValue; var AHandled: boolean);
begin
  AHandled := False;
end;

function TFakeView.ViewEvent(AMessage: string; var AHandled: boolean): IView;
begin
  Result := Self;
end;

function TFakeView.ViewEvent(AMessage: TJsonValue; var AHandled: boolean): IView;
begin
  Result := Self;
end;

function TFakeView.Controller(const AController: IController): IView;
begin
  FController := AController;
  Result := Self;
end;

function TFakeView.GetController: IController;
begin
  Result := FController;
end;

procedure TFakeView.SetController(const AController: IController);
begin
  FController := AController;
end;

function TFakeView.GetModel(AII: TGuid): IModel;
begin
  Result := nil;
end;

function TFakeView.GetViewModel: IViewModel;
begin
  Result := nil;
end;

procedure TFakeView.SetViewModel(const AViewModel: IViewModel);
begin
end;

function TFakeView.GetID: string;
begin
  Result := FID;
end;

function TFakeView.GetTitle: String;
begin
  Result := FTitle;
end;

procedure TFakeView.SetTitle(const AText: String);
begin
  FTitle := AText;
end;

procedure TFakeView.DoCommand(ACommand: string; const AArgs: array of TValue);
begin
end;

function TFakeView.ShowView(const AProcBeforeShow: TProc<IView>;
  AShowModal: boolean): IView;
begin
  Result := Self;
end;

function TFakeView.ShowView(const AProcBeforeShow: TProc<IView>;
  const AProcOnClose: TProc<IView>): IView;
begin
  Result := Self;
end;

procedure TFakeView.UpdateObserver(AJson: TJsonValue);
begin
end;

procedure TFakeView.UpdateObserver(AName: string; AJson: TJsonValue);
begin
end;

procedure TFakeView.Init;
begin
end;

function TFakeView.GetPropertyValue(ANome: string): TValue;
begin
end;

procedure TFakeView.SetPropertyValue(ANome: string; const Value: TValue);
begin
end;

function TFakeView.ApplicationControllerInternal: IApplicationController;
begin
  Result := nil;
end;

function TFakeView.GetGuid(AII: IInterface): TGuid;
begin
  Result := TGUID.Empty;
end;

procedure TFakeView.release;
begin
end;

{ TTestablePageViewFactory }

constructor TTestablePageViewFactory.Create(AOwner: TComponent);
begin
  inherited;
  FPageContainer := TComponent.Create(nil);
end;

function TTestablePageViewFactory.GetPageTabClass: TComponentClass;
begin
  Result := TComponent;
end;

function TTestablePageViewFactory.GetPageContainerClass: TComponentClass;
begin
  Result := TComponent;
end;

{ TestTPageView }

procedure TestTPageView.SetUp;
begin
  FOwner := TFakePageViewOwner.Create(nil);
end;

procedure TestTPageView.TearDown;
begin
  FOwner.Free;
end;

procedure TestTPageView.Create_Default_SetsProperties;
var
  LPageView: TPageView;
begin
  LPageView := FOwner.NewItem('Test Tab');
  Assert.IsNotNull(LPageView, 'NewItem should return TPageView');
  Assert.AreEqual('Test Tab', LPageView.Text, 'Text should be set');
  Assert.IsNotNull(LPageView.This, 'This should not be nil');
end;

procedure TestTPageView.Text_SetAndGet_Works;
var
  LPageView: TPageView;
begin
  LPageView := FOwner.NewItem('');
  LPageView.Text := 'My Text';
  Assert.AreEqual('My Text', LPageView.Text, 'Text should persist');
end;

procedure TestTPageView.ID_SetAndGet_Works;
var
  LPageView: TPageView;
begin
  LPageView := FOwner.NewItem('');
  LPageView.ID := 'MyID';
  Assert.AreEqual('MyID', LPageView.ID, 'ID should persist');
end;

procedure TestTPageView.Tab_SetAndGet_Works;
var
  LPageView: TPageView;
  LTab: TComponent;
begin
  LPageView := FOwner.NewItem('');
  LTab := TComponent.Create(nil);
  try
    LPageView.Tab := LTab;
    Assert.IsNotNull(LPageView.Tab, 'Tab should be set');
  finally
    LTab.Free;
  end;
end;

procedure TestTPageView.This_ReturnsSelf;
var
  LPageView: TPageView;
begin
  LPageView := FOwner.NewItem('');
  Assert.IsTrue(LPageView = LPageView.This, 'This should return self');
end;

procedure TestTPageView.GetOwner_ReturnsOwner;
var
  LPageView: TPageView;
begin
  LPageView := FOwner.NewItem('');
  Assert.IsTrue(FOwner = LPageView.GetOwner, 'GetOwner should return factory');
end;

procedure TestTPageView.SetController_Nil_DoesNotRaise;
var
  LPageView: TPageView;
begin
  LPageView := FOwner.NewItem('');
  LPageView.Controller := nil;
  Assert.IsNull(LPageView.Controller, 'Controller should be nil');
end;

procedure TestTPageView.Destroy_CallsOnCloseDelegate;
var
  LPageView: TPageView;
  LClosed: Boolean;
begin
  LPageView := FOwner.NewItem('');
  LClosed := False;
  LPageView.OnCloseDelegate :=
    procedure(ASender: TObject)
    begin
      LClosed := True;
    end;
  FOwner.Remove(LPageView);
  Assert.IsTrue(LClosed, 'OnCloseDelegate should be called');
end;

{ TestTCustomPageViewFactory }

procedure TestTCustomPageViewFactory.SetUp;
begin
  FSut := TTestablePageViewFactory.Create(nil);
end;

procedure TestTCustomPageViewFactory.TearDown;
begin
  FSut.Free;
end;

procedure TestTCustomPageViewFactory.Create_Default_CountZero;
begin
  Assert.AreEqual(0, FSut.Count, 'Count should start at 0');
end;

procedure TestTCustomPageViewFactory.NewItem_AddsToCount;
var
  LItem: TPageView;
begin
  LItem := FSut.NewItem('Tab 1');
  Assert.AreEqual(1, FSut.Count, 'Count should be 1 after NewItem');
  // Factory owns the item - no manual dispose
end;

procedure TestTCustomPageViewFactory.NewItem_ReturnsTPageView;
var
  LItem: TPageView;
begin
  LItem := FSut.NewItem('Test');
  Assert.IsNotNull(LItem, 'NewItem should return TPageView');
  Assert.IsTrue(LItem.InheritsFrom(TPageView), 'Should be TPageView');
end;

procedure TestTCustomPageViewFactory.AddView_WithIView_IncreasesCount;
var
  LView: IView;
  LItem: TPageView;
begin
  LView := TFakeView.Create;
  LItem := FSut.AddView(LView);
  Assert.IsNotNull(LItem, 'AddView should return TPageView');
  Assert.AreEqual(1, FSut.Count, 'Count should be 1 after AddView');
end;

procedure TestTCustomPageViewFactory.AddView_WithIView_ReturnsTPageView;
var
  LView: IView;
  LItem: TPageView;
begin
  LView := TFakeView.Create;
  LItem := FSut.AddView(LView);
  Assert.IsNotNull(LItem, 'AddView should return TPageView');
  Assert.IsTrue(LItem.InheritsFrom(TPageView), 'Should be TPageView');
end;

procedure TestTCustomPageViewFactory.FindViewByID_ReturnsCorrectItem;
var
  LFound: TPageView;
begin
  FSut.NewItem('Test').ID := 'my-id';
  LFound := FSut.FindViewByID('my-id');
  Assert.IsNotNull(LFound, 'FindViewByID should find item');
  Assert.AreEqual('my-id', LFound.ID, 'Should find the correct item');
end;

procedure TestTCustomPageViewFactory.Remove_ByPageView_DecreasesCount;
begin
  FSut.NewItem('Test');
  Assert.AreEqual(1, FSut.Count, 'Count should be 1 after NewItem');
  // Remove first item in the list
  if FSut.Count > 0 then
    FSut.Remove(FSut.Items[0]);
  Assert.AreEqual(0, FSut.Count, 'Count should be 0 after Remove');
end;

procedure TestTCustomPageViewFactory.IndexOf_NotFound_ReturnsMinusOne;
begin
  Assert.AreEqual(-1, FSut.IndexOf(TGuid.NewGuid), 'IndexOf should return -1 for unknown GUID');
end;

procedure TestTCustomPageViewFactory.PageViewIndexOf_NotFound_ReturnsMinusOne;
begin
  // No items added yet, so any search should return -1
  Assert.AreEqual(-1, FSut.PageViewIndexOf(nil), 'PageViewIndexOf should return -1 for nil');
end;

procedure TestTCustomPageViewFactory.Lock_Unlock_DoesNotRaise;
begin
  try
    FSut.Lock;
    FSut.UnLock;
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'Lock/Unlock should not raise');
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTPageView);
  TDUnitX.RegisterTestFixture(TestTCustomPageViewFactory);
end.
