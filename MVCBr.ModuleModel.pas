///
/// MVCBr.ModuleModel - Inherits from TDataModule to implements a Model Factory
/// Auth:  amarildo lacerda
/// Date:  mar/2017

{
  Changes:

}
unit MVCBr.ModuleModel;
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
{$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, VCL.Graphics, {$ENDIF}
  System.UITypes, System.SysUtils, System.Classes, System.JSON,
  MVCBr.ApplicationController, MVCBr.Interf;

type

  TCustomModuleFactory = class(TDataModule, IModuleModel, IModel)
  private
    { Private declarations }
    FController: IController;
    FID: string;
    FModelTypes: TModelTypes;
    FOnUpdateModel: TNotifyEvent;
    FOnAfterInit: TNotifyEvent;
    procedure SetOnUpdateModel(const Value: TNotifyEvent);
    procedure SetOnAfterInit(const Value: TNotifyEvent);
  protected
    function This: TObject; virtual;
    function GetID: string; virtual;
    function ID(const AID: String): IModel; virtual;
    function Update: IModel; overload; virtual;
    procedure Update(AJsonValue: TJsonValue; var AHandled: boolean); overload; virtual;

    function Controller(const AController: IController): IModel; virtual;
    procedure SetController(const AController: IController);
    function GetModelTypes: TModelTypes; virtual;
    function GetController: IController;
    procedure SetModelTypes(const AModelType: TModelTypes);
    property ModelTypes: TModelTypes read GetModelTypes write SetModelTypes;
    procedure AfterInit; virtual;
    property OnUpdateModel: TNotifyEvent read FOnUpdateModel write SetOnUpdateModel;
    property OnAfterInitModel: TNotifyEvent read FOnAfterInit write SetOnAfterInit;
  public
    { Public declarations }
    constructor Create;overload;
    constructor Create(AOwner: TComponent); overload;override;
    destructor Destroy; override;
    class procedure New(AClass: TComponentClass; AController: IController; out obj);
    procedure Release; virtual;
    function ApplicationControllerInternal: IApplicationController; virtual;
    function ApplicationController: TApplicationController; virtual;

  end;

  TModuleFactory = class(TCustomModuleFactory)
  published
    property ModelTypes;
    property OnUpdateModel;
    property OnAfterInitModel;
  end;

implementation

{ .$R *.dfm }
{ TCustomModuleFactory }

procedure TCustomModuleFactory.AfterInit;
begin
  // chamado apos INIT;
  if assigned(FOnAfterInit) then
    FOnAfterInit(self);
end;

function TCustomModuleFactory.ApplicationController: TApplicationController;
begin
  result := TApplicationController(ApplicationControllerInternal.This);
end;

function TCustomModuleFactory.ApplicationControllerInternal: IApplicationController;
begin
  result := MVCBr.ApplicationController.ApplicationController;
end;

function TCustomModuleFactory.Controller(const AController: IController): IModel;
begin
  result := self as IModel;
  FController := AController;
end;

constructor TCustomModuleFactory.Create;
begin
     Create(nil);
end;

constructor TCustomModuleFactory.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TCustomModuleFactory.Destroy;
begin
  FController := nil;
  inherited;
end;

function TCustomModuleFactory.GetController: IController;
begin
  result := FController;
end;

function TCustomModuleFactory.GetID: string;
begin
  result := FID;
end;

function TCustomModuleFactory.GetModelTypes: TModelTypes;
begin
  result := FModelTypes;
end;

function TCustomModuleFactory.ID(const AID: String): IModel;
begin
  result := self as IModel;
  FID := AID;
end;

class procedure TCustomModuleFactory.New(AClass: TComponentClass; AController: IController; out obj);
var
  o: TCustomModuleFactory;
begin
  application.CreateForm(AClass, obj);
  o := TCustomModuleFactory(obj);
  with o do
  begin
    SetController(AController);
  end;
end;

procedure TCustomModuleFactory.Release;
begin
  FController := nil;
  inherited destroy;
end;

procedure TCustomModuleFactory.SetController(const AController: IController);
begin
  FController := AController;
end;

procedure TCustomModuleFactory.SetModelTypes(const AModelType: TModelTypes);
begin
  FModelTypes := AModelType;
end;

procedure TCustomModuleFactory.SetOnAfterInit(const Value: TNotifyEvent);
begin
  FOnAfterInit := Value;
end;

procedure TCustomModuleFactory.SetOnUpdateModel(const Value: TNotifyEvent);
begin
  FOnUpdateModel := Value;
end;

function TCustomModuleFactory.This: TObject;
begin
  result := self;
end;

procedure TCustomModuleFactory.Update(AJsonValue: TJsonValue; var AHandled: boolean);
var
  AModel: IModel;
begin
  AModel := Update;
  AModel := nil;
end;

function TCustomModuleFactory.Update: IModel;
begin
  result := self as IModel;
  if assigned(FOnUpdateModel) then
    FOnUpdateModel(self);

end;

initialization

end.
