{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br                                // }
{ //************************************************************// }
{ // Data: 02/02/2017 22:16:22                                                // }
{ //************************************************************// }
unit Grupo.Controller;

interface

{ .$I ..\inc\mvcbr.inc }
uses
  SysUtils, forms, buttons, classes, controls, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI,
  Grupo.ViewModel, Grupo.ViewModel.Interf, GrupoView;

type
  IGrupoController = interface(IController)
    ['{1A282FC6-C26F-4D8B-A82B-FA3818CC4377}']
    // incluir especializações aqui
  end;

  TGrupoController = class(TControllerFactory, IGrupoController,
    IThisAs<TGrupoController>, IModelAs<IGrupoViewModel>)
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
    function ThisAs: TGrupoController;
    procedure init; override;
    function ModelAs: IGrupoViewModel;
  end;

implementation

uses TabGrupo.ModuleModel;

/// Creator para a classe Controller
Constructor TGrupoController.Create;
begin
  inherited;
  /// Inicializar as Views...
  add(TGrupoViewModel.New(self).ID('{Grupo.ViewModel}'));
  /// Inicializar os modulos
  CreateModules; // < criar os modulos persolnizados
end;

/// Finaliza o controller
Destructor TGrupoController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TGrupoController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TGrupoController.New(const AView: IView; const AModel: IModel)
  : IController;
var
  vm: IViewModel;
begin
  result := TGrupoController.Create as IController;
  result.View(AView).add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TGrupoController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TGrupoController.ThisAs: TGrupoController;
begin
  result := self;
end;

/// Cast para o ViewModel local do controller
function TGrupoController.ModelAs: IGrupoViewModel;
begin
  if count >= 0 then
    supports(GetModelByType(mtViewModel), IGrupoViewModel, result);
end;

/// Executar algum comando customizavel
Procedure TGrupoController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TGrupoController.init;
var
  ref: TGrupoView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TGrupoView, ref);
    supports(ref, IView, FView);
  end;
  AfterInit;
end;

/// Adicionar os modulos e MODELs personalizados
Procedure TGrupoController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );

  add( TTabGrupoModuleModel.new(self));

end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TGrupoController.New(TGrupoView.New,TGrupoViewModel.New)).init();
/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TGrupoController.ClassName, IGrupoController,
  TGrupoController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TGrupoController.ClassName);

end.
