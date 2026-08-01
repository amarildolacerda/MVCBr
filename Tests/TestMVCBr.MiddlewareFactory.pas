unit TestMVCBr.MiddlewareFactory;

interface

uses
  DUnitX.TestFramework, System.SysUtils, System.Classes,
  MVCBr.Patterns.Mediator, MVCBr.MiddlewareFactory;

type
  [TestFixture]
  TestTMVCBrMiddlewareFactory = class
  private
    FMiddleware: TMVCBrMiddleware;
    FBeforeCalled: boolean;
    FAfterCalled: boolean;
    FSender: TObject;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure Default_ReturnsSingleton;
    [Test]
    procedure Add_ReturnsNonEmptyID;
    [Test]
    procedure SendBeforeEvent_CallsOnBeforeEvent;
    [Test]
    procedure SendAfterEvent_CallsOnAfterEvent;
    [Test]
    procedure SendBeforeEvent_FiltersByType;
  end;

implementation

{ TestTMVCBrMiddlewareFactory }

procedure TestTMVCBrMiddlewareFactory.SetUp;
begin
  FMiddleware := TMVCBrMiddleware.Create;
  FBeforeCalled := false;
  FAfterCalled := false;
  FSender := TObject.Create;
  FMiddleware.OnBeforeEvent :=
    procedure(ASender: TObject)
    begin
      FBeforeCalled := true;
    end;
  FMiddleware.onAfterEvent :=
    procedure(ASender: TObject)
    begin
      FAfterCalled := true;
    end;
end;

procedure TestTMVCBrMiddlewareFactory.TearDown;
begin
  FSender.Free;
  FMiddleware.Free;
end;

procedure TestTMVCBrMiddlewareFactory.Default_ReturnsSingleton;
var
  LFirst, LSecond: TMVCBrMediator<TMVCBrMiddleware>;
begin
  LFirst := TMVCBrMiddlewareFactory.Default;
  LSecond := TMVCBrMiddlewareFactory.Default;
  Assert.AreSame(LFirst, LSecond,
    'Default should return the same instance');
end;

procedure TestTMVCBrMiddlewareFactory.Add_ReturnsNonEmptyID;
var
  LID: string;
begin
  LID := TMVCBrMiddlewareFactory.Add(FMiddleware);
  Assert.IsNotEmpty(LID, 'Add should return a non-empty ID');
end;

procedure TestTMVCBrMiddlewareFactory.SendBeforeEvent_CallsOnBeforeEvent;
begin
  FMiddleware.MiddType := middView;
  TMVCBrMiddlewareFactory.Add(FMiddleware);
  TMVCBrMiddlewareFactory.SendBeforeEvent(middView, FSender);
  Assert.IsTrue(FBeforeCalled, 'OnBeforeEvent should have been called');
end;

procedure TestTMVCBrMiddlewareFactory.SendAfterEvent_CallsOnAfterEvent;
begin
  FMiddleware.MiddType := middView;
  TMVCBrMiddlewareFactory.Add(FMiddleware);
  TMVCBrMiddlewareFactory.SendAfterEvent(middView, FSender);
  Assert.IsTrue(FAfterCalled, 'OnAfterEvent should have been called');
end;

procedure TestTMVCBrMiddlewareFactory.SendBeforeEvent_FiltersByType;
begin
  FMiddleware.MiddType := middController;
  TMVCBrMiddlewareFactory.Add(FMiddleware);
  TMVCBrMiddlewareFactory.SendBeforeEvent(middView, FSender);
  Assert.IsFalse(FBeforeCalled,
    'OnBeforeEvent should NOT be called for different type');
end;

initialization
  TDUnitX.RegisterTestFixture(TestTMVCBrMiddlewareFactory);
end.
