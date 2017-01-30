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
  public
    constructor Create; virtual;
    destructor destroy; override;
    function GetModelByID(const AID: String): IModel;
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); virtual;
    function GetModel(const idx: integer): IModel; overload; virtual;

    function GetModelByType(const AModelType: TModelType): IModel; virtual;
    procedure Init; virtual;
    procedure BeginInit; virtual;
    procedure EndInit; virtual;
    function GetView: IView; virtual;
    function View(const AView: IView): IController; virtual;
    function This: TControllerAbstract; virtual;
    Function ControllerAs: TControllerFactory; virtual;
    function Add(const AModel: IModel): integer; virtual;
    function IndexOf(const AModel: IModel): integer; virtual;
    function IndexOfModelType(const AModelType: TModelType): integer;
    procedure Delete(const Index: integer); virtual;
    function Count: integer; virtual;
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

procedure TControllerFactory.BeginInit;
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
end;

procedure TControllerFactory.Delete(const Index: integer);
begin
  FModels.Delete(Index);
end;

destructor TControllerFactory.destroy;
begin
  FModels.Free;
  ApplicationController.remove(self);
  inherited;
end;

procedure TControllerFactory.DoCommand(ACommand: string;
  const AArgs: array of TValue);
begin

end;

function TControllerFactory.GetModel(const idx: integer): IModel;
begin
  result := FModels[idx] as IModel;
end;

function TControllerFactory.GetModelByID(const AID: String): IModel;
var
  I: integer;
begin
  result := nil;
  for I := 0 to FModels.Count - 1 do
    if sameText(AID, (FModels.Items[I] as IModel).GetID) then
    begin
      result := FModels.Items[I] as IModel;
      exit;
    end;
end;

function TControllerFactory.GetModelByType(const AModelType
  : TModelType): IModel;
var
  I: integer;
begin
  result := nil;
  I := IndexOfModelType(AModelType);
  if I >= 0 then
    result := FModels.Items[I] as IModel;
end;

function TControllerFactory.IndexOf(const AModel: IModel): integer;
begin
  result := FModels.IndexOf(AModel);
end;

function TControllerFactory.IndexOfModelType(const AModelType
  : TModelType): integer;
var
  I: integer;
begin
  result := -1;
  for I := 0 to FModels.Count - 1 do
    if AModelType in (FModels.Items[I] as IModel).ModelTypes then
    begin
      result := I;
      exit;
    end;
end;

procedure TControllerFactory.Init;
begin
  BeginInit;
end;

procedure TControllerFactory.EndInit;
var
  FModel: IModel;
  vm: IViewModel;
begin
  FModel := GetModelByType(mtViewModel);
  if Supports(FModel.This, IViewModel, vm) then
  begin
    vm.View(FView);
  end;
end;

function TControllerFactory.This: TControllerAbstract;
begin
  result := self;
end;

function TControllerFactory.UpdateAll: IController;
var
  I: integer;
begin
  result := self;
  for I := 0 to FModels.Count - 1 do
    (FModels.Items[I] as IModel).Update;
  FView.Update;
end;

function TControllerFactory.UpdateByModel(AModel: IModel): IController;
begin
  FView.Update;
end;

function TControllerFactory.UpdateByView(AView: IView): IController;
var
  I: integer;
begin
  for I := 0 to FModels.Count - 1 do
    (FModels.Items[I] as IModel).Update;
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
