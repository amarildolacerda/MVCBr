{ *************************************************************************** }
{ }
{ }
{ Copyright (C) Amarildo Lacerda }
{ }
{ https://github.com/amarildolacerda }
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


unit MVCBr.Patterns.Memento;

interface

Uses System.Classes, System.SysUtils,
  System.Json, System.RTTI, System.Generics.Collections,
  System.ThreadSafe;

type

  IMVCBrMemento<T> = interface(TFunc<string, T>)
    ['{9B4CCA4D-F956-43B5-B067-A549FBA4241B}']
    // function Add(AId: string; AInfo: T): integer;
    // function Undo(AId: string): T;
  end;

  TMVCBrMementoItem<T> = class
  private
    FKey: string;
    FItems: TList<T>;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(AValue: T): integer; virtual;
    function Peek: T; virtual;
    function Pop: T; virtual;
  end;

  TMVCBrMementoList<T> = class(TThreadSafeObjectList <
    TMVCBrMementoItem < T >> )
  public
    function IndexOf(AKey: string): integer; virtual;
    function Add(AId: string; AInfo: T): integer; virtual;
    function Undo(AId: string): T; virtual;
    procedure Clear(AId: string); overload; virtual;
  end;

  TMVCBrMementoFactory<T> = class(TInterfacedObject, IMVCBrMemento<T>)
  private
    FMemento: TMVCBrMementoList<T>;
  protected
    function Invoke(AKey: string): T; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    class function New: IMVCBrMemento<T>;
    procedure Empty; overload; virtual;
    property Memento: TMVCBrMementoList<T> read FMemento;
    function Add(AId: string; AInfo: T): integer; virtual;
    function Undo(AId: string): T; virtual;
    procedure Clear(AId: string); overload; virtual;
  end;

implementation

{ TMVCBrMementoFactory }

function TMVCBrMementoList<T>.Add(AId: string; AInfo: T): integer;
var
  it: TMVCBrMementoItem<T>;
begin
  result := IndexOf(AId);
  with LockList do
    try
      if result < 0 then
      begin
        it := TMVCBrMementoItem<T>.Create;
        it.FKey := AId;
        result := Add(it);
      end
      else
        it := items[result];
      it.Add(AInfo);
    finally
      unlocklist;
    end;
end;

procedure TMVCBrMementoList<T>.Clear(AId: string);
var
  i: integer;
begin
  i := IndexOf(AId);
  if i >= 0 then
    with LockList do
      try
        items[i].FItems.Clear;
      finally
        unlocklist;
      end;
end;

procedure TMVCBrMementoFactory<T>.Empty;
begin
  FMemento.Clear;
end;

function TMVCBrMementoFactory<T>.Invoke(AKey: string): T;
var
  i: integer;
begin
  i := FMemento.IndexOf(AKey);
  if i >= 0 then
    with FMemento.LockList do
      try
        result := items[i].Peek;
      finally
        FMemento.unlocklist;
      end;
end;

function TMVCBrMementoFactory<T>.Add(AId: string; AInfo: T): integer;
begin
  result := FMemento.Add(AId, AInfo);
end;

procedure TMVCBrMementoFactory<T>.Clear(AId: string);
begin
  FMemento.Clear(AId);
end;

constructor TMVCBrMementoFactory<T>.Create;
begin
  FMemento := TMVCBrMementoList<T>.Create;
end;

destructor TMVCBrMementoFactory<T>.Destroy;
begin
  FMemento.Clear;
  FMemento.free;
  inherited;
end;

class function TMVCBrMementoFactory<T>.New: IMVCBrMemento<T>;
var
  r: TMVCBrMementoFactory<T>;
begin
  r := TMVCBrMementoFactory<T>.Create;
  result := r;
end;

function TMVCBrMementoFactory<T>.Undo(AId: string): T;
begin
  result := FMemento.Undo(AId);
end;

function TMVCBrMementoList<T>.Undo(AId: string): T;
var
  i, x: integer;
begin
  i := IndexOf(AId);
  if i >= 0 then
    with LockList do
      try
        result := items[i].Pop;
      finally
        unlocklist;
      end;
end;

{ TMVCBrMementoItem }

function TMVCBrMementoItem<T>.Add(AValue: T): integer;
begin
  result := FItems.Add(AValue);
end;

constructor TMVCBrMementoItem<T>.Create;
begin
  inherited;
  FItems := TList<T>.Create;
end;

destructor TMVCBrMementoItem<T>.Destroy;
begin
  FKey := '';
  while FItems.Count > 0 do
    Pop;
  FItems.free;
  inherited;
end;

function TMVCBrMementoItem<T>.Peek: T;
var
  i: integer;
begin
  i := FItems.Count - 1;
  result := FItems.items[i];
end;

function TMVCBrMementoItem<T>.Pop: T;
var
  i: integer;
begin
  i := FItems.Count - 1;
  result := FItems.items[i];
  FItems.delete(i);
end;

{ TMVCBrMementoList }

function TMVCBrMementoList<T>.IndexOf(AKey: string): integer;
var
  i: integer;
begin
  result := -1;
  with LockList do
    try
      for i := 0 to Count - 1 do
        if items[i].FKey.equals(AKey) then
          exit(i);
    finally
      unlocklist;
    end;
end;

end.
