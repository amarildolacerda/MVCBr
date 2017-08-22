{
  Application Controller - Singleton central para os controller
  Alterações:
  12/04/2017 - por: amarildo lacerda
  + Introduzido Function Default para Singleton
  + Incluido   class var FApplicationController
}

unit MVCBr.ApplicationController;
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

uses
{$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms,
{$ENDIF}{$ENDIF}
  System.Classes,
  System.JSON,
  System.Generics.Collections,
  System.SysUtils,
  System.ThreadSafe,
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
    // [weak]
    FControllers: TThreadSafeObjectList<TAggregatedObject>;
  protected
    /// MainView para o Application
    // [weak]
    FMainView: IView;
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
    [weak]
    function ControllerAsGuid: TGuid; virtual;
    [weak]
    function MainController:IController;virtual;

    /// Controllers methods
    [weak]
    function FindController(AGuid: TGuid): IController; virtual;
    function ResolveController<TIController: IController>
      : TIController; overload;
    function ResolveController(AGuid: TGuid): IController; overload; virtual;
    [weak]
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
    [weak]
    function FindView(AGuid: TGuid): IView; virtual;
    [weak]
    function ViewEvent(AMessage: string; var AHandled: boolean)
      : IApplicationController; overload;
    [weak]
    function ViewEventOther(ASender: IController; AMessage: string;
      var AHandled: boolean): IApplicationController;
    [weak]
    function ViewEvent(AView: TGuid; AMessage: String; var AHandled: boolean)
      : IView; overload;
    [weak]
    function ViewEvent<TViewInterface: IInterface>(AMessage: String;
      var AHandled: boolean): IView; overload;
    [weak]
    function ViewEvent(AMessage: TJsonValue; var AHandled: boolean)
      : IView; overload;

    /// Models Methods
    [weak]
    function FindModel(AGuid: TGuid): IModel; overload; virtual;
    [weak]
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
    procedure Run; overload;
    procedure RunMainForm(ATFormClass: TComponentClass; out AFormVar;
      AControllerGuid: TGuid; AFunc: TFunc < TObject, boolean >= nil); overload;

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
  [weak]
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
    with FControllers.LockList do
      try
        Add(agg);
        result := Count - 1;
      finally
        FControllers.UnlockList;
      end;
  end;
end;

function TApplicationController.AttachController(AGuid: TGuid): IController;
begin
  TControllerAbstract.AttachController(AGuid, result);
end;

function TApplicationController.Count: integer;
begin
  with FControllers.LockList do
    try
      result := Count;
    finally
      FControllers.UnlockList;
    end;
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
  with FControllers.LockList do
    try
      Delete(idx);
    finally
      FControllers.UnlockList;
    end;
end;

destructor TApplicationController.Destroy;
var
  i: integer;
  AController: IInterface;
begin

  LReleased := true;
  if assigned(FMainView) then
    FMainView.Release;
  FMainView := nil;
  TMVCBr.Release;
  if assigned(FControllers) then
  begin
    with FControllers.LockList do
      try
        while Count > 0 do
        begin
          AController := items[0].Controller;
          if assigned(AController) then
            (AController as IController).Release;
          Delete(0);
        end;
        clear;
      finally
        if assigned(FControllers) then
          FControllers.UnlockList;
      end;
    FControllers.free;
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
      with FControllers.LockList do
        try
          for i := 0 to Count - 1 do
          begin
            LHandled := AProc(items[i].Controller as IController);
            if LHandled then
              break;
          end;
        finally
          FControllers.UnlockList;
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
      with FControllers.LockList do
        try
          for i := Count - 1 downto 0 do
          begin
            LHandled := AProc(items[i].Controller as IController);
            if LHandled then
              break;
          end;
        finally
          FControllers.UnlockList;
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

function TApplicationController.ControllerAsGuid: TGuid;
begin
  if assigned(FMainView) then
    result := TMVCBr.GetGuid(FMainView.GetController);
end;

function TApplicationController.MainController: IController;
begin
  if assigned(FMainView) then
    result := FMainView.GetController;
end;

function TApplicationController.MainView: TObject;
begin
  if assigned(FMainView) then
    result := FMainView.This;
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
  with FControllers.LockList do
    try
      for i := Count - 1 downto 0 do
        if (items[i].Controller as IController).This.Equals(AController.This)
        then
        begin
          Delete(i);
        end;
    finally
      FControllers.UnlockList;
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
  if assigned(AController) then
    AController.Release;
  AController := nil;
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
  with FControllers.LockList do
    try
      for i := 0 to Count - 1 do
        if supports(items[i], AIID) then
          (items[i].Controller as IController).UpdateAll;
    finally
      FControllers.UnlockList;
    end;
end;

procedure TApplicationController.UpdateAll;
var
  i: integer;
begin
  with FControllers.LockList do
    try
      for i := 0 to Count - 1 do
        (items[i].Controller as IController).UpdateAll;
    finally
      FControllers.UnlockList;
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
    end;

    if assigned(AModel) then
      if AController.IndexOf(AModel) < 0 then
        AController.Add(AModel);

    if (not assigned(FMainView)) and assigned(application.MainForm) then
    begin
      TComponent(reference) := application.MainForm;
      if supports(reference, IView, FMainView) then
      begin
        if assigned(AController) then
          AController.view(FMainView);
        FMainView.ShowView(nil, false);
        application.Run;
      end;
{$IFDEF UNIGUI}
      application.Run;
{$ENDIF}
    end {$IFDEF MSWINDOWS}
    else
      application.Run;
{$ENDIF}
  end;
{$ENDIF}
end;

procedure TApplicationController.RunMainForm(ATFormClass: TComponentClass;
out AFormVar; AControllerGuid: TGuid; AFunc: TFunc<TObject, boolean>);
var
  AController: IController;
  obj: TObject;
begin
{$IFDEF LINUX}
  Run(ResolveController(AControllerGuid));
{$ELSE}
  application.CreateForm(ATFormClass, AFormVar);
  obj := TObject(AFormVar);
  Run(ResolveController(AControllerGuid),
    function: boolean
    begin
      result := true;
      if assigned(AFunc) then
        result := AFunc(obj);
    end);
{$ENDIF}
end;

procedure TApplicationController.Run;
begin
{$IFDEF LINUX}
  Run(nil, nil);
{$ELSE}
  application.Run;
{$ENDIF}
end;

initialization

finalization

TApplicationController.Release;

end.
