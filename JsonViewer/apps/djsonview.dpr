program djsonview;

uses
  Forms,
  uFormJsonViewer in 'uFormJsonViewer.pas' {FormJsonViewer},
  jsondoc in '..\pckgs\jsondoc.pas',
  jsonparser in '..\pckgs\jsonparser.pas',
  jsontreeview in '..\pckgs\jsontreeview.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Delphi Tokyo JSON Viewer';
  Application.CreateForm(TFormJsonViewer, FormJsonViewer);
  Application.Run;
end.
