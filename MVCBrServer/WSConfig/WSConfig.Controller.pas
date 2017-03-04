{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 03/03/2017 11:35:19                                  //}
{//************************************************************//}
 /// <summary>
 /// O controller possui as seguintes características:
 ///   - pode possuir 1 view associado  (GetView)
 ///   - pode receber 0 ou mais Model   (GetModel<Ixxx>)
 ///   - se auto registra no application controller
 ///   - pode localizar controller externos e instanciá-los
 ///     (resolveController<I..>)
 /// </summary>
unit WSConfig.Controller;
 /// <summary>
 ///    Object Factory para implementar o Controller
 /// </summary>
interface
{.$I ..\inc\mvcbr.inc}
uses
System.SysUtils, {$ifdef FMX} FMX.Forms,{$else}  VCL.Forms,{$endif}
System.Classes, MVCBr.Interf,
MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
System.RTTI, WSConfig.Controller.interf,
WSConfigView;
type
  TWSConfigController = class(TControllerFactory,
    IWSConfigController,
    IThisAs<TWSConfigController>)
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
    function ThisAs: TWSConfigController;
 /// Init após criado a instância é chamado para concluir init
    procedure init;override;
  end;
implementation
///  Creator para a classe Controller
Constructor TWSConfigController.Create;
begin
 inherited;
  ///  Inicializar as Views...
    View(TWSConfigView.New(self));
  ///  Inicializar os modulos
 CreateModules; //< criar os modulos persolnizados
end;
///  Finaliza o controller
Destructor TWSConfigController.destroy;
begin
  inherited;
end;
///  Classe Function basica para criar o controller
class function TWSConfigController.New(): IController;
begin
 result := new(nil,nil);
end;
///  Classe para criar o controller com View e Model criado
class function TWSConfigController.New(const AView: IView;
   const AModel: IModel) : IController;
var
  vm: IViewModel;
begin
  result := TWSConfigController.create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
      begin
        vm.View(AView).Controller( result );
      end;
end;
///  Classe para inicializar o Controller com um Modulo inicialz.
class function TWSConfigController.New(
   const AModel: IModel): IController;
begin
  result := new(nil,AModel);
end;
///  Cast para a interface local do controller
function TWSConfigController.ThisAs: TWSConfigController;
begin
   result := self;
end;
///  Executar algum comando customizavel
Procedure TWSConfigController.DoCommand(ACommand: string;
   const AArgs:Array of TValue);
begin
    inherited;
end;
///  Evento INIT chamado apos a inicializacao do controller
procedure TWSConfigController.init;
var ref:TWSConfigView;
begin
  inherited;
 if not assigned(FView) then
 begin
   Application.CreateForm( TWSConfigView, ref );
   supports(ref,IView,FView);
  {$ifdef FMX}
    if Application.MainForm=nil then
      Application.RealCreateForms;
  {$endif}
 end;
 AfterInit;
end;
/// Adicionar os modulos e MODELs personalizados
Procedure TWSConfigController.CreateModules;
begin
   // adicionar os seus MODELs aqui
   // exemplo: add( MeuModel.new(self) );
end;
initialization
///  Inicialização automatica do Controller ao iniciar o APP
//TWSConfigController.New(TWSConfigView.New,TWSConfigViewModel.New)).init();
///  Registrar Interface e ClassFactory para o MVCBr
  RegisterInterfacedClass(TWSConfigController.ClassName,IWSConfigController,TWSConfigController);
finalization
///  Remover o Registro da Interface
  unRegisterInterfacedClass(TWSConfigController.ClassName);
end.
