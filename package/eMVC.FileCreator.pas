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
{$I project.inc}
{$I viewcode.inc}
{$I modelcode.inc}
{$I controllercode.inc}
{$I classcode.inc}
{$I viewmodel.inc}

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
  public
    constructor Create(const ModelIdent, FormIdent, AncestorIdent: string;
      ACreateType: smallint = cNORMAL; ACreateModel: boolean = false;
      ACreateView: boolean = false; AModelAlone: boolean = true;
      AViewAlone: boolean = true; ViewIsForm: boolean = true);
    function GetSource: string;
    function GetAge: TDateTime;
  end;

implementation

uses eMVC.OTAUtilities;
{ TFileCreator }

constructor TFileCreator.Create(const ModelIdent, FormIdent,
  AncestorIdent: string; ACreateType: smallint = cNORMAL;
  ACreateModel: boolean = false; ACreateView: boolean = false;
  AModelAlone: boolean = true; AViewAlone: boolean = true;
  ViewIsForm: boolean = true);
begin
  self.FCreateType := ACreateType;
  FAge := -1; // Flag age as New File
  FModelIdent := ModelIdent;
  FFormIdent := FormIdent;
  FAncestorIdent := AncestorIdent;
  FCreateModel := ACreateModel;
  FCreateView := ACreateView;
  FModelAlone := AModelAlone;
  FViewAlone := AViewAlone;
  FViewIsForm := ViewIsForm;
  Debug('Modulo: ' + ModelIdent);
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
      Result := ViewCode;
    cCLASS:
      Result := ViewCode2;
    cMODEL:
      Result := ModelCode;
    CVIEWMODEL:
      Result := viewmodecode;
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
      Result := ProjectCode;
  end;

  if self.FCreateModel and not self.FModelAlone then
  begin
    Result := StringReplace(Result, '%ModelDef', ModelDef,
      [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '%ModelImpl', ModelImpl,
      [rfReplaceAll, rfIgnoreCase]);
  end
  else
  begin
    Result := StringReplace(Result, '%ModelDef', '',
      [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '%ModelImpl', '',
      [rfReplaceAll, rfIgnoreCase]);
  end;

  if self.FCreateView and not self.FViewAlone then
  begin
    Result := StringReplace(Result, '%ViewDef', ViewDef,
      [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '%ViewImpl', ViewImpl,
      [rfReplaceAll, rfIgnoreCase]);
  end
  else
  begin
    Result := StringReplace(Result, '%ViewDef', '',
      [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '%ViewImpl', '',
      [rfReplaceAll, rfIgnoreCase]);
  end;

  // Parameterize the code with the current Identifiers
  if FViewIsForm then
  begin
    Result := StringReplace(Result, '%ViewCreation', FormViewCreate,
      [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '%FreeView', '',
      [rfReplaceAll, rfIgnoreCase]);
  end
  else
  begin
    Result := StringReplace(Result, '%ViewCreation', NormalViewCreate,
      [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '%FreeView', NormalViewDestory,
      [rfReplaceAll, rfIgnoreCase]);
  end;

  if FModelIdent <> '' then
    Result := StringReplace(Result, '%ModelIdent', FModelIdent,
      [rfReplaceAll, rfIgnoreCase]);
  if FFormIdent <> '' then
    Result := StringReplace(Result, '%FormIdent', FFormIdent,
      [rfReplaceAll, rfIgnoreCase]);
  if FAncestorIdent <> '' then
    Result := StringReplace(Result, '%AncestorIdent', FAncestorIdent,
      [rfReplaceAll, rfIgnoreCase]);

  Result := StringReplace(Result, '%guid', GuidToString(TGuid.NewGuid),
    [rfReplaceAll, rfIgnoreCase]);

  str := TStringList.Create;
  with str do
    try
      text := Result;
      c := 0;
      for i := str.count - 1 downto 0 do
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
      free;
    end;

end;

end.
