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
unit MVCBr.Model;

interface

Uses System.Classes, System.SysUtils, System.Generics.collections, MVCBr.Interf;

type

  TMVCInterfacedObject = Class(TMVCFactoryAbstract)
  public
    //class function New(AClass: TInterfacedClass): IInterface;
    function GetOwner: TComponent; virtual;
  end;

  TModelFactory = class;

  TModelFactoryClass = class of TModelFactory;

  TModelFactory = class(TMVCInterfacedObject, IModel)
  private
    FOwned: TComponent;
    FID: string;
    FModelTypes: TModelTypes;
    function GetModelTypes: TModelTypes;
    procedure SetModelTypes(const AModelTypes: TModelTypes);
  private
    FController: IController;
    procedure SetID(const AID:string);
    procedure AfterConstruction ;override;
  public
    constructor create; virtual;
    destructor destroy; override;
    procedure SetController(const AController:IController);virtual;
    function GetController: IController;
    function GetOwner: TComponent; override;
    function Controller(const AController: IController): IModel; virtual;
    function This: TObject; virtual;
    function GetID: string; virtual;
    function ID(const AID: String): IModel;
    function Update: IModel;virtual;
    property ModelTypes: TModelTypes read GetModelTypes write SetModelTypes
      default [mtCommon];
    procedure AfterInit; virtual;
  end;

implementation

{ TModelClass }

constructor TModelFactory.create;
begin
  inherited create;
end;

destructor TModelFactory.destroy;
begin
  FOwned.DisposeOf;
  inherited;
end;

function TModelFactory.GetController: IController;
begin
  result := FController;
end;

function TModelFactory.GetID: string;
begin
  result := FID;
end;

function TModelFactory.GetModelTypes: TModelTypes;
begin
  result := FModelTypes;
end;

function TModelFactory.GetOwner: TComponent;
begin
  result := FOwned;
end;

function TModelFactory.ID(const AID: String): IModel;
begin
  result := self;
  SetID(AID);
end;


procedure TModelFactory.SetController(const AController: IController);
begin
  FController := AController;
end;

procedure TModelFactory.SetID(const AID: string);
begin
  FID := AID;
end;

procedure TModelFactory.SetModelTypes(const AModelTypes: TModelTypes);
begin
  FModelTypes := AModelTypes;
end;

procedure TModelFactory.afterConstruction;
begin
  inherited;
  FModelTypes := [mtCommon];
  FOwned := TComponent.create(nil);
  SetID( self.classname );
end;

procedure TModelFactory.AfterInit;
begin
  // chamado apos a conclusao do controller
end;

function TModelFactory.Controller(const AController: IController): IModel;
begin
  result := self;
  setController(AController);
end;

function TModelFactory.This: TObject;
begin
  result := self;
end;

function TModelFactory.Update: IModel;
begin
  result := self;
end;

{ TMVCInterfacedObject }

function TMVCInterfacedObject.GetOwner: TComponent;
begin
  result := nil;
end;

{class function TMVCInterfacedObject.New(AClass: TInterfacedClass): IInterface;
begin
  result := AClass.create;
end;
}
end.
