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
      Add('NavigateModel');
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
      Add('INavigateModel');
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
