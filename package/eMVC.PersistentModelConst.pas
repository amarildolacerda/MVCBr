unit eMVC.PersistentModelConst;
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

function ModelCodeCombo: string;
function ModelCodeAncestor: string;
function ModelCodeType: string;
function ModelUses:string;
function ModelInherited:string;

implementation

//  //%uses
function ModelUses:string;
begin
  with TStringList.Create do
    try
      Add('MVCBr.PersistentModel');
      Add('MVCBr.NavigateModel');
      Add('MVCBr.ValidateModel');
      Add('MVCBr.Model');
      Add('MVCBr.FireDACModel, MVCBr.FireDACModel.Interf');
      Add('MVCBr.OrmModel');
      result := text;
    finally
      Free;
    end;
end;

//     =%Class
function ModelCodeCombo: string;
begin
  with TStringList.Create do
    try
      Add('IPersistentModel=TPersistentModelFactory');
      Add('INavigateModel=TNavigateModelFactory');
      Add('IValidateModel=TValidateModelFactory');
      Add('IModel=TModelFactory');
      Add('IFireDACModel=TFireDACModelFactory');
      Add('IOrmModel=TORMModelFactory');
      result := text;
    finally
      Free;
    end;
end;

// %modelType
function ModelCodeType: string;
begin
  with TStringList.Create do
    try
      Add('mtPersistent');
      Add('mtNavigate');
      Add('mtValidate');
      Add('mtCommon');
      Add('mtPersistent');
      Add('mtOrmModel');
      result := text;
    finally
      Free;
    end;
end;

//  //%Interf
function ModelCodeAncestor: string;
begin
  with TStringList.Create do
    try
      Add('PersistentModel');
      Add('NavigatorModel');
      Add('ValidateModel');
      Add('Model');
      Add('DataModel');
      Add('OrmModel');
      result := text;
    finally
      Free;
    end;
end;

//  %interfInherited
function ModelInherited:string;
begin
  with TStringList.Create do
    try
      Add('IPersistentModel');
      Add('INavigatorModel');
      Add('IValidateModel');
      Add('IModel');
      Add('IFireDacModel');
      Add('IOrmModel');
      result := text;
    finally
      Free;
    end;
end;

end.
