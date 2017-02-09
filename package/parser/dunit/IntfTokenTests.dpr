// Uncomment the following directive to create a console application
// or leave commented to create a GUI application... 
// {$APPTYPE CONSOLE}

program IntfTokenTests;


{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  TokenClassesTests in 'TokenClassesTests.pas',
  TokenClasses in '..\TokenClasses.pas',
  TokenInterfaces in '..\TokenInterfaces.pas',
  ParserTests in 'ParserTests.pas',
  IntfParser in '..\IntfParser.pas',
  TestInterfaces in 'TestInterfaces.pas',
  CastaliaPasLex in '..\..\castalia\CastaliaPasLex.pas',
  CastaliaPasLexTypes in '..\..\castalia\CastaliaPasLexTypes.pas',
  CastaliaSimplePasPar in '..\..\castalia\CastaliaSimplePasPar.pas',
  CastaliaSimplePasParTypes in '..\..\castalia\CastaliaSimplePasParTypes.pas';

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.

