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

uses System.Classes, System.SysUtils,
  System.Generics.Collections,
  System.JSON, MVCBr.Interf, System.ThreadSafe;

type

  /// <summary>
  /// Data item about subscriber
  /// </summary>
  TMVCBrObserverItem = class(TMVCBrObserverItemAbstract, IMVCBrObserverItem)
  private
    [unsafe]
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
    destructor Destroy; override;
    procedure release; override;
    property Observer: IMVCBrObserver read GetObserver write SetObserver;
    property Topic: string read GetTopic write SetTopic;
    property SubscribeProc: TMVCBrObserverProc read GetSubscribeProc write SetSubscribeProc;
    procedure Send(AJsonValue: TJsonValue; var AHandled: boolean); override;
  end;

  /// <summary>
  /// List of Observer itens
  /// </summary>
  TMVCBrObservable = class(TInterfacedObject, IMVCBrObservable)
  private
    FSubscribers: TThreadList<IMVCBrObserverItem>;
    function GetItems(idx: integer): IMVCBrObserverItem;
    procedure SetItems(idx: integer; const Value: IMVCBrObserverItem);
    class procedure release;
  public
    Constructor create;
    Destructor Destroy; override;
    function LockList: TList<IMVCBrObserverItem>; overload;
    procedure UnlockList;
    class function DefaultContainer: TMVCBrObservable;
    function Count: integer;
    property Items[idx: integer]: IMVCBrObserverItem read GetItems write SetItems;
    function This: TObject;
    function ThisAs: TMVCBrObservable;
    function Subscribe(AProc: TMVCBrObserverProc): IMVCBrObserverItem; overload;
    procedure UnSubscribe(AProc: TMVCBrObserverProc); overload;
    procedure Send(AJson: TJsonValue); overload;
    procedure Send(const AName: string; AJson: TJsonValue); overload;
    procedure Send(const AName: string; AMensagem: String); overload;
    procedure Send(const AName: string; ASubject: string; AMensagem: String); overload;
    procedure Send(const AName: string; ASubject: string; AMensagem: String; AData: string); overload;
    procedure Send(const AName: string); overload;
    procedure Register(const AName: string; AObserver: IMVCBrObserver); overload;
    procedure Register(AObserver: IMVCBrObserver); overload;
    procedure Register(AName: string; AProc: TMVCBrObserverProc); overload;

    procedure Register(AGuid: TGuid; AName: string; AProc: TMVCBrObserverProc); overload;
    procedure Unregister(AGuid: TGuid); overload;

    procedure Unregister(const AName: string; AObserver: IMVCBrObserver); overload;
    procedure Unregister(AObserver: IMVCBrObserver); overload;
    procedure Unregister(const AName: string); overload;
  end;

implementation

{ TMVCBrObserver }
var
  FSubscribeServer: IMVCBrObservable;
  LLock: TObject;

function TMVCBrObservable.Count: integer;
begin
  try
    result := LockList.Count;
  finally
    UnlockList;
  end;
end;

constructor TMVCBrObservable.create;
begin
  inherited create;
  FSubscribers := TThreadList<IMVCBrObserverItem>.create;
end;

class function TMVCBrObservable.DefaultContainer: TMVCBrObservable;
begin
  try
    if not assigned(FSubscribeServer) then
      FSubscribeServer := TMVCBrObservable.create;
    result := TMVCBrObservable(FSubscribeServer.This);
  finally
  end;
end;

destructor TMVCBrObservable.Destroy;
begin
  FSubscribers.free;
  inherited;
end;

function TMVCBrObservable.GetItems(idx: integer): IMVCBrObserverItem;
begin
  try
    result := LockList.Items[idx];
  finally
    UnlockList;
  end;
end;

function TMVCBrObservable.LockList: TList<IMVCBrObserverItem>;
begin
  result := FSubscribers.LockList;
end;

procedure TMVCBrObservable.Register(const AName: string; AObserver: IMVCBrObserver);
var
  obj: TMVCBrObserverItemAbstract;
begin
  with LockList do
    try
      obj := TMVCBrObserverItem.create;
      obj.SetSubscribeProc(nil);
      obj.SetObserver(AObserver);
      obj.SetTopic(AName);
      Add(obj);
    finally
      UnlockList;
    end;
end;

procedure TMVCBrObservable.Send(AJson: TJsonValue);
var
  i: integer;
  p: IMVCBrObserverItem;
  AHandled: boolean;
begin
  with LockList do
    try
      for i := 0 to Count - 1 do
      begin
        p := Items[i];
        p.Send(AJson, AHandled);
        if AHandled then
          exit;
      end;
    finally
      UnlockList;
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
      UnlockList;
    end;
end;

procedure TMVCBrObservable.Send(const AName: string; AMensagem: String);
var
  AJson: TJsonObject;
begin
  AJson := TJsonObject.create as TJsonObject;
  try
    AJson.AddPair('subject', 'general');
    AJson.AddPair('message', AMensagem);
    AJson.AddPair('data', '');
    Send(AName, AJson);
  finally
    AJson.DisposeOf;
  end;
end;

procedure TMVCBrObservable.Send(const AName: string);
begin
  Send(AName, '');
end;

procedure TMVCBrObservable.Send(const AName: string; ASubject, AMensagem, AData: string);
var
  AJson: TJsonObject;
begin
  AJson := TJsonObject.create as TJsonObject;
  try
    AJson.AddPair('subject', ASubject);
    AJson.AddPair('message', AMensagem);
    AJson.AddPair('data', AData);
    Send(AName, AJson);
  finally
    AJson.DisposeOf;
  end;
end;

procedure TMVCBrObservable.Send(const AName: string; ASubject, AMensagem: String);
var
  AJson: TJsonObject;
begin
  AJson := TJsonObject.create as TJsonObject;
  try
    AJson.AddPair('subject', ASubject);
    AJson.AddPair('message', AMensagem);
    AJson.AddPair('data', '');
    Send(AName, AJson);
  finally
    AJson.DisposeOf;
  end;
end;

procedure TMVCBrObservable.SetItems(idx: integer; const Value: IMVCBrObserverItem);
begin
  try
    LockList.Items[idx] := Value;
  finally
    UnlockList;
  end;
end;

procedure TMVCBrObservable.Register(AName: string; AProc: TMVCBrObserverProc);
var
  obj: TMVCBrObserverItem;
begin
  with LockList do
    try
      obj := TMVCBrObserverItem.create;
      obj.SetSubscribeProc(AProc);
      obj.SetObserver(nil);
      obj.SetTopic(AName);
      Add(obj);
    finally
      UnlockList;
    end;
end;

const
  unnamed_name = 'unnamed';

function TMVCBrObservable.Subscribe(AProc: TMVCBrObserverProc): IMVCBrObserverItem;
begin
  Register(unnamed_name, AProc);
end;

procedure TMVCBrObservable.Register(AObserver: IMVCBrObserver);
begin
  Register(unnamed_name, AObserver);
end;

class procedure TMVCBrObservable.release;
begin
  // FSubscribeServer := nil;
end;

function TMVCBrObservable.This: TObject;
begin
  result := self;
end;

function TMVCBrObservable.ThisAs: TMVCBrObservable;
begin
  result := self;
end;

procedure TMVCBrObservable.UnlockList;
begin
  FSubscribers.UnlockList;
end;

procedure TMVCBrObservable.Unregister(AGuid: TGuid);
var
  i: integer;
begin
  with LockList do
    try
      for i := Count - 1 downto 0 do
        if Items[i].GetIDInstance = AGuid then
          Delete(i);
      /// for all
    finally
      UnlockList;
    end;

end;

procedure TMVCBrObservable.Unregister(AObserver: IMVCBrObserver);
begin
  Unregister(unnamed_name, AObserver);
end;

procedure TMVCBrObservable.Unregister(const AName: string; AObserver: IMVCBrObserver);
var
  i: integer;
  item: IMVCBrObserverItem;
begin
  with LockList do
    try
      for i := Count - 1 downto 0 do
      begin
        item := Items[i];
        try
          if assigned(item) then
            if item.GetObserver <> nil then
              if (item.GetTopic.Equals(AName) and (not assigned(AObserver))) or (item.GetTopic.Equals(AName) and TMVCBr.Equals(item.GetObserver, AObserver)) then
              begin
                Delete(i);
                item := nil;
              end;
        except // nao encontrou
        end;
        item := nil;
      end;
    finally
      UnlockList;
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
    with LockList do
      try
        for i := 0 to Count - 1 do
          AList.Add(Items[i].GetSubscribeProc);
        i := AList.IndexOf(AProc);
        if i >= 0 then
          Delete(i);
      finally
        UnlockList;
      end;

  finally
    AList.free;
  end;

end;

{ TMVCBrSubscribeItem }

destructor TMVCBrObserverItem.Destroy;
begin
  FObserver := nil;
  inherited;
end;

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

procedure TMVCBrObserverItem.release;
begin
  FObserver := nil;
  inherited;
end;

procedure TMVCBrObserverItem.Send(AJsonValue: TJsonValue; var AHandled: boolean);
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

procedure TMVCBrObservable.Unregister(const AName: string);
begin
  Unregister(AName, nil);
end;

procedure TMVCBrObservable.Register(AGuid: TGuid; AName: string; AProc: TMVCBrObserverProc);
var
  obj: TMVCBrObserverItem;
begin
  with LockList do
    try
      obj := TMVCBrObserverItem.create;
      obj.IDInstance := AGuid;
      obj.SetSubscribeProc(AProc);
      obj.SetObserver(nil);
      obj.SetTopic(AName);
      Add(obj);
    finally
      UnlockList;
    end;
end;

initialization

LLock := TObject.create;

finalization

FSubscribeServer := nil;
LLock.free;

end.
