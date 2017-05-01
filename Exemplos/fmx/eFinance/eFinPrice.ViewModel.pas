{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 08/04/2017 14:51:26                                  // }
{ //************************************************************// }
Unit eFinPrice.ViewModel;

interface

{ .$I ..\inc\mvcbr.inc }
uses MVCBr.Interf, MVCBr.ViewModel, eFinPrice.ViewModel.Interf;

Type
  /// Object Factory para o ViewModel
  TeFinPriceViewModel = class(TViewModelFactory, IeFinPriceViewModel,
    IViewModelAs<IeFinPriceViewModel>)
  public
    function ViewModelAs: IeFinPriceViewModel;
    class function new(): IeFinPriceViewModel; overload;
    class function new(const AController: IController)
      : IeFinPriceViewModel; overload;
    procedure AfterInit; override;
  end;

implementation

function TeFinPriceViewModel.ViewModelAs: IeFinPriceViewModel;
begin
  result := self;
end;

class function TeFinPriceViewModel.new(): IeFinPriceViewModel;
begin
  result := new(nil);
end;

/// <summary>
/// New cria uma nova instância para o ViewModel
/// </summary>
/// <param name="AController">
/// AController é o controller ao qual o ViewModel esta
/// ligado
/// </param>
class function TeFinPriceViewModel.new(const AController: IController)
  : IeFinPriceViewModel;
begin
  result := TeFinPriceViewModel.create;
  result.controller(AController);
end;

procedure TeFinPriceViewModel.AfterInit;
begin
  // evento disparado apos a definicao do Controller;
end;

end.
