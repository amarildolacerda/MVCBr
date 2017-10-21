program Test;

uses
  Vcl.Forms,
  TestFrameWork,
  GUITestRunner,
  GoogleApis.Calendar.Tests in 'GoogleApis.Calendar.Tests.pas',
  GoogleApis.Tests in 'GoogleApis.Tests.pas',
  GoogleApis in '..\core\GoogleApis.pas',
  GoogleApis.Persister in '..\core\GoogleApis.Persister.pas',
  GoogleApis.Calendar in '..\calendar\GoogleApis.Calendar.pas',
  GoogleApis.Calendar.Data in '..\calendar\GoogleApis.Calendar.Data.pas';

{$R *.res}

begin
  Application.Initialize;
  GUITestRunner.RunRegisteredTests;
end.
