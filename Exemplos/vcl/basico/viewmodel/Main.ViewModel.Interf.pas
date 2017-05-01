Unit Main.ViewModel.Interf;

interface

uses MVCBr.Interf, MVCBr.ViewModel;

Type
  IMainViewModel = interface(IViewModel)
    ['{A8719567-9CE8-48DA-843F-02F36F17C870}']
    // incluir especializações aqui
    function ValidarCPF(Const ACpf: string): boolean;
  end;

Implementation

end.
