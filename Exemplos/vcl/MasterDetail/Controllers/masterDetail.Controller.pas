{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 16/04/2017 22:28:42                                  // }
{ //************************************************************// }
unit masterDetail.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE}{$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF} System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI;

type
  ImaterDetailController = interface(IController)
    ['{508936C2-E68B-4FAF-9CB7-18FBC82284F3}']
  end;

  TmaterDetailController = class(TControllerFactory, ImaterDetailController, IThisAs<TmaterDetailController> { , IModelAs<ImaterDetailViewModel> } )
  protected
    Procedure DoCommand(ACommand: string; const AArgs: array of TValue); override;
  public
    // inicializar os módulos personalizados em CreateModules
    Procedure CreateModules; virtual;
    Constructor Create; override;
    Destructor Destroy; override;
    class function New(): IController; overload;
    class function New(const AView: IView; const AModel: IModel): IController; overload;
    class function New(const AModel: IModel): IController; overload;
    function ThisAs: TmaterDetailController;
    procedure init; override;
    // function ModelAs: ImaterDetailViewModel;
  end;

implementation

uses masterDetailView;

Constructor TmaterDetailController.Create;
begin
  inherited;
  // add(TmaterDetailViewModel.New(self).ID('{materDetail.ViewModel}')); CreateModules; //< criar os modulos persolnizados
end;

Destructor TmaterDetailController.Destroy;
begin
  inherited;
end;

class function TmaterDetailController.New(): IController;
begin
  result := New(nil, nil);
end;

class function TmaterDetailController.New(const AView: IView; const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TmaterDetailController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

class function TmaterDetailController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

function TmaterDetailController.ThisAs: TmaterDetailController;
begin
  result := self;
end;

{ function TmaterDetailController.ModelAs: ImaterDetailViewModel;
  begin
  if count>=0 then
  supports(GetModelByType(mtViewModel), ImaterDetailViewModel, result);
  end; }
Procedure TmaterDetailController.DoCommand(ACommand: string; const AArgs: Array of TValue);
begin
  inherited;
end;

procedure TmaterDetailController.init;
// var ref:TmaterDetailView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TForm61, Form61);
    supports(Form61, IView, FView);
  end;
  AfterInit;
end;

// Adicionar os modulos e MODELs personalizados
Procedure TmaterDetailController.CreateModules;
begin
  // adicionar os mudulos aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

// TmaterDetailController.New(TmaterDetailView.New,TmaterDetailViewModel.New)).init();
RegisterInterfacedClass(TmaterDetailController.ClassName, ImaterDetailController, TmaterDetailController);

finalization

unRegisterInterfacedClass(TmaterDetailController.ClassName);

end.
