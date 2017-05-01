unit Main.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses
  SysUtils, forms, buttons, classes, controls, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI,
  ACBrUtils.Model,  ACBrValidador.Model,
  Main.ViewModel, Main.ViewModel.Interf, MainView;

type
  IMainController = interface(IController)
    ['{D7294DF6-94B2-4846-A2B4-AA56786A27A3}']
    // incluir especializações aqui
  end;

  TMainController = class(TControllerFactory, IMainController,
    IThisAs<TMainController>, IModelAs<IMainViewModel>)
  protected
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); override;
  public
    // inicializar os módulos personalizados em CreateModules
    Procedure CreateModules; virtual;
    Constructor Create; override;
    Destructor Destroy; override;
    class function New(): IController; overload;
    class function New(const AView: IView; const AModel: IModel)
      : IController; overload;
    class function New(const AModel: IModel): IController; overload;
    function ThisAs: TMainController;
    procedure init; override;
    function ModelAs: IMainViewModel;
  end;

implementation

Constructor TMainController.Create;
begin
  inherited;
  add(TMainViewModel.New(self).ID('{Main.ViewModel}'));
  CreateModules;
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

procedure TMainController.init;
var
  ref: TMainView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TMainView, ref);
    supports(ref, IView, FView);
  end;
  AfterInit;
end;

// Adicionar os modulos e MODELs personalizados
Procedure TMainController.CreateModules;
begin
  // adicionar os mudulos aqui
  // exemplo: add( MeuModel.new(self) );

  add(TACBrUtilsModel.New(self));
  add(TACBrValidadorModel.New(self));
end;

initialization

// TMainController.New(TMainView.New,TMainViewModel.New)).init();
end.
