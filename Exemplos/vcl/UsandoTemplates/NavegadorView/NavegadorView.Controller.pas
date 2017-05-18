{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/05/2017 23:56:34                                  // }
{ //************************************************************// }
unit NavegadorView.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE}{$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF} System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  NavegadorView.Controller.Interf,
  System.RTTI;

type
  TNavegadorViewController = class(TControllerFactory, INavegadorViewController,
    IThisAs<TNavegadorViewController> { , IModelAs<INavegadorViewViewModel> } )
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
    function ThisAs: TNavegadorViewController;
    procedure init; override;
    // function ModelAs: INavegadorViewViewModel;
  end;

implementation

uses Navegador.View;

Constructor TNavegadorViewController.Create;
begin
  inherited;
  // add(TNavegadorViewViewModel.New(self).ID('{NavegadorView.ViewModel}')); CreateModules; //< criar os modulos persolnizados
end;

Destructor TNavegadorViewController.Destroy;
begin
  inherited;
end;

class function TNavegadorViewController.New(): IController;
begin
  result := New(nil, nil);
end;

class function TNavegadorViewController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TNavegadorViewController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

class function TNavegadorViewController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

function TNavegadorViewController.ThisAs: TNavegadorViewController;
begin
  result := self;
end;

{ function TNavegadorViewController.ModelAs: INavegadorViewViewModel;
  begin
  if count>=0 then
  supports(GetModelByType(mtViewModel), INavegadorViewViewModel, result);
  end; }
Procedure TNavegadorViewController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

procedure TNavegadorViewController.init;
var
  ref: TNavegadorView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TNavegadorView, ref);
    supports(ref, IView, FView);
  end;
  AfterInit;
end;

// Adicionar os modulos e MODELs personalizados
Procedure TNavegadorViewController.CreateModules;
begin
  // adicionar os mudulos aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

// TNavegadorViewController.New(TNavegadorViewView.New,TNavegadorViewViewModel.New)).init();
RegisterInterfacedClass(TNavegadorViewController.ClassName,
  INavegadorViewController, TNavegadorViewController);

finalization

unRegisterInterfacedClass(TNavegadorViewController.ClassName);

end.
