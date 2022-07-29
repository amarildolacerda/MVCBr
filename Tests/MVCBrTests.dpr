program MVCBrTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  MVCBr.ApplicationController,
  MVCBr.Controller,
  MVCBr.FormView,
  MVCBr.View,
  TestMVCBr.Controller in 'TestMVCBr.Controller.pas',
  TestMVCBrModel in 'TestMVCBrModel.pas',
  TestMVCBr.View in 'TestMVCBr.View.pas',
  TestMVCBrInterf in 'TestMVCBrInterf.pas',
  Test.Controller.Interf in 'Controllers\Test.Controller.Interf.pas',
  Test.Controller in 'Controllers\Test.Controller.pas',
  TestView.ViewModel in 'ViewModels\TestView.ViewModel.pas',
  TestView.ViewModel.Interf in 'ViewModels\TestView.ViewModel.Interf.pas',
  Test.Model in 'Models\Test.Model.pas',
  Test.Model.Interf in 'Models\Test.Model.Interf.pas',
  TestView.Controller.Interf in 'TestView\TestView.Controller.Interf.pas',
  TestView.Controller in 'TestView\TestView.Controller.pas',
  TestViewView in 'TestView\TestViewView.pas' {TestViewView},
  TestSecond.Controller.Interf in 'TestSecond\TestSecond.Controller.Interf.pas',
  TestSecond.Controller in 'TestSecond\TestSecond.Controller.pas',
  TestSecondView in 'TestSecond\TestSecondView.pas' {TestSecondView},
  MVCBr.Patterns.Decorator in '..\MVCBr.Patterns.Decorator.pas',
  MVCBr.Patterns.States in '..\MVCBr.Patterns.States.pas',
  TestMVCBr.Patterns.Lazy in 'TestMVCBr.Patterns.Lazy.pas',
  MVCBr.Patterns.Adapter in '..\MVCBr.Patterns.Adapter.pas',
  MVCBr.Patterns.Lazy in '..\MVCBr.Patterns.Lazy.pas',
  MVCBr.Factory in '..\MVCBr.Factory.pas',
  TestMVCBr.Facade in 'TestMVCBr.Facade.pas',
  MVCBr.Patterns.Builder in '..\MVCBr.Patterns.Builder.pas',
  MVCBr.Patterns.Facade in '..\MVCBr.Patterns.Facade.pas',
  DataModuleMock in 'Models\DataModuleMock.pas' {DataModule1: TDataModule},
  MVCBr.BuilderModel in '..\MVCBr.BuilderModel.pas',
  MVCBr.Patterns.Strategy in '..\MVCBr.Patterns.Strategy.pas',
  TestMVCBr.Patterns.Prototype in 'TestMVCBr.Patterns.Prototype.pas',
  MVCBr.Patterns.Prototype in '..\MVCBr.Patterns.Prototype.pas',
  TestMVCBr.Patterns in 'TestMVCBr.Patterns.pas',
  MVCBr.Patterns.Composite in '..\MVCBr.Patterns.Composite.pas',
  MVCBr.Patterns.Mediator in '..\MVCBr.Patterns.Mediator.pas',
  TestMVCBr.Patterns.Mediator in 'TestMVCBr.Patterns.Mediator.pas',
  MVCBr.MiddlewareFactory in '..\MVCBr.MiddlewareFactory.pas',
  testODataServer in 'testODataServer.pas',
  MVCBr.Patterns.Factory in '..\MVCBr.Patterns.Factory.pas',
  TestMVCBr.Patterns.Singleton in 'TestMVCBr.Patterns.Singleton.pas',
  TestsMVCBr.Patterns.Factory in 'TestsMVCBr.Patterns.Factory.pas',
  MVCBr.Patterns.Memento in '..\MVCBr.Patterns.Memento.pas',
  TestMVCBr.Patterns.memento in 'TestMVCBr.Patterns.memento.pas',
  MVCBr.MongoModel in '..\MVCBr.MongoModel.pas',
  TestMVCBrMongoModel in 'TestMVCBrMongoModel.pas';

{$R *.RES}

begin

  System.ReportMemoryLeaksOnShutdown := true;
  DUnitTestRunner.RunRegisteredTests;

end.
