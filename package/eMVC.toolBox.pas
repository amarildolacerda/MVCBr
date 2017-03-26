unit eMVC.toolBox;
{ ********************************************************************** }
{ Copyright 2005 Reserved by Eazisoft.com }
{ File name: toolBox.pas }
{ Author: Larry Le }
{ Description: This unit contains a set tool functions }
{ }
{ History: }
{ - 1.1, 19 DEC 2005 }
{ add 4 functions,reboot,shutdown,killprocess and terminate }
{ - 1.0, 04 Mar 2005 }
{ }
{ Email: linfengle@gmail.com }
{ }
{ The contents of this file are subject to the Mozilla Public License }
{ Version 1.1 (the "License"); you may not use this file except in }
{ compliance with the License. You may obtain a copy of the License at }
{ http://www.mozilla.org/MPL/ }
{ }
{ Software distributed under the License is distributed on an "AS IS" }
{ basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See }
{ the License for the specific language governing rights and }
{ limitations under the License. }
{ }
{ The Original Code is written in Delphi. }
{ }
{ The Initial Developer of the Original Code is Larry Le. }
{ Copyright (C) eazisoft.com. All Rights Reserved. }
{ }
{ ********************************************************************** }

interface

uses Winsock,
  SysUtils, Contnrs, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  wininet, shellAPI, windows, jpeg, extctrls, Forms, Dialogs, StdCtrls,
  inifiles, ShDocVw, registry, eMVC.CopyfileForm, MMSystem, shlobj;

const
  MaxPath = 255;
  MainTitle = '';
  strPrompt = 'MVCBr';

const
  EWX_FORCE = 4; // Close all programs and switch to another user
  EWX_LOGOFF = 0; // Exit to MS-DOS mode
  EWX_REBOOT = 2; // REBOOT
  EWX_SHUTDOWN = 1; // Shut down

var
  lg_StartFolder: string;
  HomeURL: OleVariant;
  GlobalID: integer = 0;

  // procedure debug(s: string);
  // Check Web browser online or not
function OnLine: boolean;
procedure BMP2JPG(bmpfile: string; jpgfile: string);
procedure showInfo(s: string);
function showInfo2(s: string): boolean;
procedure showWarning(s: string);
procedure showError(s: string);
function showConfirm(s: string): boolean;

// is there some numbers in the given string,return true
function isAllNumber(s: string): boolean;
// give a title,return the window handle,if not found return 0
function getWindowHandle(title: string): HWND;

function WinExecAndWait32(FileName: string; Visibility: integer): DWORD;
function WinExecAndNotWait32(ComLine: string; FWinStyle: integer): THandle;

function isProgramRunning(hdl: THandle): boolean;

function getIniStringValue(AFile, ASection, AKey, ADefaultValue
  : string): string;
// Close all windows contain the title
procedure CloseAllSubApp(FirstHWND: HWND; title: string);
procedure CloseApp(apphandle: HWND);

// Check the application with the given title running or not
function isAppRunning(appTitle: string): boolean;
// set IE work online
function setWebBrowserOnLine: boolean;
// no script debug,
function setNoScriptDebug: boolean;
// local web not use the proxy
function setLocalWebNotUserProx: boolean;
// Get IP
function getMyIP: string;
// Get First IP
function getFirstLocalIP: string;
// Get host name of my computer
function getMyHostName: string;
function startWith(s, search: string): boolean;
// run after windows startup
function StartUpMyProgram(const AKey: string = '';
  AExename: string = ''): boolean;
// undo run after windows startup
function UnStartUpMyProgram(const AKey: string = ''): boolean;
function GetTempDirectory: string;
function GetExecutePath: string;

function BrowseForFolder(const browseTitle: string;
  const initialFolder: string = ''; ext: string = ''): string;
function newMutex(const AMutesID: string = 'MVCBr'): THandle;
function ParamInCommandline(APAram: string): boolean;
function getSystemPath: string;
function isHung(theWindow: HWND; timeOut: Longint): boolean;
function ProgramNotRunning(WHandle: THandle): boolean;
function ChangeSystemDateTime(dtNeeded: TDateTime): boolean;

procedure ShowBlankPage(WebBrowser: TWebBrowser);
procedure freeMutex(AMutexHandle: THandle);
procedure FileCopy(const sourcefilename, targetfilename: string);
procedure SetMediaAudioOff(DeviceID: word);
procedure SetMediaAudioOn(DeviceID: word);
procedure terminate;
procedure KillProcess(hWindowHandle: HWND);
//
// show chm help
//
function HtmlHelpA(hwndcaller: Longint; lpHelpFile: string; wCommand: Longint;
  dwData: string): HWND; stdcall; external 'hhctrl.ocx'

  procedure showHelpTopic(AHelpFile: string; topic: string);

function generateID: integer;

procedure openWeb(AnUrl: string);

function extractValue(AParameter: string): string;
function outPutStrings(AList: TStrings): string;
function ShutDownWindows(Flags: Byte): boolean;
procedure HideTaskbar;
procedure ShowTaskbar;
procedure AdjustToken;
procedure reboot;
procedure shutdown;

implementation

function ShutDownWindows(Flags: Byte): boolean;
begin
  Result := ExitWindowsEx(Flags, 0)
end;

function outPutStrings(AList: TStrings): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to AList.Count - 1 do
  begin
    Result := Result + '<li>' + AList[i] + '</li>';
  end;
  if Result <> '' then
    Result := '<ul>' + Result + '</ul>';
end;

function extractValue(AParameter: string): string;
var
  i: integer;
begin
  i :=  AParameter.IndexOf('=')+1; // pos ('=', AParameter) + 1;
  if i > 0 then
    Result := AParameter.Substring(i,length(AParameter));   //copy(AParameter, i, length(AParameter));
end;

procedure showHelpTopic(AHelpFile: string; topic: string);
begin
  if not FileExists(AHelpFile) then
  begin
    showInfo('Desculpe,' + AHelpFile + ' n鉶 existe!');
    exit;
  end;

  HtmlHelpA(Application.Handle, Pchar(AHelpFile), 0, topic);
end;

procedure openWeb(AnUrl: string);
begin
  Shellexecute(Application.Handle, nil, Pchar(AnUrl), nil, nil, sw_shownormal);
end;

// see a program runing or not，if yes return true;

function isProgramRunning(hdl: THandle): boolean;
var
  FAppState: cardinal;
begin
  Result := (GetExitCodeProcess(hdl, FAppState)) and (FAppState = STILL_ACTIVE);
end;

procedure showInfo(s: string);
begin
  Application.MessageBox(Pchar(s), 'Information', MB_OK + MB_ICONINFORMATION);
end;

procedure showWarning(s: string);
begin
  Application.MessageBox(Pchar(s), 'Warning', MB_OK + MB_ICONWARNING);
end;

procedure showError(s: string);
begin
  Application.MessageBox(Pchar(s), 'Warning', MB_OK + MB_ICONERROR);
end;

function showConfirm(s: string): boolean;
begin
  Result := Application.MessageBox(Pchar(s), 'Confirm',
    MB_YESNO + MB_ICONQUESTION) = ID_YES;
end;

function showInfo2(s: string): boolean;
begin
  Result := Application.MessageBox(Pchar(s), 'Confirm',
    MB_OKCANCEL + MB_ICONINFORMATION) = ID_OK;
end;


//
// run a program and wait it exit
//

function WinExecAndWait32(FileName: string; Visibility: integer): DWORD;
var
  zAppName: array [0 .. 512] of char;
  zCurDir: array [0 .. 255] of char;
  WorkDir: string;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
begin
  StrPCopy(zAppName, FileName);
  GetDir(0, WorkDir);
  StrPCopy(zCurDir, WorkDir);
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil, zAppName, { pointer to command line string }
    nil, { pointer to process security attributes }
    nil, { pointer to thread security attributes }
    false, { handle inheritance flag }
    CREATE_NEW_CONSOLE or { creation flags }
    NORMAL_PRIORITY_CLASS, nil, { pointer to new environment block }
    nil, { pointer to current directory name }
    StartupInfo, { pointer to STARTUPINFO }
    ProcessInfo { pointer to PROCESS_INF }
    ) then
    Result := $FFFFFFFF
  else
  begin
    WaitforSingleObject(ProcessInfo.hProcess, INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess, Result);
  end;
end;

//
// is eveyting in the given string are numbers?，
// true:YEs false:no
//

function isAllNumber(s: string): boolean;
var
  i: integer;
begin
  if (length(trim(s)) <= 0) then
  begin
    Result := false;
    exit;
  end;
  for i := 1 to length(s) do
  begin
    if s[i] = #0 then
      break;
    if (s[i] < '0') or (s[i] > '9') then
    begin
      Result := false;
      exit;
    end;
  end;
  Result := i > 1;
end;

//
// run an external application and return the handle
// if not succeed return 0
// this function work under W95,W98,NT40 W2000/XP
//

function WinExecAndNotWait32(ComLine: string; FWinStyle: integer): THandle;
var
  lpAppName: Pchar;
  // lpTitle: Pchar;
  StartInfo: TStartupInfo;
  FProcessInfo: TProcessInformation;
begin
  if ((length(ComLine) + 2) > 255) then
  begin
    showInfo('Command Line Too Long!');
    Result := 0;
    exit;
  end;

  GetMem(lpAppName, MaxPath);
  StrPCopy(lpAppName, ComLine);
  StartInfo.cb := Sizeof(TStartupInfo);
  StartInfo.lpReserved := nil;
  StartInfo.lpDesktop := nil;
  StartInfo.lpTitle := nil; // lpTitle;
  StartInfo.dwFillAttribute := 0;
  StartInfo.cbReserved2 := 0;
  StartInfo.lpReserved2 := nil;
  // 这个参数控制Create Window形态
  // STARTF_USESHOWWINDOW 指定这个标志位，指示用ShowWindow的参数建立窗口
  StartInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartInfo.wShowWindow := FWinStyle;

  // Clear ProcessInfo Structure
  FProcessInfo.hProcess := 0;
  FProcessInfo.hThread := 0;
  FProcessInfo.dwProcessId := 0;
  FProcessInfo.dwThreadId := 0;

  // Create process
  if CreateProcess(nil, lpAppName, nil, nil, false, 0, nil, nil, StartInfo,
    FProcessInfo) then
  begin
    Result := OpenProcess(PROCESS_ALL_ACCESS, false, FProcessInfo.dwProcessId);
  end
  else // false Create Process;
  begin
    Result := 0;
    // ShowInfo('Run application failed!');
  end;

  FreeMem(lpAppName);
  // FreeMem(lpTitle);
end;

//
// get the first IP of my host
//

function getFirstLocalIP: string;
type
  TaPInAddr = array [0 .. 10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array [0 .. 63] of {$IFDEF UNICODE} AnsiChar {$ELSE} char{$ENDIF};
  // I: Integer;
  GInitData: TWSADATA;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(Buffer, Sizeof(Buffer));
  phe := GetHostByName(Buffer);
  if phe = nil then
    exit;
  pptr := PaPInAddr(phe^.h_addr_list);
  if pptr^[0] <> nil then
    Result := StrPas(inet_ntoa(pptr^[0]^));
  WSACleanup;
end;

function getIniStringValue(AFile, ASection, AKey, ADefaultValue
  : string): string;
begin
  if not FileExists(AFile) then
  begin
    Result := ADefaultValue;
    exit;
  end;
  with TIniFile.Create(AFile) do
  begin
    Result := readString(ASection, AKey, ADefaultValue);
    free;
  end;
end;

//
// close all windows with title
//

procedure CloseAllSubApp(FirstHWND: HWND; title: string);
var
  Found: HWND;
  Hold: string;
  zAppName: array [0 .. 127] of char;
begin
  Hold := Application.title;
  Found := GetWindow(FirstHWND, GW_HWNDFIRST);
  while Found <> 0 do
  begin
    getWIndowText(Found, zAppName, 127);
    Hold := trim(zAppName);
    if (Hold <> '') and ( lowercase(Hold).contains(lowercase(title)) ) then
    begin
      sendMessage(Found, WM_CLOSE, 0, 0);
      // closeWIndow(found);
      // DestroyWindow(Found);
    end;
    Found := GetWindow(Found, GW_HWNDNExt);
  end;
end;

procedure CloseApp(apphandle: HWND);
begin
  sendMessage(apphandle, WM_CLOSE, 0, 0);
end;

function getWindowHandle(title: string): HWND;
var
  Found, FirstHWND: HWND;
  Hold: string;
  zAppName: array [0 .. 127] of char;
begin
  Result := 0;
  Hold := Application.title;
  FirstHWND := Application.MainForm.Handle;

  Found := GetWindow(FirstHWND, GW_HWNDFIRST);
  while Found <> 0 do
  begin
    getWIndowText(Found, zAppName, 127);
    Hold := trim(zAppName);
    if (Hold <> '') and ( lowercase(Hold).contains(lowercase(title))) then
    begin
      Result := Found;
      break;
      exit;
    end;
    Found := GetWindow(Found, GW_HWNDNExt);
  end;
end;

//
// 检测程序是否已经运行
//

function isAppRunning(appTitle: string): boolean;
var
  Found: HWND;
  Hold: string;
  zAppName: array [0 .. 127] of char;
  // count: Integer;
begin
  // count := 0;
  Result := false;
  Found := GetWindow(Application.MainForm.Handle, GW_HWNDFIRST);
  while Found <> 0 do
  begin
    getWIndowText(Found, zAppName, 127);
    Hold := trim(zAppName);
    if (Hold <> '') and (lowercase(appTitle) = lowercase(Hold)) then
    begin
      // postMessage(found, WM_CLOSE, 0, 0);
      // inc(count);
      // if count > 2 then
      begin
        Result := true;
        exit;
      end;
    end;
    Found := GetWindow(Found, GW_HWNDNExt);
  end;
end;

//
// set your IE OnLine
//

function setWebBrowserOnLine: boolean;
var
  reg: TRegistry;
begin
  Result := true;
  reg := TRegistry.Create(KEY_ALL_ACCESS);
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKey
      ('\Software\Microsoft\Windows\CurrentVersion\Internet Settings', true)
    then
    begin
      reg.WriteInteger('GlobalUserOffline', 0);
      reg.CloseKey
    end
    else
      Result := false;
  except
    Result := false;
  end;
  if assigned(reg) then
    reg.free;
end;

//
// 禁止教本调试
//

function setNoScriptDebug: boolean;
var
  reg: TRegistry;
begin
  Result := true;
  reg := TRegistry.Create(KEY_ALL_ACCESS);
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKey
      ('\Software\Microsoft\Internet Explorer\AdvancedOptions\BROWSE\SCRIPT_DEBUGGER',
      true) then
    begin
      reg.WriteString('CheckedValue', 'no');
      reg.CloseKey
    end
    else
      Result := false;
  except
    Result := false;
  end;
  if assigned(reg) then
    reg.free;
end;

//
// 本地地址不使用Proxy
/// /

function setLocalWebNotUserProx: boolean;
var
  reg: TRegistry;
begin
  Result := true;
  reg := TRegistry.Create(KEY_ALL_ACCESS);
  try
    reg.RootKey := HKEY_CURRENT_USER;
    if reg.OpenKey
      ('\Software\Microsoft\Windows\CurrentVersion\Internet Settings', true)
    then
    begin
      reg.WriteString('ProxyOverride', '<local>');
      reg.CloseKey
    end
    else
      Result := false;
  except
    Result := false;
  end;
  if assigned(reg) then
    reg.free;
end;

function getMyHostName: string;
var
  wVersionRequested: word;
  wsaData: TWSADATA;
  p: PHostEnt;
  s: array [0 .. 128] of char;
begin
  { 启动 WinSock }
  wVersionRequested := MAKEWORD(1, 1);
  WSAStartup(wVersionRequested, wsaData);

  { 计算机名 }
  GetHostName(@s, 128);
  p := GetHostByName(@s);
  Result := p^.h_Name;
  WSACleanup;
end;

function getMyIP: string;
var
  wVersionRequested: word;
  wsaData: TWSADATA;
  p: PHostEnt;
  s: array [0 .. 128] of char;
  p2: {$IFDEF UNICODE} pAnsiChar {$ELSE} Pchar{$ENDIF};
begin
  { 启动 WinSock }
  wVersionRequested := MAKEWORD(1, 1);
  WSAStartup(wVersionRequested, wsaData);

  { 计算机名 }
  GetHostName(@s, 128);
  p := GetHostByName(@s);

  { IP地址 }
  p2 := inet_ntoa(PInAddr(p^.h_addr_list^)^);
  Result := p2;

  WSACleanup;
end;

function startWith(s, search: string): boolean;
begin
  Result := s.StartsWith(search);//   pos(search, s) = 1;
end;

//
// 将程序strExeFileName置为自动启动
//

function StartUpMyProgram(const AKey: string = '';
  AExename: string = ''): boolean;
var
  key, name: string;
begin
  // 建立一个Registry实例
  with TRegistry.Create do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    // 设置根键值为HKEY_LOCAL_MACHINE
    // 找到Software\Microsoft\Windows\CurrentVersion\Run
    if OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', true) then
    // 写入自己程序的快捷方式信息
    begin
      if AKey = '' then
        key := strPrompt
      else
        key := AKey;

      if AExename = '' then
        name := Application.ExeName
      else
        name := AExename;

      WriteString(key, name);
      Result := true;
    end
    else
      Result := false;
    // 善后处理
    CloseKey;
    free;
  end;
end;

function UnStartUpMyProgram(const AKey: string = ''): boolean;
begin
  // 建立一个Registry实例
  with TRegistry.Create do
  begin
    RootKey := HKEY_LOCAL_MACHINE;
    // 设置根键值为HKEY_LOCAL_MACHINE
    // 找到Software\Microsoft\Windows\CurrentVersion\Run
    if OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', true) then
    // 写入自己程序的快捷方式信息
    begin
      if AKey = '' then
        deleteValue(strPrompt)
      else
        deleteValue(AKey);

      Result := true;
    end
    else
      Result := false;
    // 善后处理
    CloseKey;
    free;
  end;
end;

procedure BMP2JPG(bmpfile: string; jpgfile: string);
var
  img: TImage;
  jpg: TJPEGIMage;
begin
  img := TImage.Create(nil);
  jpg := TJPEGIMage.Create;
  try
    img.Picture.LoadFromFile(bmpfile);
    jpg.Assign(img.Picture.Graphic);
    jpg.SaveToFile(jpgfile);
    deletefile(Pchar(bmpfile));
  finally
    img.free;
    jpg.free;
  end;
end;

function GetExecutePath: string;
begin
  Result := extractFilePath(Application.ExeName);
end;

function GetTempDirectory: string;
var
  TempDir: array [0 .. 255] of char;
begin
  GetTempPath(255, @TempDir);
  Result := StrPas(TempDir);
end;

function OnLine: boolean;
var
  ConnectState: DWORD;
  StateSize: DWORD;
begin
  ConnectState := 0;
  StateSize := Sizeof(ConnectState);
  Result := false;
  if InternetQueryOption(nil, INTERNET_OPTION_CONNECTED_STATE, @ConnectState,
    StateSize) then
    if (ConnectState and INTERNET_STATE_DISCONNECTED) <> 2 then
      Result := true;
end;

// 产生唯一的ID，在第一次调用此函数前，需要将GlobalID置为零
//

function generateID: integer;
var
  hMutex: THandle;
begin
  hMutex := newMutex('getgenerateID');
  inc(GlobalID);
  Result := GlobalID;
  freeMutex(hMutex);
end;

function newMutex(const AMutesID: string = 'MVCBr'): THandle;
var
  hMutex: THandle;
  Err: DWORD;
begin
  hMutex := CreateMutex(nil, false, Pchar(AMutesID));
  Err := GetLastError();
  if (Err = ERROR_ALREADY_EXISTS) then // ????,??
  begin
    WaitforSingleObject(hMutex, INFINITE); // 8000L);
    hMutex := CreateMutex(nil, false, 'generateID');
  end;
  Result := hMutex;
end;

procedure freeMutex(AMutexHandle: THandle);
begin
  ReleaseMutex(AMutexHandle);
end;

procedure ShowBlankPage(WebBrowser: TWebBrowser);
var
  URL: OleVariant;
begin
  URL := 'about:blank';
  WebBrowser.Navigate2(URL);
end;

function ParamInCommandline(APAram: string): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 1 to paramCount do
  begin
    if (lowercase(paramstr(i)) = lowercase(APAram)) then
    begin
      Result := true;
      break;
    end;
  end;
end;

function getSystemPath: string;
var
  MySysPath: Pchar;
begin
  GetMem(MySysPath, 255);
  GetSystemDirectory(MySysPath, 255);
  Result := MySysPath;
  FreeMem(MySysPath);
end;

{ This way uses a File stream. }

procedure FileCopy(const sourcefilename, targetfilename: string);
begin
  with TFormCopyFile.Create(nil) do
  begin
    show;
    lblFrom.caption := 'Copying file: ' + extractFileName(sourcefilename) + ' ';

    update;
    copyFile(Pchar(sourcefilename), Pchar(targetfilename), false);
    close;
    free;
  end;
end;

function isHung(theWindow: HWND; timeOut: Longint): boolean;
var
  dwResult: DWORD;
  i: integer;
begin
  i := SendMessageTimeout(theWindow, WM_NULL, 0, 0, SMTO_ABORTIFHUNG or
    SMTO_BLOCK, timeOut, dwResult);
  Result := i <> 0;
end;

function ProgramNotRunning(WHandle: THandle): boolean;
var
  dwExitCode: DWORD;
  fprocessExit: boolean;
begin
  dwExitCode := 0;
  fprocessExit := GetExitCodeProcess(WHandle, dwExitCode);
  Result := (fprocessExit and (dwExitCode <> STILL_ACTIVE));
end;

function ChangeSystemDateTime(dtNeeded: TDateTime): boolean;
var
  // tzi: TTimeZoneInformation;
  dtSystem: TSystemTime;
begin
  // GetTimeZoneInformation(tzi);
  // dtNeeded := dtNeeded + tzi.Bias / 1440;
  datetimeToSystemTime(dtNeeded, dtSystem);
  { with dtSystem do
    begin
    wYear := StrToInt(FormatDateTime('yyyy', dtNeeded));
    wMonth := StrToInt(FormatDateTime('mm', dtNeeded));
    wDay := StrToInt(FormatDateTime('dd', dtNeeded));
    wHour := StrToInt(FormatDateTime('hh', dtNeeded));
    wMinute := StrToInt(FormatDateTime('nn', dtNeeded));
    wSecond := StrToInt(FormatDateTime('ss', dtNeeded));
    wMilliseconds := 0;
    end;
  }
  Result := SetLocalTime(dtSystem);
end;

procedure HideTaskbar; // 隐藏
var
  wndHandle: THandle;
  wndClass: array [0 .. 50] of char;
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle := FindWindow(@wndClass[0], nil);
  ShowWindow(wndHandle, SW_HIDE);
end;

procedure ShowTaskbar; // 显示
var
  wndHandle: THandle;
  wndClass: array [0 .. 50] of char;
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle := FindWindow(@wndClass[0], nil);
  ShowWindow(wndHandle, SW_RESTORE);
end;

procedure SetMediaAudioOff(DeviceID: word);
var
  SetParm: TMCI_SET_PARMS;
begin
  SetParm.dwAudio := MCI_SET_AUDIO_ALL;
  mciSendCommand(DeviceID, MCI_SET, MCI_SET_AUDIO or MCI_SET_OFF,
    Longint(@SetParm));
end;

procedure SetMediaAudioOn(DeviceID: word);
var
  SetParm: TMCI_SET_PARMS;
begin
  SetParm.dwAudio := MCI_SET_AUDIO_ALL;
  mciSendCommand(DeviceID, MCI_SET, MCI_SET_AUDIO or MCI_SET_ON,
    Longint(@SetParm));
end;

//
// this function is for reboot and shutdown use
//

procedure AdjustToken;
var
  hdlProcessHandle: cardinal;
  hdlTokenHandle: {$IFDEF UNICODE} NativeUInt {$ELSE} cardinal{$ENDIF};
  tmpLuid: Int64;
  // tkpPrivilegeCount: Int64;
  tkp: TOKEN_PRIVILEGES;
  tkpNewButIgnored: TOKEN_PRIVILEGES;
  lBufferNeeded: cardinal;
  Privilege: array [0 .. 0] of _LUID_AND_ATTRIBUTES;
begin
  hdlProcessHandle := GetCurrentProcess;
  OpenProcessToken(hdlProcessHandle, (TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY),
    hdlTokenHandle);

  // Get the LUID for shutdown privilege.
  LookupPrivilegeValue('', 'SeShutdownPrivilege', tmpLuid);
  Privilege[0].Luid := tmpLuid;
  Privilege[0].Attributes := SE_PRIVILEGE_ENABLED;
  tkp.PrivilegeCount := 1; // One privilege to set
  tkp.Privileges[0] := Privilege[0];
  // Enable the shutdown privilege in the access token of this
  // process.
  windows.AdjustTokenPrivileges(hdlTokenHandle, false, tkp,
    Sizeof(tkpNewButIgnored), tkpNewButIgnored, lBufferNeeded);
end;

// reboot the computer
//

procedure reboot;
begin
  AdjustToken;
  ExitWindowsEx((EWX_SHUTDOWN or EWX_FORCE or EWX_REBOOT), $FFFF);
end;

procedure shutdown;
begin
  AdjustToken;
  ExitWindowsEx(EWX_SHUTDOWN or EWX_FORCE, $FFFF);
end;

procedure terminate;
begin
  KillProcess(Application.Handle);
end;

// kill a process with given window handle

procedure KillProcess(hWindowHandle: HWND);
var
  hprocessID: integer;
  processHandle: THandle;
  dwResult: DWORD;
begin
  SendMessageTimeout(hWindowHandle, WM_CLOSE, 0, 0, SMTO_ABORTIFHUNG or
    SMTO_NORMAL, 5000, dwResult);

  if isWindow(hWindowHandle) then
  begin
    // PostMessage(hWindowHandle, WM_QUIT, 0, 0);

    { Get the process identifier for the window }
    windows.GetWindowThreadProcessID(hWindowHandle, @hprocessID);
    if hprocessID <> 0 then
    begin
      { Get the process handle }
      processHandle := OpenProcess(PROCESS_TERMINATE or
        PROCESS_QUERY_INFORMATION, false, hprocessID);
      if processHandle <> 0 then
      begin
        { Terminate the process }
        TerminateProcess(processHandle, 0);
        CloseHandle(processHandle);
      end;
    end;
  end;
end;

/// ////////////////////////////////////////////////////////////////
// Call back function used to set the initial browse directory.
/// ////////////////////////////////////////////////////////////////

function BrowseForFolderCallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: lParam)
  : integer stdcall;
begin
  if uMsg = BFFM_INITIALIZED then
    sendMessage(Wnd, BFFM_SETSELECTION, 1, integer(@lg_StartFolder[1]));
  Result := 0;
end;

/// ////////////////////////////////////////////////////////////////
// This function allows the user to browse for a folder
//
// Arguments:-
// browseTitle : The title to display on the browse dialog.
// initialFolder : Optional argument. Use to specify the folder
// initially selected when the dialog opens.
//
// Returns: The empty string if no folder was selected (i.e. if the
// user clicked cancel), otherwise the full folder path.
/// ////////////////////////////////////////////////////////////////

function BrowseForFolder(const browseTitle: string;
  const initialFolder: string = ''; ext: string = ''): string;
 begin
  Result := initialFolder;
  if ext='' then
  begin
  with TFileOpenDialog.Create(nil) do
    try
      if ext = '' then
      begin
        title := 'Selecione a pasta';
        Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
        FileName := initialFolder;
      end
      else
      begin
        FileName := ext;
        DefaultFolder := initialFolder;
      end;
      OkButtonLabel := 'Ok';
      if Execute then
        Result := FileName;
    finally
      free;
    end;
  end else
  begin

     with TOpenDialog.create(nil) do
     try
       InitialDir := initialFolder;
       Filter := 'Arquivo ('+ext+')|'+ext;
       if execute then
          result := FileName;
     finally
       free;
     end;

  end;
end;

// procedure debug(s: string);
// begin
// {$IFDEF INFODEBUG}
// TFormDebug.getInstance.DebugInfo(s);
// {$ENDIF}
// end;

end.
