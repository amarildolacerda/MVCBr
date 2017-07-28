
unit MVCBr.Patterns.Factory;
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

interface

uses System.Classes, System.SysUtils, System.TypInfo;

Type

  IMVCBrFactory = interface
    ['{D6FEBA20-5381-48FC-B980-694B1D001DAC}']
    function This: TObject;
    Procedure Lock;
    procedure UnLock;
    procedure Release;
    function RefCount:Integer;
  end;

  TMVCBrFactory = class(TInterfacedObject, IMVCBrFactory)
  private
    FLock: TObject;
    FIsUnsafe: boolean;
    FDefaultSafeted: IInterface;
    [unsafe]
    FDefault: IInterface;
    function GetDefault: IInterface;
  public
    //Constructor New;virtual;
    constructor Create; overload; virtual;
    constructor Create(AInterface: IInterface; AUnsafe: boolean = true);
      overload; virtual;
    destructor Destroy; override;
    procedure SetUnsafe(AInterface: IInterface); virtual;
    procedure SetSafeted(AInterface: IInterface); virtual;
    property Default: IInterface read GetDefault;
    class function NewInstance<TInterface: IInterface>(AClass: TClass)
      : TInterface; static;
    function This: TObject; virtual;
    Procedure Lock; overload; virtual;
    procedure UnLock; virtual;
    procedure Release; virtual;
    function RefCount:Integer;
  end;

  {
    /// nao faz sentido um singleton para uma classe estática.
    /// nao tem como manter mais de uma variavel ao logo da aplicacação
  TMVCBrSingletonFactory<T: Class> = class(TMVCBrFactory)
  private
    class var FSingleton: T;
  public
    constructor Create; override;
    class function Default: T;
    class procedure Release;
  end;
  }

  TMVCBrAggregatedFactory = class(TObject)
  private
    [unsafe]
    FController: IInterface;
    FDisabledRefCount: boolean; // unsafe/weak reference to controller
    function GetDefault: IInterface;
    procedure SetDisabledRefCount(const Value: boolean);
  public
    property Default: IInterface read GetDefault;
    function QueryInterface(const IID: TGUID; out Obj): HResult; STDCALL;
    function _AddRef: Integer; STDCALL;
    function _Release: Integer; STDCALL;
    procedure Release; virtual;
    constructor Create(const Controller: IInterface);
    destructor Destroy; override;
    property DisabledRefCount: boolean read FDisabledRefCount
      write SetDisabledRefCount;
  end;

  TMVCBrContainedFactory = class(TMVCBrAggregatedFactory)
  public
    function QueryInterface(const IID: TGUID; out Obj): HResult; STDCALL;
  end;

  TMVCBrHelperFactory<T: Class> = class(TInterfacedObject)
  protected
    FInstance: T;
  public
    constructor Create(Instance: T);
    destructor Destroy; override;
    property Default: T read FInstance;
  end;

  TMVCBrStaticFactory<T> = class(TObject)
  protected
    FInstance: T;
  public
    constructor Create(AInstance: T);
    property Default: T read FInstance;
  end;

implementation

{ TMVCBrFactory }

constructor TMVCBrFactory.Create;
begin
  inherited Create;
  FDefaultSafeted := nil;
  FIsUnsafe := false;
  FDefault := nil;
  FRefCount := 1;
  FLock := TObject.Create;
end;

constructor TMVCBrFactory.Create(AInterface: IInterface;
  AUnsafe: boolean = true);
begin
  Create;
  if AUnsafe then
    SetUnsafe(AInterface)
  else
  begin
    FDefaultSafeted := AInterface;
  end;
end;

destructor TMVCBrFactory.Destroy;
begin
  FDefault := nil;
  FDefaultSafeted := nil;
  FLock.free;
  inherited;
end;

function TMVCBrFactory.GetDefault: IInterface;
begin
  if FIsUnsafe then
    result := FDefault
  else if assigned(FDefaultSafeted) then
    result := FDefaultSafeted
  else
    result := self;
end;

procedure TMVCBrFactory.Lock;
begin
  TMonitor.enter(FLock);
end;

{constructor TMVCBrFactory.New;
begin
      Create;
end;
}

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

function TMVCBrFactory.RefCount: Integer;
begin
   result := inherited RefCount;
end;

procedure TMVCBrFactory.Release;
begin
end;

procedure TMVCBrFactory.SetSafeted(AInterface: IInterface);
begin
  if FDefaultSafeted <> AInterface then
  begin
    FDefaultSafeted := AInterface;
    FDefault := nil;
  end;
  FIsUnsafe := false;
end;

procedure TMVCBrFactory.SetUnsafe(AInterface: IInterface);
begin
  if FDefault <> AInterface then
    FDefault := AInterface;
  FDefaultSafeted := nil;
  FIsUnsafe := true;
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
(*
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
*)

{ TMVCBrAggregatedFactory }

constructor TMVCBrAggregatedFactory.Create(const Controller: IInterface);
begin
  // "unsafe" reference to controller - don't keep it alive
  FController := Controller;
end;

destructor TMVCBrAggregatedFactory.Destroy;
begin
  FController := nil;
  inherited;
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

procedure TMVCBrAggregatedFactory.SetDisabledRefCount(const Value: boolean);
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

constructor TMVCBrHelperFactory<T>.Create(Instance: T);
begin
  inherited Create;
  FInstance := Instance;
end;

destructor TMVCBrHelperFactory<T>.Destroy;
begin
  FInstance.free;
  inherited;
end;

{ TMVCBrStaticFactory<T> }

constructor TMVCBrStaticFactory<T>.Create(AInstance: T);
begin
  inherited Create;
  FInstance := AInstance;
end;

initialization

finalization

//TMVCBrSingletonFactory<TObject>.Release;

end.
