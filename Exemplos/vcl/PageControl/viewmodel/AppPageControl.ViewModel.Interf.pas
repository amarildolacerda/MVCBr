{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 13/02/2017 23:07:44                                  // }
{ //************************************************************// }
/// <summary>
/// O ViewModel esta conectado diretamente com a VIEW
/// e possui um Controller ao qual esta associado
/// </summary>
Unit AppPageControl.ViewModel.Interf;

interface

uses MVCBr.Interf, MVCBr.ViewModel;

Type
  /// Interaface para o ViewModel
  IAppPageControlViewModel = interface(IViewModel)
    ['{CBE14EF2-A860-4926-96B0-F6D24F12C04E}']
    // incluir especializações aqui

    function CanClose: Boolean;
  end;

Implementation

end.
