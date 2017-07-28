unit eMVC.PersistentModelCreator;

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
  eMVC.ViewCreator,
  eMVC.FileCreator,
  ToolsApi,
  eMVC.OTAUtilities,
  eMVC.BaseCreator;

type

  TPersistentModelCreator = class(TBaseCreator)
  private
    FisInterf: boolean;
    FUnitIdent: string;
    procedure SetisInterf(const Value: boolean);
  public
    constructor Create(const APath: string = ''; ABaseName: string = '';
      AUnNamed: boolean = true); override;
    function GetImplFileName: string; override;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string)
      : IOTAFile; override;
    property isInterf: boolean read FisInterf write SetisInterf;
  end;

implementation

{ TPersistentModelCreator }

constructor TPersistentModelCreator.Create(const APath: string = '';
  ABaseName: string = ''; AUnNamed: boolean = true);
begin
  inherited Create(APath, ABaseName, AUnNamed);
  self.SetAncestorName('PersistentModel');
end;

function TPersistentModelCreator.GetImplFileName: string;
begin
  FUnitIdent := getBaseName + '.' + Templates.Values['%modelName'];
  if isInterf then
    FUnitIdent := getBaseName + '.' + Templates.Values['%modelName'] + '.Interf';

  result := self.getpath + FUnitIdent+ '.pas';


    debug('TPersistentModelCreator.GetImplFileName:' + result);

end;

function TPersistentModelCreator.NewImplSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
var
  fc: TFileCreator;
begin

  if isInterf then
    fc := TFileCreator.Create(ModuleIdent, FormIdent, AncestorIdent,
      cModelInterf)
  else
    fc := TFileCreator.Create(ModuleIdent, FormIdent, AncestorIdent,
      cPersistentMODEL);
  fc.BaseProjectType := self.baseProjectType;

  fc.Templates.Clear;
  fc.Templates.assign(Templates);

  fc.Templates.Add('%modelName=' + Templates.Values['%modelName']);
  fc.Templates.Add('%modelNameInterf=' + Templates.Values['%modelName'] +
    '.Model.Interf');
  fc.Templates.Values['%UnitIdent'] := FUnitIdent;

  result := fc;
end;

procedure TPersistentModelCreator.SetisInterf(const Value: boolean);
begin
  FisInterf := Value;
end;

end.
