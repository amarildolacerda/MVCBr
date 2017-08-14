{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 09/07/2017 21:16:53                                  // }
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
unit SegundoForm.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses

  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, SegundoForm.Controller.Interf,
  SegundoFormView;

type

  TSegundoFormController = class(TControllerFactory, ISegundoFormController,
    IThisAs<TSegundoFormController>)
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
    function ThisAs: TSegundoFormController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
  end;

implementation

/// Creator para a classe Controller
Constructor TSegundoFormController.Create;
begin
  inherited;
  /// Inicializar as Views...
  View(TSegundoFormView.New(self));
end;

/// Finaliza o controller
Destructor TSegundoFormController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TSegundoFormController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TSegundoFormController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TSegundoFormController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TSegundoFormController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TSegundoFormController.ThisAs: TSegundoFormController;
begin
  result := self;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TSegundoFormController.init;
var
  ref: TSegundoFormView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TSegundoFormView, ref);
    supports(ref, IView, FView);
{$IFDEF FMX}
    if Application.MainForm = nil then
      Application.RealCreateForms;
{$ENDIF}
  end;
  CreateModules; // < criar os modulos persolnizados

  AfterInit;
end;

/// Adicionar os modulos e MODELs personalizados
Procedure TSegundoFormController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TSegundoFormController.New(TSegundoFormView.New,TSegundoFormViewModel.New)).init();

/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TSegundoFormController.ClassName,
  ISegundoFormController, TSegundoFormController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TSegundoFormController.ClassName);

end.
