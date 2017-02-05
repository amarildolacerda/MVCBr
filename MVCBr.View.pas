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
unit MVCBr.View;

interface

uses Forms, system.Classes, system.SysUtils, system.Rtti, MVCBr.Model,
  MVCBr.Interf;

type

  TViewFactoryClass = class of TViewFactory;

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

  TFormFactory = class(TForm, IMVCBrBase, IView)
  private
    function GetPropertyValue(ANome: string): TValue;
    procedure SetPropertyValue(ANome: string; const Value: TValue);
  protected
    FController: IController;
    FShowModal: boolean;
    procedure SetController(const AController: IController);
    function Controller(const AController: IController): IView; virtual;
    procedure AfterConstruction; override;
  public
    function isShowModal: boolean;
    procedure SetShowModal(const AShowModal: boolean);
    function GetShowModal: boolean;
    function GetController: IController; virtual;
    function This: TObject; virtual;
    function InvokeMethod<T>(AMethod: string; const Args: TArray<TValue>): T;
    property PropertyValue[ANome: string]: TValue read GetPropertyValue
      write SetPropertyValue;
    function ShowView(const AProc: TProc<IView>): Integer; virtual;
    function Update: IView; virtual;
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

{ TViewFormFacotry }
procedure TFormFactory.AfterConstruction;
begin
  inherited;
  FShowModal := true;
end;

function TFormFactory.Controller(const AController: IController): IView;
begin
  result := self;
  FController := AController;
end;

function TFormFactory.GetController: IController;
begin
  result := FController;
end;

function TFormFactory.GetPropertyValue(ANome: string): TValue;
begin
  result := TMVCBr.GetProperty(self, ANome);
end;

function TFormFactory.GetShowModal: boolean;
begin
  result := isShowModal;
end;

function TFormFactory.InvokeMethod<T>(AMethod: string;
  const Args: TArray<TValue>): T;
begin
  result := TMVCBr.InvokeMethod<T>(self, AMethod, Args);
end;

function TFormFactory.isShowModal: boolean;
begin
  result := FShowModal;
end;

procedure TFormFactory.SetController(const AController: IController);
begin
  FController := AController;
end;

procedure TFormFactory.SetPropertyValue(ANome: string; const Value: TValue);
begin
  TMVCBr.SetProperty(self, ANome, Value);
end;

procedure TFormFactory.SetShowModal(const AShowModal: boolean);
begin
  FShowModal := AShowModal;
end;

function TFormFactory.ShowView(const AProc: TProc<IView>): Integer;
begin
  result := 0;
  if FShowModal then
    result := ord(ShowModal);
  if assigned(AProc) then
    AProc(self);
end;

function TFormFactory.This: TObject;
begin
  result := self;
end;

function TFormFactory.Update: IView;
begin
  result := self;
end;

end.
