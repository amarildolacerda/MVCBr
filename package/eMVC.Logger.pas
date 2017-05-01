unit eMVC.Logger;

{ ********************************************************************** }
{ Copyright 2005 Reserved by Eazisoft.com }
{ File Name: Logger.pas }
{ Author: Larry Le }
{ Description: }
{ Implement  a simple log }
{ }
{ History: }
{ - 1.0, 19 May 2006 }
{ First version }
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

uses classes,
  forms,
{$IFDEF VER130}
  FileCtrl,
{$ENDIF}
  sysutils;

type
  TLogger = class(TObject)
  private
    iMemo: TStringList;
    iFilename: string;
    function makeLogName: string;
    procedure doWrite(info: string);
  public
    log_on: boolean; // if false,no log will write,default is true;
    debug: boolean; // if false,no debug info will write,default true;
    class function getInstance: TLogger;
    constructor Create;
    destructor Destroy; override;
    procedure writeDebug(info: string);
    procedure writeError(info: string);
  end;

var
  log: TLogger;

  // function getLogInstance: TLogger;

implementation

class function TLogger.getInstance: TLogger;
begin
  if not assigned(log) then
    log := TLogger.Create;
  result := log;
end;

procedure TLogger.writeDebug(info: string);
begin
  if (debug) then
  begin
    doWrite(formatDatetime('dd/mm/yy,hh:mm:ss zzz', now) + ':DEBUG | ' + info);
  end;

end;

procedure TLogger.writeError(info: string);
begin
  doWrite(formatDatetime('dd/mm/yy,hh:mm:ss zzz', now) + ':ERROR | ' + info);
end;

procedure TLogger.doWrite(info: string);
begin
  if (log_on) and (trim(info) <> '') then
  begin
    iMemo.Insert(0, info);
    iMemo.SaveToFile(iFilename);
  end;
  info := '';
end;

function TLogger.makeLogName: string;
var
  dir, ext: string;
  dd, mm, yy: word;
begin
  log_on := true;
  debug := true;

  dir := extractFilePath(application.ExeName) + 'log';
  if not DirectoryExists(dir) then
    createDir(dir);

  iFilename := extractFileName(application.ExeName);
  ext := extractFileExt(iFilename);
  delete(iFilename, pos(ext, iFilename), length(ext));
  decodeDate(now, yy, mm, dd);
  iFilename := dir + '\' + iFilename + format('%2.2d%2.2d%2.2d', [dd, mm, yy]
    ) + '.log';
  result := iFilename;
end;

constructor TLogger.Create;
begin
  makeLogName;
  iMemo := TStringList.Create;
  iMemo.Clear;

  if FileExists(iFilename) then
  begin
    iMemo.LoadFromFile(iFilename);
  end;
end;

destructor TLogger.Destroy;
begin
  iMemo.Clear;
  freeAndNil(iMemo);
  inherited;
end;

initialization

begin
  if not assigned(log) then
    log := TLogger.Create;
end

finalization

begin
  try
    if assigned(log) then
      freeAndNil(log);
  except
  end;
end;

end.
