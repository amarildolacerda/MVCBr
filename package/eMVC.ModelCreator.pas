unit eMVC.ModelCreator;

{**********************************************************************}
{ Copyright 2005 Reserved by Eazisoft.com                              }
 { File Name: ModelCreator.pas                                         }
{ Author: Larry Le                                                     }
{ Description:  Model Creator                                          }
{                                                                      }
{ History:                                                             }
{ - 1.0, 19 May 2006                                                   }
{   First version                                                      }
{                                                                      }
{ Email: linfengle@gmail.com                                           }
{                                                                      }
{ The contents of this file are subject to the Mozilla Public License  }
{ Version 1.1 (the "License"); you may not use this file except in     }
{ compliance with the License. You may obtain a copy of the License at }
{ http://www.mozilla.org/MPL/                                          }
{                                                                      }
{ Software distributed under the License is distributed on an "AS IS"  }
{ basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See  }
{ the License for the specific language governing rights and           }
{ limitations under the License.                                       }
{                                                                      }
{ The Original Code is written in Delphi.                              }
{                                                                      }
{ The Initial Developer of the Original Code is Larry Le.              }
{ Copyright (C) eazisoft.com. All Rights Reserved.                     }
{                                                                      }
{**********************************************************************}

interface

uses
  Windows, SysUtils,
  eMVC.ViewCreator,
  eMVC.FileCreator,
  ToolsApi,
  eMVC.BaseCreator;

type

  TModelCreator = class(TBaseCreator)
  public
    constructor Create(const APath: string = ''; ABaseName: string = '';
      AUnNamed: Boolean = true); override;
    function GetImplFileName: string; override;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile; override;
  end;

implementation

{ TModelCreator }

constructor TModelCreator.Create(const APath: string = ''; ABaseName: string = '';
  AUnNamed: Boolean = true);
begin
  inherited create(APath, ABaseName, AUnNamed);
  self.SetAncestorName('model');
end;

function TModelCreator.GetImplFileName: string;
begin
  result := self.getpath + getBaseName + '.Model.pas';
end;

function TModelCreator.NewImplSource(const ModuleIdent,
  FormIdent, AncestorIdent: string): IOTAFile;
var fc:TFileCreator;
begin
  fc := TFileCreator.Create(ModuleIdent, FormIdent, AncestorIdent, cMODEL);
  fc.Templates.assign(Templates);
  result :=fc;
end;


end.

