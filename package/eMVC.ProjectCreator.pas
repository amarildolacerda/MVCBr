unit eMVC.ProjectCreator;
{ ********************************************************************** }
{ Copyright 2005 Reserved by Eazisoft.com }
{ File Name: ProjectCreator.pas }
{ Author: Larry Le }
{ Description: }
{ This unit contains the Easy MVC petterns define }
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

{$I .\inc\Compilers.inc}

uses
  Windows, SysUtils,
  eMVC.OTAUtilities,
  eMVC.ProjectFileCreator,
  PlatformAPI,
  ToolsApi;

type
  TProjectCreator = class(TInterfacedObject, IOTACreator, IOTAProjectCreator
{$IFDEF COMPILER_8_UP}, IOTAProjectCreator80{$ENDIF COMPILER_8_UP}
{$IF compilerVersion>=28}, IOTAProjectCreator160{$ENDIF}
    )
  private
    FProjectName: string;
    FisFMX: Boolean;
    procedure SetisFMX(const Value: Boolean);
  public
    constructor create; virtual;
    // IOTACreator
    function GetCreatorType: string;
    function GetExisting: Boolean;
    function GetFileSystem: string;
    function GetOwner: IOTAModule;
    function GetUnnamed: Boolean;
    // IOTAProjectCreator
    function GetFileName: string;
    function GetOptionFileName: string;
    function GetShowSource: Boolean;
    procedure NewDefaultModule;
    function NewOptionSource(const ProjectName: string): IOTAFile;
    procedure NewProjectResource(const Project: IOTAProject);
    function NewProjectSource(const ProjectName: string): IOTAFile;
{$IFDEF COMPILER_8_UP}
    // IOTAProjectCreator50
    procedure NewDefaultProjectModule(const Project: IOTAProject);
    // IOTAProjectCreator80
    function GetProjectPersonality: string;
    property ProjectPersonality: string read GetProjectPersonality;
{$ENDIF COMPILER_8_UP}
    procedure setFileName(AFilename: string);
    property isFMX: Boolean read FisFMX write SetisFMX;

{$IF CompilerVersion>=28}
  private
    FPersonality: string;
  protected
    function GetProjectPersonality: string;

    // IOTAProjectCreator160
    function GetPlatforms: TArray<string>;
    function GetFrameworkType: string;
    function GetPreferredPlatform: string;
    procedure SetInitialOptions(const NewProject: IOTAProject);
    procedure NewDefaultProjectModule(const Project: IOTAProject);

  public
    property Personality: string read FPersonality write FPersonality;
{$ENDIF}
  end;

implementation

{ TProjectCreator }

procedure TProjectCreator.setFileName(AFilename: string);
begin
  self.FProjectName := AFilename;
end;

procedure TProjectCreator.SetisFMX(const Value: Boolean);
begin
  FisFMX := Value;
end;

constructor TProjectCreator.create;
begin
  inherited;
  FPersonality := sDelphiPersonality;
end;

function TProjectCreator.GetCreatorType: string;
begin
  Result := sApplication;
end;

function TProjectCreator.GetExisting: Boolean;
begin
  Result := False; // Create a new module
end;

function TProjectCreator.GetFileName: string;
begin
  Result := FProjectName; // Delphi Defined default File name
end;

function TProjectCreator.GetFileSystem: string;
begin
  Result := ''; // Default File System
end;

function TProjectCreator.GetOptionFileName: string;
begin
  Result := ''; // C++ Only ?
end;

function TProjectCreator.GetOwner: IOTAModule;
var
  ProjectGroup: IOTAProjectGroup;
begin
  Result := nil;
  if GetCurrentProjectGroup(ProjectGroup) then
    Result := ProjectGroup;
end;

{$IFDEF COMPILER_8_UP}

function TProjectCreator.GetProjectPersonality: string;
begin
  Result := sDelphiPersonality;
end;

{$ENDIF COMPILER_8_UP}

function TProjectCreator.GetShowSource: Boolean;
begin
  Result := True; // < Show the source in the editor
end;

function TProjectCreator.GetUnnamed: Boolean;
begin
  Result := True; // < Project needs to be named/saved
end;

procedure TProjectCreator.NewDefaultModule;
begin
  // No default modules are created
end;

{$IFDEF COMPILER_8_UP}

procedure TProjectCreator.NewDefaultProjectModule(const Project: IOTAProject);
begin
end;

{$ENDIF COMPILER_8_UP}

function TProjectCreator.NewOptionSource(const ProjectName: string): IOTAFile;
begin
  Result := nil; // For BCB only
end;

procedure TProjectCreator.NewProjectResource(const Project: IOTAProject);
// var
// resname: string;
begin
  // resname := self.GetFileName;
  // StringReplace(resname, '.dpr', '.res', [rfIgnoreCase]);
  // project.AddFile(resname, false);
end;

function TProjectCreator.NewProjectSource(const ProjectName: string): IOTAFile;
var
  fc: TProjectFileCreator;
begin
  debug('Iniciando Project: ' + ProjectName);
  fc := TProjectFileCreator.create(ProjectName);
  fc.isFMX := self.isFMX;
  Result := fc;
end;

{$IF CompilerVersion>=28}

function TProjectCreator.GetProjectPersonality: string;
begin
  Result := FPersonality;
end;

// IOTAProjectCreator160
function TProjectCreator.GetPlatforms: TArray<string>;
begin
  if Personality = sDelphiPersonality then
    Result := TArray<string>.create(cWin32Platform, cWin64Platform,
      cOSX32Platform, cAndroidPlatform, ciOSSimulatorPlatform
      {$IFDEF DELPHI_XE8_UP}, ciOSDevice32Platform, ciOSDevice64Platform
      {$ENDIF})
  else
    Result := TArray<string>.create(cWin32Platform, cWin64Platform,
      cOSX32Platform, cAndroidPlatform
      {$IFDEF DELPHI_XE8_UP}, ciOSDevice32Platform, ciOSDevice64Platform
      {$ENDIF});

end;

function TProjectCreator.GetFrameworkType: string;
begin
    if isFMX then
      result := sFrameworkTypeFMX
    else
      result := sFrameworkTypeVCL;
end;

function TProjectCreator.GetPreferredPlatform: string;
begin
  result := cWin32Platform;
end;

procedure TProjectCreator.SetInitialOptions(const NewProject: IOTAProject);
var
  LBuildConf: IOTAProjectOptionsConfigurations;
begin
  if Supports(NewProject.ProjectOptions, IOTAProjectOptionsConfigurations, LBuildConf) then
  begin
    LBuildConf.BaseConfiguration.AsBoolean['UsingDelphiRTL'] := True;
    if FPersonality = sCBuilderPersonality then
    begin
      LBuildConf.BaseConfiguration.PlatformConfiguration[cAndroidPlatform].AsBoolean['ILINK_LinkwithDUnitXRuntime'] := True;
      LBuildConf.BaseConfiguration.PlatformConfiguration[ciOSDevice32Platform].AsBoolean['ILINK_LinkwithDUnitXRuntime'] := True;
      LBuildConf.BaseConfiguration.PlatformConfiguration[ciOSDevice64Platform].AsBoolean['ILINK_LinkwithDUnitXRuntime'] := True;
    end;
  end;

end;
procedure TProjectCreator.NewDefaultProjectModule(const Project: IOTAProject);
begin
end;

{$ENDIF}

end.
