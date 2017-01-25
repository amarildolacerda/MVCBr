unit eMVC.ProjectFileCreator;
{**********************************************************************}
{ Copyright 2005 Reserved by Eazisoft.com                              }
 { File Name: ProjectCreator.pas                                       }
{ Author: Larry Le                                                     }
{ Description:                                                         }
{   Implements the IOTAFile for TProjectCreator                        }
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
  eMVC.OTAUtilities,
  ToolsApi;

const
{$I project.inc}

type
  TProjectFileCreator = class(TInterfacedObject, IOTAFile)
  private
    FAge: TDateTime;
    FProjectName: string;
  public
    constructor Create(const ProjectName: string);
    function GetSource: string;
    function GetAge: TDateTime;
  end;

implementation

{ TProjectFileCreator }

constructor TProjectFileCreator.Create(const ProjectName: string);
begin
  FAge := -1; // Flag age as New File
  FProjectName := ProjectName;
end;

function TProjectFileCreator.GetAge: TDateTime;
begin
  Result := FAge;
end;

function TProjectFileCreator.GetSource: string;
begin
  Result := ProjectCode;
  // Parameterize the code with the current ProjectName
  Result := StringReplace(Result, '%ModuleIdent', FProjectName, [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '%Module', 'Main', [rfReplaceAll, rfIgnoreCase]);
end;

end.

