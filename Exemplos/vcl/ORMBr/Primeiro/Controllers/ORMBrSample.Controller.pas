{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 27/08/2017 11:16:02                                  // }
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
unit ORMBrSample.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses

  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, ORMBrSample.Controller.Interf,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, ORMBrSampleView;

type

  TORMBrSampleController = class(TControllerFactory, IORMBrSampleController,
    IThisAs<TORMBrSampleController>)
  protected
    FConnection: TFDConnection;
  public
    function Connection: TFDConnection;
    // inicializar os módulos personalizados em CreateModules
    Procedure CreateModules; virtual;
    Constructor Create; override;
    Destructor Destroy; override;
    /// New Cria nova instância para o Controller
    class function New(): IController; overload;
    class function New(const AView: IView; const AModel: IModel)
      : IController; overload;
    class function New(const AModel: IModel): IController; overload;
    function ThisAs: TORMBrSampleController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
    /// ModeAs retornar a própria interface do controller

  end;

implementation

uses ORMBrClienteModel;

function TORMBrSampleController.Connection: TFDConnection;
begin
  if not assigned(FConnection) then
  begin
    FConnection := TFDConnection.Create(nil);
    FConnection.DriverName := 'FB';
    FConnection.params.Database := 'c:\dados\mvcbr.fdb';
    FConnection.params.UserName := 'sysdba';
    FConnection.params.Password := 'masterkey';
    FConnection.LoginPrompt := false;
  end;
  result := FConnection;
end;

/// Creator para a classe Controller

Constructor TORMBrSampleController.Create;
begin
  inherited;
  /// Inicializar as Views...
  // %view View(TORMBrSampleView.New(self));
end;

/// Finaliza o controller
Destructor TORMBrSampleController.Destroy;
begin
  FreeAndNil(FConnection);
  inherited;
end;

/// Classe Function basica para criar o controller
class function TORMBrSampleController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TORMBrSampleController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TORMBrSampleController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TORMBrSampleController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TORMBrSampleController.ThisAs: TORMBrSampleController;
begin
  result := self;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TORMBrSampleController.init;
var
  ref: TORMBrSampleView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TORMBrSampleView, ref);
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
Procedure TORMBrSampleController.CreateModules;
begin
  Add(TClientesFactoryModel.New(self, Connection));

  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TORMBrSampleController.New(TORMBrSampleView.New,TORMBrSampleViewModel.New)).init();

/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TORMBrSampleController.ClassName,
  IORMBrSampleController, TORMBrSampleController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TORMBrSampleController.ClassName);

end.
