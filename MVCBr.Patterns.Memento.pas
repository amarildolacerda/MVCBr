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
    function GetItems(idx: integer): T;
    procedure SetItems(idx: integer; const Value: T);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(AValue: T): integer; virtual;
    function Peek: T; virtual;
    function Pop: T; virtual;
    function Count: integer; virtual;
    procedure Delete(AIdx: integer); virtual;
    property Items[idx: integer]: T read GetItems write SetItems;
  end;

  TMVCBrMementoList<T> = class(TThreadSafeObjectList <
    TMVCBrMementoItem < T >> )
  private
    FMaxItens: integer;
    procedure SetMaxItens(const Value: integer);
  public
    function IndexOf(AKey: string): integer; virtual;
    function ItemsCount(AId: String): integer; virtual;
    function Add(AId: string; AInfo: T): integer; virtual;
    function Undo(AId: string): T; virtual;
    function Peek(AId: string): T; virtual;
    procedure Clear(AId: string); overload; virtual;
    function Remove(AId: String; AInfo: T): integer; virtual;
    property MaxItens: integer read FMaxItens write SetMaxItens;

  end;

  TMVCBrMementoFactory<T> = class(TInterfacedObject, IMVCBrMemento<T>)
  private
    FMemento: TMVCBrMementoList<T>;
    procedure SetMaxItens(const Value: integer);
    function GetMaxItens: integer;
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
    function Peek(AId: string): T; virtual;
    procedure Clear(AId: string); overload; virtual;
    procedure Clear; overload; virtual;
    function Remove(AId: string; AInfo: T): boolean; virtual;
    function ItemsCount(AId: String): integer;
    property MaxItens: integer read GetMaxItens write SetMaxItens;
  end;

implementation

Uses System.Generics.defaults, System.RTTI.Helper;

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
        it := Items[result];
      it.Add(AInfo);
      while (FMaxItens >= 0) and (it.Count > (FMaxItens)) do
        it.Delete(0);
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
        Items[i].FItems.Clear;
      finally
        unlocklist;
      end;
end;

procedure TMVCBrMementoFactory<T>.Empty;
begin
  FMemento.Clear;
end;

function TMVCBrMementoFactory<T>.GetMaxItens: integer;
begin
  result := FMemento.MaxItens;
end;

function TMVCBrMementoFactory<T>.Invoke(AKey: string): T;
var
  i: integer;
begin
  i := FMemento.IndexOf(AKey);
  if i >= 0 then
    with FMemento.LockList do
      try
        result := Items[i].Peek;
      finally
        FMemento.unlocklist;
      end;
end;

function TMVCBrMementoFactory<T>.ItemsCount(AId: String): integer;
begin
  result := FMemento.ItemsCount(AId);
end;

function TMVCBrMementoFactory<T>.Add(AId: string; AInfo: T): integer;
begin
  result := FMemento.Add(AId, AInfo);
end;

procedure TMVCBrMementoFactory<T>.Clear(AId: string);
begin
  FMemento.Clear(AId);
end;

procedure TMVCBrMementoFactory<T>.Clear;
begin
  FMemento.Clear;
end;

constructor TMVCBrMementoFactory<T>.Create;
begin
  FMemento := TMVCBrMementoList<T>.Create;
  MaxItens := -1;
end;

destructor TMVCBrMementoFactory<T>.Destroy;
begin
  FMemento.Clear;
  FMemento.free;
  FMemento := nil;
  inherited;
end;

class function TMVCBrMementoFactory<T>.New: IMVCBrMemento<T>;
var
  r: TMVCBrMementoFactory<T>;
begin
  r := TMVCBrMementoFactory<T>.Create;
  result := r;
end;

function TMVCBrMementoFactory<T>.Peek(AId: string): T;
begin
  result := FMemento.Peek(AId);
end;

function TMVCBrMementoFactory<T>.Remove(AId: string; AInfo: T): boolean;
begin
  result := FMemento.Remove(AId, AInfo) > 0;
end;

procedure TMVCBrMementoFactory<T>.SetMaxItens(const Value: integer);
begin
  FMemento.MaxItens := Value;
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
        result := Items[i].Pop;
      finally
        unlocklist;
      end;
end;

{ TMVCBrMementoItem }

function TMVCBrMementoItem<T>.Add(AValue: T): integer;
begin
  result := FItems.Add(AValue);
end;

function TMVCBrMementoItem<T>.Count: integer;
begin
  result := FItems.Count;
end;

constructor TMVCBrMementoItem<T>.Create;
begin
  inherited;
  FItems := TList<T>.Create;
end;

procedure TMVCBrMementoItem<T>.Delete(AIdx: integer);
begin
  FItems.Delete(AIdx);
end;

destructor TMVCBrMementoItem<T>.Destroy;
begin
  FKey := '';
  while FItems.Count > 0 do
    Pop;
  FItems.free;
  inherited;
end;

function TMVCBrMementoItem<T>.GetItems(idx: integer): T;
begin
  result := T(FItems[idx]);
end;

function TMVCBrMementoItem<T>.Peek: T;
var
  i: integer;
begin
  i := FItems.Count - 1;
  if i >= 0 then
    result := FItems.Items[i];
end;

function TMVCBrMementoItem<T>.Pop: T;
var
  i: integer;
begin
  i := FItems.Count - 1;
  if i >= 0 then
  begin
    result := FItems.Items[i];
    FItems.Delete(i);
  end;
end;

procedure TMVCBrMementoItem<T>.SetItems(idx: integer; const Value: T);
begin
  FItems[idx] := Value;
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
        if Items[i].FKey.equals(AKey) then
          exit(i);
    finally
      unlocklist;
    end;
end;

function TMVCBrMementoList<T>.ItemsCount(AId: String): integer;
begin
  result := 0;
  if IndexOf(AId) >= 0 then
    result := Items[result].FItems.Count;
end;

function TMVCBrMementoList<T>.Peek(AId: string): T;
var
  i, x: integer;
begin
  i := IndexOf(AId);
  if i >= 0 then
    with LockList do
      try
        result := Items[i].Peek;
      finally
        unlocklist;
      end;
end;

function TMVCBrMementoList<T>.Remove(AId: String; AInfo: T): integer;
var
  i, x: integer;
  lComparer: IEqualityComparer<T>;
  AVal: T;
begin
  result := 0;
  i := IndexOf(AId);
  if i >= 0 then
    with LockList do
      try
        lComparer := TEqualityComparer<T>.Default;
        for x := Items[i].FItems.Count - 1 downto 0 do
        begin
          AVal := Items[i].FItems[x];
          if lComparer.equals(AInfo, AVal) then
          begin
            Items[i].FItems.Delete(x);
            inc(result);
          end;
        end;
      finally
        unlocklist;
      end;
end;

procedure TMVCBrMementoList<T>.SetMaxItens(const Value: integer);
begin
  FMaxItens := Value;
end;

end.
