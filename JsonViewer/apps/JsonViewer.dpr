program JsonViewer;

uses
  Forms,
  MVCBr.ApplicationController,
  MVCBr.Interf,
  uFormJsonViewer in 'uFormJsonViewer.pas' {FormJsonViewer},
  jsondoc in '..\pckgs\jsondoc.pas',
  jsonparser in '..\pckgs\jsonparser.pas',
  jsontreeview in '..\pckgs\jsontreeview.pas',
  DJsonView.Controller.Interf in 'Controllers\DJsonView.Controller.Interf.pas',
  DJsonView.Controller in 'Controllers\DJsonView.Controller.pas',
  JsonEdit.Controller.Interf in 'JsonEdit\JsonEdit.Controller.Interf.pas',
  JsonEdit.Controller in 'JsonEdit\JsonEdit.Controller.pas',
  JsonEditView in 'JsonEdit\JsonEditView.pas' {JsonEditView};

{$R *.res}

begin
  ApplicationController.Run(TDJsonViewController.new,
    function: boolean
    begin
      Application.MainFormOnTaskbar := True;
      Application.Title := 'Delphi Tokyo JSON Viewer';
      result := True;
    end);

  // Application.Run;
end.
