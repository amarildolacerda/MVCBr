{ *************************************************************************** }
{ }
{ MVCBr é o resultado de esforços de um grupo }
{ }
{ Copyright (C) 2017 MVCBr }
{ }
{ amarildo lacerda }
{ http://www.tireideletra.com.br }
{ }
{ }
{ *************************************************************************** }
{ }
{ Licensed under the Apache License, Version 2.0 (the "License"); }
{ you may not use this file except in compliance with the License. }
{ You may obtain a copy of the License at }
{ }
{ http://www.apache.org/licenses/LICENSE-2.0 }
{ }
{ Unless required by applicable law or agreed to in writing, software }
{ distributed under the License is distributed on an "AS IS" BASIS, }
{ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{ See the License for the specific language governing permissions and }
{ limitations under the License. }
{ }
{ *************************************************************************** }
unit MVCBr.Patterns.Facade.First;

interface

uses System.Classes, System.SysUtils, System.RTTI, System.Generics.Collections;

type

  TMVCBrFacateFunc = TFunc<TValue, boolean>;

  IMVCBrFacade = interface
    ['{A7519403-F83B-415A-87AB-2015EE4C4618}']
    function GetItems(idx: integer): TMVCBrFacateFunc;
    procedure SetItems(idx: integer; AValue: TMVCBrFacateFunc);
    procedure Add(ACommand: string; AFunc: TMVCBrFacateFunc);
    procedure Remove(ACommand: string);
    function Contains(ACommand: string): boolean;
    function Count: integer;
    function Execute(ACommand: String; AValue: TValue): boolean;
    property Items[idx: integer]: TMVCBrFacateFunc read GetItems write SetItems;
    procedure ForEach(AValue: TValue; AExecuteBool: TFunc < string, boolean >= nil);
    function GetItem(ACommand: String): TMVCBrFacateFunc;
  end;

  TTDictionaryFacadeCommands = class(TDictionary<string, TMVCBrFacateFunc>);

  [Depredicated( 'Usar MVCBr.Patterns.Facade' )]
  TMVCBrFacade = class(TInterfacedObject, IMVCBrFacade)
  private type
  private
    FSender: TValue;
    FLock: TObject;
    FCommands: TTDictionaryFacadeCommands;
    function GetItems(idx: integer): TMVCBrFacateFunc;
    procedure SetItems(idx: integer; AValue: TMVCBrFacateFunc);
  public
    constructor Create(ASender: TValue); virtual;
    Destructor Destroy; override;
    class function New: IMVCBrFacade; overload;
    class function New(ASender: TValue): IMVCBrFacade; overload;
    procedure Add(ACommand: string; AFunc: TMVCBrFacateFunc); virtual;
    procedure Remove(ACommand: string);
    function Count: integer;
    property Items[idx: integer]: TMVCBrFacateFunc read GetItems write SetItems;
    function Contains(ACommand: string): boolean;
    function LockList: TTDictionaryFacadeCommands;
    procedure UnlockList;
    function Execute(ACommand: String; AValue: TValue): boolean; overload; virtual;
    function Execute(ACommand: String): boolean; overload; virtual;
    procedure ForEach(AValue: TValue; AExecuteBool: TFunc < string, boolean >= nil);
    function GetItem(ACommand: String): TMVCBrFacateFunc;
  end;

implementation

{ TMVCBrFacade<T> }

procedure TMVCBrFacade.Add(ACommand: string; AFunc: TMVCBrFacateFunc);
begin
  with LockList do
    try
      AddOrSetValue(ACommand, AFunc);
    finally
      UnlockList;
    end;
end;

function TMVCBrFacade.Contains(ACommand: string): boolean;
begin
  result := LockList.ContainsKey(ACommand);
  UnlockList;
end;

function TMVCBrFacade.Count: integer;
begin
  result := LockList.Count;
  UnlockList;
end;

constructor TMVCBrFacade.Create(ASender: TValue);
begin
  inherited Create;
  FSender := ASender;
  FCommands := TTDictionaryFacadeCommands.Create();
  FLock := TObject.Create;
end;

destructor TMVCBrFacade.Destroy;
begin
  FSender := nil;
  FCommands.free;
  FLock.free;
  inherited;
end;

function TMVCBrFacade.Execute(ACommand: String): boolean;
begin
  result := Execute(ACommand, FSender);
end;

function TMVCBrFacade.Execute(ACommand: String; AValue: TValue): boolean;
var
  AFunc: TFunc<TValue, boolean>;
begin
  with LockList do
    try
      if TryGetValue(ACommand, AFunc) then
        if assigned(AFunc) then
          result := AFunc(AValue);
    finally
      UnlockList;
    end;
end;

procedure TMVCBrFacade.ForEach(AValue: TValue; AExecuteBool: TFunc < string, boolean >= nil);
var
  ACommand: string;
  AItem: TPair<string, TMVCBrFacateFunc>;
  AFunc: TMVCBrFacateFunc;
  rt: boolean;
begin
  with LockList do
    try
      for AItem in FCommands do
      begin
        if assigned(AExecuteBool) and (not AExecuteBool(AItem.Key)) then
          continue;
        AFunc := AItem.Value;
        if assigned(AFunc) then
        begin
          rt := (AFunc(AValue));
          if rt then
            break;
        end;
      end;
    finally
      UnlockList;
    end;
end;

function TMVCBrFacade.GetItem(ACommand: String): TMVCBrFacateFunc;
begin
  LockList.TryGetValue(ACommand, result);
  UnlockList;
end;

function TMVCBrFacade.GetItems(idx: integer): TMVCBrFacateFunc;

begin
  result := LockList.Values.ToArray[idx];
  UnlockList;
end;

function TMVCBrFacade.LockList: TTDictionaryFacadeCommands;
begin
  TMonitor.Enter(FLock);
  result := FCommands;
end;

class function TMVCBrFacade.New(ASender: TValue): IMVCBrFacade;
begin
  result := TMVCBrFacade.Create(ASender);
end;

class function TMVCBrFacade.New: IMVCBrFacade;
begin
  result := New(nil);
end;

procedure TMVCBrFacade.Remove(ACommand: string);
begin
  with LockList do
    try
      Remove(ACommand);
    finally
      UnlockList;
    end;
end;

procedure TMVCBrFacade.SetItems(idx: integer; AValue: TMVCBrFacateFunc);
begin
  LockList.Values.ToArray[idx] := AValue;
  UnlockList;
end;

procedure TMVCBrFacade.UnlockList;
begin
  TMonitor.Exit(FLock);
end;

end.
