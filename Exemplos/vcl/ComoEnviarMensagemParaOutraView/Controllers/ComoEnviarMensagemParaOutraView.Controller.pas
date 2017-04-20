{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 17/04/2017 12:17:21                                  //}
{//************************************************************//}
 /// <summary>
 /// O controller possui as seguintes características:
 ///   - pode possuir 1 view associado  (GetView)
 ///   - pode receber 0 ou mais Model   (GetModel<Ixxx>)
 ///   - se auto registra no application controller
 ///   - pode localizar controller externos e instanciá-los
 ///     (resolveController<I..>)
 /// </summary>
unit ComoEnviarMensagemParaOutraView.Controller;
 /// <summary>
 ///    Object Factory para implementar o Controller
 /// </summary>
interface
{.$I ..\inc\mvcbr.inc}
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}  VCL.Forms,{$endif}{$endif}
System.Classes, MVCBr.Interf,
MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
System.RTTI, ComoEnviarMensagemParaOutraView.Controller.interf, ComoEnviarMensagemParaOutraView.ViewModel, ComoEnviarMensagemParaOutraView.ViewModel.Interf,
ComoEnviarMensagemParaOutraViewView;
type
  TComoEnviarMensagemParaOutraViewController = class(TControllerFactory,
    IComoEnviarMensagemParaOutraViewController,
    IThisAs<TComoEnviarMensagemParaOutraViewController>, IModelAs<IComoEnviarMensagemParaOutraViewViewModel>)
  protected
    Procedure DoCommand(ACommand: string;
        const AArgs: array of TValue); override;
  public
    // inicializar os módulos personalizados em CreateModules
    Procedure CreateModules;virtual;
    Constructor Create;override;
    Destructor Destroy; override;
 /// New Cria nova instância para o Controller
    class function New(): IController; overload;
    class function New(const AView: IView; const AModel: IModel)
      : IController; overload;
    class function New(const AModel: IModel): IController; overload;
    function ThisAs: TComoEnviarMensagemParaOutraViewController;
 /// Init após criado a instância é chamado para concluir init
    procedure init;override;
 /// ModeAs retornar a própria interface do controller
    function ModelAs: IComoEnviarMensagemParaOutraViewViewModel;
  end;
implementation
///  Creator para a classe Controller
Constructor TComoEnviarMensagemParaOutraViewController.Create;
begin
 inherited;
  ///  Inicializar as Views...
  //%view View(TComoEnviarMensagemParaOutraViewView.New(self));
  add(TComoEnviarMensagemParaOutraViewViewModel.New(self).ID('{ComoEnviarMensagemParaOutraView.ViewModel}'));  ///  Inicializar os modulos
 CreateModules; //< criar os modulos persolnizados
end;
///  Finaliza o controller
Destructor TComoEnviarMensagemParaOutraViewController.destroy;
begin
  inherited;
end;
///  Classe Function basica para criar o controller
class function TComoEnviarMensagemParaOutraViewController.New(): IController;
begin
 result := new(nil,nil);
end;
///  Classe para criar o controller com View e Model criado
class function TComoEnviarMensagemParaOutraViewController.New(const AView: IView;
   const AModel: IModel) : IController;
var
  vm: IViewModel;
begin
  result := TComoEnviarMensagemParaOutraViewController.create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
      begin
        vm.View(AView).Controller( result );
      end;
end;
///  Classe para inicializar o Controller com um Modulo inicialz.
class function TComoEnviarMensagemParaOutraViewController.New(
   const AModel: IModel): IController;
begin
  result := new(nil,AModel);
end;
///  Cast para a interface local do controller
function TComoEnviarMensagemParaOutraViewController.ThisAs: TComoEnviarMensagemParaOutraViewController;
begin
   result := self;
end;
///  Cast para o ViewModel local do controller
function TComoEnviarMensagemParaOutraViewController.ModelAs: IComoEnviarMensagemParaOutraViewViewModel;
begin
 if count>=0 then
  supports(GetModelByType(mtViewModel), IComoEnviarMensagemParaOutraViewViewModel, result);
end;
///  Executar algum comando customizavel
Procedure TComoEnviarMensagemParaOutraViewController.DoCommand(ACommand: string;
   const AArgs:Array of TValue);
begin
    inherited;
end;
///  Evento INIT chamado apos a inicializacao do controller
procedure TComoEnviarMensagemParaOutraViewController.init;
var ref:TComoEnviarMensagemParaOutraViewView;
begin
  inherited;
 if not assigned(FView) then
 begin
   Application.CreateForm( TComoEnviarMensagemParaOutraViewView, ref );
   supports(ref,IView,FView);
  {$ifdef FMX}
    if Application.MainForm=nil then
      Application.RealCreateForms;
  {$endif}
 end;
 CreateModules;
 AfterInit;
end;
/// Adicionar os modulos e MODELs personalizados
Procedure TComoEnviarMensagemParaOutraViewController.CreateModules;
begin
   // adicionar os seus MODELs aqui
   // exemplo: add( MeuModel.new(self) );
end;
initialization
///  Inicialização automatica do Controller ao iniciar o APP
//TComoEnviarMensagemParaOutraViewController.New(TComoEnviarMensagemParaOutraViewView.New,TComoEnviarMensagemParaOutraViewViewModel.New)).init();
///  Registrar Interface e ClassFactory para o MVCBr
  RegisterInterfacedClass(TComoEnviarMensagemParaOutraViewController.ClassName,IComoEnviarMensagemParaOutraViewController,TComoEnviarMensagemParaOutraViewController);
finalization
///  Remover o Registro da Interface
  unRegisterInterfacedClass(TComoEnviarMensagemParaOutraViewController.ClassName);
end.
