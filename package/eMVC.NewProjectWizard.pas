unit eMVC.NewProjectWizard;
{**********************************************************************}
{ Copyright 2005 Reserved by Eazisoft.com                              }
 { File Name: NewProjectWizard.pas                                     }
{ Author: Larry Le                                                     }
{ Description:  New  eMVC application wizard                           }
{                                                                      }
{ History:                                                             }
{ - 1.0, 19 May 2006                                                   }
{   First version                                                      }
{                                                                      }
{ Email: linfengle@gmail.com                                           }
{                                                                      }
{ The contents of this file are subject to the Mozilla Public License  }
{ Version 1.1 (the "License"); you may not use this file except in     }
{ compliance with the License. You may obtain a copy of the License at }
{ http://www.mozilla.org/MPL/                                          }
{                                                                      }
{ Software distributed under the License is distributed on an "AS IS"  }
{ basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See  }
{ the License for the specific language governing rights and           }
{ limitations under the License.                                       }
{                                                                      }
{ The Original Code is written in Delphi.                              }
{                                                                      }
{ The Initial Developer of the Original Code is Larry Le.              }
{ Copyright (C) eazisoft.com. All Rights Reserved.                     }
{                                                                      }
{**********************************************************************}


interface

{$I Compilers.inc} // Compiler Defines
{$R ProjectWizards.res} // Wizard Icons

uses
  SysUtils, Windows, Controls,
  eMVC.OTAUtilities,
  eMVC.projectcreator,
  eMVC.ViewCreator,
  eMVC.DataModuleCreator,
  eMVC.FrameCreator,
  eMVC.ControllerCreator,
  eMVC.ModelCreator,
  AppWizardForm,
  ToolsApi;

type
  TNewProjectWizard = class(TNotifierObject, IOTAWizard,
      IOTARepositoryWizard, IOTAProjectWizard{$IFDEF MENUDEBUG}, IOTAMenuWizard{$ENDIF})
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
  Model: TModelCreator;
  Ctrl: TControllerCreator;
begin
  // First create the Project
  //ProjectModule :=
  with TFormAppWizard.Create(nil) do
  begin
    OK := showModal = mrOK;
    if not ok then begin
      free;
      exit;
    end else
    begin
      appname := edtApp.text;
      if pos('.dpr', lowercase(appname)) <= 0 then
        appname := appname + '.dpr';
      path := trim(edtPath.text);
      if path[length(path) - 1] <> '\' then
        path := path + '\';
      free;
    end;
  end;

  project := TProjectCreator.Create;
  project.setFileName(path + appname);
  ProjectModule := (BorlandIDEServices as IOTAModuleServices).CreateModule(project);

  ctrl := TControllerCreator.Create(path, 'Main', false);
  (BorlandIDEServices as IOTAModuleServices).CreateModule(ctrl);

  model := TModelCreator.Create(path, 'Main', false);
  (BorlandIDEServices as IOTAModuleServices).CreateModule(model);

  // Now create a Form for the Project since the code added to the Project expects it.
  view := TViewCreator.Create(path, 'Main', false);
  (BorlandIDEServices as IOTAModuleServices).CreateModule(view);

  SetCurrentDir(path);
end;

function TNewProjectWizard.GetAuthor: string;
begin
  //
  // When Object Repository is in Detail mode used in the Author column
  //
  Result := 'MVCBr'
end;

function TNewProjectWizard.GetComment: string;
begin
  //
  // When Object Repository is in Detail mode used in the Comment column
  //
  Result := 'MVCBr Assistente para criar projeto'
end;

function TNewProjectWizard.GetGlyph: {$IFDEF COMPILER_6_UP}Cardinal{$ELSE}HICON{$ENDIF};
begin
  Result := LoadIcon(hInstance, 'SAMPLEWIZARD');
end;

function TNewProjectWizard.GetIDString: string;
begin
  //
  // Unique name for the Wizard used internally by Delphi
  //
  Result := 'MVCBr.ProjectCreatorWizard';
end;

function TNewProjectWizard.GetName: string;
begin
  //
  // Name used for user messages and in the Object Repository if
  // implementing a IOTARepositoryWizard object
  //
  Result := 'MVCBr Assistente para criar projeto';
end;

function TNewProjectWizard.GetPage: string;
begin
  Result := 'MVCBr'
end;

function TNewProjectWizard.GetState: TWizardState;
begin
  //
  // For Menu Item Wizards only
  //
  Result := [wsEnabled];
end;

procedure Register;
begin
  RegisterPackageWizard(TNewProjectWizard.Create);
end;

end.

