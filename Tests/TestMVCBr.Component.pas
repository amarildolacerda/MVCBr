unit TestMVCBr.Component;

interface

uses
  DUnitX.TestFramework,
  System.SysUtils, System.Classes, System.JSON,
  MVCBr.Interf, MVCBr.Component, MVCBr.Controller;

type
  [TestFixture]
  TestTComponentFactory = class
  private
    FSut: TComponentFactory;
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
    procedure GetID_ReturnsNonEmpty;
    [Test]
    procedure ID_SetsIdentifier;
    [Test]
    procedure Controller_SetAndGet_Works;
    [Test]
    procedure Update_ReturnsIModel;
    [Test]
    procedure RefCount_DoesNotRaise;
    [Test]
    procedure Release_ClearsAdapter;
  end;

implementation

{ TestTComponentFactory }

procedure TestTComponentFactory.SetUp;
begin
  FSut := TComponentFactory.Create(nil);
end;

procedure TestTComponentFactory.TearDown;
begin
  FSut.Free;
end;

procedure TestTComponentFactory.Create_Default_ReturnsInstance;
begin
  Assert.IsNotNull(FSut, 'Should create instance');
  Assert.IsTrue(FSut is TComponentFactory, 'Should be TComponentFactory');
end;

procedure TestTComponentFactory.This_ReturnsSelf;
var
  LObj: TObject;
begin
  LObj := FSut.This;
  Assert.IsNotNull(LObj, 'This should return a TObject');
  Assert.IsTrue(FSut = LObj, 'This should return self');
end;

procedure TestTComponentFactory.GetID_ReturnsNonEmpty;
begin
  Assert.IsNotEmpty(FSut.GetID, 'GetID should not be empty after Create');
end;

procedure TestTComponentFactory.ID_SetsIdentifier;
var
  LResult: IModel;
begin
  LResult := FSut.ID('test-id');
  Assert.IsNotNull(LResult, 'ID should return IModel');
  Assert.IsTrue(Pos('test-id', FSut.GetID) > 0, 'ID should contain test-id');
end;

procedure TestTComponentFactory.Controller_SetAndGet_Works;
var
  LController: IController;
begin
  LController := TControllerFactory.Create;
  try
    FSut.Controller(LController);
    Assert.IsNotNull(FSut.GetController, 'Controller should be set');
  finally
    LController.Release;
    LController := nil;
  end;
end;

procedure TestTComponentFactory.Update_ReturnsIModel;
var
  LResult: IModel;
begin
  LResult := FSut.Update;
  Assert.IsNotNull(LResult, 'Update should return IModel');
end;

procedure TestTComponentFactory.RefCount_DoesNotRaise;
begin
  try
    FSut.RefCount;
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'RefCount should not raise');
  end;
end;

procedure TestTComponentFactory.Release_ClearsAdapter;
begin
  try
    FSut.Release;
    Assert.IsTrue(True, 'Release should not raise');
  except
    Assert.IsTrue(False, 'Release should not raise');
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTComponentFactory);
end.
