{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br                                // }
{ //************************************************************// }
{ // Data: 02/02/2017 21:56:59                                  // }
{ //************************************************************// }
unit Main2.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses
  SysUtils, forms, buttons, classes, controls, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  // Main2.ViewModel, Main2.ViewModel.Interf,Main2View,
  System.RTTI;

type
  IMain2Controller = interface(IController)
    ['{54EAD6F9-0C38-4D83-933C-F3F44F854117}']
    // incluir especializações aqui
  end;

  TMain2Controller = class(TControllerFactory, IMain2Controller,
    IThisAs<TMain2Controller> { , IModelAs<IMain2ViewModel> } )
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
    function ThisAs: TMain2Controller;
    procedure init; override;
    // function ModelAs: IMain2ViewModel;
  end;

implementation

Constructor TMain2Controller.Create;
begin
  inherited;
  // add(TMain2ViewModel.New(self).ID('{Main2.ViewModel}')); CreateModules; //< criar os modulos persolnizados
end;

Destructor TMain2Controller.Destroy;
begin
  inherited;
end;

class function TMain2Controller.New(): IController;
begin
  result := New(nil, nil);
end;

class function TMain2Controller.New(const AView: IView; const AModel: IModel)
  : IController;
var
  vm: IViewModel;
begin
  result := TMain2Controller.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

class function TMain2Controller.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

function TMain2Controller.ThisAs: TMain2Controller;
begin
  result := self;
end;

{ function TMain2Controller.ModelAs: IMain2ViewModel;
  begin
  if count>=0 then
  supports(GetModelByType(mtViewModel), IMain2ViewModel, result);
  end; }
Procedure TMain2Controller.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

procedure TMain2Controller.init;
// var ref:TMain2View;
begin
  inherited;
  { if not assigned(FView) then
    begin
    Application.CreateForm( TMain2View, ref );
    supports(ref,IView,FView);
    end; }
  AfterInit;
end;

// Adicionar os modulos e MODELs personalizados
Procedure TMain2Controller.CreateModules;
begin
  // adicionar os mudulos aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

// TMain2Controller.New(TMain2View.New,TMain2ViewModel.New)).init();
RegisterInterfacedClass(TMain2Controller.ClassName, IMain2Controller,
  TMain2Controller);

finalization

unRegisterInterfacedClass(TMain2Controller.ClassName);

end.
