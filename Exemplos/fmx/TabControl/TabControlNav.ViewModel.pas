{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 19/02/2017 22:11:59                                  //}
{//************************************************************//}
Unit TabControlNav.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, TabControlNav.ViewModel.Interf;
Type
///  Object Factory para o ViewModel
    TTabControlNavViewModel=class(TViewModelFactory,
      ITabControlNavViewModel, IViewModelAs<ITabControlNavViewModel>)
    public
      function ViewModelAs:ITabControlNavViewModel;
      class function new():ITabControlNavViewModel;overload;
      class function new(const AController:IController):ITabControlNavViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TTabControlNavViewModel.ViewModelAs:ITabControlNavViewModel;
begin
  result := self;
end;
class function TTabControlNavViewModel.new():ITabControlNavViewModel;
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
class function TTabControlNavViewModel.new(const AController:IController):ITabControlNavViewModel;
begin
  result := TTabControlNavViewModel.create;
  result.controller(AController);
end;
procedure TTabControlNavViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
