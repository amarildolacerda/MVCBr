{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 10/02/2017 18:28:37                                  //}
{//************************************************************//}
Unit AureliosExemplo.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, AureliosExemplo.ViewModel.Interf;
Type
///  Object Factory para o ViewModel
    TAureliosExemploViewModel=class(TViewModelFactory,
      IAureliosExemploViewModel, IViewModelAs<IAureliosExemploViewModel>)
    public
      function ViewModelAs:IAureliosExemploViewModel;
      class function new():IAureliosExemploViewModel;overload;
      class function new(const AController:IController):IAureliosExemploViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TAureliosExemploViewModel.ViewModelAs:IAureliosExemploViewModel;
begin
  result := self;
end;
class function TAureliosExemploViewModel.new():IAureliosExemploViewModel;
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
class function TAureliosExemploViewModel.new(const AController:IController):IAureliosExemploViewModel;
begin
  result := TAureliosExemploViewModel.create;
  result.controller(AController);
end;
procedure TAureliosExemploViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
