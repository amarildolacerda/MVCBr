{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 10/10/2017 23:23:57                                  // }
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
unit MongoDBModel.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses

  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, MongoDBModel.Controller.Interf,
  MongoDBModelView;

type

  TMongoDBModelController = class(TControllerFactory, IMongoDBModelController,
    IThisAs<TMongoDBModelController>)
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
    function ThisAs: TMongoDBModelController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
    /// ModeAs retornar a própria interface do controller

  end;

implementation

uses
  MVCBr.MongoModel;

/// Creator para a classe Controller
Constructor TMongoDBModelController.Create;
var
  mongo: IMongoModel;
begin
  inherited;
  /// Inicializar as Views...
  // %view View(TMongoDBModelView.New(self));

  mongo := TMongoModelFactory.New(self);
  add(mongo);

  mongo.Database('mvcbrDB').Host('localhost');

end;

/// Finaliza o controller
Destructor TMongoDBModelController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TMongoDBModelController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TMongoDBModelController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TMongoDBModelController.Create as IController;
  result.View(AView).add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TMongoDBModelController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TMongoDBModelController.ThisAs: TMongoDBModelController;
begin
  result := self;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TMongoDBModelController.init;
var
  ref: TMongoDBModelView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TMongoDBModelView, ref);
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
Procedure TMongoDBModelController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TMongoDBModelController.New(TMongoDBModelView.New,TMongoDBModelViewModel.New)).init();

/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TMongoDBModelController.ClassName,
  IMongoDBModelController, TMongoDBModelController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TMongoDBModelController.ClassName);

end.
