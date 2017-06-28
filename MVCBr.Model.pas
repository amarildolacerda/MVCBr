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
unit MVCBr.Model;

interface

Uses System.Classes, System.SysUtils,
  System.Generics.collections, System.Json, MVCBr.Interf;

type

  TModelFactory = class;

  TModelFactoryClass = class of TModelFactory;

  TModelFactory = class(TModelFactoryAbstract, IModel)
  private
    FID: string;
    FModelTypes: TModelTypes;
    FController: IController;
  protected
    function GetModelTypes: TModelTypes; virtual;
    procedure SetModelTypes(const AModelTypes: TModelTypes); virtual;
    procedure SetID(const AID: string); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Release;override;
    procedure AfterConstruction; override;
    procedure AfterInit; virtual;
    property ModelTypes: TModelTypes read GetModelTypes write SetModelTypes;
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

function TModelFactory.GetModelTypes: TModelTypes;
begin
  result := FModelTypes;
end;

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

procedure TModelFactory.SetModelTypes(const AModelTypes: TModelTypes);
begin
  FModelTypes := AModelTypes;
end;

procedure TModelFactory.AfterConstruction;
begin
  inherited;
  FModelTypes := [mtCommon];
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

function TModelFactory.Update: IModel;
begin
  result := self;
end;

end.
