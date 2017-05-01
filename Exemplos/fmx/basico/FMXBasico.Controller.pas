{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 13/02/2017 22:49:36                                  //}
{//************************************************************//}
 /// <summary>
 /// O controller possui as seguintes características:
 ///   - pode possuir 1 view associado  (GetView)
 ///   - pode receber 0 ou mais Model   (GetModel<Ixxx>)
 ///   - se auto registra no application controller
 ///   - pode localizar controller externos e instanciá-los
 ///     (resolveController<I..>)
 /// </summary>
unit FMXBasico.Controller;
 /// <summary>
 ///    Object Factory para implementar o Controller
 /// </summary>
interface
{.$I ..\inc\mvcbr.inc}
uses
System.SysUtils, {$ifdef FMX} FMX.Forms,{$else}  VCL.Forms,{$endif}
System.Classes, MVCBr.Interf,
MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
System.RTTI, FMXBasico.Controller.interf,
FMXBasico.ViewModel, FMXBasico.ViewModel.Interf,FMXBasicoView;
type
  TFMXBasicoController = class(TControllerFactory,
    IFMXBasicoController,
    IThisAs<TFMXBasicoController>, IModelAs<IFMXBasicoViewModel>)
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
    function ThisAs: TFMXBasicoController;
 /// Init após criado a instância é chamado para concluir init
    procedure init;override;
 /// ModeAs retornar a própria interface do controller
    function ModelAs: IFMXBasicoViewModel;
  end;
implementation
///  Creator para a classe Controller
Constructor TFMXBasicoController.Create;
begin
 inherited;
 ///  Inicializar as Views...
 add(TFMXBasicoViewModel.New(self).ID('{FMXBasico.ViewModel}')); ///  Inicializar os modulos
 CreateModules; //< criar os modulos persolnizados
end;
///  Finaliza o controller
Destructor TFMXBasicoController.destroy;
begin
  inherited;
end;
///  Classe Function basica para criar o controller
class function TFMXBasicoController.New(): IController;
begin
 result := new(nil,nil);
end;
///  Classe para criar o controller com View e Model criado
class function TFMXBasicoController.New(const AView: IView;
   const AModel: IModel) : IController;
var
  vm: IViewModel;
begin
  result := TFMXBasicoController.create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
      begin
        vm.View(AView).Controller( result );
      end;
end;
///  Classe para inicializar o Controller com um Modulo inicialz.
class function TFMXBasicoController.New(
   const AModel: IModel): IController;
begin
  result := new(nil,AModel);
end;
///  Cast para a interface local do controller
function TFMXBasicoController.ThisAs: TFMXBasicoController;
begin
   result := self;
end;
///  Cast para o ViewModel local do controller
function TFMXBasicoController.ModelAs: IFMXBasicoViewModel;
begin
 if count>=0 then
  supports(GetModelByType(mtViewModel), IFMXBasicoViewModel, result);
end;
///  Executar algum comando customizavel
Procedure TFMXBasicoController.DoCommand(ACommand: string;
   const AArgs:Array of TValue);
begin
    inherited;
end;
///  Evento INIT chamado apos a inicializacao do controller
procedure TFMXBasicoController.init;
var ref:TFMXBasicoView;
begin
  inherited;
 if not assigned(FView) then
 begin
   Application.CreateForm( TFMXBasicoView, ref );
   supports(ref,IView,FView);
  {$ifdef FMX}
    if Application.MainForm=nil then
      Application.RealCreateForms;
  {$endif}
 end;
 AfterInit;
end;
/// Adicionar os modulos e MODELs personalizados
Procedure TFMXBasicoController.CreateModules;
begin
   // adicionar os seus MODELs aqui
   // exemplo: add( MeuModel.new(self) );
end;
initialization
///  Inicialização automatica do Controller ao iniciar o APP
//TFMXBasicoController.New(TFMXBasicoView.New,TFMXBasicoViewModel.New)).init();
///  Registrar Interface e ClassFactory para o MVCBr
  RegisterInterfacedClass(TFMXBasicoController.ClassName,IFMXBasicoController,TFMXBasicoController);
finalization
///  Remover o Registro da Interface
  unRegisterInterfacedClass(TFMXBasicoController.ClassName);
end.
