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
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  DUnitTestRunner,
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
  TestMVCBr.Patterns in 'TestMVCBr.Patterns.pas',
  MVCBr.Patterns.Adapter in '..\MVCBr.Patterns.Adapter.pas',
  MVCBr.Patterns.Lazy in '..\MVCBr.Patterns.Lazy.pas',
  MVCBr.Patterns.Factory in '..\MVCBr.Patterns.Factory.pas',
  MVCBr.Patterns.Facade.First in '..\MVCBr.Patterns.Facade.First.pas',
  TestMVCBr.Facade in 'TestMVCBr.Facade.pas',
  MVCBr.Patterns.Builder in '..\MVCBr.Patterns.Builder.pas',
  MVCBr.Patterns.Facade in '..\MVCBr.Patterns.Facade.pas';

{$R *.RES}

begin
  System.ReportMemoryLeaksOnShutdown := true;
  DUnitTestRunner.RunRegisteredTests;
end.

