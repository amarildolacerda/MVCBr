{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 01/05/2017 11:08:32                                  // }
{ //************************************************************// }
/// <summary>
/// O controller possui as seguintes características:
/// - pode possuir 1 view associado  (GetView)
/// - pode receber 0 ou mais Model   (GetModel<Ixxx>)
/// - se auto registra no application controller
/// - pode localizar controller externos e instanciá-los
/// (resolveController<I..>)
/// </summary>
unit WooCommerceSample.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, WooCommerceSample.Controller.Interf, WooCommerceSample.ViewModel,
  WooCommerceSample.ViewModel.Interf,
  WooCommerceSampleView;

type
  TWooCommerceSampleController = class(TControllerFactory,
    IWooCommerceSampleController, IThisAs<TWooCommerceSampleController>,
    IModelAs<IWooCommerceSampleViewModel>)
  protected
    Procedure DoCommand(ACommand: string;
      const AArgs: array of TValue); override;
  public
    // inicializar os módulos personalizados em CreateModules
    Procedure CreateModules; virtual;
    Constructor Create; override;
    Destructor Destroy; override;
    /// New Cria nova instância para o Controller
    class function New(): IController; overload;
    class function New(const AView: IView; const AModel: IModel)
      : IController; overload;
    class function New(const AModel: IModel): IController; overload;
    function ThisAs: TWooCommerceSampleController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
    /// ModeAs retornar a própria interface do controller
    function ModelAs: IWooCommerceSampleViewModel;
  end;

implementation

uses WooCommerce.Model;

/// Creator para a classe Controller
Constructor TWooCommerceSampleController.Create;
begin
  inherited;
  /// Inicializar as Views...
  // %view View(TWooCommerceSampleView.New(self));
  add(TWooCommerceSampleViewModel.New(self)
    .ID('{WooCommerceSample.ViewModel}'));
  /// Inicializar os modulos
  CreateModules; // < criar os modulos persolnizados
end;

/// Finaliza o controller
Destructor TWooCommerceSampleController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TWooCommerceSampleController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TWooCommerceSampleController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TWooCommerceSampleController.Create as IController;
  result.View(AView).add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TWooCommerceSampleController.New(const AModel: IModel)
  : IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TWooCommerceSampleController.ThisAs: TWooCommerceSampleController;
begin
  result := self;
end;

/// Cast para o ViewModel local do controller
function TWooCommerceSampleController.ModelAs: IWooCommerceSampleViewModel;
begin
  if count >= 0 then
    supports(GetModelByType(mtViewModel), IWooCommerceSampleViewModel, result);
end;

/// Executar algum comando customizavel
Procedure TWooCommerceSampleController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TWooCommerceSampleController.init;
var
  ref: TWooCommerceSampleView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TWooCommerceSampleView, ref);
    supports(ref, IView, FView);
{$IFDEF FMX}
    if Application.MainForm = nil then
      Application.RealCreateForms;
{$ENDIF}
  end;
  CreateModules;
  AfterInit;
end;

/// Adicionar os modulos e MODELs personalizados
Procedure TWooCommerceSampleController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );


  ///  Inicializa o MODEL WooCommerce
  add(TWooCommerceModel.New(self));

end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TWooCommerceSampleController.New(TWooCommerceSampleView.New,TWooCommerceSampleViewModel.New)).init();
/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TWooCommerceSampleController.ClassName,
  IWooCommerceSampleController, TWooCommerceSampleController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TWooCommerceSampleController.ClassName);

end.
