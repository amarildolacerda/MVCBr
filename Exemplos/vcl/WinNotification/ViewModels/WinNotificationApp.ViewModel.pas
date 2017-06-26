{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 21/06/2017 18:38:16                                  //}
{//************************************************************//}
unit WinNotificationApp.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, WinNotificationApp.ViewModel.Interf;
Type
///  Object Factory para o ViewModel
    TWinNotificationAppViewModel=class(TViewModelFactory,
      IWinNotificationAppViewModel, IViewModelAs<IWinNotificationAppViewModel>)
    public
      function ViewModelAs:IWinNotificationAppViewModel;
      class function new():IWinNotificationAppViewModel;overload;
      class function new(const AController:IController):IWinNotificationAppViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TWinNotificationAppViewModel.ViewModelAs:IWinNotificationAppViewModel;
begin
  result := self;
end;
class function TWinNotificationAppViewModel.new():IWinNotificationAppViewModel;
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
class function TWinNotificationAppViewModel.new(const AController:IController):IWinNotificationAppViewModel;
begin
  result := TWinNotificationAppViewModel.create;
  result.controller(AController);
end;
procedure TWinNotificationAppViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
