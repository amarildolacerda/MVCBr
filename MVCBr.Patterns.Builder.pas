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
unit MVCBr.Patterns.Builder;

interface

uses
  System.Classes, System.SysUtils,
  System.RTTI.Helper,
  System.RTTI, System.Generics.Collections;

type

  IMVCBrBuilderItem<T: Class> = interface(TFunc<T>)
    property Instance: T read Invoke;
    function IsCreated: Boolean;
    function Response: TValue;
    procedure FreeInstance;
  end;

  TMVCBrBuilderItem<T, TResult> = class;

  IMVCBrBuilderItem<T, TResult> = interface
    ['{0EA84140-4B56-494B-8C09-B39A3E7F400F}']
    procedure Release;
    function This: TObject;
    function Execute(AParam: T): TResult;
    function Response: TResult;
    function Delegate: TFunc<T, TResult>;
    function Command: TValue;
    procedure SetDelegate(AValue: TFunc<T, TResult>);
  end;

  TMVCBrBuilder<T, TResult> = class
  private
    [weak]
    FList: TThreadList<IMVCBrBuilderItem<T, TResult>>;
    function GetItems(index: integer): TMVCBrBuilderItem<T, TResult>;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    class function New: TMVCBrBuilder<T, TResult>; overload;
    class function New(ACommand: TValue; ABuilderFunc: TFunc<T, TResult>)
      : TMVCBrBuilder<T, TResult>; overload;
    function LockList: TList<IMVCBrBuilderItem<T, TResult>>; virtual;
    procedure UnlockList; virtual;
    function Add(ACommand: TValue; ABuilderFunc: TFunc<T, TResult>)
      : TMVCBrBuilderItem<T, TResult>; overload; virtual;
    function Add(ACommand: TValue; AItem: TMVCBrBuilderItem<T, TResult>)
      : TMVCBrBuilderItem<T, TResult>; overload; virtual;
    [weak]
    function Execute(ACommand: TValue; AParam: T): TResult; virtual;
    [weak]
    function Query(ACommand: TValue): TMVCBrBuilderItem<T, TResult>; virtual;
    procedure Release; virtual;
    procedure Clear; virtual;
    function Count: integer; virtual;
    property Items[index: integer]: TMVCBrBuilderItem<T, TResult> read GetItems;
    function IndexOf(ACommand: TValue): integer;
    procedure Remove(AItem: TMVCBrBuilderItem<T, TResult>); overload; virtual;
    procedure Remove(ACommand: TValue); overload; virtual;
    function Contains(ACommand: TValue): Boolean; virtual;
    function This: TObject; virtual;
    function isValid(idx: integer): Boolean;
  end;

  IMVCBrBuilder<T, TResult> = interface
    ['{1C86D407-8F67-411F-AEA8-D90BBC6AA91A}']
    procedure Release;
    function This: TObject;
    function Add(ACommand: TValue; ABuilderFunc: TFunc<T, TResult>)
      : IMVCBrBuilderItem<T, TResult>;
    function Query(ACommand: TValue): IMVCBrBuilderItem<T, TResult>;
    function Execute(ACommand: TValue; AParam: T)
      : TResult;
    function Contains(ACommand: TValue): Boolean;
    procedure Remove(ACommand: TValue);
  end;

  TMVCBrBuilderItem<T, TResult> = Class(TInterfacedObject,
    IMVCBrBuilderItem<T, TResult>)
  public
  private
    FCommand: TValue;
    FDelegate: TFunc<T, TResult>;
    FResult: TResult;
    [weak]
    FBuilder: TMVCBrBuilder<T, TResult>;
  public
    constructor Create(ABuilder: TMVCBrBuilder<T, TResult>; ACommand: TValue;
      ADelegate: TFunc<T, TResult>); overload; virtual;
    destructor Destroy; override;
    class function New(ABuilder: TMVCBrBuilder<T, TResult>; ACommand: TValue;
      ADelegate: TFunc<T, TResult>): TMVCBrBuilderItem<T, TResult>; overload;
    class function New(ABuilder: TMVCBrBuilder<T, TResult>; ACommand: TValue)
      : TMVCBrBuilderItem<T, TResult>; overload;
    [weak]
    function Execute(AParam: T): TResult; virtual;
    function Response: TResult; virtual;
    function Delegate: TFunc<T, TResult>; virtual;
    function Command: TValue; virtual;
    procedure SetDelegate(AValue: TFunc<T, TResult>); virtual;
    procedure Release; virtual;
    function This: TObject; virtual;
    function ThisAs: TMVCBrBuilderItem<T, TResult>; virtual;
    property DefaultBuilder: TMVCBrBuilder<T, TResult> read FBuilder;
    function LockList: TList<IMVCBrBuilderItem<T, TResult>>; virtual;
    procedure UnlockList;
  end;

  TMVCBrBuilderFactory<T, TResult> = class(TInterfacedObject,
    IMVCBrBuilder<T, TResult>)
  private
    [weak]
    FWrapper: TMVCBrBuilder<T, TResult>;
  protected
  public
    constructor Create(AClass: TMVCBrBuilder<T, TResult>); virtual;
    destructor Destroy; override;
    class function New: IMVCBrBuilder<T, TResult>; virtual;
    property Builder: TMVCBrBuilder<T, TResult> read FWrapper;
    function This: TObject; virtual;
    procedure Release; virtual;
    function Count: integer; virtual;
    [weak]
    function Add(ACommand: TValue; ABuilderFunc: TFunc<T, TResult>)
      : IMVCBrBuilderItem<T, TResult>; overload; virtual;
    [weak]
    function Execute(ACommand: TValue; AParam: T)
      : TResult; virtual;
    [weak]
    function Query(ACommand: TValue): IMVCBrBuilderItem<T, TResult>; virtual;
    procedure Remove(ACommand: TValue); overload; virtual;
    function Contains(ACommand: TValue): Boolean; virtual;
    function LockList: TList<IMVCBrBuilderItem<T, TResult>>; virtual;
    procedure UnlockList; virtual;

  end;

  /// Lazy Builder Object
  ///
  IMVCBrBuilderObject = interface
    ['{EA4D8260-900F-4627-A7C8-B58CBAB26463}']
    function Execute(AParam: TValue): TValue;
    procedure SetResponse(const Value: TValue);
    function GetResponse: TValue;
    property Response: TValue read GetResponse write SetResponse;
  end;

  TMVCBrBuilderObject = class(TInterfacedObject, IMVCBrBuilderObject)
  private
    FResponse: TValue;
  protected
    procedure SetResponse(const Value: TValue); virtual;
    function GetResponse: TValue; virtual;
  public
    function Execute(AParam: TValue): TValue; virtual;
    property Response: TValue read GetResponse write SetResponse;
  end;

  TMVCBrBuilderObjectClass = class of TMVCBrBuilderObject;

  IMVCBrBuilderItemResult = IMVCBrBuilderItem<TValue, TValue>;

  /// Lazy Builder Item
  TMVCBrBuilderLazyItem = class(TMVCBrBuilderItem<TValue, TValue>,
    IMVCBrBuilderItem<TObject>)
  private
    FDelegateTo: TFunc<TObject>;
    FClass: TClass;
    [weak]
    FInstance: TObject;
    FCreated: Boolean;
  protected
    function Invoke: TObject;
  public
    constructor Create; Overload;
    destructor Destroy; override;
    class Function New(ABuilder: TMVCBrBuilder<TValue, TValue>;
      ACommand: TValue): TMVCBrBuilderLazyItem;
    property Instance: TObject read Invoke;
    procedure FreeInstance;
    [weak]
    function Execute(AParam: TValue): TValue; override;
    function Response: TValue; Override;
    function IsCreated: Boolean; virtual;
    function DelegateTo(AFunc: TFunc<TObject>): TMVCBrBuilderLazyItem;
  end;

  /// Lazy Builder Factory
  ///
  TMVCBrBuilderLazyFactory = class(TMVCBrBuilder<TValue, TValue>)
  private
  public
    class function New: TMVCBrBuilderLazyFactory; virtual;
    function Add(ACommand: TValue; AClass: TClass)
      : TMVCBrBuilderLazyItem; virtual;
    [weak]
    function Query<T: Class>(ACommand: TValue): T; overload;
    procedure FreeInstance(ACommand: TValue); virtual;
    procedure FreeAllInstances; virtual;
  end;

implementation

{ TMVCBrBuilderFactory<T> }
uses MVCBr.Interf, System.Classes.Helper;

function TMVCBrBuilder<T, TResult>.Add(ACommand: TValue;
  ABuilderFunc: TFunc<T, TResult>): TMVCBrBuilderItem<T, TResult>;
begin
  result := TMVCBrBuilderItem<T, TResult>.New(self, ACommand, ABuilderFunc);
  FList.Add(result);
end;

function TMVCBrBuilder<T, TResult>.Add(ACommand: TValue;
  AItem: TMVCBrBuilderItem<T, TResult>): TMVCBrBuilderItem<T, TResult>;
begin
  result := AItem;
  FList.Add(result);
end;

procedure TMVCBrBuilder<T, TResult>.Clear;
begin
  Release;
  FList.Clear;
end;

constructor TMVCBrBuilder<T, TResult>.Create();
begin
  FList := TThreadList < IMVCBrBuilderItem < T, TResult >>.Create;
end;

destructor TMVCBrBuilder<T, TResult>.Destroy;
var
  i: integer;
begin
  FList.free;
  FList := nil;
  inherited;
end;

function TMVCBrBuilder<T, TResult>.Contains(ACommand: TValue): Boolean;
var
  i: integer;
begin

  try
    i := IndexOf(ACommand);
    result := isValid(i);
  except
    /// workaround early freed interface
    result := false;
  end;
end;

function TMVCBrBuilder<T, TResult>.Count: integer;
begin
  with FList.LockList do
    try
      result := Count;
    finally
      FList.UnlockList;
    end;
end;

class function TMVCBrBuilder<T, TResult>.New(ACommand: TValue;
  ABuilderFunc: TFunc<T, TResult>): TMVCBrBuilder<T, TResult>;
begin
  result := TMVCBrBuilder<T, TResult>.New;
  result.Add(ACommand, ABuilderFunc);
end;

function TMVCBrBuilder<T, TResult>.Query(ACommand: TValue)
  : TMVCBrBuilderItem<T, TResult>;
var
  i: integer;
begin
  result := nil;
  i := IndexOf(ACommand);
  if isValid(i) then
    with FList.LockList do
      try
        result := TMVCBrBuilderItem<T, TResult>(Items[i].This);
      finally
        FList.UnlockList;
      end;
end;

function TMVCBrBuilder<T, TResult>.Execute(ACommand: TValue; AParam: T): TResult;
var
  AQuery: TMVCBrBuilderItem<T, TResult>;
begin
  AQuery := Query(ACommand);
  Assert(assigned(AQuery), 'Builder Command not found');
  if assigned(AQuery) then
  begin
    result := AQuery.Execute(AParam);
  end;
end;

function TMVCBrBuilder<T, TResult>.GetItems(index: integer)
  : TMVCBrBuilderItem<T, TResult>;
begin
  with LockList do
    try
      result := TMVCBrBuilderItem<T, TResult>(Items[index].This);
    finally
      UnlockList;
    end;
end;

function TMVCBrBuilder<T, TResult>.IndexOf(ACommand: TValue): integer;
var
  i: integer;
begin
  i := -1;
  with FList.LockList do
    try
      for i := Count - 1 downto 0 do
      begin
        if TMVCBrBuilderItem<T, TResult>(Items[i].This).FCommand.Equals(ACommand)
        then
        begin
          result := i;
          exit;
        end;
      end;
    finally
      FList.UnlockList;
    end;
end;

function TMVCBrBuilder<T, TResult>.isValid(idx: integer): Boolean;
begin
  result := (idx >= 0) and (idx < Count);
end;

function TMVCBrBuilder<T, TResult>.LockList
  : TList<IMVCBrBuilderItem<T, TResult>>;
begin
  result := FList.LockList;
end;

class function TMVCBrBuilder<T, TResult>.New: TMVCBrBuilder<T, TResult>;
begin
  result := TMVCBrBuilder<T, TResult>.Create;
end;

procedure TMVCBrBuilder<T, TResult>.Release;
var
  i: integer;
begin
  {
    with FList.LockList do
    try
    for i := count - 1 downto 0 do
    try
    items[i].Release;
    except
    /// workaround;
    end;
    finally
    FList.UnlockList;
    end;
  }
end;

procedure TMVCBrBuilder<T, TResult>.Remove(ACommand: TValue);
var
  i: integer;
begin
  i := IndexOf(ACommand);
  if isValid(i) then
    with FList.LockList do
      try
        Delete(i);
      finally
        FList.UnlockList;
      end;
end;

procedure TMVCBrBuilder<T, TResult>.Remove
  (AItem: TMVCBrBuilderItem<T, TResult>);
begin
  try
    if Contains(AItem.FCommand) then
    begin
      AItem.Release;
      Remove(AItem.FCommand);
    end;
  except
    /// workaroud for early freed
  end;
end;

function TMVCBrBuilder<T, TResult>.This: TObject;
begin
  result := self;
end;

procedure TMVCBrBuilder<T, TResult>.UnlockList;
begin
  FList.UnlockList;
end;

{ TMVCBrBuilderItem<T> }

function TMVCBrBuilderItem<T, TResult>.Delegate: TFunc<T, TResult>;
begin
  result := FDelegate;
end;

destructor TMVCBrBuilderItem<T, TResult>.Destroy;
begin
  inherited;
end;

function TMVCBrBuilderItem<T, TResult>.Execute(AParam: T): TResult;
begin
  if assigned(FDelegate) then
  begin
    FResult := FDelegate(AParam);
    result := FResult;
  end;
end;

function TMVCBrBuilderItem<T, TResult>.LockList
  : TList<IMVCBrBuilderItem<T, TResult>>;
begin
  result := FBuilder.LockList;
end;

class function TMVCBrBuilderItem<T, TResult>.New
  (ABuilder: TMVCBrBuilder<T, TResult>; ACommand: TValue)
  : TMVCBrBuilderItem<T, TResult>;
begin
  result := New(ABuilder, ACommand, nil);
end;

class function TMVCBrBuilderItem<T, TResult>.New
  (ABuilder: TMVCBrBuilder<T, TResult>; ACommand: TValue;
  ADelegate: TFunc<T, TResult>): TMVCBrBuilderItem<T, TResult>;
begin
  result := TMVCBrBuilderItem<T, TResult>.Create(ABuilder, ACommand, ADelegate);
end;

function TMVCBrBuilderItem<T, TResult>.Command: TValue;
begin
  result := FCommand;
end;

constructor TMVCBrBuilderItem<T, TResult>.Create
  (ABuilder: TMVCBrBuilder<T, TResult>; ACommand: TValue;
  ADelegate: TFunc<T, TResult>);
begin
  inherited Create;
  FCommand := ACommand;
  FDelegate := ADelegate;
  FBuilder := ABuilder;
end;

procedure TMVCBrBuilderItem<T, TResult>.Release;
begin
  if assigned(FBuilder) then
    FBuilder.Remove(self);
  FBuilder := nil;

end;

function TMVCBrBuilderItem<T, TResult>.Response: TResult;
begin
  result := FResult;
end;

procedure TMVCBrBuilderItem<T, TResult>.SetDelegate(AValue: TFunc<T, TResult>);
begin
  FDelegate := AValue;
end;

function TMVCBrBuilderItem<T, TResult>.This: TObject;
begin
  result := self;
end;

function TMVCBrBuilderItem<T, TResult>.ThisAs: TMVCBrBuilderItem<T, TResult>;
begin
  result := self;
end;

procedure TMVCBrBuilderItem<T, TResult>.UnlockList;
begin
  FBuilder.UnlockList;
end;

{ TMVCBrBuilderFactory<T, TResult> }

function TMVCBrBuilderFactory<T, TResult>.Add(ACommand: TValue;
  ABuilderFunc: TFunc<T, TResult>): IMVCBrBuilderItem<T, TResult>;
begin
  result := FWrapper.Add(ACommand, ABuilderFunc);
end;

function TMVCBrBuilderFactory<T, TResult>.Contains(ACommand: TValue): Boolean;
begin
  result := FWrapper.Contains(ACommand);
end;

function TMVCBrBuilderFactory<T, TResult>.Count: integer;
begin
  result := FWrapper.Count;
end;

constructor TMVCBrBuilderFactory<T, TResult>.Create
  (AClass: TMVCBrBuilder<T, TResult>);
begin
  inherited Create;
  FWrapper := AClass;
end;

destructor TMVCBrBuilderFactory<T, TResult>.Destroy;
begin
  if assigned(FWrapper) then
    FWrapper.free;
  inherited;
end;

function TMVCBrBuilderFactory<T, TResult>.Execute(ACommand: TValue; AParam: T)
  : TResult;
begin
  result := FWrapper.Execute(ACommand, AParam);
end;

function TMVCBrBuilderFactory<T, TResult>.LockList
  : TList<IMVCBrBuilderItem<T, TResult>>;
begin
  result := FWrapper.LockList;
end;

class function TMVCBrBuilderFactory<T, TResult>.New: IMVCBrBuilder<T, TResult>;
begin
  result := TMVCBrBuilderFactory<T, TResult>.Create
    (TMVCBrBuilder<T, TResult>.Create);
end;

function TMVCBrBuilderFactory<T, TResult>.Query(ACommand: TValue)
  : IMVCBrBuilderItem<T, TResult>;
begin
  result := FWrapper.Query(ACommand);
end;

procedure TMVCBrBuilderFactory<T, TResult>.Release;
begin
  if assigned(FWrapper) then
    FWrapper.Release;
end;

procedure TMVCBrBuilderFactory<T, TResult>.Remove(ACommand: TValue);
begin
  FWrapper.Remove(ACommand);
end;

function TMVCBrBuilderFactory<T, TResult>.This: TObject;
begin
  result := self;
end;

procedure TMVCBrBuilderFactory<T, TResult>.UnlockList;
begin
  FWrapper.UnlockList;
end;

{ TMVCBBuilderLazyItem<T, TResult> }

constructor TMVCBrBuilderLazyItem.Create;
begin
  raise Exception.Create
    ('Abstract... Use NEW class function instead of create');
end;

function TMVCBrBuilderLazyItem.DelegateTo(AFunc: TFunc<TObject>)
  : TMVCBrBuilderLazyItem;
begin
  result := self;
  FDelegateTo := AFunc;
end;

destructor TMVCBrBuilderLazyItem.Destroy;
var
  Interf: IInterface;
begin
  try
    if supports(FInstance, IInterface, Interf) then
      Interf := nil
    else
      FreeAndNil(FInstance);
    /// workaround - with Free blow Exception Error
  except
  end;
  inherited;
end;

function TMVCBrBuilderLazyItem.Execute(AParam: TValue): TValue;
begin
  with TMVCBrBuilderObject(Instance) do
  begin
    Response := Execute(AParam);
    result := response;
  end;
end;

procedure TMVCBrBuilderLazyItem.FreeInstance;
begin
  FreeAndNil(FInstance);
  FCreated := false;
end;

function TMVCBrBuilderLazyItem.Invoke: TObject;
begin
  if not FCreated then
  begin
    if assigned(FDelegateTo) then
      FInstance := FDelegateTo;
    if not assigned(FInstance) then
      FInstance := FClass.Create;
    FCreated := true;
  end;
  result := FInstance;

end;

function TMVCBrBuilderLazyItem.IsCreated: Boolean;
begin
  result := FCreated;
end;

class function TMVCBrBuilderLazyItem.New
  (ABuilder: TMVCBrBuilder<TValue, TValue>; ACommand: TValue)
  : TMVCBrBuilderLazyItem;
begin
  result := inherited Create();
  result.FBuilder := ABuilder;
  result.FCommand := ACommand;
end;

function TMVCBrBuilderLazyItem.Response: TValue;
begin
  result := TMVCBrBuilderObject(Instance).Response;
end;

{ TMVCBBuilderObject }

function TMVCBrBuilderObject.Execute(AParam: TValue): TValue;
begin
end;

function TMVCBrBuilderObject.GetResponse: TValue;
begin
  result := FResponse
end;

procedure TMVCBrBuilderObject.SetResponse(const Value: TValue);
begin
  FResponse := Value;
end;

{ TMVCBBuilderLazyFactory }

function TMVCBrBuilderLazyFactory.Add(ACommand: TValue; AClass: TClass)
  : TMVCBrBuilderLazyItem;
begin
  result := TMVCBrBuilderLazyItem.New(self, ACommand);
  result.FClass := AClass;
  result.FInstance := nil;
  inherited Add(ACommand, result);
end;

procedure TMVCBrBuilderLazyFactory.FreeAllInstances;
var
  i: integer;
begin
  With FList.LockList do
    try
      for i := 0 to Count - 1 do
        TMVCBrBuilderLazyItem(Items[i]).FreeInstance;
    finally
      FList.UnlockList;
    end;
end;

procedure TMVCBrBuilderLazyFactory.FreeInstance(ACommand: TValue);
var
  i: integer;
begin
  i := IndexOf(ACommand);
  if isValid(i) then
    With FList.LockList do
      try
        TMVCBrBuilderLazyItem(Items[i]).FreeInstance;
      finally
        FList.UnlockList;
      end;
end;

class function TMVCBrBuilderLazyFactory.New: TMVCBrBuilderLazyFactory;
begin
  result := TMVCBrBuilderLazyFactory.Create;
end;

function TMVCBrBuilderLazyFactory.Query<T>(ACommand: TValue): T;
var
  ret: IMVCBrBuilderItem<TValue, TValue>;
  AGuid: TGuid;
  AItem: TMVCBrBuilderLazyItem;
begin
  ret := inherited Query(ACommand);
  AItem := TMVCBrBuilderLazyItem(ret.This);
  result := T(AItem.Instance);
  ret := nil;
end;

end.
