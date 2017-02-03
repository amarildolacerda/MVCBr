{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br                                // }
{ //************************************************************// }
{ // Data: 02/02/2017 23:17:42                                                // }
{ //************************************************************// }
unit Usuarios.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses
  SysUtils, forms, buttons, classes, controls, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  // Usuarios.ViewModel, Usuarios.ViewModel.Interf,UsuariosView,
  System.RTTI;

type
  IUsuariosController = interface(IController)
    ['{BC36D26E-7358-473C-9E11-131B57F0B438}']
    // incluir especializações aqui
  end;

  TUsuariosController = class(TControllerFactory, IUsuariosController,
    IThisAs<TUsuariosController> { , IModelAs<IUsuariosViewModel> } )
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
    function ThisAs: TUsuariosController;
    procedure init; override;
    // function ModelAs: IUsuariosViewModel;
  end;

implementation

uses UsuarioView;

Constructor TUsuariosController.Create;
begin
  inherited;
  // add(TUsuariosViewModel.New(self).ID('{Usuarios.ViewModel}')); CreateModules; //< criar os modulos persolnizados
  View(TUsuarioForm.Create(nil) as IView);
end;

Destructor TUsuariosController.Destroy;
begin
  inherited;
end;

class function TUsuariosController.New(): IController;
begin
  result := New(nil, nil);
end;

class function TUsuariosController.New(const AView: IView; const AModel: IModel)
  : IController;
var
  vm: IViewModel;
begin
  result := TUsuariosController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

class function TUsuariosController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

function TUsuariosController.ThisAs: TUsuariosController;
begin
  result := self;
end;

{ function TUsuariosController.ModelAs: IUsuariosViewModel;
  begin
  if count>=0 then
  supports(GetModelByType(mtViewModel), IUsuariosViewModel, result);
  end; }
Procedure TUsuariosController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

procedure TUsuariosController.init;
// var ref:TUsuariosView;
begin
  inherited;
  { if not assigned(FView) then
    begin
    Application.CreateForm( TUsuariosView, ref );
    supports(ref,IView,FView);
    end; }
  AfterInit;
end;

// Adicionar os modulos e MODELs personalizados
Procedure TUsuariosController.CreateModules;
begin
  // adicionar os mudulos aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

// TUsuariosController.New(TUsuariosView.New,TUsuariosViewModel.New)).init();
RegisterInterfacedClass(TUsuariosController.ClassName, IUsuariosController,
  TUsuariosController);

finalization

unRegisterInterfacedClass(TUsuariosController.ClassName);

end.
