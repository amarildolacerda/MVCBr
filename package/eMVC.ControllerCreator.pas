unit eMVC.ControllerCreator;
       
{**********************************************************************}
{ Copyright 2005 Reserved by Eazisoft.com                              }
{ File Name: ControllerCreator.pas                                     }
{ Author: Larry Le                                                     }
{ Description: Create a controller                                     }
{                                                                      }
{ History:                                                             }
{ - 1.0, 19 May 2006                                                   }
{   First version                                                      }
{                                                                      }
{ Email: linfengle@gmail.com                                           }
{                                                                      }
{ The contents of this file are subject to the Mozilla Public License }
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
  eMVC.ToolBox,
  eMVC.BaseCreator;

type
  TControllerCreator = class(TBaseCreator)
  private
    FCreateModule, FCreateView: boolean;
    FModelAlone, FViewAlone: boolean;
    FViewIsForm: Boolean; //true:view is a child of TForm
  public
    constructor Create(const APath: string = ''; ABaseName: string = '';
      AUnNamed: Boolean = true; ACreateModule: Boolean = true; ACreateView: Boolean = true;
      AModelAlone: Boolean = true; AViewAlone: Boolean = true; ViewIsForm: boolean = true); reintroduce;
    function GetImplFileName: string; override;
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string): IOTAFile; override;
  end;

implementation

{ TControllerCreator }

constructor TControllerCreator.Create(const APath: string = ''; ABaseName: string = '';
  AUnNamed: Boolean = true; ACreateModule: Boolean = true; ACreateView: Boolean = true;
  AModelAlone: Boolean = true; AViewAlone: Boolean = true; ViewIsForm: boolean = true);
begin
  inherited Create(APath, ABaseName, AUnNamed);
  FCreateModule := ACreateModule;
  FCreateView := ACreateView;
  FModelAlone := AModelAlone;
  FViewAlone := AViewAlone;
  FViewIsForm := ViewIsForm;
  self.SetAncestorName('Controller');
end;

function TControllerCreator.GetImplFileName: string;
begin
  result := self.getpath + getBasename + '.Controller.pas';
end;



function TControllerCreator.NewImplSource(const ModuleIdent,
  FormIdent, AncestorIdent: string): IOTAFile;
var fc:TFileCreator;
begin
  fc := TFileCreator.Create(ModuleIdent, FormIdent, AncestorIdent, cController,
    FCreateModule, FCreateView, FModelAlone, FViewAlone, FViewIsForm);
  fc.isFMX := self.IsFMX;
  fc.Templates.Assign( Templates ) ;
  result := fc;
end;

end.

