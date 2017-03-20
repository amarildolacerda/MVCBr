{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 10/03/2017 21:21:54                                  // }
{ //************************************************************// }
Unit RestODataApp.ViewModel;

interface

{ .$I ..\inc\mvcbr.inc }
uses MVCBr.Interf, MVCBr.ViewModel, RestODataApp.ViewModel.Interf;

Type
  /// Object Factory para o ViewModel
  TRestODataAppViewModel = class(TViewModelFactory, IRestODataAppViewModel,
    IViewModelAs<IRestODataAppViewModel>)
  public
    function ViewModelAs: IRestODataAppViewModel;
    class function new(): IRestODataAppViewModel; overload;
    class function new(const AController: IController)
      : IRestODataAppViewModel; overload;
    procedure AfterInit; override;
  end;

implementation

function TRestODataAppViewModel.ViewModelAs: IRestODataAppViewModel;
begin
  result := self;
end;

class function TRestODataAppViewModel.new(): IRestODataAppViewModel;
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
class function TRestODataAppViewModel.new(const AController: IController)
  : IRestODataAppViewModel;
begin
  result := TRestODataAppViewModel.create;
  result.controller(AController);
end;

procedure TRestODataAppViewModel.AfterInit;
begin
  // evento disparado apos a definicao do Controller;
end;

end.
