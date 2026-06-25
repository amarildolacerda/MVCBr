unit TestMVCBr.ViewModel;

interface

uses
  DUnitX.TestFramework, System.SysUtils, System.Classes,
  System.JSON, System.Rtti,
  MVCBr.Interf, MVCBr.Model, MVCBr.View, MVCBr.Controller,
  MVCBr.ViewModel;

type
  TFakeViewForVM = class(TInterfacedObject, IView)
  private
    FController: IController;
    FViewModel: IViewModel;
    FUpdateViewCalled: Boolean;
  public
    function This: TObject;
    function ShowView(const AProc: TProc<IView>): Integer; overload;
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
    procedure SetTitle(Const AText: String);
    procedure DoCommand(ACommand: string; const AArgs: array of TValue);
    function ShowView(const AProcBeforeShow: TProc<IView>; AShowModal: boolean): IView; overload;
    function ShowView(const AProcBeforeShow: TProc<IView>; const AProcOnClose: TProc<IView>): IView; overload;
    procedure UpdateObserver(AJson: TJsonValue); overload;
    procedure UpdateObserver(AName: string; AJson: TJsonValue); overload;
    procedure Init;
    function ApplicationControllerInternal: IApplicationController;
    function GetPropertyValue(ANome: string): TValue;
    procedure SetPropertyValue(ANome: string; const Value: TValue);
    function GetGuid(AII: IInterface): TGuid;
    procedure release;
    property UpdateViewCalled: Boolean read FUpdateViewCalled write FUpdateViewCalled;
  end;

  TFakeModelForVM = class(TInterfacedObject, IModel)
  private
    FController: IController;
    FUpdateCalled: Boolean;
  public
    function This: TObject;
    function GetID: string;
    function ID(const AID: String): IModel;
    function Update: IModel; overload;
    procedure Update(AJsonValue: TJsonValue; var AHandled: boolean); overload;
    procedure release;
    function Controller(const AController: IController): IModel;
    procedure SetController(const AController: IController);
    function ApplicationControllerInternal: IApplicationController;
    function GetController: IController;
    function GetModelTypes: TModelTypes;
    procedure SetModelTypes(const AModelType: TModelTypes);
    procedure AfterInit;
    property UpdateCalled: Boolean read FUpdateCalled write FUpdateCalled;
  end;

  [TestFixture]
  TestTViewModelFactory = class
  private
    FViewModel: IViewModel;
    FView: IView;
    FModel: IModel;
    FController: IController;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  public
    [Test]
    procedure Create_Default_SetsViewModelType;
    [Test]
    procedure New_WithViewAndModel_ReturnsViewModel;
    [Test]
    procedure View_SetView_ReturnsSelf;
    [Test]
    procedure Model_SetModel_ReturnsSelf;
    [Test]
    procedure Controller_SetController_ReturnsSelf;
    [Test]
    procedure This_ReturnsViewModelObject;
    [Test]
    procedure Update_WithModel_CallsViewUpdateView;
    [Test]
    procedure Update_WithoutView_DoesNotRaise;
    [Test]
    procedure UpdateView_WithView_CallsModelUpdate;
    [Test]
    procedure UpdateView_WithoutModel_DoesNotRaise;
    [Test]
    procedure Release_DoesNotRaise;
    [Test]
    procedure AfterInit_DoesNotRaise;
    [Test]
    procedure View_NilParam_DoesNotRaise;
    [Test]
    procedure Model_NilParam_DoesNotRaise;
  end;

implementation

{ TFakeViewForVM }

function TFakeViewForVM.This: TObject;
begin
  Result := Self;
end;

function TFakeViewForVM.ShowView(const AProc: TProc<IView>): Integer;
begin
  Result := 0;
end;

function TFakeViewForVM.ShowView: IView;
begin
  Result := Self;
end;

function TFakeViewForVM.UpdateView: IView;
begin
  FUpdateViewCalled := True;
  Result := Self;
end;

procedure TFakeViewForVM.Update(AJsonValue: TJsonValue; var AHandled: boolean);
begin
end;

function TFakeViewForVM.ViewEvent(AMessage: string; var AHandled: boolean): IView;
begin
  Result := Self;
end;

function TFakeViewForVM.ViewEvent(AMessage: TJsonValue; var AHandled: boolean): IView;
begin
  Result := Self;
end;

function TFakeViewForVM.Controller(const AController: IController): IView;
begin
  FController := AController;
  Result := Self;
end;

function TFakeViewForVM.GetController: IController;
begin
  Result := FController;
end;

procedure TFakeViewForVM.SetController(const AController: IController);
begin
  FController := AController;
end;

function TFakeViewForVM.GetModel(AII: TGuid): IModel;
begin
  Result := nil;
end;

function TFakeViewForVM.GetViewModel: IViewModel;
begin
  Result := FViewModel;
end;

procedure TFakeViewForVM.SetViewModel(const AViewModel: IViewModel);
begin
  FViewModel := AViewModel;
end;

function TFakeViewForVM.GetID: string;
begin
  Result := '';
end;

function TFakeViewForVM.GetTitle: String;
begin
  Result := '';
end;

procedure TFakeViewForVM.SetTitle(const AText: String);
begin
end;

procedure TFakeViewForVM.DoCommand(ACommand: string; const AArgs: array of TValue);
begin
end;

function TFakeViewForVM.ShowView(const AProcBeforeShow: TProc<IView>; AShowModal: boolean): IView;
begin
  Result := Self;
end;

function TFakeViewForVM.ShowView(const AProcBeforeShow: TProc<IView>; const AProcOnClose: TProc<IView>): IView;
begin
  Result := Self;
end;

procedure TFakeViewForVM.UpdateObserver(AJson: TJsonValue);
begin
end;

procedure TFakeViewForVM.UpdateObserver(AName: string; AJson: TJsonValue);
begin
end;

procedure TFakeViewForVM.Init;
begin
end;

function TFakeViewForVM.ApplicationControllerInternal: IApplicationController;
begin
  Result := nil;
end;

function TFakeViewForVM.GetPropertyValue(ANome: string): TValue;
begin
  Result := TValue.Empty;
end;

procedure TFakeViewForVM.SetPropertyValue(ANome: string; const Value: TValue);
begin
end;

function TFakeViewForVM.GetGuid(AII: IInterface): TGuid;
begin
  Result := TGuid.Empty;
end;

procedure TFakeViewForVM.release;
begin
end;

{ TFakeModelForVM }

function TFakeModelForVM.This: TObject;
begin
  Result := Self;
end;

function TFakeModelForVM.GetID: string;
begin
  Result := '';
end;

function TFakeModelForVM.ID(const AID: String): IModel;
begin
  Result := Self;
end;

function TFakeModelForVM.Update: IModel;
begin
  FUpdateCalled := True;
  Result := Self;
end;

procedure TFakeModelForVM.Update(AJsonValue: TJsonValue; var AHandled: boolean);
begin
end;

procedure TFakeModelForVM.release;
begin
end;

function TFakeModelForVM.Controller(const AController: IController): IModel;
begin
  FController := AController;
  Result := Self;
end;

procedure TFakeModelForVM.SetController(const AController: IController);
begin
  FController := AController;
end;

function TFakeModelForVM.ApplicationControllerInternal: IApplicationController;
begin
  Result := nil;
end;

function TFakeModelForVM.GetController: IController;
begin
  Result := FController;
end;

function TFakeModelForVM.GetModelTypes: TModelTypes;
begin
  Result := [];
end;

procedure TFakeModelForVM.SetModelTypes(const AModelType: TModelTypes);
begin
end;

procedure TFakeModelForVM.AfterInit;
begin
end;

{ TestTViewModelFactory }

procedure TestTViewModelFactory.SetUp;
begin
  FView := TFakeViewForVM.Create;
  FModel := TFakeModelForVM.Create;
  FController := TControllerFactory.Create;
  FViewModel := TViewModelFactory.Create;
end;

procedure TestTViewModelFactory.TearDown;
begin
  FViewModel := nil;
  FView := nil;
  FModel := nil;
  FController := nil;
end;

procedure TestTViewModelFactory.Create_Default_SetsViewModelType;
begin
  Assert.IsNotNull(FViewModel, 'ViewModel should be created');
  Assert.IsTrue(FViewModel.This is TViewModelFactory,
    'Instance should be TViewModelFactory');
end;

procedure TestTViewModelFactory.New_WithViewAndModel_ReturnsViewModel;
var
  LVM: IViewModel;
begin
  LVM := TViewModelFactory.New(FView, FModel);
  Assert.IsNotNull(LVM, 'New should return a ViewModel');
  LVM := nil;
end;

procedure TestTViewModelFactory.View_SetView_ReturnsSelf;
var
  LResult: IViewModel;
begin
  LResult := FViewModel.View(FView);
  Assert.IsNotNull(LResult, 'View() should return self');
  Assert.AreSame(LResult, FViewModel,
    'View() should return the same ViewModel instance');
end;

procedure TestTViewModelFactory.Model_SetModel_ReturnsSelf;
var
  LResult: IViewModel;
begin
  LResult := FViewModel.Model(FModel);
  Assert.IsNotNull(LResult, 'Model() should return self');
  Assert.AreSame(LResult, FViewModel,
    'Model() should return the same ViewModel instance');
end;

procedure TestTViewModelFactory.Controller_SetController_ReturnsSelf;
var
  LResult: IViewModel;
begin
  LResult := FViewModel.Controller(FController);
  Assert.IsNotNull(LResult, 'Controller() should return self');
  Assert.AreSame(LResult, FViewModel,
    'Controller() should return the same ViewModel instance');
end;

procedure TestTViewModelFactory.This_ReturnsViewModelObject;
begin
  Assert.IsNotNull(FViewModel.This, 'This should return a TObject');
  Assert.IsTrue(FViewModel.This is TViewModelFactory,
    'This should be a TViewModelFactory instance');
end;

procedure TestTViewModelFactory.Update_WithModel_CallsViewUpdateView;
var
  LFakeView: TFakeViewForVM;
begin
  LFakeView := TFakeViewForVM(FView.This);
  LFakeView.UpdateViewCalled := False;
  FViewModel.View(FView);
  FViewModel.Update(FModel);
  Assert.IsTrue(LFakeView.UpdateViewCalled,
    'Update should call View.UpdateView');
end;

procedure TestTViewModelFactory.Update_WithoutView_DoesNotRaise;
begin
  try
    FViewModel.Update(FModel);
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'Update without view should not raise');
  end;
end;

procedure TestTViewModelFactory.UpdateView_WithView_CallsModelUpdate;
var
  LFakeModel: TFakeModelForVM;
begin
  LFakeModel := TFakeModelForVM(FModel.This);
  LFakeModel.UpdateCalled := False;
  FViewModel.Model(FModel);
  FViewModel.UpdateView(FView);
  Assert.IsTrue(LFakeModel.UpdateCalled,
    'UpdateView should call Model.Update');
end;

procedure TestTViewModelFactory.UpdateView_WithoutModel_DoesNotRaise;
begin
  try
    FViewModel.UpdateView(FView);
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'UpdateView without model should not raise');
  end;
end;

procedure TestTViewModelFactory.Release_DoesNotRaise;
begin
  try
    FViewModel.Release;
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'Release should not raise');
  end;
end;

procedure TestTViewModelFactory.AfterInit_DoesNotRaise;
begin
  try
    FViewModel.AfterInit;
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'AfterInit should not raise');
  end;
end;

procedure TestTViewModelFactory.View_NilParam_DoesNotRaise;
begin
  try
    FViewModel.View(nil);
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'View(nil) should not raise');
  end;
end;

procedure TestTViewModelFactory.Model_NilParam_DoesNotRaise;
begin
  try
    FViewModel.Model(nil);
    Assert.IsTrue(True);
  except
    Assert.IsTrue(False, 'Model(nil) should not raise');
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TestTViewModelFactory);

end.
