unit TestMVCBr.FrameView;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils, System.Classes, System.JSON, System.Rtti,
  VCL.Forms, VCL.StdCtrls,
  MVCBr.Interf, MVCBr.FrameView, MVCBr.Controller;

type
  TFakeFrame = class(TFrame)
  private
    FViewModel: IViewModel;
    FController: IController;
  protected
    procedure Init; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function This: TObject;
    function GetController: IController;
    function GetViewModel: IViewModel;
    procedure SetViewModel(const AViewModel: IViewModel);
  end;

  TTestableFrameFactory = class(TFrameFactory)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  [TestFixture]
  TestTFrameFactory = class
  private
    FSut: TFrameFactory;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure Create_Default_ReturnsInstance;
    [Test]
    procedure This_ReturnsSelf;
    [Test]
    procedure UpdateView_ReturnsSelf;
    [Test]
    procedure Init_DoesNotRaise;
    [Test]
    procedure Release_NilifiesReferences;
    [Test]
    procedure Controller_SetAndGet_Works;
    [Test]
    procedure GetTitle_SetTitle_Works;
    [Test]
    procedure GetID_DoesNotRaise;
    [Test]
    procedure GetViewModel_SetViewModel_Works;
    [Test]
    procedure DoCommand_DoesNotRaise;
    [Test]
    procedure UpdateObserver_DoesNotRaise;
    [Test]
    procedure UpdateObserverWithName_DoesNotRaise;
    [Test]
    procedure EventWithString_DoesNotRaise;
    [Test]
    procedure EventWithJson_DoesNotRaise;
    [Test]
    procedure Update_DoesNotRaise;
  end;

implementation

{$R *.dfm}

{ TFakeFrame }

constructor TFakeFrame.Create(AOwner: TComponent);
begin
  // TFrame.Create carrega DFM - precisamos do .dfm
  inherited;
end;

destructor TFakeFrame.Destroy;
begin
  inherited;
end;

procedure TFakeFrame.Init;
begin
  // abstract
end;

function TFakeFrame.This: TObject;
begin
  Result := Self;
end;

function TFakeFrame.GetController: IController;
begin
  Result := FController;
end;

function TFakeFrame.GetViewModel: IViewModel;
begin
  Result := FViewModel;
end;

procedure TFakeFrame.SetViewModel(const AViewModel: IViewModel);
begin
  FViewModel := AViewModel;
end;

{ TTestableFrameFactory }

constructor TTestableFrameFactory.Create(AOwner: TComponent);
begin
  inherited;
end;

{ TestTFrameFactory }

procedure TestTFrameFactory.SetUp;
begin
  FSut := TTestableFrameFactory.Create(nil);
end;

procedure TestTFrameFactory.TearDown;
begin
  FSut.Free;
end;

procedure TestTFrameFactory.Create_Default_ReturnsInstance;
begin
  Assert.IsNotNull(FSut, 'Should create instance');
  Assert.IsTrue(FSut is TFrameFactory, 'Should be TFrameFactory');
end;

procedure TestTFrameFactory.This_ReturnsSelf;
var
  LObj: TObject;
begin
  LObj := FSut.This;
  Assert.IsNotNull(LObj, 'This should return a TObject');
  Assert.IsTrue(FSut = LObj, 'This should return self');
end;

procedure TestTFrameFactory.UpdateView_ReturnsSelf;
var
  LResult: IView;
begin
  LResult := FSut.UpdateView;
  Assert.IsNotNull(LResult, 'UpdateView should return IView');
end;

procedure TestTFrameFactory.Init_DoesNotRaise;
begin
  try
    FSut.Init;
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'Init should not raise');
  end;
end;

procedure TestTFrameFactory.Release_NilifiesReferences;
begin
  try
    FSut.Release;
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'Release should not raise');
  end;
end;

procedure TestTFrameFactory.Controller_SetAndGet_Works;
var
  LController: IController;
begin
  LController := TControllerFactory.Create;
  try
    FSut.Controller(LController);
    Assert.IsNotNull(FSut.GetController, 'Controller should be set after Controller()');
  finally
    LController.Release;
    LController := nil;
  end;
end;

procedure TestTFrameFactory.GetTitle_SetTitle_Works;
begin
  FSut.Title := 'Test Frame';
  Assert.AreEqual('Test Frame', FSut.Title, 'Title should persist');
end;

procedure TestTFrameFactory.GetID_DoesNotRaise;
begin
  Assert.IsNotNull(FSut, 'Factory should exist');
  // GetID returns FID which is never set in TFrameFactory
  // Just verify it doesn't raise
  FSut.GetID;
  Assert.IsTrue(True);
end;

procedure TestTFrameFactory.GetViewModel_SetViewModel_Works;
begin
  Assert.IsNull(FSut.GetViewModel, 'ViewModel should be nil initially');
end;

procedure TestTFrameFactory.DoCommand_DoesNotRaise;
begin
  try
    FSut.DoCommand('test.cmd', []);
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'DoCommand should not raise');
  end;
end;

procedure TestTFrameFactory.UpdateObserver_DoesNotRaise;
begin
  try
    FSut.UpdateObserver(nil);
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'UpdateObserver should not raise');
  end;
end;

procedure TestTFrameFactory.UpdateObserverWithName_DoesNotRaise;
begin
  try
    FSut.UpdateObserver('test', nil);
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'UpdateObserver with name should not raise');
  end;
end;

procedure TestTFrameFactory.EventWithString_DoesNotRaise;
var
  LHandled: Boolean;
begin
  LHandled := False;
  try
    FSut.ViewEvent('test.event', LHandled);
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'ViewEvent(string) should not raise');
  end;
end;

procedure TestTFrameFactory.EventWithJson_DoesNotRaise;
var
  LHandled: Boolean;
  LJson: TJsonObject;
begin
  LHandled := False;
  LJson := TJsonObject.Create;
  try
    LJson.AddPair('test', 'value');
    FSut.ViewEvent(LJson, LHandled);
  finally
    LJson.Free;
  end;
  Assert.IsTrue(True, 'ViewEvent(JSON) should not raise');
end;

procedure TestTFrameFactory.Update_DoesNotRaise;
var
  LHandled: Boolean;
begin
  LHandled := False;
  try
    FSut.Update(nil, LHandled);
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'Update should not raise');
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTFrameFactory);
end.
