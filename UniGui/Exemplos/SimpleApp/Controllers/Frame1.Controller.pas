{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 14/07/2017 22:02:01                                  // }
{ //************************************************************// }

unit Frame1.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses

  System.SysUtils, {$IFDEF LINUX} {$ELSE}{$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF} System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  Frame1.Controller.Interf,
  System.RTTI;

type

  TFrame1Controller = class(TControllerFactory, IFrame1Controller,
    IThisAs<TFrame1Controller>)
  protected
  public
    // inicializar os módulos personalizados em CreateModules
    Procedure CreateModules; virtual;
    Constructor Create; override;
    Destructor Destroy; override;
    class function New(): IController; overload;
    class function New(const AView: IView; const AModel: IModel)
      : IController; overload;
    class function New(const AModel: IModel): IController; overload;
    function ThisAs: TFrame1Controller;
    procedure init; override;
    // function ModelAs: IFrame1ViewModel;
  end;

implementation

uses CalcularJuros.Model;

Constructor TFrame1Controller.Create;
begin
  inherited;
  add(tCalcularJurosModel.New(self));
  // add(TFrame1ViewModel.New(self).ID('{Frame1.ViewModel}'));
end;

Destructor TFrame1Controller.Destroy;
begin
  inherited;
end;

class function TFrame1Controller.New(): IController;
begin
  result := New(nil, nil);
end;

class function TFrame1Controller.New(const AView: IView; const AModel: IModel)
  : IController;
var
  vm: IViewModel;
begin
  result := TFrame1Controller.Create as IController;
  result.View(AView).add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

class function TFrame1Controller.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

function TFrame1Controller.ThisAs: TFrame1Controller;
begin
  result := self;
end;

procedure TFrame1Controller.init;
// var ref:TFrame1View;
begin
  inherited;
  { if not assigned(FView) then
    begin
    Application.CreateForm( TFrame1View, ref );
    supports(ref,IView,FView);
    end; }
  CreateModules; // < criar os modulos persolnizados
  AfterInit;
end;

// Adicionar os modulos e MODELs personalizados
Procedure TFrame1Controller.CreateModules;
begin
  // adicionar os mudulos aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

// TFrame1Controller.New(TFrame1View.New,TFrame1ViewModel.New)).init();

RegisterInterfacedClass(TFrame1Controller.ClassName, IFrame1Controller,
  TFrame1Controller);

finalization

unRegisterInterfacedClass(TFrame1Controller.ClassName);

end.
