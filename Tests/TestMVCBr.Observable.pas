unit TestMVCBr.Observable;

interface

uses
  DUnitX.TestFramework, System.SysUtils, System.Classes,
  System.JSON,
  MVCBr.Interf, MVCBr.Observable;

type
  TFakeObserver = class(TInterfacedObject, IMVCBrObserver)
  private
    FLastJson: TJsonValue;
    FHandled: Boolean;
    FUpdateCount: Integer;
  public
    procedure Update(AJsonValue: TJsonValue; var AHandled: boolean);
    property LastJson: TJsonValue read FLastJson;
    property Handled: Boolean read FHandled write FHandled;
    property UpdateCount: Integer read FUpdateCount;
  end;

  [TestFixture]
  TestTMVCBrObserverItem = class
  private
    FItem: TMVCBrObserverItem;
    FObserver: IMVCBrObserver;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure Create_Default_HasEmptyTopic;
    [Test]
    procedure Topic_SetAndGet_ReturnsValue;
    [Test]
    procedure Observer_SetAndGet_ReturnsObserver;
    [Test]
    procedure SubscribeProc_SetAndGet_DoesNotRaise;
    [Test]
    procedure Send_WithObserver_CallsObserverUpdate;
    [Test]
    procedure Send_WithSubscribeProc_DoesNotRaise;
    [Test]
    procedure Release_ClearsObserver;
  end;

  [TestFixture]
  TestTMVCBrObservable = class
  private
    FObservable: TMVCBrObservable;
    FFakeObs1: TFakeObserver;
    FFakeObs2: TFakeObserver;
    FObsIntf1: IMVCBrObserver;
    FObsIntf2: IMVCBrObserver;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure Create_Default_HasZeroCount;
    [Test]
    procedure Register_ObserverByName_IncrementsCount;
    [Test]
    procedure Register_WithProc_IncrementsCount;
    [Test]
    procedure Subscribe_WithProc_IncrementsCount;
    [Test]
    procedure UnSubscribe_ByProc_RemovesItem;
    [Test]
    procedure Clear_RemovesAll;
    [Test]
    procedure This_ReturnsSelf;
    [Test]
    procedure DefaultContainer_ReturnsSingleton;
    [Test]
    procedure Notify_ByName_DoesNotRaise;
    [Test]
    procedure Info_DoesNotRaise;
    [Test]
    procedure Count_AfterMultipleRegisters_ReturnsCorrect;
  end;

implementation

{ TFakeObserver }

procedure TFakeObserver.Update(AJsonValue: TJsonValue; var AHandled: boolean);
begin
  FLastJson := AJsonValue;
  FUpdateCount := FUpdateCount + 1;
  AHandled := FHandled;
end;

{ TestTMVCBrObserverItem }

procedure TestTMVCBrObserverItem.SetUp;
begin
  FItem := TMVCBrObserverItem.Create;
end;

procedure TestTMVCBrObserverItem.TearDown;
begin
  FObserver := nil;
  FItem.Free;
end;

procedure TestTMVCBrObserverItem.Create_Default_HasEmptyTopic;
begin
  Assert.IsNotNull(FItem, 'Item should be created');
  Assert.IsTrue(FItem.GetTopic = '', 'Default topic should be empty');
end;

procedure TestTMVCBrObserverItem.Topic_SetAndGet_ReturnsValue;
begin
  FItem.SetTopic('test.topic');
  Assert.IsTrue(FItem.GetTopic = 'test.topic',
    'Topic should return set value');
end;

procedure TestTMVCBrObserverItem.Observer_SetAndGet_ReturnsObserver;
begin
  FObserver := TFakeObserver.Create;
  FItem.SetObserver(FObserver);
  Assert.IsNotNull(FItem.GetObserver, 'Observer should be assigned');
end;

procedure TestTMVCBrObserverItem.SubscribeProc_SetAndGet_DoesNotRaise;
var
  LProc: TMVCBrObserverProc;
begin
  LProc := procedure(AJson: TJsonValue)
    begin
    end;
  try
    FItem.SetSubscribeProc(LProc);
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'Setting SubscribeProc should not raise');
  end;
end;

procedure TestTMVCBrObserverItem.Send_WithObserver_CallsObserverUpdate;
var
  LJson: TJsonObject;
  LHandled: Boolean;
  LObserver: TFakeObserver;
begin
  LObserver := TFakeObserver.Create;
  FObserver := LObserver;
  FItem.SetObserver(FObserver);
  LJson := TJsonObject.Create;
  LHandled := False;
  FItem.Send(LJson, LHandled);
  Assert.IsTrue(LObserver.UpdateCount > 0,
    'Observer.Update should be called');
end;

procedure TestTMVCBrObserverItem.Send_WithSubscribeProc_DoesNotRaise;
var
  LProc: TMVCBrObserverProc;
  LJson: TJsonObject;
  LHandled: Boolean;
begin
  LProc := procedure(AJson: TJsonValue)
    begin
    end;
  FItem.SetSubscribeProc(LProc);
  LJson := TJsonObject.Create;
  LHandled := False;
  try
    FItem.Send(LJson, LHandled);
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'Send should not raise');
  end;
end;

procedure TestTMVCBrObserverItem.Release_ClearsObserver;
begin
  FObserver := TFakeObserver.Create;
  FItem.SetObserver(FObserver);
  FItem.release;
  Assert.IsNull(FItem.GetObserver, 'Observer should be nil after release');
end;

{ TestTMVCBrObservable }

procedure TestTMVCBrObservable.SetUp;
begin
  FObservable := TMVCBrObservable.Create;
end;

procedure TestTMVCBrObservable.TearDown;
begin
  FObsIntf1 := nil;
  FObsIntf2 := nil;
  FFakeObs1 := nil;
  FFakeObs2 := nil;
  FObservable.Free;
end;

procedure TestTMVCBrObservable.Create_Default_HasZeroCount;
begin
  Assert.IsNotNull(FObservable, 'Observable should be created');
  Assert.IsTrue(FObservable.Count = 0, 'Initial count should be 0');
end;

procedure TestTMVCBrObservable.Register_ObserverByName_IncrementsCount;
begin
  FObsIntf1 := TFakeObserver.Create;
  FObservable.Register('test', FObsIntf1);
  Assert.IsTrue(FObservable.Count = 1, 'Count should be 1 after register');
end;

procedure TestTMVCBrObservable.Register_WithProc_IncrementsCount;
var
  LProc: TMVCBrObserverProc;
begin
  LProc := procedure(AJson: TJsonValue)
    begin
    end;
  FObservable.Register('test', LProc);
  Assert.IsTrue(FObservable.Count = 1, 'Count should be 1 after register');
end;

procedure TestTMVCBrObservable.Subscribe_WithProc_IncrementsCount;
var
  LProc: TMVCBrObserverProc;
begin
  LProc := procedure(AJson: TJsonValue)
    begin
    end;
  FObservable.Subscribe(LProc);
  Assert.IsTrue(FObservable.Count = 1, 'Count should be 1 after subscribe');
end;

procedure TestTMVCBrObservable.UnSubscribe_ByProc_RemovesItem;
var
  LProc: TMVCBrObserverProc;
begin
  LProc := procedure(AJson: TJsonValue)
    begin
    end;
  FObservable.Subscribe(LProc);
  FObservable.UnSubscribe(LProc);
  Assert.IsTrue(FObservable.Count = 0, 'Count should be 0 after unsubscribe');
end;

procedure TestTMVCBrObservable.Clear_RemovesAll;
begin
  FObsIntf1 := TFakeObserver.Create;
  FObsIntf2 := TFakeObserver.Create;
  FObservable.Register('a', FObsIntf1);
  FObservable.Register('b', FObsIntf2);
  FObservable.Clear;
  Assert.IsTrue(FObservable.Count = 0, 'Count should be 0 after clear');
end;

procedure TestTMVCBrObservable.This_ReturnsSelf;
begin
  Assert.IsNotNull(FObservable.This, 'This should return a TObject');
  Assert.IsTrue(FObservable.This = FObservable,
    'This should return self');
end;

procedure TestTMVCBrObservable.DefaultContainer_ReturnsSingleton;
var
  LContainer1, LContainer2: TMVCBrObservable;
begin
  LContainer1 := TMVCBrObservable.DefaultContainer;
  LContainer2 := TMVCBrObservable.DefaultContainer;
  Assert.AreSame(LContainer1, LContainer2,
    'DefaultContainer should return the same instance');
end;

procedure TestTMVCBrObservable.Notify_ByName_DoesNotRaise;
begin
  try
    TMVCBrObservable.Notify('test.topic', 'test message');
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'Notify should not raise');
  end;
end;

procedure TestTMVCBrObservable.Info_DoesNotRaise;
begin
  try
    TMVCBrObservable.Info('info message');
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'Info should not raise');
  end;
end;

procedure TestTMVCBrObservable.Count_AfterMultipleRegisters_ReturnsCorrect;
begin
  FObsIntf1 := TFakeObserver.Create;
  FObsIntf2 := TFakeObserver.Create;
  FObservable.Register('a', FObsIntf1);
  FObservable.Register('b', FObsIntf2);
  Assert.IsTrue(FObservable.Count = 2, 'Count should be 2');
  FObservable.Unregister('a', FObsIntf1);
  Assert.IsTrue(FObservable.Count = 1, 'Count should be 1 after unregister');
end;

initialization
  TDUnitX.RegisterTestFixture(TestTMVCBrObserverItem);
  TDUnitX.RegisterTestFixture(TestTMVCBrObservable);

end.
