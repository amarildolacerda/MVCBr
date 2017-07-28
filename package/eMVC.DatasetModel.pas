unit eMVC.DatasetModel;
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
  ToolsAPI, eMVC.FileCreator, eMVC.OTAUtilities, eMVC.ModelCreator;

type
  TDatasetModel = class(TModelCreator)
  private
    function GetImplFileName: string; override;
  public

    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string)
      : IOTAFile; override;

  end;

implementation

{ TDatasetModel }
const
   CR = #13;
{$I .\inc\DatasetModel.Inc}

function TDatasetModel.GetImplFileName: string;
begin
  result := self.getpath + getBaseName + '.DatasetModel.pas';
  if isInterf then
    result := self.getpath + getBaseName + '.DatasetModel.Interf.pas';
  debug('TDatasetModel.GetImplFileName: ' + result);

end;

function TDatasetModel.NewImplSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
var
  fc: TFileCreator;
begin

  debug('TDatasetModel.NewImplSource: ');
  if isInterf then
    fc := TFileCreator.New(ModuleIdent, FormIdent, AncestorIdent,
      function: string
      begin
        result := DatasetModelIntef ;
      end)
  else
    fc := TFileCreator.New(ModuleIdent, FormIdent, AncestorIdent,
      function: string
      begin
        result := DatasetModel;
      end);

  fc.Templates.assign(Templates);
  fc.Templates.Values['%MdlInterf'] := getBaseName + '.DatasetModel.Interf';

  result := fc;
end;

end.
