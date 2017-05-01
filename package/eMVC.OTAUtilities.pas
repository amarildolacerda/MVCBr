unit eMVC.OTAUtilities;

// Can't debug a weakpackage unit
{$WEAKPACKAGEUNIT ON}

interface

uses
  Windows, ToolsApi, SysUtils;

procedure debug(s: string);
function SetNameExists(ASetname: string): boolean;
function GetCurrentProject: IOTAProject;
function GetCurrentProjectGroup(out ProjectGroup: IOTAProjectGroup): boolean;
function ModuleIsForm(Module: IOTAModule): boolean;
function ModuleIsProject(Module: IOTAModule): boolean;
function ModuleIsProjectGroup(Module: IOTAModule): boolean;
function ModuleIsTypeLib(Module: IOTAModule): boolean;
function FormEditorFromForm(Module: IOTAModule): IOTAFormEditor;
function EditorIsFormEditor(Editor: IOTAEditor): boolean;
function EditorIsProjectResEditor(Editor: IOTAEditor): boolean;
function EditorIsTypeLibEditor(Editor: IOTAEditor): boolean;
function EditorIsSourceEditor(Editor: IOTAEditor): boolean;
function IsModule(Unk: IUnknown): boolean;
function GetFrameworkType: string;
function RemovePonto(texto: string): string;
function GetUnitSubFolder(var IdentProject: string): string;

implementation

function GetUnitSubFolder(var IdentProject: string): string;
var
  n: integer;
begin
  result := '';
  n := IdentProject.IndexOf('\'); // pos ('\', IdentProject);
  if n >= 0 then
  begin
    result := '\' + IdentProject.Substring(0, n); // copy (IdentProject, 1, n);
    IdentProject := IdentProject.Substring(n + 1, 255);
    // copy (IdentProject, n + 1, 255);
  end;
end;

function RemovePonto(texto: string): string;
begin
  result := stringreplace(texto, '.', '', [rfReplaceAll]);
end;

function GetFrameworkType: string;
var
  prj: IOTAProject;
begin
  result := '';
  prj := GetCurrentProject;
  if assigned(prj) then
    result := prj.FrameworkType;
end;

procedure debug(s: string);
begin
  (BorlandIDEServices as IOTAMessageServices)
    .AddTitleMessage(formatdatetime('hh:mm:ss zzz: ', time) + s);
end;

function GetCurrentProject: IOTAProject;
var
  ProjectGroup: IOTAProjectGroup;
  I: integer;
  rt: boolean;
begin
  result := nil;
  rt := GetCurrentProjectGroup(ProjectGroup);

  if rt then
  begin
    if ProjectGroup.ProjectCount > 0 then
      result := ProjectGroup.ActiveProject;
  end
  else
    with BorlandIDEServices as IOTAModuleServices do
      for I := 0 to ModuleCount - 1 do
        if Supports(Modules[I], IOTAProject, result) then
          Break;
end;

function GetCurrentProjectGroup(out ProjectGroup: IOTAProjectGroup): boolean;
var
  IModuleServices: IOTAModuleServices;
  IModule: IOTAModule;
  IProjectGroup: IOTAProjectGroup;
  I: integer;
begin
  result := false;
  ProjectGroup := nil;
  IModuleServices := BorlandIDEServices as IOTAModuleServices;
  for I := 0 to IModuleServices.ModuleCount - 1 do
  begin
    IModule := IModuleServices.Modules[I];
    if IModule.QueryInterface(IOTAProjectGroup, IProjectGroup) = S_OK then
    begin
      ProjectGroup := IProjectGroup;
      Break;
    end;
  end;
  result := assigned(ProjectGroup);
end;

function ModuleIsForm(Module: IOTAModule): boolean;
var
  I: integer;
  FormEdit: IOTAFormEditor;
begin
  result := false;
  if assigned(Module) then
  begin
    // Form Module will have a DFM and a PAS file associated with it
    if Module.GetModuleFileCount > 1 then
    begin
      I := 0;
      // See if one of the Editors is a FormEditor
      while (I < Module.GetModuleFileCount) and not result do
      begin
{$IFDEF COMPILER_6_UP}
        result := Succeeded(Module.ModuleFileEditors[I].QueryInterface
          (IOTAFormEditor, FormEdit));
{$ELSE}
        result := Succeeded(Module.GetModuleFileEditor(I)
          .QueryInterface(IOTAFormEditor, FormEdit));
{$ENDIF}
        Inc(I);
      end
    end
  end
end;

function ModuleIsProject(Module: IOTAModule): boolean;
var
  Project: IOTAProject;
begin
  result := false;
  if assigned(Module) then
    result := Succeeded(Module.QueryInterface(IOTAProject, Project))
end;

function ModuleIsProjectGroup(Module: IOTAModule): boolean;
var
  ProjectGroup: IOTAProjectGroup;
begin
  result := false;
  if assigned(Module) then
    result := Succeeded(Module.QueryInterface(IOTAProjectGroup, ProjectGroup))
end;

function ModuleIsTypeLib(Module: IOTAModule): boolean;
var
  TypeLib: IOTATypeLibModule;
begin
  result := false;
  if assigned(Module) then
    result := Succeeded(Module.QueryInterface(IOTATypeLibModule, TypeLib))
end;

function FormEditorFromForm(Module: IOTAModule): IOTAFormEditor;
var
  I: integer;
  Done: boolean;
begin
  result := nil;
  if ModuleIsForm(Module) then
  begin
    I := 0;
    Done := false;
    while (I < Module.GetModuleFileCount) and not Done do
    begin
{$IFDEF COMPILER_6_UP}
      Done := Succeeded(Module.ModuleFileEditors[I].QueryInterface
        (IOTAFormEditor, result));
{$ELSE}
      Done := Succeeded(Module.GetModuleFileEditor(I)
        .QueryInterface(IOTAFormEditor, result));
{$ENDIF}
      Inc(I);
    end;
  end
end;

function EditorIsFormEditor(Editor: IOTAEditor): boolean;
var
  FormEdit: IOTAFormEditor;
begin
  result := false;
  if assigned(Editor) then
    result := Succeeded(Editor.QueryInterface(IOTAFormEditor, FormEdit))
end;

function EditorIsProjectResEditor(Editor: IOTAEditor): boolean;
var
  ProjRes: IOTAProjectResource;
begin
  result := false;
  if assigned(Editor) then
    result := Succeeded(Editor.QueryInterface(IOTAProjectResource, ProjRes))
end;

function EditorIsTypeLibEditor(Editor: IOTAEditor): boolean;
var
  TypeLib: IOTATypeLibEditor;
begin
  result := false;
  if assigned(Editor) then
    result := Succeeded(Editor.QueryInterface(IOTATypeLibEditor, TypeLib))
end;

function EditorIsSourceEditor(Editor: IOTAEditor): boolean;
var
  SourceEdit: IOTASourceEditor;
begin
  result := false;
  if assigned(Editor) then
    result := Succeeded(Editor.QueryInterface(IOTASourceEditor, SourceEdit))
end;

function IsModule(Unk: IUnknown): boolean;
var
  Module: IOTAModule;
begin
  result := false;
  if assigned(Unk) then
    result := Succeeded(Unk.QueryInterface(IOTAModule, Module))
end;

function SetNameExists(ASetname: string): boolean;
var
  I: integer;
  s1, s2: string;
begin
  result := false;
  s1 := lowercase(trim(ASetname)) + '.Controller.pas';
  for I := 0 to (BorlandIDEServices as IOTAModuleServices).ModuleCount - 1 do
  begin
    s2 := extractFilename(lowercase((BorlandIDEServices as IOTAModuleServices)
      .Modules[I].FileName));
    if s1 = s2 then
    begin
      result := true;
      Break;
    end;
  end;
end;

end.
