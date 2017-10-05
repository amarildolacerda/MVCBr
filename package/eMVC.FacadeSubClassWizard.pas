unit eMVC.FacadeSubClassWizard;
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
  eMVC.toolBox,
  eMVC.BaseCreator,
  eMVC.FacadeSubClassForm,
  eMVC.FacadeSubClassCreator,
  DesignIntf,
  ToolsApi;

{$I .\translate\translate.inc}

type
  TNewMVCFacadeModelWizard = class(TNotifierObject, IOTAWizard,
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

uses eMVC.FileCreator;

{ TNewMVCSetWizard }

{$IFDEF MENUDEBUG}

function TNewMVCSetPersistentModelWizard.GetMenuText: string;
begin
  result := '&Facade Subclass MVCBr';
end;
{$ENDIF}

procedure TNewMVCFacadeModelWizard.Execute;
var
  path: string;
  project: string;
  Model: TFacadeSubClassCreator;
  identProject: string;
  LFacadeModelName: string;
  LFacadeCommand: string;
  function getProjectName: string;
  var
    i: integer;
  begin
    result := GetCurrentProject.FileName;
  end;

var
  LCriarPathModule: boolean;
  LPath: string;
  function GetNewPath(ASubPath: string): string;
  begin
    if LCriarPathModule then
      result := LPath +'\'
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
    eMVC.toolBox.showInfo(msgDontFindCreateProjectBefore);
    exit;
  end;
  path := extractFilePath(project);
  with TFormNewFacadeSubClass.create(nil) do
  begin
    edFolder.text := extractFilePath(project) + 'Facades';
    if showModal = mrOK then
    begin
      IsFMX := chFMX.Checked;
      setname := trim(edtSetname.text);
      identProject := stringReplace(setname, '.', '', [rfReplaceAll]);
      LFacadeModelName := edFacadeModel.text;
      LFacadeCommand := edFacadeCommand.text;
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

        Model := TFacadeSubClassCreator.create(GetNewPath('Facades'),
          setname + '', false);
        if chFMX.Checked then
          Model.baseProjectType := bptFMX;

        Model.Templates.add('%command=' + LFacadeCommand);
        Model.Templates.add('%facadeClass=' + LFacadeModelName);
        Model.Templates.add('%UnitIdent=' + setname);

        if IsFMX then
          Model.Templates.add('*.dfm=' + '*.fmx');

        (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);

      end; // else
    end; // if
    free;
  end;
end;

function TNewMVCFacadeModelWizard.GetAuthor: string;
begin
  //
  // When Object Repository is in Detail mode used in the Author column
  //
  result := 'MVCBr'
end;

function TNewMVCFacadeModelWizard.GetComment: string;
begin
  //
  // When Object Repository is in Detail mode used in the Comment column
  //
  result := 'MVCBr Criar Facede sub-class '
end;

function TNewMVCFacadeModelWizard.GetGlyph:
{$IFDEF COMPILER_6_UP}Cardinal{$ELSE}HICON{$ENDIF};
begin
  result := LoadIcon(hInstance, 'FACADESUBCLASS');
end;

function TNewMVCFacadeModelWizard.GetIDString: string;
begin
  //
  // Unique name for the Wizard used internally by Delphi
  //
  result := 'MVCBr.MVCSetFacadeSubClassWizard';
end;

function TNewMVCFacadeModelWizard.GetName: string;
begin
  //
  // Name used for user messages and in the Object Repository if
  // implementing a IOTARepositoryWizard object
  //
  result := '7. Facade Sub-Class';
end;

function TNewMVCFacadeModelWizard.GetPage: string;
begin
  result := 'MVCBr'
end;

function TNewMVCFacadeModelWizard.GetState: TWizardState;
begin
  //
  // For Menu Item Wizards only
  //
  result := [wsEnabled];
end;

procedure TNewMVCFacadeModelWizard.SetIsFMX(const Value: boolean);
begin
  FIsFMX := Value;
end;

procedure Register;
begin
  RegisterPackageWizard(TNewMVCFacadeModelWizard.create);

  { UnlistPublishedProperty(TModuleFactory, 'Font');
    UnlistPublishedProperty(TModuleFactory, 'ClientWidth');
    UnlistPublishedProperty(TModuleFactory, 'ClientHeight');
    UnlistPublishedProperty(TModuleFactory, 'Color');
    UnlistPublishedProperty(TModuleFactory, 'PixelsPerInch');
    UnlistPublishedProperty(TModuleFactory, 'TextHeight');
  }
end;

end.
