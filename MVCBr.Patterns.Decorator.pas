unit MVCBr.Patterns.Decorator;
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

Type

  IMVCBrDecorator = interface
    ['{09068FF3-F838-4A09-BFDE-6E71174AF130}']
    function This: TObject;
  end;

  IMVCBrDecorator<T> = interface
    ['{C7232C1A-A389-45B8-B760-0916E5B645A2}']
    function Invoke: T;
    function This: TObject;
    property Decorate: T read Invoke;
  end;

  IMVCBrDecorate<T> = interface(TFunc<T>)
    ['{8A452998-C520-4289-99EE-12527FD5D3D9}']
    function This: TObject;
    property Decorate: T read Invoke;
  end;

  TMVCBrDecorator<T> = class(TInterfacedObject, IMVCBrDecorator,
    IMVCBrDecorate<T>, IMVCBrDecorator<T>)
  private
    FLock: TObject;
  protected
    FDecorate: T;
    function Invoke: T; virtual;
  public
    constructor create(ADecorate: T);
    destructor destroy; override;
    property Decorate: T read Invoke;
    function This: TObject; virtual;
    function Lock: T; virtual;
    procedure UnLock; virtual;
  end;

implementation

{ TMVCBrDecorator<T> }

constructor TMVCBrDecorator<T>.create(ADecorate: T);
begin
  inherited create;
  FLock := TObject.create;
  FDecorate := ADecorate;
end;

function TMVCBrDecorator<T>.Invoke: T;
begin
  result := FDecorate;
end;

destructor TMVCBrDecorator<T>.destroy;
begin
  /// dont free FDecorate - need free on owned calls
  FLock.free;
  inherited;
end;

function TMVCBrDecorator<T>.Lock: T;
begin
  TMonitor.enter(FLock);
  result := FDecorate;
end;

function TMVCBrDecorator<T>.This: TObject;
begin
  result := self;
end;

procedure TMVCBrDecorator<T>.UnLock;
begin
  TMonitor.exit(FLock);
end;

end.
