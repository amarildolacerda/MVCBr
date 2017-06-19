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

unit MVCBr.Patterns.States;

interface

uses System.Classes, System.SysUtils,
  System.Generics.Collections, System.TypInfo,
  System.JSON;

Type

  IMVCBrStateStep = interface
    ['{09707154-F172-4F76-B9A5-AECAF48A2F71}']
    function This: TObject;
    procedure Execute;
  end;

  TDelegateSteps = TProc<IMVCBrStateStep>;

  /// <summary>
  /// TMVCBrStateStep class to be inherited
  /// </summary>
  TMVCBrStateStep = class(TInterfacedObject, IMVCBrStateStep)
  public
    function This: TObject; virtual;
    procedure Execute; virtual;
  end;

  /// <summary>
  /// Structure Class is data step item
  /// </summary>
  TMVCBrStateSteps<T> = class
    FPriorStep: Integer;
    FNextStep: Integer;
    FImplClass: TInterfacedClass;
    FInterface: PTypeInfo;
    FInstance: IMVCBrStateStep;
    FDelegate: TDelegateSteps;
    function Prior(AStep: Integer): TMVCBrStateSteps<T>;
    function Next(AStep: Integer): TMVCBrStateSteps<T>;
    function Delegate(ADelegate: TDelegateSteps): TMVCBrStateSteps<T>;
    function ImplementClass(AClass: TInterfacedClass): TMVCBrStateSteps<T>;
    function asInstance: IInterface;
    function Implements<TImplements>: TMVCBrStateSteps<T>;
    procedure execute;
  end;

  /// <summary>
  /// Steps interface
  /// </summary>
  IMVCBrStates<T> = interface
    ['{59CAE8A6-0E0D-44B6-B0E0-4D12EC22077B}']
    function Prior: TMVCBrStateSteps<T>;
    function Next: TMVCBrStateSteps<T>;
    function First: TMVCBrStateSteps<T>;
    function Last: TMVCBrStateSteps<T>;
    function MoveTo(AStep: Integer): TMVCBrStateSteps<T>;
    function CurrentStep: TMVCBrStateSteps<T>;
    function SetFirstStep(AStep: Integer): TMVCBrStateSteps<T>;
    function SetLastStep(ASetp: Integer): TMVCBrStateSteps<T>;
  end;

  /// <summary>
  /// TMVCBrStates Object container for States
  /// </summary>
  TMVCBrStates<T: TMVCBrStateStep> = class(TInterfacedObject, IMVCBrStates<T>)
  type
    TStateSteps = class(TObjectList < TMVCBrStateSteps < T >> )
    end;
  private
    FOldStep: Integer;
    FFirstStep: Integer;
    FLastStep: Integer;
    FCurrentStep: Integer;
    FSteps: TStateSteps;
    procedure SaveStep;
    function isStepChanged: Boolean;
  public
    constructor create;
    destructor destroy; override;
    function Add<TImplements: IInterface>(AClass: TInterfacedClass)
      : TMVCBrStateSteps<T>;
    function EOF: Boolean;
    function BOF: Boolean;
    function Prior: TMVCBrStateSteps<T>;
    function Next: TMVCBrStateSteps<T>;
    function First: TMVCBrStateSteps<T>;
    function Last: TMVCBrStateSteps<T>;
    function CurrentStep: TMVCBrStateSteps<T>;
    function CurrenteIndex: Integer;
    function MoveTo(AStep: Integer): TMVCBrStateSteps<T>;
    function SetFirstStep(AStep: Integer): TMVCBrStateSteps<T>;
    function SetLastStep(ASetp: Integer): TMVCBrStateSteps<T>;
    procedure ExecuteDelegate; virtual;
  end;

implementation

{ TMVCBrStates<T> }

function TMVCBrStates<T>.Add<TImplements>(AClass: TInterfacedClass)
  : TMVCBrStateSteps<T>;
begin
  result := TMVCBrStateSteps<T>.create;
  result.ImplementClass(AClass);
  result.Implements<TImplements>;
  result.Prior(FSteps.count - 1);
  FSteps.Add(result);
  TThread.NameThreadForDebugging('TestNext2');

  result.Next(FSteps.count);
  FCurrentStep := FSteps.count - 1;
end;

function TMVCBrStates<T>.BOF: Boolean;
begin
  result := (FCurrentStep < 0) or (FSteps.count = 0);
end;

constructor TMVCBrStates<T>.create;
begin
  inherited create;
  FFirstStep := -1;
  FLastStep := -1;
  FCurrentStep := -1;
  FSteps := TStateSteps.create;
end;

function TMVCBrStates<T>.CurrenteIndex: Integer;
begin
  result := FCurrentStep;
end;

function TMVCBrStates<T>.CurrentStep: TMVCBrStateSteps<T>;
begin
  result := nil;
  if EOF or BOF then
    exit;
  result := FSteps.items[FCurrentStep];
end;

destructor TMVCBrStates<T>.destroy;
begin
  FSteps.free;
  inherited;
end;

function TMVCBrStates<T>.EOF: Boolean;
begin
  result := (FCurrentStep >= FSteps.count) or (FSteps.count = 0);
end;

procedure TMVCBrStates<T>.ExecuteDelegate;
begin
  if assigned(CurrentStep.FDelegate) then
    CurrentStep.execute;
end;

function TMVCBrStates<T>.First: TMVCBrStateSteps<T>;
begin
  SaveStep;
  if FFirstStep >= 0 then
    FCurrentStep := FFirstStep
  else if FSteps.count > 0 then
    FCurrentStep := 0
  else
    FCurrentStep := -1;
  result := CurrentStep;
  if isStepChanged then
    ExecuteDelegate;

end;

function TMVCBrStates<T>.isStepChanged: Boolean;
begin
  result := FOldStep <> FCurrentStep;
  if EOF or BOF then
    result := false;
end;

function TMVCBrStates<T>.Last: TMVCBrStateSteps<T>;
begin
  SaveStep;
  if FLastStep >= 0 then
    FCurrentStep := FLastStep
  else if FSteps.count > 0 then
    FCurrentStep := FSteps.count - 1
  else
    FCurrentStep := FSteps.count;
  result := CurrentStep;
  if isStepChanged then
    ExecuteDelegate;

end;

function TMVCBrStates<T>.MoveTo(AStep: Integer): TMVCBrStateSteps<T>;
begin
  SaveStep;
  FCurrentStep := AStep;
  result := CurrentStep;
  if isStepChanged then
    ExecuteDelegate;
end;

function TMVCBrStates<T>.Next: TMVCBrStateSteps<T>;
begin
  SaveStep;
  if CurrentStep.FNextStep >= 0 then
    FCurrentStep := CurrentStep.FNextStep
  else
    inc(FCurrentStep);
  if EOF then
    FCurrentStep := FSteps.count;
  result := CurrentStep;
  if isStepChanged then
    ExecuteDelegate;

end;

function TMVCBrStates<T>.Prior: TMVCBrStateSteps<T>;
begin
  SaveStep;
  if CurrentStep.FPriorStep >= 0 then
    FCurrentStep := CurrentStep.FPriorStep
  else
    dec(FCurrentStep);
  if BOF then
    FCurrentStep := -1;
  result := CurrentStep;
  if isStepChanged then
    ExecuteDelegate;
end;

procedure TMVCBrStates<T>.SaveStep;
begin
  FOldStep := FCurrentStep;
end;

function TMVCBrStates<T>.SetFirstStep(AStep: Integer): TMVCBrStateSteps<T>;
begin
  FFirstStep := AStep;
end;

function TMVCBrStates<T>.SetLastStep(ASetp: Integer): TMVCBrStateSteps<T>;
begin
  FLastStep := ASetp;
end;

{ TMVCBrStateSteps<T> }

function TMVCBrStateSteps<T>.asInstance: IInterface;
begin
  if not assigned(FInstance) then
    FInstance := FImplClass.create as IMVCBrStateStep;
  result := FInstance;
end;

function TMVCBrStateSteps<T>.Delegate(ADelegate: TDelegateSteps)
  : TMVCBrStateSteps<T>;
begin
  result := self;
  FDelegate := ADelegate;
end;

procedure TMVCBrStateSteps<T>.execute;
begin
  if assigned(FDelegate) then
    FDelegate(FInstance);
end;

function TMVCBrStateSteps<T>.ImplementClass(AClass: TInterfacedClass)
  : TMVCBrStateSteps<T>;
begin
  result := self;
  FImplClass := AClass;
end;

function TMVCBrStateSteps<T>.Implements<TImplements>: TMVCBrStateSteps<T>;
begin
  FInterface := TypeInfo(TImplements);
end;

function TMVCBrStateSteps<T>.Next(AStep: Integer): TMVCBrStateSteps<T>;
begin
  result := self;
  FNextStep := AStep;
end;

function TMVCBrStateSteps<T>.Prior(AStep: Integer): TMVCBrStateSteps<T>;
begin
  result := self;
  FPriorStep := AStep;
end;

{ TMVCBrStateStep }

procedure TMVCBrStateStep.execute;
begin

end;

function TMVCBrStateStep.This: TObject;
begin
  result := self;
end;

end.
