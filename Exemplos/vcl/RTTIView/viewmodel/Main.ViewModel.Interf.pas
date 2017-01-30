Unit Main.ViewModel.Interf;

interface

uses MVCBr.Interf, MVCBr.ViewModel;

Type
  IMainViewModel = interface(IViewModel)
    ['{12C7D6C2-9E87-445D-9B30-78117945B968}']
    // incluir especializações aqui
    procedure ShowCaption(ATexto: string);
  end;

Implementation

end.
