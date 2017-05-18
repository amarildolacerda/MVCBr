{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/05/2017 23:22:03                                  // }
{ //************************************************************// }
/// <summary>
/// O controller possui as seguintes características:
/// - pode possuir 1 view associado  (GetView)
/// - pode receber 0 ou mais Model   (GetModel<Ixxx>)
/// - se auto registra no application controller
/// - pode localizar controller externos e instanciá-los
/// (resolveController<I..>)
/// </summary>
unit ViewTemplate.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, ViewTemplate.Controller.Interf,
  ViewTemplateView;

type
  TViewTemplateController = class(TControllerFactory, IViewTemplateController,
    IThisAs<TViewTemplateController>)
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
    function ThisAs: TViewTemplateController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
  end;

implementation

/// Creator para a classe Controller
Constructor TViewTemplateController.Create;
begin
  inherited;
  /// Inicializar as Views...
  View(TViewTemplateView.New(self));
  /// Inicializar os modulos
  CreateModules; // < criar os modulos persolnizados
end;

/// Finaliza o controller
Destructor TViewTemplateController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TViewTemplateController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TViewTemplateController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TViewTemplateController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TViewTemplateController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TViewTemplateController.ThisAs: TViewTemplateController;
begin
  result := self;
end;

/// Executar algum comando customizavel
Procedure TViewTemplateController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TViewTemplateController.init;
var
  ref: TViewTemplateView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TViewTemplateView, ref);
    supports(ref, IView, FView);
{$IFDEF FMX}
    if Application.MainForm = nil then
      Application.RealCreateForms;
{$ENDIF}
  end;
  AfterInit;
end;

/// Adicionar os modulos e MODELs personalizados
Procedure TViewTemplateController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TViewTemplateController.New(TViewTemplateView.New,TViewTemplateViewModel.New)).init();
/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TViewTemplateController.ClassName,
  IViewTemplateController, TViewTemplateController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TViewTemplateController.ClassName);

end.
