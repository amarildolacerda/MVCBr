{ //************************************************************// }
{ //                                                            // }
{ //         Código gerado pelo assistente                      // }
{ //                                                            // }
{ //         Projeto MVCBr                                      // }
{ //         tireideletra.com.br  / amarildo lacerda            // }
{ //************************************************************// }
{ // Data: 19/02/2017 08:49:29                                  // }
{ //************************************************************// }
/// <summary>
/// O ViewModel esta conectado diretamente com a VIEW
/// e possui um Controller ao qual esta associado
/// </summary>
Unit Editor.ViewModel.Interf;

interface

uses MVCBr.Interf, MVCBr.ViewModel;

Type
  /// Interaface para o ViewModel
  IEditorViewModel = interface(IViewModel)
    ['{C1B537D1-A592-4C49-AB14-3DE3D68737A4}']
    // incluir especializações aqui
    function IsChanged:boolean;
  end;

Implementation

end.
