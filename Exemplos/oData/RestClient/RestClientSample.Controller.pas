{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 10/03/2017 19:20:21                                  // }
{ //************************************************************// }
/// <summary>
/// O controller possui as seguintes características:
/// - pode possuir 1 view associado  (GetView)
/// - pode receber 0 ou mais Model   (GetModel<Ixxx>)
/// - se auto registra no application controller
/// - pode localizar controller externos e instanciá-los
/// (resolveController<I..>)
/// </summary>
unit RestClientSample.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, RestClientSample.Controller.Interf, RestClientSample.ViewModel,
  RestClientSample.ViewModel.Interf,
  RestClientSampleView;

type
  TRestClientSampleController = class(TControllerFactory,
    IRestClientSampleController, IThisAs<TRestClientSampleController>,
    IModelAs<IRestClientSampleViewModel>)
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
    function ThisAs: TRestClientSampleController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
    /// ModeAs retornar a própria interface do controller
    function ModelAs: IRestClientSampleViewModel;
  end;

implementation

/// Creator para a classe Controller
Constructor TRestClientSampleController.Create;
begin
  inherited;
  /// Inicializar as Views...
  // %view View(TRestClientSampleView.New(self));
  add(TRestClientSampleViewModel.New(self).ID('{RestClientSample.ViewModel}'));
  /// Inicializar os modulos
  CreateModules; // < criar os modulos persolnizados
end;

/// Finaliza o controller
Destructor TRestClientSampleController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TRestClientSampleController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TRestClientSampleController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TRestClientSampleController.Create as IController;
  result.View(AView).add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TRestClientSampleController.New(const AModel: IModel)
  : IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TRestClientSampleController.ThisAs: TRestClientSampleController;
begin
  result := self;
end;

/// Cast para o ViewModel local do controller
function TRestClientSampleController.ModelAs: IRestClientSampleViewModel;
begin
  if count >= 0 then
    supports(GetModelByType(mtViewModel), IRestClientSampleViewModel, result);
end;

/// Executar algum comando customizavel
Procedure TRestClientSampleController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TRestClientSampleController.init;
var
  ref: TRestClientSampleView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TRestClientSampleView, ref);
    supports(ref, IView, FView);
{$IFDEF FMX}
    if Application.MainForm = nil then
      Application.RealCreateForms;
{$ENDIF}
  end;
  AfterInit;
end;

/// Adicionar os modulos e MODELs personalizados
Procedure TRestClientSampleController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TRestClientSampleController.New(TRestClientSampleView.New,TRestClientSampleViewModel.New)).init();
/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TRestClientSampleController.ClassName,
  IRestClientSampleController, TRestClientSampleController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TRestClientSampleController.ClassName);

end.
