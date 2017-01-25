unit ProjectCreatorWizard;

interface

{$I Compilers.inc} // Compiler Defines
{$R OTAProjectWizardsEx.res} // Wizard Icons

uses
  SysUtils, Windows, Controls,
  OTAUtilities,
  projectcreator,
  FormCreator,
  DataModuleCreator,
  FrameCreator,
  ControllerCreator,
  ModelCreator,
  ToolsApi;

type
  TProjectCreatorWizard = class(TNotifierObject, IOTAWizard,
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

{ TProjectCreatorWizard }

{$IFDEF MENUDEBUG}

function TProjectCreatorWizard.GetMenuText: string;
begin
  result := '&Novo Projeto MVCBr ';
end;
{$ENDIF}


//
// Called when the Wizard is Selected in the ObjectRepository
//

procedure TProjectCreatorWizard.Execute;
//var
//  ProjectModule,
//    FormModule;
//    DataModule,
 //   FrameModule: IOTAModule;
 // FormEditor: IOTAFormEditor;
begin
  // First create the Project
  //ProjectModule :=
  (BorlandIDEServices as IOTAModuleServices).CreateModule(TProjectCreator.Create);
  // Now create a Form for the Project since the code added to the Project expects it.
  //FormModule :=
  (BorlandIDEServices as IOTAModuleServices).CreateModule(TFormCreator.Create);
  (BorlandIDEServices as IOTAModuleServices).CreateModule(TControllerCreator.Create);
  (BorlandIDEServices as IOTAModuleServices).CreateModule(TModelCreator.Create);

  // Now create a DataModue for the Project since the code added to the Project expects it.
  //DataModule := (BorlandIDEServices as IOTAModuleServices).CreateModule(TDataModuleCreator.Create);
  // Now create a DataModue for the Project since the code added to the Project expects it.
  //FrameModule := (BorlandIDEServices as IOTAModuleServices).CreateModule(TFrameCreator.Create);

  // Another way to get the FormEditor to create Components.  The TEdits are
  // created in the FormCreated method in TFormCreator.
//  FormEditor := FormEditorFromForm(FormModule);
//  if Assigned(FormEditor) then
//  begin
//    FormEditor.CreateComponent(nil, 'TButton', 10, 150, 56, 21);
//    FormEditor.CreateComponent(nil, 'TButton', 68, 150, 56, 21);
//  end

end;

function TProjectCreatorWizard.GetAuthor: string;
begin
  //
  // When Object Repository is in Detail mode used in the Author column
  //
  Result := 'MVCBr'
end;

function TProjectCreatorWizard.GetComment: string;
begin
  //
  // When Object Repository is in Detail mode used in the Comment column
  //
  Result := 'Assistente de criação projeto MVCBr'
end;

function TProjectCreatorWizard.GetGlyph: {$IFDEF COMPILER_6_UP}Cardinal{$ELSE}HICON{$ENDIF};
begin
  Result := LoadIcon(hInstance, 'SAMPLEWIZARD');
end;

function TProjectCreatorWizard.GetIDString: string;
begin
  //
  // Unique name for the Wizard used internally by Delphi
  //
  Result := 'MVCBr.ProjectCreatorWizard';
end;

function TProjectCreatorWizard.GetName: string;
begin
  //
  // Name used for user messages and in the Object Repository if
  // implementing a IOTARepositoryWizard object
  //
  Result := 'Assistente para criar projeto MVCBr';
end;

function TProjectCreatorWizard.GetPage: string;
begin
  Result := 'MVCBr'
end;

function TProjectCreatorWizard.GetState: TWizardState;
begin
  //
  // For Menu Item Wizards only
  //
  Result := [wsEnabled];
end;

procedure Register;
begin
  RegisterPackageWizard(TProjectCreatorWizard.Create);
end;

end.

