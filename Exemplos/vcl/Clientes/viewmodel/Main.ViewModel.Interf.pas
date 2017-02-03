Unit Main.ViewModel.Interf;

interface

uses MVCBr.Interf, MVCBr.ViewModel;

Type
  IMainViewModel = interface(IViewModel)
    ['{B54F5314-A525-4A01-BC8A-403E8806668A}']
    // incluir especializações aqui
    Function ValidarCPF(ACPF: string): boolean;
  end;

Implementation

end.
