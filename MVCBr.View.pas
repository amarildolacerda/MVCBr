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
///  Unit MVCBr.View implementas os objeto Factory para a camada de visualização
/// </summary>
unit MVCBr.View;

interface

uses Forms, system.Classes, system.SysUtils, system.Rtti, MVCBr.Model,
  MVCBr.Interf;

type

  TViewFactoryClass = class of TViewFactory;

  /// <summary>
  ///     TViewFactory é um Factory abstrato a ser utilizado com finalidades genericas
  ///     sem ligação direta com um visualizador
  ///  </summary>
  TViewFactory = class(TMVCInterfacedObject, IView)
  private
    // FView: IView;
    FController: IController;
    procedure SetController(const AController: IController);
  protected
    function Controller(const AController: IController): IView; virtual;
    function This: TObject; virtual;
  public
    { class Function New(AClass: TViewFactoryClass;
      const AController: IController): IView;
    }
    function ShowView(const AProc: TProc<IView>): Integer; virtual;
    function Update: IView; virtual;
    function GetController: IController;

  end;


implementation

{ TViewFactory }
function TViewFactory.Controller(const AController: IController): IView;
begin
  result := self;
  SetController(AController);
end;

function TViewFactory.GetController: IController;
begin
  result := FController;
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


end.
