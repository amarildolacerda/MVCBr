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
unit MVCBr.ViewModel;

interface

uses MVCBr.Interf, MVCBr.Model, MVCBr.View, MVCBr.Controller;

type

  TViewModelFactory = class(TModelFactory, IViewModel)
  private
  protected
    FView: IView;
    FModel: IModel;
    procedure AfterConstruction;override;
  public
    constructor create; override;
    class function New(const AView: IView; const AModel: IModel)
      : IViewModel; virtual;
    procedure AfterInit; virtual;
    function Update(const AView: IView): IViewModel; overload; virtual;
    function Update(const AModel: IModel): IViewModel; overload; virtual;
    function This: TObject; virtual;
    function View(const AView: IView = nil): IViewModel; virtual;
    function Model(const AModel: IModel = nil): IViewModel; virtual;
    function Controller(const AController: IController): IViewModel;
      reintroduce; virtual;

  end;

implementation

{ TViewModelFactory }

procedure TViewModelFactory.AfterConstruction;
begin
  inherited;
  ModelTypes := [mtViewModel];

end;

procedure TViewModelFactory.AfterInit;
begin
  // disparado apos
end;

function TViewModelFactory.Controller(const AController: IController)
  : IViewModel;
begin
  result := self;
  SetController(AController);
end;

constructor TViewModelFactory.create;
begin
  inherited;
end;

function TViewModelFactory.Model(const AModel: IModel): IViewModel;
begin
  result := self;
  if not Assigned(AModel) then
    exit;
  FModel := AModel;
end;

class function TViewModelFactory.New(const AView: IView; const AModel: IModel)
  : IViewModel;
begin
  result := TViewModelFactory.create;
  result.View(AView);
  result.Model(AModel);
end;


function TViewModelFactory.This: TObject;
begin
  result := self;
end;

function TViewModelFactory.Update(const AModel: IModel): IViewModel;
begin
  result := self;
  if Assigned(FView) then
    FView.Update;
end;

function TViewModelFactory.Update(const AView: IView): IViewModel;
begin
  result := self;
  if Assigned(FModel) then
    FModel.Update;
end;

function TViewModelFactory.View(const AView: IView): IViewModel;
begin
  result := self;
  if not Assigned(AView) then
    exit;
  FView := AView;
end;

end.
