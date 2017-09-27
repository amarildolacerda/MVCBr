unit eMVC.ClassModelWizard;

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
  eMVC.ClassModelCreator,
  eMVC.ClassModelForm,
  DesignIntf,
  ToolsApi;

{$I .\translate\translate.inc}

type
  TClassModelWizard = class(TNotifierObject, IOTAWizard, IOTARepositoryWizard,
    IOTAProjectWizard{$IFDEF MENUDEBUG}, IOTAMenuWizard{$ENDIF})
  private
    FIsFMX: boolean;
    FClassesLists: string;
    procedure SetIsFMX(const Value: boolean);
    procedure FillClasses(sPas: String; Lista: TStrings);
    procedure FillMethods(sClass: string; ListaMethds, Prop: TStrings);
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

uses eMVC.ModuleModelConst, eMVC.ViewModelCreator;

{ TNewMVCSetWizard }

{$IFDEF MENUDEBUG}

function TNewMVCSetPersistentModelWizard.GetMenuText: string;
begin
  result := '&Class Model MVCBr';
end;
{$ENDIF}

procedure TClassModelWizard.FillMethods(sClass: string; ListaMethds: TStrings;
  Prop: TStrings);
var
  str: TStringList;
  s: string;
  i: integer;
begin
  str := TStringList.create;
  try
    s := copy(FClassesLists, pos(sClass, FClassesLists), length(FClassesLists));
    // procurar o end;
    s := copy(s, 1, pos('end;', lowercase(s)) + 4);
    for i := 0 to str.count - 1 do
    begin
      s := TrimLeft(TrimRight(str[i]));
      if s = '' then
        continue;

      // separar os methods

      // separar as propriedades;

    end;
  finally
    str.free;
  end;

end;

procedure TClassModelWizard.FillClasses(sPas: String; Lista: TStrings);
var
  str: TStringList;
  s: String;
  i: integer;
begin
  Lista.clear;
  if not fileExists(sPas) then
    Exit;

  str := TStringList.create;
  try
    str.LoadFromFile(sPas);
    while str.count > 0 do
    begin
      if pos('type', lowercase(trim(str[0]))) > 0 then
      begin
        str.delete(0);
        break
      end;
      str.delete(0);
    end;

    str.text := copy(str.text, 1, pos('implementation', str.text));
    FClassesLists := str.text;

    for i := str.count - 1 downto 0 do
    begin
      s := lowercase(str[i]);
      if pos('class', s) = 0 then
        str.delete(i)
      else if pos('=', s) = 0 then
        str.delete(i)
      else
      begin
        str[i] := TrimRight(TrimLeft((copy(str[i], 1, pos('=', str[i]) - 1))));
        if pos(' ', str[i]) > 0 then
          str.delete(i);
      end;
    end;

    for s in str do
    begin
      Lista.add(s);
    end;

    debug('TNewClassModelWizard.FillClasses: ' + str.count.toString);

  finally
    str.free;
  end;

end;

procedure TClassModelWizard.Execute;
var
  isViewModel: boolean;
  isController: boolean;
  s, path: string;
  setName: string;
  project: string;
  identProject: string;
  FInterfImplem: string;
  FCodeInterf: string;
  i: TFormClassModel;

  function getProjectName: string;
  var
    i: integer;
  begin
    result := GetCurrentProject.FileName;
  end;
  var LCriarPathModule:boolean;
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


  function GetUnitCorrente: string;
  var
    i: integer;
  begin
    result := '';
    If BorlandIDEServices = Nil Then
      Exit;
    result := (BorlandIDEServices as IOTAModuleServices).CurrentModule.FileName;
    if not sameText(ExtractFileExt(result), '.pas') then
      result := '';
  end;

var
  cbClassNameText: string;
  edUnitText: string;

  function ExtractNameBased(s: string): String;
  begin
    if pos('<', s) > 0 then
      s := copy(s, 1, pos('<', s) - 1);
    if s[1] = 'T' then
      s := copy(s, 2, length(s));
    result := s;
  end;

  procedure CriarController;
  var
    Model: TClassModelCreator;
  begin
    debug('Pronto para criar o Controller');
    Model := TClassModelCreator.create(GetNewPath('Models'), setName, false);
    Model.templates.add('//InterfImplem=' + FInterfImplem);
    Model.templates.add('//InterfCode=' + FCodeInterf);
    Model.templates.add('%UnitBase=' + setName);

    Model.templates.add('%ClassConector=' + cbClassNameText);
    s := ExtractNameBased(cbClassNameText) + 'Base';
    Model.templates.add('%ClassModel=' + s);
    s := ExtractFileName(edUnitText);
    s := copy(s, 1, pos(ExtractFileExt(s), s) - 1);
    Model.templates.add('%ClassUnit=' + s);
    Model.isController := true;

    (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);

    debug('Criou o Model');

    Model := TClassModelCreator.create(GetNewPath('Models'), setName, false);
    Model.templates.add('//InterfImplem=' + FInterfImplem);
    Model.templates.add('//InterfCode=' + FCodeInterf);
    Model.templates.add('%UnitBase=' + setName);

    Model.templates.add('%ClassConector=' + cbClassNameText);
    s := ExtractNameBased(cbClassNameText) + 'Base';
    Model.templates.add('%ClassModel=' + s);
    s := ExtractFileName(edUnitText);
    s := copy(s, 1, pos(ExtractFileExt(s), s) - 1);
    Model.templates.add('%ClassUnit=' + s);
    Model.isController := true;

    Model.isInterf := true;
    (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);

    debug('Criou o Model Interf');

  end;
  procedure CriarModel;
  var
    Model: TClassModelCreator;
  begin
    debug('Pronto para criar o Modulo');
    Model := TClassModelCreator.create(GetNewPath('Models'), setName, false);
    Model.templates.add('//InterfImplem=' + FInterfImplem);
    Model.templates.add('//InterfCode=' + FCodeInterf);
    Model.templates.add('%UnitBase=' + setName);

    Model.templates.add('%ClassConector=' + cbClassNameText);
    s := ExtractNameBased(cbClassNameText) + 'Base';
    Model.templates.add('%ClassModel=' + s);
    s := ExtractFileName(edUnitText);
    s := copy(s, 1, pos(ExtractFileExt(s), s) - 1);
    Model.templates.add('%ClassUnit=' + s);

    (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);

    debug('Criou o Model');

    Model := TClassModelCreator.create(GetNewPath('Models'), setName, false);
    Model.templates.add('//InterfImplem=' + FInterfImplem);
    Model.templates.add('//InterfCode=' + FCodeInterf);
    Model.templates.add('%UnitBase=' + setName);

    Model.templates.add('%ClassConector=' + cbClassNameText);
    s := ExtractNameBased(cbClassNameText) + 'Base';
    Model.templates.add('%ClassModel=' + s);
    s := ExtractFileName(edUnitText);
    s := copy(s, 1, pos(ExtractFileExt(s), s) - 1);
    Model.templates.add('%ClassUnit=' + s);

    Model.isInterf := true;
    (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);

    debug('Criou o Model Interf');

  end;

  procedure CriarViewModel();
  var
    ViewModel: TClassModelCreator;
  begin
    debug('Pronto para criar o Modulo');
    ViewModel := TClassModelCreator.create(GetNewPath('ViewModels'), setName, false);
    ViewModel.isViewModel := true;
    ViewModel.SetAncestorName('ViewModel');
    ViewModel.templates.add('//InterfImplem=' + FInterfImplem);
    ViewModel.templates.add('//InterfCode=' + FCodeInterf);

    ViewModel.templates.add('%UnitBase=' + setName);

    ViewModel.templates.add('%ClassConector=' + cbClassNameText);
    s := ExtractNameBased(cbClassNameText) + 'Base';
    ViewModel.templates.add('%ClassModel=' + s);
    s := ExtractFileName(edUnitText);
    s := copy(s, 1, pos(ExtractFileExt(s), s) - 1);
    ViewModel.templates.add('%ClassUnit=' + s);

    (BorlandIDEServices as IOTAModuleServices).CreateModule(ViewModel);

    debug('Criou o Model');

    ViewModel := TClassModelCreator.create(GetNewPath('ViewModels'), setName, false);
    ViewModel.isViewModel := true;
    ViewModel.SetAncestorName('ViewModel');
    ViewModel.templates.add('//InterfImplem=' + FInterfImplem);
    ViewModel.templates.add('//InterfCode=' + FCodeInterf);
    ViewModel.templates.add('%UnitBase=' + setName);

    ViewModel.templates.add('%ClassConector=' + cbClassNameText);
    s := ExtractNameBased(cbClassNameText) + 'Base';
    ViewModel.templates.add('%ClassModel=' + s);
    s := ExtractFileName(edUnitText);
    s := copy(s, 1, pos(ExtractFileExt(s), s) - 1);
    ViewModel.templates.add('%ClassUnit=' + s);

    ViewModel.isInterf := true;
    (BorlandIDEServices as IOTAModuleServices).CreateModule(ViewModel);

    debug('Criou o Model Interf');

  end;

var
  n: integer;
begin
  project := getProjectName;
  if project = '' then
  begin
    eMVC.toolBox.showInfo
      ('Não encontrei o projeto MVCBr, criar um projeto antes!');
    Exit;
  end;
  path := extractFilePath(project);
  with TFormClassModel.create(nil) do
  begin
    edUnit.text := GetUnitCorrente;
    FillListClassesProc := procedure
      begin
        FillClasses(edUnit.text, cbClassName.items);
        SetClassesList(FClassesLists,
          procedure
          begin
            // FillMethods(edModelName.text, clMetodos.items, clPropriedades.items);
          end);
      end;
    edFolder.text := path+'Models';
    if showModal = mrOK then
    begin
      // IsFMX := cbFMX.Checked;
      cbClassNameText := edModelName.text;
      edUnitText := edUnit.text;
      isViewModel := RadioGroup1.ItemIndex = 1;
      isController := RadioGroup1.ItemIndex = 2;
      setName := ExtractNameBased(trim(cbClassNameText));
      setName := StringReplace(setName, ExtractFileExt(setName), '', []);

      identProject := StringReplace(setName, '.', '', [rfReplaceAll]);

      FInterfImplem := GetInterf;
      FCodeInterf := GetCodigos;

      if SetNameExists(setName) then
      begin
        eMVC.toolBox.showInfo('Desculpe, o projeto "' + setName +
          '" já existe!');
      end
      else
      begin
        LCriarPathModule := cbCreateDir.Checked;
        LPath := edFolder.text;
        if cbCreateDir.Checked then
        begin
          path := path + ( setName ) + '\';
          if not directoryExists(path) then
            ForceDirectories(path);
        end;

        ChDir(extractFilePath(project));

        if isViewModel then
        begin
          CriarViewModel;
        end
        else if isController then
          CriarController
        else
        begin
          CriarModel;
        end;

      end; // else
    end; // if
    free;
  end;
end;

function TClassModelWizard.GetAuthor: string;
begin
  //
  // When Object Repository is in Detail mode used in the Author column
  //
  result := 'MVCBr'
end;

function TClassModelWizard.GetComment: string;
begin
  //
  // When Object Repository is in Detail mode used in the Comment column
  //
  result := 'MVCBr Criar ClassModel '
end;

function TClassModelWizard.GetGlyph:
{$IFDEF COMPILER_6_UP}Cardinal{$ELSE}HICON{$ENDIF};
begin
  result := LoadIcon(hInstance, 'IMPORTMODEL');
end;

function TClassModelWizard.GetIDString: string;
begin
  //
  // Unique name for the Wizard used internally by Delphi
  //
  result := 'MVCBr.MVCSetClassModelWizard';
end;

function TClassModelWizard.GetName: string;
begin
  //
  // Name used for user messages and in the Object Repository if
  // implementing a IOTARepositoryWizard object
  //
  result := '6. '+wizardClassModel_Import_caption;
end;

function TClassModelWizard.GetPage: string;
begin
  result := 'MVCBr'
end;

function TClassModelWizard.GetState: TWizardState;
begin
  //
  // For Menu Item Wizards only
  //
  result := [wsEnabled];
end;

procedure TClassModelWizard.SetIsFMX(const Value: boolean);
begin
  FIsFMX := Value;
end;

procedure Register;
begin
  RegisterPackageWizard(TClassModelWizard.create);

end;

end.
