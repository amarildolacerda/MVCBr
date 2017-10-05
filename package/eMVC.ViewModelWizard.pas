unit eMVC.ViewModelWizard;

{ ********************************************************************** }
{ Copyright 2005 Reserved by Eazisoft.com }
{ File Name: ModelCreator.pas }
{ Author: Larry Le }
{ Description:  Wizard for create a MVC set }
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

{$I .\inc\Compilers.inc} // Compiler Defines

uses
  SysUtils, Windows, Controls, {$IFDEF DELPHI_5 }FileCtrl, {$ENDIF}
  eMVC.OTAUtilities,
  eMVC.projectcreator,
  eMVC.toolBox,
  eMVC.ViewCreator,
  eMVC.BaseCreator,
  eMVC.ControllerCreator,
  eMVC.ModelCreator,
  eMVC.ViewModelCreator,
  eMVC.ViewModelForm,
  ToolsApi;

{$I ./translate/translate.inc}

type
  TNewMVCViewModelWizard = class(TNotifierObject, IOTAWizard,
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

uses eMVC.FileCreator;
{ TNewMVCSetWizard }

{$IFDEF MENUDEBUG}

function TNewMVCSetWizard.GetMenuText: string;
begin
  result := '&Novo unit MVCBr';
end;
{$ENDIF}

procedure TNewMVCViewModelWizard.Execute;
var
  path: string;
  project: string;
  view: TViewCreator;
  viewModel: TViewModelCreator;
  Model: TModelCreator;
  Ctrl: TControllerCreator;

  function getProjectName: string;
  var
    i: integer;
  begin
    result := GetCurrentProject.FileName;
  end;

var
  LCriarPathModule: boolean;
  function GetNewPath(ASubPath: string): string;
  begin
    if LCriarPathModule then
      result := path
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

  Debug('NewMVCSetWizard: ' + path);

  with TFormNewSet.create(nil) do
  begin
    if showModal = mrOK then
    begin
      setname := trim(edtSetname.Text);

      if SetNameExists(setname) then
      begin
        eMVC.toolBox.showInfo(format(msgSorryFileExists, [setname]));
      end
      else
      begin
        LCriarPathModule := cbCreateDir.Checked;
        if cbCreateDir.Checked then
        begin
          if Folder <> '' then
            path := Folder + '\'
          else
            path := path + setname + '\'; // +GetUnitSubFolder(setname);
          if not directoryExists(path) then
            ForceDirectories(path);
        end;

        ChDir(extractFilePath(project));

        Ctrl := TControllerCreator.create(GetNewPath('Controllers'), setname,
          false, CreateModule, CreateView, ModelAlone, ViewAlone,
          trim(lowercase(edtClassName.Text)) = 'tform');
        if chFMX.Checked then
          Ctrl.baseProjectType := bptFMX;
        Ctrl.IsInterf := true;
        Ctrl.Templates.Values['%MdlInterf'] := setname + '.Controller.Interf';
        (BorlandIDEServices as IOTAModuleServices).CreateModule(Ctrl);

        Ctrl := TControllerCreator.create(GetNewPath('Controllers'), setname,
          false, CreateModule, CreateView, ModelAlone, ViewAlone,
          trim(lowercase(edtClassName.Text)) = 'tform');
        if chFMX.Checked then
        begin
          Ctrl.baseProjectType := bptFMX;
          Ctrl.Templates.Add('TFormFactory=TFMXFormFactory');
        end;
        Ctrl.IsInterf := false;
        Ctrl.Templates.Values['%MdlInterf'] := setname + '.Controller.Interf';
        if CreateView then
        begin
          Debug('Create controller for ViewModel');
          Ctrl.Templates.Values['//%view'] := ' '; // retira a marcacao
        end
        else
          Ctrl.Templates.Values['%view'] := ' '; // retira a marcacao

        if CreateViewModule then
        begin
          Ctrl.createViewModel := true;
        end
        else
          Ctrl.createViewModel := false;

        (BorlandIDEServices as IOTAModuleServices).CreateModule(Ctrl);

        if ViewAlone and CreateView then
        begin
          view := TViewCreator.create(GetNewPath('Views'), setname, false);
          if chFMX.Checked then
          begin
            view.baseProjectType := bptFMX;
            view.Templates.Add('TFormFactory=TFMXFormFactory');
          end;
          view.SetAncestorName(trim(edtClassName.Text));
          (BorlandIDEServices as IOTAModuleServices).CreateModule(view);
        end;

        if ModelAlone and CreateModule then
        begin
          Model := TModelCreator.create(GetNewPath('Models'), setname, false);
          if chFMX.Checked then
            Model.baseProjectType := bptFMX;
          Model.Templates.Add('%MdlInterf=' + setname + '.Model.Interf');
          (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);

          Model := TModelCreator.create(GetNewPath('Models'), setname, false);
          if chFMX.Checked then
          begin
            Model.baseProjectType := bptFMX;
            Model.Templates.Add('TFormFactory=TFMXFormFactory');
          end;
          Model.Templates.Add('%MdlInterf=' + setname + '.Model.Interf');
          Model.IsInterf := true;
          (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);
        end;

        if CreateViewModule then
        begin
          viewModel := TViewModelCreator.create(GetNewPath('ViewModels'),
            setname, false);
          viewModel.IsInterf := false;
          if chFMX.Checked then
          begin
            viewModel.baseProjectType := bptFMX;
            viewModel.Templates.Add('TFormFactory=TFMXFormFactory');
          end;
          viewModel.Templates.Add('%MdlInterf=' + setname +
            '.ViewModel.Interf');
          (BorlandIDEServices as IOTAModuleServices).CreateModule(viewModel);

          viewModel := TViewModelCreator.create(GetNewPath('ViewModels'),
            setname, false);
          viewModel.IsInterf := false;
          if chFMX.Checked then
          begin
            viewModel.baseProjectType := bptFMX;
            viewModel.Templates.Add('TFormFactory=TFMXFormFactory');
          end;
          viewModel.Templates.Add('%MdlInterf=' + setname +
            '.ViewModel.Interf');
          viewModel.IsInterf := true;
          (BorlandIDEServices as IOTAModuleServices).CreateModule(viewModel);
        end;

      end; // else
    end; // if
    free;
  end;
end;

function TNewMVCViewModelWizard.GetAuthor: string;
begin
  //
  // When Object Repository is in Detail mode used in the Author column
  //
  result := 'MVCBr'
end;

function TNewMVCViewModelWizard.GetComment: string;
begin
  //
  // When Object Repository is in Detail mode used in the Comment column
  //
  result := 'MVCBr Criar Nova View / ViewModel ou Model '
end;

function TNewMVCViewModelWizard.GetGlyph:
{$IFDEF COMPILER_6_UP}Cardinal{$ELSE}HICON{$ENDIF};
begin
  result := LoadIcon(hInstance, 'VIEW');
end;

function TNewMVCViewModelWizard.GetIDString: string;
begin
  //
  // Unique name for the Wizard used internally by Delphi
  //
  result := 'MVCBr.MVCSetWizard';
end;

function TNewMVCViewModelWizard.GetName: string;
begin
  //
  // Name used for user messages and in the Object Repository if
  // implementing a IOTARepositoryWizard object
  //
  result := '2. View';
end;

function TNewMVCViewModelWizard.GetPage: string;
begin
  result := 'MVCBr'
end;

function TNewMVCViewModelWizard.GetState: TWizardState;
begin
  //
  // For Menu Item Wizards only
  //
  result := [wsEnabled];
end;

procedure Register;
begin
  RegisterPackageWizard(TNewMVCViewModelWizard.create);
end;

end.
