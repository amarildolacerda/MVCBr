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

uses
  MVCBr.Interf,
  MVCBr.Model,
  MVCBr.View,
{$IFDEF LINUX} {$ELSE}
{$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Generics.Collections, System.JSON,
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
    FControllerInited: Boolean;
    FLoaded: Boolean;
    FRefModelCount: integer;
    FRefViewCount: integer;
  protected
    FView: IView;
    FID: string;
    FReleased: Boolean;
    procedure Load; virtual;
    procedure SetID(const AID: string); override;
  public
    procedure AfterConstruction; override;
  public

    constructor Create; override;
    destructor Destroy; override;
    procedure CreateModule(AClass: TComponentClass; var AModule);
    procedure Release; override;
    [weak] function Default: IController; overload;
{$IFDEF FMX}
    procedure Embedded(AControl: TLayout); virtual;
{$ENDIF}
    function IsView(AII: TGuid): Boolean;
    function IsController(AGuid: TGuid): Boolean;
    function IsModel(AIModel: TGuid): Boolean;
    function ApplicationController: TApplicationController;
    function GetGuid<TInterface: IInterface>: TGuid;
    function ShowView: IView; overload; virtual;
    function ShowView(const AProcBeforeShow: TProc<IView>;
      const AProcOnClose: TProc<IView>): IView; overload; virtual;

    function ViewEvent(AMessage: String; var AHandled: Boolean): IView;
      overload; virtual;
    function ViewEvent<TViewInterface>(AMessage: string; var AHandled: Boolean)
      : IView; overload;
    function ID(const AID: string): IController; virtual;
    function GetID: String; override;
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
    procedure SetView(AView: IView); virtual;
    function View(const AView: IView): IController; virtual;
    function This: TControllerAbstract; virtual;
    Function ControllerAs: TControllerFactory; virtual;
    function Add(const AModel: IModel): integer; virtual;
    function AttachModel(const AModel: IModel): integer; override;
    function IndexOf(const AModel: IModel): integer; virtual;
    function IndexOfModelType(const AModelType: TModelType): integer; virtual;
    procedure Delete(const Index: integer); virtual;
    function Count: integer; virtual;
    procedure ForEach(AProc: TProc<IModel>); virtual;
    function UpdateAll: IController; virtual;
    procedure Update(AJsonValue: TJsonValue; var AHandled: Boolean);
      overload; override;
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
  child := nil;
end;
{$ENDIF}

function TControllerFactory.Add(const AModel: IModel): integer;
begin
  result := AttachModel(AModel);
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
  with FModels.LockList do
    try
      result := Count;
    finally
      FModels.UnlockList;
    end;
end;

constructor TControllerFactory.Create;
begin
  inherited Create;
  FViewOwnedFree := false;
  SetUnsafe(self);
  TMVCBr.AttachInstance(self.Default as IController);
  FReleased := false;
  FControllerInited := false;
  Load;
end;

function TControllerFactory.Default: IController;
begin
  result := inherited Default as IController;
end;

procedure TControllerFactory.Delete(const Index: integer);
begin
  with FModels.LockList do
    try
      Delete(Index);
    finally
      FModels.UnlockList;
    end;
end;

destructor TControllerFactory.Destroy;
var
  ac: TApplicationController;
  i: integer;
begin
  Release;
  if assigned(FView) then
  begin
    FView.Release;
    FView := nil;
  end;
  ac := ApplicationController;
  // self.DisabledRefCount := false;
  if assigned(ac) then
    ac.remove(self);
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
    with FModels.LockList do
      try
        for i := 0 to Count - 1 do
          AProc(items[i] as IModel);
      finally
        FModels.UnlockList;
      end;
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
  try
    result := FModels.LockList[idx] as IModel;
  finally
    FModels.UnlockList;
  end;
end;

function TControllerFactory.GetModelByID(const AID: String): IModel;
var
  i: integer;
begin
  result := nil;
  with FModels.LockList do
    try
      for i := 0 to Count - 1 do
        if sameText(AID, items[i].GetID) then
        begin
          result := items[i];
          exit;
        end;
    finally
      FModels.UnlockList;
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
    with FModels.LockList do
      try
        result := items[i] as IModel;
      finally
        FModels.UnlockList;
      end;
end;

function TControllerFactory.ID(const AID: string): IController;
begin
  result := self;
  SetID(AID);
end;

function TControllerFactory.IndexOf(const AModel: IModel): integer;
var
  i: integer;
begin
  result := -1;
  with FModels.LockList do
    try
      for i := 0 to Count - 1 do
        if TMVCBr.Equals(AModel, items[i]) then
        begin
          result := i;
          exit;
        end;
    finally
      FModels.UnlockList;
    end;
end;

function TControllerFactory.IndexOfModelType(const AModelType
  : TModelType): integer;
var
  i: integer;
  FModel: IModel;
begin
  result := -1;
  if assigned(FModels) then
    with FModels.LockList do
      try
        for i := 0 to Count - 1 do
        begin
          FModel := items[i] as IModel;
          if AModelType in FModel.ModelTypes then
          begin
            result := i;
            exit;
          end;
        end;
      finally
        FModels.UnlockList;
      end;
end;

procedure TControllerFactory.Init;
begin
  if not FControllerInited then
  begin
    if assigned(FView) then
      FView.setController(self);
    BeforeInit;
  end;
end;

function TControllerFactory.IsController(AGuid: TGuid): Boolean;
begin
  result := supports(self, AGuid);
end;

function TControllerFactory.IsModel(AIModel: TGuid): Boolean;
var
  i: integer;
begin
  result := false;
  with FModels.LockList do
    try
      for i := 0 to Count - 1 do
        if supports((items[i] as IModel).This, AIModel) then
        begin
          result := true;
          exit;
        end;
    finally
      FModels.UnlockList;
    end;
end;

function TControllerFactory.IsView(AII: TGuid): Boolean;
begin
  result := false;
  if assigned(FView) then
    result := supports(FView.This, AII);
end;

procedure TControllerFactory.Load;
begin
  DefaultModels;
  if (not FLoaded) then
  begin
    ApplicationController.Add(self);
    ID(self.ClassName);
    FLoaded := true;
    FRefModelCount := 0;
  end;
end;

procedure TControllerFactory.CreateModule(AClass: TComponentClass; var AModule);
var
  LModel: IModel;
  Instance: TComponent;
begin
  Instance := nil;
{$IF DEFINED(CLR)}
  Instance := AClass.Create(self);
{$ELSE}
  Instance := TComponent(AClass.NewInstance);
  try
    Instance.Create(nil);
  except
    Instance := nil;
    raise;
  end;
{$ENDIF}
  if supports(Instance, IModel, LModel) then
  begin
    TObject(AModule) := Instance;
    LModel.setController(self);
    self.Add(LModel);
  end
  else
    Instance.free;
end;

procedure TControllerFactory.Release;
var
  obj: TObject;
begin
  if not FReleased then
  begin
    FReleased := true;
    if assigned(FView) then
    begin
      FView.Release;
      try
        if not FViewOwnedFree then
          if assigned(FView) then
          begin
            if not TMVCBr.IsMainForm(FView.This) then
            begin
              obj := FView.This;
              FView := nil; // tenta encerrar o formulario
              obj.DisposeOf;
            end;
          end;
      except
      end;
    end;
    FView := nil;
    inherited;
  end
  else
  begin
    // FView := nil;
  end;
end;

function TControllerFactory.ViewEvent(AMessage: String;
  var AHandled: Boolean): IView;
begin
  result := FView;
  FView.ViewEvent(AMessage, AHandled);
end;

function TControllerFactory.ViewEvent<TViewInterface>(AMessage: string;
  var AHandled: Boolean): IView;
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

procedure TControllerFactory.SetView(AView: IView);
begin
  View(AView);
end;

function TControllerFactory.ShowView(const AProcBeforeShow,
  AProcOnClose: TProc<IView>): IView;
begin
  result := FView;
  if assigned(result) then
    result.ShowView(AProcBeforeShow, AProcOnClose);
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

  if not FControllerInited then
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
    FControllerInited := true;
  end;
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

function TControllerFactory.AttachModel(const AModel: IModel): integer;
var
  vm: IViewModel;
  v: IView;
begin
  result := -1;
  if not assigned(AModel) then
    exit;
  result := inherited AttachModel(AModel);
  AModel.setController(self);

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

function TControllerFactory.This: TControllerAbstract;
begin
  result := self;
end;

procedure TControllerFactory.Update(AJsonValue: TJsonValue;
var AHandled: Boolean);
var
  i: integer;
begin
  if FRefModelCount = 0 then
  begin
    inc(FRefModelCount); // previne para nao entrar em LOOP
    with FModels.LockList do
      try
        try
          for i := 0 to Count - 1 do
            (items[i] as IModel).Update(AJsonValue, AHandled);
          if assigned(FView) then
            FView.Update(AJsonValue, AHandled);
        finally
          dec(FRefModelCount);
        end;
      finally
        FModels.UnlockList;
      end;
  end;
end;

function TControllerFactory.UpdateAll: IController;
var
  i: integer;
begin
  result := self;
  if FRefModelCount = 0 then
  begin
    inc(FRefModelCount); // previne para nao entrar em LOOP
    with FModels.LockList do
      try
        try
          for i := 0 to Count - 1 do
            (items[i] as IModel).Update;
          if assigned(FView) then
            FView.UpdateView;
        finally
          dec(FRefModelCount);
        end;
      finally
        FModels.UnlockList;
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
      FView.UpdateView;
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
    with FModels.LockList do
      try
        try
          for i := 0 to Count - 1 do
            (items[i] as IModel).Update;
        finally
          dec(FRefModelCount);
        end;
      finally
        FModels.UnlockList;
      end;
  end;
end;

function TControllerFactory.View(const AView: IView): IController;
var
  vm: IViewModel;
begin
  result := self;

  if not assigned(AView) then
    exit;

  if assigned(FView) and (FView <> AView) then
  begin
    FView.Release;
    FView := nil;
  end;
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
