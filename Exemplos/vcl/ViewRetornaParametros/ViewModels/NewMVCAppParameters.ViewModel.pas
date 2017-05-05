{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 05/05/2017 11:12:00                                  //}
{//************************************************************//}
unit NewMVCAppParameters.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, NewMVCAppParameters.ViewModel.Interf;
Type
///  Object Factory para o ViewModel
    TNewMVCAppParametersViewModel=class(TViewModelFactory,
      INewMVCAppParametersViewModel, IViewModelAs<INewMVCAppParametersViewModel>)
    public
      function ViewModelAs:INewMVCAppParametersViewModel;
      class function new():INewMVCAppParametersViewModel;overload;
      class function new(const AController:IController):INewMVCAppParametersViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TNewMVCAppParametersViewModel.ViewModelAs:INewMVCAppParametersViewModel;
begin
  result := self;
end;
class function TNewMVCAppParametersViewModel.new():INewMVCAppParametersViewModel;
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
class function TNewMVCAppParametersViewModel.new(const AController:IController):INewMVCAppParametersViewModel;
begin
  result := TNewMVCAppParametersViewModel.create;
  result.controller(AController);
end;
procedure TNewMVCAppParametersViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
