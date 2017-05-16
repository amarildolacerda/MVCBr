{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 05/05/2017 14:43:07                                  //}
{//************************************************************//}
unit SuiteCRMSample.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, SuiteCRMSample.ViewModel.Interf;
Type
///  Object Factory para o ViewModel
    TSugarCRMSampleViewModel=class(TViewModelFactory,
      ISuiteCRMSampleViewModel, IViewModelAs<ISuiteCRMSampleViewModel>)
    public
      function ViewModelAs:ISuiteCRMSampleViewModel;
      class function new():ISuiteCRMSampleViewModel;overload;
      class function new(const AController:IController):ISuiteCRMSampleViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TSugarCRMSampleViewModel.ViewModelAs:ISuiteCRMSampleViewModel;
begin
  result := self;
end;
class function TSugarCRMSampleViewModel.new():ISuiteCRMSampleViewModel;
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
class function TSugarCRMSampleViewModel.new(const AController:IController):ISuiteCRMSampleViewModel;
begin
  result := TSugarCRMSampleViewModel.create;
  result.controller(AController);
end;
procedure TSugarCRMSampleViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
