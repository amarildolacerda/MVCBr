{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 13/02/2017 23:07:44                                  // }
{ //************************************************************// }
Unit AppPageControl.ViewModel;

interface

{ .$I ..\inc\mvcbr.inc }
uses MVCBr.Interf, MVCBr.ViewModel, AppPageControl.ViewModel.Interf;

Type
  /// Object Factory para o ViewModel
  TAppPageControlViewModel = class(TViewModelFactory, IAppPageControlViewModel,
    IViewModelAs<IAppPageControlViewModel>)
  protected
    FIsChanged:boolean;
    procedure AfterConstruction;override;
  public
    function ViewModelAs: IAppPageControlViewModel;
    class function new(): IAppPageControlViewModel; overload;
    class function new(const AController: IController)
      : IAppPageControlViewModel; overload;
    procedure AfterInit; override;

    //
     function CanClose:Boolean;

  end;

implementation

function TAppPageControlViewModel.ViewModelAs: IAppPageControlViewModel;
begin
  result := self;
end;

class function TAppPageControlViewModel.new(): IAppPageControlViewModel;
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
function TAppPageControlViewModel.CanClose: Boolean;
begin
   result := not FIsChanged;
end;

class function TAppPageControlViewModel.new(const AController: IController)
  : IAppPageControlViewModel;
begin
  result := TAppPageControlViewModel.create;
  result.controller(AController);
end;

procedure TAppPageControlViewModel.AfterConstruction;
begin
  inherited;
  FIsChanged := false;
end;

procedure TAppPageControlViewModel.AfterInit;
begin
  // evento disparado apos a definicao do Controller;
end;

end.
