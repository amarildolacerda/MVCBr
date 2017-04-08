{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 08/04/2017 10:52:08                                  //}
{//************************************************************//}
Unit TestView.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, TestView.ViewModel.Interf;
Type
///  Object Factory para o ViewModel
    TTestViewViewModel=class(TViewModelFactory,
      ITestViewViewModel, IViewModelAs<ITestViewViewModel>)
    public
      function ViewModelAs:ITestViewViewModel;
      class function new():ITestViewViewModel;overload;
      class function new(const AController:IController):ITestViewViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TTestViewViewModel.ViewModelAs:ITestViewViewModel;
begin
  result := self;
end;
class function TTestViewViewModel.new():ITestViewViewModel;
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
class function TTestViewViewModel.new(const AController:IController):ITestViewViewModel;
begin
  result := TTestViewViewModel.create;
  result.controller(AController);
end;
procedure TTestViewViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
