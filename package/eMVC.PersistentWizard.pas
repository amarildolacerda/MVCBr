unit eMVC.PersistentWizard;

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

{$I .\inc\Compilers.inc} // Compiler Defines

uses
  SysUtils, Windows, Controls, {$IFDEF DELPHI_5 }FileCtrl, {$ENDIF}
  System.Classes,
  eMVC.OTAUtilities,
  eMVC.projectcreator,
  eMVC.toolBox,
  eMVC.ViewCreator,
  eMVC.BaseCreator,
  eMVC.ControllerCreator,
  eMVC.ModelCreator,
  eMVC.PersistentModelCreator,
  eMVC.PersistentModelForm,
  ToolsApi;

{$I .\translate\translate.inc}

type
  TPersistentModelWizard = class(TNotifierObject, IOTAWizard,
    IOTARepositoryWizard, IOTAProjectWizard{$IFDEF MENUDEBUG},
    IOTAMenuWizard{$ENDIF})
    // IOTAWizard
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure Execute;
    // IOTARepositoryWizard
    function GetAuthor: string;
    function GetComment: string;
    function GetPage: string;
    function GetGlyph: {$IFDEF COMPILER_6_UP}Cardinal{$ELSE}HICON{$ENDIF};
{$IFDEF MENUDEBUG}
    function GetMenuText: string;
{$ENDIF}
  end;

procedure Register;

implementation

uses eMVC.PersistentModelConst, eMVC.FileCreator;

{ TNewMVCSetWizard }

{$IFDEF MENUDEBUG}

function TNewMVCSetPersistentModelWizard.GetMenuText: string;
begin
  result := '&Model MVCBr';
end;
{$ENDIF}

procedure TPersistentModelWizard.Execute;
var
  path: string;
  project: string;
  Model: TPersistentModelCreator;
  identProject: string;

  function getProjectName: string;
  var
    i: integer;
  begin
    result := GetCurrentProject.FileName;
  end;
  function GetAncestorX(idx: integer): string;
  begin
    with TStringList.create do
      try
        text := ModelCodeAncestor;
        result := Strings[idx];
      finally
        free;
      end;
  end;
  function GetModelType(idx: integer): string;
  begin
    with TStringList.create do
      try
        text := ModelCodeType;
        result := Strings[idx];
      finally
        free;
      end;
  end;
// %Interf
  function GetModelUses(idx: integer): string;
  begin
    with TStringList.create do
      try
        text := ModelUses;
        result := Strings[idx];
      finally
        free;
      end;
  end;

// %modelInher
  function GetModelInher(idx: integer): string;
  begin
    with TStringList.create do
      try
        text := ModelInherited;
        result := Strings[idx];
      finally
        free;
      end;
  end;

var
  LCriarPathModule: boolean;
  LPath:string;
  function GetNewPath(ASubPath: string): string;
  begin
    if LCriarPathModule then
      result := LPath+'\'
    else
    begin
      result := extractFilePath(project);
      if ((result + ' ')[length(result)]) <> '\' then
        result := result + '\';
      result := result + ASubPath + '\';
    end;
    if not directoryExists(result) then
      ForceDirectories(result);
  end;

begin
  project := getProjectName;
  // project := (BorlandIDEServices as IOTAModuleServices).GetActiveProject;
  if project = '' then
  begin
    eMVC.toolBox.showInfo(msgDontFindCreateProjectBefore);
    exit;
  end;
  path := extractFilePath(project);
  with TFormNewSetPersistentModel.create(nil) do
  begin
    edFolder.text := extractFilePath(project)+'Models';
    if showModal = mrOK then
    begin
      setname := trim(edtSetname.text);
      identProject := stringReplace(setname, '.', '', [rfReplaceAll]);

      if SetNameExists(setname) then
      begin
        eMVC.toolBox.showInfo(format(msgSorryFileExists, [setname]));
      end
      else
      begin
        LCriarPathModule := cbCreateDir.Checked;
        LPath := edFolder.text;
        if cbCreateDir.Checked then
        begin
          path := path + (setname) + '\';
          if not directoryExists(path) then
            ForceDirectories(path);
        end;

        ChDir(extractFilePath(project));

        debug('Pronto para criar o Modulo');
        Model := TPersistentModelCreator.create(GetNewPath('Models'),
          identProject, false);
        if cbFMX.Checked then
          Model.baseProjectType := bptFMX;
        // Model.SetAncestorName(GetAncestorX(ComboBox1.ItemIndex));
        Model.Templates.Add('%intf=' + ComboBox1.Items.Names
          [ComboBox1.ItemIndex]);
        Model.Templates.Add('%modelType=' + GetModelType(ComboBox1.ItemIndex));
        Model.Templates.Add('%modelName=' + GetAncestorX(ComboBox1.ItemIndex));
        Model.Templates.Add('%class=' + ComboBox1.Items.ValueFromIndex
          [ComboBox1.ItemIndex]);
        Model.Templates.Add('//%uses=' + GetModelUses(ComboBox1.ItemIndex));
        Model.Templates.Add('%UnitBase=' + setname);

        Model.Templates.Add('%interfInherited=' +
          GetModelInher(ComboBox1.ItemIndex));
        Model.isInterf := false;

        (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);

        debug('Criou o Model');

        Model := TPersistentModelCreator.create(GetNewPath('Models'),
          identProject, false);
        if cbFMX.Checked then
          Model.baseProjectType := bptFMX;
        // Model.SetAncestorName(GetAncestorX(ComboBox1.ItemIndex));

        Model.Templates.Add('%intf=' + ComboBox1.Items.Names
          [ComboBox1.ItemIndex]);

        Model.Templates.Add('%interfInherited=' +
          GetModelInher(ComboBox1.ItemIndex));

        Model.Templates.Add('%modelType=' + GetModelType(ComboBox1.ItemIndex));
        Model.Templates.Add('%modelName=' + GetAncestorX(ComboBox1.ItemIndex));
        Model.Templates.Add('%class=' + ComboBox1.Items.ValueFromIndex
          [ComboBox1.ItemIndex]);
        Model.Templates.Add('//%uses=' + GetModelUses(ComboBox1.ItemIndex));
        Model.Templates.Add('%UnitBase=' + setname + '.interf');

        Model.isInterf := true;
        (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);

        debug('Criou o Model Interf');

      end; // else
    end; // if
    free;
  end;
end;

function TPersistentModelWizard.GetAuthor: string;
begin
  //
  // When Object Repository is in Detail mode used in the Author column
  //
  result := 'MVCBr'
end;

function TPersistentModelWizard.GetComment: string;
begin
  //
  // When Object Repository is in Detail mode used in the Comment column
  //
  result := 'MVCBr Criar Model '
end;

function TPersistentModelWizard.GetGlyph:
{$IFDEF COMPILER_6_UP}Cardinal{$ELSE}HICON{$ENDIF};
begin
  result := LoadIcon(hInstance, 'MODEL');
end;

function TPersistentModelWizard.GetIDString: string;
begin
  //
  // Unique name for the Wizard used internally by Delphi
  //
  result := 'MVCBr.MVCSetPersistentModelWizard';
end;

function TPersistentModelWizard.GetName: string;
begin
  //
  // Name used for user messages and in the Object Repository if
  // implementing a IOTARepositoryWizard object
  //
  result := '3. Models';
end;

function TPersistentModelWizard.GetPage: string;
begin
  result := 'MVCBr'
end;

function TPersistentModelWizard.GetState: TWizardState;
begin
  //
  // For Menu Item Wizards only
  //
  result := [wsEnabled];
end;

procedure Register;
begin
  RegisterPackageWizard(TPersistentModelWizard.create);
end;

end.
