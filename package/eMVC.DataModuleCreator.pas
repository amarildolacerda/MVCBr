unit eMVC.DataModuleCreator;
{**********************************************************************}
{ Copyright 2005 Reserved by Eazisoft.com                              }
{ File Name: DataModuleCreator.pas                                     }
{ Author: Larry Le                                                     }
{ Description:                                                         }
{ Implement IOTAModuleCreator for the TProjectCreatorWizard to create  }
{ a DataModule                                                         }
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
  ToolsApi,
  eMVC.BaseCreator;

type
  //
  // Implements the necessary interfaces for a Delphi DataModule.  The IDE typically
  //
  TDataModuleCreator = class(TBaseCreator)
  public
    function GetAncestorName: string; override;
    function GetCreatorType: string; override;
  end;

implementation

{$IFDEF GXDEBUG}

function FmtStr(Str: string): string;
begin
  if Str = '' then
    Result := '<nil>'
  else
    Result := Str
end;
{$ENDIF GXDEBUG}


{ TDataModuleCreator }


function TDataModuleCreator.GetAncestorName: string;
begin
  Result := 'DataModule';

end;

function TDataModuleCreator.GetCreatorType: string;
begin
  Result := sForm;
end;

end.
