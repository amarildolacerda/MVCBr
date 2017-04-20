{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 17/04/2017 12:17:21                                  //}
{//************************************************************//}
unit ComoEnviarMensagemParaOutraView.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, ComoEnviarMensagemParaOutraView.ViewModel.Interf;
Type
///  Object Factory para o ViewModel
    TComoEnviarMensagemParaOutraViewViewModel=class(TViewModelFactory,
      IComoEnviarMensagemParaOutraViewViewModel, IViewModelAs<IComoEnviarMensagemParaOutraViewViewModel>)
    public
      function ViewModelAs:IComoEnviarMensagemParaOutraViewViewModel;
      class function new():IComoEnviarMensagemParaOutraViewViewModel;overload;
      class function new(const AController:IController):IComoEnviarMensagemParaOutraViewViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TComoEnviarMensagemParaOutraViewViewModel.ViewModelAs:IComoEnviarMensagemParaOutraViewViewModel;
begin
  result := self;
end;
class function TComoEnviarMensagemParaOutraViewViewModel.new():IComoEnviarMensagemParaOutraViewViewModel;
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
class function TComoEnviarMensagemParaOutraViewViewModel.new(const AController:IController):IComoEnviarMensagemParaOutraViewViewModel;
begin
  result := TComoEnviarMensagemParaOutraViewViewModel.create;
  result.controller(AController);
end;
procedure TComoEnviarMensagemParaOutraViewViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
