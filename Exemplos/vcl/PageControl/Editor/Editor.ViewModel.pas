{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 19/02/2017 08:49:29                                  // }
{ //************************************************************// }
Unit Editor.ViewModel;

interface

{ .$I ..\inc\mvcbr.inc }
uses MVCBr.Interf, MVCBr.ViewModel, Editor.ViewModel.Interf;

Type
  /// Object Factory para o ViewModel
  TEditorViewModel = class(TViewModelFactory, IEditorViewModel,
    IViewModelAs<IEditorViewModel>)
  public
    function ViewModelAs: IEditorViewModel;
    class function new(): IEditorViewModel; overload;
    class function new(const AController: IController)
      : IEditorViewModel; overload;
    procedure AfterInit; override;

    // interno
    function IsChanged: boolean;

  end;

implementation

function TEditorViewModel.ViewModelAs: IEditorViewModel;
begin
  result := self;
end;

class function TEditorViewModel.new(): IEditorViewModel;
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
function TEditorViewModel.IsChanged: boolean;
begin
  result := false;
end;

class function TEditorViewModel.new(const AController: IController)
  : IEditorViewModel;
begin
  result := TEditorViewModel.create;
  result.controller(AController);
end;

procedure TEditorViewModel.AfterInit;
begin
  // evento disparado apos a definicao do Controller;
end;

end.
