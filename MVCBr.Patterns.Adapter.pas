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

  TMVCBrAdapter<T: Class> = class(TMVCBrAdapter)
  private
    FAdapter: T;
  public
    constructor Create(AObject: T);
    destructor Destroy; override;
    property Adapter: T read FAdapter;
    procedure Release; override;
    function This: TObject; override;
  end;

  TMVCBrInterfacedAdapter<T: IInterface> = class(TMVCBrAdapter)
  private
    FAdapter: T;
  public
    constructor Create(AInterface: T);
    destructor Destroy; override;
    property Default: T read FAdapter;
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

constructor TMVCBrAdapter<T>.Create(AObject: T);
begin
  inherited Create;
  FAdapter := AObject;
end;

destructor TMVCBrAdapter<T>.Destroy;
begin
  /// need free on calls class (FAdapter)
  inherited;
end;

procedure TMVCBrAdapter<T>.Release;
begin
  if assigned(FAdapter) then
    FAdapter.free;
  FAdapter := nil;
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

end.
