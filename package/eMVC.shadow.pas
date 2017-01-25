unit eMVC.shadow;

{**********************************************************************}
{ Copyright 2005 Reserved by Eazisoft.com                              }
{ File Name: shadow.pas                                                }
{ Author: Larry Le                                                     }
{ Description:  make your application run in a shadow                  }
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
  windows, forms, SysUtils, shellAPI;
var
  IAmShadow: Boolean = true;
  shadowName: string;

procedure DeleteSelf;

implementation

procedure DeleteSelf;
var
  hModule: THandle;
  buff: array[0..255] of Char;
  hKernel32: THandle;
  pExitProcess, pDeleteFileA, pUnmapViewOfFile: Pointer;
begin
  hModule := GetModuleHandle(nil);
  GetModuleFileName(hModule, buff, sizeof(buff));
//  CloseHandle(THandle(4));
  hKernel32 := GetModuleHandle('KERNEL32');
  pExitProcess := GetProcAddress(hKernel32, 'ExitProcess');
  pDeleteFileA := GetProcAddress(hKernel32, 'DeleteFileA');
  pUnmapViewOfFile := GetProcAddress(hKernel32, 'UnmapViewOfFile');
  asm
    LEA         EAX, buff
    PUSH        0
    PUSH        0
    PUSH        EAX
    PUSH        pExitProcess
    PUSH        hModule
    PUSH        pDeleteFileA
    PUSH        pUnmapViewOfFile
    RET
  end;
end;


{$IFDEF SHADOWON}
var
  path, params: string;
  i: Integer;


initialization
  begin
    if lowercase(paramStr(1)) <> 'noshadow' then
    begin
      path := ExtractFilePath(Application.ExeName);
      shadowName := '_' + ExtractFileName(Application.ExeName);
      SetCurrentDir(path);
      if lowercase(paramStr(1)) <> 'shadow' then
      begin
        if fileexists(path + pchar(shadowname)) then
          deleteFile(path + pchar(shadowname));
        copyFile(pchar(application.ExeName), pchar(path + pchar(shadowname)),
          true);
        params := '';
        //get the params
        for i := 1 to paramCount do
        begin
          params := params + ' ' + paramStr(i);
        end;
        //run the shadow
        ShellExecute(0, 'open', pchar(path + pchar(shadowName)),
          pchar('shadow ' + params), pchar(path), SW_SHOW);
        //kill self
        IAmShadow := false;
        application.Terminate;
      end
      else
      begin
        IAmShadow := true;
      end; //else
    end; //if
  end;
{$ENDIF}
end.
