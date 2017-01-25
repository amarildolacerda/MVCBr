unit MVCBr.ViewModel;

interface

uses MVCBr.Interf, MVCBr.Model, MVCBr.View, MVCBr.Controller;

type

  TViewModelFactory = class(TModelFactory, IViewModel)
  private
  protected
    FView: IView;
    FModel: IModel;
  public
    constructor create; override;
    class function New(const AView: IView; const AModel: IModel)
      : IViewModel; virtual;
    function Update(const AView: IView): IViewModel; overload;
    function Update(const AModel: IModel): IViewModel; overload;
    function This: TObject; virtual;
    function View(const AView: IView = nil): IViewModel; virtual;
    function Model(const AModel: IModel = nil): IViewModel; virtual;
    function Controller(const AController: IController): IViewModel; reintroduce; virtual;

  end;

implementation

{ TViewModelFactory }

function TViewModelFactory.Controller(const AController: IController)
  : IViewModel;
begin
  result := self;
  inherited Controller(AController);
end;

constructor TViewModelFactory.create;
begin
  inherited;
  ModelTypes := [mtViewModel];
end;

function TViewModelFactory.Model(const AModel: IModel): IViewModel;
begin
  result := self;
  if not assigned(AModel) then
    exit;
  FModel := AModel;
end;

class function TViewModelFactory.New(const AView: IView; const AModel: IModel)
  : IViewModel;
begin
  result := TViewModelFactory.create;
  result.View(AView);
  result.Model(AModel);
end;

function TViewModelFactory.This: TObject;
begin
  result := self;
end;

function TViewModelFactory.Update(const AModel: IModel): IViewModel;
begin
  result := self;
  if assigned(FView) then
    FView.Update;
end;

function TViewModelFactory.Update(const AView: IView): IViewModel;
begin
  result := self;
  if assigned(FModel) then
    FModel.Update;
end;

function TViewModelFactory.View(const AView: IView): IViewModel;
begin
  result := self;
  if not assigned(AView) then
    exit;
  FView := AView;
end;

end.
