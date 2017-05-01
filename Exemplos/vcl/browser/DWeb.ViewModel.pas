{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 19/02/2017 19:35:38                                  //}
{//************************************************************//}
Unit DWeb.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, DWeb.ViewModel.Interf;
Type
///  Object Factory para o ViewModel
    TDWebViewModel=class(TViewModelFactory,
      IDWebViewModel, IViewModelAs<IDWebViewModel>)
    public
      function ViewModelAs:IDWebViewModel;
      class function new():IDWebViewModel;overload;
      class function new(const AController:IController):IDWebViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TDWebViewModel.ViewModelAs:IDWebViewModel;
begin
  result := self;
end;
class function TDWebViewModel.new():IDWebViewModel;
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
class function TDWebViewModel.new(const AController:IController):IDWebViewModel;
begin
  result := TDWebViewModel.create;
  result.controller(AController);
end;
procedure TDWebViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
