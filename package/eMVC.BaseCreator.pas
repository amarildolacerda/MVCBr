unit eMVC.BaseCreator;

{ ********************************************************************** }
{ Copyright 2005 Reserved by Eazisoft.com }
{ File Name: BaseCreator.pas }
{ Author: Larry Le }
{ Description: Base Class of the all module creators }
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
  Windows, SysUtils, Classes,
  eMVC.OTAUtilities,
  eMVC.FileCreator,
  ToolsApi,
  eMVC.ToolBox;

type

  TBaseCreator = class(TInterfacedObject, IOTACreator, IOTAModuleCreator)
  protected
    FFileCreator: TFileCreator;
    FAncestorName: string;
    FPath: string;
    FBaseName: string;
    FUnnamed: boolean;
    FTemplates: TStringList;
    FIsFMX: boolean;
    procedure setBaseName(ABaseName: string);
    procedure SetTemplates(const Value: TStringList);
    procedure SetIsFMX(const Value: boolean);
  public
    constructor Create(const APath: string = ''; ABaseName: string = '';
      AUnNamed: boolean = true); virtual;
    destructor destroy; override;
    procedure setPath(APath: string);
    function getpath: string;
    // IOTACreator
    function GetCreatorType: string; virtual;
    function GetExisting: boolean; virtual;
    function GetFileSystem: string;
    function GetOwner: IOTAModule; virtual;
    function GetUnnamed: boolean; virtual;
    // IOTAModulCreator
    function GetAncestorName: string; virtual;
    function GetImplFileName: string; virtual;
    function GetIntfFileName: string;
    function GetFormName: string; virtual;
    function GetMainForm: boolean; virtual;
    function GetShowForm: boolean; virtual;
    function GetShowSource: boolean;
    function NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string)
      : IOTAFile; virtual;
    function NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string)
      : IOTAFile;
    procedure FormCreated(const FormEditor: IOTAFormEditor); virtual;

    property AncestorName: string read GetAncestorName;
    property FormName: string read GetFormName;
    property ImplFileName: string read GetImplFileName;
    property IntfFileName: string read GetIntfFileName;
    property MainForm: boolean read GetMainForm;
    property ShowForm: boolean read GetShowForm;
    property ShowSource: boolean read GetShowSource;

    procedure SetAncestorName(AnAncestorName: string);
    function getBaseName: string;
    property BaseName: string read getBaseName write setBaseName;

    property Templates: TStringList read FTemplates write SetTemplates;
    property IsFMX: boolean read FIsFMX write SetIsFMX;
  end;

implementation

uses eMVC.Config;
{ TSampleProjectCreatorModule }

function TBaseCreator.GetAncestorName: string;
begin
  Result := FAncestorName; // We will be deriving from TForm in this example
end;

procedure TBaseCreator.SetAncestorName(AnAncestorName: string);
var
  s: string;
begin
  s := uppercase(trim(AnAncestorName));
  if s = '' then
    self.FAncestorName := 'Object'
  else
  begin
    if Pos('T', s) = 1 then
      self.FAncestorName := Copy(s, 2, length(s))
    else
      self.FAncestorName := s;
  end;
  Debug('TBaseCreator.SetAncestorName:Parent Class=' + FAncestorName);
end;

function TBaseCreator.getBaseName: string;
begin
  Result := self.FBaseName;
  Debug('GetBaseName: ' + Result);
end;

constructor TBaseCreator.Create(const APath: string = '';
  ABaseName: string = ''; AUnNamed: boolean = true);
begin
  FTemplates := TStringList.Create;
  self.FPath := APath;
  self.FBaseName := ABaseName;
  self.FUnnamed := AUnNamed;
end;

procedure TBaseCreator.setBaseName(ABaseName: string);
begin
  FBaseName := ABaseName;
end;

procedure TBaseCreator.SetIsFMX(const Value: boolean);
begin
  FIsFMX := Value;
end;

procedure TBaseCreator.setPath(APath: string);
begin
  self.FPath := APath;
end;

procedure TBaseCreator.SetTemplates(const Value: TStringList);
begin
  FTemplates := Value;
end;

function TBaseCreator.getpath: string;
var
  LProject: IOTAProject;
begin

  LProject := GetCurrentProject;
  if assigned(LProject) then
    SetCurrentDir(ExtractFilePath(LProject.FileName));

  Result := FPath;

{  if TMVCConfig.new.IsCreateSubFolder then
  begin
    if sametext(FAncestorName, 'form') or sametext(FAncestorName, 'frame') then
      Result := Result + 'Views\'
    else if sametext(FAncestorName, 'datamodule') then
      Result := Result + 'Modules\'
    else if sametext(FAncestorName, 'model') then
      Result := Result + 'Models\'
    else if sametext(FAncestorName, 'viewmodel') then
      Result := Result + 'ViewModels\'
    else if sametext(FAncestorName, 'include') then
      Result := Result + 'inc\'
    else
      Result := Result + LowerCase(FAncestorName) + '\';
  end;
}

  if not DirectoryExists(Result) then
    ForceDirectories(Result);
  Debug('Path: ' + Result);
end;

destructor TBaseCreator.destroy;
begin
  FTemplates.Free;
  inherited;
end;

procedure TBaseCreator.FormCreated(const FormEditor: IOTAFormEditor);
begin
end;

function TBaseCreator.GetExisting: boolean;
begin
  Result := False; // Create a new module
end;

function TBaseCreator.GetFileSystem: string;
begin
  Result := ''; // Default File System
end;

function TBaseCreator.GetFormName: string;
begin
  Result := getBaseName;
end;

function TBaseCreator.GetImplFileName: string;
begin
  Result := '';
end;

function TBaseCreator.GetIntfFileName: string;
begin
  Result := '';
end;

function TBaseCreator.GetMainForm: boolean;
begin
  Result := False;
end;

function TBaseCreator.GetOwner: IOTAModule;
var
  ProjectGroup: IOTAProjectGroup;
begin
  // Owned by current project
  if GetCurrentProjectGroup(ProjectGroup) then
    Result := ProjectGroup.ActiveProject
  else
    Result := GetCurrentProject;
end;

function TBaseCreator.GetShowForm: boolean;
begin
  Result := False;
end;

function TBaseCreator.GetShowSource: boolean;
begin
  Result := true;
end;

function TBaseCreator.GetUnnamed: boolean;
begin
  Result := self.FUnnamed; // true means Project needs to be named/saved
end;

function TBaseCreator.NewFormFile(const FormIdent, AncestorIdent: string)
  : IOTAFile;
begin
  Result := nil;
end;

function TBaseCreator.NewImplSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
begin
  // default create the normal class
  Debug('FileCreator: ' + ModuleIdent);
  FFileCreator := TFileCreator.Create(ModuleIdent, FormIdent, AncestorIdent);
  FFileCreator.IsFMX := self.IsFMX;
  FFileCreator.Templates.Assign(self.FTemplates);
  Result := FFileCreator;
end;

function TBaseCreator.NewIntfSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
begin
  Result := nil;
end;

function TBaseCreator.GetCreatorType: string;
begin
  Result := sUnit;
end;

end.
