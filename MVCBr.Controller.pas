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
unit MVCBr.Controller;

interface

uses MVCBr.Interf, MVCBr.Model, MVCBr.View,
  System.Generics.Collections,
  System.TypInfo,
{$IFDEF FMX} FMX.Layouts, {$ENDIF}
  System.Classes, System.SysUtils,
  MVCBr.ApplicationController,
  System.RTTI;

type

  // TControllerFactory Classe Factory para  IController
  TControllerFactory = class(TControllerAbstract, IController,
    IControllerAs<TControllerFactory>)
  private
    FLoaded: boolean;
    FRefModelCount: integer;
    FRefViewCount: integer;
  protected
    FView: IView;
    FID: string;
    procedure Load; virtual;
    procedure SetID(const AID: string);
    procedure AfterConstruction; override;

  public

    constructor Create; override;
    destructor destroy; override;
{$IFDEF FMX}
    procedure Embedded(AControl: TLayout); virtual;
{$ENDIF}
    function IsView(AII: TGuid): boolean;
    function IsController(AGuid: TGuid): boolean;
    function IsModel(AIModel: TGuid): boolean;
    function ApplicationController: TApplicationController;
    function GetGuid<TInterface: IInterface>: TGuid;
    function ShowView: IView; overload;virtual;
    function ShowView(const AProcBeforeShow: TProc<IView>;
      const AProcOnClose: TProc<IView>): IView;
      overload; virtual;

    function ViewEvent(AMessage: String; var AHandled: boolean): IView;
      overload; virtual;
    function ViewEvent<TViewInterface>(AMessage: string; var AHandled: boolean)
      : IView; overload;
    function ID(const AID: string): IController; virtual;
    function GetID: String; virtual;
    function GetModelByID(const AID: String): IModel; virtual;
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); virtual;
    function GetModel(const idx: integer): IModel; overload; virtual;

    function GetModelByType(const AModelType: TModelType): IModel; virtual;
    procedure Init; virtual;
    function Start: IController; virtual;
    procedure BeforeInit; virtual;
    procedure AfterInit; virtual;
    function GetView: IView; virtual;
    function View(const AView: IView): IController; virtual;
    function This: TControllerAbstract; virtual;
    Function ControllerAs: TControllerFactory; virtual;
    function Add(const AModel: IModel): integer; virtual;
    function IndexOf(const AModel: IModel): integer; virtual;
    function IndexOfModelType(const AModelType: TModelType): integer; virtual;
    procedure Delete(const Index: integer); virtual;
    function Count: integer; virtual;
    procedure ForEach(AProc: TProc<IModel>); virtual;
    function UpdateAll: IController; virtual;
    function UpdateByModel(AModel: IModel): IController; virtual;
    function UpdateByView(AView: IView): IController; virtual;

  end;

  TControllerFactoryOf = class of TControllerFactory;

implementation

{ TController }

{$IFDEF FMX}

procedure TControllerFactory.Embedded(AControl: TLayout);
var
  child: ILayOut;
begin
  if supports(GetView.This, ILayOut, child) then
  begin
    with TLayout(child.GetLayout) do
    begin
      Parent := AControl;
    end;

  end;
end;
{$ENDIF}

function TControllerFactory.Add(const AModel: IModel): integer;
var
  vm: IViewModel;
  v: IView;
begin
  result := -1;
  if not assigned(AModel) then
    exit;
  AModel.Controller(self);
  FModels.Add(AModel);
  result := FModels.Count - 1;

  if mtViewModel in AModel.ModelTypes then
  begin
    if supports(AModel.This, IViewModel, vm) then
    begin
      v := GetView;
      if assigned(v) then
      begin
        vm.View(v);
        v.SetViewModel(vm);
      end;
    end;
  end;

end;

procedure TControllerFactory.BeforeInit;
begin

end;

function TControllerFactory.ControllerAs: TControllerFactory;
begin
  result := self;
end;

function TControllerFactory.Count: integer;
begin
  result := FModels.Count;
end;

constructor TControllerFactory.Create;
begin
  inherited Create;
  Load;
end;

procedure TControllerFactory.Delete(const Index: integer);
begin
  FModels.Delete(Index);
end;

destructor TControllerFactory.destroy;
var ac:TApplicationController;
begin
  if assigned(FModels) then
  begin
    try
      FModels.Clear;
    except
    end;
    FModels := nil;
  end;
  FView := nil;
  ac := ApplicationController;
  if assigned(ac) then ac.remove(self);
  inherited;
end;

procedure TControllerFactory.DoCommand(ACommand: string;
  const AArgs: array of TValue);
begin

end;

procedure TControllerFactory.ForEach(AProc: TProc<IModel>);
var
  i: integer;
begin
  if assigned(AProc) then
    for i := 0 to FModels.Count - 1 do
      AProc(FModels.Items[i] as IModel);
end;

function TControllerFactory.GetGuid<TInterface>: TGuid;
begin
  result := TMVCBr.GetGuid<TInterface>;
end;

function TControllerFactory.GetID: String;
begin
  result := FID;
end;

function TControllerFactory.GetModel(const idx: integer): IModel;
begin
  result := FModels[idx] as IModel;
end;

function TControllerFactory.GetModelByID(const AID: String): IModel;
var
  i: integer;
begin
  result := nil;
  for i := 0 to FModels.Count - 1 do
    if sameText(AID, (FModels.Items[i] as IModel).GetID) then
    begin
      result := FModels.Items[i] as IModel;
      exit;
    end;
end;

function TControllerFactory.GetModelByType(const AModelType
  : TModelType): IModel;
var
  i: integer;
begin
  result := nil;
  i := IndexOfModelType(AModelType);
  if i >= 0 then
    result := FModels.Items[i] as IModel;
end;

function TControllerFactory.ID(const AID: string): IController;
begin
  result := self;
  SetID(AID);
end;

function TControllerFactory.IndexOf(const AModel: IModel): integer;
begin
  result := FModels.IndexOf(AModel);
end;

function TControllerFactory.IndexOfModelType(const AModelType
  : TModelType): integer;
var
  i: integer;
  FModel: IModel;
begin
  result := -1;
  for i := 0 to FModels.Count - 1 do
  begin
    FModel := FModels.Items[i] as IModel;
    if AModelType in FModel.ModelTypes then
    begin
      result := i;
      exit;
    end;
  end;
end;

procedure TControllerFactory.Init;
begin
  if assigned(FView) then
    FView.SetController(self);
  BeforeInit;
end;

function TControllerFactory.IsController(AGuid: TGuid): boolean;
begin
  result := supports(self, AGuid);
end;

function TControllerFactory.IsModel(AIModel: TGuid): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to FModels.Count - 1 do
    if supports((FModels.Items[i] as IModel).This, AIModel) then
    begin
      result := true;
      exit;
    end;
end;

function TControllerFactory.IsView(AII: TGuid): boolean;
begin
  result := false;
  if assigned(FView) then
    result := supports(FView.This, AII);
end;

procedure TControllerFactory.Load;
begin
  if not assigned(FModels) then
    FModels := TMVCInterfacedList<IModel>.Create;
  if (not FLoaded) then
  begin
    ApplicationController.Add(self);
    ID(self.ClassName);
    FLoaded := true;
    FRefModelCount := 0;
  end;
end;

function TControllerFactory.ViewEvent(AMessage: String;
  var AHandled: boolean): IView;
begin
  result := FView;
  FView.ViewEvent(AMessage, AHandled);
end;

function TControllerFactory.ViewEvent<TViewInterface>(AMessage: string;
  var AHandled: boolean): IView;
var
  i: integer;
  pInfo: PTypeInfo;
  IID: TGuid;
  AView: IView;
begin
  result := nil;
  if FRefViewCount > 0 then
    exit; // LOOP !!
  inc(FRefViewCount);
  try
    pInfo := TypeInfo(TViewInterface);
    IID := GetTypeData(pInfo).Guid;
    if supports(GetView.This, IID, AView) then
    begin
      result := AView;
      AView.ViewEvent(AMessage, AHandled);
      exit;
    end;
    result := ApplicationController.ViewEvent(IID, AMessage, AHandled);
  finally
    dec(FRefViewCount);
  end;
end;

procedure TControllerFactory.SetID(const AID: string);
begin
  FID := AID;
end;

function TControllerFactory.ShowView(const AProcBeforeShow,
  AProcOnClose: TProc<IView>): IView;
begin
    result := FView;
    if assigned(result) then
       result.ShowView(AProcBeforeShow,AProcOnClose);
end;

function TControllerFactory.ShowView: IView;
begin
  result := FView;
  if assigned(FView) then
    FView.ShowView();
end;

function TControllerFactory.Start: IController;
begin
  result := self;
  Init;
end;

procedure TControllerFactory.AfterConstruction;
begin
  inherited;
  FRefViewCount := 0;
  Load;
end;

procedure TControllerFactory.AfterInit;
var
  FModel: IModel;
  vm: IViewModel;
begin
  FModel := GetModelByType(mtViewModel);
  if assigned(FModel) then
    if supports(FModel.This, IViewModel, vm) then
    begin
      vm.View(FView).Controller(self);
    end;

  ForEach(
    procedure(AModel: IModel)
    begin
      AModel.AfterInit;
    end);

end;

function TControllerFactory.ApplicationController: TApplicationController;
var
  ac: IApplicationController;
begin
  result := nil;
  ac := ApplicationControllerInternal;
  if assigned(ac) then
    result := TApplicationController(ac.This);
end;

function TControllerFactory.This: TControllerAbstract;
begin
  result := self;
end;

function TControllerFactory.UpdateAll: IController;
var
  i: integer;
begin
  result := self;
  if FRefModelCount = 0 then
  begin
    inc(FRefModelCount); // previne para nao entrar em LOOP
    try
      for i := 0 to FModels.Count - 1 do
        (FModels.Items[i] as IModel).Update;
      if assigned(FView) then
        FView.Update;
    finally
      dec(FRefModelCount);
    end;
  end;
end;

function TControllerFactory.UpdateByModel(AModel: IModel): IController;
begin
  result := self;
  if FRefModelCount = 0 then
  begin
    inc(FRefModelCount); // previne para nao entrar em LOOP
    try
      FView.Update;
    finally
      dec(FRefModelCount);
    end;
  end;
end;

function TControllerFactory.UpdateByView(AView: IView): IController;
var
  i: integer;
begin
  result := self;
  if FRefModelCount = 0 then
  begin
    inc(FRefModelCount); // previne para nao entrar em LOOP
    try
      for i := 0 to FModels.Count - 1 do
        (FModels.Items[i] as IModel).Update;
    finally
      dec(FRefModelCount);
    end;
  end;
end;

function TControllerFactory.View(const AView: IView): IController;
var
  vm: IViewModel;
begin
  result := self;
  FView := AView;
  if assigned(FView) then
  begin
    FView.Controller(result);
    vm := GetModelByType(mtViewModel) as IViewModel;
    if assigned(vm) then
    begin
      vm.View(FView);
      FView.SetViewModel(vm);
    end;
  end;
end;

function TControllerFactory.GetView: IView;
begin
  result := FView;
end;

end.
