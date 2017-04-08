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
  TestMVCBr.Controller in 'TestMVCBr.Controller.pas',
  TestMVCBrModel in 'TestMVCBrModel.pas',
  MVCBr.Model in '..\MVCBr.Model.pas',
  MVCBr.InterfaceHelper in '..\MVCBr.InterfaceHelper.pas',
  MVCBr.Interf in '..\MVCBr.Interf.pas',
  TestMVCBr.View in 'TestMVCBr.View.pas',
  MVCBr.View in '..\MVCBr.View.pas',
  TestMVCBrInterf in 'TestMVCBrInterf.pas',
  Test.Controller.Interf in 'Controllers\Test.Controller.Interf.pas',
  Test.Controller in 'Controllers\Test.Controller.pas',
  TestView.Controller.Interf in 'Controllers\TestView.Controller.Interf.pas',
  TestView.Controller in 'Controllers\TestView.Controller.pas',
  TestViewView in 'Views\TestViewView.pas' {TestViewView},
  TestView.ViewModel in 'ViewModels\TestView.ViewModel.pas',
  TestView.ViewModel.Interf in 'ViewModels\TestView.ViewModel.Interf.pas',
  Test.Model in 'Models\Test.Model.pas',
  Test.Model.Interf in 'Models\Test.Model.Interf.pas',
  TestSecond.Controller.Interf in 'Controllers\TestSecond.Controller.Interf.pas',
  TestSecond.Controller in 'Controllers\TestSecond.Controller.pas',
  TestSecondView in 'Views\TestSecondView.pas' {TestSecondView};

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

