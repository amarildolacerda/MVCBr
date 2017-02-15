{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 13/02/2017 23:07:44                                  //}
{//************************************************************//}
 /// <summary>
 /// O controller possui as seguintes características:
 ///   - pode possuir 1 view associado  (GetView)
 ///   - pode receber 0 ou mais Model   (GetModel<Ixxx>)
 ///   - se auto registra no application controller
 ///   - pode localizar controller externos e instanciá-los
 ///     (resolveController<I..>)
 /// </summary>
unit AppPageControl.Controller;
 /// <summary>
 ///    Object Factory para implementar o Controller
 /// </summary>
interface
{.$I ..\inc\mvcbr.inc}
uses
System.SysUtils, {$ifdef FMX} FMX.Forms,{$else}  VCL.Forms,{$endif}
System.Classes, MVCBr.Interf,
MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
System.RTTI, AppPageControl.Controller.interf,
AppPageControl.ViewModel, AppPageControl.ViewModel.Interf,AppPageControlView;
type
  TAppPageControlController = class(TControllerFactory,
    IAppPageControlController,
    IThisAs<TAppPageControlController>, IModelAs<IAppPageControlViewModel>)
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
    function ThisAs: TAppPageControlController;
 /// Init após criado a instância é chamado para concluir init
    procedure init;override;
 /// ModeAs retornar a própria interface do controller
    function ModelAs: IAppPageControlViewModel;
  end;
implementation
///  Creator para a classe Controller
Constructor TAppPageControlController.Create;
begin
 inherited;
 ///  Inicializar as Views...
 add(TAppPageControlViewModel.New(self).ID('{AppPageControl.ViewModel}')); ///  Inicializar os modulos
 CreateModules; //< criar os modulos persolnizados
end;
///  Finaliza o controller
Destructor TAppPageControlController.destroy;
begin
  inherited;
end;
///  Classe Function basica para criar o controller
class function TAppPageControlController.New(): IController;
begin
 result := new(nil,nil);
end;
///  Classe para criar o controller com View e Model criado
class function TAppPageControlController.New(const AView: IView;
   const AModel: IModel) : IController;
var
  vm: IViewModel;
begin
  result := TAppPageControlController.create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
      begin
        vm.View(AView).Controller( result );
      end;
end;
///  Classe para inicializar o Controller com um Modulo inicialz.
class function TAppPageControlController.New(
   const AModel: IModel): IController;
begin
  result := new(nil,AModel);
end;
///  Cast para a interface local do controller
function TAppPageControlController.ThisAs: TAppPageControlController;
begin
   result := self;
end;
///  Cast para o ViewModel local do controller
function TAppPageControlController.ModelAs: IAppPageControlViewModel;
begin
 if count>=0 then
  supports(GetModelByType(mtViewModel), IAppPageControlViewModel, result);
end;
///  Executar algum comando customizavel
Procedure TAppPageControlController.DoCommand(ACommand: string;
   const AArgs:Array of TValue);
begin
    inherited;
end;
///  Evento INIT chamado apos a inicializacao do controller
procedure TAppPageControlController.init;
var ref:TAppPageControlView;
begin
  inherited;
 if not assigned(FView) then
 begin
   Application.CreateForm( TAppPageControlView, ref );
   supports(ref,IView,FView);
  {$ifdef FMX}
    if Application.MainForm=nil then
      Application.RealCreateForms;
  {$endif}
 end;
 AfterInit;
end;
/// Adicionar os modulos e MODELs personalizados
Procedure TAppPageControlController.CreateModules;
begin
   // adicionar os seus MODELs aqui
   // exemplo: add( MeuModel.new(self) );
end;
initialization
///  Inicialização automatica do Controller ao iniciar o APP
//TAppPageControlController.New(TAppPageControlView.New,TAppPageControlViewModel.New)).init();
///  Registrar Interface e ClassFactory para o MVCBr
  RegisterInterfacedClass(TAppPageControlController.ClassName,IAppPageControlController,TAppPageControlController);
finalization
///  Remover o Registro da Interface
  unRegisterInterfacedClass(TAppPageControlController.ClassName);
end.
