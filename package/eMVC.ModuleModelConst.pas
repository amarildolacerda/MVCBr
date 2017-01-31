unit eMVC.ModuleModelConst;

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
