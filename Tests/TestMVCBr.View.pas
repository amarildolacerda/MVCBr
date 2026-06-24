unit TestMVCBr.View;

interface

uses
  TestFramework, system.SysUtils,
  system.Classes,
  MVCBr.Interf,
  MVCBr.Model,
  MVCBr.Controller,
  TestViewView,
  MVCBr.View,
  system.Rtti;

type

  TestTViewFactory = class(TTestCase)
  strict private
    FViewFactory: TViewFactory;
    FController: IController;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestNew;
    procedure TestShowView;
    procedure TestUpdate;
    procedure TestGetController;
  end;

  TestTFormFactory = class(TTestCase)
  strict private
    FFormFactory: ITestViewView;
    Controller: IController;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestGetController;
    procedure TestThis;
    procedure TestInterfaceStubInt;
    procedure TestShowView;
    procedure TestUpdate;
    procedure TestResolveController;
    procedure TestEnviarEventoParaUmView;
    procedure TestEnviarEventoJSONparaUmView;
    procedure TestProcurarModelEmUmController;
    procedure TestFindController;
    procedure TestIsModel;
    procedure TestInvokeMethod;
    procedure TestChamarViewSecundaria;

    procedure TestRegisterObserver;
    procedure TestUnRegisterObserverNamed;
    procedure TestUnRegisterObserverNamedOnly;
    procedure TesteObserver;

  end;

implementation

 uses testSecond.Controller.Interf, TestView.Controller.Interf,
  MVCBr.ApplicationController, TestView.Controller, system.Json,
  test.Controller.Interf, test.Model.Interf;

procedure TestTViewFactory.SetUp;
begin
  FController := TControllerFactory.create;
  FViewFactory := TViewFactory.create;
  FController.View(FViewFactory);
  checkNotNull(FViewFactory);
end;

procedure TestTViewFactory.TearDown;
begin
  FController.release;
  FController := nil;
end;

procedure TestTViewFactory.TestNew;
var
  ReturnValue: IView;
  AController: IController;
  AClass: TViewFactoryClass;
begin
  AController := TControllerFactory.create;
  ReturnValue := TViewFactory.New<IView>(TViewFactory);
  checkNotNull(ReturnValue);
end;

procedure TestTViewFactory.TestShowView;
var
  ReturnValue: Integer;
  AProc: TProc<IView>;
begin
  ReturnValue := FViewFactory.ShowView(AProc);
  CheckTrue(ReturnValue >= 0);
end;

procedure TestTViewFactory.TestUpdate;
var
  ReturnValue: IView;
begin
  ReturnValue := FViewFactory.UpdateView;
  checkNotNull(ReturnValue);
end;

procedure TestTViewFactory.TestGetController;
var
  ReturnValue: IController;
begin
  ReturnValue := FViewFactory.GetController;
  checkNotNull(ReturnValue);
end;

procedure TestTFormFactory.SetUp;
begin
  Controller := TTestViewController.New(nil, nil);
  FFormFactory := Controller.GetView as ITestViewView;
end;

procedure TestTFormFactory.TearDown;
begin
  if assigned(Controller) then
    Controller.release;
  Controller := nil;
end;

procedure TestTFormFactory.TestGetController;
var
  ReturnValue: IController;
begin
  ReturnValue := FFormFactory.GetController;
  checkNotNull(ReturnValue);
end;

procedure TestTFormFactory.TestThis;
var
  ReturnValue: TObject;
begin
  ReturnValue := FFormFactory.This;
  checkNotNull(ReturnValue);
end;

procedure TestTFormFactory.TestInterfaceStubInt;
var
  itf: ITestViewView;
begin
  itf := FFormFactory;
  CheckTrue(itf.getStubInt = 1, 'Nao obteve dados na interface');
end;

procedure TestTFormFactory.TestInvokeMethod;
begin
  TViewFactory(FFormFactory.This).InvokeMethod<Integer>('getStubInt', []);
end;

procedure TestTFormFactory.TestIsModel;
begin
  CheckTrue(FFormFactory.GetController.IsModel(itestModel),
    'Nao achei IsModel');
end;

procedure TestTFormFactory.TestProcurarModelEmUmController;
var
  inf: itestModel;
  ctrl: ITestViewController;
begin
  inf := FFormFactory.GetModel(itestModel) as itestModel;
  checkNotNull(inf, 'Nao encontrou o model instanciado no controller');
  inf := nil;

  ctrl := ApplicationController.ResolveController(ITestViewController)
    as ITestViewController;
  checkNotNull(ctrl, 'Nao encontrou o controller desejado');

  checkNotNull(ctrl.GetView, 'Nao incialicou o VIEW');

  inf := ctrl.GetModel(itestModel) as itestModel;
  checkNotNull(inf, 'Nao encontrou o model instanciado no controller');
  ctrl := nil;
  inf := nil;

end;

procedure TestTFormFactory.TestRegisterObserver;
var
  obs: IMVCBrObserver;
begin
  supports(FFormFactory.This, IMVCBrObserver, obs);
  TMVCBr.RegisterObserver('x', obs);
end;

procedure TestTFormFactory.TestResolveController;
var
  ctrl: iTestController;
begin
  ctrl := ApplicationController.ResolveController(iTestController) as iTestController;
  CheckNotNull(ctrl, 'Nao resolveu o controller');
end;

procedure TestTFormFactory.TestShowView;
var
  ret: Integer;
begin
  ret := FFormFactory.ShowView(nil);
  CheckTrue(ret >= 0);
end;

procedure TestTFormFactory.TestUnRegisterObserverNamed;
var
  obs: IMVCBrObserver;
begin
  supports(FFormFactory.This, IMVCBrObserver, obs);
  TMVCBr.RegisterObserver('x', obs);
  TMVCBr.UnRegisterObserver('x', obs);
end;

procedure TestTFormFactory.TestUnRegisterObserverNamedOnly;
var
  obs: IMVCBrObserver;
begin
  supports(FFormFactory.This, IMVCBrObserver, obs);
  TMVCBr.RegisterObserver('y', obs);
  TMVCBr.UnRegisterObserver('y');
end;

procedure TestTFormFactory.TestUpdate;
var
  ReturnValue: IView;
begin
  ReturnValue := FFormFactory.UpdateView;
  checkNotNull(ReturnValue);
end;

procedure TestTFormFactory.TestEnviarEventoParaUmView;
var
  inf: ITestViewView;
  LHandled: Boolean;
begin
  inf := FFormFactory;
  LHandled := false;
  inf.ViewEvent('teste.event', LHandled);
  CheckTrue(LHandled, 'Nao encontrou o evento');
end;

procedure TestTFormFactory.TesteObserver;
var
  obs: IMVCBrObserver;
  ref: Integer;
begin
  supports(FFormFactory.This, IMVCBrObserver, obs);
  TMVCBr.RegisterObserver('x', obs);
  ref := FFormFactory.getStubInt;
  TMVCBr.UpdateObserver('x', nil);

  CheckTrue(FFormFactory.getStubInt > ref, 'Nao chamou o evento do Observer');

  TMVCBr.UnRegisterObserver('x', obs);
  obs := nil;
end;

procedure TestTFormFactory.TestFindController;
begin
  checkNotNull(ApplicationController.FindController(ITestViewController),
    'Nao achou o controller com findController');
end;

procedure TestTFormFactory.TestChamarViewSecundaria;
var
  ctrl: ITestSecondController2;
begin
  ctrl := ApplicationController.ResolveController(ITestSecondController2)
    as ITestSecondController2;
  CheckNotNull(ctrl, 'Nao resolveu o controller secundario');
  ctrl := nil;
end;

procedure TestTFormFactory.TestEnviarEventoJSONparaUmView;
var
  inf: ITestViewView;
  LHandled: Boolean;
  j: TJsonObject;
begin
  inf := FFormFactory;
  LHandled := false;
  j := TJsonObject.create(TJsonPair.create('texto', 'test'));
  try
    inf.ViewEvent(j, LHandled);
  finally
    j.free;
  end;
  CheckTrue(LHandled, 'Nao encontrou o evento');
end;

initialization

RegisterTest(TestTViewFactory.Suite);
RegisterTest(TestTFormFactory.Suite);

end.
