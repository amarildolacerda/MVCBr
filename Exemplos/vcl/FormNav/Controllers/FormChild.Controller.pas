{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 26/03/2017 11:42:00                                  //}
{//************************************************************//}
 /// <summary>
 /// O controller possui as seguintes características:
 ///   - pode possuir 1 view associado  (GetView)
 ///   - pode receber 0 ou mais Model   (GetModel<Ixxx>)
 ///   - se auto registra no application controller
 ///   - pode localizar controller externos e instanciá-los
 ///     (resolveController<I..>)
 /// </summary>
unit FormChild.Controller;
 /// <summary>
 ///    Object Factory para implementar o Controller
 /// </summary>
interface
{.$I ..\inc\mvcbr.inc}
uses
System.SysUtils, {$ifdef FMX} FMX.Forms,{$else}  VCL.Forms,{$endif}
System.Classes, MVCBr.Interf,
MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
System.RTTI, FormChild.Controller.interf,
FormChildView;
type
  TFormChildController = class(TControllerFactory,
    IFormChildController,
    IThisAs<TFormChildController>)
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
    function ThisAs: TFormChildController;
 /// Init após criado a instância é chamado para concluir init
    procedure init;override;
  end;
implementation
///  Creator para a classe Controller
Constructor TFormChildController.Create;
begin
 inherited;
  ///  Inicializar as Views...
    View(TFormChildView.New(self));
  ///  Inicializar os modulos
 CreateModules; //< criar os modulos persolnizados
end;
///  Finaliza o controller
Destructor TFormChildController.destroy;
begin
  inherited;
end;
///  Classe Function basica para criar o controller
class function TFormChildController.New(): IController;
begin
 result := new(nil,nil);
end;
///  Classe para criar o controller com View e Model criado
class function TFormChildController.New(const AView: IView;
   const AModel: IModel) : IController;
var
  vm: IViewModel;
begin
  result := TFormChildController.create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
      begin
        vm.View(AView).Controller( result );
      end;
end;
///  Classe para inicializar o Controller com um Modulo inicialz.
class function TFormChildController.New(
   const AModel: IModel): IController;
begin
  result := new(nil,AModel);
end;
///  Cast para a interface local do controller
function TFormChildController.ThisAs: TFormChildController;
begin
   result := self;
end;
///  Executar algum comando customizavel
Procedure TFormChildController.DoCommand(ACommand: string;
   const AArgs:Array of TValue);
begin
    inherited;
end;
///  Evento INIT chamado apos a inicializacao do controller
procedure TFormChildController.init;
var ref:TFormChildView;
begin
  inherited;
 if not assigned(FView) then
 begin
   Application.CreateForm( TFormChildView, ref );
   supports(ref,IView,FView);
  {$ifdef FMX}
    if Application.MainForm=nil then
      Application.RealCreateForms;
  {$endif}
 end;
 AfterInit;
end;
/// Adicionar os modulos e MODELs personalizados
Procedure TFormChildController.CreateModules;
begin
   // adicionar os seus MODELs aqui
   // exemplo: add( MeuModel.new(self) );
end;
initialization
///  Inicialização automatica do Controller ao iniciar o APP
//TFormChildController.New(TFormChildView.New,TFormChildViewModel.New)).init();
///  Registrar Interface e ClassFactory para o MVCBr
  RegisterInterfacedClass(TFormChildController.ClassName,IFormChildController,TFormChildController);
finalization
///  Remover o Registro da Interface
  unRegisterInterfacedClass(TFormChildController.ClassName);
end.
