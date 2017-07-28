{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 18/06/2017 15:57:22                                  //}
{//************************************************************//}
unit ObserverApp.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, ObserverApp.ViewModel.Interf;
Type
///  Object Factory para o ViewModel
    TObserverAppViewModel=class(TViewModelFactory,
      IObserverAppViewModel, IViewModelAs<IObserverAppViewModel>)
    public
      function ViewModelAs:IObserverAppViewModel;
      class function new():IObserverAppViewModel;overload;
      class function new(const AController:IController):IObserverAppViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TObserverAppViewModel.ViewModelAs:IObserverAppViewModel;
begin
  result := self;
end;
class function TObserverAppViewModel.new():IObserverAppViewModel;
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
class function TObserverAppViewModel.new(const AController:IController):IObserverAppViewModel;
begin
  result := TObserverAppViewModel.create;
  result.controller(AController);
end;
procedure TObserverAppViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
