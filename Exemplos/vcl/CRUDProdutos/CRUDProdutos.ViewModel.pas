{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 28/03/2017 22:29:13                                  //}
{//************************************************************//}
Unit CRUDProdutos.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, CRUDProdutos.ViewModel.Interf;
Type
///  Object Factory para o ViewModel
    TCRUDProdutosViewModel=class(TViewModelFactory,
      ICRUDProdutosViewModel, IViewModelAs<ICRUDProdutosViewModel>)
    public
      function ViewModelAs:ICRUDProdutosViewModel;
      class function new():ICRUDProdutosViewModel;overload;
      class function new(const AController:IController):ICRUDProdutosViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TCRUDProdutosViewModel.ViewModelAs:ICRUDProdutosViewModel;
begin
  result := self;
end;
class function TCRUDProdutosViewModel.new():ICRUDProdutosViewModel;
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
class function TCRUDProdutosViewModel.new(const AController:IController):ICRUDProdutosViewModel;
begin
  result := TCRUDProdutosViewModel.create;
  result.controller(AController);
end;
procedure TCRUDProdutosViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
