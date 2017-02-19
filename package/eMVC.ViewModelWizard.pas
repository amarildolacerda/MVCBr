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
    result := '';
    for i := 0 to (BorlandIDEServices as IOTAModuleServices).ModuleCount - 1 do
    begin
      if pos('.dpr', lowercase((BorlandIDEServices as IOTAModuleServices)
        .Modules[i].FileName)) > 0 then
      begin
        result := (BorlandIDEServices as IOTAModuleServices).Modules[i]
          .FileName;
        break;
      end;
    end;
  end;

begin
  project := getProjectName;
  // project := (BorlandIDEServices as IOTAModuleServices).GetActiveProject;
  if project = '' then
  begin
    eMVC.toolBox.showInfo
      ('Não encontrei o projeto MVCBr, criar um projeto antes!');
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
        eMVC.toolBox.showInfo('Desculpe, o projeto "' + setname +
          '" já existe!');
      end
      else
      begin
        if cbCreateDir.Checked then
        begin
          path := path + setname + '\';
          if not directoryExists(path) then
            ForceDirectories(path);
        end;

        ChDir(extractFilePath(project));

        Ctrl := TControllerCreator.create(path, setname, false, CreateModule,
          CreateView, ModelAlone, ViewAlone, trim(lowercase(edtClassName.Text))
          = 'tform');
        Ctrl.IsFMX := chFMX.Checked;
        Ctrl.IsInterf := true;
        Ctrl.Templates.AddPair('%MdlInterf', setname + '.Controller.Interf');
        (BorlandIDEServices as IOTAModuleServices).CreateModule(Ctrl);

        Ctrl := TControllerCreator.create(path, setname, false, CreateModule,
          CreateView, ModelAlone, ViewAlone, trim(lowercase(edtClassName.Text))
          = 'tform');
        Ctrl.IsFMX := chFMX.Checked;
        Ctrl.IsInterf := false;
        Ctrl.Templates.AddPair('%MdlInterf', setname + '.Controller.Interf');
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
          view := TViewCreator.create(path, setname, false);
          view.IsFMX := chFMX.Checked;
          view.SetAncestorName(trim(edtClassName.Text));
          (BorlandIDEServices as IOTAModuleServices).CreateModule(view);
        end;

        if ModelAlone and CreateModule then
        begin
          Model := TModelCreator.create(path, setname, false);
          Model.IsFMX := chFMX.Checked;
          Model.Templates.AddPair('%MdlInterf', setname + '.Model.Interf');
          (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);

          Model := TModelCreator.create(path, setname, false);
          Model.IsFMX := chFMX.Checked;
          Model.Templates.AddPair('%MdlInterf', setname + '.Model.Interf');
          Model.IsInterf := true;
          (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);
        end;

        if CreateViewModule then
        begin
          viewModel := TViewModelCreator.create(path, setname, false);
          viewModel.IsInterf := false;
          viewModel.IsFMX := chFMX.Checked;
          viewModel.Templates.AddPair('%MdlInterf',
            setname + '.ViewModel.Interf');
          (BorlandIDEServices as IOTAModuleServices).CreateModule(viewModel);

          viewModel := TViewModelCreator.create(path, setname, false);
          viewModel.IsInterf := false;
          viewModel.IsFMX := chFMX.Checked;
          viewModel.Templates.AddPair('%MdlInterf',
            setname + '.ViewModel.Interf');
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
  result := LoadIcon(hInstance, 'SAMPLEWIZARD');
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
