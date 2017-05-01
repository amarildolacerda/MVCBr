{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 01/05/2017 11:08:32                                  //}
{//************************************************************//}
unit WooCommerceSample.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, WooCommerceSample.ViewModel.Interf;
Type
///  Object Factory para o ViewModel
    TWooCommerceSampleViewModel=class(TViewModelFactory,
      IWooCommerceSampleViewModel, IViewModelAs<IWooCommerceSampleViewModel>)
    public
      function ViewModelAs:IWooCommerceSampleViewModel;
      class function new():IWooCommerceSampleViewModel;overload;
      class function new(const AController:IController):IWooCommerceSampleViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TWooCommerceSampleViewModel.ViewModelAs:IWooCommerceSampleViewModel;
begin
  result := self;
end;
class function TWooCommerceSampleViewModel.new():IWooCommerceSampleViewModel;
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
class function TWooCommerceSampleViewModel.new(const AController:IController):IWooCommerceSampleViewModel;
begin
  result := TWooCommerceSampleViewModel.create;
  result.controller(AController);
end;
procedure TWooCommerceSampleViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
