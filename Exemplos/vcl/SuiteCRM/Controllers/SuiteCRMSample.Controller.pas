{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 05/05/2017 14:43:06                                  // }
{ //************************************************************// }
/// <summary>
/// O controller possui as seguintes características:
/// - pode possuir 1 view associado  (GetView)
/// - pode receber 0 ou mais Model   (GetModel<Ixxx>)
/// - se auto registra no application controller
/// - pode localizar controller externos e instanciá-los
/// (resolveController<I..>)
/// </summary>
unit SuiteCRMSample.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, SuiteCRMSample.Controller.Interf, SuiteCRMSample.ViewModel,
  SuiteCRMSample.ViewModel.Interf,
  SuiteCRMSampleView;

type
  TSuiteCRMSampleController = class(TControllerFactory,
    ISuiteCRMSampleController, IThisAs<TSuiteCRMSampleController>,
    IModelAs<ISuiteCRMSampleViewModel>)
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
    function ThisAs: TSuiteCRMSampleController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
    /// ModeAs retornar a própria interface do controller
    function ModelAs: ISuiteCRMSampleViewModel;
  end;

implementation

uses SuiteCRM.Model;

/// Creator para a classe Controller
Constructor TSuiteCRMSampleController.Create;
begin
  inherited;
  /// Inicializar as Views...
  // %view View(TSugarCRMSampleView.New(self));
  add(TSugarCRMSampleViewModel.New(self).ID('{SugarCRMSample.ViewModel}'));
  /// Inicializar os modulos
  CreateModules; // < criar os modulos persolnizados
end;

/// Finaliza o controller
Destructor TSuiteCRMSampleController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TSuiteCRMSampleController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TSuiteCRMSampleController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TSuiteCRMSampleController.Create as IController;
  result.View(AView).add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TSuiteCRMSampleController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TSuiteCRMSampleController.ThisAs: TSuiteCRMSampleController;
begin
  result := self;
end;

/// Cast para o ViewModel local do controller
function TSuiteCRMSampleController.ModelAs: ISuiteCRMSampleViewModel;
begin
  if count >= 0 then
    supports(GetModelByType(mtViewModel), ISuiteCRMSampleViewModel, result);
end;

/// Executar algum comando customizavel
Procedure TSuiteCRMSampleController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TSuiteCRMSampleController.init;
var
  ref: TSugarCRMSampleView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TSugarCRMSampleView, ref);
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
Procedure TSuiteCRMSampleController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  add(TSuiteCRMModel.New(self));
end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TSugarCRMSampleController.New(TSugarCRMSampleView.New,TSugarCRMSampleViewModel.New)).init();
/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TSuiteCRMSampleController.ClassName,
  ISuiteCRMSampleController, TSuiteCRMSampleController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TSuiteCRMSampleController.ClassName);

end.
