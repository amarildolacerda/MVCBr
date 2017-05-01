{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br                                // }
{ //************************************************************// }
{ // Data: 02/02/2017 22:16:22                                                // }
{ //************************************************************// }
Unit Grupo.ViewModel;

interface

{ .$I ..\inc\mvcbr.inc }
uses MVCBr.Interf, MVCBr.ViewModel, Grupo.ViewModel.Interf;

Type
  TGrupoViewModel = class(TViewModelFactory, IGrupoViewModel,
    IViewModelAs<IGrupoViewModel>)
  public
    function ViewModelAs: IGrupoViewModel;
    class function new(): IGrupoViewModel; overload;
    class function new(const AController: IController)
      : IGrupoViewModel; overload;
    procedure AfterInit; override;
  end;

implementation

function TGrupoViewModel.ViewModelAs: IGrupoViewModel;
begin
  result := self;
end;

class function TGrupoViewModel.new(): IGrupoViewModel;
begin
  result := new(nil);
end;

class function TGrupoViewModel.new(const AController: IController)
  : IGrupoViewModel;
begin
  result := TGrupoViewModel.create;
  result.controller(AController);
end;

procedure TGrupoViewModel.AfterInit;
begin
  // evento disparado apos a definicao do Controller;
end;

end.
