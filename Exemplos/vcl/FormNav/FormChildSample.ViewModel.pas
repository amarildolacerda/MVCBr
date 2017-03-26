{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 26/03/2017 11:40:55                                  // }
{ //************************************************************// }
Unit FormChildSample.ViewModel;

interface

{ .$I ..\inc\mvcbr.inc }
uses MVCBr.Interf, MVCBr.ViewModel, FormChildSample.ViewModel.Interf;

Type
  /// Object Factory para o ViewModel
  TFormChildSampleViewModel = class(TViewModelFactory,
    IFormChildSampleViewModel, IViewModelAs<IFormChildSampleViewModel>)
  public
    function ViewModelAs: IFormChildSampleViewModel;
    class function new(): IFormChildSampleViewModel; overload;
    class function new(const AController: IController)
      : IFormChildSampleViewModel; overload;
    procedure AfterInit; override;
  end;

implementation

function TFormChildSampleViewModel.ViewModelAs: IFormChildSampleViewModel;
begin
  result := self;
end;

class function TFormChildSampleViewModel.new(): IFormChildSampleViewModel;
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
class function TFormChildSampleViewModel.new(const AController: IController)
  : IFormChildSampleViewModel;
begin
  result := TFormChildSampleViewModel.create;
  result.controller(AController);
end;

procedure TFormChildSampleViewModel.AfterInit;
begin
  // evento disparado apos a definicao do Controller;
end;

end.
