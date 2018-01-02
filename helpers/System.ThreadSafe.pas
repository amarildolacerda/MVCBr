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

unit System.ThreadSafe;

interface

uses System.Classes, System.SysUtils, System.Generics.Collections, System.Json;

type

  IObjectAdapter<T> = interface(TFunc<T>)
  end;

  TObjectAdapter<T: Class> = Class(TInterfacedObject, IObjectAdapter<T>)
  private
    FInstance: T;
  public
    function Invoke: T;
  End;

  IObjectLock = Interface
    ['{172D89AE-268F-4312-BEF6-4F1A1B6A0F12}']
    procedure Lock;
    procedure UnLock;
  End;

  TObjectLock = class(TInterfacedObject, IObjectLock)
  private
    FLock: TObject;
  protected
    procedure Lock; virtual;
    procedure UnLock; virtual;
    function TryLock: boolean; virtual;
  public
    constructor create; virtual;
    destructor destroy; override;
  end;

  TStringListHelper = class helper for TStringList
  public
    procedure Erase(ATexto: string);
  end;

  TThreadSafeStringList = class;

  IStringList = interface
    ['{1A388037-6C6B-4D1E-968F-5D295A879C14}']
    function This: TThreadSafeStringList;
    procedure Clear;
    function Count: integer;

  end;

  TThreadSafeStringList = class(TObjectLock, IStringList)
  private
    FList: TStringList;
    FOnNotify: TNotifyEvent;
    function Getitems(AIndex: integer): string;
    procedure Setitems(AIndex: integer; const AValue: string);
    function GetDelimitedText: string;
    function GetDelimiter: Char;
    procedure SetDelimitedText(const AValue: string);
    procedure SetDelimiter(const AValue: Char);
    function GetCommaText: string;
    procedure SetCommaText(const AValue: string);
    function GetQuoteChar: Char;
    procedure SetQuoteChar(const AValue: Char);
    function GetValues(AName: string): String;
    procedure SetValues(AName: string; const Value: String);
    function GetNames(AIndex: integer): String;
    procedure SetNames(AIndex: integer; const Value: String);
    function GetValueFromIndex(idx: integer): string;
    procedure SetValueFromIndex(idx: integer; const Value: string);
    procedure SetOnNotify(const Value: TNotifyEvent);
  public
    constructor create; override;
    destructor destroy; override;
    class function New: IStringList;
    function This: TThreadSafeStringList;
    procedure Clear;
    function Count: integer;

    // stack
    procedure Push(AValue: String);
    function Pop: string;
    function Peek: String;
    function Extract: String;

    function IndexOf(const AText: string): integer;
    function IndexOfName(const AText: string): integer;
    function IndexOfValue(const AText: string): integer;
    procedure Add(const AText: string; const ADupl: boolean = true);
    procedure AddPair(AKey, AValue: string);
    procedure Default(AKey, AValue: string);
    function ContainsKey(AKey: String): boolean;
    procedure Delete(const AIndex: integer);
    procedure Remove(const AText: string);
    function LockList: TStringList;
    procedure UnlockList; inline;
    property Items[AIndex: integer]: string read Getitems
      write Setitems; default;
    property Delimiter: Char read GetDelimiter write SetDelimiter;
    property DelimitedText: string read GetDelimitedText write SetDelimitedText;
    function Text: string;
    property CommaText: string read GetCommaText write SetCommaText;
    property QuoteChar: Char read GetQuoteChar write SetQuoteChar;
    procedure Assing(AStrings: TStrings);
    procedure AssingTo(AStrings: TStrings);
    procedure AddTo(AStrings: TStrings);
    property Values[AName: string]: String read GetValues write SetValues;
    property Names[AIndex: integer]: String read GetNames write SetNames;
    property ValueFromIndex[idx: integer]: string read GetValueFromIndex
      write SetValueFromIndex;
    property OnNotify: TNotifyEvent read FOnNotify write SetOnNotify;
  end;

  TThreadSafeObjectList<T: Class> = class(TInterfacedObject, IUnknown)
  private
    FLock: TObject;
    FList: TObjectList<T>;
    function Getitems(AIndex: integer): T;
    procedure Setitems(AIndex: integer; const AValue: T);
  protected
    FItemClass: TClass;
  public
    constructor create(AOwnedObject: boolean = true); overload; virtual;
    constructor create(AClass: TClass); overload; virtual;
    destructor destroy; override;
    procedure Push(AValue: T); virtual;
    procedure Pop; virtual;
    function Peek: T; virtual;
    function Extract: T; virtual;
    function LockList: TList<T>;
    function TryLockList: TList<T>;
    procedure UnlockList;
    procedure Clear; virtual;
    function Add(AValue: T): integer; overload; virtual;
    function Append(AValue: T): T; overload; virtual;
    function Count: integer; virtual;
    property Items[AIndex: integer]: T read Getitems write Setitems; default;
    function IndexOf(AValue: T): integer; virtual;
    procedure Delete(AIndex: integer); virtual;
    procedure Remove(AValue: T); virtual;
    function Add: T; overload; virtual;
    procedure ForEach(AFunc: TFunc<T, boolean>); virtual;
    function ToJson: string; overload; virtual;
    function ToJsonArray: TJsonArray; virtual;
  end;

  TThreadedList<T: Class> = class(TThreadList)
  private
    function Getitems(idx: integer): T;
    procedure Setitems(idx: integer; const Value: T);
  public
    procedure Delete(AIdx: integer);
    function Count: integer;
    function Add(const AItem: T): integer; overload;
    property Items[idx: integer]: T read Getitems write Setitems;
    function Pop: T; virtual;
  end;

  TThreadSafeList<T: Class> = class(TThreadedList<T>)
  end;

  TThreadSafeInterfaceList<T: IInterface> = class(TInterfacedObject,
    IObjectLock)
  private
    FOwned: boolean;
    FList: TThreadList<T>;
    function Getitems(AIndex: integer): T;
    procedure Setitems(AIndex: integer; const AValue: T);
  public
    procedure Release; virtual;
    procedure Insert(AIndex: integer; AValue: T);
    function Add(AValue: T): integer;
    function IndexOf(AValue: T): integer;
    procedure Delete(AIndex: integer);
    procedure Remove(AValue: T);
    constructor create(AOwned: boolean = true); virtual;
    destructor destroy; override;
    function Count: integer;
    procedure Clear;
    function LockList: TList<T>;
    procedure UnlockList;
    procedure Lock;
    procedure UnLock;

    property Items[AIndex: integer]: T read Getitems write Setitems;
  end;

  TThreadSafeDictionary<TKey, TValue> = class
  private
    FOwnedList: TDictionaryOwnerShips;
    FInited: boolean;
    FLock: TObject;
    FDictionary: TObjectDictionary<TKey, TValue>;
    function GetItem(const Key: TKey): TValue;
    procedure SetItem(const Key: TKey; const Value: TValue);
    function Invoke: TObjectDictionary<TKey, TValue>;
    function GetCount: integer;
  public
    constructor create; Reintroduce; overload;
    constructor create(AOwnedList: TDictionaryOwnerShips); overload;
    destructor destroy; override;
    function LockList: TDictionary<TKey, TValue>;
    procedure UnlockList;

    function TryGetValue(const Key: TKey; out Value: TValue): boolean;
    procedure Add(const Key: TKey; const Value: TValue);
    procedure Remove(const Key: TKey);
    function ExtractPair(const Key: TKey): TPair<TKey, TValue>;
    procedure Clear;
    procedure TrimExcess;
    procedure AddOrSetValue(const Key: TKey; const Value: TValue);
    function ContainsKey(const Key: TKey): boolean;
    function ContainsValue(const Value: TValue): boolean;
    function ToArray: TArray<TPair<TKey, TValue>>;

    property Items[const Key: TKey]: TValue read GetItem write SetItem; default;
    property Count: integer read GetCount;
  end;

  TThreadSafeDictionaryObject<TValue: Class> = class
    (TThreadSafeDictionary<string, TValue>)
  public
    function ToJson: String;
    procedure FromJson(AJson: String);
  end;

implementation

{$IFNDEF BPL}

uses REST.Json, System.Classes.Helper;
{$ENDIF}

constructor TThreadSafeStringList.create;
begin
  inherited create;
  FList := TStringList.create;
end;

destructor TThreadSafeStringList.destroy;
begin
  FList.Free;
  inherited;
end;

function TThreadSafeStringList.Extract: String;
begin // nao chama o evento;
  // retorna a string e remove da lista
  with LockList do
    try
      if Count > 0 then
      begin
        result := FList[Count - 1];
        Delete(Count - 1);
      end
      else
        result := '';
    finally
      UnlockList;
    end;
end;

function TThreadSafeStringList.LockList: TStringList;
begin
  Lock;
  result := FList;
end;

class function TThreadSafeStringList.New: IStringList;
begin
  result := TThreadSafeStringList.create;
end;

function TThreadSafeStringList.Peek: String;
begin // retorna sem remover.
  result := '';
  with LockList do
    try
      if Count > 0 then
        result := FList[Count - 1];
    finally
      UnlockList;
    end;
end;

function TThreadSafeStringList.Pop: string;
begin // remove da lista e gera evento
  with LockList do
    try
      if Count > 0 then
      begin
        result := FList[Count - 1];
        Delete(Count - 1);
        if Assigned(FOnNotify) then
          FOnNotify(self);

      end
      else
        result := '';
    finally
      UnlockList;
    end;
end;

procedure TThreadSafeStringList.Push(AValue: String);
begin
  Add(AValue);
  if Assigned(FOnNotify) then
    FOnNotify(self);
end;

procedure TThreadSafeStringList.Remove(const AText: string);
var
  i: integer;
begin
  i := IndexOf(AText);
  if i >= 0 then
    Delete(i);
end;

procedure TThreadSafeStringList.UnlockList;
begin
  UnLock;
end;

procedure TThreadSafeStringList.Add(const AText: string;
  const ADupl: boolean = true);
begin
  Lock;
  try
    begin
      if (not ADupl) and (FList.IndexOf(AText) >= 0) then
        Exit;
      FList.Add(AText);
    end;
  finally
    UnLock;
  end;
end;

procedure TThreadSafeStringList.Default(AKey, AValue: string);
begin
  if not ContainsKey(AKey) then
    AddPair(AKey, AValue);
end;

procedure TThreadSafeStringList.Delete(const AIndex: integer);
begin
  try
    LockList.Delete(AIndex);
  finally
    UnlockList;
  end;
end;

function TThreadSafeStringList.ContainsKey(AKey: String): boolean;
begin
  result := IndexOfName(AKey) >= 0;
end;

function TThreadSafeStringList.Count: integer;
begin
  try
    result := LockList.Count;
  finally
    UnlockList;
  end;
end;

function TThreadSafeStringList.Getitems(AIndex: integer): string;
begin
  try
    result := LockList.Strings[AIndex];
  finally
    UnlockList;
  end;
end;

function TThreadSafeStringList.GetNames(AIndex: integer): String;
begin
  with LockList do
    try
      result := Names[AIndex];
    finally
      UnlockList;
    end;
end;

procedure TThreadSafeStringList.Setitems(AIndex: integer; const AValue: string);
begin
  try
    LockList.Strings[AIndex] := AValue;
  finally
    UnlockList;
  end;
end;

procedure TThreadSafeStringList.SetNames(AIndex: integer; const Value: String);
var
  sValue: String;
begin
  Lock;
  try
    sValue := FList.ValueFromIndex[AIndex];
    FList[AIndex] := Value + '=' + sValue;
  finally
    UnLock;
  end;
end;

procedure TThreadSafeStringList.SetOnNotify(const Value: TNotifyEvent);
begin
  FOnNotify := Value;
end;

function TThreadSafeStringList.Text: string;
begin
  try
    result := LockList.Text;
  finally
    UnlockList;
  end;
end;

function TThreadSafeStringList.This: TThreadSafeStringList;
begin
  result := self;
end;

function TThreadSafeStringList.GetDelimitedText: string;
begin
  try
    result := LockList.DelimitedText;
  finally
    UnlockList;
  end;
end;

function TThreadSafeStringList.GetDelimiter: Char;
begin

  try
    result := LockList.Delimiter;
  finally
    UnlockList;
  end;

end;

procedure TThreadSafeStringList.SetDelimitedText(const AValue: string);
begin
  try
    LockList.DelimitedText := AValue;
  finally
    UnlockList;
  end;

end;

procedure TThreadSafeStringList.SetDelimiter(const AValue: Char);
begin
  try
    LockList.Delimiter := AValue;
  finally
    UnlockList;
  end;

end;

function TThreadSafeStringList.GetCommaText: string;
var
  f: TStrings;
  i: integer;
begin
  f := LockList;
  try
    result := '';
    for i := 0 to f.Count - 1 do
    begin
      if i > 0 then
        result := result + ',';
      result := result + QuoteChar + f[i] + QuoteChar;
    end;
  finally
    UnlockList;
  end;
end;

procedure TThreadSafeStringList.SetCommaText(const AValue: string);
begin
  try
    LockList.CommaText := AValue;
  finally
    UnlockList;
  end;
end;

function TThreadSafeStringList.GetQuoteChar: Char;
begin
  try
    result := LockList.QuoteChar;
  finally
    UnlockList;
  end;

end;

function TThreadSafeStringList.GetValueFromIndex(idx: integer): string;
begin
  with LockList do
    try
      result := ValueFromIndex[idx];
    finally
      UnlockList;
    end;
end;

function TThreadSafeStringList.GetValues(AName: string): String;
begin
  with LockList do
    try
      result := Values[AName];
    finally
      UnlockList;
    end;
end;

function TThreadSafeStringList.IndexOf(const AText: string): integer;
begin
  with LockList do
    try
      result := IndexOf(AText);
    finally
      UnlockList;
    end;
end;

function TThreadSafeStringList.IndexOfName(const AText: string): integer;
begin
  try
    result := LockList.IndexOfName(AText);
  finally
    UnlockList;
  end;
end;

function TThreadSafeStringList.IndexOfValue(const AText: string): integer;
var
  i: integer;
begin
  result := -1;
  with LockList do
    try
      for i := 0 to Count - 1 do
        if sametext(AText, FList.ValueFromIndex[i]) then
        begin
          result := i;
          Exit;
        end;
    finally
      UnlockList;
    end;

end;

procedure TThreadSafeStringList.SetQuoteChar(const AValue: Char);
begin
  try
    LockList.QuoteChar := AValue;
  finally
    UnlockList;
  end;
end;

procedure TThreadSafeStringList.SetValueFromIndex(idx: integer;
  const Value: string);
begin
  with LockList do
    try
      ValueFromIndex[idx] := Value;
    finally
      UnlockList;
    end;
end;

procedure TThreadSafeStringList.SetValues(AName: string; const Value: String);
begin
  with LockList do
    try
      Values[AName] := Value;
    finally
      UnlockList;
    end;
end;

procedure TThreadSafeStringList.AddPair(AKey, AValue: string);
begin
  Add(AKey + '=' + AValue);
end;

procedure TThreadSafeStringList.AddTo(AStrings: TStrings);
begin
  try
    AStrings.AddStrings(LockList);
  finally
    UnlockList;
  end;
end;

procedure TThreadSafeStringList.Assing(AStrings: TStrings);
begin
  with LockList do
    try
      Assign(AStrings);
    finally
      UnlockList;
    end;
end;

procedure TThreadSafeStringList.AssingTo(AStrings: TStrings);
begin
  try
    AStrings.Assign(LockList);
  finally
    UnlockList;
  end;
end;

procedure TThreadSafeStringList.Clear;
begin
  try
    LockList.Clear;
  finally
    UnlockList;
  end;
end;

{ TObjectLocked }

constructor TObjectLock.create;
begin
  inherited;
  FLock := TObject.create;
end;

destructor TObjectLock.destroy;
begin
  FLock.Free;
  inherited;
end;

procedure TObjectLock.Lock;
begin
  System.TMonitor.Enter(FLock); // Bloqueia o objeto
end;

function TObjectLock.TryLock: boolean;
begin
  result := System.TMonitor.TryEnter(FLock);
end;

procedure TObjectLock.UnLock;
begin
  System.TMonitor.Exit(FLock); // Libera o objeto
end;

{ TThreadObjectList }

function TThreadSafeObjectList<T>.Add(AValue: T): integer;
begin
  with LockList do
    try
      result := Count;
      Add(AValue);
    finally
      UnlockList;
    end;
end;

function TThreadSafeObjectList<T>.Add: T;
begin
  result := T(FItemClass.NewInstance);
  Add(result);
end;

function TThreadSafeObjectList<T>.Append(AValue: T): T;
begin
  result := AValue;
  with LockList do
    try
      Add(AValue);
    finally
      UnlockList;
    end;
end;

procedure TThreadSafeObjectList<T>.Clear;
begin
  with LockList do
    try
      Clear;
    finally
      UnlockList;
    end;
end;

function TThreadSafeObjectList<T>.Count: integer;
begin
  with LockList do
    try
      result := Count;
    finally
      UnlockList;
    end;
end;

constructor TThreadSafeObjectList<T>.create(AClass: TClass);
begin
  create(true);
  FItemClass := AClass;
end;

constructor TThreadSafeObjectList<T>.create(AOwnedObject: boolean = true);
begin
  inherited create;
  FLock := TObject.create;
  FList := TObjectList<T>.create(AOwnedObject);
end;

procedure TThreadSafeObjectList<T>.Delete(AIndex: integer);
var
  obj: TObject;
begin
  with LockList do
    try
      obj := Items[0];
      Delete(AIndex);
    finally
      UnlockList;
    end;
end;

destructor TThreadSafeObjectList<T>.destroy;
begin
  while Count > 0 do
    Delete(0);
  FreeAndNil(FList);
  FreeAndNil(FLock);
  inherited;
end;

function TThreadSafeObjectList<T>.Extract: T;
begin
  result := nil;
  if Count > 0 then
    result := Items[Count - 1];
end;

procedure TThreadSafeObjectList<T>.ForEach(AFunc: TFunc<T, boolean>);
var
  i: integer;
begin
  if Assigned(AFunc) then
    with LockList do
      try
        for i := 0 to Count - 1 do
          if AFunc(Items[i]) then
            break;
      finally
        UnlockList;
      end;
end;

function TThreadSafeObjectList<T>.Getitems(AIndex: integer): T;
begin
  with LockList do
    try
      result := Items[AIndex];
    finally
      UnlockList;
    end;
end;

function TThreadSafeObjectList<T>.IndexOf(AValue: T): integer;
begin
  with LockList do
    try
      result := IndexOf(AValue);
    finally
      UnlockList;
    end;
end;

function TThreadSafeObjectList<T>.LockList: TList<T>;
begin
  TMonitor.Enter(FLock);
  result := FList;
end;

function TThreadSafeObjectList<T>.Peek: T;
begin
  result := nil;
  if Count > 0 then
    result := Items[Count - 1];
end;

procedure TThreadSafeObjectList<T>.Pop;
var
  o: TObject;
begin
  if Count > 0 then
  begin
    with LockList do
      try
        o := Items[Count - 1];
        Delete(Count - 1);
        // if (not FList.OwnsObjects) and Assigned(o) then
        // o.DisposeOf;
      finally
        UnlockList;
      end;
  end;
end;

procedure TThreadSafeObjectList<T>.Push(AValue: T);
begin
  Add(AValue);
end;

procedure TThreadSafeObjectList<T>.Remove(AValue: T);
var
  i: integer;
begin
  if not Assigned(FList) then
    Exit;
  i := IndexOf(AValue);
  if i >= 0 then
    Delete(i);
end;

procedure TThreadSafeObjectList<T>.Setitems(AIndex: integer; const AValue: T);
begin
  with LockList do
    try
      Items[AIndex] := AValue;
    finally
      UnlockList;
    end;
end;

function TThreadSafeObjectList<T>.ToJson: string;
var
  j: TJsonArray;
begin
  j := self.ToJsonArray;
  try
    result := j.ToJson;
  finally
    j.Free;
  end;
end;

function TThreadSafeObjectList<T>.ToJsonArray: TJsonArray;
var
  i: integer;
  ob: T;
begin
  result := TJsonArray.create;
{$IFNDEF BPL}
  with LockList do
    try
      for i := 0 to Count - 1 do
      begin
        ob := Items[i];
        result.Add( Rest.Json.TJson.ObjectToJsonObject(ob));
      end;
    finally
      UnlockList;
    end;
{$ENDIF}
end;

function TThreadSafeObjectList<T>.TryLockList: TList<T>;
begin
  result := LockList;
end;

procedure TThreadSafeObjectList<T>.UnlockList;
begin
  TMonitor.Exit(FLock);
end;

{ TInterfaceThreadSafeList<T> }

function TThreadSafeInterfaceList<T>.Add(AValue: T): integer;
begin
  result := -1;
  with LockList do
    try
      Add(AValue);
      result := Count - 1;
    finally
      UnlockList;
    end;
end;

procedure TThreadSafeInterfaceList<T>.Clear;
var
  ob: IInterface;
  i: integer;
begin
  with LockList do
    try
      try
        for i := Count - 1 downto 0 do
        begin
          ob := Items[i];
          Delete(i);
          if FOwned then
            ob := nil;
        end;
      finally
        Clear; // garantir que todos os itens foram excluidos... redundante
      end;
    finally
      UnlockList;
    end;
end;

function TThreadSafeInterfaceList<T>.Count: integer;
begin
  with LockList do
    try
      result := Count;
    finally
      UnlockList;
    end;

end;

constructor TThreadSafeInterfaceList<T>.create(AOwned: boolean = true);
begin
  inherited create;
  FOwned := AOwned;
  FList := TThreadList<T>.create;
end;

procedure TThreadSafeInterfaceList<T>.Delete(AIndex: integer);
var
  ob: T;
begin
  with LockList do
    try
      if FOwned then
        Items[AIndex] := nil;
      // ob := FList.Items[AIndex];
      Delete(AIndex);
      // if FOwned then
      // ob := nil;
    finally
      UnlockList;
    end;
end;

destructor TThreadSafeInterfaceList<T>.destroy;
var
  i: integer;
begin
  if FOwned then
    for i := Count - 1 downto 0 do
      Items[i] := nil;
  FList.Free;
  inherited;
end;

function TThreadSafeInterfaceList<T>.Getitems(AIndex: integer): T;
begin
  with LockList do
    try
      result := T(Items[AIndex]);
    finally
      UnlockList;
    end;
end;

procedure TThreadSafeInterfaceList<T>.Lock;
begin
  LockList;
end;

function TThreadSafeInterfaceList<T>.LockList: TList<T>;
begin
  result := FList.LockList;;
end;

procedure TThreadSafeInterfaceList<T>.Release;
var
  II: T;
  i: integer;
begin
  with LockList do
    try
      for i := 0 to Count - 1 do
      begin
        Items[i] := nil;
        Delete(i);
      end;
    finally
      UnlockList;
    end;

end;

procedure TThreadSafeInterfaceList<T>.Remove(AValue: T);
var
  i: integer;
begin
  i := IndexOf(AValue);
  if i >= 0 then
    Delete(i);
end;

procedure TThreadSafeInterfaceList<T>.Setitems(AIndex: integer;
  const AValue: T);
begin
  with LockList do
    try
      Items[AIndex] := T(AValue);
    finally
      UnlockList;
    end;
end;

procedure TThreadSafeInterfaceList<T>.UnLock;
begin
  UnlockList;
end;

procedure TThreadSafeInterfaceList<T>.UnlockList;
begin
  FList.UnlockList;
end;

function TThreadSafeInterfaceList<T>.IndexOf(AValue: T): integer;
var
  i: integer;
  ob1, ob2: TObject;
begin
  result := -1;
  ob2 := AValue as TObject;
  with LockList do
    try
      for i := 0 to Count - 1 do
      begin
        ob1 := Items[i] as TObject;
        if ob1.Equals(ob2) then
        begin
          result := i;
          Exit;
        end;
      end;
    finally
      UnlockList;
    end;
end;

procedure TThreadSafeInterfaceList<T>.Insert(AIndex: integer; AValue: T);
begin
  with LockList do
    try
      Insert(AIndex, AValue);
    finally
      UnlockList;
    end;
end;

{ TThreadedList<T> }

function TThreadedList<T>.Add(const AItem: T): integer;
begin
  with LockList do
    try
      result := Count;
      Add(TObject(AItem));
    finally
      UnlockList;
    end;
end;

function TThreadedList<T>.Count: integer;
begin
  with LockList do
    try
      result := Count;
    finally
      UnlockList;
    end;
end;

procedure TThreadedList<T>.Delete(AIdx: integer);
var
  FList: TList;
begin
  FList := LockList;
  try
    FList.Delete(AIdx);
  finally
    UnlockList;
  end;
end;

function TThreadedList<T>.Getitems(idx: integer): T;
var
  FList: TList;
begin
  result := nil;
  FList := LockList;
  try
    if idx < FList.Count then
      result := FList.Items[idx];
  finally
    UnlockList;
  end;
end;

function TThreadedList<T>.Pop: T;
var
  i: integer;
begin
  result := nil;
  i := Count - 1;
  if i >= 0 then
  begin
    result := Items[i];
    Delete(i);
  end;
end;

procedure TThreadedList<T>.Setitems(idx: integer; const Value: T);
begin
  with LockList do
    try
      Items[idx] := TObject(Value);
    finally
      UnlockList;
    end;
end;

{ TStringListHelper }

procedure TStringListHelper.Erase(ATexto: string);
var
  i: integer;
begin
  i := IndexOf(ATexto);
  if i >= 0 then
    Delete(i);
end;

{ TThreadSafeDictionary<TKey, TValue> }

constructor TThreadSafeDictionary<TKey, TValue>.create
  (AOwnedList: TDictionaryOwnerShips);
begin
  inherited create;
  FOwnedList := AOwnedList;
  Invoke;
end;

procedure TThreadSafeDictionary<TKey, TValue>.Add(const Key: TKey;
  const Value: TValue);
begin
  with LockList do
    try
      FDictionary.Add(Key, Value);
    finally
      UnlockList;
    end;
end;

procedure TThreadSafeDictionary<TKey, TValue>.AddOrSetValue(const Key: TKey;
  const Value: TValue);
begin
  with LockList do
    try
      FDictionary.AddOrSetValue(Key, Value);
    finally
      UnlockList;
    end;
end;

procedure TThreadSafeDictionary<TKey, TValue>.Clear;
begin
  with LockList do
    try
      FDictionary.Clear;
    finally
      UnlockList;
    end;
end;

function TThreadSafeDictionary<TKey, TValue>.ContainsKey
  (const Key: TKey): boolean;
begin
  with LockList do
    try
      result := FDictionary.ContainsKey(Key);
    finally
      UnlockList;
    end;

end;

function TThreadSafeDictionary<TKey, TValue>.ContainsValue
  (const Value: TValue): boolean;
begin
  with LockList do
    try
      result := FDictionary.ContainsValue(Value);
    finally
      UnlockList;
    end;

end;

constructor TThreadSafeDictionary<TKey, TValue>.create;
begin
  // raise exception.create('Use  .create([]); instead create');
  self.create([]);
end;

{ constructor TThreadSafeDictionary<TKey, TValue>.create;
  begin
  inherited;
  FOwnedList := [doOwnsKeys, doOwnsValues];
  Invoke;
  end;
}

function TThreadSafeDictionary<TKey, TValue>.ToArray
  : TArray<TPair<TKey, TValue>>;
begin
  with LockList do
    try
      result := FDictionary.ToArray;
    finally
      UnlockList;
    end;

end;

procedure TThreadSafeDictionary<TKey, TValue>.TrimExcess;
begin
  with LockList do
    try
      FDictionary.TrimExcess;
    finally
      UnlockList;
    end;
end;

function TThreadSafeDictionary<TKey, TValue>.TryGetValue(const Key: TKey;
  out Value: TValue): boolean;
begin
  with LockList do
    try
      result := FDictionary.TryGetValue(Key, Value);
    finally
      UnlockList;
    end;
end;

destructor TThreadSafeDictionary<TKey, TValue>.destroy;
begin
  if FInited then
  begin
    FDictionary.Free;
    FLock.Free;
  end;
  inherited;
end;

function TThreadSafeDictionary<TKey, TValue>.ExtractPair(const Key: TKey)
  : TPair<TKey, TValue>;
begin
  with LockList do
    try
      result := FDictionary.ExtractPair(Key);
    finally
      UnlockList;
    end;

end;

function TThreadSafeDictionary<TKey, TValue>.GetCount: integer;
begin
  with LockList do
    try
      result := FDictionary.Count;
    finally
      UnlockList;
    end;
end;

function TThreadSafeDictionary<TKey, TValue>.GetItem(const Key: TKey): TValue;
begin
  with LockList do
    try
      FDictionary.TryGetValue(Key, result);
    finally
      UnlockList;
    end;
end;

function TThreadSafeDictionary<TKey, TValue>.Invoke
  : TObjectDictionary<TKey, TValue>;
begin
  if not FInited then
  begin
    FInited := true;
    FLock := TObject.create;
    FDictionary := TObjectDictionary<TKey, TValue>.create;
  end;
  result := FDictionary;
end;

function TThreadSafeDictionary<TKey, TValue>.LockList
  : TDictionary<TKey, TValue>;
begin
  System.TMonitor.Enter(FLock);
  result := FDictionary;
end;

procedure TThreadSafeDictionary<TKey, TValue>.Remove(const Key: TKey);
begin
  with LockList do
    try
      FDictionary.Remove(Key);
    finally
      UnlockList;
    end;

end;

procedure TThreadSafeDictionaryObject<TValue>.FromJson(AJson: String);
var
  arr: TJsonArray;
  it: TJsonValue;
  Key: string;
  Value: TValue;
  j: TJsonObject;
  AClass: TClass;
begin

  LockList;
  try
    arr := TJsonObject.ParseJSONValue(AJson) as TJsonArray;
    try
      for it in arr do
        if it.TryGetValue<string>('key', Key) then
        begin
          j := it.GetValue<TJsonValue>('value') as TJsonObject;
          if Assigned(j) then
          begin
            AClass := TValue;

            Value := TValue(AClass.create);
            value.FromJson(j.toJson);
            FDictionary.AddOrSetValue(Key, Value);
          end;
        end;
    finally
      arr.Free;
    end;
  finally
    UnlockList;
  end;
end;

function TThreadSafeDictionaryObject<TValue>.ToJson: String;
var
  Key: string;
  Value: TValue;
  arr: TJsonArray;
  jKey: TJsonObject;
  jValue: TJsonObject;
  obj: TObject;
begin
  result := '{}';
  with LockList do
    try
      arr := TJsonArray.create;
      try
        for Key in FDictionary.Keys do
          if FDictionary.TryGetValue(Key, Value) then
          begin
            jValue := Rest.Json.TJson.ObjectToJsonObject(Value);
            jKey := TJsonObject.create();
            jKey.AddPair('key', Key);
            jKey.AddPair('value', jValue);
            arr.AddElement(jKey);
          end;
        result := arr.ToJson;
      finally
        arr.Free;
      end;
    finally
      UnlockList;
    end;
end;

procedure TThreadSafeDictionary<TKey, TValue>.SetItem(const Key: TKey;
  const Value: TValue);
begin
  with LockList do
    try
      SetItem(Key, Value);
    finally
      UnlockList;
    end;

end;

procedure TThreadSafeDictionary<TKey, TValue>.UnlockList;
begin
  System.TMonitor.Exit(FLock);
end;

{ TObjectAdapter<T> }

function TObjectAdapter<T>.Invoke: T;
begin
  if not Assigned(FInstance) then
    FInstance := T(TClass(T).create);
  result := FInstance;
end;

end.
