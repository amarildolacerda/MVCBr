{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 05/05/2017 11:12:00                                  //}
{//************************************************************//}
 /// <summary>
 /// O controller possui as seguintes características:
 ///   - pode possuir 1 view associado  (GetView)
 ///   - pode receber 0 ou mais Model   (GetModel<Ixxx>)
 ///   - se auto registra no application controller
 ///   - pode localizar controller externos e instanciá-los
 ///     (resolveController<I..>)
 /// </summary>
unit NewMVCAppParameters.Controller;
 /// <summary>
 ///    Object Factory para implementar o Controller
 /// </summary>
interface
{.$I ..\inc\mvcbr.inc}
uses
System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}  VCL.Forms,{$endif}{$endif}
System.Classes, MVCBr.Interf,
MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
System.RTTI, NewMVCAppParameters.Controller.interf, NewMVCAppParameters.ViewModel, NewMVCAppParameters.ViewModel.Interf,
NewMVCAppParametersView;
type
  TNewMVCAppParametersController = class(TControllerFactory,
    INewMVCAppParametersController,
    IThisAs<TNewMVCAppParametersController>, IModelAs<INewMVCAppParametersViewModel>)
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
    function ThisAs: TNewMVCAppParametersController;
 /// Init após criado a instância é chamado para concluir init
    procedure init;override;
 /// ModeAs retornar a própria interface do controller
    function ModelAs: INewMVCAppParametersViewModel;
  end;
implementation
///  Creator para a classe Controller
Constructor TNewMVCAppParametersController.Create;
begin
 inherited;
  ///  Inicializar as Views...
  //%view View(TNewMVCAppParametersView.New(self));
  add(TNewMVCAppParametersViewModel.New(self).ID('{NewMVCAppParameters.ViewModel}'));  ///  Inicializar os modulos
 CreateModules; //< criar os modulos persolnizados
end;
///  Finaliza o controller
Destructor TNewMVCAppParametersController.destroy;
begin
  inherited;
end;
///  Classe Function basica para criar o controller
class function TNewMVCAppParametersController.New(): IController;
begin
 result := new(nil,nil);
end;
///  Classe para criar o controller com View e Model criado
class function TNewMVCAppParametersController.New(const AView: IView;
   const AModel: IModel) : IController;
var
  vm: IViewModel;
begin
  result := TNewMVCAppParametersController.create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
      begin
        vm.View(AView).Controller( result );
      end;
end;
///  Classe para inicializar o Controller com um Modulo inicialz.
class function TNewMVCAppParametersController.New(
   const AModel: IModel): IController;
begin
  result := new(nil,AModel);
end;
///  Cast para a interface local do controller
function TNewMVCAppParametersController.ThisAs: TNewMVCAppParametersController;
begin
   result := self;
end;
///  Cast para o ViewModel local do controller
function TNewMVCAppParametersController.ModelAs: INewMVCAppParametersViewModel;
begin
 if count>=0 then
  supports(GetModelByType(mtViewModel), INewMVCAppParametersViewModel, result);
end;
///  Executar algum comando customizavel
Procedure TNewMVCAppParametersController.DoCommand(ACommand: string;
   const AArgs:Array of TValue);
begin
    inherited;
end;
///  Evento INIT chamado apos a inicializacao do controller
procedure TNewMVCAppParametersController.init;
var ref:TNewMVCAppParametersView;
begin
  inherited;
 if not assigned(FView) then
 begin
   Application.CreateForm( TNewMVCAppParametersView, ref );
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
Procedure TNewMVCAppParametersController.CreateModules;
begin
   // adicionar os seus MODELs aqui
   // exemplo: add( MeuModel.new(self) );
end;
initialization
///  Inicialização automatica do Controller ao iniciar o APP
//TNewMVCAppParametersController.New(TNewMVCAppParametersView.New,TNewMVCAppParametersViewModel.New)).init();
///  Registrar Interface e ClassFactory para o MVCBr
  RegisterInterfacedClass(TNewMVCAppParametersController.ClassName,INewMVCAppParametersController,TNewMVCAppParametersController);
finalization
///  Remover o Registro da Interface
  unRegisterInterfacedClass(TNewMVCAppParametersController.ClassName);
end.
