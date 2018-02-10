unit MVCBr.Patterns.Adapter;
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

uses System.Classes, System.SysUtils;

type

  IMVCBrAdapter = interface
    ['{9075BA8D-80EE-4F4F-BE43-3B5F5BAB406F}']
    function This: TObject;
    procedure Release;
  end;

  TMVCBrAdapter = class(TInterfacedObject, IMVCBrAdapter)
  private
  public
    function This: TObject; virtual;
    procedure Release; virtual;
  end;

  IMVCBrAdapter<T: Class> = interface(TFunc<T>)
    property Adapter: T read Invoke;
    function GetInstance: T;
    procedure SetInstance(AInst: T; AFreeOnExit: boolean = false);
    procedure SetFreeOnExit(const Value: boolean);
    function GetFreeOnExit: boolean;
    property FreeOnExit: boolean read GetFreeOnExit write SetFreeOnExit;
    function AsInterface: IMVCBrAdapter<T>;
  end;

  TMVCBrAdapter<T: Class> = class(TMVCBrAdapter, IMVCBrAdapter<T>)
  private
    FDelegateTo: TFunc<T>;
    FFreeOnExit: boolean;
    FAdapter: T;
    function Invoke: T; virtual;
    procedure SetFreeOnExit(const Value: boolean);
    function GetFreeOnExit: boolean;
  public
    class function New(AObject: T): IMVCBrAdapter<T>; overload;
    //class function New(): IMVCBrAdapter<T>; //overload;
    constructor Create(AObject: T; AFreeOnExit:boolean=true); overload;
    //constructor Create(); overload;
    destructor Destroy; override;
    procedure SetInstance(AInst: T; AFreeOnExit: boolean = false);
    function GetInstance: T;
    property Adapter: T read Invoke;
    procedure Release; override;
    function This: TObject; override;
    property FreeOnExit: boolean read GetFreeOnExit write SetFreeOnExit;
    function DelegateTo(AProc: TFunc<T>): TMVCBrAdapter<T>;
    function AsInterface: IMVCBrAdapter<T>;
  end;

  TMVCBrInterfacedAdapter<T: IInterface> = class(TMVCBrAdapter)
  private
    FAdapter: T;
  public
    function GetInstance: T; virtual;
    constructor Create(AInterface: T);
    destructor Destroy; override;
    property Default: T read GetInstance;
  end;

implementation

procedure TMVCBrAdapter.Release;
begin
  /// nothing
end;

function TMVCBrAdapter.This: TObject;
begin
  result := self;
end;

{ TMVCBrAdapter<T> }

function TMVCBrAdapter<T>.AsInterface: IMVCBrAdapter<T>;
begin
  result := self;
end;

constructor TMVCBrAdapter<T>.Create(AObject: T; AFreeOnExit:boolean=true);
begin
  inherited Create;
  if AObject = nil then
    self.DelegateTo(
      function: T
      begin
        result := T(TClass(T).Create);
      end);
  FFreeOnExit := assigned(AObject);
  FAdapter := AObject;
end;


function TMVCBrAdapter<T>.DelegateTo(AProc: TFunc<T>): TMVCBrAdapter<T>;
begin
  result := self;
  FDelegateTo := AProc;
end;

destructor TMVCBrAdapter<T>.Destroy;
begin
  Release;
  inherited;
end;

function TMVCBrAdapter<T>.GetFreeOnExit: boolean;
begin
  result := FFreeOnExit;
end;

function TMVCBrAdapter<T>.GetInstance: T;
begin
  result := Invoke;
end;

function TMVCBrAdapter<T>.Invoke: T;
begin
  if not assigned(FAdapter) then
  begin
    if assigned(FDelegateTo) then
    begin
      FAdapter := FDelegateTo;
      FFreeOnExit := true;
    end;
  end;
  result := FAdapter;
end;

{
class function TMVCBrAdapter<T>.New: IMVCBrAdapter<T>;
begin
  result := TMVCBrAdapter<T>.New(nil);
end;
}

class function TMVCBrAdapter<T>.New(AObject: T): IMVCBrAdapter<T>;
begin
  result := TMVCBrAdapter<T>.Create(AObject);
end;

procedure TMVCBrAdapter<T>.Release;
begin
  if assigned(FAdapter) and FFreeOnExit then
    FAdapter.DisposeOf;
  FAdapter := nil;
end;

procedure TMVCBrAdapter<T>.SetFreeOnExit(const Value: boolean);
begin
  FFreeOnExit := Value;
end;

procedure TMVCBrAdapter<T>.SetInstance(AInst: T; AFreeOnExit: boolean);
begin
  if assigned(FAdapter) then
  begin
    if FAdapter.Equals(AInst) then
      exit;
    Release;
  end;
  FAdapter := AInst;
  FFreeOnExit := AFreeOnExit;
end;

function TMVCBrAdapter<T>.This: TObject;
begin
  result := self;
end;

{ TMVCBrInterfacedAdapter<T> }

constructor TMVCBrInterfacedAdapter<T>.Create(AInterface: T);
begin
  inherited Create;
  FAdapter := AInterface;
end;

destructor TMVCBrInterfacedAdapter<T>.Destroy;
begin
  /// need freed interface on owner caller
  inherited;
end;

function TMVCBrInterfacedAdapter<T>.GetInstance: T;
begin
  result := FAdapter;
end;

end.
