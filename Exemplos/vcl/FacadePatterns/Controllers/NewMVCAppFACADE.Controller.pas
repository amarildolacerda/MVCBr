{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 04/07/2017 21:51:17                                  // }
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
unit NewMVCAppFACADE.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, NewMVCAppFACADE.Controller.Interf,
  NewMVCAppFACADEView;

type
  TNewMVCAppFACADEController = class(TControllerFactory, INewMVCAppFACADEController, IThisAs<TNewMVCAppFACADEController>)
  protected
  public
    // inicializar os módulos personalizados em CreateModules
    Procedure CreateModules; virtual;
    Constructor Create; override;
    Destructor Destroy; override;
    /// New Cria nova instância para o Controller
    class function New(): IController; overload;
    class function New(const AView: IView; const AModel: IModel): IController; overload;
    class function New(const AModel: IModel): IController; overload;
    function ThisAs: TNewMVCAppFACADEController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
    /// ModeAs retornar a própria interface do controller
  end;

implementation

/// Creator para a classe Controller

uses PDVSat.Model, PDVSat.Model.Interf;

Constructor TNewMVCAppFACADEController.Create;
begin
  inherited;

  add(TPDVSatModel.new(self));

  /// Inicializar as Views...
  // %view View(TNewMVCAppFACADEView.New(self));
end;

/// Finaliza o controller
Destructor TNewMVCAppFACADEController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TNewMVCAppFACADEController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TNewMVCAppFACADEController.New(const AView: IView; const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TNewMVCAppFACADEController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TNewMVCAppFACADEController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TNewMVCAppFACADEController.ThisAs: TNewMVCAppFACADEController;
begin
  result := self;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TNewMVCAppFACADEController.init;
var
  ref: TNewMVCAppFACADEView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TNewMVCAppFACADEView, ref);
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
Procedure TNewMVCAppFACADEController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TNewMVCAppFACADEController.New(TNewMVCAppFACADEView.New,TNewMVCAppFACADEViewModel.New)).init();
/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TNewMVCAppFACADEController.ClassName, INewMVCAppFACADEController, TNewMVCAppFACADEController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TNewMVCAppFACADEController.ClassName);

end.
