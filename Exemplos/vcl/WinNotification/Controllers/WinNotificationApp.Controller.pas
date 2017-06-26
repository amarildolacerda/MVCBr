{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 21/06/2017 18:38:16                                  // }
{ //************************************************************// }
/// <summary>
/// O controller possui as seguintes características:
/// - pode possuir 1 view associado  (GetView)
/// - pode receber 0 ou mais Model   (GetModel<Ixxx>)
/// - se auto registra no application controller
/// - pode localizar controller externos e instanciá-los
/// (resolveController<I..>)
/// </summary>
unit WinNotificationApp.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, WinNotificationApp.Controller.Interf,
  {WinNotificationApp.ViewModel, WinNotificationApp.ViewModel.Interf,
  }
  WinNotificationAppView;

type
  TWinNotificationAppController = class(TControllerFactory,
    IWinNotificationAppController, IThisAs<TWinNotificationAppController>{,
    {IModelAs<IWinNotificationAppViewModel>})
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
    function ThisAs: TWinNotificationAppController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
    /// ModeAs retornar a própria interface do controller
    //function ModelAs: IWinNotificationAppViewModel;
  end;

implementation

uses WinNotification.Model;

/// Creator para a classe Controller
Constructor TWinNotificationAppController.Create;
begin
  inherited;
  /// Inicializar as Views...
  // %view View(TWinNotificationAppView.New(self));
  //add(TWinNotificationAppViewModel.New(self)
  //  .ID('{WinNotificationApp.ViewModel}'));
  /// Inicializar os modulos
end;

/// Finaliza o controller
Destructor TWinNotificationAppController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TWinNotificationAppController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TWinNotificationAppController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TWinNotificationAppController.Create as IController;
  result.View(AView).add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TWinNotificationAppController.New(const AModel: IModel)
  : IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TWinNotificationAppController.ThisAs: TWinNotificationAppController;
begin
  result := self;
end;

/// Cast para o ViewModel local do controller
{function TWinNotificationAppController.ModelAs: IWinNotificationAppViewModel;
begin
  if count >= 0 then
    supports(GetModelByType(mtViewModel), IWinNotificationAppViewModel, result);
end;
}
/// Executar algum comando customizavel
Procedure TWinNotificationAppController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TWinNotificationAppController.init;
var
  ref: TWinNotificationAppView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TWinNotificationAppView, ref);
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
Procedure TWinNotificationAppController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );
  add(TWinNotificationModel.New(self));

end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TWinNotificationAppController.New(TWinNotificationAppView.New,TWinNotificationAppViewModel.New)).init();
/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TWinNotificationAppController.ClassName,
  IWinNotificationAppController, TWinNotificationAppController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TWinNotificationAppController.ClassName);

end.
