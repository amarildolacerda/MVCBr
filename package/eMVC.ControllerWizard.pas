unit eMVC.ControllerWizard;

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
  System.SysUtils, Windows, Controls, {$IFDEF DELPHI_5 }FileCtrl, {$ENDIF}
  System.Classes,
  eMVC.OTAUtilities,
  eMVC.projectcreator,
  eMVC.toolBox,
  eMVC.ViewCreator,
  eMVC.BaseCreator,
  eMVC.ControllerCreator,
  eMVC.ModelCreator,
  eMVC.ModuleModelCreator,
  eMVC.ControllerForm,
  DesignIntf,
  ToolsApi;

{$I .\translate\translate.inc}


type
  TNewMVCSetControllerWizard = class(TNotifierObject, IOTAWizard,
    IOTARepositoryWizard, IOTAProjectWizard{$IFDEF MENUDEBUG},
    IOTAMenuWizard{$ENDIF})
  private
    FIsFMX: boolean;
    procedure SetIsFMX(const Value: boolean);
  published
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
    property IsFMX: boolean read FIsFMX write SetIsFMX;
  end;

procedure Register;

implementation

uses eMVC.ModuleModelConst, eMVC.FileCreator;

{ TNewMVCSetWizard }

{$IFDEF MENUDEBUG}

function TNewMVCSetPersistentModelWizard.GetMenuText: string;
begin
  result := '&Controller MVCBr';
end;
{$ENDIF}

procedure TNewMVCSetControllerWizard.Execute;
var
  path: string;
  project: string;
  Ctrl: TControllerCreator;
  identProject: string;

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
  if project = '' then
  begin
    eMVC.toolBox.showInfo
      (msgDontFindCreateProjectBefore);
    exit;
  end;
  path := extractFilePath(project);
  with TFormNewController.create(nil) do
  begin
    if showModal = mrOK then
    begin
      IsFMX := cbFMX.Checked;
      setname := trim(edtSetname.text);
      identProject := stringReplace(setname, '.', '', [rfReplaceAll]);
      if SetNameExists(setname) then
      begin
        eMVC.toolBox.showInfo(format(msgSorryFileExists, [setname]));
      end
      else
      begin
        LCriarPathModule := cbCreateDir.Checked;
        if cbCreateDir.Checked then
        begin
          path := path + (setname) + '\';
          if not directoryExists(path) then
            ForceDirectories(path);
        end;

        ChDir(extractFilePath(project));

        debug('Pronto para criar o Modulo');

        Ctrl := TControllerCreator.create(GetNewPath('Controllers'),
          setname + '', false, false, false, true, true, false);
        if cbFMX.Checked then
          Ctrl.baseProjectType := bptFMX;
        // Model.SetAncestorName(GetAncestorX(ComboBox1.ItemIndex));
        Ctrl.Templates.Add('%intf=' + ComboBox1.Items.Names
          [ComboBox1.ItemIndex]);
        // Ctrl.Templates.AddPair('%modelType',
        // GetModelType(ComboBox1.ItemIndex));
        // Ctrl.Templates.AddPair('%modelName',
        // GetAncestorX(ComboBox1.ItemIndex));
        Ctrl.Templates.Add('%class=' + ComboBox1.Items.ValueFromIndex
          [ComboBox1.ItemIndex]);
        // Ctrl.Templates.AddPair('//%uses', GetModelUses(ComboBox1.ItemIndex));

        // Ctrl.Templates.AddPair('%interfInherited',
        // GetModelInher(ComboBox1.ItemIndex));

        // if IsFMX then
        // Ctrl.Templates.AddPair('*.dfm', '*.fmx');
        Ctrl.Templates.Add('%UnitBase=' + setname);
        Ctrl.IsInterf := true;
        Ctrl.Templates.Add('%MdlInterf=' + setname + '.Controller.Interf');
        (BorlandIDEServices as IOTAModuleServices).CreateModule(Ctrl);

        Ctrl := TControllerCreator.create(GetNewPath('Controllers'),
          setname + '', false, false, false, true, true, false);
        if cbFMX.Checked then
          Ctrl.baseProjectType := bptFMX;
        // Model.SetAncestorName(GetAncestorX(ComboBox1.ItemIndex));
        Ctrl.Templates.Add('%intf=' + ComboBox1.Items.Names
          [ComboBox1.ItemIndex]);
        // Ctrl.Templates.AddPair('%modelType',
        // GetModelType(ComboBox1.ItemIndex));
        // Ctrl.Templates.AddPair('%modelName',
        // GetAncestorX(ComboBox1.ItemIndex));
        Ctrl.Templates.Add('%class=' + ComboBox1.Items.ValueFromIndex
          [ComboBox1.ItemIndex]);
        // Ctrl.Templates.AddPair('//%uses', GetModelUses(ComboBox1.ItemIndex));

        // Ctrl.Templates.AddPair('%interfInherited',
        // GetModelInher(ComboBox1.ItemIndex));

        // if IsFMX then
        // Ctrl.Templates.AddPair('*.dfm', '*.fmx');
        Ctrl.Templates.Add('%UnitBase=' + setname);
        Ctrl.Templates.values['//viewmodelUses'] := ' ';

        (BorlandIDEServices as IOTAModuleServices).CreateModule(Ctrl);

        debug('Criou o Controller');

      end; // else
    end; // if
    free;
  end;
end;

function TNewMVCSetControllerWizard.GetAuthor: string;
begin
  //
  // When Object Repository is in Detail mode used in the Author column
  //
  result := 'MVCBr'
end;

function TNewMVCSetControllerWizard.GetComment: string;
begin
  //
  // When Object Repository is in Detail mode used in the Comment column
  //
  result := 'MVCBr Criar Controller '
end;

function TNewMVCSetControllerWizard.GetGlyph:
{$IFDEF COMPILER_6_UP}Cardinal{$ELSE}HICON{$ENDIF};
begin
  result := LoadIcon(hInstance, 'CONTROLLER');
end;

function TNewMVCSetControllerWizard.GetIDString: string;
begin
  //
  // Unique name for the Wizard used internally by Delphi
  //
  result := 'MVCBr.MVCSetControllerWizard';
end;

function TNewMVCSetControllerWizard.GetName: string;
begin
  //
  // Name used for user messages and in the Object Repository if
  // implementing a IOTARepositoryWizard object
  //
  result := '5. Controller';
end;

function TNewMVCSetControllerWizard.GetPage: string;
begin
  result := 'MVCBr'
end;

function TNewMVCSetControllerWizard.GetState: TWizardState;
begin
  //
  // For Menu Item Wizards only
  //
  result := [wsEnabled];
end;

procedure TNewMVCSetControllerWizard.SetIsFMX(const Value: boolean);
begin
  FIsFMX := Value;
end;

procedure Register;
begin
  RegisterPackageWizard(TNewMVCSetControllerWizard.create);

  { UnlistPublishedProperty(TModuleFactory, 'Font');
    UnlistPublishedProperty(TModuleFactory, 'ClientWidth');
    UnlistPublishedProperty(TModuleFactory, 'ClientHeight');
    UnlistPublishedProperty(TModuleFactory, 'Color');
    UnlistPublishedProperty(TModuleFactory, 'PixelsPerInch');
    UnlistPublishedProperty(TModuleFactory, 'TextHeight');
  }
end;

end.
