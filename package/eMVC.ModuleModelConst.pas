unit eMVC.ModuleModelConst;
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

uses System.Classes;

//{$I+ PersistentModel.inc  }

function ModuleCodeCombo: string;
function ModuleCodeAncestor: string;
function ModuleCodeType: string;
function ModuleUses:string;
function ModuleInherited:string;

implementation

//  //%uses
function ModuleUses:string;
begin
  with TStringList.Create do
    try
      Add('MVCBr.ModuleModel');
      result := text;
    finally
      Free;
    end;
end;

//     =%Class
function ModuleCodeCombo: string;
begin
  with TStringList.Create do
    try
      Add('IModuleModel=TModuleFactory');
      result := text;
    finally
      Free;
    end;
end;

// %modelType
function ModuleCodeType: string;
begin
  with TStringList.Create do
    try
      Add('mtCommon');
      result := text;
    finally
      Free;
    end;
end;

//  //%Interf
function ModuleCodeAncestor: string;
begin
  with TStringList.Create do
    try
      Add('ModuleModel');
      result := text;
    finally
      Free;
    end;
end;

//  %interfInherited
function ModuleInherited:string;
begin
  with TStringList.Create do
    try
      Add('IModuleModel');
      result := text;
    finally
      Free;
    end;
end;

end.
