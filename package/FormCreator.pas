unit FormCreator;

interface

uses
  Windows, SysUtils,
  OTAUtilities,
  FileCreator,
  ToolsApi,
  BaseCreator;

type
  TFormCreator = class(TBaseCreator)
    function GetAncestorName: string; override;
    function GetFormName: string; override;
    function GetCreatorType: string; override;
    function GetImplFileName: string; override;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile; override;
    procedure FormCreated(const FormEditor: IOTAFormEditor); override;
  end;

implementation

{ TFormCreator }

function TFormCreator.GetImplFileName: string;
begin
  result := self.getpath + GetBaseName + 'View.pas';
end;

function TFormCreator.getFormName: string;
begin
  result := 'View' + GetBaseName;
end;

function TFormCreator.NewImplSource(const ModuleIdent,
  FormIdent, AncestorIdent: string): IOTAFile;
begin
  Result := TFileCreator.Create(ModuleIdent, FormIdent, AncestorIdent, cView);
end;

procedure TFormCreator.FormCreated(const FormEditor: IOTAFormEditor);
begin
  // One way to get the FormEditor to create Components.  The TButtons are
  // created TProjectCreatorWizard.Execute method.
  inherited;
end;

function TFormCreator.GetAncestorName: string;
begin
  Result := 'Form'; // We will be deriving from TForm in this example
end;

function TFormCreator.GetCreatorType: string;
begin
  Result := sForm;
end;

end.

