unit TestMVCBr.NavigateModel;

interface

uses
  DUnitX.TestFramework, System.SysUtils, System.Classes,
  MVCBr.Interf, MVCBr.NavigateModel, MVCBr.Controller;

type
  [TestFixture]
  TestTNavigateModelFactory = class
  private
    FSut: INavigatorModel;
    FObj: TNavigateModelFactory;
    FController: IController;
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
    procedure Controller_Set_ReturnsINavigatorModel;
    [Test]
    procedure Update_ReturnsIModel;
    [Test]
    procedure Release_DoesNotRaise;
  end;

implementation

{ TestTNavigateModelFactory }

procedure TestTNavigateModelFactory.SetUp;
begin
  FObj := TNavigateModelFactory.Create;
  FSut := FObj;
  FController := TControllerFactory.Create;
end;

procedure TestTNavigateModelFactory.TearDown;
begin
  FController := nil;
  FSut := nil;
  FObj := nil;
end;

procedure TestTNavigateModelFactory.Create_Default_ReturnsInstance;
begin
  Assert.IsNotNull(FObj, 'Should create instance');
  Assert.IsTrue(FObj is TNavigateModelFactory, 'Should be TNavigateModelFactory');
end;

procedure TestTNavigateModelFactory.This_ReturnsSelf;
var
  LObj: TObject;
begin
  LObj := FObj.This;
  Assert.IsNotNull(LObj, 'This should return a TObject');
  Assert.IsTrue(FObj = LObj, 'This should return self');
end;

procedure TestTNavigateModelFactory.GetID_ReturnsNonEmpty;
begin
  Assert.IsNotEmpty(FObj.GetID, 'GetID should not be empty after Create');
end;

procedure TestTNavigateModelFactory.Controller_Set_ReturnsINavigatorModel;
var
  LResult: INavigatorModel;
begin
  LResult := FSut.Controller(FController);
  Assert.IsNotNull(LResult, 'Controller should return INavigatorModel');
end;

procedure TestTNavigateModelFactory.Update_ReturnsIModel;
var
  LResult: IModel;
begin
  LResult := FObj.Update;
  Assert.IsNotNull(LResult, 'Update should return IModel');
end;

procedure TestTNavigateModelFactory.Release_DoesNotRaise;
begin
  try
    FObj.Release;
    Assert.IsTrue(True, 'Release should not raise');
  except
    Assert.IsTrue(False, 'Release should not raise');
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTNavigateModelFactory);
end.
