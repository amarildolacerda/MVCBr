unit eMVC.ProjectFileCreator;
{ ********************************************************************** }
{ Copyright 2005 Reserved by Eazisoft.com }
{ File Name: ProjectCreator.pas }
{ Author: Larry Le }
{ Description: }
{ Implements the IOTAFile for TProjectCreator }
{ }
{ History: }
{ - 1.0, 19 May 2006 }
{ First version }
{ }
{ Email: linfengle@gmail.com }
{ }
{ The contents of this file are subject to the Mozilla Public License }
{ Version 1.1 (the "License"); you may not use this file except in }
{ compliance with the License. You may obtain a copy of the License at }
{ http://www.mozilla.org/MPL/ }
{ }
{ Software distributed under the License is distributed on an "AS IS" }
{ basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See }
{ the License for the specific language governing rights and }
{ limitations under the License. }
{ }
{ The Original Code is written in Delphi. }
{ }
{ The Initial Developer of the Original Code is Larry Le. }
{ Copyright (C) eazisoft.com. All Rights Reserved. }
{ }
{ ********************************************************************** }

interface

uses
  Windows, Classes, SysUtils,
  eMVC.OTAUtilities,
  eMVC.FileCreator,
  ToolsApi;

const
{$I .\inc\project.inc}
type
  TProjectFileCreator = class(TInterfacedObject, IOTAFile)
  private
    FAge: TDateTime;
    FProjectName: string;
    FTemplates: TStringList;
    FbaseProjectType: TbaseProjectType;
    procedure SetTemplates(const Value: TStringList);
    procedure SetbaseProjectType(const Value: TbaseProjectType);
  public
    constructor Create(const ProjectName: string);
    destructor destroy; override;
    procedure init;
    function GetSource: string;
    function GetAge: TDateTime;
    property Templates: TStringList read FTemplates write SetTemplates;
    property baseProjectType: TbaseProjectType read FbaseProjectType
      write SetbaseProjectType;
  end;

implementation

{ TProjectFileCreator }

constructor TProjectFileCreator.Create(const ProjectName: string);
begin
  FTemplates := TStringList.Create;
  FAge := -1; // Flag age as New File
  FProjectName := ProjectName;
  init;
end;

destructor TProjectFileCreator.destroy;
begin
  FTemplates.Free;
  inherited;
end;

function TProjectFileCreator.GetAge: TDateTime;
begin
  Result := FAge;
end;

function TProjectFileCreator.GetSource: string;
var
  i: integer;
begin
  case baseProjectType of
    bptVCL: Debug('Projeto: VCL');
    bptFMX: Debug('Projeto: FMX');
    bptPrompt: Debug('Projeto: PROMPT');
  end;
  case baseProjectType of
    bptVCL: Result := ProjectCode;
    bptFMX: Result := ProjectCodeFMX;
    bptPrompt: Result := promptProject;
  end;
  // usa os templates;
  for i := 0 to FTemplates.Count - 1 do
  begin
    Result := stringReplace(Result, FTemplates.Names[i],
      FTemplates.ValueFromIndex[i], [rfReplaceAll, rfIgnoreCase]);
    Debug('MainProject: ' + FTemplates.Names[i] + '=' +
      FTemplates.ValueFromIndex[i]);
  end;

end;

procedure TProjectFileCreator.init;
begin
  // Parameterize the code with the current ProjectName
  FTemplates.Add('%ModuleIdent=' + FProjectName);
  FTemplates.Add('%Module=' + 'Main');
  FTemplates.Add('%MdlInterf=' + FProjectName + '.Interf');

end;

procedure TProjectFileCreator.SetbaseProjectType(const Value: TbaseProjectType);
begin
  FbaseProjectType := Value;
end;

procedure TProjectFileCreator.SetTemplates(const Value: TStringList);
begin
  FTemplates := Value;
end;

end.
