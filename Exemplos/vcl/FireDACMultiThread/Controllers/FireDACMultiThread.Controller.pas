{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 20/10/2017 06:38:14                                  //}
{//************************************************************//}

 /// <summary>
 /// O controller possui as seguintes características:
 ///   - pode possuir 1 view associado  (GetView)
 ///   - pode receber 0 ou mais Model   (GetModel<Ixxx>)
 ///   - se auto registra no application controller
 ///   - pode localizar controller externos e instanciá-los
 ///     (resolveController<I..>)
 /// </summary>
  {auth}
unit FireDACMultiThread.Controller;
 /// <summary>
 ///    Object Factory para implementar o Controller
 /// </summary>
interface
{.$I ..\inc\mvcbr.inc}
uses

System.SysUtils,{$ifdef LINUX} {$else} {$ifdef FMX} FMX.Forms,{$else}  VCL.Forms,{$endif}{$endif}
System.Classes, MVCBr.Interf,
MVCBr.Model, MVCBr.Controller, MVCBr.ApplicationController,
System.RTTI, FireDACMultiThread.Controller.interf,
FireDACMultiThreadView;

type

  TFireDACMultiThreadController = class(TControllerFactory,
    IFireDACMultiThreadController,
    IThisAs<TFireDACMultiThreadController>)
  protected
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
    function ThisAs: TFireDACMultiThreadController;
 /// Init após criado a instância é chamado para concluir init
    procedure init;override;
 /// ModeAs retornar a própria interface do controller

  end;

implementation
///  Creator para a classe Controller
Constructor TFireDACMultiThreadController.Create;
begin
 inherited;
  ///  Inicializar as Views...
  //%view View(TFireDACMultiThreadView.New(self));
end;
///  Finaliza o controller
Destructor TFireDACMultiThreadController.destroy;
begin
  inherited;
end;
///  Classe Function basica para criar o controller
class function TFireDACMultiThreadController.New(): IController;
begin
 result := new(nil,nil);
end;
///  Classe para criar o controller com View e Model criado
class function TFireDACMultiThreadController.New(const AView: IView;
   const AModel: IModel) : IController;
var
  vm: IViewModel;
begin
  result := TFireDACMultiThreadController.create as IController;
  result.View(AView).Add(AModel);
  if assigned(AModel) then
    if supports(AModel.This, IViewModel, vm) then
      begin
        vm.View(AView).Controller( result );
      end;
end;
///  Classe para inicializar o Controller com um Modulo inicialz.
class function TFireDACMultiThreadController.New(
   const AModel: IModel): IController;
begin
  result := new(nil,AModel);
end;
///  Cast para a interface local do controller
function TFireDACMultiThreadController.ThisAs: TFireDACMultiThreadController;
begin
   result := self;
end;
///  Evento INIT chamado apos a inicializacao do controller
procedure TFireDACMultiThreadController.init;
var ref:TFireDACMultiThreadView;
begin
  inherited;
 if not assigned(FView) then
 begin
   Application.CreateForm( TFireDACMultiThreadView, ref );
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
Procedure TFireDACMultiThreadController.CreateModules;
begin
   // adicionar os seus MODELs aqui
   // exemplo: add( MeuModel.new(self) );
end;

initialization
///  Inicialização automatica do Controller ao iniciar o APP
//TFireDACMultiThreadController.New(TFireDACMultiThreadView.New,TFireDACMultiThreadViewModel.New)).init();

///  Registrar Interface e ClassFactory para o MVCBr
  RegisterInterfacedClass(TFireDACMultiThreadController.ClassName,IFireDACMultiThreadController,TFireDACMultiThreadController);

finalization
///  Remover o Registro da Interface
  unRegisterInterfacedClass(TFireDACMultiThreadController.ClassName);

end.
