
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

/// <summary>
///   TMVCBrFacade Class - Create commands to be execute by injection methods
///                Its a class inherited by TMVCBrBuilder class
/// </summary>

unit MVCBr.Patterns.Facade;

interface

uses System.Classes, System.SysUtils, System.RTTI,
  MVCBr.Patterns.Builder;

type

  TMVCBrFacateFunc = TFunc<TValue, boolean>;

  IMVCBrFacade = interface
    ['{734BBC32-4236-4B1B-BAE1-47F7DCF1D572}']
    function GetItems(idx: integer): TMVCBrFacateFunc;
    procedure SetItems(idx: integer; AValue: TMVCBrFacateFunc);
    procedure Add(ACommand: TValue; AFunc: TMVCBrFacateFunc);
    procedure Remove(ACommand: TValue);
    function Contains(ACommand: TValue): boolean;
    function Count: integer;
    function Execute(ACommand: TValue; AValue: TValue): boolean;
    property Items[idx: integer]: TMVCBrFacateFunc read GetItems write SetItems;
    procedure ForEach(AValue: TValue; AExecuteBool: TFunc < TValue, boolean >= nil);
    function GetItem(ACommand: TValue): TMVCBrFacateFunc;
  end;

  /// <summary>
  ///  TMVCBrFacade - Injection commands to be execute later
  ///                 tem por objetivo injetar comandos a serem executados
  ///  </summary>
  TMVCBrFacade = class(TMVCBrBuilderFactory<TValue, boolean>, IMVCBrFacade)
  public
    class function New: TMVCBrFacade;
    procedure Add(ACommand: TValue; AFunc: TMVCBrFacateFunc);
    function GetItems(idx: integer): TMVCBrFacateFunc;
    procedure SetItems(idx: integer; AValue: TMVCBrFacateFunc);
    procedure Remove(ACommand: TValue);
    function Contains(ACommand: TValue): boolean;
    function Execute(ACommand: TValue; AValue: TValue): boolean; overload;
    property Items[idx: integer]: TMVCBrFacateFunc read GetItems write SetItems;
    procedure ForEach(AValue: TValue; AExecuteBool: TFunc < TValue, boolean >= nil);
    function GetItem(ACommand: TValue): TMVCBrFacateFunc;
  end;

implementation

{ TMVCBrFacade }

procedure TMVCBrFacade.Add(ACommand: TValue; AFunc: TMVCBrFacateFunc);
begin
  inherited Add(ACommand, AFunc);
end;

function TMVCBrFacade.Contains(ACommand: TValue): boolean;
begin
  result := Builder.Contains(ACommand);
end;

function TMVCBrFacade.Execute(ACommand: TValue; AValue: TValue): boolean;
var
  i: integer;
  item: TMVCBrBuilderItem<string, boolean>;
begin
  result := false;
  i := Builder.IndexOf(ACommand);
  if Builder.isValid(i) then
  begin
    with LockList do
      try
        result := Items[i].Execute(AValue);
      finally
        unlocklist;
      end;
  end;
end;

procedure TMVCBrFacade.ForEach(AValue: TValue; AExecuteBool: TFunc<TValue, boolean>);
var
  i: integer;
  ACommand: string;
  AItem: IMVCBrBuilderItem<TValue, boolean>;
  rt: boolean;
  AFunc: TMVCBrFacateFunc;
begin
  with LockList do
    try
      for i := 0 to Count - 1 do
      begin
        if Builder.isValid(i) then
        begin
          AItem := Items[i];
          if assigned(AExecuteBool) and (not AExecuteBool(AItem.Command)) then
            continue;
          AFunc := AItem.Delegate;
          if assigned(AFunc) then
          begin
            rt := (AFunc(AValue));
            if rt then
              break;
          end;
        end;
      end;
    finally
      unlocklist;
    end;
end;

function TMVCBrFacade.GetItem(ACommand: TValue): TMVCBrFacateFunc;
var
  i: integer;
  item: IMVCBrBuilderItem<TValue, boolean>;
begin
  result := nil;
  i := Builder.IndexOf(ACommand);
  if Builder.isValid(i) then
  begin
    with LockList do
      try
        item := Items[i];
        result := item.Delegate;
      finally
        unlocklist;
      end;
  end;
end;

function TMVCBrFacade.GetItems(idx: integer): TMVCBrFacateFunc;
var
  item: IMVCBrBuilderItem<TValue, boolean>;
begin
  result := nil;
  if Builder.isValid(idx) then
  begin
    item := LockList.Items[idx];
    try
      if assigned(item) then
        result := item.Delegate;
    finally
      unlocklist;
    end;
  end;
end;

class function TMVCBrFacade.New: TMVCBrFacade;
begin
  result := TMVCBrFacade.Create(TMVCBrBuilder<TValue, boolean>.Create);
end;

procedure TMVCBrFacade.Remove(ACommand: TValue);
begin
  Builder.Remove(ACommand);
end;

procedure TMVCBrFacade.SetItems(idx: integer; AValue: TMVCBrFacateFunc);
begin
  if Builder.isValid(idx) then
    with LockList do
      try
        Items[idx].SetDelegate(AValue);
      finally
        unlocklist;
      end;
end;

end.
