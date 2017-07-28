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

unit MVCBr.Observable;

interface

uses System.Classes, System.SysUtils, System.Generics.Collections,
  System.JSON, MVCBr.Interf;

type

  /// <summary>
  /// Data item about subscriber
  /// </summary>
  TMVCBrObserverItem = class(TMVCBrObserverItemAbstract)
  private
    FObserver: IMVCBrObserver;
    FSubscribeProc: TMVCBrObserverProc;
    FTopic: string;
    procedure SetTopic(const Value: string); override;
    function GetTopic: string; override;
    function GetSubscribeProc: TMVCBrObserverProc; override;
    procedure SetSubscribeProc(const Value: TMVCBrObserverProc); override;
    procedure SetObserver(const Value: IMVCBrObserver); override;
    function GetObserver: IMVCBrObserver; override;
  public
    property Observer: IMVCBrObserver read GetObserver write SetObserver;
    property Topic: string read GetTopic write SetTopic;
    property SubscribeProc: TMVCBrObserverProc read GetSubscribeProc
      write SetSubscribeProc;
    procedure Send(AJsonValue: TJsonValue; var AHandled: boolean); override;
  end;

  /// <summary>
  /// List of Observer itens
  /// </summary>
  TMVCBrObservable = class(TInterfacedObject, IMVCBrObservable)
  private
    FSubscribers: TObjectList<TMVCBrObserverItemAbstract>;
    function GetItems(idx: integer): TMVCBrObserverItemAbstract;
    procedure SetItems(idx: integer; const Value: TMVCBrObserverItemAbstract);
    class procedure Release;
  public
    Constructor create;
    Destructor Destroy; override;
    function LockList: TObjectList<TMVCBrObserverItemAbstract>; overload;
    procedure Lock; overload;
    procedure Unlock;
    class function DefaultContainer: TMVCBrObservable;
    function Count: integer;
    property Items[idx: integer]: TMVCBrObserverItemAbstract read GetItems
      write SetItems;
    function This: TObject;
    function ThisAs: TMVCBrObservable;
    function Subscribe(AProc: TMVCBrObserverProc): IMVCBrObserverItem; overload;
    procedure UnSubscribe(AProc: TMVCBrObserverProc); overload;
    procedure Send(AJson: TJsonValue); overload;
    procedure Send(const AName: string; AJson: TJsonValue); overload;
    procedure Register(const AName: string; AObserver: IMVCBrObserver);
      overload;
    procedure Register(AObserver: IMVCBrObserver); overload;
    procedure UnRegister(const AName: string;
      AObserver: IMVCBrObserver); overload;
    procedure UnRegister(AObserver: IMVCBrObserver); overload;
    procedure UnRegister(const AName: string); overload;
  end;

implementation

{ TMVCBrObserver }
var
  FSubscribeServer: IMVCBrObservable;

var
  LLock: TObject;

function TMVCBrObservable.Count: integer;
begin
  try
    result := LockList.Count;
  finally
    Unlock;
  end;
end;

constructor TMVCBrObservable.create;
begin
  if not assigned(FSubscribers) then
    FSubscribers := TObjectList<TMVCBrObserverItemAbstract>.create;
end;

class function TMVCBrObservable.DefaultContainer: TMVCBrObservable;
begin
  TMonitor.enter(LLock);
  try
    if not assigned(FSubscribeServer) then
      FSubscribeServer := TMVCBrObservable.create;
    result := TMVCBrObservable(FSubscribeServer.This);
  finally
    TMonitor.exit(LLock);
  end;
end;

destructor TMVCBrObservable.Destroy;
begin
  inherited;
end;

function TMVCBrObservable.GetItems(idx: integer): TMVCBrObserverItemAbstract;
begin
  try
    result := LockList.Items[idx];
  finally
    Unlock;
  end;
end;

procedure TMVCBrObservable.Lock;
begin
  TMonitor.enter(LLock);
end;

function TMVCBrObservable.LockList: TObjectList<TMVCBrObserverItemAbstract>;
begin
  TMonitor.enter(LLock);
  result := FSubscribers;
end;

procedure TMVCBrObservable.Register(const AName: string;
  AObserver: IMVCBrObserver);
var
  obj: TMVCBrObserverItemAbstract;
begin
  obj := TMVCBrObserverItem.create;
  obj.SetSubscribeProc(nil);
  obj.SetObserver(AObserver);
  obj.SetTopic(AName);
  with LockList do
    try
      Add(obj);
    finally
      Unlock;
    end;
end;

procedure TMVCBrObservable.Send(AJson: TJsonValue);
var
  p: TMVCBrObserverItemAbstract;
  AHandled: boolean;
begin
  Lock;
  try
    for p in FSubscribers do
    begin
      p.Send(AJson, AHandled);
      if AHandled then
        exit;
    end;
  finally
    Unlock;
  end;
end;

procedure TMVCBrObservable.Send(const AName: string; AJson: TJsonValue);
var
  i: integer;
  AHandled: boolean;
begin
  with LockList do
    try
      for i := 0 to Count - 1 do
      begin
        AHandled := false;
        if Items[i].GetTopic.Equals(AName) then
          Items[i].Send(AJson, AHandled);
        if AHandled then
          exit;
      end;
    finally
      Unlock;
    end;
end;

procedure TMVCBrObservable.SetItems(idx: integer;
  const Value: TMVCBrObserverItemAbstract);
begin
  try
    LockList.Items[idx] := Value;
  finally
    Unlock;
  end;
end;

const
  unnamed_name = 'unnamed';

function TMVCBrObservable.Subscribe(AProc: TMVCBrObserverProc)
  : IMVCBrObserverItem;
var
  obj: TMVCBrObserverItem;
begin
  obj := TMVCBrObserverItem.create;
  result := obj;
  result.SetSubscribeProc(AProc);
  result.SetObserver(nil);
  result.SetTopic(unnamed_name);
  with LockList do
    try
      Add(obj);
    finally
      Unlock;
    end;
end;

procedure TMVCBrObservable.Register(AObserver: IMVCBrObserver);
begin
  Register(unnamed_name, AObserver);
end;

class procedure TMVCBrObservable.Release;
begin
  FSubscribeServer := nil;
end;

function TMVCBrObservable.This: TObject;
begin
  result := self;
end;

function TMVCBrObservable.ThisAs: TMVCBrObservable;
begin
  result := self;
end;

procedure TMVCBrObservable.Unlock;
begin
  TMonitor.exit(LLock);
end;

procedure TMVCBrObservable.UnRegister(AObserver: IMVCBrObserver);
begin
  UnRegister(unnamed_name, AObserver);
end;

procedure TMVCBrObservable.UnRegister(const AName: string;
  AObserver: IMVCBrObserver);
var
  i: integer;
  item: TMVCBrObserverItemAbstract;
begin
  with LockList do
    try
      for i := FSubscribers.Count - 1 downto 0 do
      begin
        item := FSubscribers.Items[i];
        if item.GetObserver <> nil then
          if (item.GetTopic.Equals(AName) and (not assigned(AObserver))) or
            (item.GetTopic.Equals(AName) and TMVCBr.Equals(item.GetObserver,
            AObserver)) then
          begin
            FSubscribers.Delete(i);
          end;
      end;
    finally
      Unlock;
    end;
end;

procedure TMVCBrObservable.UnSubscribe(AProc: TMVCBrObserverProc);
var
  i: integer;
  p: TMVCBrObserverProc;
  AList: TList<TMVCBrObserverProc>;
begin

  // workaroud
  AList := TList<TMVCBrObserverProc>.create;
  try
    Lock;
    try
      for i := 0 to FSubscribers.Count - 1 do
        AList.Add(FSubscribers[i].SubscribeProc);

      i := AList.IndexOf(AProc);
      if i >= 0 then
        FSubscribers.Delete(i);
    finally
      Unlock;
    end;

  finally
    AList.free;
  end;

end;

{ TMVCBrSubscribeItem }

function TMVCBrObserverItem.GetObserver: IMVCBrObserver;
begin
  result := FObserver;
end;

function TMVCBrObserverItem.GetSubscribeProc: TMVCBrObserverProc;
begin
  result := FSubscribeProc;
end;

function TMVCBrObserverItem.GetTopic: string;
begin
  result := FTopic;
end;

procedure TMVCBrObserverItem.Send(AJsonValue: TJsonValue;
  var AHandled: boolean);
begin
  if assigned(FObserver) then
    FObserver.update(AJsonValue, AHandled)
  else if assigned(FSubscribeProc) then
    FSubscribeProc(AJsonValue)

end;

procedure TMVCBrObserverItem.SetObserver(const Value: IMVCBrObserver);
begin
  FObserver := Value;
end;

procedure TMVCBrObserverItem.SetSubscribeProc(const Value: TMVCBrObserverProc);
begin
  FSubscribeProc := Value;
end;

procedure TMVCBrObserverItem.SetTopic(const Value: string);
begin
  FTopic := Value;
end;

procedure TMVCBrObservable.UnRegister(const AName: string);
begin
  UnRegister(AName, nil);
end;

initialization

LLock := TObject.create;

finalization

TMVCBrObservable.Release;
LLock.free;

end.
