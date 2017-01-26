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
  ToolsApi;

const
{$I .\inc\project.inc}
type
  TProjectFileCreator = class(TInterfacedObject, IOTAFile)
  private
    FAge: TDateTime;
    FProjectName: string;
    FTemplates: TStringList;
    FisFMX: Boolean;
    procedure SetTemplates(const Value: TStringList);
    procedure SetisFMX(const Value: Boolean);
  public
    constructor Create(const ProjectName: string);
    destructor destroy; override;
    procedure init;
    function GetSource: string;
    function GetAge: TDateTime;
    property Templates: TStringList read FTemplates write SetTemplates;
    property isFMX: Boolean read FisFMX write SetisFMX;
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
  Result := ProjectCode;
  if isFMX then
    Result := ProjectCodeFMX;

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
  FTemplates.AddPair('%ModuleIdent', FProjectName);
  FTemplates.AddPair('%Module', 'Main');

end;

procedure TProjectFileCreator.SetisFMX(const Value: Boolean);
begin
  FisFMX := Value;
end;

procedure TProjectFileCreator.SetTemplates(const Value: TStringList);
begin
  FTemplates := Value;
end;

end.
