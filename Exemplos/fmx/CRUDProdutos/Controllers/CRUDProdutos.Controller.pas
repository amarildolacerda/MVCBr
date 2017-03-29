{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 28/03/2017 22:19:45                                  //}
{//************************************************************//}
 /// <summary>
 /// O controller possui as seguintes características:
 ///   - pode possuir 1 view associado  (GetView)
 ///   - pode receber 0 ou mais Model   (GetModel<Ixxx>)
 ///   - se auto registra no application controller
 ///   - pode localizar controller externos e instanciá-los
 ///     (resolveController<I..>)
 /// </summary>
unit CRUDProdutos.Controller;
 /// <summary>
 ///    Object Factory para implementar o Controller
 /// </summary>
interface
{.$I ..\inc\mvcbr.inc}
uses
System.SysUtils, {$ifdef FMX} FMX.Forms,{$else}  VCL.Forms,{$endif}
System.Classes, MVCBr.Interf,
MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
System.RTTI, CRUDProdutos.Controller.interf, CRUDProdutos.ViewModel, CRUDProdutos.ViewModel.Interf,
CRUDProdutosView;
type
  TCRUDProdutosController = class(TControllerFactory,
    ICRUDProdutosController,
    IThisAs<TCRUDProdutosController>, IModelAs<ICRUDProdutosViewModel>)
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
    function ThisAs: TCRUDProdutosController;
 /// Init após criado a instância é chamado para concluir init
    procedure init;override;
 /// ModeAs retornar a própria interface do controller
    function ModelAs: ICRUDProdutosViewModel;
  end;
implementation
///  Creator para a classe Controller
Constructor TCRUDProdutosController.Create;
begin
 inherited;
  ///  Inicializar as Views...
  //%view View(TCRUDProdutosView.New(self));
  add(TCRUDProdutosViewModel.New(self).ID('{CRUDProdutos.ViewModel}'));  ///  Inicializar os modulos
 CreateModules; //< criar os modulos persolnizados
end;
///  Finaliza o controller
Destructor TCRUDProdutosController.destroy;
begin
  inherited;
end;
///  Classe Function basica para criar o controller
class function TCRUDProdutosController.New(): IController;
begin
 result := new(nil,nil);
end;
///  Classe para criar o controller com View e Model criado
class function TCRUDProdutosController.New(const AView: IView;
   const AModel: IModel) : IController;
var
  vm: IViewModel;
begin
  result := TCRUDProdutosController.create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
      begin
        vm.View(AView).Controller( result );
      end;
end;
///  Classe para inicializar o Controller com um Modulo inicialz.
class function TCRUDProdutosController.New(
   const AModel: IModel): IController;
begin
  result := new(nil,AModel);
end;
///  Cast para a interface local do controller
function TCRUDProdutosController.ThisAs: TCRUDProdutosController;
begin
   result := self;
end;
///  Cast para o ViewModel local do controller
function TCRUDProdutosController.ModelAs: ICRUDProdutosViewModel;
begin
 if count>=0 then
  supports(GetModelByType(mtViewModel), ICRUDProdutosViewModel, result);
end;
///  Executar algum comando customizavel
Procedure TCRUDProdutosController.DoCommand(ACommand: string;
   const AArgs:Array of TValue);
begin
    inherited;
end;
///  Evento INIT chamado apos a inicializacao do controller
procedure TCRUDProdutosController.init;
var ref:TCRUDProdutosView;
begin
  inherited;
 if not assigned(FView) then
 begin
   Application.CreateForm( TCRUDProdutosView, ref );
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
Procedure TCRUDProdutosController.CreateModules;
begin
   // adicionar os seus MODELs aqui
   // exemplo: add( MeuModel.new(self) );
end;
initialization
///  Inicialização automatica do Controller ao iniciar o APP
//TCRUDProdutosController.New(TCRUDProdutosView.New,TCRUDProdutosViewModel.New)).init();
///  Registrar Interface e ClassFactory para o MVCBr
  RegisterInterfacedClass(TCRUDProdutosController.ClassName,ICRUDProdutosController,TCRUDProdutosController);
finalization
///  Remover o Registro da Interface
  unRegisterInterfacedClass(TCRUDProdutosController.ClassName);
end.
