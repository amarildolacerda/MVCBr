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

/// <summary>
/// Unit MVCBr.View implementas os objeto Factory para a camada de visualização
/// </summary>
unit MVCBr.View;

interface

uses {$ifdef LINUX}  {$else} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$endif} system.Classes,
  system.SysUtils, system.Rtti, MVCBr.Model,
  MVCBr.Interf, System.JSON;

type

  TViewFactoryClass = class of TViewFactory;

  /// <summary>
  /// TViewFactory é um Factory abstrato a ser utilizado com finalidades genericas
  /// sem ligação direta com um visualizador
  /// </summary>
  TViewFactory = class(TMVCFactoryAbstract, IView)
  private
    FText: string;
    FController: IController;
    FViewModel: IViewModel;
    procedure SetController(const AController: IController);
    function GetText: String;
    procedure SetText(Const AText: String);
  protected
    function Controller(const AController: IController): IView; virtual;
    function This: TObject; virtual;
  public
    procedure Init; virtual;
    function ViewEvent(AMessage: string;var AHandled: boolean): IView; overload;virtual;
    function ViewEvent(AMessage: TJsonValue;var AHandled: boolean): IView;overload;virtual;
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); virtual;
    function ShowView(const AProc: TProc<IView>): Integer; overload; virtual;
    function ShowView(): IView; overload; virtual;
    function ShowView(const AProc: TProc<IView>; AShowModal: boolean): IView;
      overload; virtual;
    function ShowView(const AProcBeforeShow: TProc<IView>; const AProcAfterShow:TProc<IView>)
      : IView; overload; virtual;
    function GetViewModel: IViewModel; virtual;
    procedure SetViewModel(const AViewModel: IViewModel); virtual;
    function GetModel(AII:TGuid):IModel;

    function Update: IView; virtual;
    function GetController: IController;
    function ViewModel(const AModel: IViewModel): IView;
    property Text: string read GetText write SetText;

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

function TViewFactory.ViewEvent(AMessage: string;var AHandled: boolean): IView;
begin
  result := self;
end;

function TViewFactory.GetController: IController;
begin
  result := FController;
end;

function TViewFactory.GetModel(AII: TGuid): IModel;
begin
  result := FController.GetModel(AII,result);
end;

function TViewFactory.GetText: String;
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

function TViewFactory.ViewEvent(AMessage: TJsonValue;var AHandled: boolean): IView;
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

procedure TViewFactory.SetText(const AText: String);
begin
  FText := AText;
end;

procedure TViewFactory.SetViewModel(const AViewModel: IViewModel);
begin
  FViewModel := AViewModel;
end;

function TViewFactory.ShowView(const AProcBeforeShow,
  AProcAfterShow: TProc<IView>): IView;
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

function TViewFactory.Update: IView;
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
