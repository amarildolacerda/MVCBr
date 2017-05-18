{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 17/05/2017 23:20:36                                  //}
{//************************************************************//}
 /// <summary>
 /// O controller possui as seguintes características:
 ///   - pode possuir 1 view associado  (GetView)
 ///   - pode receber 0 ou mais Model   (GetModel<Ixxx>)
 ///   - se auto registra no application controller
 ///   - pode localizar controller externos e instanciá-los
 ///     (resolveController<I..>)
 /// </summary>
unit UsandoTemplate.Controller;
 /// <summary>
 ///    Object Factory para implementar o Controller
 /// </summary>
interface
{.$I ..\inc\mvcbr.inc}
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}  VCL.Forms,{$endif}{$endif}
System.Classes, MVCBr.Interf,
MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
System.RTTI, UsandoTemplate.Controller.interf, UsandoTemplate.ViewModel, UsandoTemplate.ViewModel.Interf,
UsandoTemplateView;
type
  TUsandoTemplateController = class(TControllerFactory,
    IUsandoTemplateController,
    IThisAs<TUsandoTemplateController>, IModelAs<IUsandoTemplateViewModel>)
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
    function ThisAs: TUsandoTemplateController;
 /// Init após criado a instância é chamado para concluir init
    procedure init;override;
 /// ModeAs retornar a própria interface do controller
    function ModelAs: IUsandoTemplateViewModel;
  end;
implementation
///  Creator para a classe Controller
Constructor TUsandoTemplateController.Create;
begin
 inherited;
  ///  Inicializar as Views...
  //%view View(TUsandoTemplateView.New(self));
  add(TUsandoTemplateViewModel.New(self).ID('{UsandoTemplate.ViewModel}'));  ///  Inicializar os modulos
 CreateModules; //< criar os modulos persolnizados
end;
///  Finaliza o controller
Destructor TUsandoTemplateController.destroy;
begin
  inherited;
end;
///  Classe Function basica para criar o controller
class function TUsandoTemplateController.New(): IController;
begin
 result := new(nil,nil);
end;
///  Classe para criar o controller com View e Model criado
class function TUsandoTemplateController.New(const AView: IView;
   const AModel: IModel) : IController;
var
  vm: IViewModel;
begin
  result := TUsandoTemplateController.create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
      begin
        vm.View(AView).Controller( result );
      end;
end;
///  Classe para inicializar o Controller com um Modulo inicialz.
class function TUsandoTemplateController.New(
   const AModel: IModel): IController;
begin
  result := new(nil,AModel);
end;
///  Cast para a interface local do controller
function TUsandoTemplateController.ThisAs: TUsandoTemplateController;
begin
   result := self;
end;
///  Cast para o ViewModel local do controller
function TUsandoTemplateController.ModelAs: IUsandoTemplateViewModel;
begin
 if count>=0 then
  supports(GetModelByType(mtViewModel), IUsandoTemplateViewModel, result);
end;
///  Executar algum comando customizavel
Procedure TUsandoTemplateController.DoCommand(ACommand: string;
   const AArgs:Array of TValue);
begin
    inherited;
end;
///  Evento INIT chamado apos a inicializacao do controller
procedure TUsandoTemplateController.init;
var ref:TUsandoTemplateView;
begin
  inherited;
 if not assigned(FView) then
 begin
   Application.CreateForm( TUsandoTemplateView, ref );
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
Procedure TUsandoTemplateController.CreateModules;
begin
   // adicionar os seus MODELs aqui
   // exemplo: add( MeuModel.new(self) );
end;
initialization
///  Inicialização automatica do Controller ao iniciar o APP
//TUsandoTemplateController.New(TUsandoTemplateView.New,TUsandoTemplateViewModel.New)).init();
///  Registrar Interface e ClassFactory para o MVCBr
  RegisterInterfacedClass(TUsandoTemplateController.ClassName,IUsandoTemplateController,TUsandoTemplateController);
finalization
///  Remover o Registro da Interface
  unRegisterInterfacedClass(TUsandoTemplateController.ClassName);
end.
