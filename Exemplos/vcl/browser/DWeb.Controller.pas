{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 19/02/2017 19:35:38                                  //}
{//************************************************************//}
 /// <summary>
 /// O controller possui as seguintes características:
 ///   - pode possuir 1 view associado  (GetView)
 ///   - pode receber 0 ou mais Model   (GetModel<Ixxx>)
 ///   - se auto registra no application controller
 ///   - pode localizar controller externos e instanciá-los
 ///     (resolveController<I..>)
 /// </summary>
unit DWeb.Controller;
 /// <summary>
 ///    Object Factory para implementar o Controller
 /// </summary>
interface
{.$I ..\inc\mvcbr.inc}
uses
System.SysUtils, {$ifdef FMX} FMX.Forms,{$else}  VCL.Forms,{$endif}
System.Classes, MVCBr.Interf,
MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
System.RTTI, DWeb.Controller.interf, DWeb.ViewModel, DWeb.ViewModel.Interf,
DWebView;
type
  TDWebController = class(TControllerFactory,
    IDWebController,
    IThisAs<TDWebController>, IModelAs<IDWebViewModel>)
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
    function ThisAs: TDWebController;
 /// Init após criado a instância é chamado para concluir init
    procedure init;override;
 /// ModeAs retornar a própria interface do controller
    function ModelAs: IDWebViewModel;
  end;
implementation
///  Creator para a classe Controller
Constructor TDWebController.Create;
begin
 inherited;
  ///  Inicializar as Views...
  //%view View(TDWebView.New(self));
  add(TDWebViewModel.New(self).ID('{DWeb.ViewModel}'));  ///  Inicializar os modulos
 CreateModules; //< criar os modulos persolnizados
end;
///  Finaliza o controller
Destructor TDWebController.destroy;
begin
  inherited;
end;
///  Classe Function basica para criar o controller
class function TDWebController.New(): IController;
begin
 result := new(nil,nil);
end;
///  Classe para criar o controller com View e Model criado
class function TDWebController.New(const AView: IView;
   const AModel: IModel) : IController;
var
  vm: IViewModel;
begin
  result := TDWebController.create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
      begin
        vm.View(AView).Controller( result );
      end;
end;
///  Classe para inicializar o Controller com um Modulo inicialz.
class function TDWebController.New(
   const AModel: IModel): IController;
begin
  result := new(nil,AModel);
end;
///  Cast para a interface local do controller
function TDWebController.ThisAs: TDWebController;
begin
   result := self;
end;
///  Cast para o ViewModel local do controller
function TDWebController.ModelAs: IDWebViewModel;
begin
 if count>=0 then
  supports(GetModelByType(mtViewModel), IDWebViewModel, result);
end;
///  Executar algum comando customizavel
Procedure TDWebController.DoCommand(ACommand: string;
   const AArgs:Array of TValue);
begin
    inherited;
end;
///  Evento INIT chamado apos a inicializacao do controller
procedure TDWebController.init;
var ref:TDWebView;
begin
  inherited;
 if not assigned(FView) then
 begin
   Application.CreateForm( TDWebView, ref );
   supports(ref,IView,FView);
  {$ifdef FMX}
    if Application.MainForm=nil then
      Application.RealCreateForms;
  {$endif}
 end;
 AfterInit;
end;
/// Adicionar os modulos e MODELs personalizados
Procedure TDWebController.CreateModules;
begin
   // adicionar os seus MODELs aqui
   // exemplo: add( MeuModel.new(self) );
end;
initialization
///  Inicialização automatica do Controller ao iniciar o APP
//TDWebController.New(TDWebView.New,TDWebViewModel.New)).init();
///  Registrar Interface e ClassFactory para o MVCBr
  RegisterInterfacedClass(TDWebController.ClassName,IDWebController,TDWebController);
finalization
///  Remover o Registro da Interface
  unRegisterInterfacedClass(TDWebController.ClassName);
end.
