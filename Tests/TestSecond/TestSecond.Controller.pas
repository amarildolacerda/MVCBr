{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 15/06/2017 21:47:37                                  // }
{ //************************************************************// }
/// <summary>
/// O controller possui as seguintes características:
/// - pode possuir 1 view associado  (GetView)
/// - pode receber 0 ou mais Model   (GetModel<Ixxx>)
/// - se auto registra no application controller
/// - pode localizar controller externos e instanciá-los
/// (resolveController<I..>)
/// </summary>
unit TestSecond.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, TestSecond.Controller.Interf,
  TestSecondView;

type

  TTestSecondController = class(TControllerFactory, ITestSecondController,
    IThisAs<TTestSecondController>)
  protected
    FContador:integer;
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
    function ThisAs: TTestSecondController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
    function GetStubInt:integer;
    procedure IncContador;
  end;


  TTestSecondController2 = class(TControllerFactory,ITestSecondController2)
   private
   FContador:integer;
   public
       function GetStubInt2:integer;
       destructor Destroy;override;
    function GetStubInt:integer;
    procedure IncContador;
  end;

implementation

uses Test.Model;

/// Creator para a classe Controller
Constructor TTestSecondController.Create;
begin
  inherited;
  FContador := 1;
  /// Inicializar as Views...
  add(TTestModel.new(self));

  View(TTestSecondView.New(self));
  /// Inicializar os modulos
  CreateModules; // < criar os modulos persolnizados
end;

/// Finaliza o controller
Destructor TTestSecondController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TTestSecondController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TTestSecondController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TTestSecondController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TTestSecondController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TTestSecondController.ThisAs: TTestSecondController;
begin
  result := self;
end;

/// Executar algum comando customizavel
Procedure TTestSecondController.DoCommand(ACommand: string;
  const AArgs: Array of TValue);
begin
  inherited;
end;

function TTestSecondController.GetStubInt: integer;
begin
  result := FContador;
end;

procedure TTestSecondController.IncContador;
begin
  inc(FContador);
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TTestSecondController.init;
var
  ref: TTestSecondView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TTestSecondView, ref);
    supports(ref, IView, FView);
{$IFDEF FMX}
    if Application.MainForm = nil then
      Application.RealCreateForms;
{$ENDIF}
  end;
  AfterInit;
end;

/// Adicionar os modulos e MODELs personalizados
Procedure TTestSecondController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );


end;

{ TTestSecondController2 }

destructor TTestSecondController2.Destroy;
begin

  inherited;
end;

function TTestSecondController2.GetStubInt: integer;
begin
   result := FContador;
end;

function TTestSecondController2.GetStubInt2: integer;
begin
  result := FContador;
end;

procedure TTestSecondController2.IncContador;
begin
  inc(FContador);
end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TTestSecondController.New(TTestSecondView.New,TTestSecondViewModel.New)).init();
/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TTestSecondController.ClassName, ITestSecondController,
  TTestSecondController);
RegisterInterfacedClass(TTestSecondController2.ClassName, ITestSecondController2,
  TTestSecondController2);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TTestSecondController.ClassName);

end.
