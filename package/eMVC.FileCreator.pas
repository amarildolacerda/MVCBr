unit eMVC.FileCreator;
{ ********************************************************************** }
{ Copyright 2005 Reserved by Eazisoft.com }
{ File Name: FileCreator.pas }
{ Author: Larry Le }
{ Description: Implements the IOTAFile for TViewCreator, TModelCreator, }
{ and the TControllerCreator }
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

uses
  Windows, Classes, SysUtils, ToolsApi, eMVC.Toolbox;

const
  cNORMAL = 0;
  cVIEW = 1;
  cMODEL = 2;
  cCONTROLLER = 3;
  cPROJECT = 4;
  cCLASS = 5;
  CVIEWMODEL = 6;
  cPersistentMODEL = 7;

{$I .\inc\project.inc}
{$I .\inc\viewcode.inc}
{$I .\inc\modelcode.inc}
{$I .\inc\controllercode.inc}
{$I .\inc\classcode.inc}
{$I .\inc\viewmodel.inc}
{$I .\inc\persistentmodel.inc}

type
  TFileCreator = class(TInterfacedObject, IOTAFile)
  private
    FAge: TDateTime;
    FCreateType: smallint;
    FModelIdent: string;
    FFormIdent: string;
    FAncestorIdent: string;
    FCreateModel, FCreateView: boolean;
    FModelAlone, FViewAlone: boolean;
    FViewIsForm: boolean;
    FViewModel: boolean;
    FTemplates: TStringList;
    FIsFMX: boolean;
    procedure SetTemplates(const Value: TStringList);
    procedure SetisFMX(const Value: boolean);
  public
    constructor Create(const ModelIdent, FormIdent, AncestorIdent: string;
      ACreateType: smallint = cNORMAL; ACreateModel: boolean = false;
      ACreateView: boolean = false; AModelAlone: boolean = true;
      AViewAlone: boolean = true; ViewIsForm: boolean = true;
      AViewModel: boolean = true; AIsFMX: boolean = false);
    destructor destroy; override;
    function GetSource: string;
    function GetAge: TDateTime;
    property Templates: TStringList read FTemplates write SetTemplates;
    property isFMX: boolean read FIsFMX write SetisFMX;
  end;

implementation

uses eMVC.OTAUtilities;
{ TFileCreator }

constructor TFileCreator.Create(const ModelIdent, FormIdent,
  AncestorIdent: string; ACreateType: smallint = cNORMAL;
  ACreateModel: boolean = false; ACreateView: boolean = false;
  AModelAlone: boolean = true; AViewAlone: boolean = true;
  ViewIsForm: boolean = true; AViewModel: boolean = true;
  AIsFMX: boolean = false);
begin
  self.FCreateType := ACreateType;
  FTemplates := TStringList.Create;
  FAge := -1; // Flag age as New File
  FModelIdent := ModelIdent;
  FFormIdent := FormIdent;
  FAncestorIdent := AncestorIdent;
  FCreateModel := ACreateModel;
  FCreateView := ACreateView;
  FModelAlone := AModelAlone;
  FViewAlone := AViewAlone;
  FViewIsForm := ViewIsForm;
  FViewModel := AViewModel;
  FIsFMX := AIsFMX;
  Debug('Modulo: ' + ModelIdent);
end;

destructor TFileCreator.destroy;
begin
  FTemplates.Free;
  inherited;
end;

function TFileCreator.GetAge: TDateTime;
begin
  Result := FAge;
end;

function TFileCreator.GetSource: string;
var
  i: integer;
  c: integer;
  str: TStringList;
begin
  case self.FCreateType of
    cNORMAL:
      Result := classCode;
    cVIEW:
      if FIsFMX then
        Result := ViewCodeFMX
      else
        Result := ViewCode;
    cCLASS:
      Result := ViewCode2;
    cMODEL:
      if isFMX then
         result := ModelCodeFMX else
      Result := ModelCode;
    CVIEWMODEL:
      begin
        Result := viewmodecode;
        if FViewModel then
          Result := stringReplace(Result, '%ViewModelInit', '',
            [rfReplaceAll, rfIgnoreCase]);
      end;
    cPersistentMODEL:
      begin
        Result := ModelCodeBase;
      end;
    cCONTROLLER:
      begin
        if (not self.FCreateModel) and (not self.FCreateView) then
          Result := ControllerCodeOnly
        else if (self.FCreateModel) and (not self.FCreateView) then
          Result := ControllerCodeWithoutView
        else if (not self.FCreateModel) and (self.FCreateView) then
          Result := ControllerCodeWithoutModel
        else
        begin
          if (not FModelAlone and not FViewAlone) then
            Result := ControllerCode2
          else if (not self.FModelAlone and self.FViewAlone) then
            Result := ControllerCodeWithoutModel
          else if (self.FModelAlone and not self.FViewAlone) then
            Result := ControllerCodeWithoutView
          else
            Result := ControllerCode;
        end;
      end;
    cPROJECT:
      if isFMX then
        Result := ProjectCodeFMX
      else
        Result := ProjectCode;
  end;

  if self.FCreateModel and not self.FModelAlone then
  begin
    Result := stringReplace(Result, '%ModelDef', ModelDef,
      [rfReplaceAll, rfIgnoreCase]);
    Result := stringReplace(Result, '%ModelImpl', ModelImpl,
      [rfReplaceAll, rfIgnoreCase]);
  end
  else
  begin
    Result := stringReplace(Result, '%ModelDef', '',
      [rfReplaceAll, rfIgnoreCase]);
    Result := stringReplace(Result, '%ModelImpl', '',
      [rfReplaceAll, rfIgnoreCase]);
  end;

  if self.FCreateView and not self.FViewAlone then
  begin
    Result := stringReplace(Result, '%ViewDef', ViewDef,
      [rfReplaceAll, rfIgnoreCase]);
    Result := stringReplace(Result, '%ViewImpl', ViewImpl,
      [rfReplaceAll, rfIgnoreCase]);
  end
  else
  begin
    Result := stringReplace(Result, '%ViewDef', '',
      [rfReplaceAll, rfIgnoreCase]);
    Result := stringReplace(Result, '%ViewImpl', '',
      [rfReplaceAll, rfIgnoreCase]);
  end;

  // Parameterize the code with the current Identifiers
  if FViewIsForm then
  begin
    Result := stringReplace(Result, '%ViewCreation', FormViewCreate,
      [rfReplaceAll, rfIgnoreCase]);
    Result := stringReplace(Result, '%FreeView', '',
      [rfReplaceAll, rfIgnoreCase]);
  end
  else
  begin
    Result := stringReplace(Result, '%ViewCreation', NormalViewCreate,
      [rfReplaceAll, rfIgnoreCase]);
    Result := stringReplace(Result, '%FreeView', NormalViewDestory,
      [rfReplaceAll, rfIgnoreCase]);
  end;

  if FModelIdent <> '' then
    Result := stringReplace(Result, '%ModelIdent', FModelIdent,
      [rfReplaceAll, rfIgnoreCase]);
  if FFormIdent <> '' then
    Result := stringReplace(Result, '%FormIdent', FFormIdent,
      [rfReplaceAll, rfIgnoreCase]);
  if FAncestorIdent <> '' then
    Result := stringReplace(Result, '%AncestorIdent', FAncestorIdent,
      [rfReplaceAll, rfIgnoreCase]);

  Result := stringReplace(Result, '%guid', GuidToString(TGuid.NewGuid),
    [rfReplaceAll, rfIgnoreCase]);

  // usa os templates;
  for i := 0 to FTemplates.Count - 1 do
  begin
    Result := stringReplace(Result, FTemplates.Names[i],
      FTemplates.ValueFromIndex[i], [rfReplaceAll, rfIgnoreCase]);
    Debug('Template: ' + FTemplates.Names[i] + '=' +
      FTemplates.ValueFromIndex[i]);
  end;

  str := TStringList.Create;
  with str do
    try
      text := Result;
      c := 0;
      for i := str.Count - 1 downto 0 do
      begin
        str[i] := str[i].TrimRight;
        if str[i] = '' then
        begin
          inc(c);
          if c > 0 then
            str.Delete(i);
        end
        else
          c := 0;
      end;
      Result := text;
    finally
      Free;
    end;

end;

procedure TFileCreator.SetisFMX(const Value: boolean);
begin
  FIsFMX := Value;
end;

procedure TFileCreator.SetTemplates(const Value: TStringList);
begin
  FTemplates := Value;
end;

end.
