{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 29/08/2017 22:34:39                                  // }
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
unit LiveMVC_com_ORMBr.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses

  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, MVCBr.Interf,
  FireDac.Comp.Client,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, LiveMVC_com_ORMBr.Controller.Interf,
  LiveMVC_com_ORMBrView;

type

  TLiveMVC_com_ORMBrController = class(TControllerFactory,
    ILiveMVC_com_ORMBrController, IThisAs<TLiveMVC_com_ORMBrController>)
  private
    function Connection: TFDConnection;
  protected
    FConnection: TFDConnection;
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
    function ThisAs: TLiveMVC_com_ORMBrController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;
    /// ModeAs retornar a própria interface do controller

  end;

implementation

uses
  LiveORM.Model;

/// <summary> New Connection </summary>
// var FConnection :TFDConnection; {move to right place}
function TLiveMVC_com_ORMBrController.Connection: TFDConnection;
begin
  if not assigned(FConnection) then
  begin
    FConnection := TFDConnection.Create(nil);
    FConnection.DriverName := 'FB';
    FConnection.params.Database := 'localhost:c:\dados\mvcbr.fdb';
    FConnection.params.UserName := 'sysdba';
    FConnection.params.Password := 'masterkey';
    FConnection.LoginPrompt := false;
  end;
  result := FConnection;
end;

/// Creator para a classe Controller
Constructor TLiveMVC_com_ORMBrController.Create;
begin
  inherited;
  /// Inicializar as Views...
  // %view View(TLiveMVC_com_ORMBrView.New(self));
end;

/// Finaliza o controller
Destructor TLiveMVC_com_ORMBrController.Destroy;
begin
  FConnection.free; { move to right place }
  inherited;
end;

/// Classe Function basica para criar o controller
class function TLiveMVC_com_ORMBrController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TLiveMVC_com_ORMBrController.New(const AView: IView;
  const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TLiveMVC_com_ORMBrController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TLiveMVC_com_ORMBrController.New(const AModel: IModel)
  : IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TLiveMVC_com_ORMBrController.ThisAs: TLiveMVC_com_ORMBrController;
begin
  result := self;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TLiveMVC_com_ORMBrController.init;
var
  ref: TLiveMVC_com_ORMBrView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TLiveMVC_com_ORMBrView, ref);
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
Procedure TLiveMVC_com_ORMBrController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );

  Add(TClientesModel.New(self, Connection));

end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TLiveMVC_com_ORMBrController.New(TLiveMVC_com_ORMBrView.New,TLiveMVC_com_ORMBrViewModel.New)).init();

/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TLiveMVC_com_ORMBrController.ClassName,
  ILiveMVC_com_ORMBrController, TLiveMVC_com_ORMBrController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TLiveMVC_com_ORMBrController.ClassName);

end.
