unit Main.Controller;

interface

uses
  SysUtils, forms, buttons, classes, controls, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI,
  Main.ViewModel, Main.ViewModel.Interf, MainView;

type
  IMainController = interface(IController)
    ['{A1ECA41A-8DD1-4678-AE0C-59076715532F}']
    // incluir especializações aqui
  end;

  TMainController = class(TControllerFactory, IMainController,
    IThisAs<TMainController>, IModelAs<IMainViewModel>)
  protected
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); override;
  public
    Constructor Create; override;
    Destructor Destroy; override;
    class function New(): IController; overload;
    class function New(const AView: IView; const AModel: IModel)
      : IController; overload;
    class function New(const AModel: IModel): IController; overload;
    function ThisAs: TMainController;
    function ModelAs: IMainViewModel;
  end;

implementation

Constructor TMainController.Create;
begin
  inherited;
  add(TMainViewModel.New(self).ID('{Main.ViewModel}'));
end;

Destructor TMainController.Destroy;
begin
  inherited;
end;

class function TMainController.New(): IController;
begin
  result := New(nil, nil);
end;

class function TMainController.New(const AView: IView; const AModel: IModel)
  : IController;
var
  vm: IViewModel;
begin
  result := TMainController.Create as IController;
  result.View(AView).add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

class function TMainController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

function TMainController.ThisAs: TMainController;
begin
  result := self;
end;

function TMainController.ModelAs: IMainViewModel;
begin
  if count >= 0 then
    supports(GetModelByType(mtViewModel), IMainViewModel, result);
end;

Procedure TMainController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

initialization
// TMainController.New(TMainView.New,TMainViewModel.New));
end.
