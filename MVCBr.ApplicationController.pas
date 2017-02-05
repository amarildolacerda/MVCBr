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
unit MVCBr.ApplicationController;

interface

uses Forms, System.Classes,
  System.Generics.Collections,

  System.SysUtils, MVCBr.Model, MVCBr.Interf;

type

  TApplicationController = class(TMVCInterfacedObject, IApplicationController)
  private
    FControllers: TMVCInterfacedList<IController>;
  protected
    FMainView: IView;
  public
    constructor create;
    destructor destroy; override;
    function This: TObject;
    function Count: integer;
    function Add(const AController: IController): integer;
    procedure Delete(const idx: integer);
    procedure Remove(const AController: IController);
    procedure Run(AClass: TComponentClass; AController: IController;
      AModel: IModel; AFunc: TFunc < boolean >= nil); overload;
    procedure Run(AController: IController;
      AFunc: TFunc < boolean >= nil); overload;
    class function New: IApplicationController;
    procedure ForEach(AProc: TProc<IController>);
    procedure UpdateAll;
    procedure Update(const AIID: TGuid);
  end;

function ApplicationController: IApplicationController;
procedure SetApplicationController(AController: IApplicationController);

implementation

var
  FApplication: IApplicationController;

function ApplicationController(): IApplicationController;
begin
  if not assigned(FApplication) then
    FApplication := TApplicationController.New;
  result := FApplication;
end;

procedure SetApplicationController(AController: IApplicationController);
begin
  FApplication := nil; // limpa a instancia carregada;
  FApplication := AController;
end;

{ TApplicationController }

function TApplicationController.Add(const AController: IController): integer;
begin
  result := -1;
  if assigned(AController) then
  begin
    FControllers.Add(AController);
    result := FControllers.Count - 1;
  end;
end;

function TApplicationController.Count: integer;
begin
  result := FControllers.Count;
end;

constructor TApplicationController.create;
begin
  inherited create;
  FControllers := TMVCInterfacedList<IController>.create;
end;

procedure TApplicationController.Delete(const idx: integer);
begin
  FControllers.Delete(idx);
end;

destructor TApplicationController.destroy;
begin
  if assigned(FControllers) then
  begin
    try
      FControllers.clear;
      FControllers.DisposeOf;
    except
    end;
    FControllers := nil;
  end;
  inherited;
end;

procedure TApplicationController.ForEach(AProc: TProc<IController>);
var
  i: integer;
begin
  if assigned(AProc) then
    for i := 0 to FControllers.Count - 1 do
      AProc(FControllers.Items[i] as IController);
end;

class function TApplicationController.New: IApplicationController;
begin
  result := TApplicationController.create;
end;

procedure TApplicationController.Remove(const AController: IController);
begin
  FControllers.Remove(AController);
end;

procedure TApplicationController.Run(AController: IController;
  AFunc: TFunc<boolean>);
begin
  Run(nil, AController, nil, AFunc);
end;

function TApplicationController.This: TObject;
begin
  result := self;
end;

procedure TApplicationController.Update(const AIID: TGuid);
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    if supports(FControllers.Items[i], AIID) then
      (FControllers.Items[i] as IController).UpdateAll;
end;

procedure TApplicationController.UpdateAll;
var
  i: integer;
begin
  for i := 0 to FControllers.Count - 1 do
    (FControllers.Items[i] as IController).UpdateAll;
end;

procedure TApplicationController.Run(AClass: TComponentClass;
  AController: IController; AModel: IModel; AFunc: TFunc<boolean>);
var
  rt: boolean;
  reference: TComponent;
  Controller: TObject;
  LContrInterf: IController;
begin
  application.Initialize;

  rt := true;
  if assigned(AFunc) then
    rt := AFunc;

  if rt then
  begin
    if assigned(AController) then
      AController.init;
    if (AClass <> nil) and (application.MainForm = nil) then
    begin
      application.CreateForm(AClass, reference);
      if not supports(reference, IView) then
        raise Exception.create('Não é uma classe que implementa IView');
      FMainView := reference as IView;
    end;

    if assigned(AModel) then
      if AController.IndexOf(AModel) < 0 then
        AController.Add(AModel);

    if supports(application.MainForm, IView, FMainView) then
    begin
      if assigned(AController) then
        AController.View(FMainView);
      FMainView.ShowView(nil);
    end;

  end;
  if assigned(AController) then
    AController.AfterInit;

end;

end.
