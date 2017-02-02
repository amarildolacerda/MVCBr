{***************************************************************************}
{                                                                           }
{           MVCBr é o resultado de esforços de um grupo                     }
{                                                                           }
{           Copyright (C) 2017 MVCBr                                        }
{                                                                           }
{           amarildo lacerda                                                }
{           http://www.tireideletra.com.br                                  }
{                                                                           }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{***************************************************************************}
unit MVCBr.Controller;

interface

uses MVCBr.Interf, MVCBr.Model, MVCBr.View,
  System.Generics.Collections,
  System.TypInfo,
  System.Classes, System.SysUtils,
  MVCBr.ApplicationController,
  System.RTTI;

type

  // TControllerFactory Classe Factory para  IController
  TControllerFactory = class(TControllerAbstract, IController,
    IControllerAs<TControllerFactory>)
  private
  protected
    FView: IView;
    FID: string;
    procedure SetID( const AID:string );
  public
    constructor Create; override;
    destructor destroy; override;
    function ID(const AID: string): IController;
    function GetModelByID(const AID: String): IModel;
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); virtual;
    function GetModel(const idx: integer): IModel; overload; virtual;

    function GetModelByType(const AModelType: TModelType): IModel; virtual;
    procedure Init; virtual;
    procedure BeforeInit; virtual;
    procedure AfterInit; virtual;
    function GetView: IView; virtual;
    function View(const AView: IView): IController; virtual;
    function This: TControllerAbstract; virtual;
    Function ControllerAs: TControllerFactory; virtual;
    function Add(const AModel: IModel): integer; virtual;
    function IndexOf(const AModel: IModel): integer; virtual;
    function IndexOfModelType(const AModelType: TModelType): integer;
    procedure Delete(const Index: integer); virtual;
    function Count: integer; virtual;
    procedure ForEach(AProc: TProc<IModel>); virtual;
    function UpdateAll: IController;
    function UpdateByModel(AModel: IModel): IController; virtual;
    function UpdateByView(AView: IView): IController; virtual;


  end;

  TControllerFactoryOf = class of TControllerFactory;

implementation

{ TController }

function TControllerFactory.Add(const AModel: IModel): integer;
begin
  result := -1;
  if not assigned(AModel) then
    exit;
  AModel.Controller(self);
  FModels.Add(AModel);
  result := FModels.Count - 1;
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
  ApplicationController.Add(self);
  FModels := TMVCInterfacedList<IModel>.Create;
  ID(self.ClassName);
end;

procedure TControllerFactory.Delete(const Index: integer);
begin
  FModels.Delete(Index);
end;

destructor TControllerFactory.destroy;
begin
  FModels.Free;
  UnRegisterClass(GetClass(FID));
  ApplicationController.remove(self);
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
begin
  result := -1;
  for i := 0 to FModels.Count - 1 do
    if AModelType in (FModels.Items[i] as IModel).ModelTypes then
    begin
      result := i;
      exit;
    end;
end;

procedure TControllerFactory.Init;
begin
  BeforeInit;
end;

procedure TControllerFactory.SetID(const AID: string);
begin
  if FID<>'' then
     UnRegisterClass(GetClass(FID));
  FID := AID;
  RegisterClassAlias( TPersistentClass(Self.ClassType)   ,FID);
end;

procedure TControllerFactory.AfterInit;
var
  FModel: IModel;
  vm: IViewModel;
begin
  FModel := GetModelByType(mtViewModel);
  if Supports(FModel.This, IViewModel, vm) then
  begin
    vm.View(FView).Controller(self);
  end;

  ForEach(
    procedure(AModel: IModel)
    begin
      AModel.AfterInit;
    end);

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
  for i := 0 to FModels.Count - 1 do
    (FModels.Items[i] as IModel).Update;
  FView.Update;
end;

function TControllerFactory.UpdateByModel(AModel: IModel): IController;
begin
  FView.Update;
end;

function TControllerFactory.UpdateByView(AView: IView): IController;
var
  i: integer;
begin
  for i := 0 to FModels.Count - 1 do
    (FModels.Items[i] as IModel).Update;
end;

function TControllerFactory.View(const AView: IView): IController;
begin
  result := self;
  FView := AView;
  if assigned(FView) then
    FView.Controller(result);
end;

function TControllerFactory.GetView: IView;
begin
  result := FView;
end;

end.
