unit MVCBr.MiddlewareFactory;
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
  MVCBr.Patterns.Mediator,
  System.Generics.Collections;

type

  TMVCBrMiddlewareType = (middView, middController, middFrame, middReport);

  IMVCBrMiddleware = interface
    ['{2A015FEE-754D-41AE-A4C9-64398FEBBAAD}']
    procedure SetMiddType(const Value: TMVCBrMiddlewareType);
    procedure SetonAfterEvent(const Value: TProc<TObject>);
    procedure SetOnBeforeEvent(const Value: TProc<TObject>);
  end;

  TMVCBrMiddleware = class(TMVCBrParticipant, IMVCBrMiddleware)
  private
    FOnBeforeEvent: TProc<TObject>;
    FonAfterEvent: TProc<TObject>;
    FMiddType: TMVCBrMiddlewareType;
    procedure SetMiddType(const Value: TMVCBrMiddlewareType);
    procedure SetonAfterEvent(const Value: TProc<TObject>);
    procedure SetOnBeforeEvent(const Value: TProc<TObject>);
  public
    property MiddType: TMVCBrMiddlewareType read FMiddType write SetMiddType;
    property OnBeforeEvent: TProc<TObject> read FOnBeforeEvent
      write SetOnBeforeEvent;
    property onAfterEvent: TProc<TObject> read FonAfterEvent
      write SetonAfterEvent;
  end;

  IMiddlewareFactory<T> = interface(TFunc<T>)
    ['{AAE48E03-E56D-4561-BE21-A2534F4C61D0}']
  end;

  TMVCBrMiddlewareFactory = class(TInterfacedObject,
    IMiddlewareFactory < TMVCBrMediator < TMVCBrMiddleware >> )
  private
    Class Var FMiddleware: TMVCBrMediator<TMVCBrMiddleware>;
    function Invoke: TMVCBrMediator<TMVCBrMiddleware>;
  public
    Destructor Destroy; override;
    procedure Release;
    Class function Default: TMVCBrMediator<TMVCBrMiddleware>;
    Class function Add(AInstance: TMVCBrMiddleware): string;
    Class procedure SendBeforeEvent(AType: TMVCBrMiddlewareType;
      ASender: TObject);
    Class procedure SendAfterEvent(AType: TMVCBrMiddlewareType;
      ASender: TObject);
  end;

Function MVCBrRegisterMiddleware(AType: TMVCBrMiddlewareType;
  AInstance: TMVCBrMiddleware): string;

{
  [Depredicated]
  [Obsoleted]
  Function RegisterViewMiddleware(AInstance: TMVCBrMiddleware): string;
}
implementation

var
  LMiddlewareFactory: TMVCBrMiddlewareFactory;

  {
    Function RegisterViewMiddleware(AInstance: TMVCBrMiddleware): string;
    begin
    result := MVCBrRegisterMiddleware(middView, AInstance);
    end;
  }
Function MVCBrRegisterMiddleware(AType: TMVCBrMiddlewareType;
  AInstance: TMVCBrMiddleware): string;
begin
  AInstance.MiddType := AType;
  result := TMVCBrMiddlewareFactory.Add(AInstance);
end;

{ TMVCBrMiddlewareFactory }

{ TMVCBrMiddlewareFactory<T> }

class function TMVCBrMiddlewareFactory.Add(AInstance: TMVCBrMiddleware): string;
begin
  LMiddlewareFactory.Invoke.Add(AInstance);
  result := AInstance.ID.AsString
end;

class function TMVCBrMiddlewareFactory.Default
  : TMVCBrMediator<TMVCBrMiddleware>;
begin
  result := LMiddlewareFactory.Invoke;
end;

destructor TMVCBrMiddlewareFactory.Destroy;
begin
  Release;
  inherited;
end;

var FReleased: Boolean;

function TMVCBrMiddlewareFactory.Invoke: TMVCBrMediator<TMVCBrMiddleware>;
begin
  if not assigned(FMiddleware) then
  begin
    FMiddleware := TMVCBrMediator<TMVCBrMiddleware>.create(TMVCBrMiddleware);
    FReleased := false;
  end else
    FReleased := true;
  result := FMiddleware;
end;

procedure TMVCBrMiddlewareFactory.Release;
begin
  if assigned(FMiddleware) then
    FMiddleware.DisposeOf;
  FMiddleware := nil;
  FReleased := true;
end;

class procedure TMVCBrMiddlewareFactory.SendAfterEvent
  (AType: TMVCBrMiddlewareType; ASender: TObject);
begin
  if not FReleased then
    LMiddlewareFactory.Invoke.ForEach(
      function(APart: TMVCBrMiddleware): Boolean
      begin
        if (APart.MiddType = AType) and assigned(APart.onAfterEvent) then
          APart.onAfterEvent(ASender);
      end);
end;

class procedure TMVCBrMiddlewareFactory.SendBeforeEvent
  (AType: TMVCBrMiddlewareType; ASender: TObject);
begin
  if not FReleased then
    LMiddlewareFactory.Invoke.ForEach(
      function(APart: TMVCBrMiddleware): Boolean
      begin
        if (APart.MiddType = AType) and assigned(APart.OnBeforeEvent) then
          APart.OnBeforeEvent(ASender);
      end);
end;

{ TMVCBrMiddleware }

procedure TMVCBrMiddleware.SetMiddType(const Value: TMVCBrMiddlewareType);
begin
  FMiddType := Value;
end;

procedure TMVCBrMiddleware.SetonAfterEvent(const Value: TProc<TObject>);
begin
  FonAfterEvent := Value;
end;

procedure TMVCBrMiddleware.SetOnBeforeEvent(const Value: TProc<TObject>);
begin
  FOnBeforeEvent := Value;
end;

initialization

LMiddlewareFactory := TMVCBrMiddlewareFactory.create;

finalization

LMiddlewareFactory.free;

end.
