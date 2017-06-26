{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 08/04/2017 14:51:23                                  // }
{ //************************************************************// }
/// <summary>
/// O controller possui as seguintes características:
/// - pode possuir 1 view associado  (GetView)
/// - pode receber 0 ou mais Model   (GetModel<Ixxx>)
/// - se auto registra no application controller
/// - pode localizar controller externos e instanciá-los
/// (resolveController<I..>)
/// </summary>
unit eFinPrice.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, eFinPrice.Controller.Interf, eFinPrice.ViewModel,
  eFinPrice.ViewModel.Interf,
  eFinPriceView;

type
  TeFinPriceController = class(TControllerFactory, IeFinPriceController,
    IThisAs<TeFinPriceController>, IModelAs<IeFinPriceViewModel>)
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
    function ThisAs: TeFinPriceController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
    /// ModeAs retornar a própria interface do controller
    function ModelAs: IeFinPriceViewModel;
  end;

implementation

/// Creator para a classe Controller
Constructor TeFinPriceController.Create;
begin
  inherited;
  /// Inicializar as Views...
  // %view View(TeFinPriceView.New(self));
  add(TeFinPriceViewModel.New(self).ID('{eFinPrice.ViewModel}'));
  /// Inicializar os modulos
  /// CreateModules; // < criar os modulos persolnizados
end;

/// Finaliza o controller
Destructor TeFinPriceController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TeFinPriceController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TeFinPriceController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TeFinPriceController.Create as IController;
  result.View(AView).add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TeFinPriceController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TeFinPriceController.ThisAs: TeFinPriceController;
begin
  result := self;
end;

/// Cast para o ViewModel local do controller
function TeFinPriceController.ModelAs: IeFinPriceViewModel;
begin
  if count >= 0 then
    supports(GetModelByType(mtViewModel), IeFinPriceViewModel, result);
end;

/// Executar algum comando customizavel
Procedure TeFinPriceController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TeFinPriceController.init;
var
  ref: TeFinPriceView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TeFinPriceView, ref);
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
Procedure TeFinPriceController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TeFinPriceController.New(TeFinPriceView.New,TeFinPriceViewModel.New)).init();
/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TeFinPriceController.ClassName, IeFinPriceController,
  TeFinPriceController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TeFinPriceController.ClassName);

end.
