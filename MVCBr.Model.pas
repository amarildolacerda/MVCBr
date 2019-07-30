unit MVCBr.Model;
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

Uses System.Classes, System.SysUtils,
  System.Generics.collections, System.Json, MVCBr.Interf;

type

  TModelFactory = class;

  TModelFactoryClass = class of TModelFactory;

  /// <summary>
  /// Model Factory
  /// </summary>
  TModelFactory = class(TModelFactoryAbstract, IModel)
  private
    FID: string;
{$IFNDEF BPL}
    [Hide]
    FModelTypes: TModelTypes;
{$ENDIF}
    [Hide]
    FController: IController;
  protected
{$IFNDEF BPL}
    function GetModelTypes: TModelTypes; virtual;
    procedure SetModelTypes(const AModelTypes: TModelTypes); virtual;
{$ENDIF}
    procedure SetID(const AID: string); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Release; override;
    procedure AfterConstruction; override;
    procedure AfterInit; virtual;
{$IFNDEF BPL}
    [Hide]
    property ModelTypes: TModelTypes read GetModelTypes write SetModelTypes;
{$ENDIF}
    procedure SetController(const AController: IController); virtual;
    function GetController: IController;
    function Controller(const AController: IController): IModel;
      overload; virtual;
    function This: TObject; virtual;
    function GetID: string; override;
    function ID(const AID: String): IModel; virtual;
    function Update: IModel; overload; virtual;
    procedure Update(AJsonValue: TJsonValue; var AHandled: boolean);
      overload; override;
    procedure ViewEvent(AMessage: string; var AHandled: boolean);
      overload; virtual;
    procedure ViewEvent(AMessage: String); overload; virtual;
    procedure ViewEvent(AMessage: String; ASubject: string); overload; virtual;
  end;

  /// <summary>
  /// Lazy Adapter for Models
  /// </summary>
  TModelAdapterFactory<T: Class> = class(TModelFactory, IModel,
    IModelAdapter<T>)
  private
    FCreated: boolean;
    FInstanceClass: TClass;
    FInstance: T;
    function GetInstance: T; virtual;
    constructor CreateInternal; overload; virtual;
  public
    constructor Create; overload;
    class function New(AController: IController)
      : TModelAdapterFactory<T>; static;
    destructor Destroy; override;
    procedure Release; override;
    property Instance: T read GetInstance;
    procedure FreeInstance; virtual;
    function IsCreated: boolean; virtual;
  end;

implementation

{ TModelClass }

constructor TModelFactory.Create;
begin
  inherited Create;
  FRefCount := 1;
end;

destructor TModelFactory.Destroy;
begin
  FController := nil;
  inherited;
end;

function TModelFactory.GetController: IController;
begin
  result := FController;
end;

function TModelFactory.GetID: string;
begin
  result := FID;
end;

{$IFNDEF BPL}

function TModelFactory.GetModelTypes: TModelTypes;
begin
  result := FModelTypes;
end;
{$ENDIF}

function TModelFactory.ID(const AID: String): IModel;
begin
  result := self;
  SetID(AID);
end;

procedure TModelFactory.Release;
begin
  FController := nil;
  inherited;
end;

procedure TModelFactory.SetController(const AController: IController);
begin
  FController := AController;
end;

procedure TModelFactory.SetID(const AID: string);
begin
  FID := AID;
end;

{$IFNDEF BPL}

procedure TModelFactory.SetModelTypes(const AModelTypes: TModelTypes);
begin
  FModelTypes := AModelTypes;
end;
{$ENDIF}

procedure TModelFactory.AfterConstruction;
begin
  inherited;
{$IFNDEF BPL}
  FModelTypes := [mtCommon];
{$ENDIF}
  SetID(self.classname);
end;

procedure TModelFactory.AfterInit;
begin
  // chamado apos a conclusao do controller
end;

function TModelFactory.Controller(const AController: IController): IModel;
begin
  result := self;
  SetController(AController);
end;

function TModelFactory.This: TObject;
begin
  result := self;
end;

procedure TModelFactory.Update(AJsonValue: TJsonValue; var AHandled: boolean);
begin
  Update;
end;

procedure TModelFactory.ViewEvent(AMessage, ASubject: string);
var
  AController: IController;
  AView: IView;
  js: TJsonObject;
  AHandled: boolean;
begin
  AController := GetController;
  if assigned(AController) then
  begin
    AView := AController.GetView;
    if assigned(AView) then
    begin
      js := TJsonObject.Create;
      try
        js.addPair('message', AMessage);
        js.addPair('subject', ASubject);
        AView.ViewEvent(js, AHandled);
      finally
        js.free;
      end;
    end;
  end;
end;

procedure TModelFactory.ViewEvent(AMessage: String);
var
  AHandled: boolean;
begin
  ViewEvent(AMessage, AHandled);
end;

procedure TModelFactory.ViewEvent(AMessage: string; var AHandled: boolean);
var
  AController: IController;
  AView: IView;
begin
  AController := GetController;
  if assigned(AController) then
  begin
    AView := AController.GetView;
    if assigned(AView) then
    begin
      AView.ViewEvent(AMessage, AHandled);
    end;
  end;
end;

function TModelFactory.Update: IModel;
begin
  result := self;
end;

{ TModuleAdapterFactory }

constructor TModelAdapterFactory<T>.Create;
begin
  raise Exception.Create('Abstract... Use Class Function NEW');
end;

constructor TModelAdapterFactory<T>.CreateInternal;
begin
  inherited Create;
  FInstanceClass := TComponentClass(T);
  FInstance := nil;
end;

destructor TModelAdapterFactory<T>.Destroy;
begin
  FreeAndNil(FInstance);
  inherited;
end;

procedure TModelAdapterFactory<T>.FreeInstance;
begin
  FreeAndNil(FInstance);
  FCreated := false;
end;

function TModelAdapterFactory<T>.GetInstance: T;
begin
  if not FCreated then
  begin
    FInstance := TMVCBr.InvokeCreate<T>([nil]);
    FCreated := true;
  end;
  result := FInstance;
end;

function TModelAdapterFactory<T>.IsCreated: boolean;
begin
  result := FCreated;
end;

class function TModelAdapterFactory<T>.New(AController: IController)
  : TModelAdapterFactory<T>;
begin
  result := TModelAdapterFactory<T>.CreateInternal();
  result.SetController(AController);
end;

procedure TModelAdapterFactory<T>.Release;
begin
  FreeAndNil(FInstance);
  inherited;
end;

end.
