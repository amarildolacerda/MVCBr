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
  TestSecondView in 'TestSecond\TestSecondView.pas' {TestSecondView};

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

