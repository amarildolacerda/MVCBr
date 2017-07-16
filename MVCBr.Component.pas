
/// Implementa interface IModel para TComponent a ser herdado em
/// Componentes que possom ser registrado para o Delphi
unit MVCBr.Component;
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

uses MVCBr.Interf, MVCBr.Model, MVCBr.ApplicationController,
  System.Classes, System.JSON,
  System.SysUtils;

type

  /// <summary>
  /// TComponentFactory Implementa IModel
  /// </Summary>
  TComponentFactory = class(TComponent, IModel)
  private
    FAdapter: IModel;
    procedure initBase;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Release;
    procedure AfterConstruction; override;
    function ApplicationControllerInternal: IApplicationController; virtual;
    function ApplicationController: TApplicationController; virtual;
    function This: TObject; virtual;
    function GetID: string; virtual;
    function ID(const AID: String): IModel;
    function Controller(const AController: IController): IModel; virtual;
    procedure SetController(const AController: IController); virtual;
    function GetModelTypes: TModelTypes; virtual;
    function GetController: IController; virtual;
    function ResolveController(const AGuidController: TGuid)
      : IController; virtual;
    procedure SetModelTypes(const AModelType: TModelTypes); virtual;
    property ModelTypes: TModelTypes read GetModelTypes write SetModelTypes;
    procedure AfterInit; virtual;
    function Update: IModel; overload; virtual;
    procedure Update(AJsonValue: TJsonValue; var AHandled: boolean);
      overload; virtual;

  end;

implementation

{ TComponentFactory }

procedure TComponentFactory.AfterConstruction;
begin
  inherited;
  initBase;
end;

procedure TComponentFactory.AfterInit;
begin
  FAdapter.AfterInit;
end;

function TComponentFactory.ApplicationController: TApplicationController;
begin
  result := TApplicationController(ApplicationControllerInternal.This);
end;

function TComponentFactory.ApplicationControllerInternal
  : IApplicationController;
begin
  result := MVCBr.ApplicationController.ApplicationController;
end;

function TComponentFactory.Controller(const AController: IController): IModel;
begin
  result := FAdapter.Controller(AController);
end;

constructor TComponentFactory.Create(AOwner: TComponent);
begin
  inherited;
  initBase;
end;

destructor TComponentFactory.Destroy;
begin

  inherited;
end;

function TComponentFactory.GetController: IController;
var
  vw: IView;
begin
  result := FAdapter.GetController;
  if not assigned(result) then
    if assigned(Owner) then
      if supports(Owner, IView, vw) then
        result := vw.GetController;

end;

function TComponentFactory.GetID: string;
begin
  result := FAdapter.GetID;
end;

function TComponentFactory.GetModelTypes: TModelTypes;
begin
  result := FAdapter.GetModelTypes;
end;

function TComponentFactory.ID(const AID: String): IModel;
begin
  result := FAdapter.ID(AID);
end;

procedure TComponentFactory.initBase;
begin
  if not assigned(FAdapter) then
  begin
    FAdapter := TModelFactory.Create;
    FAdapter.ID(Self.ClassName + '.' + Self.name);
    SetModelTypes([mtComponent]);
  end;
end;

procedure TComponentFactory.Release;
begin
  FAdapter.Release;
  FAdapter := nil;
end;

function TComponentFactory.ResolveController(const AGuidController: TGuid)
  : IController;
begin
  result := ApplicationController.ResolveController(AGuidController);
end;

procedure TComponentFactory.SetController(const AController: IController);
begin
  FAdapter.SetController(AController);
end;

procedure TComponentFactory.SetModelTypes(const AModelType: TModelTypes);
begin
  if assigned(FAdapter) then
    FAdapter.SetModelTypes(AModelType);
end;

function TComponentFactory.This: TObject;
begin
  result := Self;
end;

procedure TComponentFactory.Update(AJsonValue: TJsonValue;
  var AHandled: boolean);
begin
  Update;
end;

function TComponentFactory.Update: IModel;
begin
  result := FAdapter.Update;
end;

end.
