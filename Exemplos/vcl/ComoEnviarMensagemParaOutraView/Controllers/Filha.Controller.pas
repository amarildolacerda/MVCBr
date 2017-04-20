{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 17/04/2017 12:19:36                                  // }
{ //************************************************************// }
/// <summary>
/// O controller possui as seguintes características:
/// - pode possuir 1 view associado  (GetView)
/// - pode receber 0 ou mais Model   (GetModel<Ixxx>)
/// - se auto registra no application controller
/// - pode localizar controller externos e instanciá-los
/// (resolveController<I..>)
/// </summary>
unit Filha.Controller;

/// <summary>
/// Object Factory para implementar o Controller
/// </summary>
interface

{ .$I ..\inc\mvcbr.inc }
uses
  System.SysUtils, {$IFDEF LINUX} {$ELSE} {$IFDEF FMX} FMX.Forms, {$ELSE} VCL.Forms, {$ENDIF}{$ENDIF}
  System.Classes, MVCBr.Interf,
  MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
  System.RTTI, Filha.Controller.Interf,
  FilhaView;

type
  TFilhaController = class(TControllerFactory, IFilhaController, IThisAs<TFilhaController>)
  protected
    Procedure DoCommand(ACommand: string; const AArgs: array of TValue); override;
  public
    // inicializar os módulos personalizados em CreateModules
    Procedure CreateModules; virtual;
    Constructor Create; override;
    Destructor Destroy; override;
    /// New Cria nova instância para o Controller
    class function New(): IController; overload;
    class function New(const AView: IView; const AModel: IModel): IController; overload;
    class function New(const AModel: IModel): IController; overload;
    function ThisAs: TFilhaController;
    /// Init após criado a instância é chamado para concluir init
    procedure init; override;


    procedure TrocarMensagemPanel( AMsg:string );

  end;

implementation

/// Creator para a classe Controller
Constructor TFilhaController.Create;
begin
  inherited;
  /// Inicializar as Views...
  View(TFilhaView.New(self));
  /// Inicializar os modulos
  CreateModules; // < criar os modulos persolnizados
end;

/// Finaliza o controller
Destructor TFilhaController.Destroy;
begin
  inherited;
end;

/// Classe Function basica para criar o controller
class function TFilhaController.New(): IController;
begin
  result := New(nil, nil);
end;

/// Classe para criar o controller com View e Model criado
class function TFilhaController.New(const AView: IView; const AModel: IModel): IController;
var
  vm: IViewModel;
begin
  result := TFilhaController.Create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
    begin
      vm.View(AView).Controller(result);
    end;
end;

/// Classe para inicializar o Controller com um Modulo inicialz.
class function TFilhaController.New(const AModel: IModel): IController;
begin
  result := New(nil, AModel);
end;

/// Cast para a interface local do controller
function TFilhaController.ThisAs: TFilhaController;
begin
  result := self;
end;

procedure TFilhaController.TrocarMensagemPanel(AMsg: string);
begin
  TFilhaView(FView.This).Panel1.Caption := AMsg;
end;

/// Executar algum comando customizavel
Procedure TFilhaController.DoCommand(ACommand: string; const AArgs: Array of TValue);
begin
  inherited;
end;

/// Evento INIT chamado apos a inicializacao do controller
procedure TFilhaController.init;
var
  ref: TFilhaView;
begin
  inherited;
  if not assigned(FView) then
  begin
    Application.CreateForm(TFilhaView, ref);
    supports(ref, IView, FView);
{$IFDEF FMX}
    if Application.MainForm = nil then
      Application.RealCreateForms;
{$ENDIF}
  end;
  AfterInit;
end;

/// Adicionar os modulos e MODELs personalizados
Procedure TFilhaController.CreateModules;
begin
  // adicionar os seus MODELs aqui
  // exemplo: add( MeuModel.new(self) );
end;

initialization

/// Inicialização automatica do Controller ao iniciar o APP
// TFilhaController.New(TFilhaView.New,TFilhaViewModel.New)).init();
/// Registrar Interface e ClassFactory para o MVCBr
RegisterInterfacedClass(TFilhaController.ClassName, IFilhaController, TFilhaController);

finalization

/// Remover o Registro da Interface
unRegisterInterfacedClass(TFilhaController.ClassName);

end.
