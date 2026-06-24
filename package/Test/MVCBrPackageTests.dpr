program MVCBrPackageTests;
{

  Delphi DUnitX Test Project
  --------------------------
  This project uses DUnitX testing framework.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  TesteNewClassModelForm in 'TesteNewClassModelForm.pas',
  eMVC.NewClassModelForm in '..\eMVC.NewClassModelForm.pas',
  eMVC.AppWizardForm in '..\eMVC.AppWizardForm.pas' {FormAppWizard},
  TesteMVCAppWizardForm in 'TesteMVCAppWizardForm.pas';

{$R *.RES}

var
  runner: ITestRunner;
  results: IRunResults;
begin
  System.ReportMemoryLeaksOnShutdown := True;
  runner := TDUnitX.CreateRunner;
  {$IFDEF CONSOLE_TESTRUNNER}
  runner.AddLogger(TDUnitXConsoleLogger.Create(true));
  {$ENDIF}
  results := runner.Execute;
  if not results.AllPassed then
    ExitCode := EXIT_ERRORS;
end.

