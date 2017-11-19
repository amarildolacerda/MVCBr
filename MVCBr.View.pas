
/// <summary>
/// Unit MVCBr.View implementas os objeto Factory para a camada de visualização
/// </summary>
unit MVCBr.View;
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
{$IFDEF LINUX}  {$ELSE}
{$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms,
{$ENDIF}{$ENDIF}
  system.Classes,
  system.SysUtils, system.Rtti, MVCBr.Model,
  MVCBr.Interf, system.JSON;

type

  TViewFactoryClass = class of TViewFactory;

  /// <summary>
  /// TViewFactory é um Factory abstrato a ser utilizado com finalidades genericas
  /// sem ligação direta com um visualizador
  /// </summary>
  TViewFactory = class(TMVCFactoryAbstract, IView, IMVCBrObserver)
  private
    FText: string;
    [weak]
    FController: IController;
    [weak]
    FViewModel: IViewModel;
    procedure SetController(const AController: IController);
    function GetTitle: String;
    procedure SetTitle(Const AText: String);
  protected
    [weak]
    function Controller(const AController: IController): IView; virtual;
    function This: TObject; virtual;
  public
    procedure Release; override;
    procedure Init; virtual;
    function ViewEvent(AMessage: string; var AHandled: boolean): IView;
      overload; virtual;
    function ViewEvent(AMessage: TJsonValue; var AHandled: boolean): IView;
      overload; virtual;
    procedure Update(AJsonValue: TJsonValue; var AHandled: boolean);
      overload; virtual;

    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); virtual;
    function ShowView(const AProc: TProc<IView>): Integer; overload; virtual;
    function ShowView(): IView; overload; virtual;
    function ShowView(const AProc: TProc<IView>; AShowModal: boolean): IView;
      overload; virtual;
    function ShowView(const AProcBeforeShow: TProc<IView>;
      const AProcAfterShow: TProc<IView>): IView; overload; virtual;
    [weak]
    function GetViewModel: IViewModel; virtual;
    procedure SetViewModel(const AViewModel: IViewModel); virtual;
    [weak]
    function GetModel(AII: TGuid): IModel;

    [weak]
    function UpdateView: IView; virtual;

    /// <summary>
    /// Observer Methods
    /// </summary>
    procedure UpdateObserver(AJson: TJsonValue); overload; virtual;
    procedure UpdateObserver(AName: string; AJson: TJsonValue);
      overload; virtual;
    class procedure RegisterObserver(AName: string; AObserver: IMVCBrObserver);
      overload; static;
    procedure RegisterObserver(const AName: string); overload; virtual;
    class procedure UnRegisterObserver(AObserver: IMVCBrObserver);
      overload; static;
    class procedure UnRegisterObserver(AName: string;
      AObserver: IMVCBrObserver); overload; static;
    class procedure UnRegisterObserver(const AName: string); overload; static;

    [weak]
    function GetController: IController;
    [weak]
    function ViewModel(const AModel: IViewModel): IView;
    property Text: string read GetTitle write SetTitle;

  end;

implementation

{ TViewFactory }
function TViewFactory.Controller(const AController: IController): IView;
begin
  result := self;
  SetController(AController);
end;

procedure TViewFactory.DoCommand(ACommand: string;
  const AArgs: array of TValue);
begin

end;

function TViewFactory.ViewEvent(AMessage: string; var AHandled: boolean): IView;
begin
  result := self;
end;

function TViewFactory.GetController: IController;
begin
  result := FController;
end;

function TViewFactory.GetModel(AII: TGuid): IModel;
begin
  TControllerAbstract(FController.this).GetModel(AII, result);
end;

function TViewFactory.GetTitle: String;
begin
  result := FText;
end;

function TViewFactory.GetViewModel: IViewModel;
begin
  result := FViewModel;
end;

procedure TViewFactory.Init;
begin

end;

procedure TViewFactory.RegisterObserver(const AName: string);
begin
  TMVCBr.RegisterObserver(AName, self);
end;

procedure TViewFactory.Release;
begin
  FController := nil;
  FViewModel := nil;
  inherited;
end;

class procedure TViewFactory.RegisterObserver(AName: string;
  AObserver: IMVCBrObserver);
begin
  TMVCBr.RegisterObserver(AName, AObserver);
end;

function TViewFactory.ViewEvent(AMessage: TJsonValue;
  var AHandled: boolean): IView;
begin

end;

function TViewFactory.ViewModel(const AModel: IViewModel): IView;
begin
  result := self;
  FViewModel := AModel;
end;

{ class function TViewFactory.New(AClass: TViewFactoryClass;
  const AController: IController): IView;
  var obj:TViewFactory;
  begin
  obj := AClass.Create;
  obj.Controller(AController);
  supports(obj,IView,result);
  end;
}
procedure TViewFactory.SetController(const AController: IController);
begin
  FController := AController;
end;

procedure TViewFactory.SetTitle(const AText: String);
begin
  FText := AText;
end;

procedure TViewFactory.SetViewModel(const AViewModel: IViewModel);
begin
  FViewModel := AViewModel;
end;

function TViewFactory.ShowView(const AProcBeforeShow, AProcAfterShow
  : TProc<IView>): IView;
begin
  result := self;
  ShowView(AProcBeforeShow);
end;

function TViewFactory.ShowView: IView;
begin
  result := self;
  ShowView(nil);
end;

function TViewFactory.ShowView(const AProc: TProc<IView>): Integer;
begin
  result := -1;
  // implements on overrided code

  if assigned(AProc) then
    AProc(self);

  result := 0;
end;

function TViewFactory.This: TObject;
begin
  result := self;
end;

class procedure TViewFactory.UnRegisterObserver(AObserver: IMVCBrObserver);
begin
  TMVCBr.UnRegisterObserver(AObserver);
end;

class procedure TViewFactory.UnRegisterObserver(AName: string;
  AObserver: IMVCBrObserver);
begin
  TMVCBr.UnRegisterObserver(AName, AObserver);
end;

class procedure TViewFactory.UnRegisterObserver(const AName: string);
begin
  TMVCBr.UnRegisterObserver(AName);
end;

procedure TViewFactory.Update(AJsonValue: TJsonValue; var AHandled: boolean);
begin
  ViewEvent(AJsonValue, AHandled);
end;

procedure TViewFactory.UpdateObserver(AName: string; AJson: TJsonValue);
begin
  TMVCBr.UpdateObserver(AName, AJson);
end;

procedure TViewFactory.UpdateObserver(AJson: TJsonValue);
begin
  TMVCBr.UpdateObserver(AJson);
end;

function TViewFactory.UpdateView: IView;
begin
  result := self;
end;

function TViewFactory.ShowView(const AProc: TProc<IView>;
  AShowModal: boolean): IView;
begin
  result := self;
  ShowView(AProc);
end;

end.
