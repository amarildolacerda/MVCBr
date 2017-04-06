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

uses
{$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms,
{$ENDIF}{$ENDIF}
  System.Classes,
  System.Generics.Collections,

  System.SysUtils, MVCBr.Model, MVCBr.Interf;

type
  /// <summary>
  /// AplicationController é uma instancia SINGLETON iniciada ao carregar o MVCBr
  /// No ApplicationController fica armazenado uma lista de Controllers
  /// ativos
  /// </summary>
  TApplicationController = class(TMVCInterfacedObject, IApplicationController)
  private
    /// Lista de controllers instanciados
    FControllers: TMVCInterfacedList<IController>;
  protected
    // MainView para o Application
    FMainView: IView;
  public
    function MainView: IView; virtual;
    procedure SetMainView(AView: IView);
    function FindController(AGuid: TGuid): IController; virtual;
    function ResolveController(AGuid: TGuid): IController; virtual;

    function FindView(AGuid: TGuid): IView; virtual;
    function FindModel(AGuid: TGuid): IModel; overload; virtual;
    function FindModel<TIModel: IInterface>: TIModel; overload;

    function ViewEvent(AMessage: string; var AHandled: boolean)
      : IApplicationController; overload;
    function ViewEventOther(ASender: IController; AMessage: string;
      var AHandled: boolean): IApplicationController;
    function ViewEvent(AView: TGuid; AMessage: String; var AHandled: boolean)
      : IView; overload;
    function ViewEvent<TViewInterface: IInterface>(AMessage: String;
      var AHandled: boolean): IView; overload;
    constructor create; override;
    destructor destroy; override;
    /// This retorna o Self do ApplicationController Object Factory
    function This: TObject;
    function ThisAs: TApplicationController;
    /// Count retorna a quantidade de controllers empilhados na lista
    function Count: integer;
    /// Add Adiciona um controller a lista de controller instaciados
    function Add(const AController: IController): integer;
    /// Delete Remove um controller da lista
    procedure Delete(const idx: integer);
    procedure Remove(const AController: IController);
    /// Executa o ApplicationController
    procedure Run(AClass: TComponentClass; AController: IController;
      AModel: IModel; AFunc: TFunc < boolean >= nil); overload;
    /// Executa
    procedure Run(AController: IController;
      AFunc: TFunc < boolean >= nil); overload;
    class function New: IApplicationController;
    /// Loop que chama AProc para cada um dos controllers da lista
    procedure ForEach(AProc: TProc<IController>); overload;
    function ForEach(AProc: TFunc<IController, boolean>): boolean; overload;
    procedure Inited;
    /// Envia evnet de Update a todos os controllers da lista
    procedure UpdateAll;
    /// envia event de Update a um Controller que contenha a IInterface
    procedure Update(const AIID: TGuid);
  end;

  /// ApplicationController é uma instância que implementa a interface ...
function ApplicationController: IApplicationController;
/// Altera o ApplicationController
procedure SetApplicationController(AController: IApplicationController);

implementation

uses System.TypInfo;

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

/// ForEach Execut a AProc passar a instancia de cada um dos controllers instanciados.
function TApplicationController.FindController(AGuid: TGuid): IController;
var
  rst: IController;
begin
  rst := nil;
  ForEach(
    function(ACtrl: IController): boolean
    begin
      if supports(ACtrl.This, AGuid, rst) then
        result := true;
    end);
  result := rst;
end;

function TApplicationController.FindModel(AGuid: TGuid): IModel;
var
  rst: IModel;
begin
  rst := nil;
  ForEach(
    function(ACtrl: IController): boolean
    begin
      ACtrl.GetModel(AGuid, rst);
      if assigned(rst) then
        result := true;
    end);
  result := rst;
end;

function TApplicationController.FindModel<TIModel>: TIModel;
var
  IID: TGuid;
  AModel: IModel;
begin
  IID := TMVCBr.GetGuid<TIModel>;
  AModel := FindModel(IID);
  if assigned(AModel) then
    result := TIModel(AModel);
end;

function TApplicationController.FindView(AGuid: TGuid): IView;
var
  rst: IView;
begin
  rst := nil;
  ForEach(
    function(ACtrl: IController): boolean
    var
      r: IView;
    begin
      r := ACtrl.GetView;
      if assigned(r) then
        if supports(r.This, AGuid, rst) then
          result := true;
    end);
  result := rst;
end;

function TApplicationController.ForEach
  (AProc: TFunc<IController, boolean>): boolean;
var
  i: integer;
  LHandled: boolean;
begin
  Lock;
  try
    LHandled := false;
    if assigned(AProc) then
      for i := 0 to FControllers.Count - 1 do
      begin
        LHandled := AProc(FControllers.Items[i] as IController);
        if LHandled then
          break;
      end;
    result := LHandled;
  finally
    UnLock;
  end;
end;

procedure TApplicationController.ForEach(AProc: TProc<IController>);
var
  i: integer;
begin
  ForEach(
    function(AController: IController): boolean
    begin
      try
        result := false;
        AProc(AController);
      except
        result := true;
      end;
    end);
end;

procedure TApplicationController.Inited;
begin
  ForEach(
    procedure(AController: IController)
    begin
      AController.Init;
    end);
end;

function TApplicationController.MainView: IView;
begin
  result := FMainView;
end;

function TApplicationController.ThisAs: TApplicationController;
begin
  result := self;
end;

class function TApplicationController.New: IApplicationController;
begin
  result := TApplicationController.create;
end;

procedure TApplicationController.Remove(const AController: IController);
begin
  FControllers.Remove(AController);
end;

function TApplicationController.ResolveController(AGuid: TGuid): IController;
var
  stb: TControllerAbstract;
begin
  stb := TControllerAbstract.create;
  try
    stb.ResolveController(AGuid, result);
  finally
    stb.DisposeOf;
  end;
end;

procedure TApplicationController.Run(AController: IController;
AFunc: TFunc<boolean>);
begin
  Run(nil, AController, nil, AFunc);
end;

procedure TApplicationController.SetMainView(AView: IView);
begin
  FMainView := AView;
end;

function TApplicationController.ViewEvent(AMessage: string;
var AHandled: boolean): IApplicationController;
begin
  result := ViewEventOther(nil, AMessage, AHandled);
end;

function TApplicationController.This: TObject;
begin
  result := self;
end;

procedure TApplicationController.Update(const AIID: TGuid);
var
  i: integer;
begin
  Lock;
  try
    for i := 0 to Count - 1 do
      if supports(FControllers.Items[i], AIID) then
        (FControllers.Items[i] as IController).UpdateAll;
  finally
    UnLock;
  end;
end;

procedure TApplicationController.UpdateAll;
var
  i: integer;
begin
  Lock;
  try
    for i := 0 to FControllers.Count - 1 do
      (FControllers.Items[i] as IController).UpdateAll;
  finally
    UnLock;
  end;
end;

function TApplicationController.ViewEvent(AView: TGuid; AMessage: String;
var AHandled: boolean): IView;
var
  view: IView;
  rst: IView;
  LHandled: boolean;
begin
  result := nil;
  ForEach(
    function(AController: IController): boolean
    begin
      view := AController.GetView;
      if assigned(view) then
        if supports(view.This, AView) then
        begin
          rst := view; // stub
          AController.ViewEvent(AMessage, LHandled);
          result := LHandled;
        end;
    end);
  result := rst;
  AHandled := LHandled;
end;

function TApplicationController.ViewEvent<TViewInterface>(AMessage: String;
var AHandled: boolean): IView;
var
  IID: TGuid;
begin
  IID := TMVCBr.GetGuid<TViewInterface>;
  result := ViewEvent(IID, AMessage, AHandled);
end;

function TApplicationController.ViewEventOther(ASender: IController;
AMessage: string; var AHandled: boolean): IApplicationController;
var
  LHandled: boolean;
  i: integer;
begin
  result := self;
  ForEach(
    function(AController: IController):Boolean
    begin
      result := false;
      if (not assigned(ASender)) or (ASender <> AController) then
        /// CHECK NO LOOP
        if supports(AController.This, IController) then
          AController.ViewEvent(AMessage, result);
      LHandled := result;
    end);
  AHandled := LHandled;
end;

procedure TApplicationController.Run(AClass: TComponentClass;
AController: IController; AModel: IModel; AFunc: TFunc<boolean>);
var
  rt: boolean;
  reference: TComponent;
  Controller: TObject;
  LContrInterf: IController;
begin

{$IFDEF LINUX}
{$ELSE}
  application.Initialize;
  rt := true;
  if assigned(AFunc) then
    rt := AFunc;

  if rt then
  begin
    if assigned(AController) then
      AController.Init;
    if (AClass <> nil) and (application.MainForm = nil) then
    begin
      application.CreateForm(AClass, reference);
      if not supports(reference, IView) then
        raise Exception.create('Não é uma classe que implementa IView');
      FMainView := reference as IView;
      AController.view(FMainView);
    end;

    if assigned(AModel) then
      if AController.IndexOf(AModel) < 0 then
        AController.Add(AModel);

    if supports(application.MainForm, IView, FMainView) then
    begin
      if assigned(AController) then
        AController.view(FMainView);
      FMainView.ShowView(nil, false);
      application.Run;
    end;

  end;
  { if assigned(AController) then
    AController.AfterInit;
  }
{$ENDIF}
end;

end.
