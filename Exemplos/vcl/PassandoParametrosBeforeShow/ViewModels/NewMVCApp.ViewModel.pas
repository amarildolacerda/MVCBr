{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 16/05/2017 22:59:43                                  //}
{//************************************************************//}
unit NewMVCApp.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, NewMVCApp.ViewModel.Interf;
Type
///  Object Factory para o ViewModel
    TNewMVCAppViewModel=class(TViewModelFactory,
      INewMVCAppViewModel, IViewModelAs<INewMVCAppViewModel>)
    public
      function ViewModelAs:INewMVCAppViewModel;
      class function new():INewMVCAppViewModel;overload;
      class function new(const AController:IController):INewMVCAppViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TNewMVCAppViewModel.ViewModelAs:INewMVCAppViewModel;
begin
  result := self;
end;
class function TNewMVCAppViewModel.new():INewMVCAppViewModel;
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
class function TNewMVCAppViewModel.new(const AController:IController):INewMVCAppViewModel;
begin
  result := TNewMVCAppViewModel.create;
  result.controller(AController);
end;
procedure TNewMVCAppViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
