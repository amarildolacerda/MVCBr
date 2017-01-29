unit eMVC.PersistentModelConst;

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
      Add('MVCBr.DatabaseModel');
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
      Add('IDatabaseModel=TDatabaseModelFactory');
      Add('IPersistentModel=TPersistentModelFactory');
      Add('INavigatorModel=TNavigatorModelFactory');
      Add('IValidateModel=TValidateModelFactory');
      Add('IModel=TModelFactory');
      Add('IFireDACModel=TFireDACModel');
      Add('IOrmModel=TORMModel');
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
      Add('mtPersistent');
      Add('mtNavigator');
      Add('mtValidate');
      Add('mtCommon');
      Add('mtPersistent');
      Add('mtPersistent');
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
      Add('DatabaseModel');
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
      Add('IDatabaseModel');
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
