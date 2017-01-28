unit eMVC.NewMVCPersistentWizard;

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
  System.Classes,
  eMVC.OTAUtilities,
  eMVC.projectcreator,
  eMVC.toolBox,
  eMVC.ViewCreator,
  eMVC.BaseCreator,
  eMVC.ControllerCreator,
  eMVC.ModelCreator,
  eMVC.PersistentModelCreator,
  eMVC.NewSetPersistentModelForm,
  ToolsApi;

type
  TNewMVCSetPersistentModelWizard = class(TNotifierObject, IOTAWizard,
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

function TNewMVCSetPersistentModelWizard.GetMenuText: string;
begin
  result := '&Novo PersistentModel MVCBr';
end;
{$ENDIF}

procedure TNewMVCSetPersistentModelWizard.Execute;
var
  path: string;
  project: string;
  Model: TPersistentModelCreator;

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
  function GetAncestorX(idx: integer): string;
  begin
    with TStringList.create do
      try
        text := ModelCodeExt;
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
  with TFormNewSetPersistentModel.create(nil) do
  begin
    if showModal = mrOK then
    begin
      setname := trim(edtSetname.text);

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

        Model := TPersistentModelCreator.create(path, setname, false);
        Model.IsFMX := cbFMX.Checked;
        Model.SetAncestorName(GetAncestorX(ComboBox1.ItemIndex));
        Model.Templates.AddPair('%intf',
          ComboBox1.Items.Names[ComboBox1.ItemIndex]);
        Model.Templates.AddPair('%modelType',
          GetModelType(ComboBox1.ItemIndex));
        Model.Templates.AddPair('%modelName',
          GetAncestorX(ComboBox1.ItemIndex));
        Model.Templates.AddPair('%class', ComboBox1.Items.ValueFromIndex
          [ComboBox1.ItemIndex]);
        if GetModelType(ComboBox1.ItemIndex) <> 'mtCommon' then
          Model.Templates.AddPair('//%uses', 'MVCBr.Model,');

        (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);






        Model := TPersistentModelCreator.create(path, setname, false);
        Model.IsFMX := cbFMX.Checked;
        Model.SetAncestorName(GetAncestorX(ComboBox1.ItemIndex));
        Model.Templates.AddPair('%intf',
          ComboBox1.Items.Names[ComboBox1.ItemIndex]);
        Model.Templates.AddPair('%modelType',
          GetModelType(ComboBox1.ItemIndex));
        Model.Templates.AddPair('%modelName',
          GetAncestorX(ComboBox1.ItemIndex));
        Model.Templates.AddPair('%class', ComboBox1.Items.ValueFromIndex
          [ComboBox1.ItemIndex]);
        if GetModelType(ComboBox1.ItemIndex) <> 'mtCommon' then
          Model.Templates.AddPair('//%uses', 'MVCBr.Model,');
        Model.isInterf := true;
        (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);

      end; // else
    end; // if
    free;
  end;
end;

function TNewMVCSetPersistentModelWizard.GetAuthor: string;
begin
  //
  // When Object Repository is in Detail mode used in the Author column
  //
  result := 'MVCBr'
end;

function TNewMVCSetPersistentModelWizard.GetComment: string;
begin
  //
  // When Object Repository is in Detail mode used in the Comment column
  //
  result := 'MVCBr Criar PersistentModel '
end;

function TNewMVCSetPersistentModelWizard.GetGlyph:
{$IFDEF COMPILER_6_UP}Cardinal{$ELSE}HICON{$ENDIF};
begin
  result := LoadIcon(hInstance, 'SAMPLEWIZARD');
end;

function TNewMVCSetPersistentModelWizard.GetIDString: string;
begin
  //
  // Unique name for the Wizard used internally by Delphi
  //
  result := 'MVCBr.MVCSetPersistentModelWizard';
end;

function TNewMVCSetPersistentModelWizard.GetName: string;
begin
  //
  // Name used for user messages and in the Object Repository if
  // implementing a IOTARepositoryWizard object
  //
  result := 'Novo MVCBr Set PersistentModel';
end;

function TNewMVCSetPersistentModelWizard.GetPage: string;
begin
  result := 'MVCBr'
end;

function TNewMVCSetPersistentModelWizard.GetState: TWizardState;
begin
  //
  // For Menu Item Wizards only
  //
  result := [wsEnabled];
end;

procedure Register;
begin
  RegisterPackageWizard(TNewMVCSetPersistentModelWizard.create);
end;

end.
