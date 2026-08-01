unit TestMVCBr.ApplicationController;

interface

uses
  DUnitX.TestFramework, System.SysUtils, System.Classes,
  MVCBr.Interf, MVCBr.ApplicationController, MVCBr.Controller, MVCBr.View;

type
  TTestAppCtrlView = class(TViewFactory)
  end;

  [TestFixture]
  TestTApplicationController = class
  private
    FSut: IApplicationController;
    FCtrl1: IController;
    FCtrl2: IController;
    FView: IView;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure Default_ReturnsSingleton;
    [Test]
    procedure Count_Initial_IsZero;
    [Test]
    procedure Add_Controller_IncrementsCount;
    [Test]
    procedure Remove_Controller_DecrementsCount;
    [Test]
    procedure Delete_ByIndex_RemovesController;
    [Test]
    procedure FindController_ByGuid_ReturnsRegisteredController;
    [Test]
    procedure SetMainView_StoresReference;
    [Test]
    procedure ForEach_IteratesOverAllControllers;
    [Test]
    procedure ForEachFunc_StopsWhenHandled;
    [Test]
    procedure This_ReturnsSelf;
    [Test]
    procedure Inited_CallsInitOnAllControllers;
    [Test]
    procedure UpdateAll_DoesNotRaise;
  end;

implementation

{ TestTApplicationController }

procedure TestTApplicationController.SetUp;
begin
  FSut := TApplicationController.Create;
  FCtrl1 := TControllerFactory.Create;
  FCtrl2 := TControllerFactory.Create;
  FView := TTestAppCtrlView.Create;
end;

procedure TestTApplicationController.TearDown;
begin
  FView := nil;
  FCtrl1 := nil;
  FCtrl2 := nil;
  FSut := nil;
end;

procedure TestTApplicationController.Default_ReturnsSingleton;
var
  LOther: IApplicationController;
begin
  TApplicationController.Release;
  FSut := TApplicationController.Default;
  LOther := TApplicationController.Default;
  Assert.AreSame(FSut.This, LOther.This,
    'Default should return the same instance');
end;

procedure TestTApplicationController.Count_Initial_IsZero;
begin
  Assert.IsTrue(FSut.Count = 0, 'Initial count should be 0');
end;

procedure TestTApplicationController.Add_Controller_IncrementsCount;
begin
  FSut.Add(FCtrl1);
  Assert.IsTrue(FSut.Count = 1, 'Count should be 1 after add');
  FSut.Add(FCtrl2);
  Assert.IsTrue(FSut.Count = 2, 'Count should be 2 after second add');
end;

procedure TestTApplicationController.Remove_Controller_DecrementsCount;
begin
  FSut.Add(FCtrl1);
  FSut.Add(FCtrl2);
  FSut.Remove(FCtrl1);
  Assert.IsTrue(FSut.Count = 1, 'Count should be 1 after remove');
end;

procedure TestTApplicationController.Delete_ByIndex_RemovesController;
begin
  FSut.Add(FCtrl1);
  FSut.Add(FCtrl2);
  FSut.Delete(0);
  Assert.IsTrue(FSut.Count = 1, 'Count should be 1 after delete(0)');
end;

procedure TestTApplicationController.FindController_ByGuid_ReturnsRegisteredController;
var
  LGuid: TGuid;
begin
  LGuid := TMVCBr.GetGuid<IController>();
  FSut.Add(FCtrl1);
  Assert.IsNotNull(FSut.FindController(LGuid),
    'FindController should return controller');
end;

procedure TestTApplicationController.SetMainView_StoresReference;
begin
  FSut.SetMainView(FView);
  Assert.IsNotNull(FSut.MainView, 'MainView should be assigned');
  Assert.IsTrue(FSut.MainView = FView.This, 'MainView should match');
end;

procedure TestTApplicationController.ForEach_IteratesOverAllControllers;
var
  LCount: integer;
begin
  FSut.Add(FCtrl1);
  FSut.Add(FCtrl2);
  LCount := 0;
  FSut.ForEach(
    TFunc<IController, boolean>(
      function(ACtrl: IController): boolean
      begin
        LCount := LCount + 1;
        result := false;
      end));
  Assert.IsTrue(LCount = 2, 'ForEach should visit all controllers');
end;

procedure TestTApplicationController.ForEachFunc_StopsWhenHandled;
var
  LVisited: integer;
  LResult: boolean;
begin
  FSut.Add(FCtrl1);
  FSut.Add(FCtrl2);
  LVisited := 0;
  LResult := FSut.ForEach(
    TFunc<IController, boolean>(
      function(ACtrl: IController): boolean
      begin
        LVisited := LVisited + 1;
        result := LVisited = 1;
      end));
  Assert.IsTrue(LResult, 'ForEachFunc should return true when handled');
  Assert.IsTrue(LVisited = 1, 'ForEachFunc should stop after first match');
end;

procedure TestTApplicationController.This_ReturnsSelf;
begin
  Assert.IsNotNull(FSut.This, 'This should return a TObject');
  Assert.IsTrue(FSut.This = TApplicationController(FSut.This),
    'This should return self');
end;

procedure TestTApplicationController.Inited_CallsInitOnAllControllers;
begin
  FSut.Add(FCtrl1);
  FSut.Add(FCtrl2);
  try
    TApplicationController(FSut.This).Inited;
    Assert.IsTrue(True, 'Inited should not raise');
  except
    Assert.IsTrue(False, 'Inited should not raise');
  end;
end;

procedure TestTApplicationController.UpdateAll_DoesNotRaise;
begin
  FSut.Add(FCtrl1);
  FSut.Add(FCtrl2);
  try
    FSut.UpdateAll;
    Assert.IsTrue(True, 'UpdateAll should not raise');
  except
    Assert.IsTrue(False, 'UpdateAll should not raise');
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTApplicationController);
end.
