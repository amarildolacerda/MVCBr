{//************************************************************//}
{//                                                            //}
{//         Código gerado pelo assistente                      //}
{//                                                            //}
{//         Projeto MVCBr                                      //}
{//         tireideletra.com.br  / amarildo lacerda            //}
{//************************************************************//}
{// Data: 11/02/2017 21:37:21                                  //}
{//************************************************************//}
Unit Config.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, Config.ViewModel.Interf;
Type
///  Object Factory para o ViewModel
    TConfigViewModel=class(TViewModelFactory,
      IConfigViewModel, IViewModelAs<IConfigViewModel>)
    public
      function ViewModelAs:IConfigViewModel;
      class function new():IConfigViewModel;overload;
      class function new(const AController:IController):IConfigViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TConfigViewModel.ViewModelAs:IConfigViewModel;
begin
  result := self;
end;
class function TConfigViewModel.new():IConfigViewModel;
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
class function TConfigViewModel.new(const AController:IController):IConfigViewModel;
begin
  result := TConfigViewModel.create;
  result.controller(AController);
end;
procedure TConfigViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
