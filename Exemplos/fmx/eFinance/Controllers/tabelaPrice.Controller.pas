{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 08/04/2017 15:02:38                                  //}
{//************************************************************//}
 /// <summary>
 /// O controller possui as seguintes características:
 ///   - pode possuir 1 view associado  (GetView)
 ///   - pode receber 0 ou mais Model   (GetModel<Ixxx>)
 ///   - se auto registra no application controller
 ///   - pode localizar controller externos e instanciá-los
 ///     (resolveController<I..>)
 /// </summary>
unit tabelaPrice.Controller;
 /// <summary>
 ///    Object Factory para implementar o Controller
 /// </summary>
interface
{.$I ..\inc\mvcbr.inc}
uses
System.SysUtils, {$ifdef FMX} FMX.Forms,{$else}  VCL.Forms,{$endif}
System.Classes, MVCBr.Interf,
MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
System.RTTI, tabelaPrice.Controller.interf,
tabelaPriceView;
type
  TtabelaPriceController = class(TControllerFactory,
    ItabelaPriceController,
    IThisAs<TtabelaPriceController>)
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
    function ThisAs: TtabelaPriceController;
 /// Init após criado a instância é chamado para concluir init
    procedure init;override;
  end;
implementation
///  Creator para a classe Controller
Constructor TtabelaPriceController.Create;
begin
 inherited;
  ///  Inicializar as Views...
    View(TtabelaPriceView.New(self));
  ///  Inicializar os modulos
 CreateModules; //< criar os modulos persolnizados
end;
///  Finaliza o controller
Destructor TtabelaPriceController.destroy;
begin
  inherited;
end;
///  Classe Function basica para criar o controller
class function TtabelaPriceController.New(): IController;
begin
 result := new(nil,nil);
end;
///  Classe para criar o controller com View e Model criado
class function TtabelaPriceController.New(const AView: IView;
   const AModel: IModel) : IController;
var
  vm: IViewModel;
begin
  result := TtabelaPriceController.create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
      begin
        vm.View(AView).Controller( result );
      end;
end;
///  Classe para inicializar o Controller com um Modulo inicialz.
class function TtabelaPriceController.New(
   const AModel: IModel): IController;
begin
  result := new(nil,AModel);
end;
///  Cast para a interface local do controller
function TtabelaPriceController.ThisAs: TtabelaPriceController;
begin
   result := self;
end;
///  Executar algum comando customizavel
Procedure TtabelaPriceController.DoCommand(ACommand: string;
   const AArgs:Array of TValue);
begin
    inherited;
end;
///  Evento INIT chamado apos a inicializacao do controller
procedure TtabelaPriceController.init;
var ref:TtabelaPriceView;
begin
  inherited;
 if not assigned(FView) then
 begin
   Application.CreateForm( TtabelaPriceView, ref );
   supports(ref,IView,FView);
  {$ifdef FMX}
    if Application.MainForm=nil then
      Application.RealCreateForms;
  {$endif}
 end;
 AfterInit;
end;
/// Adicionar os modulos e MODELs personalizados
Procedure TtabelaPriceController.CreateModules;
begin
   // adicionar os seus MODELs aqui
   // exemplo: add( MeuModel.new(self) );
end;
initialization
///  Inicialização automatica do Controller ao iniciar o APP
//TtabelaPriceController.New(TtabelaPriceView.New,TtabelaPriceViewModel.New)).init();
///  Registrar Interface e ClassFactory para o MVCBr
  RegisterInterfacedClass(TtabelaPriceController.ClassName,ItabelaPriceController,TtabelaPriceController);
finalization
///  Remover o Registro da Interface
  unRegisterInterfacedClass(TtabelaPriceController.ClassName);
end.
