{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/06/2017 21:46:56                                  // }
{ //************************************************************// }
/// <summary>
/// O controller possui as seguintes características:
/// - pode possuir 1 view associado  (GetView)
/// - pode receber 0 ou mais Model   (GetModel<Ixxx>)
/// - se auto registra no application controller
/// - pode localizar controller externos e instanciá-los
/// (resolveController<I..>)
/// </summary>
unit TestView.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, TestView.Controller.Interf,
  TestViewView;

type
  TTestViewController = class(TControllerFactory, ITestViewController,
    IThisAs<TTestViewController>)
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
    function ThisAs: TTestViewController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
  end;

implementation

uses Test.Model;

/// Creator para a classe Controller
Constructor TTestViewController.Create;
begin
  inherited;
  /// Inicializar as Views...
  add(TTestModel.new(self));

  View(TTestViewView.New(self));
  /// Inicializar os modulos
  CreateModules; // < criar os modulos persolnizados
end;

/// Finaliza o controller
Destructor TTestViewController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TTestViewController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TTestViewController.New(const AView: IView; const AModel: IModel)
  : IController;
var
  vm: IViewModel;
begin
  result := TTestViewController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TTestViewController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TTestViewController.ThisAs: TTestViewController;
begin
  result := self;
end;

/// Executar algum comando customizavel
Procedure TTestViewController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TTestViewController.init;
var
  ref: TTestViewView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TTestViewView, ref);
    supports(ref, IView, FView);
{$IFDEF FMX}
    if Application.MainForm = nil then
      Application.RealCreateForms;
{$ENDIF}
  end;
  AfterInit;
end;

/// Adicionar os modulos e MODELs personalizados
Procedure TTestViewController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TTestViewController.New(TTestViewView.New,TTestViewViewModel.New)).init();
/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TTestViewController.ClassName, ITestViewController,
  TTestViewController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TTestViewController.ClassName);

end.
