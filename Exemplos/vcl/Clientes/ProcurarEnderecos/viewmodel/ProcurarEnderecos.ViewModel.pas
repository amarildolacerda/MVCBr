Unit ProcurarEnderecos.ViewModel;
interface
{.$I ..\inc\mvcbr.inc}
uses MVCBr.Interf, MVCBr.ViewModel, ProcurarEnderecos.ViewModel.Interf;
Type
    TProcurarEnderecosViewModel=class(TViewModelFactory,
      IProcurarEnderecosViewModel, IViewModelAs<IProcurarEnderecosViewModel>)
    public
      function ViewModelAs:IProcurarEnderecosViewModel;
      class function new():IProcurarEnderecosViewModel;overload;
      class function new(const AController:IController):IProcurarEnderecosViewModel; overload;
      procedure AfterInit;override;
    end;
implementation
function TProcurarEnderecosViewModel.ViewModelAs:IProcurarEnderecosViewModel;
begin
  result := self;
end;
class function TProcurarEnderecosViewModel.new():IProcurarEnderecosViewModel;
begin
  result := new(nil);
end;
class function TProcurarEnderecosViewModel.new(const AController:IController):IProcurarEnderecosViewModel;
begin
  result := TProcurarEnderecosViewModel.create;
  result.controller(AController);
end;
procedure TProcurarEnderecosViewModel.AfterInit;
begin
    // evento disparado apos a definicao do Controller;
end;
end.
