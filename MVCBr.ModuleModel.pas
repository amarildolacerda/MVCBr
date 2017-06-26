///
/// MVCBr.ModuleModel - Inherits from TDataModule to implements a Model Factory
/// Auth:  amarildo lacerda
/// Date:  mar/2017

{
  Changes:

}
unit MVCBr.ModuleModel;

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
    function Update: IModel;overload; virtual;
    procedure Update(AJsonValue: TJsonValue; var AHandled: boolean);
      overload; virtual;

    function Controller(const AController: IController): IModel; virtual;
    function GetModelTypes: TModelTypes; virtual;
    function GetController: IController;
    procedure SetModelTypes(const AModelType: TModelTypes);
    property ModelTypes: TModelTypes read GetModelTypes write SetModelTypes;
    procedure AfterInit; virtual;
    property OnUpdateModel: TNotifyEvent read FOnUpdateModel
      write SetOnUpdateModel;
    property OnAfterInitModel: TNotifyEvent read FOnAfterInit write SetOnAfterInit;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Release;virtual;
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

function TCustomModuleFactory.ApplicationControllerInternal
  : IApplicationController;
begin
  result := MVCBr.ApplicationController.ApplicationController;
end;

function TCustomModuleFactory.Controller(const AController
  : IController): IModel;
begin
  result := self as IModel;
  FController := AController;
end;

constructor TCustomModuleFactory.Create(AOwner: TComponent);
begin
  inherited;
  // BorderIcons:=[];
  // FFont:= TFont.Create;
end;

destructor TCustomModuleFactory.Destroy;
begin
  // FFont.Free;
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

procedure TCustomModuleFactory.Release;
begin
  inherited;

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

procedure TCustomModuleFactory.Update(AJsonValue: TJsonValue;
  var AHandled: boolean);
begin
   Update;
end;

function TCustomModuleFactory.Update: IModel;
begin
  result := self as IModel;
  if assigned(FOnUpdateModel) then
    FOnUpdateModel(self);

end;

initialization

end.
