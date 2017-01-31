unit eMVC.DataModuleCreator;

interface

uses
  Windows, SysUtils,
  System.Classes,
  eMVC.OTAUtilities,
  eMVC.FileCreator,
  ToolsApi,
  eMVC.BaseCreator;

const
{$I .\inc\Datamodule.inc}
type
  TDataModuleCreator = class(TBaseCreator)
  private
    FIsInterf: Boolean;
    FUnitBase:string;
    procedure SetIsInterf(const Value: Boolean);
  public
    constructor Create(const APath: string = ''; ABaseName: string = '';
      AUnNamed: Boolean = true; AnAncestorName: string = dataModuleAncestorName); reintroduce;
    function GetFormName: string; override;
    function GetCreatorType: string; override;
    function GetImplFileName: string; override;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string)
      : IOTAFile; override;
    procedure FormCreated(const FormEditor: IOTAFormEditor); override;
    property IsInterf: Boolean read FIsInterf write SetIsInterf;
  end;

implementation

uses eMVC.toolbox;

{ TDataModuleCreator }

constructor TDataModuleCreator.Create(const APath: string = '';
  ABaseName: string = ''; AUnNamed: Boolean = true;
  AnAncestorName: string = dataModuleAncestorName);
begin
  inherited Create(APath, ABaseName, AUnNamed);
  SetAncestorName(  dataModuleAncestorName );
  setBaseName( StringReplace(ABaseName,'.','',[]) );
  FUnitBase := ABaseName;
  debug('BaseName: '+ABaseName);
end;

function TDataModuleCreator.GetImplFileName: string;
begin
  result := self.getpath + FUnitBase + '.pas';
  if IsInterf then
    result := self.getpath + FUnitBase + '.Interf.pas';

  debug('TDataModuleCreator.GetImplFileName: ' + result);
end;

function TDataModuleCreator.GetFormName: string;
begin
  result := StringReplace(GetBaseName, '.', '', []);
  debug('TDataModuleCreator.GetFormName: ' + result);
end;

function TDataModuleCreator.NewImplSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
var
  fc: TFileCreator;
  dfm: string;
begin
  if IsInterf then
    fc := TFileCreator.Create(ModuleIdent, FormIdent, AncestorIdent,
      cModelInterf)
  else
  begin
     fc := TFileCreator.Create(ModuleIdent, FormIdent, AncestorIdent, cCLASS);
  end;
  fc.isFMX := self.isFMX;
  fc.Templates.Assign(self.Templates);
  fc.Templates.Values['%MdlInterf'] := FUnitBase + '.Interf';

  fc.FFuncSource := function: string
    begin
      if IsInterf then
        result := dataModuleCodeInterf
      else
        result := dataModuleCode;
    end;

  result := fc;
end;

procedure TDataModuleCreator.SetIsInterf(const Value: Boolean);
begin
  FIsInterf := Value;
end;

procedure TDataModuleCreator.FormCreated(const FormEditor: IOTAFormEditor);
begin
  // One way to get the FormEditor to create Components.  The TButtons are
  // created TProjectCreatorWizard.Execute method.
  debug('TDataModuleCreator.FormCreated');
  inherited;
end;

function TDataModuleCreator.GetCreatorType: string;
begin

{  if ((sametext(GetAncestorName, 'FORM')) or (sametext(GetAncestorName, 'FRAME')
    ) or (sametext(GetAncestorName, dataModuleAncestorName))) and (not IsInterf)
  then
    result := sForm
  else
}    result := sUnit;

  debug('TDataModuleCreator.GetCreatorType=' + GetAncestorName + ',Type='
    + result);
end;

end.
