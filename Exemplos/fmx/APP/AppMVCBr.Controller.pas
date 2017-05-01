{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 11/02/2017 22:18:59                                  //}
{//************************************************************//}
 /// <summary>
 /// O controller possui as seguintes características:
 ///   - pode possuir 1 view associado  (GetView)
 ///   - pode receber 0 ou mais Model   (GetModel<Ixxx>)
 ///   - se auto registra no application controller
 ///   - pode localizar controller externos e instanciá-los
 ///     (resolveController<I..>)
 /// </summary>
unit AppMVCBr.Controller;
 /// <summary>
 ///    Object Factory para implementar o Controller
 /// </summary>
interface
{.$I ..\inc\mvcbr.inc}
uses
System.SysUtils, {$ifdef FMX} FMX.Forms,{$else}  VCL.Forms,{$endif}
System.Classes, MVCBr.Interf,
MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
System.RTTI, AppMVCBr.Controller.interf,
AppMVCBr.ViewModel, AppMVCBr.ViewModel.Interf,AppMVCBrView;
type
  TAppMVCBrController = class(TControllerFactory,
    IAppMVCBrController,
    IThisAs<TAppMVCBrController>, IModelAs<IAppMVCBrViewModel>)
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
    function ThisAs: TAppMVCBrController;
 /// Init após criado a instância é chamado para concluir init
    procedure init;override;
 /// ModeAs retornar a própria interface do controller
    function ModelAs: IAppMVCBrViewModel;
  end;
implementation
///  Creator para a classe Controller
Constructor TAppMVCBrController.Create;
begin
 inherited;
 ///  Inicializar as Views...
 add(TAppMVCBrViewModel.New(self).ID('{AppMVCBr.ViewModel}')); ///  Inicializar os modulos
 CreateModules; //< criar os modulos persolnizados
end;
///  Finaliza o controller
Destructor TAppMVCBrController.destroy;
begin
  inherited;
end;
///  Classe Function basica para criar o controller
class function TAppMVCBrController.New(): IController;
begin
 result := new(nil,nil);
end;
///  Classe para criar o controller com View e Model criado
class function TAppMVCBrController.New(const AView: IView;
   const AModel: IModel) : IController;
var
  vm: IViewModel;
begin
  result := TAppMVCBrController.create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
      begin
        vm.View(AView).Controller( result );
      end;
end;
///  Classe para inicializar o Controller com um Modulo inicialz.
class function TAppMVCBrController.New(
   const AModel: IModel): IController;
begin
  result := new(nil,AModel);
end;
///  Cast para a interface local do controller
function TAppMVCBrController.ThisAs: TAppMVCBrController;
begin
   result := self;
end;
///  Cast para o ViewModel local do controller
function TAppMVCBrController.ModelAs: IAppMVCBrViewModel;
begin
 if count>=0 then
  supports(GetModelByType(mtViewModel), IAppMVCBrViewModel, result);
end;
///  Executar algum comando customizavel
Procedure TAppMVCBrController.DoCommand(ACommand: string;
   const AArgs:Array of TValue);
begin
    inherited;
end;
///  Evento INIT chamado apos a inicializacao do controller
procedure TAppMVCBrController.init;
var ref:TAppMVCBrView;
begin
  inherited;
 if not assigned(FView) then
 begin
   Application.CreateForm( TAppMVCBrView, ref );
   supports(ref,IView,FView);
  {$ifdef FMX}
    if Application.MainForm=nil then
      Application.RealCreateForms;
  {$endif}
 end;
 AfterInit;
end;
/// Adicionar os modulos e MODELs personalizados
Procedure TAppMVCBrController.CreateModules;
begin
   // adicionar os seus MODELs aqui
   // exemplo: add( MeuModel.new(self) );
end;
initialization
///  Inicialização automatica do Controller ao iniciar o APP
//TAppMVCBrController.New(TAppMVCBrView.New,TAppMVCBrViewModel.New)).init();
///  Registrar Interface e ClassFactory para o MVCBr
  RegisterInterfacedClass(TAppMVCBrController.ClassName,IAppMVCBrController,TAppMVCBrController);
finalization
///  Remover o Registro da Interface
  unRegisterInterfacedClass(TAppMVCBrController.ClassName);
end.
