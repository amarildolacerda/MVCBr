
unit MVCBr.Patterns.States;
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

uses System.Classes, System.SysUtils,
  System.Generics.Collections, System.TypInfo,
  MVCBr.Interf,
  System.RTTI, System.JSON;

Type

  TMVCBrStateStep = class;
  TMVCBrStates<T: Class> = class;

  IMVCBrStateStep = interface
    ['{09707154-F172-4F76-B9A5-AECAF48A2F71}']
    function This: TObject;
    procedure Execute;
    procedure MoveTo(ACommand: TValue);
    procedure MoveNext;
    procedure MoveFirst;
    procedure MoveLast;
    procedure MovePrior;
  end;

  TDelegateSteps = TProc<IMVCBrStateStep>;

  /// <summary>
  /// TMVCBrStateStep class to be inherited
  /// </summary>
  TMVCBrStateStep = class(TInterfacedObject, IMVCBrStateStep)
  protected
    FLoopSafe: boolean;
    FExecuteDelegate: TProc;
    MasterStates: TMVCBrStates<TMVCBrStateStep>;
  public
    procedure SetMasterStates<TMasterStates>(AMasterStates
      : TMVCBrStates<TMVCBrStateStep>);
    function This: TObject; virtual;
    function DelegateTo(ADelegate: TProc): TMVCBrStateStep;
    procedure Execute; virtual;
    procedure MoveTo(ACommand: TValue);
    procedure MoveNext;
    procedure MoveFirst;
    procedure MoveLast;
    procedure MovePrior;
  end;

  TMVCBrStateStepClass = class of TMVCBrStateStep;

  /// <summary>
  /// Structure Class is data step item
  /// </summary>
  TMVCBrStateSteps<T> = class
    FPriorStep: TValue;
    FNextStep: TValue;
    FImplClass: TMVCBrStateStepClass;
    FInterface: PTypeInfo;
    FInstance: IMVCBrStateStep;
    FDelegate: TDelegateSteps;
    FExecuteDelegate: TProc;
    FCommand: TValue;
    MasterStates: TMVCBrStates<TMVCBrStateStep>;

    procedure SetMasterStates<TMasterStates>(AMasterStates
      : TMVCBrStates<TMVCBrStateStep>);

    function Prior(AStep: Integer): TMVCBrStateSteps<T>;
    function Next(AStep: Integer): TMVCBrStateSteps<T>;
    function Delegate(ADelegate: TDelegateSteps): TMVCBrStateSteps<T>; overload;
    function ImplementClass(AClass: TMVCBrStateStepClass): TMVCBrStateSteps<T>;
    function asInstance: IInterface;
    function Implements<TImplements>: TMVCBrStateSteps<T>;
    function Delegate(ADelegate: TProc): TMVCBrStateSteps<T>; overload;
    procedure Execute;
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
    function IndexOf(ACommand: TValue): Integer;
    function MoveTo(AStep: Integer): TMVCBrStateSteps<T>; overload;
    function MoveTo(ACommand: TValue): TMVCBrStateSteps<T>; overload;
    function CurrentStep: TMVCBrStateSteps<T>;
    function SetFirstStep(AStep: TValue): TMVCBrStateSteps<T>;
    function SetLastStep(ASetp: TValue): TMVCBrStateSteps<T>;
  end;

  /// <summary>
  /// TMVCBrStates Object container for States
  /// </summary>
  TMVCBrStates<T: Class> = class(TInterfacedObject, IMVCBrStates<T>)
  type
    TStateSteps = class(TObjectList < TMVCBrStateSteps < T >> )
    end;

  private
    FOldStep: Integer;
    FFirstStep: TValue;
    FLastStep: TValue;
    FCurrentStep: Integer;
    FSteps: TStateSteps;
    procedure SaveStep;
    function isStepChanged: boolean;
  public
    constructor create;
    destructor destroy; override;
    function Add<TImplements: IInterface>(AClass: TMVCBrStateStepClass)
      : TMVCBrStateSteps<T>; overload;
    function Add<TImplements: IInterface>(ACommand: TValue;
      AClass: TMVCBrStateStepClass): TMVCBrStateSteps<T>; overload;
    function EOF: boolean; virtual;
    function BOF: boolean; virtual;
    function Prior: TMVCBrStateSteps<T>; virtual;
    function Next: TMVCBrStateSteps<T>; virtual;
    function First: TMVCBrStateSteps<T>; virtual;
    function Last: TMVCBrStateSteps<T>; virtual;
    function CurrentStep: TMVCBrStateSteps<T>;
    function CurrenteIndex: Integer;
    function IsValidIndex(AIndex: Integer): boolean;
    function MoveTo(AStep: Integer): TMVCBrStateSteps<T>; overload;
    function MoveTo(ACommand: TValue): TMVCBrStateSteps<T>; overload;
    function IndexOf(ACommand: TValue): Integer; virtual;
    function SetFirstStep(AStep: TValue): TMVCBrStateSteps<T>;
    function SetLastStep(AStep: TValue): TMVCBrStateSteps<T>;
    procedure ExecuteDelegate; virtual;

  end;

implementation

uses System.RTTI.Helper;

{ TMVCBrStates<T> }

function TMVCBrStates<T>.Add<TImplements>(AClass: TMVCBrStateStepClass)
  : TMVCBrStateSteps<T>;
begin
  result := TMVCBrStateSteps<T>.create;
  result.MasterStates := TMVCBrStates<TMVCBrStateStep>(self);
  result.FCommand := FSteps.count;
  result.ImplementClass(AClass);
  result.Implements<TImplements>;
  result.Prior(FSteps.count - 1);
  FSteps.Add(result);
  TThread.NameThreadForDebugging('TestNext2');

  result.Next(FSteps.count);
  FCurrentStep := FSteps.count - 1;
end;

function TMVCBrStates<T>.Add<TImplements>(ACommand: TValue;
  AClass: TMVCBrStateStepClass): TMVCBrStateSteps<T>;
begin
  result := Add<TImplements>(AClass);
  result.FCommand := ACommand;

end;

function TMVCBrStates<T>.BOF: boolean;
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

function TMVCBrStates<T>.EOF: boolean;
begin
  result := (FCurrentStep >= FSteps.count) or (FSteps.count = 0);
end;

procedure TMVCBrStates<T>.ExecuteDelegate;
begin
  CurrentStep.Execute
end;

function TMVCBrStates<T>.First: TMVCBrStateSteps<T>;
var
  step: Integer;
begin
  SaveStep;
  step := IndexOf(FFirstStep);
  if step >= 0 then
    FCurrentStep := step
  else if FSteps.count > 0 then
    FCurrentStep := 0
  else
    FCurrentStep := -1;
  result := CurrentStep;
  if isStepChanged then
    ExecuteDelegate;

end;

function TMVCBrStates<T>.IndexOf(ACommand: TValue): Integer;
var
  i: Integer;
begin
  result := -1;
  for i := 0 to FSteps.count - 1 do
  begin
    if FSteps.items[i].FCommand.Equals(ACommand) then
    begin
      result := i;
      exit;
    end;
  end;
end;

function TMVCBrStates<T>.isStepChanged: boolean;
begin
  result := FOldStep <> FCurrentStep;
  if EOF or BOF then
    result := false;
end;

function TMVCBrStates<T>.IsValidIndex(AIndex: Integer): boolean;
begin
  result := (AIndex >= 0) and (AIndex < FSteps.count);

end;

function TMVCBrStates<T>.Last: TMVCBrStateSteps<T>;
var
  step: Integer;
begin
  SaveStep;
  step := IndexOf(FLastStep);
  if step >= 0 then
    FCurrentStep := step
  else if FSteps.count > 0 then
    FCurrentStep := FSteps.count - 1
  else
    FCurrentStep := FSteps.count;
  result := CurrentStep;
  if isStepChanged then
    ExecuteDelegate;

end;

function TMVCBrStates<T>.MoveTo(ACommand: TValue): TMVCBrStateSteps<T>;
var
  i: Integer;
begin
  SaveStep;
  result := nil;
  i := IndexOf(ACommand);
  if i >= 0 then
  begin
    FCurrentStep := i;
  end;
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
var
  step: Integer;
begin
  SaveStep;
  step := IndexOf(CurrentStep.FNextStep);
  if step >= 0 then
    FCurrentStep := step
  else
    inc(FCurrentStep);
  if EOF then
    FCurrentStep := FSteps.count;
  result := CurrentStep;
  if isStepChanged then
    ExecuteDelegate;

end;

function TMVCBrStates<T>.Prior: TMVCBrStateSteps<T>;
var
  step: Integer;
begin
  SaveStep;
  step := IndexOf(CurrentStep.FPriorStep);
  if step >= 0 then
    FCurrentStep := step
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

function TMVCBrStates<T>.SetFirstStep(AStep: TValue): TMVCBrStateSteps<T>;
var
  step: Integer;
begin
  step := IndexOf(AStep);
  if IsValidIndex(step) then
    FFirstStep := FSteps.items[step].FCommand;
end;

function TMVCBrStates<T>.SetLastStep(AStep: TValue): TMVCBrStateSteps<T>;
var
  step: Integer;
begin
  step := IndexOf(AStep);
  if IsValidIndex(step) then
    FLastStep := FSteps.items[step].FCommand;
end;

{ TMVCBrStateSteps<T> }

function TMVCBrStateSteps<T>.asInstance: IInterface;
var
  instance: TMVCBrStateStep;
begin
  if not assigned(FInstance) then
  begin
    instance := FImplClass.create;
    instance.DelegateTo(FExecuteDelegate);
    instance.MasterStates := self.MasterStates;
    FInstance := instance as IMVCBrStateStep;
  
  end;
  result := FInstance;
end;

function TMVCBrStateSteps<T>.Delegate(ADelegate: TDelegateSteps)
  : TMVCBrStateSteps<T>;
begin
  result := self;
  FDelegate := ADelegate;
end;

function TMVCBrStateSteps<T>.Delegate(ADelegate: TProc): TMVCBrStateSteps<T>;
begin
  result := self;
  FExecuteDelegate := ADelegate;
end;

procedure TMVCBrStateSteps<T>.Execute;
begin
  if not assigned(FInstance) then
    asInstance;
  if assigned(FDelegate) then
  begin
    FDelegate(FInstance);
  end;
  FInstance.Execute;
end;

procedure TMVCBrStateStep.MoveFirst;
begin
  if FLoopSafe then
    exit;
  FLoopSafe := true;
  try
    if assigned(MasterStates) then
      MasterStates.First;
  finally
    FLoopSafe := false;
  end;
end;

function TMVCBrStateSteps<T>.ImplementClass(AClass: TMVCBrStateStepClass)
  : TMVCBrStateSteps<T>;
begin
  result := self;
  FImplClass := AClass;
end;

function TMVCBrStateSteps<T>.Implements<TImplements>: TMVCBrStateSteps<T>;
begin
  FInterface := TypeInfo(TImplements);
end;

procedure TMVCBrStateStep.MoveLast;
begin
  if FLoopSafe then
    exit;
  FLoopSafe := true;
  try
    if assigned(MasterStates) then
      MasterStates.Last;
  finally
    FLoopSafe := false;
  end;
end;

procedure TMVCBrStateStep.MoveTo(ACommand: TValue);
begin
  if FLoopSafe then
    exit;
  FLoopSafe := true;
  try
    if assigned(MasterStates) then
      MasterStates.MoveTo(ACommand);
  finally
    FLoopSafe := false;
  end;
end;

procedure TMVCBrStateStep.MoveNext;
begin
  if FLoopSafe then
    exit;
  FLoopSafe := true;
  try
    if assigned(MasterStates) then
      MasterStates.Next;
  finally
    FLoopSafe := false;
  end;
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

procedure TMVCBrStateSteps<T>.SetMasterStates<TMasterStates>
  (AMasterStates: TMVCBrStates<TMVCBrStateStep>);
begin
  MasterStates := AMasterStates;
end;

procedure TMVCBrStateStep.MovePrior;
begin
  if FLoopSafe then
    exit;
  FLoopSafe := true;
  try
    if assigned(MasterStates) then
      MasterStates.Prior;
  finally
    FLoopSafe := false;
  end;
end;

{ TMVCBrStateStep }

function TMVCBrStateStep.DelegateTo(ADelegate: TProc): TMVCBrStateStep;
begin
  result := self;
  FExecuteDelegate := ADelegate;
end;

procedure TMVCBrStateStep.Execute;
begin
  if assigned(FExecuteDelegate) then
    FExecuteDelegate;
end;

procedure TMVCBrStateStep.SetMasterStates<TMasterStates>(AMasterStates
  : TMVCBrStates<TMVCBrStateStep>);
begin
  MasterStates := AMasterStates;
end;

function TMVCBrStateStep.This: TObject;
begin
  result := self;
end;

end.
