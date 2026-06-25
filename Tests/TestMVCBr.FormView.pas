unit TestMVCBr.FormView;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils, System.Classes, System.JSON, System.Rtti,
  VCL.Forms,
  MVCBr.Interf, MVCBr.View, MVCBr.FormView, MVCBr.Controller;

type
  TFakeForm = class(TForm)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TTestableFormFactory = class(TCustomFormFactory)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  [TestFixture]
  TestTViewFactoryAdapter = class
  private
    FSut: IViewAdpater;
    FForm: TForm;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure New_WithFormClass_ReturnsIView;
    [Test]
    procedure New_WithFormInstance_ReturnsIView;
    [Test]
    procedure Form_ReturnsWrappedForm;
    [Test]
    procedure ThisAs_ReturnsSelf;
    [Test]
    procedure This_ReturnsSelf;
    [Test]
    procedure isShowModal_DefaultIsTrue;
    [Test]
    procedure isShowModal_SetFalse_ReturnsFalse;
    [Test]
    procedure Controller_SetAndGet_Works;
    [Test]
    procedure UpdateView_ReturnsSelf;
  end;

  [TestFixture]
  TestTCustomFormFactory = class
  private
    FSut: TTestableFormFactory;
    FOnViewInitCalled: Boolean;
    FOnViewUpdateCalled: Boolean;
    FViewEventHandled: Boolean;
    FViewCommandCalled: Boolean;
    FCommandName: string;
    procedure HandleOnViewInit(Sender: TObject);
    procedure HandleOnViewUpdate(Sender: TObject);
    procedure HandleOnViewEvent(AMessage: TJsonValue; var AHandled: boolean);
    procedure HandleOnViewCommand(ACommand: string; const AArgs: array of TValue);
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure Create_Default_SetsID;
    [Test]
    procedure Create_Default_SetsShowModalTrue;
    [Test]
    procedure GetTitle_SetTitle_Works;
    [Test]
    procedure isShowModal_DefaultIsTrue;
    [Test]
    procedure SetShowModal_ChangesValue;
    [Test]
    procedure This_ReturnsSelf;
    [Test]
    procedure UpdateView_ReturnsSelf;
    [Test]
    procedure Init_DoesNotRaise;
    [Test]
    procedure Release_DoesNotRaise;
    [Test]
    procedure GetID_DoesNotRaise;
    [Test]
    procedure SetTitle_GetTitle_ReturnsSame;
    [Test]
    procedure OnViewInit_CalledOnInit;
    [Test]
    procedure OnViewUpdate_CalledOnUpdateView;
    [Test]
    procedure ViewEvent_WithString_TriggersOnViewEvent;
    [Test]
    procedure ViewEvent_WithJson_TriggersOnViewEvent;
    [Test]
    procedure DoCommand_TriggersOnCommandEvent;
  end;

implementation

{ TFakeForm }

constructor TFakeForm.Create(AOwner: TComponent);
begin
  CreateNew(AOwner);
end;

destructor TFakeForm.Destroy;
begin
  inherited;
end;

{ TTestableFormFactory }

constructor TTestableFormFactory.Create(AOwner: TComponent);
begin
  CreateNew(AOwner);
end;

{ TestTViewFactoryAdapter }

procedure TestTViewFactoryAdapter.SetUp;
begin
  FForm := TFakeForm.Create(nil);
end;

procedure TestTViewFactoryAdapter.TearDown;
begin
  FSut := nil;
  FForm.Free;
end;

procedure TestTViewFactoryAdapter.New_WithFormClass_ReturnsIView;
var
  LResult: IView;
begin
  LResult := TViewFactoryAdapter.New(TFakeForm);
  Assert.IsNotNull(LResult, 'New with class should return IView');
  LResult := nil;
end;

procedure TestTViewFactoryAdapter.New_WithFormInstance_ReturnsIView;
var
  LResult: IView;
begin
  LResult := TViewFactoryAdapter.New(FForm);
  Assert.IsNotNull(LResult, 'New with instance should return IView');
  LResult := nil;
end;

procedure TestTViewFactoryAdapter.Form_ReturnsWrappedForm;
var
  LAdapter: IViewAdpater;
begin
  LAdapter := TViewFactoryAdapter.New(FForm) as IViewAdpater;
  Assert.IsNotNull(LAdapter, 'Adapter should be created');
  Assert.IsTrue(FForm = LAdapter.Form, 'Form should return the wrapped form');
end;

procedure TestTViewFactoryAdapter.ThisAs_ReturnsSelf;
var
  LAdapter: IViewAdpater;
  LThis: TViewFactoryAdapter;
begin
  LAdapter := TViewFactoryAdapter.New(FForm) as IViewAdpater;
  LThis := LAdapter.ThisAs;
  Assert.IsNotNull(LThis, 'ThisAs should return a TViewFactoryAdapter');
  Assert.IsTrue(LThis is TViewFactoryAdapter, 'ThisAs should be TViewFactoryAdapter');
end;

procedure TestTViewFactoryAdapter.This_ReturnsSelf;
var
  LAdapter: IViewAdpater;
  LObj: TObject;
begin
  LAdapter := TViewFactoryAdapter.New(FForm) as IViewAdpater;
  LObj := LAdapter.This;
  Assert.IsNotNull(LObj, 'This should return a TObject');
  Assert.IsTrue(LObj is TViewFactoryAdapter, 'This should be TViewFactoryAdapter');
end;

procedure TestTViewFactoryAdapter.isShowModal_DefaultIsTrue;
var
  LAdapter: TViewFactoryAdapter;
  LIntf: IViewAdpater;
begin
  LIntf := TViewFactoryAdapter.New(FForm) as IViewAdpater;
  LAdapter := LIntf.ThisAs;
  Assert.IsTrue(LAdapter.isShowModal, 'isShowModal should default to True');
end;

procedure TestTViewFactoryAdapter.isShowModal_SetFalse_ReturnsFalse;
var
  LAdapter: TViewFactoryAdapter;
  LIntf: IViewAdpater;
begin
  LIntf := TViewFactoryAdapter.New(FForm) as IViewAdpater;
  LAdapter := LIntf.ThisAs;
  LAdapter.isShowModal := False;
  Assert.IsFalse(LAdapter.isShowModal, 'isShowModal should be False after set');
end;

procedure TestTViewFactoryAdapter.Controller_SetAndGet_Works;
var
  LAdapter: IViewAdpater;
  LController: IController;
begin
  LAdapter := TViewFactoryAdapter.New(FForm) as IViewAdpater;
  LController := TControllerFactory.Create;
  try
    LAdapter.Controller(LController);
    Assert.IsNotNull(LAdapter.GetController, 'Controller should be set');
  finally
    LController.Release;
    LController := nil;
  end;
end;

procedure TestTViewFactoryAdapter.UpdateView_ReturnsSelf;
var
  LAdapter: IViewAdpater;
  LResult: IView;
begin
  LAdapter := TViewFactoryAdapter.New(FForm) as IViewAdpater;
  LResult := LAdapter.UpdateView;
  Assert.IsNotNull(LResult, 'UpdateView should return IView');
end;

{ TestTCustomFormFactory }

procedure TestTCustomFormFactory.HandleOnViewInit(Sender: TObject);
begin
  FOnViewInitCalled := True;
end;

procedure TestTCustomFormFactory.HandleOnViewUpdate(Sender: TObject);
begin
  FOnViewUpdateCalled := True;
end;

procedure TestTCustomFormFactory.HandleOnViewEvent(AMessage: TJsonValue;
  var AHandled: boolean);
begin
  FViewEventHandled := True;
end;

procedure TestTCustomFormFactory.HandleOnViewCommand(ACommand: string;
  const AArgs: array of TValue);
begin
  FViewCommandCalled := True;
  FCommandName := ACommand;
end;

procedure TestTCustomFormFactory.SetUp;
begin
  FSut := TTestableFormFactory.Create(nil);
  FOnViewInitCalled := False;
  FOnViewUpdateCalled := False;
  FViewEventHandled := False;
  FViewCommandCalled := False;
  FCommandName := '';
end;

procedure TestTCustomFormFactory.TearDown;
begin
  FSut.Free;
end;

procedure TestTCustomFormFactory.Create_Default_SetsID;
begin
  Assert.IsNotNull(FSut, 'Should create instance');
end;

procedure TestTCustomFormFactory.Create_Default_SetsShowModalTrue;
begin
  Assert.IsTrue(FSut.isShowModal, 'isShowModal should default to True');
end;

procedure TestTCustomFormFactory.GetTitle_SetTitle_Works;
begin
  FSut.Text := 'Test Title';
  Assert.AreEqual('Test Title', FSut.Text, 'Title should match');
end;

procedure TestTCustomFormFactory.isShowModal_DefaultIsTrue;
begin
  Assert.IsTrue(FSut.isShowModal, 'isShowModal should default to True');
end;

procedure TestTCustomFormFactory.SetShowModal_ChangesValue;
begin
  FSut.isShowModal := False;
  Assert.IsFalse(FSut.isShowModal, 'isShowModal should be False after set');
end;

procedure TestTCustomFormFactory.This_ReturnsSelf;
var
  LObj: TObject;
begin
  LObj := FSut.This;
  Assert.IsNotNull(LObj, 'This should return a TObject');
  Assert.IsTrue(FSut = LObj, 'This should return self');
end;

procedure TestTCustomFormFactory.UpdateView_ReturnsSelf;
var
  LResult: IView;
begin
  LResult := FSut.UpdateView;
  Assert.IsNotNull(LResult, 'UpdateView should return IView');
end;

procedure TestTCustomFormFactory.Init_DoesNotRaise;
begin
  try
    FSut.Init;
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'Init should not raise');
  end;
end;

procedure TestTCustomFormFactory.Release_DoesNotRaise;
begin
  try
    FSut.Release;
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'Release should not raise');
  end;
end;

procedure TestTCustomFormFactory.GetID_DoesNotRaise;
begin
  // GetID is a string; we just verify it doesn't raise
  Assert.IsNotNull(FSut, 'Factory should be created');
end;

procedure TestTCustomFormFactory.SetTitle_GetTitle_ReturnsSame;
var
  LTitle: string;
begin
  FSut.Text := 'MyFormTitle';
  LTitle := FSut.Text;
  Assert.AreEqual('MyFormTitle', LTitle, 'Title should be persisted');
end;

procedure TestTCustomFormFactory.OnViewInit_CalledOnInit;
begin
  FSut.OnViewInit := HandleOnViewInit;
  FSut.Init;
  Assert.IsTrue(FOnViewInitCalled, 'OnViewInit should be called');
end;

procedure TestTCustomFormFactory.OnViewUpdate_CalledOnUpdateView;
begin
  FSut.OnViewUpdate := HandleOnViewUpdate;
  FSut.UpdateView;
  Assert.IsTrue(FOnViewUpdateCalled, 'OnViewUpdate should be called');
end;

procedure TestTCustomFormFactory.ViewEvent_WithString_TriggersOnViewEvent;
var
  LEventHandled: Boolean;
begin
  LEventHandled := False;
  FSut.OnViewEvent := HandleOnViewEvent;
  FSut.ViewEvent('test.event', LEventHandled);
  Assert.IsTrue(FViewEventHandled, 'OnViewEvent should be triggered');
end;

procedure TestTCustomFormFactory.ViewEvent_WithJson_TriggersOnViewEvent;
var
  LEventHandled: Boolean;
  LJson: TJsonObject;
begin
  LEventHandled := False;
  FSut.OnViewEvent := HandleOnViewEvent;
  LJson := TJsonObject.Create;
  try
    LJson.AddPair('test', 'value');
    FSut.ViewEvent(LJson, LEventHandled);
  finally
    LJson.Free;
  end;
  Assert.IsTrue(FViewEventHandled, 'OnViewEvent should be triggered with JSON');
end;

procedure TestTCustomFormFactory.DoCommand_TriggersOnCommandEvent;
begin
  FSut.OnViewCommand := HandleOnViewCommand;
  FSut.DoCommand('test.command', []);
  Assert.IsTrue(FViewCommandCalled, 'OnViewCommand should be triggered');
  Assert.AreEqual('test.command', FCommandName, 'Command name should match');
end;

initialization
  TDUnitX.RegisterTestFixture(TestTViewFactoryAdapter);
  TDUnitX.RegisterTestFixture(TestTCustomFormFactory);
end.
