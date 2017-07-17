unit eMVC.BuilderSubClassCreator;

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

const
{$I .\inc\BuilderModel.inc}
type

  TBuilderCreator = class(TBaseCreator)
  private
    FisInterf: boolean;
    FUnitIdent: string;
    FSubClassType: Integer;
    procedure SetisInterf(const Value: boolean);
    procedure SetSubClassType(const Value: Integer);
  public
    constructor Create(const APath: string = ''; ABaseName: string = ''; AUnNamed: boolean = true); override;
    function GetImplFileName: string; override;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile; override;
    property isInterf: boolean read FisInterf write SetisInterf;
    property SubClassType:Integer read FSubClassType write SetSubClassType;
  end;

implementation

{ TModelCreator }

constructor TBuilderCreator.Create(const APath: string = ''; ABaseName: string = ''; AUnNamed: boolean = true);
begin
  inherited Create(APath, ABaseName, AUnNamed);
  self.SetAncestorName('builderBuilt');
end;

function TBuilderCreator.GetImplFileName: string;
begin
  FUnitIdent := getBaseName + '.Built';
  if isInterf then
    FUnitIdent := getBaseName + '.Built.Interf';

  result := self.getpath + FUnitIdent + '.pas';

end;

function TBuilderCreator.NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile;
var
  fc: TFileCreator;
begin
  debug('TBuiltCreator.NewImplSource: ');
  if isInterf then
    fc := TFileCreator.New(ModuleIdent, FormIdent, AncestorIdent,
      function: string
      begin
        result := builderSubClassInterf;
      end)
  else
    fc := TFileCreator.New(ModuleIdent, FormIdent, AncestorIdent,
      function: string
      begin
        if SubClassType=1 then
           result := builderSubClassModel
        else
           result := builderLazySubClassModel;
      end);

  fc.Templates.assign(Templates);
  fc.Templates.Values['%MdlInterf'] := getBaseName + '.Built.Interf';
  fc.Templates.Values['%UnitIdent'] := FUnitIdent;
  result := fc;
end;

procedure TBuilderCreator.SetisInterf(const Value: boolean);
begin
  FisInterf := Value;
end;

procedure TBuilderCreator.SetSubClassType(const Value: Integer);
begin
  FSubClassType := Value;
end;

end.
