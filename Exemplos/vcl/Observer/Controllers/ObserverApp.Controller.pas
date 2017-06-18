{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 18/06/2017 15:57:22                                  //}
{//************************************************************//}
 /// <summary>
 /// O controller possui as seguintes características:
 ///   - pode possuir 1 view associado  (GetView)
 ///   - pode receber 0 ou mais Model   (GetModel<Ixxx>)
 ///   - se auto registra no application controller
 ///   - pode localizar controller externos e instanciá-los
 ///     (resolveController<I..>)
 /// </summary>
unit ObserverApp.Controller;
 /// <summary>
 ///    Object Factory para implementar o Controller
 /// </summary>
interface
{.$I ..\inc\mvcbr.inc}
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}  VCL.Forms,{$endif}{$endif}
System.Classes, MVCBr.Interf,
MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
System.RTTI, ObserverApp.Controller.interf, ObserverApp.ViewModel, ObserverApp.ViewModel.Interf,
ObserverAppView;
type
  TObserverAppController = class(TControllerFactory,
    IObserverAppController,
    IThisAs<TObserverAppController>, IModelAs<IObserverAppViewModel>)
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
    function ThisAs: TObserverAppController;
 /// Init após criado a instância é chamado para concluir init
    procedure init;override;
 /// ModeAs retornar a própria interface do controller
    function ModelAs: IObserverAppViewModel;
  end;
implementation
///  Creator para a classe Controller
Constructor TObserverAppController.Create;
begin
 inherited;
  ///  Inicializar as Views...
  //%view View(TObserverAppView.New(self));
  add(TObserverAppViewModel.New(self).ID('{ObserverApp.ViewModel}'));  ///  Inicializar os modulos
 CreateModules; //< criar os modulos persolnizados
end;
///  Finaliza o controller
Destructor TObserverAppController.destroy;
begin
  inherited;
end;
///  Classe Function basica para criar o controller
class function TObserverAppController.New(): IController;
begin
 result := new(nil,nil);
end;
///  Classe para criar o controller com View e Model criado
class function TObserverAppController.New(const AView: IView;
   const AModel: IModel) : IController;
var
  vm: IViewModel;
begin
  result := TObserverAppController.create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
      begin
        vm.View(AView).Controller( result );
      end;
end;
///  Classe para inicializar o Controller com um Modulo inicialz.
class function TObserverAppController.New(
   const AModel: IModel): IController;
begin
  result := new(nil,AModel);
end;
///  Cast para a interface local do controller
function TObserverAppController.ThisAs: TObserverAppController;
begin
   result := self;
end;
///  Cast para o ViewModel local do controller
function TObserverAppController.ModelAs: IObserverAppViewModel;
begin
 if count>=0 then
  supports(GetModelByType(mtViewModel), IObserverAppViewModel, result);
end;
///  Executar algum comando customizavel
Procedure TObserverAppController.DoCommand(ACommand: string;
   const AArgs:Array of TValue);
begin
    inherited;
end;
///  Evento INIT chamado apos a inicializacao do controller
procedure TObserverAppController.init;
var ref:TObserverAppView;
begin
  inherited;
 if not assigned(FView) then
 begin
   Application.CreateForm( TObserverAppView, ref );
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
Procedure TObserverAppController.CreateModules;
begin
   // adicionar os seus MODELs aqui
   // exemplo: add( MeuModel.new(self) );
end;
initialization
///  Inicialização automatica do Controller ao iniciar o APP
//TObserverAppController.New(TObserverAppView.New,TObserverAppViewModel.New)).init();
///  Registrar Interface e ClassFactory para o MVCBr
  RegisterInterfacedClass(TObserverAppController.ClassName,IObserverAppController,TObserverAppController);
finalization
///  Remover o Registro da Interface
  unRegisterInterfacedClass(TObserverAppController.ClassName);
end.
