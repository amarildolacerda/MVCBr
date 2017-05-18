{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 17/05/2017 23:20:37                                  //}
{//************************************************************//}
unit UsandoTemplate.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, UsandoTemplate.ViewModel.Interf;
Type
///  Object Factory para o ViewModel
    TUsandoTemplateViewModel=class(TViewModelFactory,
      IUsandoTemplateViewModel, IViewModelAs<IUsandoTemplateViewModel>)
    public
      function ViewModelAs:IUsandoTemplateViewModel;
      class function new():IUsandoTemplateViewModel;overload;
      class function new(const AController:IController):IUsandoTemplateViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TUsandoTemplateViewModel.ViewModelAs:IUsandoTemplateViewModel;
begin
  result := self;
end;
class function TUsandoTemplateViewModel.new():IUsandoTemplateViewModel;
begin
  result := new(nil);
end;
/// <summary>
///   New cria uma nova instância para o ViewModel
/// </summary>
/// <param name="AController">
///   AController é o controller ao qual o ViewModel esta
///   ligado
/// </param>
class function TUsandoTemplateViewModel.new(const AController:IController):IUsandoTemplateViewModel;
begin
  result := TUsandoTemplateViewModel.create;
  result.controller(AController);
end;
procedure TUsandoTemplateViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
