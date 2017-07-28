unit eMVC.ModuleModelCreator;
{ *************************************************************************** }
{ }
{ MVCBr é o resultado de esforços de um grupo }
{ }
{ Copyright (C) 2017 MVCBr }
{ }
{ amarildo lacerda }
{ http://www.tireideletra.com.br }
{ }
{ }
{ *************************************************************************** }
{ }
{ Licensed under the Apache License, Version 2.0 (the "License"); }
{ you may not use this file except in compliance with the License. }
{ You may obtain a copy of the License at }
{ }
{ http://www.apache.org/licenses/LICENSE-2.0 }
{ }
{ Unless required by applicable law or agreed to in writing, software }
{ distributed under the License is distributed on an "AS IS" BASIS, }
{ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{ See the License for the specific language governing permissions and }
{ limitations under the License. }
{ }
{ *************************************************************************** }

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
    FUnitBase: string;
    FUnitIdent:String;
    procedure SetIsInterf(const Value: Boolean);
  public
    constructor Create(const APath: string = ''; ABaseName: string = '';
      AUnNamed: Boolean = true;
      AnAncestorName: string = dataModuleAncestorName); reintroduce;
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
  SetAncestorName(dataModuleAncestorName);
  setBaseName(StringReplace(ABaseName, '.', '', []));
  FUnitBase := ABaseName;
  debug('BaseName: ' + ABaseName);
end;

function TDataModuleCreator.GetImplFileName: string;
begin
  FUnitIdent := FUnitBase ;
  if IsInterf then
    FUnitIdent := FUnitBase + '.Interf';
  result := self.getpath + FUnitIdent + '.pas';
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
  fc.BaseProjectType := self.baseProjectType;
  fc.Templates.Assign(self.Templates);
  fc.Templates.Values['%MdlInterf'] := FUnitBase + '.Interf';
  fc.Templates.Values['%UnitIdent'] := FUnitIdent;

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

  { if ((sametext(GetAncestorName, 'FORM')) or (sametext(GetAncestorName, 'FRAME')
    ) or (sametext(GetAncestorName, dataModuleAncestorName))) and (not IsInterf)
    then
    result := sForm
    else
  } result := sUnit;

  debug('TDataModuleCreator.GetCreatorType=' + GetAncestorName + ',Type='
    + result);
end;

end.
