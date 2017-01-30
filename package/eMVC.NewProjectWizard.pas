unit eMVC.NewProjectWizard;
{ ********************************************************************** }
{ Copyright 2005 Reserved by Eazisoft.com }
{ File Name: NewProjectWizard.pas }
{ Author: Larry Le }
{ Description:  New  eMVC application wizard }
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
{$R .\inc\ProjectWizards.res} // Wizard Icons

uses
  SysUtils, Windows, Controls,
  eMVC.OTAUtilities,
  eMVC.projectcreator,
  eMVC.ViewCreator,
  eMVC.DataModuleCreator,
  eMVC.FrameCreator,
  eMVC.ControllerCreator,
  eMVC.ModelCreator,
  eMVC.ViewModelCreator,
  eMVC.AppWizardForm,
  eMVC.ProjectGroupCreator,
  eMVC.IncludeCreator,
  Dialogs,
  ToolsApi;

type
  TNewProjectWizard = class(TNotifierObject, IOTAWizard, IOTARepositoryWizard,
    IOTAProjectWizard{$IFDEF MENUDEBUG}, IOTAMenuWizard{$ENDIF})
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

{ TNewProjectWizard }

{$IFDEF MENUDEBUG}

function TNewProjectWizard.GetMenuText: string;
begin
  result := '&Novo projeto MVCBr';
end;
{$ENDIF}
//
// Called when the Wizard is Selected in the ObjectRepository
//

procedure TNewProjectWizard.Execute;
var
  ProjectModule: IOTAModule;
  OK: Boolean;
  path, appname: string;
  project: TProjectCreator;
  view: TViewCreator;
  Model: TViewModelCreator;
  ModelInterf: TViewModelCreator;
  Ctrl: TControllerCreator;
  incl:TIncludeCreator;
  AFMX: Boolean;
  pg: IOTAProjectGroup;
  PGModel:TBDSProjectGroupCreator;
begin
  // First create the Project
  // ProjectModule :=
  with TFormAppWizard.Create(nil) do
  begin
    OK := showModal = mrOK;
    if not OK then
    begin
      free;
      exit;
    end
    else
    begin
      AFMX := cbFMX.Checked;
      appname := edtApp.text;
      if pos('.dpr', lowercase(appname)) <= 0 then
        appname := appname + '.dpr';
      debug('AppName: '+appname);
      path := trim(edtPath.text);
      if path[length(path) - 1] <> '\' then
        path := path + '\';
      free;
    end;
  end;

  try
    if not GetCurrentProjectGroup(pg) then
    begin
      debug('Criar ProjectGroup');
      // created project group
      try
      PGModel := TBDSProjectGroupCreator.Create;
      PGModel.Path := path;
      except
         on e:Exception do
            raise Exception.Create('Error Message: '+e.message);
      end;
      (BorlandIDEServices as IOTAModuleServices)
        .CreateModule(  PGModel );

    end;
  except
    on e: Exception do
      debug('Erro (Group): ' + e.message);
  end;

  if not GetCurrentProjectGroup(pg) then
  begin
    raise Exception.Create
      ('Opps, que vergonha - não consegui criar um ProjectGroup automático... Necessário ter um ProjectGroup criado');
  end
  else
    debug('ProjectGroup Iniciado: ' + pg.FileName);

  try
    project := TProjectCreator.Create;
    project.isFMX := AFMX;
    project.setFileName(path + appname);
    ProjectModule := (BorlandIDEServices as IOTAModuleServices)
      .CreateModule(project);

  except
    on e: Exception do
      debug('Erro (Project): ' + e.message);

  end;
  try
  debug('AppWizard: ' +  path + appname);

  incl:=TIncludeCreator.Create(path,'Main',false);
  incl.IsFMX := AFMX;
  (BorlandIDEServices as IOTAModuleServices).CreateModule(incl);

  Ctrl := TControllerCreator.Create(path, 'Main', false);
  debug('Main Controller Creator');
  Ctrl.Templates.AddPair('//ViewModelInit',
    'result.add( TMainViewModel.new(self));');
  Ctrl.isFMX := AFMX;
  (BorlandIDEServices as IOTAModuleServices).CreateModule(Ctrl);

  ModelInterf := TViewModelCreator.Create(path, 'Main', false);
  ModelInterf.isInterf := true;
  ModelInterf.isFMX := AFMX;
  (BorlandIDEServices as IOTAModuleServices).CreateModule(ModelInterf);

  Model := TViewModelCreator.Create(path, 'Main', false);
  Model.isFMX := AFMX;
  Model.Templates.AddPair('%MdlInterf', 'Main.ViewModel.Interf');

  (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);

  // Now create a Form for the Project since the code added to the Project expects it.
  view := TViewCreator.Create(path, 'Main', false);
  view.isFMX := AFMX;
  (BorlandIDEServices as IOTAModuleServices).CreateModule(view);

  SetCurrentDir(path);
  except
     on e:Exception do
        debug(e.message);
  end;
end;

function TNewProjectWizard.GetAuthor: string;
begin
  //
  // When Object Repository is in Detail mode used in the Author column
  //
  result := 'MVCBr'
end;

function TNewProjectWizard.GetComment: string;
begin
  //
  // When Object Repository is in Detail mode used in the Comment column
  //
  result := 'MVCBr Assistente para criar projeto'
end;

function TNewProjectWizard.GetGlyph:
{$IFDEF COMPILER_6_UP}Cardinal{$ELSE}HICON{$ENDIF};
begin
  result := LoadIcon(hInstance, 'SAMPLEWIZARD');
end;

function TNewProjectWizard.GetIDString: string;
begin
  //
  // Unique name for the Wizard used internally by Delphi
  //
  result := 'MVCBr.ProjectCreatorWizard';
end;

function TNewProjectWizard.GetName: string;
begin
  //
  // Name used for user messages and in the Object Repository if
  // implementing a IOTARepositoryWizard object
  //
  result := '1. Projeto MVCBr';
end;

function TNewProjectWizard.GetPage: string;
begin
  result := 'MVCBr'
end;

function TNewProjectWizard.GetState: TWizardState;
begin
  //
  // For Menu Item Wizards only
  //
  result := [wsEnabled];
end;

procedure Register;
begin
  RegisterPackageWizard(TNewProjectWizard.Create);
end;

end.
