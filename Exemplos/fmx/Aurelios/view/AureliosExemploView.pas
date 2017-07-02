{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 10/02/2017 18:28:37                                  //}
{//************************************************************//}
/// <summary>
///    Uma View representa a camada de apresentação ao usuário
///    deve esta associado a um controller onde ocorrerá
///    a troca de informações e comunicação com os Models
/// </summary>
unit AureliosExemploView;
interface
uses
{$IFDEF FMX}FMX.Forms, {$ELSE}VCL.Forms, {$ENDIF}
  System.SysUtils, System.Classes,MVCBr.Interf,
  MVCBr.View,MVCBr.FormView, AureliosExemplo.ViewModel.Interf ,MVCBr.Controller;
type
/// Interface para a VIEW
  IAureliosExemploView = interface(IView)
    ['{DC257422-A037-4971-AE93-7412988EF6BF}']
    // incluir especializacoes aqui
  end;
/// Object Factory que implementa a interface da VIEW
  TAureliosExemploView = class(TFormFactory {TFORM} ,IView,IThisAs<TAureliosExemploView>,
                      IAureliosExemploView,IViewAs<IAureliosExemploView>)
  private
    FViewModel : IAureliosExemploViewModel;
  protected
    function Controller(const aController: IController): IView;override;
  public
   { Public declarations }
    class function New(AController:IController):IView;
    function ViewModel(const AViewModel:IAureliosExemploViewModel):IView;
    function This: TObject;override;
    function ThisAs:TAureliosExemploView;
    function ViewAs:IAureliosExemploView;
    function ShowView(const AProc: TProc<IView>): integer;override;
    function UpdateView: IView;override;
  end;
implementation
{$R *.fmx}
function TAureliosExemploView.UpdateView:IView;
begin
  result := self;
  if assigned(FViewModel) then FViewModel.updateView(self as IView);
  {codigo para atualizar a View vai aqui...}
end;
function TAureliosExemploView.ViewAs:IAureliosExemploView;
begin
  result := self;
end;
class function TAureliosExemploView.new(AController:IController):IView;
begin
   result := TAureliosExemploView.create(nil);
   result.controller(AController);
end;
function TAureliosExemploView.Controller(const AController:IController):IView;
begin
  result := inherited Controller(AController);
end;
function TAureliosExemploView.ViewModel(const AViewModel:IAureliosExemploViewModel):IView;
begin
   result := self;
  if assigned(AViewModel) then
   FViewModel := AViewModel;
end;
function TAureliosExemploView.This:TObject;
begin
   result := inherited This;
end;
function TAureliosExemploView.ThisAs:TAureliosExemploView;
begin
   result := self;
end;
function TAureliosExemploView.ShowView(const AProc:TProc<IView>):integer;
var
  vm: IModel;
begin
  if assigned(FController) then
  begin
    vm := FController.GetModelByType(mtViewModel);
    if assigned(vm) then
      supports(vm.This,IAureliosExemploViewModel,FViewModel);
  end;
  ShowModal;
  result := ord(ModalResult);
  if assigned(AProc) then AProc(self);
end;
end.
