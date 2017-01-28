unit eMVC.ViewCreator;

interface

uses
  Windows, SysUtils,
  eMVC.OTAUtilities,
  eMVC.FileCreator,
  ToolsApi,
  eMVC.BaseCreator;

type
  TViewCreator = class(TBaseCreator)
  public
    constructor Create(const APath: string = ''; ABaseName: string = '';
      AUnNamed: Boolean = true; AnAncestorName: string = 'Form'); reintroduce;
    function GetFormName: string; override;
    function GetCreatorType: string; override;
    function GetImplFileName: string; override;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string)
      : IOTAFile; override;
    procedure FormCreated(const FormEditor: IOTAFormEditor); override;
  end;

implementation

uses eMVC.toolbox;

{ TViewCreator }

constructor TViewCreator.Create(const APath: string = '';
  ABaseName: string = ''; AUnNamed: Boolean = true;
  AnAncestorName: string = 'Form');
begin
  inherited Create(APath, ABaseName, AUnNamed);
  SetAncestorName(AnAncestorName);
end;

function TViewCreator.GetImplFileName: string;
begin
  result := self.getpath + GetBaseName + 'View.pas';
  debug('View: ' + result);
end;

function TViewCreator.GetFormName: string;
begin
  result := GetBaseName + 'View';
  debug('Form View: ' + result);
end;

function TViewCreator.NewImplSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
var
  fc: TFileCreator;
begin
  if GetCreatorType = sForm then
    fc := TFileCreator.Create(ModuleIdent, FormIdent, AncestorIdent, cView)
  else
    fc := TFileCreator.Create(ModuleIdent, FormIdent, AncestorIdent, cClass);
  fc.isFMX := self.IsFMX;
  fc.Templates.Assign(self.Templates);
  fc.Templates.Values['%MdlInterf'] :=getBaseName+'.ViewModel.Interf';

  result := fc;
end;

procedure TViewCreator.FormCreated(const FormEditor: IOTAFormEditor);
begin
  // One way to get the FormEditor to create Components.  The TButtons are
  // created TProjectCreatorWizard.Execute method.
  inherited;
end;

function TViewCreator.GetCreatorType: string;
begin

  if (sametext(GetAncestorName, 'FORM')) or (sametext(GetAncestorName, 'FRAME'))
  then
    result := sForm
  else
    result := sUnit;

  debug('TViewCreator.GetCreatorType=' + GetAncestorName + ',Type=' + result);
end;

end.
