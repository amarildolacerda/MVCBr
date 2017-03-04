program MVCBrServerTests;
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
  TestoData in 'TestoData.pas',
  MVC.oData.Base in '..\..\oData\MVC.oData.Base.pas',
  oData.Client.Builder in '..\..\oData\oData.Client.Builder.pas',
  oData.Client in '..\..\oData\oData.Client.pas',
  oData.Collections in '..\..\oData\oData.Collections.pas',
  oData.Dialect.Firebird in '..\..\oData\oData.Dialect.Firebird.pas',
  oData.Dialect.MySQL in '..\..\oData\oData.Dialect.MySQL.pas',
  oData.Dialect in '..\..\oData\oData.Dialect.pas',
  oData.Engine in '..\..\oData\oData.Engine.pas',
  oData.Interf in '..\..\oData\oData.Interf.pas',
  oData.Parse in '..\..\oData\oData.Parse.pas',
  oData.ProxyBase in '..\..\oData\oData.ProxyBase.pas',
  oData.ServiceModel in '..\..\oData\oData.ServiceModel.pas',
  oData.SQL.FireDAC in '..\..\oData\oData.SQL.FireDAC.pas',
  oData.SQL in '..\..\oData\oData.SQL.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

