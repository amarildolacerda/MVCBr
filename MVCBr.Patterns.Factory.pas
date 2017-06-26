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
    procedure Release;
  end;

  TMVCBrFactory = class(TInterfacedObject, IMVCBrFactory)
  private
    FLock: TObject;
    [unsafe]
    FDefault: IInterface;
    function GetDefault: IInterface;
  public
    constructor Create; overload;virtual;
    constructor Create(AInterface: IInterface); overload;virtual;
    destructor Destroy; override;
    procedure SetUnsafe(AInterface:IInterface);virtual;
    property Default: IInterface read GetDefault;
    class function NewInstance<TInterface: IInterface>(AClass: TClass)
      : TInterface; static;
    function This: TObject; virtual;
    Procedure Lock; overload; virtual;
    procedure UnLock; virtual;
    procedure Release; virtual;
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

  TMVCBrAggregatedFactory = class(TObject)
  private
    [unsafe]
    FController: IInterface;
    FDisabledRefCount: Boolean; // unsafe/weak reference to controller
    function GetDefault: IInterface;
    procedure SetDisabledRefCount(const Value: Boolean);
  public
    property Default: IInterface read GetDefault;
    function QueryInterface(const IID: TGUID; out Obj): HResult; STDCALL;
    function _AddRef: Integer; STDCALL;
    function _Release: Integer; STDCALL;
    procedure Release; virtual;
    constructor Create(const Controller: IInterface);
    property DisabledRefCount: Boolean read FDisabledRefCount
      write SetDisabledRefCount;
  end;

  TMVCBrContainedFactory = class(TMVCBrAggregatedFactory)
  public
    function QueryInterface(const IID: TGUID; out Obj): HResult; STDCALL;
  end;

  TMVCBrHelperFactory = class(TInterfacedObject)
  protected
    FInstance: TObject;
  public
    constructor Create(Instance: TObject);
    destructor Destroy; override;
  end;

  TMVCBrStaticFactory = class(TObject)

  end;

implementation

{ TMVCBrFactory }

constructor TMVCBrFactory.Create;
begin
  inherited Create;
  FDefault := nil;
  FRefCount := 1;
  FLock := TObject.Create;
end;

constructor TMVCBrFactory.Create(AInterface: IInterface);
begin
    Create;
    SetUnsafe(AInterface);
end;

destructor TMVCBrFactory.Destroy;
begin
  FLock.free;
  inherited;
end;

function TMVCBrFactory.GetDefault: IInterface;
begin
  if assigned(FDefault) then
    result := FDefault
  else
    result := self;
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
  IID: TGUID;
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

procedure TMVCBrFactory.Release;
begin
  // FDisabledRefCount := false;
  // _Release;
end;


procedure TMVCBrFactory.SetUnsafe(AInterface: IInterface);
begin
  FDefault := AInterface;
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

{ TMVCBrAggregatedFactory }

constructor TMVCBrAggregatedFactory.Create(const Controller: IInterface);
begin
  // "unsafe" reference to controller - don't keep it alive
  FController := Controller;
end;

function TMVCBrAggregatedFactory.GetDefault: IInterface;
begin
  result := FController;
end;

function TMVCBrAggregatedFactory.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  result := FController.QueryInterface(IID, Obj);
end;

procedure TMVCBrAggregatedFactory.Release;
begin
  if FDisabledRefCount then
  begin
    FDisabledRefCount := false;
  end;
  _Release;
end;

procedure TMVCBrAggregatedFactory.SetDisabledRefCount(const Value: Boolean);
begin
  FDisabledRefCount := Value;
end;

function TMVCBrAggregatedFactory._AddRef: Integer;
begin
  if not FDisabledRefCount then
    result := FController._AddRef
  else
    result := 1;
end;

function TMVCBrAggregatedFactory._Release: Integer;
begin
  if not FDisabledRefCount then
    result := FController._Release
  else
    result := 1;
end;

{ TMVCBrContainedFactory }

function TMVCBrContainedFactory.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    result := 0
  else
    result := E_NOINTERFACE;
end;

{ TMVCBrHelperFactory }

constructor TMVCBrHelperFactory.Create(Instance: TObject);
begin
  inherited Create;
  FInstance := Instance;
end;

destructor TMVCBrHelperFactory.Destroy;
begin

  inherited;
end;

initialization

finalization

// TMVCBrSingletonFactory<TObject>.Release;

end.
