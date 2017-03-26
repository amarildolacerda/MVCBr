{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 26/03/2017 11:40:55                                  // }
{ //************************************************************// }
/// <summary>
/// O controller possui as seguintes características:
/// - pode possuir 1 view associado  (GetView)
/// - pode receber 0 ou mais Model   (GetModel<Ixxx>)
/// - se auto registra no application controller
/// - pode localizar controller externos e instanciá-los
/// (resolveController<I..>)
/// </summary>
unit FormChildSample.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, FormChildSample.Controller.Interf, FormChildSample.ViewModel,
  FormChildSample.ViewModel.Interf,
  FormChildSampleView;

type
  TFormChildSampleController = class(TControllerFactory,
    IFormChildSampleController, IThisAs<TFormChildSampleController>,
    IModelAs<IFormChildSampleViewModel>)
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
    function ThisAs: TFormChildSampleController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
    /// ModeAs retornar a própria interface do controller
    function ModelAs: IFormChildSampleViewModel;
  end;

implementation

uses RegrasNegocios.Model;

/// Creator para a classe Controller
Constructor TFormChildSampleController.Create;
begin
  inherited;
  /// Inicializar as Views...
  // %view View(TFormChildSampleView.New(self));
  add(TFormChildSampleViewModel.New(self).ID('{FormChildSample.ViewModel}'));
  /// Inicializar os modulos
  CreateModules; // < criar os modulos persolnizados
end;

/// Finaliza o controller
Destructor TFormChildSampleController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TFormChildSampleController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TFormChildSampleController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TFormChildSampleController.Create as IController;
  result.View(AView).add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TFormChildSampleController.New(const AModel: IModel)
  : IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TFormChildSampleController.ThisAs: TFormChildSampleController;
begin
  result := self;
end;

/// Cast para o ViewModel local do controller
function TFormChildSampleController.ModelAs: IFormChildSampleViewModel;
begin
  if count >= 0 then
    supports(GetModelByType(mtViewModel), IFormChildSampleViewModel, result);
end;

/// Executar algum comando customizavel
Procedure TFormChildSampleController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TFormChildSampleController.init;
var
  ref: TFormChildSampleView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TFormChildSampleView, ref);
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
Procedure TFormChildSampleController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );

  add( TRegrasNegociosModel.new(self)  );

end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TFormChildSampleController.New(TFormChildSampleView.New,TFormChildSampleViewModel.New)).init();
/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TFormChildSampleController.ClassName,
  IFormChildSampleController, TFormChildSampleController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TFormChildSampleController.ClassName);

end.
