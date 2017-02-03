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
unit MVCBr.View;

interface

uses Forms, system.Classes, system.SysUtils, system.Rtti, MVCBr.Model,
  MVCBr.Interf;

type

  TViewFactoryClass = class of TViewFactory;

  TViewFactory = class(TMVCInterfacedObject, IView)
  private
    FView: IView;
    FController: IController;
  protected
    function Controller(const AController: IController): IView; virtual;
    function This: TObject; virtual;
  public
    class Function New(AClass: TViewFactoryClass;
      const AController: IController): IView;
    function ShowView(const AProc: TProc<IView>): Integer; virtual;
    function Update: IView; virtual;
  end;

  TFormFactory = class(TForm, IMVCBrBase, IView)
  private
    function GetPropertyValue(ANome: string): TValue;
    procedure SetPropertyValue(ANome: string; const Value: TValue);
  protected
    FController: IController;
    procedure SetController(const AController: IController);
    function Controller(const AController: IController): IView; virtual;
  public
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
  FController := AController;
end;

class function TViewFactory.New(AClass: TViewFactoryClass;
  const AController: IController): IView;
begin
  result := AClass.Create;
  result.Controller(AController);
end;

function TViewFactory.ShowView(const AProc: TProc<IView>): Integer;
begin

  // implements on overrided code

  if assigned(AProc) then
    AProc(self);
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

function TFormFactory.InvokeMethod<T>(AMethod: string;
  const Args: TArray<TValue>): T;
begin
  result := TMVCBr.InvokeMethod<T>(self, AMethod, Args);
end;

procedure TFormFactory.SetController(const AController: IController);
begin
  FController := AController;
end;

procedure TFormFactory.SetPropertyValue(ANome: string; const Value: TValue);
begin
  TMVCBr.SetProperty(self, ANome, Value);
end;

function TFormFactory.ShowView(const AProc: TProc<IView>): Integer;
begin
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
