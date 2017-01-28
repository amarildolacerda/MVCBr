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
  ToolsApi;

type
  TProjectCreator = class(TInterfacedObject, IOTACreator, IOTAProjectCreator
{$IFDEF COMPILER_8_UP}, IOTAProjectCreator80{$ENDIF COMPILER_8_UP})
  private
    FProjectName: string;
    FisFMX: Boolean;
    procedure SetisFMX(const Value: Boolean);
  public
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
  end;

  TBDSProjectGroupCreator = class(TInterfacedObject, IOTACreator,
    IOTAProjectGroupCreator)
  protected
    { Return a string representing the default creator type in which to augment.
      See the definitions of sApplication, sConsole, sLibrary and
      sPackage, etc.. above.  Return an empty string indicating that this
      creator will provide *all* information }
    function GetCreatorType: string;
    { Return False if this is a new module }
    function GetExisting: Boolean;
    { Return the File system IDString that this module uses for reading/writing }
    function GetFileSystem: string;
    { Return the Owning module, if one exists (for a project module, this would
      be a project; for a project this is a project group) }
    function GetOwner: IOTAModule;
    { Return true, if this item is to be marked as un-named.  This will force the
      save as dialog to appear the first time the user saves. }
    function GetUnnamed: Boolean;

    property CreatorType: string read GetCreatorType;
    property Existing: Boolean read GetExisting;
    property FileSystem: string read GetFileSystem;
    property Owner: IOTAModule read GetOwner;
    property Unnamed: Boolean read GetUnnamed;

  public
    function GetFileName: string;
    { Return True to show the source }
    function GetShowSource: Boolean;
    { Deprecated/never called.  Create and return the project group source }
    function NewProjectGroupSource(const ProjectGroupName: string): IOTAFile;
      deprecated;

    property FileName: string read GetFileName;
    property ShowSource: Boolean read GetShowSource;
  end;

Function ProjectGroup: IOTAProjectGroup;

implementation

Function ProjectGroup: IOTAProjectGroup;

Var
  AModuleServices: IOTAModuleServices;
  AModule: IOTAModule;
  i: integer;
  AProjectGroup: IOTAProjectGroup;

Begin
  Result := Nil;
  AModuleServices := (BorlandIDEServices as IOTAModuleServices);
  For i := 0 To AModuleServices.ModuleCount - 1 Do
  Begin
    AModule := AModuleServices.Modules[i];
    If (AModule.QueryInterface(IOTAProjectGroup, AProjectGroup) = S_OK) Then
      Break;
  End;
  Result := AProjectGroup;
end;

{ TProjectCreator }

procedure TProjectCreator.setFileName(AFilename: string);
begin
  self.FProjectName := AFilename;
end;

procedure TProjectCreator.SetisFMX(const Value: Boolean);
begin
  FisFMX := Value;
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
begin
  Result := GetCurrentProjectGroup; // < Owned by current project group
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
  fc := TProjectFileCreator.Create(ProjectName);
  fc.isFMX := self.isFMX;
  Result := fc;
end;

{ TBDSProjectGroupCreator }

function TBDSProjectGroupCreator.GetCreatorType: string;
begin
  Result := sPackage;
end;

function TBDSProjectGroupCreator.GetExisting: Boolean;
begin
  Result := False;
end;

function TBDSProjectGroupCreator.GetFileName: string;
begin
  Result := 'MVCBr Project';
end;

function TBDSProjectGroupCreator.GetFileSystem: string;
begin

end;

function TBDSProjectGroupCreator.GetOwner: IOTAModule;
begin
  Result := nil;
end;

function TBDSProjectGroupCreator.GetShowSource: Boolean;
begin
  Result := False;
end;

function TBDSProjectGroupCreator.GetUnnamed: Boolean;
begin
  Result := True;
end;

function TBDSProjectGroupCreator.NewProjectGroupSource(const ProjectGroupName
  : string): IOTAFile;
begin

end;

end.
