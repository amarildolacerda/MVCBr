{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 01/05/2017 15:04:55                                  //}
{//************************************************************//}
unit UsandoTLayout.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, UsandoTLayout.ViewModel.Interf;
Type
///  Object Factory para o ViewModel
    TUsandoTLayoutViewModel=class(TViewModelFactory,
      IUsandoTLayoutViewModel, IViewModelAs<IUsandoTLayoutViewModel>)
    public
      function ViewModelAs:IUsandoTLayoutViewModel;
      class function new():IUsandoTLayoutViewModel;overload;
      class function new(const AController:IController):IUsandoTLayoutViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TUsandoTLayoutViewModel.ViewModelAs:IUsandoTLayoutViewModel;
begin
  result := self;
end;
class function TUsandoTLayoutViewModel.new():IUsandoTLayoutViewModel;
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
class function TUsandoTLayoutViewModel.new(const AController:IController):IUsandoTLayoutViewModel;
begin
  result := TUsandoTLayoutViewModel.create;
  result.controller(AController);
end;
procedure TUsandoTLayoutViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
