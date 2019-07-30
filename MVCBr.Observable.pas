unit MVCBr.Observable;
{ *************************************************************************** }
{ }
{ MVCBr � o resultado de esfor�os de um grupo }
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

interface

uses System.Classes, System.SysUtils,
  System.Generics.Collections,
  System.JSON, MVCBr.Interf, System.ThreadSafe;

type

  IMVCBrObserver = MVCBr.Interf.IMVCBrObserver;

  IMVCBrObserverItem = MVCBr.Interf.IMVCBrObserverItem;

  IMVCBrObservable = MVCBr.Interf.IMVCBrObservable;
  TMVCBrObserverProc = MVCBr.Interf.TMVCBrObserverProc;

  /// <summary>
  /// Data item about subscriber
  /// </summary>
  TMVCBrObserverItem = class(TMVCBrObserverItemAbstract, IMVCBrObserverItem)
  private
    [unsafe]
    FObserver: IMVCBrObserver;
    FTopic: string;
    procedure SetTopic(const Value: string); override;
    function GetTopic: string; override;
    procedure SetSubscribeProc(const Value: TMVCBrObserverProc); override;
    procedure SetObserver(const Value: IMVCBrObserver); override;
    function GetObserver: IMVCBrObserver; override;
  protected
    FSubscribeProc: TMVCBrObserverProc;
    function GetSubscribeProc: TMVCBrObserverProc; override;
  public
    destructor Destroy; override;
    procedure release; override;
    property Observer: IMVCBrObserver read GetObserver write SetObserver;
    property Topic: string read GetTopic write SetTopic;
    property SubscribeProc: TMVCBrObserverProc read GetSubscribeProc
      write SetSubscribeProc;
    procedure Send(AJsonValue: TJsonValue; var AHandled: boolean); override;
  end;

  /// <summary>
  /// List of Observer itens
  /// </summary>
  ///
  TMVCBrObservable = class(TInterfacedObject, IMVCBrObservable)
  type
    TObservableList = class(TObjectList<TMVCBrObserverItemAbstract>)
    end;
  private
    FLock: TObject;
    FSubscribers: TObservableList;
    function GetItems(idx: integer): TMVCBrObserverItemAbstract;
    procedure SetItems(idx: integer; const Value: TMVCBrObserverItemAbstract);
    class procedure release;
  public
    Constructor create;
    Destructor Destroy; override;
    procedure Clear;
    function LockList: TObservableList; overload;
    procedure UnlockList;
    class function DefaultContainer: TMVCBrObservable;
    function Count: integer;
    property Items[idx: integer]: TMVCBrObserverItemAbstract read GetItems
      write SetItems;
    function This: TObject;
    function ThisAs: TMVCBrObservable;
    [weak]
    function Subscribe(AProc: TMVCBrObserverProc): IMVCBrObserverItem; overload;
    procedure UnSubscribe(AProc: TMVCBrObserverProc;
      AName: String = ''); overload;
    procedure Send(AJson: TJsonValue); overload;
    procedure Send(const AName: string; AJson: TJsonValue;
      AOwned: boolean = true); overload;
    procedure Send(const AName: string; AMensagem: String); overload;
    procedure Send(const AName: string; ASubject: string;
      AMensagem: String); overload;
    procedure Send(const AName: string; ASubject: string; AMensagem: String;
      AData: string); overload;
    procedure Send(const AName: string); overload;
    [weak]
    function Register(const AName: string; AObserver: IMVCBrObserver)
      : IMVCBrObservable; overload;
    [weak]
    procedure Register(AObserver: IMVCBrObserver); overload;
    procedure Register(AName: string; AProc: TMVCBrObserverProc); overload;
    procedure Register(AOwner: TObject; AName: string;
      AProc: TMVCBrObserverProc); overload;

    procedure Register(AGuid: TGuid; AName: string;
      AProc: TMVCBrObserverProc); overload;
    procedure Unregister(AGuid: TGuid); overload;
    [weak]
    procedure Unregister(const AName: string;
      AObserver: IMVCBrObserver); overload;
    [weak]
    procedure Unregister(AObserver: IMVCBrObserver); overload;
    procedure Unregister(const AName: string); overload;
    procedure Unregister(AOwner: TObject); overload;
    procedure Unregister(AOwner: TObject; AName: string); overload;
    class procedure Notify(AName: string; AValue: TJsonValue); overload;
    class procedure Notify(AName: string; AMessage: string); overload;
    class procedure Info(AMessage: string); static;
    class procedure Subscribe(AOwner: TObject; AName: string;
      AProc: TMVCBrObserverProc); overload;
    class procedure Subscribe(const AName: string;
      AProc: TMVCBrObserverProc); overload;
    class procedure UnSubscribe(AOwnder: TObject; AName: String = ''); overload;
    class procedure UnSubscribe(const AName: String); overload;
    class procedure RequestInfo(AName: string; var AValue: TJsonValue); virtual;
  end;

implementation

{ TMVCBrObserver }
var
  FSubscribeServer: TMVCBrObservable;
  LLock: TObject;

procedure TMVCBrObservable.Clear;
begin
  with LockList do
    try
      Clear;
      { while Count > 0 do
        begin
        try
        delete(0);
        except
        end;
        end; }
    finally
      UnlockList;
    end;
end;

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
  FLock := TObject.create;
  FSubscribers := TObservableList.create;
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
  FSubscribers.disposeOf;
  FLock.disposeOf;
  inherited;
end;

function TMVCBrObservable.GetItems(idx: integer): TMVCBrObserverItemAbstract;
begin
  try
    result := LockList.Items[idx];
  finally
    UnlockList;
  end;
end;

function TMVCBrObservable.LockList: TObservableList;
begin
  TMonitor.enter(FLock);
  result := FSubscribers; // .LockList;
end;

class procedure TMVCBrObservable.Notify(AName, AMessage: string);
begin
  TMVCBrObservable.DefaultContainer.Send(AName, AMessage);
end;

class procedure TMVCBrObservable.Notify(AName: string; AValue: TJsonValue);
begin
  TMVCBrObservable.DefaultContainer.Send(AName, AValue);
end;

class procedure TMVCBrObservable.Info(AMessage: string);
begin
  TMVCBrObservable.DefaultContainer.Send('info-message', AMessage);
end;

procedure TMVCBrObservable.Register(AOwner: TObject; AName: string;
  AProc: TMVCBrObserverProc);
var
  obj: TMVCBrObserverItem;
begin

  with LockList do
    try
      obj := TMVCBrObserverItem.create;
      obj.SetSubscribeProc(AProc);
      obj.SetObserver(nil);
      obj.SetTopic(AName);
      obj.SetContainer(AOwner);
      Add(obj);
    finally
      UnlockList;
    end;
end;

function TMVCBrObservable.Register(const AName: string;
  AObserver: IMVCBrObserver): IMVCBrObservable;
var
  obj: TMVCBrObserverItemAbstract;
begin
  result := self;
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
  try
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
  except
  end;
end;

procedure TMVCBrObservable.Send(const AName: string; AJson: TJsonValue;
  AOwned: boolean = true);
var
  i: integer;
  AHandled: boolean;
  ADados: string;
  nDados: integer;
begin
  try
    try
      nDados := 0;
      ADados := '';
{$IFDEF DEBUG}
      if assigned(AJson) then
        ADados := AJson.ToString;
{$ENDIF}
      OutputDebug('TMVCBrObservable.Send(' + AName + ')' + ' ' + ADados);

      TThread.NameThreadForDebugging('observable.send');
      with LockList do
        try
          for i := 0 to Count - 1 do
          begin
            AHandled := false;
            if Items[i].GetTopic.Equals(AName) then
            begin
              Items[i].Send(AJson, AHandled);
            end;
            if AHandled then
              exit;
          end;
        finally
          UnlockList;
        end;
    finally
      if AOwned then
        AJson.disposeOf;
    end;
  except
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
      Send(AName, AJson);
    finally
      // AJson.DisposeOf;
    end;
end;

procedure TMVCBrObservable.Send(const AName: string);
begin
  Send(AName, '');
end;

procedure TMVCBrObservable.Send(const AName: string;
  ASubject, AMensagem, AData: string);
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
    // AJson.DisposeOf;
  end;
end;

procedure TMVCBrObservable.Send(const AName: string;
  ASubject, AMensagem: String);
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
    // AJson.DisposeOf;
  end;
end;

procedure TMVCBrObservable.SetItems(idx: integer;
  const Value: TMVCBrObserverItemAbstract);
begin
  try
    LockList.Items[idx] := Value;
  finally
    UnlockList;
  end;
end;

class procedure TMVCBrObservable.Subscribe(const AName: string;
  AProc: TMVCBrObserverProc);
begin
  self.DefaultContainer.Register(AName, AProc);
end;

class procedure TMVCBrObservable.Subscribe(AOwner: TObject; AName: string;
  AProc: TMVCBrObserverProc);
begin
  self.DefaultContainer.Register(AOwner, AName, AProc);
end;

procedure TMVCBrObservable.Register(AName: string; AProc: TMVCBrObserverProc);
begin
  self.Register(nil, AName, AProc);
end;

const
  unnamed_name = 'unnamed';

function TMVCBrObservable.Subscribe(AProc: TMVCBrObserverProc)
  : IMVCBrObserverItem;
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

class procedure TMVCBrObservable.RequestInfo(AName: string;
  var AValue: TJsonValue);
var
  i: integer;
  AHandled: boolean;
  it: TMVCBrObserverItem;
begin

  try
    TThread.NameThreadForDebugging('observable.RequestInfo');
    with TMVCBrObservable.DefaultContainer do
      with LockList do
        try
          for i := 0 to Count - 1 do
          begin
            AHandled := false;
            it := TMVCBrObserverItem(Items[i]);
            if it.GetTopic.Equals(AName) then
              if assigned(it.FSubscribeProc) then
              begin
                it.FSubscribeProc(AValue);
                AHandled := true;
              end;
            if AHandled then
              exit;
          end;
        finally
          UnlockList;
        end;
  finally
  end;
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
  TMonitor.exit(FLock);
end;

procedure TMVCBrObservable.Unregister(AGuid: TGuid);
var
  i: integer;
begin
  with LockList do
    try
      for i := Count - 1 downto 0 do
        if Items[i].GetIDInstance = AGuid then
          delete(i);
      /// for all
    finally
      UnlockList;
    end;

end;

procedure TMVCBrObservable.Unregister(AObserver: IMVCBrObserver);
begin
  Unregister(unnamed_name, AObserver);
end;

procedure TMVCBrObservable.Unregister(const AName: string;
  AObserver: IMVCBrObserver);
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
              if (item.GetTopic.Equals(AName) and (not assigned(AObserver))) or
                (item.GetTopic.Equals(AName) and TMVCBr.Equals(item.GetObserver,
                AObserver)) then
              begin
                delete(i);
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

procedure TMVCBrObservable.UnSubscribe(AProc: TMVCBrObserverProc;
  AName: String = '');
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
          AList.Add(TMVCBrObserverItem(Items[i]).FSubscribeProc);
        i := AList.IndexOf(AProc);
        if i >= 0 then
          delete(i);
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

procedure TMVCBrObserverItem.Send(AJsonValue: TJsonValue;
  var AHandled: boolean);
begin
  if assigned(FObserver) then
    FObserver.update(AJsonValue, AHandled)
  else if assigned(FSubscribeProc) then
    TThread.queue(nil,
      procedure
      begin
        try
          FSubscribeProc(AJsonValue);
        except
        end;
      end);
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

procedure TMVCBrObservable.Register(AGuid: TGuid; AName: string;
AProc: TMVCBrObserverProc);
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

procedure TMVCBrObservable.Unregister(AOwner: TObject);
begin
  Unregister(AOwner, '');
end;

procedure TMVCBrObservable.Unregister(AOwner: TObject; AName: String);
var
  i: integer;
  SName: string;
  SObject: TObject;
  comp: IComparable<TObject>;
begin
  with LockList do
    try
      for i := Count - 1 downto 0 do
      begin
        try
          SName := Items[i].GetTopic;
          SObject := Items[i].GetContainer;
          if SObject = AOwner then
          begin
            if (AName <> '') and (SName <> AName) then
              continue;
            Items[i].SetContainer(nil);
            delete(i);
          end;
        except // nao encontrou
          delete(i);
        end;
      end;
    finally
      UnlockList;
    end;
end;

class procedure TMVCBrObservable.UnSubscribe(const AName: String);
begin
  self.DefaultContainer.Unregister(AName, nil);
end;

class procedure TMVCBrObservable.UnSubscribe(AOwnder: TObject;
AName: String = '');
begin
  try
    if assigned(FSubscribeServer) and assigned(AOwnder) then
      FSubscribeServer.Unregister(AOwnder, AName);
  except
  end;
end;

initialization

LLock := TObject.create;

finalization

if assigned(FSubscribeServer) then
  FSubscribeServer.disposeOf;
FSubscribeServer := nil;
LLock.free;

end.
