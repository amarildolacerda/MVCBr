{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 29/09/2017 21:07:48                                  // }
{ //************************************************************// }

/// <summary>
/// O controller possui as seguintes características:
/// - pode possuir 1 view associado  (GetView)
/// - pode receber 0 ou mais Model   (GetModel<Ixxx>)
/// - se auto registra no application controller
/// - pode localizar controller externos e instanciá-los
/// (resolveController<I..>)
/// </summary>
{ auth }
unit EvolucaoPopulacional.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses

  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, EvolucaoPopulacional.Controller.Interf,
  EvolucaoPopulacionalView;

type

  TEvolucaoPopulacionalController = class(TControllerFactory,
    IEvolucaoPopulacionalController, IThisAs<TEvolucaoPopulacionalController>)
  protected
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
    function ThisAs: TEvolucaoPopulacionalController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
    /// ModeAs retornar a própria interface do controller

    procedure Notification(AName,ASubject,AMessage: string);

  end;

implementation

uses
  Dados.Model, Dados.Model.Interf, WinNotification.Model,
  WinNotification.Model.Interf;

/// Creator para a classe Controller
Constructor TEvolucaoPopulacionalController.Create;
begin
  inherited;
  Add(TDadosModel.New(self));
  Add(TWinNotificationModel.New(self));
  /// Inicializar as Views...
  // %view View(TEvolucaoPopulacionalView.New(self));
end;

/// Finaliza o controller
Destructor TEvolucaoPopulacionalController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TEvolucaoPopulacionalController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TEvolucaoPopulacionalController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TEvolucaoPopulacionalController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TEvolucaoPopulacionalController.New(const AModel: IModel)
  : IController;
begin
  result := New(nil, AModel);
end;

procedure TEvolucaoPopulacionalController.Notification(AName,ASubject,AMessage: string);
begin
  getModel<IWinNotificationModel>.Send(AName,ASubject,AMessage);
end;

/// Cast para a interface local do controller
function TEvolucaoPopulacionalController.ThisAs
  : TEvolucaoPopulacionalController;
begin
  result := self;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TEvolucaoPopulacionalController.init;
var
  ref: TEvolucaoPopulacionalView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TEvolucaoPopulacionalView, ref);
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
Procedure TEvolucaoPopulacionalController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TEvolucaoPopulacionalController.New(TEvolucaoPopulacionalView.New,TEvolucaoPopulacionalViewModel.New)).init();

/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TEvolucaoPopulacionalController.ClassName,
  IEvolucaoPopulacionalController, TEvolucaoPopulacionalController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TEvolucaoPopulacionalController.ClassName);

end.
