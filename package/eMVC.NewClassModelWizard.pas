unit eMVC.NewClassModelWizard;

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
  eMVC.toolBox,
  eMVC.BaseCreator,
  eMVC.ClassModelCreator,
  eMVC.NewClassModelForm,
  DesignIntf,
  ToolsApi;

type
  TNewClassModelWizard = class(TNotifierObject, IOTAWizard,
    IOTARepositoryWizard, IOTAProjectWizard{$IFDEF MENUDEBUG},
    IOTAMenuWizard{$ENDIF})
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

procedure TNewClassModelWizard.FillMethods(sClass: string;
  ListaMethds: TStrings; Prop: TStrings);
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

procedure TNewClassModelWizard.FillClasses(sPas: String; Lista: TStrings);
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

procedure TNewClassModelWizard.Execute;
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
    Model := TClassModelCreator.create(path, setName, false);
    Model.templates.AddPair('//InterfImplem', FInterfImplem);
    Model.templates.AddPair('//InterfCode', FCodeInterf);
    Model.templates.AddPair('%UnitBase', setName);

    Model.templates.AddPair('%ClassConector', cbClassNameText);
    s := ExtractNameBased(cbClassNameText) + 'Base';
    Model.templates.AddPair('%ClassModel', s);
    s := ExtractFileName(edUnitText);
    s := copy(s, 1, pos(ExtractFileExt(s), s) - 1);
    Model.templates.AddPair('%ClassUnit', s);
    Model.isController := true;

    (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);

    debug('Criou o Model');

    Model := TClassModelCreator.create(path, setName, false);
    Model.templates.AddPair('//InterfImplem', FInterfImplem);
    Model.templates.AddPair('//InterfCode', FCodeInterf);
    Model.templates.AddPair('%UnitBase', setName);

    Model.templates.AddPair('%ClassConector', cbClassNameText);
    s := ExtractNameBased(cbClassNameText) + 'Base';
    Model.templates.AddPair('%ClassModel', s);
    s := ExtractFileName(edUnitText);
    s := copy(s, 1, pos(ExtractFileExt(s), s) - 1);
    Model.templates.AddPair('%ClassUnit', s);
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
    Model := TClassModelCreator.create(path, setName, false);
    Model.templates.AddPair('//InterfImplem', FInterfImplem);
    Model.templates.AddPair('//InterfCode', FCodeInterf);
    Model.templates.AddPair('%UnitBase', setName);

    Model.templates.AddPair('%ClassConector', cbClassNameText);
    s := ExtractNameBased(cbClassNameText) + 'Base';
    Model.templates.AddPair('%ClassModel', s);
    s := ExtractFileName(edUnitText);
    s := copy(s, 1, pos(ExtractFileExt(s), s) - 1);
    Model.templates.AddPair('%ClassUnit', s);

    (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);

    debug('Criou o Model');

    Model := TClassModelCreator.create(path, setName, false);
    Model.templates.AddPair('//InterfImplem', FInterfImplem);
    Model.templates.AddPair('//InterfCode', FCodeInterf);
    Model.templates.AddPair('%UnitBase', setName);

    Model.templates.AddPair('%ClassConector', cbClassNameText);
    s := ExtractNameBased(cbClassNameText) + 'Base';
    Model.templates.AddPair('%ClassModel', s);
    s := ExtractFileName(edUnitText);
    s := copy(s, 1, pos(ExtractFileExt(s), s) - 1);
    Model.templates.AddPair('%ClassUnit', s);

    Model.isInterf := true;
    (BorlandIDEServices as IOTAModuleServices).CreateModule(Model);

    debug('Criou o Model Interf');

  end;

  procedure CriarViewModel();
  var
    ViewModel: TClassModelCreator;
  begin
    debug('Pronto para criar o Modulo');
    ViewModel := TClassModelCreator.create(path, setName, false);
    ViewModel.isViewModel := true;
    ViewModel.SetAncestorName('ViewModel');
    ViewModel.templates.AddPair('//InterfImplem', FInterfImplem);
    ViewModel.templates.AddPair('//InterfCode', FCodeInterf);

    ViewModel.templates.AddPair('%UnitBase', setName);

    ViewModel.templates.AddPair('%ClassConector', cbClassNameText);
    s := ExtractNameBased(cbClassNameText) + 'Base';
    ViewModel.templates.AddPair('%ClassModel', s);
    s := ExtractFileName(edUnitText);
    s := copy(s, 1, pos(ExtractFileExt(s), s) - 1);
    ViewModel.templates.AddPair('%ClassUnit', s);

    (BorlandIDEServices as IOTAModuleServices).CreateModule(ViewModel);

    debug('Criou o Model');

    ViewModel := TClassModelCreator.create(path, setName, false);
    ViewModel.isViewModel := true;
    ViewModel.SetAncestorName('ViewModel');
    ViewModel.templates.AddPair('//InterfImplem', FInterfImplem);
    ViewModel.templates.AddPair('//InterfCode', FCodeInterf);
    ViewModel.templates.AddPair('%UnitBase', setName);

    ViewModel.templates.AddPair('%ClassConector', cbClassNameText);
    s := ExtractNameBased(cbClassNameText) + 'Base';
    ViewModel.templates.AddPair('%ClassModel', s);
    s := ExtractFileName(edUnitText);
    s := copy(s, 1, pos(ExtractFileExt(s), s) - 1);
    ViewModel.templates.AddPair('%ClassUnit', s);

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

        if cbCreateDir.Checked then
        begin
          path := path + setName + '\';
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

function TNewClassModelWizard.GetAuthor: string;
begin
  //
  // When Object Repository is in Detail mode used in the Author column
  //
  result := 'MVCBr'
end;

function TNewClassModelWizard.GetComment: string;
begin
  //
  // When Object Repository is in Detail mode used in the Comment column
  //
  result := 'MVCBr Criar ClassModel '
end;

function TNewClassModelWizard.GetGlyph:
{$IFDEF COMPILER_6_UP}Cardinal{$ELSE}HICON{$ENDIF};
begin
  result := LoadIcon(hInstance, 'SAMPLEWIZARD');
end;

function TNewClassModelWizard.GetIDString: string;
begin
  //
  // Unique name for the Wizard used internally by Delphi
  //
  result := 'MVCBr.MVCSetClassModelWizard';
end;

function TNewClassModelWizard.GetName: string;
begin
  //
  // Name used for user messages and in the Object Repository if
  // implementing a IOTARepositoryWizard object
  //
  result := '6. Importar Classe';
end;

function TNewClassModelWizard.GetPage: string;
begin
  result := 'MVCBr'
end;

function TNewClassModelWizard.GetState: TWizardState;
begin
  //
  // For Menu Item Wizards only
  //
  result := [wsEnabled];
end;

procedure TNewClassModelWizard.SetIsFMX(const Value: boolean);
begin
  FIsFMX := Value;
end;

procedure Register;
begin
  RegisterPackageWizard(TNewClassModelWizard.create);

end;

end.
