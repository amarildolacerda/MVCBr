{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 14/07/2017 21:57:39                                  // }
{ //************************************************************// }

unit MainForm.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses

  System.SysUtils, {$IFDEF LINUX} {$ELSE}{$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF} System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  MainForm.Controller.Interf,
  System.RTTI;

type

  TMainFormController = class(TControllerFactory, IMainFormController,
    IThisAs<TMainFormController>)
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
    function ThisAs: TMainFormController;
    procedure init; override;
    // function ModelAs: IMainFormViewModel;
  end;

implementation

uses CalcularJuros.Model;

Constructor TMainFormController.Create;
begin
  inherited;
  add(   TCalcularJurosModel.new(self)  );
  // add(TMainFormViewModel.New(self).ID('{MainForm.ViewModel}'));
end;

Destructor TMainFormController.Destroy;
begin
  inherited;
end;

class function TMainFormController.New(): IController;
begin
  result := New(nil, nil);
end;

class function TMainFormController.New(const AView: IView; const AModel: IModel)
  : IController;
var
  vm: IViewModel;
begin
  result := TMainFormController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

class function TMainFormController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

function TMainFormController.ThisAs: TMainFormController;
begin
  result := self;
end;

procedure TMainFormController.init;
// var ref:TMainFormView;
begin
  inherited;
  { if not assigned(FView) then
    begin
    Application.CreateForm( TMainFormView, ref );
    supports(ref,IView,FView);
    end; }
  CreateModules; // < criar os modulos persolnizados
  AfterInit;
end;

// Adicionar os modulos e MODELs personalizados
Procedure TMainFormController.CreateModules;
begin
  // adicionar os mudulos aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

// TMainFormController.New(TMainFormView.New,TMainFormViewModel.New)).init();

RegisterInterfacedClass(TMainFormController.ClassName, IMainFormController,
  TMainFormController);

finalization

unRegisterInterfacedClass(TMainFormController.ClassName);

end.
