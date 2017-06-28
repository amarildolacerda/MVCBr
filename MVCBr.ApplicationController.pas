{
  Application Controller - Singleton central para os controller
  Alterações:
  12/04/2017 - por: amarildo lacerda
  + Introduzido Function Default para Singleton
  + Incluido   class var FApplicationController
}

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
  System.JSON,
  System.Generics.Collections,
  System.SysUtils,
  System.Threadsafe,
  MVCBr.Interf;

type
  /// <summary>
  /// AplicationController é uma instancia SINGLETON iniciada ao carregar o MVCBr
  /// No ApplicationController fica armazenado uma lista de Controllers
  /// ativos
  /// </summary>
  TApplicationController = class(TMVCOwnedInterfacedObject,
    IApplicationController)
  private
    /// Lista de controllers instanciados
    [unsafe]
    FControllers: TThreadSafeObjectList<TAggregatedObject>;
  protected
    /// MainView para o Application
    FMainView: TObject;
    /// singleton
    class var FApplicationController: IApplicationController;
  public

    constructor Create; override;
    destructor Destroy; override;

    class function Default: IApplicationController;
    class procedure Release;
    /// Loop que chama AProc para cada um dos controllers da lista
    function MainView: TObject; virtual;
    procedure SetMainView(AView: IView);

    /// Controllers methods
    function FindController(AGuid: TGuid): IController; virtual;
    function ResolveController<TIController: IController>
      : TIController; overload;
    function ResolveController(AGuid: TGuid): IController; overload; virtual;
    function AttachController(AGuid: TGuid): IController; virtual;
    procedure RevokeController(AGuid: TGuid);
    /// Count retorna a quantidade de controllers empilhados na lista
    function Count: integer;
    /// Add Adiciona um controller a lista de controller instaciados
    function Add(const AController: IController): integer;
    /// Delete Remove um controller da lista
    procedure Delete(const idx: integer);
    procedure Remove(const AController: IController);

    /// Views Methods
    function FindView(AGuid: TGuid): IView; virtual;
    function ViewEvent(AMessage: string; var AHandled: boolean)
      : IApplicationController; overload;
    function ViewEventOther(ASender: IController; AMessage: string;
      var AHandled: boolean): IApplicationController;
    function ViewEvent(AView: TGuid; AMessage: String; var AHandled: boolean)
      : IView; overload;
    function ViewEvent<TViewInterface: IInterface>(AMessage: String;
      var AHandled: boolean): IView; overload;
    function ViewEvent(AMessage: TJsonValue; var AHandled: boolean)
      : IView; overload;

    /// Models Methods
    function FindModel(AGuid: TGuid): IModel; overload; virtual;
    function FindModel<TIModel: IInterface>: TIModel; overload;

    /// This retorna o Self do ApplicationController Object Factory
    function This: TObject;
    function ThisAs: TApplicationController;

    /// Executa o ApplicationController
    procedure Run(AClass: TComponentClass; AController: IController;
      AModel: IModel; AFunc: TFunc < boolean >= nil); overload;
    /// Executa
    procedure Run(AController: IController;
      AFunc: TFunc < boolean >= nil); overload;

    procedure ForEach(AProc: TProc<IController>); overload;
    function ForEach(AProc: TFunc<IController, boolean>): boolean; overload;
    function ForEachDown(AProc: TFunc<IController, boolean>): boolean;

    procedure Inited;
    /// Envia evnet de Update a todos os controllers da lista

    procedure UpdateAll;
    /// envia event de Update a um Controller que contenha a IInterface
    procedure Update(const AIID: TGuid);
  end;

  /// Singleton
  /// ApplicationController é uma instância que implementa a interface ...
function ApplicationController: IApplicationController;

implementation

uses System.TypInfo;

var
  LReleased: boolean;

function ApplicationController(): IApplicationController;
begin
  if LReleased then
    result := nil
  else
    result := TApplicationController.Default;
end;

{ TApplicationController }

function TApplicationController.Add(const AController: IController): integer;
var
  agg: TAggregatedObject;
begin
  result := -1;
  if assigned(AController) then
  begin
    agg := TAggregatedObject.Create(AController);
    FControllers.Add(agg);
    result := FControllers.Count - 1;
  end;
end;

function TApplicationController.AttachController(AGuid: TGuid): IController;
begin
  TControllerAbstract.AttachController(AGuid, result);
end;

function TApplicationController.Count: integer;
begin
  result := FControllers.Count;
end;

constructor TApplicationController.Create;
begin
  inherited Create;
  LReleased := false;
  FControllers := TThreadSafeObjectList<TAggregatedObject>.Create;
end;

class function TApplicationController.Default: IApplicationController;
begin
  if not assigned(FApplicationController) then
    FApplicationController := TApplicationController.Create;
  result := FApplicationController;
end;

procedure TApplicationController.Delete(const idx: integer);
begin
  FControllers.Delete(idx);
end;

destructor TApplicationController.Destroy;
var
  i: integer;
begin
  FMainView := nil;
  if assigned(FControllers) then
  begin
    try
      for i := FControllers.Count - 1 downto 0 do
      begin
        (FControllers.items[i].Controller as IController).Release;
      end;
      FControllers.clear;
      FControllers.free;
      FControllers := nil;
    finally
    end;
  end;
  TMVCBr.Release;
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
      result := false;
      if supports(ACtrl.This, AGuid, rst) then
      begin
        result := true;
        rst := nil;
        rst := ACtrl.This.Default as IController; // use [unsafe]
      end;
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
      result := false;
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
      result := false;
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
        LHandled := AProc(FControllers.items[i].Controller as IController);
        if LHandled then
          break;
      end;
    result := LHandled;
  finally
    UnLock;
  end;
end;

function TApplicationController.ForEachDown
  (AProc: TFunc<IController, boolean>): boolean;
var
  i: integer;
  LHandled: boolean;
begin
  Lock;
  try
    LHandled := false;
    if assigned(AProc) then
      for i := FControllers.Count - 1 downto 0 do
      begin
        LHandled := AProc(FControllers.items[i].Controller as IController);
        if LHandled then
          break;
      end;
    result := LHandled;
  finally
    UnLock;
  end;
end;

procedure TApplicationController.ForEach(AProc: TProc<IController>);
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

function TApplicationController.MainView: TObject;
begin
  result := FMainView;
end;

function TApplicationController.ThisAs: TApplicationController;
begin
  result := self;
end;

class procedure TApplicationController.Release;
begin
  FApplicationController := nil;
  LReleased := true;
end;

procedure TApplicationController.Remove(const AController: IController);
var
  i: integer;
begin
  for i := FControllers.Count - 1 downto 0 do
    if (FControllers.items[i].Controller as IController)
      .This.Equals(AController.This) then
    begin
      Delete(i);
    end;
end;

function TApplicationController.ResolveController(AGuid: TGuid): IController;
begin
  TControllerAbstract.Resolve(AGuid, result);
end;

function TApplicationController.ResolveController<TIController>: TIController;
var
  IID: TGuid;
begin
  IID := TMVCBr.GetGuid<TIController>;
  TControllerAbstract.Resolve(IID, result);
end;

procedure TApplicationController.RevokeController(AGuid: TGuid);
var
  AController: IController;
begin
  AController := FindController(AGuid);
  if assigned(AController) then
  begin
    Remove(AController);
    TControllerAbstract.RevokeInstance(AController);
    AController := nil;
  end;
end;

procedure TApplicationController.Run(AController: IController;
AFunc: TFunc<boolean>);
begin
  Run(nil, AController, nil, AFunc);
  AController.Release;
  AController := nil;
  FMainView := nil;
end;

procedure TApplicationController.SetMainView(AView: IView);
begin
  FMainView := AView.This;
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
      if supports(FControllers.items[i], AIID) then
        (FControllers.items[i].Controller as IController).UpdateAll;
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
      (FControllers.items[i].Controller as IController).UpdateAll;
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
      result := false;
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

function TApplicationController.ViewEvent(AMessage: TJsonValue;
var AHandled: boolean): IView;
var
  LHandled: boolean;
  AView: IView;
begin
  AView := nil;
  ForEach(
    function(AController: IController): boolean
    begin
      result := false;
      if supports(AController.This, IController) then
      begin
        AController.GetView.ViewEvent(AMessage, result);
        if result then
          AView := AController.GetView;
      end;
      LHandled := result;
    end);
  result := AView;
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
begin
  result := self;
  ForEach(
    function(AController: IController): boolean
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
  AView: IView;
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
        raise Exception.Create('Não é uma classe que implementa IView');
      FMainView := reference { as IView };
      AController.view(reference as IView);
    end;

    if assigned(AModel) then
      if AController.IndexOf(AModel) < 0 then
        AController.Add(AModel);

    if assigned(application.MainForm) then
    begin
      if supports(application.MainForm, IView, AView) then
      begin
        FMainView := application.MainForm;
        if assigned(AController) then
          AController.view(AView);
        AView.ShowView(nil, false);
        application.Run;
      end;
    end {$IFDEF MSWINDOWS}
    else
      application.Run;
{$ENDIF}
  end;
  { if assigned(AController) then
    AController.AfterInit;
  }
{$ENDIF}
end;

initialization

finalization

// TApplicationController.Release;

end.
