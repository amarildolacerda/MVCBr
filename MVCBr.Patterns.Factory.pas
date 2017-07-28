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

unit MVCBr.Patterns.Factory;


interface

uses System.Classes, System.SysUtils, System.TypInfo;

Type

  IMVCBrFactory = interface
    ['{D6FEBA20-5381-48FC-B980-694B1D001DAC}']
    function This: TObject;
    Procedure Lock;
    procedure UnLock;
  end;

  TMVCBrFactory = class(TInterfacedObject, IMVCBrFactory)
  private
    FLock: TObject;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    class function NewInstance<TInterface: IInterface>(AClass: TClass)
      : TInterface; static;
    function This: TObject; virtual;
    Procedure Lock; overload; virtual;
    procedure UnLock; virtual;
  end;

  TMVCBrSingletonFactory<T: Class> = class(TMVCBrFactory)
  private
    class var FSingleton: T;
  public
    constructor Create; override;
    class function Default: T;
    class procedure Release;
  end;

  TMVCBrBuilderFactory<T> = class(TMVCBrFactory)
  private
    FDelegate: TProc<T>;
  public
    constructor Create(ADelegate: TProc<T>);
    function Builder(AObject: T): TMVCBrBuilderFactory<T>;
  end;

implementation

{ TMVCBrFactory }

constructor TMVCBrFactory.Create;
begin
  inherited Create;
  FLock := TObject.Create;
end;

destructor TMVCBrFactory.Destroy;
begin
  FLock.free;
  inherited;
end;

procedure TMVCBrFactory.Lock;
begin
  TMonitor.enter(FLock);
end;

class function TMVCBrFactory.NewInstance<TInterface>(AClass: TClass)
  : TInterface;
var
  o: TObject;
  pInfo: PTypeInfo;
  IID: TGuid;
begin
  o := AClass.Create;
  pInfo := TypeInfo(TInterface);
  IID := GetTypeData(pInfo).Guid;
  if not supports(o, IID, result) then
  begin
    o.free;
    raise Exception.Create('O objeto não implementa a interface solicitada');
  end;
end;

function TMVCBrFactory.This: TObject;
begin
  result := self;
end;

procedure TMVCBrFactory.UnLock;
begin
  TMonitor.Exit(FLock);
end;

{ TMVCBrSingletonFactory<T> }

constructor TMVCBrSingletonFactory<T>.Create();
begin
  inherited Create;
end;

class function TMVCBrSingletonFactory<T>.Default: T;
var
  LClass: TClass;
begin
  LClass := T;
  if not assigned(FSingleton) then
    FSingleton := LClass.Create as T;
  result := FSingleton;
end;

class procedure TMVCBrSingletonFactory<T>.Release;
begin
  if assigned(FSingleton) then
    FSingleton.disposeOf;
  FSingleton := nil;
end;

{ TMVCBrBuilderFactory<T> }

function TMVCBrBuilderFactory<T>.Builder(AObject: T): TMVCBrBuilderFactory<T>;
begin
  result := self;
  FDelegate(AObject);
end;

constructor TMVCBrBuilderFactory<T>.Create(ADelegate: TProc<T>);
begin
  inherited Create;
  FDelegate := ADelegate;
end;

initialization

finalization

TMVCBrSingletonFactory<TObject>.Release;

end.
